<?php

use App\Models\Family;
use App\Models\User;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('family_members', function (Blueprint $table): void {
            $table->id();
            $table->foreignIdFor(Family::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(User::class)->nullable()->constrained()->nullOnDelete();
            $table->string('first_name');
            $table->string('last_name')->nullable();
            $table->string('gender', 32)->nullable();
            $table->date('birth_date')->nullable();
            $table->date('death_date')->nullable();
            $table->string('email')->nullable();
            $table->string('phone')->nullable();
            $table->string('current_city')->nullable();
            $table->string('current_country')->nullable();
            $table->text('notes')->nullable();
            $table->boolean('is_living')->default(true);
            $table->boolean('is_private')->default(false);
            $table->foreignIdFor(User::class, 'created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('family_members');
    }
};
