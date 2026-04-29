<?php

use App\Models\Family;
use App\Models\FamilyMember;
use App\Models\User;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('households', function (Blueprint $table): void {
            $table->id();
            $table->foreignIdFor(Family::class)->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->foreignIdFor(FamilyMember::class, 'primary_person_id')
                ->nullable()
                ->constrained('family_members')
                ->nullOnDelete();
            $table->foreignIdFor(FamilyMember::class, 'spouse_person_id')
                ->nullable()
                ->constrained('family_members')
                ->nullOnDelete();
            $table->foreignIdFor(User::class, 'created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->index(['family_id', 'name']);
            $table->unique(
                ['family_id', 'primary_person_id', 'spouse_person_id'],
                'households_couple_unique'
            );
        });

        Schema::create('household_members', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('household_id')->constrained('households')->cascadeOnDelete();
            $table->foreignIdFor(FamilyMember::class, 'member_id')->constrained('family_members')->cascadeOnDelete();
            $table->string('role', 32);
            $table->foreignIdFor(User::class, 'created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->unique(['household_id', 'member_id'], 'household_members_unique');
            $table->index(['member_id', 'role']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('household_members');
        Schema::dropIfExists('households');
    }
};
