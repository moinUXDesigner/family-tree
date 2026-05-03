<?php

namespace App\Http\Middleware;

use App\Models\AuditTrail;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AuditTrailMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        if (! $request->user() || $request->method() === 'GET') {
            return $response;
        }

        $user = $request->user();
        $payload = collect($request->except(['password', 'password_confirmation', 'current_password']))
            ->map(function (mixed $value): mixed {
                if (is_string($value) && mb_strlen($value) > 180) {
                    return mb_substr($value, 0, 180).'...';
                }

                return $value;
            })
            ->all();

        AuditTrail::query()->create([
            'user_id' => $user->id,
            'user_role' => $user->role,
            'family_id' => $user->family_id,
            'event' => sprintf('%s %s', $request->method(), $request->path()),
            'method' => $request->method(),
            'path' => $request->path(),
            'ip_address' => $request->ip(),
            'user_agent' => (string) $request->userAgent(),
            'meta' => [
                'status_code' => $response->getStatusCode(),
                'payload' => $payload,
            ],
        ]);

        return $response;
    }
}

