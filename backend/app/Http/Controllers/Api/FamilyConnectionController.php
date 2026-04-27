<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class FamilyConnectionController extends Controller
{
    private const ROOT_FIRST_NAME = 'Shaik';
    private const ROOT_LAST_NAME = 'Nanne Saheb';

    /**
     * @var array<int, string>
     */
    private const RELATIONSHIPS = [
        'grandfather',
        'grandmother',
        'father',
        'mother',
        'son',
        'daughter',
        'child',
        'grandson',
        'granddaughter',
        'grandchild',
        'great grandson',
        'great granddaughter',
        'great grandchild',
        'husband',
        'wife',
        'spouse',
        'brother',
        'sister',
        'sibling',
        'uncle',
        'aunt',
        'nephew',
        'niece',
        'cousin',
        'guardian',
        'ward',
        'relative',
    ];

    public function status(Request $request): JsonResponse
    {
        $member = FamilyMember::query()
            ->where('user_id', $request->user()->id)
            ->with('family:id,name')
            ->first();

        return response()->json([
            'status' => true,
            'message' => 'Family connection status loaded.',
            'data' => [
                'is_connected' => (bool) $member,
                'member' => $member ? [
                    'id' => $member->id,
                    'display_name' => trim("{$member->first_name} {$member->last_name}"),
                    'family_id' => $member->family_id,
                    'family_name' => $member->family?->name,
                ] : null,
                'root_member_name' => $this->rootMemberName(),
                'relationships' => self::RELATIONSHIPS,
            ],
        ]);
    }

    public function connect(Request $request): JsonResponse
    {
        $data = $request->validate([
            'connection_type' => ['required', 'string', Rule::in(['root_member', 'family_id'])],
            'family_id' => ['required_if:connection_type,family_id', 'nullable', 'integer', Rule::exists('families', 'id')],
            'relationship_to_root' => ['required', 'string', Rule::in(self::RELATIONSHIPS)],
        ]);

        $user = $request->user();
        $family = $data['connection_type'] === 'family_id'
            ? Family::query()->findOrFail((int) $data['family_id'])
            : $this->rootFamily();

        $rootMember = $this->rootMember($family, $user);

        $user->forceFill(['family_id' => $family->id])->save();

        $member = $this->linkedMember($user, $family, $data['relationship_to_root']);
        $this->connectMemberToRoot($family, $rootMember, $member, $data['relationship_to_root'], $user);

        return response()->json([
            'status' => true,
            'message' => 'Family connection saved.',
            'data' => [
                'family' => [
                    'id' => $family->id,
                    'name' => $family->name,
                ],
                'member' => [
                    'id' => $member->id,
                    'display_name' => trim("{$member->first_name} {$member->last_name}"),
                    'family_id' => $member->family_id,
                ],
                'root_member' => [
                    'id' => $rootMember->id,
                    'display_name' => $this->rootMemberName(),
                ],
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

    private function linkedMember(User $user, Family $family, string $relationship): FamilyMember
    {
        $nameParts = preg_split('/\s+/', trim($user->name), 2) ?: [$user->name];
        $firstName = $nameParts[0] ?: $user->name;
        $lastName = $nameParts[1] ?? null;

        return FamilyMember::query()->updateOrCreate(
            ['user_id' => $user->id],
            [
                'family_id' => $family->id,
                'first_name' => $firstName,
                'last_name' => $lastName,
                'email' => $user->email,
                'notes' => "Connected to {$this->rootMemberName()} as {$relationship}.",
                'is_living' => true,
                'is_private' => false,
                'created_by' => $user->id,
            ],
        );
    }

    private function connectMemberToRoot(
        Family $family,
        FamilyMember $rootMember,
        FamilyMember $member,
        string $relationship,
        User $user,
    ): void {
        $type = $this->relationshipType($relationship);

        if (! $type || $rootMember->id === $member->id) {
            return;
        }

        [$fromMemberId, $toMemberId] = $this->relationshipDirection($rootMember, $member, $relationship);

        FamilyRelationship::query()->updateOrCreate(
            [
                'family_id' => $family->id,
                'from_member_id' => $fromMemberId,
                'to_member_id' => $toMemberId,
                'relationship_type' => $type,
            ],
            [
                'notes' => "User selected relationship to root: {$relationship}.",
                'created_by' => $user->id,
            ],
        );
    }

    /**
     * @return array{0: int, 1: int}
     */
    private function relationshipDirection(FamilyMember $rootMember, FamilyMember $member, string $relationship): array
    {
        if (in_array($relationship, ['father', 'mother', 'grandfather', 'grandmother'], true)) {
            return [$member->id, $rootMember->id];
        }

        return [$rootMember->id, $member->id];
    }

    private function relationshipType(string $relationship): ?string
    {
        return match ($relationship) {
            'husband', 'wife', 'spouse' => FamilyRelationship::TYPE_SPOUSE,
            'brother', 'sister', 'sibling', 'cousin' => FamilyRelationship::TYPE_SIBLING,
            'guardian' => FamilyRelationship::TYPE_GUARDIAN,
            'father', 'mother', 'son', 'daughter', 'child',
            'grandfather', 'grandmother', 'grandson', 'granddaughter', 'grandchild',
            'great grandson', 'great granddaughter', 'great grandchild' => FamilyRelationship::TYPE_PARENT,
            default => null,
        };
    }

    private function rootMemberName(): string
    {
        return self::ROOT_FIRST_NAME.' '.self::ROOT_LAST_NAME;
    }
}
