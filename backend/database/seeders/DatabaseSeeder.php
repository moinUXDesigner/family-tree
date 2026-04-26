<?php

namespace Database\Seeders;

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
        $users = [
            [
                'name' => 'Super Admin',
                'email' => 'superadmin@familytree.test',
                'role' => User::ROLE_SUPER_ADMIN,
            ],
            [
                'name' => 'Family Admin',
                'email' => 'admin@familytree.test',
                'role' => User::ROLE_ADMIN,
            ],
            [
                'name' => 'End User',
                'email' => 'user@familytree.test',
                'role' => User::ROLE_USER,
            ],
        ];

        foreach ($users as $user) {
            User::query()->updateOrCreate(
                ['email' => $user['email']],
                [
                    'name' => $user['name'],
                    'password' => 'password123',
                    'role' => $user['role'],
                    'is_active' => true,
                ],
            );
        }
    }
}
