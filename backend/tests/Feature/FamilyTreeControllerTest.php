<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FamilyTreeControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_family_tree_uses_explicit_family_head_as_root_before_spouse(): void
    {
        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
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

        $nanne = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Nanne Saheb',
            'gender' => 'male',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        $amina = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Amina Bee',
            'gender' => 'female',
            'family_head_id' => $nanne->id,
            'relation_to_family_head' => 'wife',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        $child = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'gender' => 'male',
            'family_head_id' => $nanne->id,
            'relation_to_family_head' => 'son',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        FamilyRelationship::query()->create([
            'family_id' => $family->id,
            'from_member_id' => $nanne->id,
            'to_member_id' => $amina->id,
            'relationship_type' => FamilyRelationship::TYPE_SPOUSE,
            'created_by' => $superAdmin->id,
        ]);

        FamilyRelationship::query()->create([
            'family_id' => $family->id,
            'from_member_id' => $nanne->id,
            'to_member_id' => $child->id,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
            'created_by' => $superAdmin->id,
        ]);

        Sanctum::actingAs($superAdmin);

        $this->getJson("/api/v1/family-tree?family_id={$family->id}")
            ->assertOk()
            ->assertJsonPath('data.root_member_ids.0', $nanne->id)
            ->assertJsonFragment([
                'from_member_id' => $nanne->id,
                'to_member_id' => $child->id,
                'relationship_type' => FamilyRelationship::TYPE_PARENT,
            ]);
    }

    public function test_family_tree_loads_legacy_branch_family_members_from_root_tree(): void
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

        $yasmeen = FamilyMember::query()->create([
            'family_id' => $rootFamily->id,
            'first_name' => 'Shaik',
            'last_name' => 'Yasmeen',
            'gender' => 'female',
            'family_head_id' => $madar->id,
            'relation_to_family_head' => 'daughter',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);

        Sanctum::actingAs($superAdmin);

        $this->getJson("/api/v1/family-tree?family_id={$branchFamily->id}")
            ->assertOk()
            ->assertJsonPath('data.family.name', 'Shaik Madar Saheb Family')
            ->assertJsonPath('data.root_member_ids.0', $madar->id)
            ->assertJsonFragment([
                'id' => $madar->id,
                'name' => 'Shaik Madar Saheb',
            ])
            ->assertJsonFragment([
                'id' => $chand->id,
                'name' => 'Shaik Chand Begum',
            ])
            ->assertJsonFragment([
                'id' => $yasmeen->id,
                'name' => 'Shaik Yasmeen',
            ])
            ->assertJsonFragment([
                'from_member_id' => $madar->id,
                'to_member_id' => $chand->id,
                'relationship_type' => FamilyRelationship::TYPE_SPOUSE,
            ])
            ->assertJsonFragment([
                'from_member_id' => $madar->id,
                'to_member_id' => $yasmeen->id,
                'relationship_type' => FamilyRelationship::TYPE_PARENT,
            ]);
    }
}
