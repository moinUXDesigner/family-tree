<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class UserApprovalController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $status = $request->query('status', User::APPROVAL_PENDING);

        $users = User::query()
            ->with('family:id,name')
            ->where('role', User::ROLE_USER)
            ->when($status !== 'all', fn ($query) => $query->where('approval_status', $status))
            ->latest()
            ->get()
            ->map(fn (User $user) => $this->userPayload($user));

        return response()->json([
            'status' => true,
            'message' => 'Access requests loaded.',
            'data' => [
                'users' => $users,
            ],
        ]);
    }

    public function update(Request $request, User $user): JsonResponse
    {
        $data = $request->validate([
            'approval_status' => ['required', Rule::in([
                User::APPROVAL_APPROVED,
                User::APPROVAL_REJECTED,
                User::APPROVAL_PENDING,
            ])],
        ]);

        abort_if(! $user->hasRole(User::ROLE_USER), 422, 'Only end users require approval.');

        $user->forceFill(['approval_status' => $data['approval_status']])->save();

        return response()->json([
            'status' => true,
            'message' => 'Access request updated.',
            'data' => [
                'user' => $this->userPayload($user->refresh()->load('family:id,name')),
            ],
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function userPayload(User $user): array
    {
        $member = FamilyMember::query()
            ->where('user_id', $user->id)
            ->first(['id', 'notes']);
        $relationship = $this->relationshipToRoot($member?->notes);

        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone' => $user->phone,
            'family_id' => $user->family_id,
            'family_name' => $user->family?->name,
            'member_id' => $member?->id,
            'relationship_to_root' => $relationship,
            'relationship_label' => $relationship ? Str::headline($relationship) : null,
            'approval_status' => $user->approval_status,
            'created_at' => $user->created_at?->toISOString(),
        ];
    }

    private function relationshipToRoot(?string $notes): ?string
    {
        if (! $notes || ! preg_match('/\bas\s+(.+?)\.$/i', $notes, $matches)) {
            return null;
        }

        return $matches[1];
    }
}
