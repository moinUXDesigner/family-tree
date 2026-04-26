<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::get('/health', fn () => response()->json([
        'status' => true,
        'message' => 'Family Tree API is healthy.',
        'data' => [
            'service' => 'family-tree-api',
        ],
    ]));

    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function (): void {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);

        Route::middleware('role:super_admin')->get('/super-admin/ping', fn () => response()->json([
            'status' => true,
            'message' => 'Super admin access confirmed.',
            'data' => null,
        ]));

        Route::middleware('role:admin,super_admin')->get('/admin/ping', fn () => response()->json([
            'status' => true,
            'message' => 'Admin access confirmed.',
            'data' => null,
        ]));

        Route::middleware('role:user,admin,super_admin')->get('/user/ping', fn () => response()->json([
            'status' => true,
            'message' => 'User access confirmed.',
            'data' => null,
        ]));
    });
});
