<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\FamilyConnectionController;
use App\Http\Controllers\Api\FamilyController;
use App\Http\Controllers\Api\FamilyMemberController;
use App\Http\Controllers\Api\FamilyRelationshipController;
use App\Http\Controllers\Api\FamilyTreeController;
use App\Http\Controllers\Api\RootFamilyController;
use App\Http\Controllers\Api\UserApprovalController;
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

        Route::middleware('role:user,admin,super_admin')->group(function (): void {
            Route::get('/families', [FamilyController::class, 'index']);
            Route::get('/family-members', [FamilyMemberController::class, 'index']);
            Route::post('/family-members', [FamilyMemberController::class, 'store']);
            Route::get('/family-relationships', [FamilyRelationshipController::class, 'index']);
            Route::get('/family-tree', [FamilyTreeController::class, 'show']);
            Route::get('/family-connection', [FamilyConnectionController::class, 'status']);
            Route::post('/family-connection', [FamilyConnectionController::class, 'connect']);
        });

        Route::middleware('role:admin,super_admin')->group(function (): void {
            Route::put('/family-members/{familyMember}', [FamilyMemberController::class, 'update']);
            Route::delete('/family-members/{familyMember}', [FamilyMemberController::class, 'destroy']);
            Route::post('/family-relationships', [FamilyRelationshipController::class, 'store']);
            Route::delete('/family-relationships/{familyRelationship}', [FamilyRelationshipController::class, 'destroy']);
        });

        Route::middleware('role:super_admin')->group(function (): void {
            Route::post('/families', [FamilyController::class, 'store']);
            Route::delete('/families/{family}', [FamilyController::class, 'destroy']);
            Route::get('/approval-requests', [UserApprovalController::class, 'index']);
            Route::post('/approval-requests/{user}', [UserApprovalController::class, 'update']);
            Route::put('/approval-requests/{user}', [UserApprovalController::class, 'update']);
            Route::get('/root-family', [RootFamilyController::class, 'show']);
            Route::post('/root-family/members', [RootFamilyController::class, 'storeMember']);
        });

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
