<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Password;
use Illuminate\Auth\Notifications\ResetPassword;
use Tests\TestCase;

class AuthPasswordFlowTest extends TestCase
{
    use RefreshDatabase;

    public function test_forgot_password_sends_reset_notification_for_existing_user(): void
    {
        Notification::fake();

        $user = User::factory()->create();

        $response = $this->postJson('/api/v1/forgot-password', [
            'email' => $user->email,
        ]);

        $response
            ->assertOk()
            ->assertJson([
                'status' => true,
                'data' => null,
            ]);

        Notification::assertSentTo($user, ResetPassword::class);
    }

    public function test_reset_password_updates_user_password_with_valid_token(): void
    {
        $user = User::factory()->create([
            'password' => 'OldPassword123',
        ]);

        $token = Password::broker()->createToken($user);

        $response = $this->postJson('/api/v1/reset-password', [
            'email' => $user->email,
            'token' => $token,
            'password' => 'NewPassword123',
            'password_confirmation' => 'NewPassword123',
        ]);

        $response
            ->assertOk()
            ->assertJson([
                'status' => true,
                'data' => null,
            ]);

        $user->refresh();

        $this->assertTrue(Hash::check('NewPassword123', $user->password));
    }

    public function test_change_password_requires_correct_current_password(): void
    {
        $user = User::factory()->create([
            'password' => 'CurrentPassword123',
        ]);

        $token = $user->createToken('web')->plainTextToken;

        $response = $this
            ->withHeader('Authorization', 'Bearer '.$token)
            ->postJson('/api/v1/change-password', [
                'current_password' => 'wrong-password',
                'password' => 'UpdatedPassword123',
                'password_confirmation' => 'UpdatedPassword123',
            ]);

        $response
            ->assertStatus(422)
            ->assertJsonValidationErrors(['current_password']);

        $user->refresh();

        $this->assertTrue(Hash::check('CurrentPassword123', $user->password));
    }

    public function test_change_password_updates_password_and_revokes_tokens(): void
    {
        $user = User::factory()->create([
            'password' => 'CurrentPassword123',
        ]);

        $token = $user->createToken('web')->plainTextToken;

        $response = $this
            ->withHeader('Authorization', 'Bearer '.$token)
            ->postJson('/api/v1/change-password', [
                'current_password' => 'CurrentPassword123',
                'password' => 'UpdatedPassword123',
                'password_confirmation' => 'UpdatedPassword123',
            ]);

        $response
            ->assertOk()
            ->assertJson([
                'status' => true,
                'data' => null,
            ]);

        $user->refresh();

        $this->assertTrue(Hash::check('UpdatedPassword123', $user->password));
        $this->assertDatabaseCount('personal_access_tokens', 0);
    }
}
