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

        $member = FamilyMember::query()->create([
            ...$data,
            'family_id' => $family->id,
            'created_by' => $request->user()->id,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Family member created.',
            'data' => [
                'member' => $this->memberPayload($member->load('family:id,name')),
            ],
        ], 201);
    }

    public function update(Request $request, FamilyMember $familyMember): JsonResponse
    {
        $this->ensureMemberAccess($request, $familyMember, true);

        $data = $this->validatedMemberData($request, $familyMember);
        $family = $this->accessibleFamily($request, (int) $data['family_id'], true);

        $familyMember->update([
            ...$data,
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
            'notes' => ['nullable', 'string', 'max:2000'],
            'is_living' => ['sometimes', 'boolean'],
            'is_private' => ['sometimes', 'boolean'],
        ]);
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
            'notes' => $member->notes,
            'is_living' => $member->is_living,
            'is_private' => $member->is_private,
        ];
    }
}
