<?php

use App\Models\FamilyMember;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasColumn('family_members', 'family_head_id')) {
            Schema::table('family_members', function (Blueprint $table): void {
                $table->foreignIdFor(FamilyMember::class, 'family_head_id')
                    ->nullable()
                    ->after('current_country')
                    ->constrained('family_members')
                    ->nullOnDelete();
            });
        }

        if (! Schema::hasColumn('family_members', 'relation_to_family_head')) {
            Schema::table('family_members', function (Blueprint $table): void {
                $table->string('relation_to_family_head', 100)->nullable()->after('family_head_id');
            });
        }

        if (! Schema::hasColumn('family_members', 'marital_status')) {
            Schema::table('family_members', function (Blueprint $table): void {
                $table->string('marital_status', 50)->nullable()->after('relation_to_family_head');
            });
        }

        if (! Schema::hasColumn('family_members', 'graveyard_location')) {
            Schema::table('family_members', function (Blueprint $table): void {
                $table->string('graveyard_location')->nullable()->after('marital_status');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('family_members', 'family_head_id')) {
            Schema::table('family_members', function (Blueprint $table): void {
                $table->dropConstrainedForeignId('family_head_id');
            });
        }

        foreach (['relation_to_family_head', 'marital_status'] as $column) {
            if (Schema::hasColumn('family_members', $column)) {
                Schema::table('family_members', function (Blueprint $table) use ($column): void {
                    $table->dropColumn($column);
                });
            }
        }
    }
};
