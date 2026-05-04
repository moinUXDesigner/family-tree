<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('family_members', function (Blueprint $table): void {
            if (! Schema::hasColumn('family_members', 'birth_time')) {
                $table->time('birth_time')->nullable()->after('birth_date');
            }

            if (! Schema::hasColumn('family_members', 'photo_path')) {
                $table->string('photo_path', 2048)->nullable()->after('death_date');
            }
        });
    }

    public function down(): void
    {
        Schema::table('family_members', function (Blueprint $table): void {
            if (Schema::hasColumn('family_members', 'birth_time')) {
                $table->dropColumn('birth_time');
            }

            if (Schema::hasColumn('family_members', 'photo_path')) {
                $table->dropColumn('photo_path');
            }
        });
    }
};

