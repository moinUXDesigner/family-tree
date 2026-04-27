<?php

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\FamilyRelationship;
use App\Models\User;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('family:reset-root', function (): int {
    $rootFamilySlug = 'shaik-nanne-saheb-family';
    $rootFirstName = 'Shaik';
    $rootLastName = 'Nanne Saheb';

    DB::transaction(function () use ($rootFamilySlug, $rootFirstName, $rootLastName): void {
        $superAdmin = User::query()
            ->where('role', User::ROLE_SUPER_ADMIN)
            ->orderBy('id')
            ->first();

        User::query()
            ->whereNotNull('family_id')
            ->update(['family_id' => null]);

        User::query()
            ->where('role', User::ROLE_USER)
            ->update(['approval_status' => User::APPROVAL_PENDING]);

        FamilyRelationship::query()->delete();
        FamilyMember::query()->delete();
        Family::query()->delete();

        $family = Family::query()->create([
            'name' => 'Shaik Nanne Saheb Family',
            'slug' => $rootFamilySlug,
            'description' => 'Family rooted at Shaik Nanne Saheb.',
            'is_active' => true,
            'created_by' => $superAdmin?->id,
        ]);

        FamilyMember::query()->create([
            'family_id' => $family->id,
            'first_name' => $rootFirstName,
            'last_name' => $rootLastName,
            'gender' => 'male',
            'notes' => 'Root member for this family tree.',
            'is_living' => false,
            'is_private' => false,
            'created_by' => $superAdmin?->id,
        ]);
    });

    $this->info('Family data reset. Only Shaik Nanne Saheb root family/member remains.');

    return self::SUCCESS;
})->purpose('Delete family tree data and recreate only the Shaik Nanne Saheb root member');
