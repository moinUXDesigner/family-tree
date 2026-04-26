<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserHasRole
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (! $user || ! $user->is_active || ! $user->hasRole(...$roles)) {
            return response()->json([
                'status' => false,
                'message' => 'Forbidden.',
                'data' => null,
            ], 403);
        }

        return $next($request);
    }
}
