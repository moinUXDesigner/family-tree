<?php

use App\Models\FamilyMember;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('family_members', function (Blueprint $table): void {
            $table->foreignIdFor(FamilyMember::class, 'family_head_id')
                ->nullable()
                ->after('current_country')
                ->constrained('family_members')
                ->nullOnDelete();
            $table->string('relation_to_family_head', 100)->nullable()->after('family_head_id');
            $table->string('marital_status', 50)->nullable()->after('relation_to_family_head');
            $table->string('graveyard_location')->nullable()->after('marital_status');
        });
    }

    public function down(): void
    {
        Schema::table('family_members', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('family_head_id');
            $table->dropColumn([
                'relation_to_family_head',
                'marital_status',
                'graveyard_location',
            ]);
        });
    }
};
