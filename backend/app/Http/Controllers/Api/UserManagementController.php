<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

class UserManagementController extends Controller
{
    public function index(): JsonResponse
    {
        $users = User::query()
            ->with(['family:id,name', 'familyMember:id,user_id', 'familyConnectionRequest:id,user_id,status'])
            ->withCount('tokens')
            ->latest()
            ->get()
            ->map(fn (User $user) => $this->userPayload($user));

        return response()->json([
            'status' => true,
            'message' => 'Users loaded.',
            'data' => [
                'users' => $users,
                'roles' => User::roles(),
                'approval_statuses' => [
                    User::APPROVAL_PENDING,
                    User::APPROVAL_APPROVED,
                    User::APPROVAL_REJECTED,
                ],
            ],
        ]);
    }

    public function update(Request $request, User $user): JsonResponse
    {
        $data = $request->validate([
            'role' => ['sometimes', 'string', Rule::in(User::roles())],
            'family_id' => ['sometimes', 'nullable', 'integer', Rule::exists('families', 'id')],
            'approval_status' => ['sometimes', 'string', Rule::in([
                User::APPROVAL_PENDING,
                User::APPROVAL_APPROVED,
                User::APPROVAL_REJECTED,
            ])],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $this->guardSelfLockout($request, $user, $data);
        $this->guardLastActiveSuperAdmin($user, $data);

        if (array_key_exists('role', $data) && $data['role'] !== User::ROLE_USER) {
            $data['approval_status'] = User::APPROVAL_APPROVED;
        }

        $user->forceFill($data)->save();

        if (array_key_exists('is_active', $data) && ! $data['is_active']) {
            $user->tokens()->delete();
        }

        return response()->json([
            'status' => true,
            'message' => 'User updated.',
            'data' => [
                'user' => $this->userPayload($user->refresh()->load(['family:id,name', 'familyMember:id,user_id', 'familyConnectionRequest:id,user_id,status'])->loadCount('tokens')),
            ],
        ]);
    }

    public function destroy(Request $request, User $user): JsonResponse
    {
        abort_if($request->user()->is($user), Response::HTTP_UNPROCESSABLE_ENTITY, 'You cannot delete your own account.');
        $this->guardLastActiveSuperAdmin($user, ['is_active' => false]);

        $user->tokens()->delete();
        $user->delete();

        return response()->json([
            'status' => true,
            'message' => 'User deleted.',
            'data' => null,
        ]);
    }

    /**
     * @param array<string, mixed> $data
     */
    private function guardSelfLockout(Request $request, User $user, array $data): void
    {
        if (! $request->user()->is($user)) {
            return;
        }

        abort_if(($data['role'] ?? $user->role) !== User::ROLE_SUPER_ADMIN, Response::HTTP_UNPROCESSABLE_ENTITY, 'You cannot remove your own Super Admin role.');
        abort_if(array_key_exists('is_active', $data) && ! $data['is_active'], Response::HTTP_UNPROCESSABLE_ENTITY, 'You cannot block your own account.');
    }

    /**
     * @param array<string, mixed> $data
     */
    private function guardLastActiveSuperAdmin(User $user, array $data): void
    {
        if (! $user->hasRole(User::ROLE_SUPER_ADMIN)) {
            return;
        }

        $keepsSuperAdmin = ($data['role'] ?? $user->role) === User::ROLE_SUPER_ADMIN;
        $keepsActive = $data['is_active'] ?? $user->is_active;

        if ($keepsSuperAdmin && $keepsActive) {
            return;
        }

        $otherActiveSuperAdmins = User::query()
            ->whereKeyNot($user->id)
            ->where('role', User::ROLE_SUPER_ADMIN)
            ->where('is_active', true)
            ->exists();

        abort_if(! $otherActiveSuperAdmins, Response::HTTP_UNPROCESSABLE_ENTITY, 'At least one active Super Admin is required.');
    }

    /**
     * @return array<string, mixed>
     */
    private function userPayload(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone' => $user->phone,
            'role' => $user->role,
            'family_id' => $user->family_id,
            'family_name' => $user->family?->name,
            'approval_status' => $user->approval_status,
            'is_active' => $user->is_active,
            'is_connected' => (bool) $user->familyMember,
            'connection_request_status' => $user->familyConnectionRequest?->status,
            'active_sessions' => $user->tokens_count ?? 0,
            'created_at' => $user->created_at?->toISOString(),
        ];
    }
}
