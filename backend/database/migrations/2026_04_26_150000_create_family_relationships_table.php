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
        Schema::create('family_relationships', function (Blueprint $table): void {
            $table->id();
            $table->foreignIdFor(Family::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(FamilyMember::class, 'from_member_id')->constrained('family_members')->cascadeOnDelete();
            $table->foreignIdFor(FamilyMember::class, 'to_member_id')->constrained('family_members')->cascadeOnDelete();
            $table->string('relationship_type', 32);
            $table->text('notes')->nullable();
            $table->foreignIdFor(User::class, 'created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->unique(
                ['family_id', 'from_member_id', 'to_member_id', 'relationship_type'],
                'family_relationship_unique'
            );
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('family_relationships');
    }
};
