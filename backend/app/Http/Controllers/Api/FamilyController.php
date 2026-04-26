<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Family;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class FamilyController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $families = Family::query()
            ->when(! $user->hasRole(User::ROLE_SUPER_ADMIN), fn ($query) => $query->whereKey($user->family_id))
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
}
