<?php

namespace Database\Seeders;

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    private const ROOT_FAMILY_SLUG = 'shaik-nanne-saheb-family';
    private const ROOT_FIRST_NAME = 'Shaik';
    private const ROOT_LAST_NAME = 'Nanne Saheb';

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $superAdmin = User::query()->updateOrCreate(
            ['email' => 'superadmin@familytree.test'],
            [
                'name' => 'Super Admin',
                'password' => 'password123',
                'role' => User::ROLE_SUPER_ADMIN,
                'family_id' => null,
                'approval_status' => User::APPROVAL_APPROVED,
                'is_active' => true,
            ],
        );

        $family = Family::query()->updateOrCreate(
            ['slug' => self::ROOT_FAMILY_SLUG],
            [
                'name' => 'Shaik Nanne Saheb Family',
                'description' => 'Family rooted at Shaik Nanne Saheb.',
                'is_active' => true,
                'created_by' => $superAdmin->id,
            ],
        );

        FamilyMember::query()->updateOrCreate(
            [
                'family_id' => $family->id,
                'first_name' => self::ROOT_FIRST_NAME,
                'last_name' => self::ROOT_LAST_NAME,
            ],
            [
                'gender' => 'male',
                'notes' => 'Root member for this family tree.',
                'is_living' => false,
                'is_private' => false,
                'created_by' => $superAdmin->id,
            ],
        );
    }
}
