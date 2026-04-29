<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FamilyConnectionRequest;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

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
        ]);

        abort_if(! $user->hasRole(User::ROLE_USER), 422, 'Only end users require approval.');

        $connectionRequest = $user->familyConnectionRequest()
            ->with(['anchorMember', 'family'])
            ->first();

        abort_if(! $connectionRequest || ! $user->family_id, 422, 'User must submit a family connection request before approval.');

        DB::transaction(function () use ($request, $user, $connectionRequest, $data): void {
            if ($data['approval_status'] === User::APPROVAL_APPROVED) {
                $member = $this->approveConnectionRequest($request->user(), $user, $connectionRequest);

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
            'created_at' => $user->created_at?->toISOString(),
        ];
    }

    private function approveConnectionRequest(
        User $approver,
        User $user,
        FamilyConnectionRequest $connectionRequest,
    ): FamilyMember {
        $member = FamilyMember::query()->updateOrCreate(
            ['user_id' => $user->id],
            [
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
            ],
        );

        $this->connectMemberToAnchor($connectionRequest, $member, $approver);

        return $member;
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
