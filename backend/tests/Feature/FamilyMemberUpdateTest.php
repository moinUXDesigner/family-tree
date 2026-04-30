<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\Household;
use App\Models\HouseholdMember;
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

    public function test_admin_can_add_spouse_without_creating_spouse_name_family(): void
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

        $madar = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'marital_status' => 'unmarried',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        Sanctum::actingAs($admin);

        $response = $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'add_member_type' => 'spouse',
            'existing_person_id' => $madar->id,
            'first_name' => 'Shaik',
            'last_name' => 'Chand Begum',
            'gender' => 'female',
            'marital_status' => 'married',
            'living_status' => 'living',
            'is_private' => false,
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.member.relation_to_family_head', 'spouse')
            ->assertJsonPath('data.family', null)
            ->assertJsonPath('data.household.name', 'Shaik Madar Saheb & Shaik Chand Begum Family');

        $spouseId = $response->json('data.member.id');
        $householdId = $response->json('data.household.id');

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $madar->id,
            'to_member_id' => $spouseId,
            'relationship_type' => FamilyRelationship::TYPE_SPOUSE,
            'created_by' => $admin->id,
        ]);

        $this->assertDatabaseHas('households', [
            'id' => $householdId,
            'family_id' => $family->id,
            'name' => 'Shaik Madar Saheb & Shaik Chand Begum Family',
            'primary_person_id' => $madar->id,
            'spouse_person_id' => $spouseId,
            'created_by' => $admin->id,
        ]);

        $this->assertDatabaseHas('household_members', [
            'household_id' => $householdId,
            'member_id' => $madar->id,
            'role' => Household::ROLE_HUSBAND,
        ]);

        $this->assertDatabaseHas('household_members', [
            'household_id' => $householdId,
            'member_id' => $spouseId,
            'role' => Household::ROLE_WIFE,
        ]);

        $this->assertSame(
            0,
            Family::query()->whereIn('name', [
                'Shaik Madar Saheb Family',
                'Shaik Chand Begum Family',
            ])->count()
        );
    }

    public function test_super_admin_can_load_members_from_legacy_branch_family_alias(): void
    {
        $rootFamily = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $branchFamily = Family::query()->create([
            'name' => 'Shaik Madar Saheb Family',
            'slug' => 'shaik-madar-saheb-family',
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
            'gender' => 'male',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        $chand = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Chand Begum',
            'gender' => 'female',
            'family_head_id' => $madar->id,
            'relation_to_family_head' => 'wife',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        $child = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Mynuddin',
            'gender' => 'male',
            'family_head_id' => $madar->id,
            'relation_to_family_head' => 'son',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        FamilyRelationship::query()->create([
            'family_id' => $rootFamily->id,
            'from_member_id' => $madar->id,
            'to_member_id' => $chand->id,
            'relationship_type' => FamilyRelationship::TYPE_SPOUSE,
            'created_by' => $superAdmin->id,
        ]);

        FamilyRelationship::query()->create([
            'family_id' => $rootFamily->id,
            'from_member_id' => $madar->id,
            'to_member_id' => $child->id,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
            'created_by' => $superAdmin->id,
        ]);

        Sanctum::actingAs($superAdmin);

        $this->getJson("/api/v1/family-members?family_id={$branchFamily->id}")
            ->assertOk()
            ->assertJsonFragment(['display_name' => 'Shaik Madar Saheb'])
            ->assertJsonFragment(['display_name' => 'Shaik Chand Begum'])
            ->assertJsonFragment(['display_name' => 'Shaik Mynuddin']);
    }

    public function test_cached_legacy_spouse_form_with_branch_family_stores_member_on_root_tree_household(): void
    {
        $rootFamily = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $branchFamily = Family::query()->create([
            'name' => 'Shaik Madar Saheb Family',
            'slug' => 'shaik-madar-saheb-family',
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
            'gender' => 'male',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        Sanctum::actingAs($superAdmin);

        $response = $this->postJson('/api/v1/family-members', [
            'family_id' => $branchFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Chand Begum',
            'gender' => 'female',
            'family_head_id' => $madar->id,
            'relationship_to_family_head' => 'wife',
            'marital_status' => 'married',
            'living_status' => 'deceased',
            'death_date' => '2014-04-01',
            'is_private' => false,
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.member.family_id', $rootFamily->id)
            ->assertJsonPath('data.member.family_head_id', $madar->id)
            ->assertJsonPath('data.member.relation_to_family_head', 'wife')
            ->assertJsonPath('data.household.name', 'Shaik Madar Saheb & Shaik Chand Begum Family')
            ->assertJsonPath('data.family', null);

        $spouseId = $response->json('data.member.id');

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $rootFamily->id,
            'from_member_id' => $madar->id,
            'to_member_id' => $spouseId,
            'relationship_type' => FamilyRelationship::TYPE_SPOUSE,
        ]);

        $this->assertDatabaseHas('households', [
            'family_id' => $rootFamily->id,
            'name' => 'Shaik Madar Saheb & Shaik Chand Begum Family',
            'primary_person_id' => $madar->id,
            'spouse_person_id' => $spouseId,
        ]);

        $this->assertDatabaseMissing('family_members', [
            'id' => $spouseId,
            'family_id' => $branchFamily->id,
        ]);
    }

    public function test_admin_assigned_legacy_branch_can_list_branch_members_and_add_spouse(): void
    {
        $rootFamily = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $branchFamily = Family::query()->create([
            'name' => 'Shaik Madar Saheb Family',
            'slug' => 'shaik-madar-saheb-family',
            'is_active' => true,
        ]);

        $admin = User::query()->create([
            'name' => 'Branch Admin',
            'email' => 'branch-admin@example.com',
            'password' => 'password123',
            'role' => User::ROLE_ADMIN,
            'family_id' => $branchFamily->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $madar = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        Sanctum::actingAs($admin);

        $this->getJson("/api/v1/family-members?family_id={$branchFamily->id}")
            ->assertOk()
            ->assertJsonFragment([
                'id' => $madar->id,
                'display_name' => 'Shaik Madar Saheb',
            ]);

        $response = $this->postJson('/api/v1/family-members', [
            'family_id' => $branchFamily->id,
            'add_member_type' => 'spouse',
            'existing_person_id' => $madar->id,
            'first_name' => 'Shaik',
            'last_name' => 'Chand Begum',
            'gender' => 'female',
            'marital_status' => 'married',
            'living_status' => 'living',
            'is_private' => false,
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.member.family_id', $rootFamily->id)
            ->assertJsonPath('data.household.name', 'Shaik Madar Saheb & Shaik Chand Begum Family');
    }

    public function test_user_assigned_legacy_branch_can_add_child_to_branch_household(): void
    {
        $rootFamily = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);

        $branchFamily = Family::query()->create([
            'name' => 'Shaik Madar Saheb Family',
            'slug' => 'shaik-madar-saheb-family',
            'is_active' => true,
        ]);

        $user = User::query()->create([
            'name' => 'Branch User',
            'email' => 'branch-user@example.com',
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'family_id' => $branchFamily->id,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);

        $madar = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $user->id,
        ]);

        $chand = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Chand Begum',
            'gender' => 'female',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $user->id,
        ]);

        $household = Household::query()->create([
            'family_id' => $rootFamily->id,
            'name' => 'Shaik Madar Saheb & Shaik Chand Begum Family',
            'primary_person_id' => $madar->id,
            'spouse_person_id' => $chand->id,
            'created_by' => $user->id,
        ]);

        HouseholdMember::query()->create([
            'household_id' => $household->id,
            'member_id' => $madar->id,
            'role' => Household::ROLE_HUSBAND,
            'created_by' => $user->id,
        ]);

        HouseholdMember::query()->create([
            'household_id' => $household->id,
            'member_id' => $chand->id,
            'role' => Household::ROLE_WIFE,
            'created_by' => $user->id,
        ]);

        Sanctum::actingAs($user);

        $this->getJson("/api/v1/households?family_id={$branchFamily->id}")
            ->assertOk()
            ->assertJsonFragment([
                'id' => $household->id,
                'name' => 'Shaik Madar Saheb & Shaik Chand Begum Family',
            ]);

        $response = $this->postJson('/api/v1/family-members', [
            'family_id' => $branchFamily->id,
            'add_member_type' => 'child',
            'household_id' => $household->id,
            'first_name' => 'Shaik',
            'last_name' => 'Tajuddin',
            'gender' => 'male',
            'living_status' => 'living',
            'is_private' => false,
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.member.family_id', $rootFamily->id)
            ->assertJsonPath('data.member.relation_to_family_head', 'son')
            ->assertJsonPath('data.household.id', $household->id);

        $childId = $response->json('data.member.id');

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $rootFamily->id,
            'from_member_id' => $madar->id,
            'to_member_id' => $childId,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
        ]);

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $rootFamily->id,
            'from_member_id' => $chand->id,
            'to_member_id' => $childId,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
        ]);
    }

    public function test_admin_can_add_child_to_household_and_link_both_parents(): void
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

        $madar = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        $chand = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Chand Begum',
            'gender' => 'female',
            'marital_status' => 'married',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $admin->id,
        ]);

        $household = Household::query()->create([
            'family_id' => $family->id,
            'name' => 'Shaik Madar Saheb & Shaik Chand Begum Family',
            'primary_person_id' => $madar->id,
            'spouse_person_id' => $chand->id,
            'created_by' => $admin->id,
        ]);

        HouseholdMember::query()->create([
            'household_id' => $household->id,
            'member_id' => $madar->id,
            'role' => Household::ROLE_HUSBAND,
            'created_by' => $admin->id,
        ]);

        HouseholdMember::query()->create([
            'household_id' => $household->id,
            'member_id' => $chand->id,
            'role' => Household::ROLE_WIFE,
            'created_by' => $admin->id,
        ]);

        Sanctum::actingAs($admin);

        $response = $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'add_member_type' => 'child',
            'household_id' => $household->id,
            'first_name' => 'Shaik',
            'last_name' => 'Mynuddin',
            'gender' => 'male',
            'living_status' => 'living',
            'is_private' => false,
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.member.family_head_id', $madar->id)
            ->assertJsonPath('data.member.relation_to_family_head', 'son')
            ->assertJsonPath('data.household.id', $household->id);

        $childId = $response->json('data.member.id');

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $madar->id,
            'to_member_id' => $childId,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
        ]);

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $chand->id,
            'to_member_id' => $childId,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
        ]);

        $this->assertDatabaseHas('household_members', [
            'household_id' => $household->id,
            'member_id' => $childId,
            'role' => Household::ROLE_CHILD,
        ]);
    }

    public function test_end_user_can_add_parent_and_sibling(): void
    {
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

        $child = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Ahmed',
            'gender' => 'male',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $user->id,
        ]);

        Sanctum::actingAs($user);

        $parentResponse = $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'add_member_type' => 'parent',
            'existing_person_id' => $child->id,
            'first_name' => 'Shaik',
            'last_name' => 'Rahman',
            'gender' => 'male',
            'living_status' => 'living',
            'is_private' => false,
        ]);

        $parentResponse
            ->assertCreated()
            ->assertJsonPath('data.member.relation_to_family_head', 'father');

        $parentId = $parentResponse->json('data.member.id');

        $siblingResponse = $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'add_member_type' => 'sibling',
            'existing_person_id' => $child->id,
            'first_name' => 'Shaik',
            'last_name' => 'Yasmeen',
            'gender' => 'female',
            'living_status' => 'living',
            'is_private' => false,
        ]);

        $siblingResponse
            ->assertCreated()
            ->assertJsonPath('data.member.relation_to_family_head', 'sister');

        $siblingId = $siblingResponse->json('data.member.id');

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $parentId,
            'to_member_id' => $child->id,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
        ]);

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $child->id,
            'to_member_id' => $siblingId,
            'relationship_type' => FamilyRelationship::TYPE_SIBLING,
        ]);
    }

    public function test_end_user_can_attach_existing_person_to_household_without_duplicate(): void
    {
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

        $parent = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'is_living' => false,
            'is_private' => false,
        ]);
        $child = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Ahmed',
            'family_head_id' => $parent->id,
            'relation_to_family_head' => 'son',
            'is_living' => true,
            'is_private' => false,
        ]);
        $household = Household::query()->create([
            'family_id' => $family->id,
            'name' => 'Shaik Madar Saheb Family',
            'primary_person_id' => $parent->id,
            'created_by' => $user->id,
        ]);

        Sanctum::actingAs($user);

        $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'add_member_type' => 'existing_to_household',
            'existing_person_id' => $child->id,
            'household_id' => $household->id,
            'is_private' => false,
        ])
            ->assertCreated()
            ->assertJsonPath('data.member.id', $child->id)
            ->assertJsonPath('data.household.id', $household->id);

        $this->assertSame(2, FamilyMember::query()->where('family_id', $family->id)->count());
        $this->assertDatabaseHas('household_members', [
            'household_id' => $household->id,
            'member_id' => $child->id,
            'role' => Household::ROLE_CHILD,
        ]);
    }

    public function test_duplicate_child_add_reuses_existing_member(): void
    {
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

        $parent = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'is_living' => false,
            'is_private' => false,
        ]);
        $household = Household::query()->create([
            'family_id' => $family->id,
            'name' => 'Shaik Madar Saheb Family',
            'primary_person_id' => $parent->id,
            'created_by' => $user->id,
        ]);
        $existingChild = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Ahmed',
            'gender' => 'male',
            'family_head_id' => $parent->id,
            'relation_to_family_head' => 'son',
            'is_living' => true,
            'is_private' => false,
        ]);

        Sanctum::actingAs($user);

        $this->postJson('/api/v1/family-members', [
            'family_id' => $family->id,
            'add_member_type' => 'child',
            'household_id' => $household->id,
            'first_name' => 'Shaik',
            'last_name' => 'Ahmed',
            'gender' => 'male',
            'living_status' => 'living',
            'is_private' => false,
        ])
            ->assertCreated()
            ->assertJsonPath('data.member.id', $existingChild->id);

        $this->assertSame(2, FamilyMember::query()->where('family_id', $family->id)->count());
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

    public function test_updating_member_to_married_does_not_create_member_name_family(): void
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
            ->assertJsonPath('data.family', null);

        $this->putJson("/api/v1/family-members/{$member->id}", $payload)
            ->assertOk()
            ->assertJsonPath('data.family', null);

        $this->assertSame(
            0,
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
