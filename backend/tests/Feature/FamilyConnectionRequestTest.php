<?php

namespace Tests\Feature;

use App\Models\Family;
use App\Models\FamilyConnectionRequest;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FamilyConnectionRequestTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_submits_pending_connection_request_through_existing_member(): void
    {
        [$family, $anchor] = $this->rootFamilyWithAnchor();
        $user = User::query()->create([
            'name' => 'Shaik Ahmed',
            'email' => 'ahmed@example.com',
            'phone' => '9999999999',
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'approval_status' => User::APPROVAL_PENDING,
            'is_active' => true,
        ]);

        Sanctum::actingAs($user);

        $response = $this->postJson('/api/v1/family-connection', [
            'anchor_member_id' => $anchor->id,
            'relationship_to_anchor' => 'child',
            'evidence_notes' => 'My father can confirm.',
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('data.connection_request.anchor_member_id', $anchor->id)
            ->assertJsonPath('data.connection_request.status', FamilyConnectionRequest::STATUS_PENDING)
            ->assertJsonPath('data.approval_status', User::APPROVAL_PENDING);

        $this->assertDatabaseHas('family_connection_requests', [
            'user_id' => $user->id,
            'family_id' => $family->id,
            'anchor_member_id' => $anchor->id,
            'relationship_to_anchor' => 'child',
            'status' => FamilyConnectionRequest::STATUS_PENDING,
            'claimed_first_name' => 'Shaik',
            'claimed_last_name' => 'Ahmed',
        ]);

        $this->assertDatabaseMissing('family_members', [
            'user_id' => $user->id,
        ]);
    }

    public function test_super_admin_approval_creates_member_and_verified_relationship(): void
    {
        [$family, $anchor] = $this->rootFamilyWithAnchor();
        $superAdmin = User::query()->create([
            'name' => 'Super Admin',
            'email' => 'super@example.com',
            'phone' => '1111111111',
            'password' => 'password123',
            'role' => User::ROLE_SUPER_ADMIN,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);
        $user = User::query()->create([
            'name' => 'Shaik Ahmed',
            'email' => 'ahmed@example.com',
            'phone' => '9999999999',
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_PENDING,
            'is_active' => true,
        ]);

        FamilyConnectionRequest::query()->create([
            'user_id' => $user->id,
            'family_id' => $family->id,
            'anchor_member_id' => $anchor->id,
            'relationship_to_anchor' => 'child',
            'status' => FamilyConnectionRequest::STATUS_PENDING,
            'claimed_first_name' => 'Shaik',
            'claimed_last_name' => 'Ahmed',
            'claimed_email' => $user->email,
            'claimed_phone' => $user->phone,
        ]);

        Sanctum::actingAs($superAdmin);

        $response = $this->postJson("/api/v1/approval-requests/{$user->id}", [
            'approval_status' => User::APPROVAL_APPROVED,
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('data.user.approval_status', User::APPROVAL_APPROVED)
            ->assertJsonPath('data.user.anchor_member_id', $anchor->id);

        $member = FamilyMember::query()->where('user_id', $user->id)->firstOrFail();

        $this->assertDatabaseHas('family_connection_requests', [
            'user_id' => $user->id,
            'claimed_member_id' => $member->id,
            'status' => FamilyConnectionRequest::STATUS_APPROVED,
            'resolved_by' => $superAdmin->id,
        ]);

        $this->assertDatabaseHas('family_relationships', [
            'family_id' => $family->id,
            'from_member_id' => $anchor->id,
            'to_member_id' => $member->id,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
            'created_by' => $superAdmin->id,
        ]);
    }

    public function test_super_admin_approval_links_existing_member_instead_of_creating_duplicate(): void
    {
        [$family, $anchor] = $this->rootFamilyWithAnchor();
        $superAdmin = User::query()->create([
            'name' => 'Super Admin',
            'email' => 'super@example.com',
            'phone' => '1111111111',
            'password' => 'password123',
            'role' => User::ROLE_SUPER_ADMIN,
            'approval_status' => User::APPROVAL_APPROVED,
            'is_active' => true,
        ]);
        $existingMember = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Ahmed',
            'email' => 'ahmed@example.com',
            'phone' => '9999999999',
            'family_head_id' => $anchor->id,
            'relation_to_family_head' => 'son',
            'is_living' => true,
            'is_private' => false,
            'created_by' => $superAdmin->id,
        ]);
        FamilyRelationship::query()->create([
            'family_id' => $family->id,
            'from_member_id' => $anchor->id,
            'to_member_id' => $existingMember->id,
            'relationship_type' => FamilyRelationship::TYPE_PARENT,
            'created_by' => $superAdmin->id,
        ]);
        $user = User::query()->create([
            'name' => 'Shaik Ahmed',
            'email' => 'ahmed@example.com',
            'phone' => '9999999999',
            'password' => 'password123',
            'role' => User::ROLE_USER,
            'family_id' => $family->id,
            'approval_status' => User::APPROVAL_PENDING,
            'is_active' => true,
        ]);

        FamilyConnectionRequest::query()->create([
            'user_id' => $user->id,
            'family_id' => $family->id,
            'anchor_member_id' => $anchor->id,
            'relationship_to_anchor' => 'son',
            'status' => FamilyConnectionRequest::STATUS_PENDING,
            'claimed_first_name' => 'Shaik',
            'claimed_last_name' => 'Ahmed',
            'claimed_email' => $user->email,
            'claimed_phone' => $user->phone,
        ]);

        Sanctum::actingAs($superAdmin);

        $this->getJson('/api/v1/approval-requests')
            ->assertOk()
            ->assertJsonPath('data.users.0.suggested_member_id', $existingMember->id)
            ->assertJsonPath('data.users.0.claimable_members.0.id', $existingMember->id);

        $response = $this->postJson("/api/v1/approval-requests/{$user->id}", [
            'approval_status' => User::APPROVAL_APPROVED,
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('data.user.approval_status', User::APPROVAL_APPROVED)
            ->assertJsonPath('data.user.member_id', $existingMember->id);

        $this->assertSame(2, FamilyMember::query()->where('family_id', $family->id)->count());
        $this->assertDatabaseHas('family_members', [
            'id' => $existingMember->id,
            'user_id' => $user->id,
        ]);
        $this->assertDatabaseHas('family_connection_requests', [
            'user_id' => $user->id,
            'claimed_member_id' => $existingMember->id,
            'status' => FamilyConnectionRequest::STATUS_APPROVED,
            'resolved_by' => $superAdmin->id,
        ]);
    }

    /**
     * @return array{0: Family, 1: FamilyMember}
     */
    private function rootFamilyWithAnchor(): array
    {
        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => 'shaik-nanne-saheb-family',
            'is_active' => true,
        ]);
        $anchor = FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => 'Shaik',
            'last_name' => 'Madar Saheb',
            'is_living' => false,
            'is_private' => false,
        ]);

        return [$family, $anchor];
    }
}
