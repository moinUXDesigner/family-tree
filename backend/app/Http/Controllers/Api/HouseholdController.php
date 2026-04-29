<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\Household;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\Response;

class HouseholdController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $familyId = $this->requestedFamilyId($request, $user);

        $households = Household::query()
            ->with([
                'primaryPerson:id,first_name,last_name,gender',
                'spousePerson:id,first_name,last_name,gender',
            ])
            ->withCount('members')
            ->when($familyId, fn (Builder $query) => $query->where('family_id', $familyId))
            ->when(! $user->hasRole(User::ROLE_SUPER_ADMIN) && ! $familyId, fn (Builder $query) => $query->where('family_id', $user->family_id))
            ->orderBy('name')
            ->get();

        if ($familyId && $households->isEmpty()) {
            $households = $this->legacyBranchHouseholds($request, $familyId);
        }

        return response()->json([
            'status' => true,
            'message' => 'Households loaded.',
            'data' => [
                'households' => $households->map(fn (Household $household) => $this->householdPayload($household)),
            ],
        ]);
    }

    private function requestedFamilyId(Request $request, User $user): ?int
    {
        $familyId = $request->integer('family_id') ?: null;

        if (! $familyId) {
            return $user->hasRole(User::ROLE_SUPER_ADMIN) ? null : $user->family_id;
        }

        $this->accessibleFamily($request, $familyId);

        return $familyId;
    }

    private function accessibleFamily(Request $request, int $familyId): Family
    {
        $user = $request->user();
        $family = Family::query()->findOrFail($familyId);

        if (! $user->hasRole(User::ROLE_SUPER_ADMIN)) {
            abort_if($user->family_id !== $family->id, Response::HTTP_FORBIDDEN);
        }

        return $family;
    }

    private function legacyBranchHouseholds(Request $request, int $familyId)
    {
        $family = Family::query()->find($familyId);

        if (! $family) {
            return collect();
        }

        $head = FamilyMember::query()
            ->get(['id', 'family_id', 'first_name', 'last_name'])
            ->first(fn (FamilyMember $member): bool => $this->legacyBranchFamilyMatchesMember($family, $member));

        if (! $head) {
            return collect();
        }

        return Household::query()
            ->with([
                'primaryPerson:id,first_name,last_name,gender',
                'spousePerson:id,first_name,last_name,gender',
            ])
            ->withCount('members')
            ->where('family_id', $head->family_id)
            ->where(function (Builder $query) use ($head): void {
                $query->where('primary_person_id', $head->id)->orWhere('spouse_person_id', $head->id);
            })
            ->orderBy('name')
            ->get();
    }

    private function legacyBranchFamilyMatchesMember(Family $family, FamilyMember $member): bool
    {
        $memberFamilyName = "{$this->memberName($member)} Family";

        return $family->name === $memberFamilyName
            || $family->slug === (Str::slug($memberFamilyName) ?: 'family');
    }

    /**
     * @return array<string, mixed>
     */
    private function householdPayload(Household $household): array
    {
        return [
            'id' => $household->id,
            'family_id' => $household->family_id,
            'name' => $household->name,
            'primary_person_id' => $household->primary_person_id,
            'primary_person_name' => $this->memberName($household->primaryPerson),
            'spouse_person_id' => $household->spouse_person_id,
            'spouse_person_name' => $this->memberName($household->spousePerson),
            'members_count' => $household->members_count ?? 0,
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
