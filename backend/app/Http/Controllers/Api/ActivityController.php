<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AuditTrail;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ActivityController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $familyId = $request->integer('family_id') ?: null;

        $trails = AuditTrail::query()
            ->with('user:id,name,email')
            ->when(
                $user->hasRole(User::ROLE_ADMIN),
                fn (Builder $query) => $query->where('family_id', $user->family_id)
            )
            ->when(
                $user->hasRole(User::ROLE_SUPER_ADMIN) && $familyId,
                fn (Builder $query) => $query->where('family_id', $familyId)
            )
            ->when(
                filled($request->input('event')),
                fn (Builder $query) => $query->where('event', 'like', '%'.$request->string('event')->toString().'%')
            )
            ->latest('id')
            ->limit(300)
            ->get()
            ->map(fn (AuditTrail $trail): array => [
                'id' => $trail->id,
                'user_id' => $trail->user_id,
                'user_name' => $trail->user?->name,
                'user_email' => $trail->user?->email,
                'user_role' => $trail->user_role,
                'family_id' => $trail->family_id,
                'event' => $trail->event,
                'method' => $trail->method,
                'path' => $trail->path,
                'ip_address' => $trail->ip_address,
                'meta' => $trail->meta,
                'created_at' => $trail->created_at?->toIso8601String(),
            ]);

        return response()->json([
            'status' => true,
            'message' => 'Activity trails loaded.',
            'data' => [
                'activities' => $trails,
            ],
        ]);
    }
}

