<?php

namespace Tests\Feature;

use App\Models\AuditTrail;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuditTrailTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_mutation_creates_audit_trail_entry(): void
    {
        $user = User::factory()->create([
            'role' => User::ROLE_USER,
            'is_active' => true,
        ]);

        Sanctum::actingAs($user);

        $this->putJson('/api/v1/me', [
            'name' => 'Updated Name',
            'phone' => '9876543210',
        ])->assertOk();

        $trail = AuditTrail::query()->latest('id')->first();

        $this->assertNotNull($trail);
        $this->assertSame($user->id, $trail->user_id);
        $this->assertSame('PUT', $trail->method);
        $this->assertSame('api/v1/me', $trail->path);
        $this->assertSame(200, data_get($trail->meta, 'status_code'));
        $this->assertSame('Updated Name', data_get($trail->meta, 'payload.name'));
    }

    public function test_login_creates_guest_accessible_audit_trail_entry(): void
    {
        $user = User::factory()->create([
            'password' => 'Password123!',
            'is_active' => true,
        ]);

        $this->postJson('/api/v1/login', [
            'email' => $user->email,
            'password' => 'Password123!',
        ])->assertOk();

        $trail = AuditTrail::query()->latest('id')->first();

        $this->assertNotNull($trail);
        $this->assertSame($user->id, $trail->user_id);
        $this->assertSame('AUTH login', $trail->event);
        $this->assertSame('POST', $trail->method);
        $this->assertSame('api/v1/login', $trail->path);
    }

    public function test_sensitive_fields_are_redacted_in_audit_payload(): void
    {
        $user = User::factory()->create([
            'password' => 'CurrentPassword123',
            'is_active' => true,
        ]);

        Sanctum::actingAs($user);

        $this->postJson('/api/v1/change-password', [
            'current_password' => 'CurrentPassword123',
            'password' => 'UpdatedPassword123',
            'password_confirmation' => 'UpdatedPassword123',
        ])->assertOk();

        $trail = AuditTrail::query()->latest('id')->first();

        $this->assertNotNull($trail);
        $this->assertSame('***', data_get($trail->meta, 'payload.current_password'));
        $this->assertSame('***', data_get($trail->meta, 'payload.password'));
        $this->assertSame('***', data_get($trail->meta, 'payload.password_confirmation'));
    }
}
