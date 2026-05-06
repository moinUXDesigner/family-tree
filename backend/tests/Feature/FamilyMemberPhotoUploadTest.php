<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FamilyMemberPhotoUploadTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_upload_photo_for_accessible_family_member(): void
    {
        Storage::fake('user_photos');

        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $user = User::query()->create([
            'name' => 'Family User',
            'email' => 'user@example.com',
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $member = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Accessible',
            'last_name' => 'Member',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $user->id,
        ]);

        Sanctum::actingAs($user);

        $response = $this->postJson("/api/v1/family-members/{$member->id}/photo", [
            'photo' => UploadedFile::fake()->image('member-photo.jpg'),
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('data.member.id', $member->id);

        $member->refresh();

        $this->assertNotNull($member->photo_path);
        Storage::disk('user_photos')->assertExists($member->photo_path);
    }

    public function test_user_cannot_upload_photo_for_inaccessible_family_member(): void
    {
        Storage::fake('user_photos');

        $familyA = Family::query()->create([
            'name' => 'Family A',
            'slug' => 'family-a',
            'is_active' => true,
        ]);

        $familyB = Family::query()->create([
            'name' => 'Family B',
            'slug' => 'family-b',
            'is_active' => true,
        ]);

        $user = User::query()->create([
            'name' => 'Family User',
            'email' => 'user@example.com',
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'family_id' => $familyA->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $member = FamilyMember::query()->create([
            'family_id' => $familyB->id,
            'first_name' => 'Blocked',
            'last_name' => 'Member',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $user->id,
        ]);

        Sanctum::actingAs($user);

        $this->postJson("/api/v1/family-members/{$member->id}/photo", [
            'photo' => UploadedFile::fake()->image('member-photo.jpg'),
        ])->assertForbidden();
    }
}
