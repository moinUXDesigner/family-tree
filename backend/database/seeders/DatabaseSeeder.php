<?php

namespace Database\Seeders;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $family = Family::query()->updateOrCreate(
            ['slug' => 'demo-family'],
            [
                'name' => 'Demo Family',
                'description' => 'Seed family used for local development and production smoke testing.',
                'is_active' => true,
            ],
        );

        $users = [
            [
                'name' => 'Super Admin',
                'email' => 'superadmin@familytree.test',
                'role' => User::ROLE_SUPER_ADMIN,
                'family_id' => null,
            ],
            [
                'name' => 'Family Admin',
                'email' => 'admin@familytree.test',
                'role' => User::ROLE_ADMIN,
                'family_id' => $family->id,
            ],
            [
                'name' => 'End User',
                'email' => 'user@familytree.test',
                'role' => User::ROLE_USER,
                'family_id' => $family->id,
            ],
        ];

        foreach ($users as $user) {
            User::query()->updateOrCreate(
                ['email' => $user['email']],
                [
                    'name' => $user['name'],
                    'password' => 'password123',
                    'role' => $user['role'],
                    'family_id' => $user['family_id'],
                    'approval_status' => User::APPROVAL_APPROVED,
                    'is_active' => true,
                ],
            );
        }

        $admin = User::query()->where('email', 'admin@familytree.test')->first();
        $endUser = User::query()->where('email', 'user@familytree.test')->first();

        $members = [
            [
                'first_name' => 'Amina',
                'last_name' => 'Khan',
                'gender' => 'female',
                'birth_date' => '1978-03-18',
                'email' => 'amina@example.com',
                'current_city' => 'Hyderabad',
                'current_country' => 'India',
                'notes' => 'Sample parent profile for validating member management.',
                'is_living' => true,
                'is_private' => false,
                'user_id' => null,
            ],
            [
                'first_name' => 'Omar',
                'last_name' => 'Khan',
                'gender' => 'male',
                'birth_date' => '1975-09-05',
                'current_city' => 'Mumbai',
                'current_country' => 'India',
                'notes' => 'Sample parent profile for validating member management.',
                'is_living' => true,
                'is_private' => false,
                'user_id' => null,
            ],
            [
                'first_name' => 'End',
                'last_name' => 'User',
                'gender' => null,
                'birth_date' => null,
                'email' => 'user@familytree.test',
                'current_city' => 'Bengaluru',
                'current_country' => 'India',
                'notes' => 'Linked to the default end-user login.',
                'is_living' => true,
                'is_private' => false,
                'user_id' => $endUser?->id,
            ],
        ];

        foreach ($members as $member) {
            FamilyMember::query()->updateOrCreate(
                [
                    'family_id' => $family->id,
                    'first_name' => $member['first_name'],
                    'last_name' => $member['last_name'],
                ],
                [
                    ...$member,
                    'family_id' => $family->id,
                    'created_by' => $admin?->id,
                ],
            );
        }

        $amina = FamilyMember::query()
            ->where('family_id', $family->id)
            ->where('first_name', 'Amina')
            ->where('last_name', 'Khan')
            ->first();
        $omar = FamilyMember::query()
            ->where('family_id', $family->id)
            ->where('first_name', 'Omar')
            ->where('last_name', 'Khan')
            ->first();
        $linkedUser = FamilyMember::query()
            ->where('family_id', $family->id)
            ->where('first_name', 'End')
            ->where('last_name', 'User')
            ->first();

        $relationships = [
            [
                'from_member_id' => $amina?->id,
                'to_member_id' => $omar?->id,
                'relationship_type' => FamilyRelationship::TYPE_SPOUSE,
                'notes' => 'Seed relationship for validating spouse links.',
            ],
            [
                'from_member_id' => $amina?->id,
                'to_member_id' => $linkedUser?->id,
                'relationship_type' => FamilyRelationship::TYPE_PARENT,
                'notes' => 'Seed relationship for validating parent-child links.',
            ],
            [
                'from_member_id' => $omar?->id,
                'to_member_id' => $linkedUser?->id,
                'relationship_type' => FamilyRelationship::TYPE_PARENT,
                'notes' => 'Seed relationship for validating parent-child links.',
            ],
        ];

        foreach ($relationships as $relationship) {
            if (! $relationship['from_member_id'] || ! $relationship['to_member_id']) {
                continue;
            }

            FamilyRelationship::query()->updateOrCreate(
                [
                    'family_id' => $family->id,
                    'from_member_id' => $relationship['from_member_id'],
                    'to_member_id' => $relationship['to_member_id'],
                    'relationship_type' => $relationship['relationship_type'],
                ],
                [
                    ...$relationship,
                    'family_id' => $family->id,
                    'created_by' => $admin?->id,
                ],
            );
        }
    }
}
