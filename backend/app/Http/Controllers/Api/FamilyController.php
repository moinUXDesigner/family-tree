<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

class FamilyController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $familyId = $user->hasRole(User::ROLE_SUPER_ADMIN)
            ? null
            : $this->familyIdForUser($user);

        $families = Family::query()
            ->when(! $user->hasRole(User::ROLE_SUPER_ADMIN), fn ($query) => $query->whereKey($familyId))
            ->withCount('members')
            ->orderBy('name')
            ->get()
            ->map(fn (Family $family) => $this->familyPayload($family));

        return response()->json([
            'status' => true,
            'message' => 'Families loaded.',
            'data' => [
                'families' => $families,
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'slug' => ['nullable', 'string', 'max:255', 'alpha_dash', Rule::unique('families', 'slug')],
            'description' => ['nullable', 'string', 'max:1000'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $family = Family::query()->create([
            'name' => $data['name'],
            'slug' => $data['slug'] ?? $this->uniqueSlug($data['name']),
            'description' => $data['description'] ?? null,
            'is_active' => $data['is_active'] ?? true,
            'created_by' => $request->user()->id,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Family created.',
            'data' => [
                'family' => $this->familyPayload($family->loadCount('members')),
            ],
        ], 201);
    }

    public function destroy(Family $family): JsonResponse
    {
        abort_if($family->slug === 'shaik-nanne-saheb-family', Response::HTTP_UNPROCESSABLE_ENTITY, 'The Nanne Saheb root family cannot be deleted.');

        $family->delete();

        return response()->json([
            'status' => true,
            'message' => 'Family deleted.',
            'data' => null,
        ]);
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
            'members_count' => $family->members_count ?? 0,
        ];
    }

    private function uniqueSlug(string $name): string
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

    private function familyIdForUser(User $user): int
    {
        if ($user->family_id) {
            return $user->family_id;
        }

        $family = Family::query()->create([
            'name' => "{$user->name}'s Family",
            'slug' => $this->uniqueSlug($user->name),
            'description' => null,
            'is_active' => true,
            'created_by' => $user->id,
        ]);

        $user->forceFill(['family_id' => $family->id])->save();

        return $family->id;
    }
}
