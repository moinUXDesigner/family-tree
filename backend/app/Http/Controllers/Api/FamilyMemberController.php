<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\Household;
use App\Models\HouseholdMember;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Query\Builder as QueryBuilder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Support\Collection;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response;

class FamilyMemberController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $familyId = $this->requestedFamilyId($request, $user);
        $relations = [
            'creator:id,name,email',
            'family:id,name',
            'familyHead:id,first_name,last_name,marital_status',
            'user:id,name,email',
        ];

        $members = FamilyMember::query()
            ->with($relations)
            ->when($familyId, fn (Builder $query) => $query->where('family_id', $familyId))
            ->when(! $user->hasRole(User::ROLE_SUPER_ADMIN) && ! $familyId, fn (Builder $query) => $query->where('family_id', $user->family_id))
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get();

        if ($familyId && $members->isEmpty()) {
            $members = $this->legacyBranchMembers($request, $familyId, $relations);
        }

        return response()->json([
            'status' => true,
            'message' => 'Family members loaded.',
            'data' => [
                'members' => $members->map(fn (FamilyMember $member) => $this->memberPayload($member)),
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $data = $this->validatedMemberData($request);
            $uploadedPhotoPath = $this->persistPhotoUpload($request);
            if ($uploadedPhotoPath) {
                $data['photo_path'] = $uploadedPhotoPath;
            }
            $family = $this->accessibleFamily($request, (int) $data['family_id'], false);
            $this->ensureUserCanAddMemberType($request->user(), $data['add_member_type'] ?? null);
            $addMemberType = $data['add_member_type'] ?? null;

            [$member, $household] = DB::transaction(function () use ($request, $data, $family, $addMemberType): array {
                return match ($addMemberType) {
                    'spouse' => $this->createSpouseMember($family, $data, $request->user()),
                    'child' => $this->createChildMember($family, $data, $request->user()),
                    'parent' => $this->createParentMember($family, $data, $request->user()),
                    'sibling' => $this->createSiblingMember($family, $data, $request->user()),
                    'existing_to_household' => $this->attachExistingMemberToHousehold($family, $data, $request->user()),
                    default => $this->createLegacyMember($family, $data, $request->user()),
                };
            });

            return response()->json([
                'status' => true,
                'message' => 'Family member created.',
                'data' => [
                    'member' => $this->memberPayload($member->load([
                        'creator:id,name,email',
                        'family:id,name',
                        'familyHead:id,first_name,last_name,marital_status',
                        'user:id,name,email',
                    ])),
                    'family' => null,
                    'household' => $household ? $this->householdPayload($household) : null,
                ],
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $exception) {
            throw $exception;
        } catch (\Throwable $exception) {
            return $this->memberCreationFailure($request, $exception);
        }
    }

    public function update(Request $request, FamilyMember $familyMember): JsonResponse
    {
        $user = $request->user();
        $isSelfEditableMember = $user->hasRole(User::ROLE_USER)
            && (
                ($familyMember->user_id && (int) $familyMember->user_id === (int) $user->id)
                || (
                    $familyMember->email
                    && $user->email
                    && Str::lower((string) $familyMember->email) === Str::lower((string) $user->email)
                )
            );

        if (! $isSelfEditableMember) {
            $this->ensureMemberAccess($request, $familyMember, true);
        } else {
            $this->ensureMemberAccess($request, $familyMember, false);
        }

        $data = $this->validatedMemberData($request, $familyMember);
        $uploadedPhotoPath = $this->persistPhotoUpload($request, $familyMember);
        if ($uploadedPhotoPath) {
            $data['photo_path'] = $uploadedPhotoPath;
        }

        if ($isSelfEditableMember) {
            $familyMember->update($this->selfEditableMemberFields($data));
        } else {
            $family = $this->accessibleFamily($request, (int) $data['family_id'], true);
            $familyMember->update([
                ...$this->memberFields($data),
                'family_id' => $family->id,
            ]);
        }

        return response()->json([
            'status' => true,
            'message' => 'Family member updated.',
            'data' => [
                'member' => $this->memberPayload($familyMember->refresh()->load([
                    'creator:id,name,email',
                    'family:id,name',
                    'familyHead:id,first_name,last_name,marital_status',
                    'user:id,name,email',
                ])),
                'family' => null,
            ],
        ]);
    }

    public function updatePhoto(Request $request, FamilyMember $familyMember): JsonResponse
    {
        $this->ensureMemberAccess($request, $familyMember, false);

        $request->validate([
            'photo' => ['required', 'image', 'max:5120'],
        ]);

        $uploadedPhotoPath = $this->persistPhotoUpload($request, $familyMember);

        if (! $uploadedPhotoPath) {
            throw ValidationException::withMessages([
                'photo' => ['Uploaded photo is invalid. Please try again.'],
            ]);
        }

        $familyMember->update([
            'photo_path' => $uploadedPhotoPath,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Family member photo updated.',
            'data' => [
                'member' => $this->memberPayload($familyMember->refresh()->load([
                    'creator:id,name,email',
                    'family:id,name',
                    'familyHead:id,first_name,last_name,marital_status',
                    'user:id,name,email',
                ])),
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
            abort_if(
                $user->family_id !== $family->id && ! $this->canAccessCanonicalFamilyFromLegacyBranch($request, $family),
                Response::HTTP_FORBIDDEN
            );
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
            'add_member_type' => ['sometimes', 'nullable', 'string', Rule::in(['spouse', 'child', 'parent', 'sibling', 'existing_to_household'])],
            'first_name' => ['required_unless:add_member_type,existing_to_household', 'nullable', 'string', 'max:255'],
            'last_name' => ['nullable', 'string', 'max:255'],
            'gender' => ['nullable', 'string', 'max:32'],
            'birth_date' => ['nullable', 'date'],
            'birth_time' => ['nullable', 'date_format:H:i'],
            'death_date' => ['nullable', 'date', 'after_or_equal:birth_date'],
            'photo' => ['nullable', 'image', 'max:5120'],
            'photo_path' => ['nullable', 'string', 'max:2048'],
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'current_city' => ['nullable', 'string', 'max:255'],
            'current_country' => ['nullable', 'string', 'max:255'],
            'family_head_id' => [
                'nullable',
                'integer',
                Rule::exists('family_members', 'id')->where(
                    fn (QueryBuilder $query) => $query->where('family_id', $request->integer('family_id'))
                ),
            ],
            'existing_person_id' => [
                'nullable',
                'integer',
                Rule::exists('family_members', 'id')->where(
                    fn (QueryBuilder $query) => $query->where('family_id', $request->integer('family_id'))
                ),
            ],
            'household_id' => [
                'nullable',
                'integer',
                Rule::exists('households', 'id')->where(
                    fn (QueryBuilder $query) => $query->where('family_id', $request->integer('family_id'))
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
            'member_type' => 'add_member_type',
            'existing_member_id' => 'existing_person_id',
            'selected_person_id' => 'existing_person_id',
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

        if ($request->has('birth_time')) {
            $normalized['birth_time'] = $this->blankToNull($request->input('birth_time'));
        }

        foreach (['family_head_id', 'existing_person_id', 'household_id'] as $integerField) {
            if (
                ($request->has($integerField) || array_key_exists($integerField, $normalized))
                && (int) ($normalized[$integerField] ?? $request->input($integerField)) === 0
            ) {
                $normalized[$integerField] = null;
            }
        }

        $this->normalizeLegacyBranchFamilySelection($request, $normalized);

        if ($normalized !== []) {
            $request->merge($normalized);
        }
    }

    /**
     * @param array<string, mixed> $normalized
     */
    private function normalizeLegacyBranchFamilySelection(Request $request, array &$normalized): void
    {
        $selectedFamilyId = (int) ($normalized['family_id'] ?? $request->input('family_id'));

        if ($selectedFamilyId <= 0) {
            return;
        }

        $selectedFamily = Family::query()->find($selectedFamilyId);

        if (! $selectedFamily) {
            return;
        }

        $memberReferenceId = (int) (
            $normalized['existing_person_id']
            ?? $request->input('existing_person_id')
            ?? $normalized['family_head_id']
            ?? $request->input('family_head_id')
        );

        if ($memberReferenceId > 0) {
            $member = FamilyMember::query()->find($memberReferenceId);

            if ($member && $member->family_id !== $selectedFamily->id && $this->legacyBranchFamilyContainsMember($selectedFamily, $member)) {
                $normalized['_selected_family_id'] = $selectedFamily->id;
                $normalized['family_id'] = $member->family_id;
            }

            return;
        }

        $householdId = (int) ($normalized['household_id'] ?? $request->input('household_id'));

        if ($householdId > 0) {
            $household = Household::query()->with(['primaryPerson', 'spousePerson'])->find($householdId);
            $primaryPerson = $household?->primaryPerson;

            if ($household && $primaryPerson && $household->family_id !== $selectedFamily->id && $this->legacyBranchFamilyContainsMember($selectedFamily, $primaryPerson)) {
                $normalized['_selected_family_id'] = $selectedFamily->id;
                $normalized['family_id'] = $household->family_id;
            }
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
            'birth_time',
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

    private function memberCreationFailure(Request $request, \Throwable $exception): JsonResponse
    {
        $reference = 'member-create-'.Str::lower(Str::random(8));
        $user = $request->user();

        Log::error('Family member creation failed.', [
            'reference' => $reference,
            'user_id' => $user?->id,
            'family_id' => $request->input('family_id'),
            'family_head_id' => $request->input('family_head_id'),
            'relationship' => $request->input('relation_to_family_head') ?? $request->input('relationship_to_family_head'),
            'marital_status' => $request->input('marital_status'),
            'exception' => $exception,
        ]);

        $message = "Unable to add family member. Reference: {$reference}";

        if ($user?->hasRole(User::ROLE_SUPER_ADMIN)) {
            $message .= " Detail: {$exception->getMessage()}";
        }

        return response()->json([
            'status' => false,
            'message' => $message,
            'data' => null,
        ], Response::HTTP_INTERNAL_SERVER_ERROR);
    }

    private function ensureUserCanAddMemberType(User $user, ?string $addMemberType): void
    {
        if (! $user->hasRole(User::ROLE_USER)) {
            return;
        }

        if (! in_array($addMemberType, ['spouse', 'child', 'parent', 'sibling'], true)) {
            throw ValidationException::withMessages([
                'add_member_type' => ['End users can only add spouse, child, parent, or sibling relationships.'],
            ]);
        }
    }

    /**
     * @param array<int, string> $relations
     * @return Collection<int, FamilyMember>
     */
    private function legacyBranchMembers(Request $request, int $familyId, array $relations): Collection
    {
        $family = Family::query()->find($familyId);

        if (! $family) {
            return collect();
        }

        $head = $this->legacyBranchHead($request, $family);

        if (! $head) {
            return collect();
        }

        $memberIds = $this->legacyBranchMemberIds($head);

        if ($memberIds->isEmpty()) {
            return collect();
        }

        return FamilyMember::query()
            ->with($relations)
            ->whereIn('id', $memberIds)
            ->orderByRaw('id = ? desc', [$head->id])
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get();
    }

    /**
     * @return Collection<int, int>
     */
    private function legacyBranchMemberIds(FamilyMember $head): Collection
    {
        $spouseIds = FamilyRelationship::query()
            ->where('family_id', $head->family_id)
            ->where('relationship_type', FamilyRelationship::TYPE_SPOUSE)
            ->where(function (Builder $query) use ($head): void {
                $query->where('from_member_id', $head->id)->orWhere('to_member_id', $head->id);
            })
            ->get()
            ->flatMap(fn (FamilyRelationship $relationship) => [
                $relationship->from_member_id,
                $relationship->to_member_id,
            ])
            ->reject(fn (int $memberId): bool => $memberId === $head->id);

        $parentIds = collect([$head->id])->merge($spouseIds)->unique()->values();

        $childIds = FamilyRelationship::query()
            ->where('family_id', $head->family_id)
            ->where('relationship_type', FamilyRelationship::TYPE_PARENT)
            ->whereIn('from_member_id', $parentIds)
            ->pluck('to_member_id');

        $legacyLinkedIds = FamilyMember::query()
            ->where('family_id', $head->family_id)
            ->where('family_head_id', $head->id)
            ->whereIn('relation_to_family_head', ['child', 'son', 'daughter', 'spouse', 'wife', 'husband'])
            ->pluck('id');

        return collect([$head->id])
            ->merge($spouseIds)
            ->merge($childIds)
            ->merge($legacyLinkedIds)
            ->unique()
            ->values();
    }

    private function legacyBranchHead(Request $request, Family $family): ?FamilyMember
    {
        return FamilyMember::query()
            ->get(['id', 'family_id', 'first_name', 'last_name'])
            ->first(fn (FamilyMember $member): bool => $this->legacyBranchFamilyMatchesMember($family, $member));
    }

    private function legacyBranchFamilyContainsMember(Family $family, FamilyMember $member): bool
    {
        $head = $this->legacyBranchHeadForFamily($family);

        if (! $head || $head->family_id !== $member->family_id) {
            return false;
        }

        if ($head->id === $member->id) {
            return true;
        }

        $memberIds = $this->legacyBranchMemberIds($head);

        return $memberIds->contains($member->id);
    }

    private function legacyBranchHeadForFamily(Family $family): ?FamilyMember
    {
        return FamilyMember::query()
            ->get(['id', 'family_id', 'first_name', 'last_name'])
            ->first(fn (FamilyMember $member): bool => $this->legacyBranchFamilyMatchesMember($family, $member));
    }

    private function canAccessCanonicalFamilyFromLegacyBranch(Request $request, Family $family): bool
    {
        $user = $request->user();
        $selectedFamilyId = (int) $request->input('_selected_family_id');

        if (! $selectedFamilyId || $selectedFamilyId !== (int) $user->family_id) {
            return false;
        }

        $selectedFamily = Family::query()->find($selectedFamilyId);
        $head = $selectedFamily ? $this->legacyBranchHeadForFamily($selectedFamily) : null;

        return $head?->family_id === $family->id;
    }

    private function legacyBranchFamilyMatchesMember(Family $family, FamilyMember $member): bool
    {
        $memberFamilyName = "{$this->memberName($member)} Family";

        return $family->name === $memberFamilyName
            || $family->slug === (Str::slug($memberFamilyName) ?: 'family');
    }

    /**
     * @param array<string, mixed> $data
     * @return array{0: FamilyMember, 1: Household|null}
     */
    private function createLegacyMember(Family $family, array $data, User $user): array
    {
        $familyHead = $this->familyHead($family, $data);
        $relationship = $data['relationship_to_family_head'] ?? $data['relation_to_family_head'] ?? null;

        $member = $this->createOrReuseMember(
            $family,
            $data,
            $user,
            $relationship,
            $familyHead ? [$familyHead->id] : [],
        );

        $this->connectToFamilyHead(
            $family,
            $familyHead,
            $member,
            $relationship,
            $user
        );

        $household = null;

        if ($familyHead && in_array($relationship, ['husband', 'wife', 'spouse'], true)) {
            if ($familyHead->marital_status !== 'married') {
                $familyHead->forceFill(['marital_status' => 'married'])->save();
            }

            $household = $this->createOrUpdateCoupleHousehold($family, $familyHead, $member, $user);
        }

        return [$member, $household];
    }

    /**
     * @param array<string, mixed> $data
     * @return array{0: FamilyMember, 1: Household}
     */
    private function createSpouseMember(Family $family, array $data, User $user): array
    {
        if (empty($data['existing_person_id'])) {
            throw ValidationException::withMessages([
                'existing_person_id' => ['Please select an existing person to add a spouse.'],
            ]);
        }

        $existingPerson = FamilyMember::query()
            ->where('family_id', $family->id)
            ->findOrFail((int) $data['existing_person_id']);

        $member = $this->createOrReuseMember($family, [
            ...$data,
            'family_head_id' => $existingPerson->id,
            'relation_to_family_head' => 'spouse',
            'marital_status' => $data['marital_status'] ?? 'married',
        ], $user, 'spouse', [$existingPerson->id]);

        $this->ensureSpouseRelationshipDoesNotExist($family, $existingPerson, $member);

        $this->createFamilyRelationship(
            $family,
            $existingPerson->id,
            $member->id,
            FamilyRelationship::TYPE_SPOUSE,
            "Added as spouse to {$this->memberName($existingPerson)}.",
            $user
        );

        if ($existingPerson->marital_status !== 'married') {
            $existingPerson->forceFill(['marital_status' => 'married'])->save();
        }

        $household = $this->createOrUpdateCoupleHousehold($family, $existingPerson, $member, $user);

        return [$member, $household];
    }

    /**
     * @param array<string, mixed> $data
     * @return array{0: FamilyMember, 1: Household}
     */
    private function createChildMember(Family $family, array $data, User $user): array
    {
        if (empty($data['household_id'])) {
            throw ValidationException::withMessages([
                'household_id' => ['Please select a household before adding a child.'],
            ]);
        }

        $household = $this->householdForFamily($family, (int) $data['household_id']);
        $parentIds = collect([$household->primary_person_id, $household->spouse_person_id])
            ->filter()
            ->unique()
            ->values();

        if ($parentIds->isEmpty()) {
            throw ValidationException::withMessages([
                'household_id' => ['Please select a household with at least one parent before adding a child.'],
            ]);
        }

        $familyHeadId = $parentIds->first();

        $member = $this->createOrReuseMember($family, [
            ...$data,
            'family_head_id' => $familyHeadId,
            'relation_to_family_head' => $this->childRelationFor($data['gender'] ?? null),
            'marital_status' => $data['marital_status'] ?? 'unmarried',
        ], $user, $this->childRelationFor($data['gender'] ?? null), $parentIds->all());

        foreach ($parentIds as $parentId) {
            $this->createFamilyRelationship(
                $family,
                (int) $parentId,
                $member->id,
                FamilyRelationship::TYPE_PARENT,
                "Added as child in household {$household->name}.",
                $user
            );
        }

        $this->attachHouseholdMember($household, $member, Household::ROLE_CHILD, $user);

        return [$member, $household->refresh()->load(['primaryPerson', 'spousePerson'])];
    }

    /**
     * @param array<string, mixed> $data
     * @param array<int, int> $excludeMemberIds
     */
    private function createOrReuseMember(
        Family $family,
        array $data,
        User $user,
        ?string $relationship = null,
        array $excludeMemberIds = [],
    ): FamilyMember {
        $duplicate = $this->matchingExistingMember($family, $data, $relationship, $excludeMemberIds);

        if ($duplicate) {
            $duplicate->forceFill([
                ...$this->emptyProfileFields($duplicate, $data),
                'family_head_id' => $duplicate->family_head_id ?: ($data['family_head_id'] ?? null),
                'relation_to_family_head' => $duplicate->relation_to_family_head ?: ($data['relation_to_family_head'] ?? $relationship),
                'marital_status' => $duplicate->marital_status ?: ($data['marital_status'] ?? null),
            ])->save();

            return $duplicate;
        }

        return FamilyMember::query()->create([
            ...$this->memberFields($data),
            'family_id' => $family->id,
            'created_by' => $user->id,
        ]);
    }

    /**
     * @param array<string, mixed> $data
     * @param array<int, int> $excludeMemberIds
     */
    private function matchingExistingMember(
        Family $family,
        array $data,
        ?string $relationship,
        array $excludeMemberIds,
    ): ?FamilyMember {
        $firstName = $this->normalizedText($data['first_name'] ?? null);
        $lastName = $this->normalizedText($data['last_name'] ?? null);

        if ($firstName === '') {
            return null;
        }

        $query = FamilyMember::query()
            ->where('family_id', $family->id)
            ->when($excludeMemberIds !== [], fn (Builder $query) => $query->whereNotIn('id', $excludeMemberIds))
            ->whereRaw('LOWER(TRIM(first_name)) = ?', [$firstName])
            ->whereRaw("LOWER(TRIM(COALESCE(last_name, ''))) = ?", [$lastName]);

        $email = Str::lower((string) ($data['email'] ?? ''));
        $phone = $this->normalizedPhone($data['phone'] ?? null);
        $birthDate = $data['birth_date'] ?? null;

        if ($email !== '' || $birthDate) {
            $query->where(function (Builder $query) use ($email, $birthDate): void {
                if ($email !== '') {
                    $query->orWhereRaw('LOWER(email) = ?', [$email]);
                }

                if ($birthDate) {
                    $query->orWhereDate('birth_date', $birthDate);
                }
            });
        }

        $matches = $query->get();

        if ($matches->isEmpty() && $phone !== '') {
            $matches = FamilyMember::query()
                ->where('family_id', $family->id)
                ->when($excludeMemberIds !== [], fn (Builder $query) => $query->whereNotIn('id', $excludeMemberIds))
                ->whereRaw('LOWER(TRIM(first_name)) = ?', [$firstName])
                ->whereRaw("LOWER(TRIM(COALESCE(last_name, ''))) = ?", [$lastName])
                ->get()
                ->filter(fn (FamilyMember $member): bool => $this->normalizedPhone($member->phone) === $phone)
                ->values();
        }

        if ($matches->isEmpty()) {
            return null;
        }

        if ($relationship) {
            $relationshipMatch = $matches->first(
                fn (FamilyMember $member): bool => $this->relationshipType((string) $member->relation_to_family_head)
                    === $this->relationshipType($relationship)
            );

            if ($relationshipMatch) {
                return $relationshipMatch;
            }
        }

        return $matches->first();
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    private function emptyProfileFields(FamilyMember $member, array $data): array
    {
        return collect([
            'gender',
            'birth_date',
            'birth_time',
            'death_date',
            'graveyard_location',
            'photo_path',
            'email',
            'phone',
            'current_city',
            'current_country',
            'notes',
            'is_living',
            'is_private',
        ])
            ->filter(fn (string $field): bool => blank($member->{$field}) && array_key_exists($field, $data))
            ->mapWithKeys(fn (string $field): array => [$field => $data[$field]])
            ->all();
    }

    private function persistPhotoUpload(Request $request, ?FamilyMember $existingMember = null): ?string
    {
        if (! $request->hasFile('photo')) {
            return null;
        }

        $photo = $request->file('photo');

        if (! $photo || ! $photo->isValid()) {
            throw ValidationException::withMessages([
                'photo' => ['Uploaded photo is invalid. Please try again.'],
            ]);
        }

        $path = $photo->store('family-members', 'user_photos');

        if ($existingMember?->photo_path && $existingMember->photo_path !== $path) {
            Storage::disk('user_photos')->delete($existingMember->photo_path);
        }

        return $path;
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    private function selfEditableMemberFields(array $data): array
    {
        return collect($this->memberFields($data))->only([
            'first_name',
            'last_name',
            'gender',
            'birth_date',
            'birth_time',
            'death_date',
            'graveyard_location',
            'photo_path',
            'email',
            'phone',
            'current_city',
            'current_country',
            'marital_status',
            'is_living',
        ])->all();
    }

    /**
     * @param array<string, mixed> $data
     * @return array{0: FamilyMember, 1: Household|null}
     */
    private function createParentMember(Family $family, array $data, User $user): array
    {
        if (empty($data['existing_person_id'])) {
            throw ValidationException::withMessages([
                'existing_person_id' => ['Please select the existing child this parent should be linked to.'],
            ]);
        }

        $child = FamilyMember::query()
            ->where('family_id', $family->id)
            ->findOrFail((int) $data['existing_person_id']);
        $relationship = $this->parentRelationFor($data['gender'] ?? null);
        $member = $this->createOrReuseMember($family, [
            ...$data,
            'family_head_id' => $child->id,
            'relation_to_family_head' => $relationship,
            'marital_status' => $data['marital_status'] ?? 'married',
        ], $user, $relationship, [$child->id]);

        $this->createFamilyRelationship(
            $family,
            $member->id,
            $child->id,
            FamilyRelationship::TYPE_PARENT,
            "Added as parent to {$this->memberName($child)}.",
            $user
        );

        return [$member, null];
    }

    /**
     * @param array<string, mixed> $data
     * @return array{0: FamilyMember, 1: Household|null}
     */
    private function createSiblingMember(Family $family, array $data, User $user): array
    {
        if (empty($data['existing_person_id'])) {
            throw ValidationException::withMessages([
                'existing_person_id' => ['Please select the existing person this sibling should be linked to.'],
            ]);
        }

        $sibling = FamilyMember::query()
            ->where('family_id', $family->id)
            ->findOrFail((int) $data['existing_person_id']);
        $relationship = $this->siblingRelationFor($data['gender'] ?? null);
        $isSiblingOfSpouse = $sibling->family_head_id
            && in_array($sibling->relation_to_family_head, ['spouse', 'wife', 'husband'], true);
        $siblingParentIds = FamilyRelationship::query()
            ->where('family_id', $family->id)
            ->where('relationship_type', FamilyRelationship::TYPE_PARENT)
            ->where('to_member_id', $sibling->id)
            ->pluck('from_member_id')
            ->unique()
            ->values();
        $memberRelationship = $isSiblingOfSpouse
            ? $this->inLawRelationFor($data['gender'] ?? null)
            : $relationship;
        $memberFamilyHeadId = $isSiblingOfSpouse
            ? $sibling->family_head_id
            : $siblingParentIds->first();

        $member = $this->createOrReuseMember($family, [
            ...$data,
            'family_head_id' => $memberFamilyHeadId,
            'relation_to_family_head' => $memberRelationship,
            'marital_status' => $data['marital_status'] ?? 'unmarried',
        ], $user, $memberRelationship, [$sibling->id]);

        $this->createFamilyRelationship(
            $family,
            $sibling->id,
            $member->id,
            FamilyRelationship::TYPE_SIBLING,
            "Added as sibling to {$this->memberName($sibling)}.",
            $user
        );

        foreach ($siblingParentIds as $parentId) {
            $this->createFamilyRelationship(
                $family,
                (int) $parentId,
                $member->id,
                FamilyRelationship::TYPE_PARENT,
                "Added as sibling in {$this->memberName($sibling)} family.",
                $user
            );
        }

        return [$member, null];
    }

    /**
     * @param array<string, mixed> $data
     * @return array{0: FamilyMember, 1: Household}
     */
    private function attachExistingMemberToHousehold(Family $family, array $data, User $user): array
    {
        if (empty($data['existing_person_id']) || empty($data['household_id'])) {
            throw ValidationException::withMessages([
                'existing_person_id' => ['Please select an existing person and household.'],
            ]);
        }

        $member = FamilyMember::query()
            ->where('family_id', $family->id)
            ->findOrFail((int) $data['existing_person_id']);
        $household = $this->householdForFamily($family, (int) $data['household_id']);

        $this->attachHouseholdMember($household, $member, $this->householdRoleFor($household, $member), $user);

        return [$member, $household->refresh()->load(['primaryPerson', 'spousePerson'])];
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

        if ($type === FamilyRelationship::TYPE_SPOUSE) {
            $this->ensureSpouseRelationshipDoesNotExist($family, $familyHead, $member);
        }

        [$fromMemberId, $toMemberId] = $this->relationshipDirection($familyHead, $member, $relationship);

        FamilyRelationship::query()->updateOrCreate(
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

    private function createFamilyRelationship(
        Family $family,
        int $fromMemberId,
        int $toMemberId,
        string $type,
        string $notes,
        User $user,
    ): FamilyRelationship {
        return FamilyRelationship::query()->updateOrCreate(
            [
                'family_id' => $family->id,
                'from_member_id' => $fromMemberId,
                'to_member_id' => $toMemberId,
                'relationship_type' => $type,
            ],
            [
                'notes' => $notes,
                'created_by' => $user->id,
            ],
        );
    }

    private function ensureSpouseRelationshipDoesNotExist(
        Family $family,
        FamilyMember $firstPerson,
        FamilyMember $secondPerson,
    ): void {
        $exists = FamilyRelationship::query()
            ->where('family_id', $family->id)
            ->where('relationship_type', FamilyRelationship::TYPE_SPOUSE)
            ->where(function (Builder $query) use ($firstPerson, $secondPerson): void {
                $query
                    ->where(function (Builder $query) use ($firstPerson, $secondPerson): void {
                        $query
                            ->where('from_member_id', $firstPerson->id)
                            ->where('to_member_id', $secondPerson->id);
                    })
                    ->orWhere(function (Builder $query) use ($firstPerson, $secondPerson): void {
                        $query
                            ->where('from_member_id', $secondPerson->id)
                            ->where('to_member_id', $firstPerson->id);
                    });
            })
            ->exists();

        if ($exists) {
            throw ValidationException::withMessages([
                'existing_person_id' => ['This spouse relationship already exists.'],
            ]);
        }
    }

    private function createOrUpdateCoupleHousehold(
        Family $family,
        FamilyMember $primaryPerson,
        FamilyMember $spousePerson,
        User $user,
    ): Household {
        $household = Household::query()
            ->where('family_id', $family->id)
            ->where(function (Builder $query) use ($primaryPerson, $spousePerson): void {
                $query
                    ->where(function (Builder $query) use ($primaryPerson, $spousePerson): void {
                        $query
                            ->where('primary_person_id', $primaryPerson->id)
                            ->where('spouse_person_id', $spousePerson->id);
                    })
                    ->orWhere(function (Builder $query) use ($primaryPerson, $spousePerson): void {
                        $query
                            ->where('primary_person_id', $spousePerson->id)
                            ->where('spouse_person_id', $primaryPerson->id);
                    });
            })
            ->first();

        $name = "{$this->memberName($primaryPerson)} & {$this->memberName($spousePerson)} Family";

        if (! $household) {
            $household = Household::query()->create([
                'family_id' => $family->id,
                'name' => $name,
                'primary_person_id' => $primaryPerson->id,
                'spouse_person_id' => $spousePerson->id,
                'created_by' => $user->id,
            ]);
        } else {
            $household->update([
                'name' => $name,
                'primary_person_id' => $household->primary_person_id ?: $primaryPerson->id,
                'spouse_person_id' => $household->spouse_person_id ?: $spousePerson->id,
            ]);
        }

        $this->attachHouseholdMember($household, $primaryPerson, $this->spouseRoleFor($primaryPerson), $user);
        $this->attachHouseholdMember($household, $spousePerson, $this->spouseRoleFor($spousePerson), $user);

        return $household->refresh()->load(['primaryPerson', 'spousePerson']);
    }

    private function householdForFamily(Family $family, int $householdId): Household
    {
        // TODO: Add household-level grants here when branch admin assignments are modeled.
        return Household::query()
            ->where('family_id', $family->id)
            ->findOrFail($householdId);
    }

    private function attachHouseholdMember(
        Household $household,
        FamilyMember $member,
        string $role,
        User $user,
    ): HouseholdMember {
        $existing = HouseholdMember::query()
            ->where('household_id', $household->id)
            ->where('member_id', $member->id)
            ->first();

        if ($existing) {
            if ($existing->role !== $role) {
                $existing->update(['role' => $role]);
            }

            return $existing;
        }

        return HouseholdMember::query()->create([
            'household_id' => $household->id,
            'member_id' => $member->id,
            'role' => $role,
            'created_by' => $user->id,
        ]);
    }

    private function childRelationFor(?string $gender): string
    {
        return match ($gender) {
            'male' => 'son',
            'female' => 'daughter',
            default => 'child',
        };
    }

    private function parentRelationFor(?string $gender): string
    {
        return match ($gender) {
            'male' => 'father',
            'female' => 'mother',
            default => 'parent',
        };
    }

    private function siblingRelationFor(?string $gender): string
    {
        return match ($gender) {
            'male' => 'brother',
            'female' => 'sister',
            default => 'sibling',
        };
    }

    private function inLawRelationFor(?string $gender): string
    {
        return match ($gender) {
            'male' => 'brother_in_law',
            'female' => 'sister_in_law',
            default => 'in_law',
        };
    }

    private function spouseRoleFor(FamilyMember $member): string
    {
        return match ($member->gender) {
            'male' => Household::ROLE_HUSBAND,
            'female' => Household::ROLE_WIFE,
            default => Household::ROLE_SPOUSE,
        };
    }

    private function householdRoleFor(Household $household, FamilyMember $member): string
    {
        if ((int) $household->primary_person_id === (int) $member->id) {
            return $this->spouseRoleFor($member);
        }

        if ((int) $household->spouse_person_id === (int) $member->id) {
            return $this->spouseRoleFor($member);
        }

        if ($member->family_head_id && in_array($member->relation_to_family_head, ['child', 'son', 'daughter'], true)) {
            return Household::ROLE_CHILD;
        }

        if (in_array($member->relation_to_family_head, ['father', 'mother', 'parent', 'guardian'], true)) {
            return Household::ROLE_GUARDIAN;
        }

        return Household::ROLE_OTHER;
    }

    private function normalizedText(?string $value): string
    {
        return Str::of((string) $value)->lower()->squish()->toString();
    }

    private function normalizedPhone(?string $value): string
    {
        return preg_replace('/\D+/', '', (string) $value) ?? '';
    }

    /**
     * @return array<int, string>
     */
    private function relationshipOptions(): array
    {
        return [
            'father',
            'mother',
            'parent',
            'son',
            'daughter',
            'child',
            'husband',
            'wife',
            'spouse',
            'brother',
            'sister',
            'sibling',
            'brother_in_law',
            'sister_in_law',
            'in_law',
            'guardian',
            'ward',
        ];
    }

    private function relationshipType(string $relationship): ?string
    {
        return match ($relationship) {
            'father', 'mother', 'parent', 'son', 'daughter', 'child' => FamilyRelationship::TYPE_PARENT,
            'husband', 'wife', 'spouse' => FamilyRelationship::TYPE_SPOUSE,
            'brother', 'sister', 'sibling', 'brother_in_law', 'sister_in_law', 'in_law' => FamilyRelationship::TYPE_SIBLING,
            'guardian', 'ward' => FamilyRelationship::TYPE_GUARDIAN,
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
    private function householdPayload(Household $household): array
    {
        $household->loadMissing(['primaryPerson', 'spousePerson']);

        return [
            'id' => $household->id,
            'family_id' => $household->family_id,
            'name' => $household->name,
            'primary_person_id' => $household->primary_person_id,
            'primary_person_name' => $household->primaryPerson ? $this->memberName($household->primaryPerson) : null,
            'spouse_person_id' => $household->spouse_person_id,
            'spouse_person_name' => $household->spousePerson ? $this->memberName($household->spousePerson) : null,
            'members_count' => $household->members_count ?? $household->members()->count(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function memberPayload(FamilyMember $member): array
    {
        $displayFamily = $this->displayFamily($member);
        $displayHousehold = $this->displayHousehold($member);

        return [
            'id' => $member->id,
            'family_id' => $member->family_id,
            'family_name' => $member->family?->name,
            'display_family_id' => $displayFamily?->id ?? $member->family_id,
            'display_family_name' => $displayFamily?->name ?? $member->family?->name,
            'household_id' => $displayHousehold?->id,
            'household_name' => $displayHousehold?->name,
            'user_id' => $member->user_id,
            'first_name' => $member->first_name,
            'last_name' => $member->last_name,
            'display_name' => trim("{$member->first_name} {$member->last_name}"),
            'gender' => $member->gender,
            'birth_date' => $member->birth_date?->format('Y-m-d'),
            'birth_time' => $member->birth_time,
            'death_date' => $member->death_date?->format('Y-m-d'),
            'photo_path' => $member->photo_path,
            'photo_url' => $member->photo_path ? Storage::disk('user_photos')->url($member->photo_path) : null,
            'email' => $member->email,
            'phone' => $member->phone,
            'current_city' => $member->current_city,
            'current_country' => $member->current_country,
            'family_head_id' => $member->family_head_id,
            'relation_to_family_head' => $this->resolvedRelationToFamilyHead($member),
            'marital_status' => $member->marital_status,
            'graveyard_location' => $member->graveyard_location,
            'notes' => $member->notes,
            'is_living' => $member->is_living,
            'is_private' => $member->is_private,
            'created_by' => $member->created_by,
            'creator_name' => $member->creator?->name,
            'creator_email' => $member->creator?->email,
            'linked_user_name' => $member->user?->name,
            'linked_user_email' => $member->user?->email,
            'family_head_name' => $member->familyHead
                ? trim("{$member->familyHead->first_name} {$member->familyHead->last_name}")
                : null,
        ];
    }

    private function displayHousehold(FamilyMember $member): ?Household
    {
        return Household::query()
            ->where('family_id', $member->family_id)
            ->whereHas('members', fn (Builder $query) => $query->where('member_id', $member->id))
            ->orderBy('name')
            ->first();
    }

    private function displayFamily(FamilyMember $member): ?Family
    {
        if (
            ! $member->familyHead
            || ! in_array($member->relation_to_family_head, ['child', 'son', 'daughter'], true)
        ) {
            return null;
        }

        $headName = trim("{$member->familyHead->first_name} {$member->familyHead->last_name}");

        if ($headName === '') {
            return null;
        }

        return Family::query()
            ->where('slug', $this->uniqueFamilySlugCandidate("{$headName} Family"))
            ->orWhere('name', "{$headName} Family")
            ->first();
    }

    private function uniqueFamilySlugCandidate(string $name): string
    {
        return Str::slug($name) ?: 'family';
    }

    private function resolvedRelationToFamilyHead(FamilyMember $member): ?string
    {
        $relation = $member->relation_to_family_head;

        if (
            ! in_array($relation, ['brother', 'sister', 'sibling'], true)
            || ! $member->family_head_id
        ) {
            return $relation;
        }

        $spouseIds = FamilyRelationship::query()
            ->where('family_id', $member->family_id)
            ->where('relationship_type', FamilyRelationship::TYPE_SPOUSE)
            ->where(function (Builder $query) use ($member): void {
                $query
                    ->where('from_member_id', $member->family_head_id)
                    ->orWhere('to_member_id', $member->family_head_id);
            })
            ->get()
            ->flatMap(fn (FamilyRelationship $relationship): array => [
                $relationship->from_member_id,
                $relationship->to_member_id,
            ])
            ->reject(fn (int $id): bool => $id === (int) $member->family_head_id)
            ->unique()
            ->values();

        if ($spouseIds->isEmpty()) {
            return $relation;
        }

        $isSiblingOfSpouse = FamilyRelationship::query()
            ->where('family_id', $member->family_id)
            ->where('relationship_type', FamilyRelationship::TYPE_SIBLING)
            ->where(function (Builder $query) use ($member, $spouseIds): void {
                $query
                    ->where(function (Builder $query) use ($member, $spouseIds): void {
                        $query
                            ->where('from_member_id', $member->id)
                            ->whereIn('to_member_id', $spouseIds->all());
                    })
                    ->orWhere(function (Builder $query) use ($member, $spouseIds): void {
                        $query
                            ->where('to_member_id', $member->id)
                            ->whereIn('from_member_id', $spouseIds->all());
                    });
            })
            ->exists();

        if (! $isSiblingOfSpouse) {
            return $relation;
        }

        return match ($relation) {
            'brother' => 'brother_in_law',
            'sister' => 'sister_in_law',
            default => 'in_law',
        };
    }
}
