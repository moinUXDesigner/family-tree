<?php

namespace App\Http\Middleware;

use App\Support\AuditTrailLogger;
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

        AuditTrailLogger::logRequest($request, $response);

        return $response;
    }
}
