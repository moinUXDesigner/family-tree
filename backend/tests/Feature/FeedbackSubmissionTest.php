<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FeedbackSubmission;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FeedbackSubmissionTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_submit_feedback_notes(): void
    {
        [$family, $user] = $this->approvedUser();

        Sanctum::actingAs($user);

        $response = $this->postJson('/api/v1/feedback', [
            'notes' => 'The mobile tree should show the spouse card closer to self.',
            'source_url' => 'http://localhost:5173/app/tree',
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.feedback.status', FeedbackSubmission::STATUS_OPEN)
            ->assertJsonPath('data.feedback.has_screenshot', false);

        $this->assertDatabaseHas('feedback_submissions', [
            'user_id' => $user->id,
            'family_id' => $family->id,
            'role' => User::ROLE_USER,
            'notes' => 'The mobile tree should show the spouse card closer to self.',
            'source_url' => 'http://localhost:5173/app/tree',
            'status' => FeedbackSubmission::STATUS_OPEN,
        ]);
    }

    public function test_authenticated_user_can_submit_feedback_with_screenshot(): void
    {
        Storage::fake('public');
        [, $user] = $this->approvedUser();

        Sanctum::actingAs($user);

        $response = $this->post('/api/v1/feedback', [
            'notes' => 'Screenshot attached.',
            'screenshot' => $this->fakePngUpload(),
        ], [
            'Accept' => 'application/json',
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.feedback.has_screenshot', true);

        $feedback = FeedbackSubmission::query()->firstOrFail();

        $this->assertSame('family-tree-issue.png', $feedback->screenshot_original_name);
        $this->assertSame('image/png', $feedback->screenshot_mime_type);
        Storage::disk('public')->assertExists($feedback->screenshot_path);
    }

    public function test_feedback_requires_notes_or_screenshot(): void
    {
        [, $user] = $this->approvedUser();

        Sanctum::actingAs($user);

        $response = $this->postJson('/api/v1/feedback', [
            'notes' => '   ',
        ]);

        $response
            ->assertUnprocessable()
            ->assertJsonValidationErrors('notes');
    }

    public function test_super_admin_can_review_feedback_from_all_families(): void
    {
        [$firstFamily, $firstUser] = $this->approvedUser('Shaik Yasmeen', 'yasmeen@example.com');
        [$secondFamily, $secondUser] = $this->approvedUser('Syed Mushtaq', 'mushtaq@example.com');
        $superAdmin = $this->reviewer(User::ROLE_SUPER_ADMIN);

        FeedbackSubmission::query()->create([
            'user_id' => $firstUser->id,
            'family_id' => $firstFamily->id,
            'role' => User::ROLE_USER,
            'notes' => 'Tree screen is not showing full children list.',
            'status' => FeedbackSubmission::STATUS_OPEN,
        ]);
        FeedbackSubmission::query()->create([
            'user_id' => $secondUser->id,
            'family_id' => $secondFamily->id,
            'role' => User::ROLE_USER,
            'notes' => 'Please add PDF download.',
            'status' => FeedbackSubmission::STATUS_IN_REVIEW,
        ]);

        Sanctum::actingAs($superAdmin);

        $response = $this->getJson('/api/v1/feedback');

        $response
            ->assertOk()
            ->assertJsonPath('data.stats.total', 2)
            ->assertJsonPath('data.stats.open', 1)
            ->assertJsonPath('data.stats.in_review', 1)
            ->assertJsonCount(2, 'data.feedbacks');
    }

    public function test_admin_can_review_only_assigned_family_feedback(): void
    {
        [$assignedFamily, $assignedUser] = $this->approvedUser('Shaik Yasmeen', 'yasmeen@example.com');
        [$otherFamily, $otherUser] = $this->approvedUser('Syed Mushtaq', 'mushtaq@example.com');
        $admin = $this->reviewer(User::ROLE_ADMIN, $assignedFamily->id);

        FeedbackSubmission::query()->create([
            'user_id' => $assignedUser->id,
            'family_id' => $assignedFamily->id,
            'role' => User::ROLE_USER,
            'notes' => 'Assigned family feedback.',
            'status' => FeedbackSubmission::STATUS_OPEN,
        ]);
        FeedbackSubmission::query()->create([
            'user_id' => $otherUser->id,
            'family_id' => $otherFamily->id,
            'role' => User::ROLE_USER,
            'notes' => 'Other family feedback.',
            'status' => FeedbackSubmission::STATUS_OPEN,
        ]);

        Sanctum::actingAs($admin);

        $response = $this->getJson('/api/v1/feedback');

        $response
            ->assertOk()
            ->assertJsonCount(1, 'data.feedbacks')
            ->assertJsonPath('data.feedbacks.0.user_name', 'Shaik Yasmeen');
    }

    public function test_admin_can_update_assigned_family_feedback_status(): void
    {
        [$family, $user] = $this->approvedUser('Shaik Yasmeen', 'yasmeen@example.com');
        $admin = $this->reviewer(User::ROLE_ADMIN, $family->id);
        $feedback = FeedbackSubmission::query()->create([
            'user_id' => $user->id,
            'family_id' => $family->id,
            'role' => User::ROLE_USER,
            'notes' => 'Needs review.',
            'status' => FeedbackSubmission::STATUS_OPEN,
        ]);

        Sanctum::actingAs($admin);

        $response = $this->putJson("/api/v1/feedback/{$feedback->id}", [
            'status' => FeedbackSubmission::STATUS_RESOLVED,
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('data.feedback.status', FeedbackSubmission::STATUS_RESOLVED)
            ->assertJsonPath('data.feedback.status_label', 'Resolved');

        $this->assertDatabaseHas('feedback_submissions', [
            'id' => $feedback->id,
            'status' => FeedbackSubmission::STATUS_RESOLVED,
        ]);
    }

    /**
     * @return array{0: Family, 1: User}
     */
    private function approvedUser(string $name = 'Shaik Yasmeen', string $email = 'yasmeen@example.com'): array
    {
        $family = Family::query()->create([
            'name' => "{$name} Family",
            'slug' => str($name)->slug()->append('-family')->value(),
            'is_active' => true,
        ]);
        $user = User::query()->create([
            'name' => $name,
            'email' => $email,
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        return [$family, $user];
    }

    private function reviewer(string $role, ?int $familyId = null): User
    {
        return User::query()->create([
            'name' => $role === User::ROLE_SUPER_ADMIN ? 'Super Admin' : 'Family Admin',
            'email' => $role === User::ROLE_SUPER_ADMIN ? 'super@example.com' : 'admin@example.com',
            'password' => 'password123',
            'role' => $role,
            'family_id' => $familyId,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);
    }

    private function fakePngUpload(): UploadedFile
    {
        $png = base64_decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p9sAAAAASUVORK5CYII='
        );

        return UploadedFile::fake()->createWithContent('family-tree-issue.png', $png);
    }
}
