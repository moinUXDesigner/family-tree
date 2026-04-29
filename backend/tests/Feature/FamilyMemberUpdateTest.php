<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FamilyMemberUpdateTest extends TestCase
{
    use RefreshDatabase;

    public function test_admin_can_create_member_with_family_head_relationship(): void
    {
        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $admin = User::query()->create([
            'name' => 'Family Admin',
            'email' => 'admin@example.com',
            'password' => 'password123',
            'role' => User::ROLE_ADMIN,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $familyHead = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Nanne Saheb',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        Sanctum::actingAs($admin);

        $response = $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'birth_date' => '',
            'email' => '',
            'phone' => '',
            'current_city' => 'Kadapa',
            'current_country' => 'India',
            'family_head_id' => $familyHead->id,
            'relationship_to_family_head' => 'son',
            'marital_status' => 'unmarried',
            'living_status' => 'living',
            'is_living' => true,
            'is_private' => false,
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.member.first_name', 'Shaik')
            ->assertJsonPath('data.member.relation_to_family_head', 'son')
            ->assertJsonPath('data.family', null);

        $memberId = $response->json('data.member.id');

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $familyHead->id,
            'to_member_id' => $memberId,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
            'created_by' => $admin->id,
        ]);
    }

    public function test_admin_can_update_member_profile_fields_from_edit_form_aliases(): void
    {
        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $admin = User::query()->create([
            'name' => 'Family Admin',
            'email' => 'admin@example.com',
            'password' => 'password123',
            'role' => User::ROLE_ADMIN,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $familyHead = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Nanne Saheb',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        $member = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Old',
            'last_name' => 'Name',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        Sanctum::actingAs($admin);

        $response = $this->putJson("/api/v1/family-members/{$member->id}", [
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'birth_date' => '01-07-1947',
            'phone' => '08121990714',
            'current_city' => 'Kadapa',
            'current_country' => 'India',
            'family_head' => $familyHead->id,
            'relation' => 'son',
            'married_unmarried' => 'unmarried',
            'living_status' => 'deceased',
            'date_of_expiry' => '02-08-2020',
            'graveyard_location' => 'Kadapa graveyard',
            'is_private' => false,
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('data.member.first_name', 'Shaik')
            ->assertJsonPath('data.member.family_head_id', $familyHead->id)
            ->assertJsonPath('data.member.is_living', false);

        $this->assertDatabaseHas('family_members', [
            'id' => $member->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'birth_date' => '1947-07-01',
            'death_date' => '2020-08-02',
            'family_head_id' => $familyHead->id,
            'relation_to_family_head' => 'son',
            'marital_status' => 'unmarried',
            'graveyard_location' => 'Kadapa graveyard',
            'is_living' => false,
        ]);
    }

    public function test_updating_member_to_married_creates_family_in_member_name_once(): void
    {
        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $admin = User::query()->create([
            'name' => 'Family Admin',
            'email' => 'admin@example.com',
            'password' => 'password123',
            'role' => User::ROLE_ADMIN,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $member = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'marital_status' => 'unmarried',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        Sanctum::actingAs($admin);

        $payload = [
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
        ];

        $response = $this->putJson("/api/v1/family-members/{$member->id}", $payload);

        $response
            ->assertOk()
            ->assertJsonPath('data.member.marital_status', 'married')
            ->assertJsonPath('data.family.name', 'Shaik Madar Saheb Family');

        $this->assertDatabaseHas('families', [
            'name' => 'Shaik Madar Saheb Family',
            'slug' => 'shaik-madar-saheb-family',
            'description' => 'Family branch created for married member Shaik Madar Saheb.',
            'created_by' => $admin->id,
        ]);

        $this->putJson("/api/v1/family-members/{$member->id}", $payload)
            ->assertOk()
            ->assertJsonPath('data.family', null);

        $this->assertSame(
            1,
            Family::query()->where('name', 'Shaik Madar Saheb Family')->count()
        );
    }

    public function test_child_member_payload_displays_family_head_branch_family(): void
    {
        $rootFamily = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $branchFamily = Family::query()->create([
            'name' => 'Shaik Madar Saheb Family',
            'slug' => 'shaik-madar-saheb-family',
            'description' => 'Family branch created for married member Shaik Madar Saheb.',
            'is_active' => true,
        ]);

        $superAdmin = User::query()->create([
            'name' => 'Super Admin',
            'email' => 'superadmin@example.com',
            'password' => 'password123',
            'role' => User::ROLE_SUPER_ADMIN,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $madar = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Rahimatunnisa',
            'family_head_id' => $madar->id,
            'relation_to_family_head' => 'daughter',
            'marital_status' => 'married',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        Sanctum::actingAs($superAdmin);

        $this->getJson("/api/v1/family-members?family_id={$rootFamily->id}")
            ->assertOk()
            ->assertJsonFragment([
                'display_family_id' => $branchFamily->id,
                'display_family_name' => 'Shaik Madar Saheb Family',
                'family_head_name' => 'Shaik Madar Saheb',
                'relation_to_family_head' => 'daughter',
            ]);
    }
}
