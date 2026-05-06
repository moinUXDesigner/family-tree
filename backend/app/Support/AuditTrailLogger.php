<?php

namespace App\Support;

use App\Models\AuditTrail;
use App\Models\User;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Schema;
use Symfony\Component\HttpFoundation\Response;

class AuditTrailLogger
{
    private const REDACTED = '***';

    /**
     * @var array<int, string>
     */
    private const SENSITIVE_KEYS = [
        'password',
        'password_confirmation',
        'current_password',
        'token',
        'authorization',
    ];

    private static ?bool $auditTableExists = null;

    public static function logRequest(
        Request $request,
        Response $response,
        ?User $actor = null,
        ?string $event = null
    ): void {
        if (! self::canWriteAuditTrail()) {
            return;
        }

        $user = $actor ?? $request->user();
        $payload = self::sanitize($request->all());

        try {
            AuditTrail::query()->create([
                'user_id' => $user?->id,
                'user_role' => $user?->role,
                'family_id' => $user?->family_id,
                'event' => $event ?? sprintf('%s %s', $request->method(), $request->path()),
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
            self::$auditTableExists = false;
        }
    }

    private static function canWriteAuditTrail(): bool
    {
        if (self::$auditTableExists !== null) {
            return self::$auditTableExists;
        }

        return self::$auditTableExists = Schema::hasTable('audit_trails');
    }

    /**
     * @param mixed $value
     * @return mixed
     */
    private static function sanitize(mixed $value): mixed
    {
        if (is_array($value)) {
            $sanitized = [];
            foreach ($value as $key => $item) {
                if (is_string($key) && self::isSensitiveKey($key)) {
                    $sanitized[$key] = self::REDACTED;
                    continue;
                }

                $sanitized[$key] = self::sanitize($item);
            }

            return $sanitized;
        }

        if ($value instanceof UploadedFile) {
            return [
                'name' => $value->getClientOriginalName(),
                'size' => $value->getSize(),
                'mime' => $value->getClientMimeType(),
            ];
        }

        if (is_string($value) && mb_strlen($value) > 180) {
            return mb_substr($value, 0, 180).'...';
        }

        if (is_scalar($value) || $value === null) {
            return $value;
        }

        return sprintf('[%s]', get_debug_type($value));
    }

    private static function isSensitiveKey(string $key): bool
    {
        $normalized = strtolower($key);

        foreach (self::SENSITIVE_KEYS as $sensitiveKey) {
            if ($normalized === $sensitiveKey || str_contains($normalized, $sensitiveKey)) {
                return true;
            }
        }

        return false;
    }
}
