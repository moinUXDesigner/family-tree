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
        Schema::create('family_connection_requests', function (Blueprint $table): void {
            $table->id();
            $table->foreignIdFor(User::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(Family::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(FamilyMember::class, 'anchor_member_id')->constrained('family_members')->cascadeOnDelete();
            $table->foreignIdFor(FamilyMember::class, 'claimed_member_id')->nullable()->constrained('family_members')->nullOnDelete();
            $table->string('relationship_to_anchor', 50);
            $table->string('status', 32)->default('pending')->index();
            $table->string('claimed_first_name');
            $table->string('claimed_last_name')->nullable();
            $table->string('claimed_email')->nullable();
            $table->string('claimed_phone')->nullable();
            $table->text('evidence_notes')->nullable();
            $table->foreignIdFor(User::class, 'resolved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('resolved_at')->nullable();
            $table->timestamps();

            $table->unique('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('family_connection_requests');
    }
};
