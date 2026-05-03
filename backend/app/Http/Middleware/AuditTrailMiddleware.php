<?php

namespace App\Http\Middleware;

use App\Models\AuditTrail;
use Closure;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Schema;
use Symfony\Component\HttpFoundation\Response;

class AuditTrailMiddleware
{
    private static ?bool $auditTableExists = null;

    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        if (! $request->user() || $request->method() === 'GET' || ! $this->canWriteAuditTrail()) {
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

        try {
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
        } catch (QueryException) {
            // Fail-safe: request should never fail because audit table is missing/migrating.
            self::$auditTableExists = false;
        }

        return $response;
    }

    private function canWriteAuditTrail(): bool
    {
        if (self::$auditTableExists !== null) {
            return self::$auditTableExists;
        }

        return self::$auditTableExists = Schema::hasTable('audit_trails');
    }
}
