<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class RootFamilyController extends Controller
{
    private const FAMILY_SLUG = 'shaik-nanne-saheb-family';
    private const ROOT_FIRST_NAME = 'Shaik';
    private const ROOT_LAST_NAME = 'Nanne Saheb';

    public function show(Request $request): JsonResponse
    {
        $family = $this->rootFamily($request);
        $rootMember = $this->rootMember($family, $request);

        return response()->json([
            'status' => true,
            'message' => 'Root family loaded.',
            'data' => $this->payload($family, $rootMember),
        ]);
    }

    public function storeMember(Request $request): JsonResponse
    {
        $family = $this->rootFamily($request);
        $rootMember = $this->rootMember($family, $request);

        $data = $request->validate([
            'anchor_member_id' => ['required', 'integer', Rule::exists('family_members', 'id')],
            'relationship_to_anchor' => ['required', 'string', Rule::in(['wife', 'child'])],
            'first_name' => ['required', 'string', 'max:255'],
            'last_name' => ['nullable', 'string', 'max:255'],
            'gender' => ['nullable', 'string', 'max:32'],
            'birth_date' => ['nullable', 'date'],
            'birth_time' => ['nullable', 'date_format:H:i'],
            'death_date' => ['nullable', 'date', 'after_or_equal:birth_date'],
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'current_city' => ['nullable', 'string', 'max:255'],
            'current_country' => ['nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'is_living' => ['sometimes', 'boolean'],
            'is_private' => ['sometimes', 'boolean'],
        ]);

        $anchor = FamilyMember::query()
            ->where('family_id', $family->id)
            ->findOrFail((int) $data['anchor_member_id']);

        $member = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'] ?? null,
            'gender' => $data['gender'] ?? null,
            'birth_date' => $data['birth_date'] ?? null,
            'birth_time' => $data['birth_time'] ?? null,
            'death_date' => $data['death_date'] ?? null,
            'email' => $data['email'] ?? null,
            'phone' => $data['phone'] ?? null,
            'current_city' => $data['current_city'] ?? null,
            'current_country' => $data['current_country'] ?? null,
            'notes' => $data['notes'] ?? null,
            'is_living' => $data['is_living'] ?? true,
            'is_private' => $data['is_private'] ?? false,
            'created_by' => $request->user()->id,
        ]);

        $relationshipType = $data['relationship_to_anchor'] === 'wife'
            ? FamilyRelationship::TYPE_SPOUSE
            : FamilyRelationship::TYPE_PARENT;

        FamilyRelationship::query()->create([
            'family_id' => $family->id,
            'from_member_id' => $anchor->id,
            'to_member_id' => $member->id,
            'relationship_type' => $relationshipType,
            'notes' => $data['relationship_to_anchor'] === 'wife'
                ? 'Added as wife/spouse in the Nanne Saheb tree.'
                : 'Added as child in the Nanne Saheb tree.',
            'created_by' => $request->user()->id,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Root family member added.',
            'data' => [
                ...$this->payload($family, $rootMember),
                'member' => $this->memberPayload($member->load('family:id,name')),
            ],
        ], 201);
    }

    private function rootFamily(Request $request): Family
    {
        return Family::query()->firstOrCreate(
            ['slug' => self::FAMILY_SLUG],
            [
                'name' => 'Shaik Nanne Saheb Family',
                'description' => 'Family rooted at Shaik Nanne Saheb.',
                'is_active' => true,
                'created_by' => $request->user()->id,
            ],
        );
    }

    private function rootMember(Family $family, Request $request): FamilyMember
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
                'created_by' => $request->user()->id,
            ],
        );
    }

    /**
     * @return array<string, mixed>
     */
    private function payload(Family $family, FamilyMember $rootMember): array
    {
        $members = FamilyMember::query()
            ->with('family:id,name')
            ->where('family_id', $family->id)
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get()
            ->map(fn (FamilyMember $member) => $this->memberPayload($member));

        $relationships = FamilyRelationship::query()
            ->with(['fromMember:id,first_name,last_name', 'toMember:id,first_name,last_name'])
            ->where('family_id', $family->id)
            ->latest()
            ->get()
            ->map(fn (FamilyRelationship $relationship) => [
                'id' => $relationship->id,
                'from_member_id' => $relationship->from_member_id,
                'from_member_name' => $this->memberName($relationship->fromMember),
                'to_member_id' => $relationship->to_member_id,
                'to_member_name' => $this->memberName($relationship->toMember),
                'relationship_type' => $relationship->relationship_type,
                'relationship_label' => $relationship->relationship_type === FamilyRelationship::TYPE_SPOUSE
                    ? 'Spouse of'
                    : 'Parent of',
                'notes' => $relationship->notes,
            ]);

        return [
            'family' => [
                'id' => $family->id,
                'name' => $family->name,
                'slug' => $family->slug,
            ],
            'root_member' => $this->memberPayload($rootMember),
            'members' => $members,
            'relationships' => $relationships,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function memberPayload(FamilyMember $member): array
    {
        return [
            'id' => $member->id,
            'family_id' => $member->family_id,
            'family_name' => $member->family?->name,
            'first_name' => $member->first_name,
            'last_name' => $member->last_name,
            'display_name' => trim("{$member->first_name} {$member->last_name}"),
            'gender' => $member->gender,
            'birth_date' => $member->birth_date?->format('Y-m-d'),
            'birth_time' => $member->birth_time,
            'death_date' => $member->death_date?->format('Y-m-d'),
            'email' => $member->email,
            'phone' => $member->phone,
            'current_city' => $member->current_city,
            'current_country' => $member->current_country,
            'notes' => $member->notes,
            'is_living' => $member->is_living,
            'is_private' => $member->is_private,
        ];
    }

    private function memberName(?FamilyMember $member): ?string
    {
        if (! $member) {
            return null;
        }

        return trim("{$member->first_name} {$member->last_name}");
    }
}
