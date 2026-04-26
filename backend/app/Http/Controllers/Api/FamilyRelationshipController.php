<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response;

class FamilyRelationshipController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $familyId = $this->requestedFamilyId($request, $user);

        $relationships = FamilyRelationship::query()
            ->with([
                'family:id,name',
                'fromMember:id,first_name,last_name',
                'toMember:id,first_name,last_name',
            ])
            ->when($familyId, fn (Builder $query) => $query->where('family_id', $familyId))
            ->when(! $user->hasRole(User::ROLE_SUPER_ADMIN) && ! $familyId, fn (Builder $query) => $query->where('family_id', $user->family_id))
            ->latest()
            ->get()
            ->map(fn (FamilyRelationship $relationship) => $this->relationshipPayload($relationship));

        return response()->json([
            'status' => true,
            'message' => 'Family relationships loaded.',
            'data' => [
                'relationships' => $relationships,
                'relationship_types' => FamilyRelationship::types(),
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $this->validatedRelationshipData($request);
        $family = $this->accessibleFamily($request, (int) $data['family_id'], true);
        $this->ensureMembersBelongToFamily($family, (int) $data['from_member_id'], (int) $data['to_member_id']);

        $relationship = FamilyRelationship::query()->create([
            ...$data,
            'family_id' => $family->id,
            'created_by' => $request->user()->id,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Family relationship created.',
            'data' => [
                'relationship' => $this->relationshipPayload($relationship->load([
                    'family:id,name',
                    'fromMember:id,first_name,last_name',
                    'toMember:id,first_name,last_name',
                ])),
            ],
        ], 201);
    }

    public function destroy(Request $request, FamilyRelationship $familyRelationship): JsonResponse
    {
        $this->accessibleFamily($request, $familyRelationship->family_id, true);
        $familyRelationship->delete();

        return response()->json([
            'status' => true,
            'message' => 'Family relationship deleted.',
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

    private function ensureMembersBelongToFamily(Family $family, int $fromMemberId, int $toMemberId): void
    {
        if ($fromMemberId === $toMemberId) {
            throw ValidationException::withMessages([
                'to_member_id' => ['Choose two different family members.'],
            ]);
        }

        $memberCount = FamilyMember::query()
            ->where('family_id', $family->id)
            ->whereIn('id', [$fromMemberId, $toMemberId])
            ->count();

        if ($memberCount !== 2) {
            throw ValidationException::withMessages([
                'family_id' => ['Both members must belong to the selected family.'],
            ]);
        }
    }

    /**
     * @return array<string, mixed>
     */
    private function validatedRelationshipData(Request $request): array
    {
        return $request->validate([
            'family_id' => ['required', 'integer', Rule::exists('families', 'id')],
            'from_member_id' => ['required', 'integer', Rule::exists('family_members', 'id')],
            'to_member_id' => ['required', 'integer', Rule::exists('family_members', 'id')],
            'relationship_type' => ['required', 'string', Rule::in(FamilyRelationship::types())],
            'notes' => ['nullable', 'string', 'max:1000'],
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function relationshipPayload(FamilyRelationship $relationship): array
    {
        return [
            'id' => $relationship->id,
            'family_id' => $relationship->family_id,
            'family_name' => $relationship->family?->name,
            'from_member_id' => $relationship->from_member_id,
            'from_member_name' => $this->memberName($relationship->fromMember),
            'to_member_id' => $relationship->to_member_id,
            'to_member_name' => $this->memberName($relationship->toMember),
            'relationship_type' => $relationship->relationship_type,
            'relationship_label' => $this->relationshipLabel($relationship->relationship_type),
            'notes' => $relationship->notes,
        ];
    }

    private function memberName(?FamilyMember $member): ?string
    {
        if (! $member) {
            return null;
        }

        return trim("{$member->first_name} {$member->last_name}");
    }

    private function relationshipLabel(string $type): string
    {
        return match ($type) {
            FamilyRelationship::TYPE_PARENT => 'Parent of',
            FamilyRelationship::TYPE_SPOUSE => 'Spouse of',
            FamilyRelationship::TYPE_SIBLING => 'Sibling of',
            FamilyRelationship::TYPE_GUARDIAN => 'Guardian of',
            default => ucfirst($type),
        };
    }
}
