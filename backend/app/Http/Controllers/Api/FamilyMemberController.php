<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

class FamilyMemberController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $familyId = $this->requestedFamilyId($request, $user);

        $members = FamilyMember::query()
            ->with('family:id,name')
            ->when($familyId, fn (Builder $query) => $query->where('family_id', $familyId))
            ->when(! $user->hasRole(User::ROLE_SUPER_ADMIN) && ! $familyId, fn (Builder $query) => $query->where('family_id', $user->family_id))
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get()
            ->map(fn (FamilyMember $member) => $this->memberPayload($member));

        return response()->json([
            'status' => true,
            'message' => 'Family members loaded.',
            'data' => [
                'members' => $members,
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $this->validatedMemberData($request);
        $family = $this->accessibleFamily($request, (int) $data['family_id'], false);
        $familyHead = $this->familyHead($family, $data);

        $member = FamilyMember::query()->create([
            ...$this->memberFields($data),
            'family_id' => $family->id,
            'created_by' => $request->user()->id,
        ]);

        $this->connectToFamilyHead(
            $family,
            $familyHead,
            $member,
            $data['relationship_to_family_head'] ?? $data['relation_to_family_head'] ?? null,
            $request->user()
        );
        $newFamily = $this->createMarriedFamily($request, $member, $data['marital_status'] ?? null);

        return response()->json([
            'status' => true,
            'message' => 'Family member created.',
            'data' => [
                'member' => $this->memberPayload($member->load('family:id,name')),
                'family' => $newFamily ? $this->familyPayload($newFamily) : null,
            ],
        ], 201);
    }

    public function update(Request $request, FamilyMember $familyMember): JsonResponse
    {
        $this->ensureMemberAccess($request, $familyMember, true);

        $data = $this->validatedMemberData($request, $familyMember);
        $family = $this->accessibleFamily($request, (int) $data['family_id'], true);

        $familyMember->update([
            ...$this->memberFields($data),
            'family_id' => $family->id,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Family member updated.',
            'data' => [
                'member' => $this->memberPayload($familyMember->refresh()->load('family:id,name')),
            ],
        ]);
    }

    public function destroy(Request $request, FamilyMember $familyMember): JsonResponse
    {
        $this->ensureMemberAccess($request, $familyMember, true);
        $familyMember->delete();

        return response()->json([
            'status' => true,
            'message' => 'Family member deleted.',
            'data' => null,
        ]);
    }

    private function requestedFamilyId(Request $request, User $user): ?int
    {
        $familyId = $request->integer('family_id') ?: null;

        if (! $familyId) {
            return $user->hasRole(User::ROLE_SUPER_ADMIN) ? null : $user->family_id;
        }

        $this->accessibleFamily($request, $familyId, false);

        return $familyId;
    }

    private function accessibleFamily(Request $request, int $familyId, bool $write): Family
    {
        $user = $request->user();

        abort_if($write && ! $user->hasRole(User::ROLE_ADMIN, User::ROLE_SUPER_ADMIN), Response::HTTP_FORBIDDEN);

        $family = Family::query()->findOrFail($familyId);

        if (! $user->hasRole(User::ROLE_SUPER_ADMIN)) {
            abort_if($user->family_id !== $family->id, Response::HTTP_FORBIDDEN);
        }

        return $family;
    }

    private function ensureMemberAccess(Request $request, FamilyMember $member, bool $write): void
    {
        $this->accessibleFamily($request, $member->family_id, $write);
    }

    /**
     * @return array<string, mixed>
     */
    private function validatedMemberData(Request $request, ?FamilyMember $member = null): array
    {
        $this->normalizeMemberRequest($request);

        return $request->validate([
            'family_id' => ['required', 'integer', Rule::exists('families', 'id')],
            'user_id' => ['nullable', 'integer', Rule::exists('users', 'id')],
            'first_name' => ['required', 'string', 'max:255'],
            'last_name' => ['nullable', 'string', 'max:255'],
            'gender' => ['nullable', 'string', 'max:32'],
            'birth_date' => ['nullable', 'date'],
            'death_date' => ['nullable', 'date', 'after_or_equal:birth_date'],
            'photo_path' => ['nullable', 'string', 'max:2048'],
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'current_city' => ['nullable', 'string', 'max:255'],
            'current_country' => ['nullable', 'string', 'max:255'],
            'family_head_id' => [
                'nullable',
                'integer',
                Rule::exists('family_members', 'id')->where(
                    fn (Builder $query) => $query->where('family_id', $request->integer('family_id'))
                ),
            ],
            'relation_to_family_head' => ['sometimes', 'nullable', 'string', Rule::in($this->relationshipOptions())],
            'relationship_to_family_head' => ['sometimes', 'nullable', 'string', Rule::in($this->relationshipOptions())],
            'marital_status' => ['sometimes', 'nullable', 'string', Rule::in(['married', 'unmarried'])],
            'graveyard_location' => ['nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'is_living' => ['sometimes', 'boolean'],
            'is_private' => ['sometimes', 'boolean'],
        ]);
    }

    private function normalizeMemberRequest(Request $request): void
    {
        $aliases = [
            'date_of_expiry' => 'death_date',
            'expiry_date' => 'death_date',
            'family_head' => 'family_head_id',
            'selected_family_head' => 'family_head_id',
            'relation' => 'relation_to_family_head',
            'relationship_to_family_head' => 'relation_to_family_head',
            'married_status' => 'marital_status',
            'married_unmarried' => 'marital_status',
            'cemetery_location' => 'graveyard_location',
        ];

        $normalized = [];

        foreach ($aliases as $from => $to) {
            if ($request->has($from) && ! $request->has($to)) {
                $normalized[$to] = $this->blankToNull($request->input($from));
            }
        }

        if ($request->has('living_status') && ! $request->has('is_living')) {
            $normalized['is_living'] = $this->livingStatusToBoolean($request->input('living_status'));
        }

        if ($request->has('is_deceased') && ! $request->has('is_living')) {
            $normalized['is_living'] = ! $request->boolean('is_deceased');
        }

        $dateFields = ['birth_date', 'death_date'];
        foreach ($dateFields as $field) {
            $value = $this->blankToNull($normalized[$field] ?? $request->input($field));

            if (is_string($value) && preg_match('/^\d{2}-\d{2}-\d{4}$/', $value)) {
                [$day, $month, $year] = explode('-', $value);
                $normalized[$field] = "{$year}-{$month}-{$day}";
            } elseif ($value === null && $request->has($field)) {
                $normalized[$field] = null;
            }
        }

        if (
            ($request->has('family_head_id') || array_key_exists('family_head_id', $normalized))
            && (int) ($normalized['family_head_id'] ?? $request->input('family_head_id')) === 0
        ) {
            $normalized['family_head_id'] = null;
        }

        if ($normalized !== []) {
            $request->merge($normalized);
        }
    }

    private function blankToNull(mixed $value): mixed
    {
        return $value === '' ? null : $value;
    }

    private function livingStatusToBoolean(mixed $value): bool
    {
        if (is_bool($value)) {
            return $value;
        }

        $status = strtolower((string) $value);

        return ! in_array($status, ['deceased', 'dead', 'expired', 'false', '0'], true);
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    private function memberFields(array $data): array
    {
        return collect($data)->only([
            'family_id',
            'user_id',
            'first_name',
            'last_name',
            'gender',
            'birth_date',
            'death_date',
            'graveyard_location',
            'photo_path',
            'email',
            'phone',
            'current_city',
            'current_country',
            'family_head_id',
            'relation_to_family_head',
            'marital_status',
            'notes',
            'is_living',
            'is_private',
        ])->all();
    }

    /**
     * @param array<string, mixed> $data
     */
    private function familyHead(Family $family, array $data): ?FamilyMember
    {
        if (empty($data['family_head_id'])) {
            return null;
        }

        return FamilyMember::query()
            ->where('family_id', $family->id)
            ->findOrFail((int) $data['family_head_id']);
    }

    private function connectToFamilyHead(
        Family $family,
        ?FamilyMember $familyHead,
        FamilyMember $member,
        ?string $relationship,
        User $user,
    ): void {
        if (! $familyHead || ! $relationship) {
            return;
        }

        $type = $this->relationshipType($relationship);

        if (! $type || $familyHead->id === $member->id) {
            return;
        }

        [$fromMemberId, $toMemberId] = $this->relationshipDirection($familyHead, $member, $relationship);

        \App\Models\FamilyRelationship::query()->updateOrCreate(
            [
                'family_id' => $family->id,
                'from_member_id' => $fromMemberId,
                'to_member_id' => $toMemberId,
                'relationship_type' => $type,
            ],
            [
                'notes' => "Added as {$relationship} to family head {$this->memberName($familyHead)}.",
                'created_by' => $user->id,
            ],
        );
    }

    private function createMarriedFamily(Request $request, FamilyMember $member, ?string $maritalStatus): ?Family
    {
        if ($maritalStatus !== 'married') {
            return null;
        }

        $name = trim("{$member->first_name} {$member->last_name}") ?: $member->first_name;

        return Family::query()->create([
            'name' => "{$name} Family",
            'slug' => $this->uniqueFamilySlug("{$name} Family"),
            'description' => "Family branch created for married member {$name}.",
            'is_active' => true,
            'created_by' => $request->user()->id,
        ]);
    }

    private function uniqueFamilySlug(string $name): string
    {
        $base = Str::slug($name) ?: 'family';
        $slug = $base;
        $counter = 2;

        while (Family::query()->where('slug', $slug)->exists()) {
            $slug = "{$base}-{$counter}";
            $counter++;
        }

        return $slug;
    }

    /**
     * @return array<int, string>
     */
    private function relationshipOptions(): array
    {
        return [
            'father',
            'mother',
            'son',
            'daughter',
            'child',
            'husband',
            'wife',
            'spouse',
            'brother',
            'sister',
            'sibling',
            'guardian',
            'ward',
        ];
    }

    private function relationshipType(string $relationship): ?string
    {
        return match ($relationship) {
            'father', 'mother', 'son', 'daughter', 'child' => \App\Models\FamilyRelationship::TYPE_PARENT,
            'husband', 'wife', 'spouse' => \App\Models\FamilyRelationship::TYPE_SPOUSE,
            'brother', 'sister', 'sibling' => \App\Models\FamilyRelationship::TYPE_SIBLING,
            'guardian', 'ward' => \App\Models\FamilyRelationship::TYPE_GUARDIAN,
            default => null,
        };
    }

    /**
     * @return array{0: int, 1: int}
     */
    private function relationshipDirection(FamilyMember $familyHead, FamilyMember $member, string $relationship): array
    {
        if (in_array($relationship, ['father', 'mother', 'guardian'], true)) {
            return [$member->id, $familyHead->id];
        }

        return [$familyHead->id, $member->id];
    }

    private function memberName(FamilyMember $member): string
    {
        return trim("{$member->first_name} {$member->last_name}");
    }

    /**
     * @return array<string, mixed>
     */
    private function familyPayload(Family $family): array
    {
        return [
            'id' => $family->id,
            'name' => $family->name,
            'slug' => $family->slug,
            'description' => $family->description,
            'is_active' => $family->is_active,
            'members_count' => 0,
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
            'user_id' => $member->user_id,
            'first_name' => $member->first_name,
            'last_name' => $member->last_name,
            'display_name' => trim("{$member->first_name} {$member->last_name}"),
            'gender' => $member->gender,
            'birth_date' => $member->birth_date?->format('Y-m-d'),
            'death_date' => $member->death_date?->format('Y-m-d'),
            'photo_path' => $member->photo_path,
            'photo_url' => $member->photo_path ? Storage::disk('user_photos')->url($member->photo_path) : null,
            'email' => $member->email,
            'phone' => $member->phone,
            'current_city' => $member->current_city,
            'current_country' => $member->current_country,
            'family_head_id' => $member->family_head_id,
            'relation_to_family_head' => $member->relation_to_family_head,
            'marital_status' => $member->marital_status,
            'graveyard_location' => $member->graveyard_location,
            'notes' => $member->notes,
            'is_living' => $member->is_living,
            'is_private' => $member->is_private,
        ];
    }
}
