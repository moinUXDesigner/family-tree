<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
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

        if ($members->isEmpty()) {
            [$members, $relationships] = $this->legacyBranchTree($request, $family);
        } else {
            $relationships = FamilyRelationship::query()
                ->where('family_id', $family->id)
                ->with([
                    'fromMember:id,first_name,last_name,birth_date,is_living',
                    'toMember:id,first_name,last_name,birth_date,is_living',
                ])
                ->get();
        }

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
     * @return array{0: Collection<int, FamilyMember>, 1: Collection<int, FamilyRelationship>}
     */
    private function legacyBranchTree(Request $request, Family $family): array
    {
        $head = $this->legacyBranchHead($request, $family);

        if (! $head) {
            return [new Collection(), new Collection()];
        }

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

        $memberIds = collect([$head->id])
            ->merge($spouseIds)
            ->merge($childIds)
            ->merge($legacyLinkedIds)
            ->unique()
            ->values();

        if ($memberIds->isEmpty()) {
            return [new Collection(), new Collection()];
        }

        $members = FamilyMember::query()
            ->whereIn('id', $memberIds)
            ->orderByRaw('id = ? desc', [$head->id])
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->get();

        $relationships = FamilyRelationship::query()
            ->where('family_id', $head->family_id)
            ->whereIn('from_member_id', $memberIds)
            ->whereIn('to_member_id', $memberIds)
            ->with([
                'fromMember:id,first_name,last_name,birth_date,is_living',
                'toMember:id,first_name,last_name,birth_date,is_living',
            ])
            ->get();

        return [$members, $this->withLegacyMemberFieldLinks($relationships, $members)];
    }

    private function legacyBranchHead(Request $request, Family $family): ?FamilyMember
    {
        return FamilyMember::query()
            ->get(['id', 'family_id', 'first_name', 'last_name'])
            ->first(fn (FamilyMember $member): bool => $this->legacyBranchFamilyMatchesMember($family, $member));
    }

    private function legacyBranchFamilyMatchesMember(Family $family, FamilyMember $member): bool
    {
        $memberFamilyName = "{$this->memberName($member)} Family";

        return $family->name === $memberFamilyName
            || $family->slug === (Str::slug($memberFamilyName) ?: 'family');
    }

    /**
     * @param Collection<int, FamilyRelationship> $relationships
     * @param Collection<int, FamilyMember> $members
     * @return Collection<int, FamilyRelationship>
     */
    private function withLegacyMemberFieldLinks(Collection $relationships, Collection $members): Collection
    {
        $membersById = $members->keyBy('id');
        $existingKeys = $relationships
            ->mapWithKeys(fn (FamilyRelationship $relationship): array => [
                $this->relationshipKey($relationship->from_member_id, $relationship->to_member_id, $relationship->relationship_type) => true,
            ]);

        foreach ($members as $member) {
            if (! $member->family_head_id || ! $membersById->has($member->family_head_id)) {
                continue;
            }

            $type = $this->relationshipTypeForLegacyMember($member);

            if (! $type) {
                continue;
            }

            $key = $this->relationshipKey($member->family_head_id, $member->id, $type);

            if ($existingKeys->has($key)) {
                continue;
            }

            $relationship = new FamilyRelationship();
            $relationship->forceFill([
                'id' => -$member->id,
                'family_id' => $member->family_id,
                'from_member_id' => $member->family_head_id,
                'to_member_id' => $member->id,
                'relationship_type' => $type,
            ]);
            $relationship->setRelation('fromMember', $membersById->get($member->family_head_id));
            $relationship->setRelation('toMember', $member);

            $relationships->push($relationship);
            $existingKeys->put($key, true);
        }

        return $relationships;
    }

    private function relationshipTypeForLegacyMember(FamilyMember $member): ?string
    {
        return match ($member->relation_to_family_head) {
            'child', 'son', 'daughter' => FamilyRelationship::TYPE_PARENT,
            'husband', 'wife', 'spouse' => FamilyRelationship::TYPE_SPOUSE,
            default => null,
        };
    }

    private function relationshipKey(int $fromMemberId, int $toMemberId, string $type): string
    {
        return "{$fromMemberId}:{$toMemberId}:{$type}";
    }

    /**
     * @return array<string, mixed>
     */
    private function nodePayload(FamilyMember $member): array
    {
        return [
            'id' => $member->id,
            'user_id' => $member->user_id,
            'name' => trim("{$member->first_name} {$member->last_name}"),
            'first_name' => $member->first_name,
            'last_name' => $member->last_name,
            'gender' => $member->gender,
            'birth_date' => $member->birth_date?->format('Y-m-d'),
            'death_date' => $member->death_date?->format('Y-m-d'),
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
        $explicitRoots = $members
            ->filter(fn (FamilyMember $member): bool => blank($member->family_head_id) && blank($member->relation_to_family_head))
            ->pluck('id')
            ->values()
            ->all();

        if ($explicitRoots) {
            return $explicitRoots;
        }

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
