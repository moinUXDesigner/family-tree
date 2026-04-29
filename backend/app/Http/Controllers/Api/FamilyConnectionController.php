<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyConnectionRequest;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class FamilyConnectionController extends Controller
{
    private const ROOT_FIRST_NAME = 'Shaik';
    private const ROOT_LAST_NAME = 'Nanne Saheb';

    public function status(Request $request): JsonResponse
    {
        $member = FamilyMember::query()
            ->where('user_id', $request->user()->id)
            ->with('family:id,name')
            ->first();
        $family = $this->rootFamily();
        $rootMember = $this->rootMember($family, $request->user());
        $connectionRequest = FamilyConnectionRequest::query()
            ->with(['anchorMember:id,first_name,last_name', 'family:id,name'])
            ->where('user_id', $request->user()->id)
            ->first();

        return response()->json([
            'status' => true,
            'message' => 'Family connection status loaded.',
            'data' => [
                'is_connected' => (bool) $member,
                'approval_status' => $request->user()->approval_status,
                'member' => $member ? [
                    'id' => $member->id,
                    'display_name' => trim("{$member->first_name} {$member->last_name}"),
                    'family_id' => $member->family_id,
                    'family_name' => $member->family?->name,
                ] : null,
                'root_member_name' => $this->rootMemberName(),
                'root_member' => [
                    'id' => $rootMember->id,
                    'display_name' => $this->memberName($rootMember),
                ],
                'family' => [
                    'id' => $family->id,
                    'name' => $family->name,
                ],
                'anchor_members' => $this->anchorMembers($family),
                'relationships' => FamilyConnectionRequest::relationshipOptions(),
                'connection_request' => $connectionRequest ? $this->requestPayload($connectionRequest) : null,
            ],
        ]);
    }

    public function connect(Request $request): JsonResponse
    {
        $data = $request->validate([
            'anchor_member_id' => ['required', 'integer', Rule::exists('family_members', 'id')],
            'relationship_to_anchor' => ['required', 'string', Rule::in(FamilyConnectionRequest::relationshipOptions())],
            'evidence_notes' => ['nullable', 'string', 'max:2000'],
        ]);

        $user = $request->user();
        abort_if($user->familyMember()->exists(), 422, 'This account is already connected to a family member.');

        $anchorMember = FamilyMember::query()
            ->whereKey((int) $data['anchor_member_id'])
            ->firstOrFail();
        $family = $anchorMember->family;
        $nameParts = $this->nameParts($user->name);

        $connectionRequest = FamilyConnectionRequest::query()->updateOrCreate(
            ['user_id' => $user->id],
            [
                'family_id' => $family->id,
                'anchor_member_id' => $anchorMember->id,
                'claimed_member_id' => null,
                'relationship_to_anchor' => $data['relationship_to_anchor'],
                'status' => FamilyConnectionRequest::STATUS_PENDING,
                'claimed_first_name' => $nameParts[0],
                'claimed_last_name' => $nameParts[1],
                'claimed_email' => $user->email,
                'claimed_phone' => $user->phone,
                'evidence_notes' => $data['evidence_notes'] ?? null,
                'resolved_by' => null,
                'resolved_at' => null,
            ],
        );

        $user->forceFill([
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_PENDING,
        ])->save();

        $connectionRequest->load(['anchorMember:id,first_name,last_name', 'family:id,name']);

        return response()->json([
            'status' => true,
            'message' => 'Family connection request submitted for Super Admin approval.',
            'data' => [
                'connection_request' => $this->requestPayload($connectionRequest),
                'approval_status' => $user->approval_status,
            ],
        ]);
    }

    private function rootFamily(): Family
    {
        $root = FamilyMember::query()
            ->whereRaw('LOWER(first_name) = ?', [Str::lower(self::ROOT_FIRST_NAME)])
            ->whereRaw('LOWER(last_name) = ?', [Str::lower(self::ROOT_LAST_NAME)])
            ->first();

        if ($root) {
            return $root->family;
        }

        return Family::query()->firstOrCreate(
            ['slug' => 'shaik-nanne-saheb-family'],
            [
                'name' => 'Shaik Nanne Saheb Family',
                'description' => 'Family rooted at Shaik Nanne Saheb.',
                'is_active' => true,
            ],
        );
    }

    private function rootMember(Family $family, User $user): FamilyMember
    {
        return FamilyMember::query()->firstOrCreate(
            [
                'family_id' => $family->id,
                'first_name' => self::ROOT_FIRST_NAME,
                'last_name' => self::ROOT_LAST_NAME,
            ],
            [
                'gender' => 'male',
                'notes' => 'Root member for this family tree.',
                'is_living' => false,
                'is_private' => false,
                'created_by' => $user->id,
            ],
        );
    }

    private function rootMemberName(): string
    {
        return self::ROOT_FIRST_NAME.' '.self::ROOT_LAST_NAME;
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function anchorMembers(Family $family): array
    {
        return FamilyMember::query()
            ->where('family_id', $family->id)
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get()
            ->map(fn (FamilyMember $member) => [
                'id' => $member->id,
                'display_name' => $this->memberName($member),
                'is_living' => $member->is_living,
            ])
            ->values()
            ->all();
    }

    /**
     * @return array{0: string, 1: string|null}
     */
    private function nameParts(string $name): array
    {
        $parts = preg_split('/\s+/', trim($name), 2) ?: [$name];

        return [$parts[0] ?: $name, $parts[1] ?? null];
    }

    private function memberName(FamilyMember $member): string
    {
        return trim("{$member->first_name} {$member->last_name}");
    }

    /**
     * @return array<string, mixed>
     */
    private function requestPayload(FamilyConnectionRequest $request): array
    {
        return [
            'id' => $request->id,
            'family_id' => $request->family_id,
            'family_name' => $request->family?->name,
            'anchor_member_id' => $request->anchor_member_id,
            'anchor_member_name' => $request->anchorMember ? $this->memberName($request->anchorMember) : null,
            'relationship_to_anchor' => $request->relationship_to_anchor,
            'relationship_label' => Str::headline($request->relationship_to_anchor),
            'status' => $request->status,
            'evidence_notes' => $request->evidence_notes,
            'created_at' => $request->created_at?->toISOString(),
        ];
    }
}
