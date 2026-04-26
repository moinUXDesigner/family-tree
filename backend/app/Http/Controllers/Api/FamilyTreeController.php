<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class FamilyTreeController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        $user = $request->user();
        $family = $this->accessibleFamily($request, $request->integer('family_id') ?: $user->family_id);

        $members = FamilyMember::query()
            ->where('family_id', $family->id)
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get();

        $relationships = FamilyRelationship::query()
            ->where('family_id', $family->id)
            ->with([
                'fromMember:id,first_name,last_name,birth_date,is_living',
                'toMember:id,first_name,last_name,birth_date,is_living',
            ])
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Family tree loaded.',
            'data' => [
                'family' => [
                    'id' => $family->id,
                    'name' => $family->name,
                    'slug' => $family->slug,
                ],
                'nodes' => $members->map(fn (FamilyMember $member) => $this->nodePayload($member))->values(),
                'links' => $relationships->map(fn (FamilyRelationship $relationship) => $this->linkPayload($relationship))->values(),
                'root_member_ids' => $this->rootMemberIds($members, $relationships),
            ],
        ]);
    }

    private function accessibleFamily(Request $request, ?int $familyId): Family
    {
        $user = $request->user();

        abort_if(! $familyId, Response::HTTP_FORBIDDEN);

        $family = Family::query()->findOrFail($familyId);

        if (! $user->hasRole(User::ROLE_SUPER_ADMIN)) {
            abort_if($user->family_id !== $family->id, Response::HTTP_FORBIDDEN);
        }

        return $family;
    }

    /**
     * @return array<string, mixed>
     */
    private function nodePayload(FamilyMember $member): array
    {
        return [
            'id' => $member->id,
            'name' => trim("{$member->first_name} {$member->last_name}"),
            'first_name' => $member->first_name,
            'last_name' => $member->last_name,
            'birth_date' => $member->birth_date?->format('Y-m-d'),
            'is_living' => $member->is_living,
            'location' => trim(collect([$member->current_city, $member->current_country])->filter()->join(', ')),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function linkPayload(FamilyRelationship $relationship): array
    {
        return [
            'id' => $relationship->id,
            'from_member_id' => $relationship->from_member_id,
            'from_member_name' => $this->memberName($relationship->fromMember),
            'to_member_id' => $relationship->to_member_id,
            'to_member_name' => $this->memberName($relationship->toMember),
            'relationship_type' => $relationship->relationship_type,
            'relationship_label' => $this->relationshipLabel($relationship->relationship_type),
        ];
    }

    /**
     * @param Collection<int, FamilyMember> $members
     * @param Collection<int, FamilyRelationship> $relationships
     * @return array<int, int>
     */
    private function rootMemberIds(Collection $members, Collection $relationships): array
    {
        $childIds = $relationships
            ->where('relationship_type', FamilyRelationship::TYPE_PARENT)
            ->pluck('to_member_id')
            ->unique()
            ->all();

        $roots = $members
            ->whereNotIn('id', $childIds)
            ->pluck('id')
            ->values()
            ->all();

        return $roots ?: $members->pluck('id')->take(1)->values()->all();
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
