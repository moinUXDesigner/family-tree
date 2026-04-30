<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FamilyConnectionRequest;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class UserApprovalController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $status = $request->query('status', User::APPROVAL_PENDING);

        $users = User::query()
            ->with([
                'family:id,name',
                'familyMember:id,user_id,notes',
                'familyConnectionRequest.family:id,name',
                'familyConnectionRequest.anchorMember:id,first_name,last_name',
            ])
            ->where('role', User::ROLE_USER)
            ->whereHas('familyConnectionRequest')
            ->when($status !== 'all', fn ($query) => $query->where('approval_status', $status))
            ->latest()
            ->get()
            ->map(fn (User $user) => $this->userPayload($user));

        return response()->json([
            'status' => true,
            'message' => 'Access requests loaded.',
            'data' => [
                'users' => $users,
            ],
        ]);
    }

    public function update(Request $request, User $user): JsonResponse
    {
        $data = $request->validate([
            'approval_status' => ['required', Rule::in([
                User::APPROVAL_APPROVED,
                User::APPROVAL_REJECTED,
                User::APPROVAL_PENDING,
            ])],
            'claimed_member_id' => ['nullable', 'integer', Rule::exists('family_members', 'id')],
        ]);

        abort_if(! $user->hasRole(User::ROLE_USER), 422, 'Only end users require approval.');

        $connectionRequest = $user->familyConnectionRequest()
            ->with(['anchorMember', 'family'])
            ->first();

        abort_if(! $connectionRequest || ! $user->family_id, 422, 'User must submit a family connection request before approval.');

        DB::transaction(function () use ($request, $user, $connectionRequest, $data): void {
            if ($data['approval_status'] === User::APPROVAL_APPROVED) {
                $member = $this->approveConnectionRequest(
                    $request->user(),
                    $user,
                    $connectionRequest,
                    $data['claimed_member_id'] ?? null,
                );

                $connectionRequest->forceFill([
                    'claimed_member_id' => $member->id,
                    'status' => FamilyConnectionRequest::STATUS_APPROVED,
                    'resolved_by' => $request->user()->id,
                    'resolved_at' => now(),
                ])->save();
            }

            if ($data['approval_status'] === User::APPROVAL_REJECTED) {
                $connectionRequest->forceFill([
                    'status' => FamilyConnectionRequest::STATUS_REJECTED,
                    'resolved_by' => $request->user()->id,
                    'resolved_at' => now(),
                ])->save();
            }

            if ($data['approval_status'] === User::APPROVAL_PENDING) {
                $connectionRequest->forceFill([
                    'status' => FamilyConnectionRequest::STATUS_PENDING,
                    'resolved_by' => null,
                    'resolved_at' => null,
                ])->save();
            }

            $user->forceFill(['approval_status' => $data['approval_status']])->save();
        });

        return response()->json([
            'status' => true,
            'message' => 'Access request updated.',
            'data' => [
                'user' => $this->userPayload($user->refresh()->load([
                    'family:id,name',
                    'familyMember:id,user_id,notes',
                    'familyConnectionRequest.family:id,name',
                    'familyConnectionRequest.anchorMember:id,first_name,last_name',
                ])),
            ],
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function userPayload(User $user): array
    {
        $member = $user->familyMember ?? $user->familyMember()->first(['id', 'notes']);
        $connectionRequest = $user->familyConnectionRequest;
        $relationship = $connectionRequest?->relationship_to_anchor ?? $this->relationshipToRoot($member?->notes);

        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone' => $user->phone,
            'family_id' => $connectionRequest?->family_id ?? $user->family_id,
            'family_name' => $connectionRequest?->family?->name ?? $user->family?->name,
            'member_id' => $member?->id,
            'relationship_to_root' => $relationship,
            'relationship_label' => $relationship ? Str::headline($relationship) : null,
            'anchor_member_id' => $connectionRequest?->anchor_member_id,
            'anchor_member_name' => $connectionRequest?->anchorMember ? $this->memberName($connectionRequest->anchorMember) : null,
            'connection_request_id' => $connectionRequest?->id,
            'connection_request_status' => $connectionRequest?->status,
            'evidence_notes' => $connectionRequest?->evidence_notes,
            'approval_status' => $user->approval_status,
            'suggested_member_id' => $connectionRequest
                ? $this->suggestedExistingMember($connectionRequest, $user)?->id
                : null,
            'claimable_members' => $connectionRequest
                ? $this->claimableMemberOptions($connectionRequest, $user)
                : [],
            'created_at' => $user->created_at?->toISOString(),
        ];
    }

    private function approveConnectionRequest(
        User $approver,
        User $user,
        FamilyConnectionRequest $connectionRequest,
        ?int $claimedMemberId = null,
    ): FamilyMember {
        $member = $user->familyMember()->first();

        if (! $member) {
            $member = $claimedMemberId
                ? $this->claimableMember($connectionRequest, $user, $claimedMemberId)
                : $this->suggestedExistingMember($connectionRequest, $user);
        }

        if ($member) {
            $member->forceFill($this->existingMemberApprovalFields($member, $user, $connectionRequest, $approver))->save();
        } else {
            $member = FamilyMember::query()->create([
                'user_id' => $user->id,
                'family_id' => $connectionRequest->family_id,
                'first_name' => $connectionRequest->claimed_first_name,
                'last_name' => $connectionRequest->claimed_last_name,
                'email' => $connectionRequest->claimed_email,
                'phone' => $connectionRequest->claimed_phone,
                'family_head_id' => $connectionRequest->anchor_member_id,
                'relation_to_family_head' => $connectionRequest->relationship_to_anchor,
                'notes' => "Approved connection as {$connectionRequest->relationship_to_anchor} of {$this->memberName($connectionRequest->anchorMember)}.",
                'is_living' => true,
                'is_private' => false,
                'created_by' => $approver->id,
            ]);
        }

        $this->connectMemberToAnchor($connectionRequest, $member, $approver);

        return $member;
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function claimableMemberOptions(FamilyConnectionRequest $connectionRequest, User $user): array
    {
        return $this->claimableMembersQuery($connectionRequest, $user)
            ->get()
            ->map(fn (FamilyMember $member) => [
                'id' => $member->id,
                'display_name' => $this->memberName($member),
                'email' => $member->email,
                'phone' => $member->phone,
                'relationship_to_anchor' => $member->relation_to_family_head,
                'family_head_id' => $member->family_head_id,
                'match_score' => $this->memberMatchScore($member, $connectionRequest),
            ])
            ->sortByDesc('match_score')
            ->values()
            ->all();
    }

    private function suggestedExistingMember(FamilyConnectionRequest $connectionRequest, User $user): ?FamilyMember
    {
        return $this->claimableMembersQuery($connectionRequest, $user)
            ->get()
            ->map(fn (FamilyMember $member) => [
                'member' => $member,
                'score' => $this->memberMatchScore($member, $connectionRequest),
                'relationship_matches' => $this->memberRelationshipMatches($member, $connectionRequest),
            ])
            ->filter(fn (array $match) => $match['relationship_matches'] && $match['score'] >= 8)
            ->sortByDesc('score')
            ->pluck('member')
            ->first();
    }

    private function claimableMember(FamilyConnectionRequest $connectionRequest, User $user, int $memberId): FamilyMember
    {
        $member = $this->claimableMembersQuery($connectionRequest, $user)
            ->whereKey($memberId)
            ->first();

        if (! $member) {
            throw ValidationException::withMessages([
                'claimed_member_id' => ['Select an unlinked member from the same family.'],
            ]);
        }

        return $member;
    }

    private function claimableMembersQuery(FamilyConnectionRequest $connectionRequest, User $user): Builder
    {
        return FamilyMember::query()
            ->where('family_id', $connectionRequest->family_id)
            ->whereKeyNot($connectionRequest->anchor_member_id)
            ->where(function (Builder $query) use ($user): void {
                $query->whereNull('user_id')->orWhere('user_id', $user->id);
            })
            ->orderBy('first_name')
            ->orderBy('last_name');
    }

    private function memberMatchScore(FamilyMember $member, FamilyConnectionRequest $connectionRequest): int
    {
        $score = 0;

        if ($this->memberRelationshipMatches($member, $connectionRequest)) {
            $score += 4;
        }

        if ($this->normalizeText($this->memberName($member)) === $this->normalizeText($this->claimedMemberName($connectionRequest))) {
            $score += 4;
        }

        if ($member->first_name && $this->normalizeText($member->first_name) === $this->normalizeText($connectionRequest->claimed_first_name)) {
            $score += 2;
        }

        if ($member->last_name && $this->normalizeText($member->last_name) === $this->normalizeText((string) $connectionRequest->claimed_last_name)) {
            $score += 2;
        }

        if ($member->email && $connectionRequest->claimed_email && Str::lower($member->email) === Str::lower($connectionRequest->claimed_email)) {
            $score += 5;
        }

        if ($this->normalizePhone($member->phone) && $this->normalizePhone($member->phone) === $this->normalizePhone($connectionRequest->claimed_phone)) {
            $score += 4;
        }

        return $score;
    }

    private function memberRelationshipMatches(FamilyMember $member, FamilyConnectionRequest $connectionRequest): bool
    {
        if (
            (int) $member->family_head_id === (int) $connectionRequest->anchor_member_id
            && $this->sameRelationshipGroup((string) $member->relation_to_family_head, $connectionRequest->relationship_to_anchor)
        ) {
            return true;
        }

        $type = $this->relationshipType($connectionRequest->relationship_to_anchor);

        if (! $type) {
            return false;
        }

        [$fromMemberId, $toMemberId] = $this->relationshipDirection(
            $connectionRequest->anchor_member_id,
            $member->id,
            $connectionRequest->relationship_to_anchor,
        );

        return FamilyRelationship::query()
            ->where('family_id', $connectionRequest->family_id)
            ->where('from_member_id', $fromMemberId)
            ->where('to_member_id', $toMemberId)
            ->where('relationship_type', $type)
            ->exists();
    }

    /**
     * @return array<string, mixed>
     */
    private function existingMemberApprovalFields(
        FamilyMember $member,
        User $user,
        FamilyConnectionRequest $connectionRequest,
        User $approver,
    ): array {
        return [
            'user_id' => $user->id,
            'email' => $member->email ?: $connectionRequest->claimed_email,
            'phone' => $member->phone ?: $connectionRequest->claimed_phone,
            'family_head_id' => $member->family_head_id ?: $connectionRequest->anchor_member_id,
            'relation_to_family_head' => $member->relation_to_family_head ?: $connectionRequest->relationship_to_anchor,
            'notes' => $member->notes ?: "Approved connection as {$connectionRequest->relationship_to_anchor} of {$this->memberName($connectionRequest->anchorMember)}.",
            'created_by' => $member->created_by ?: $approver->id,
        ];
    }

    private function sameRelationshipGroup(string $first, string $second): bool
    {
        return $this->relationshipType($first) === $this->relationshipType($second);
    }

    private function claimedMemberName(FamilyConnectionRequest $connectionRequest): string
    {
        return trim("{$connectionRequest->claimed_first_name} {$connectionRequest->claimed_last_name}");
    }

    private function normalizeText(?string $value): string
    {
        return Str::of((string) $value)->lower()->squish()->toString();
    }

    private function normalizePhone(?string $value): string
    {
        return preg_replace('/\D+/', '', (string) $value) ?? '';
    }

    private function connectMemberToAnchor(
        FamilyConnectionRequest $connectionRequest,
        FamilyMember $member,
        User $approver,
    ): void {
        $type = $this->relationshipType($connectionRequest->relationship_to_anchor);

        if (! $type || $member->id === $connectionRequest->anchor_member_id) {
            return;
        }

        [$fromMemberId, $toMemberId] = $this->relationshipDirection(
            $connectionRequest->anchor_member_id,
            $member->id,
            $connectionRequest->relationship_to_anchor,
        );

        FamilyRelationship::query()->updateOrCreate(
            [
                'family_id' => $connectionRequest->family_id,
                'from_member_id' => $fromMemberId,
                'to_member_id' => $toMemberId,
                'relationship_type' => $type,
            ],
            [
                'notes' => "Approved user claim: {$member->first_name} is {$connectionRequest->relationship_to_anchor} of {$this->memberName($connectionRequest->anchorMember)}.",
                'created_by' => $approver->id,
            ],
        );
    }

    /**
     * @return array{0: int, 1: int}
     */
    private function relationshipDirection(int $anchorMemberId, int $memberId, string $relationship): array
    {
        if (in_array($relationship, ['parent', 'father', 'mother'], true)) {
            return [$memberId, $anchorMemberId];
        }

        return [$anchorMemberId, $memberId];
    }

    private function relationshipType(string $relationship): ?string
    {
        return match ($relationship) {
            'child', 'son', 'daughter', 'parent', 'father', 'mother' => FamilyRelationship::TYPE_PARENT,
            'spouse', 'wife', 'husband' => FamilyRelationship::TYPE_SPOUSE,
            'sibling', 'brother', 'sister' => FamilyRelationship::TYPE_SIBLING,
            default => null,
        };
    }

    private function memberName(?FamilyMember $member): string
    {
        if (! $member) {
            return 'selected family member';
        }

        return trim("{$member->first_name} {$member->last_name}");
    }

    private function relationshipToRoot(?string $notes): ?string
    {
        if (! $notes || ! preg_match('/\bas\s+(.+?)\.$/i', $notes, $matches)) {
            return null;
        }

        return $matches[1];
    }
}
