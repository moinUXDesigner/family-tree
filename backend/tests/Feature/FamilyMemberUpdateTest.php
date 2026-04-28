<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FamilyMemberUpdateTest extends TestCase
{
    use RefreshDatabase;

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
}
