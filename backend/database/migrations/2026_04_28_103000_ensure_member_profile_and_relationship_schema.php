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
        Schema::table('family_members', function (Blueprint $table): void {
            if (! Schema::hasColumn('family_members', 'photo_path')) {
                $table->string('photo_path')->nullable()->after('death_date');
            }

            if (! Schema::hasColumn('family_members', 'family_head_id')) {
                $table->foreignIdFor(FamilyMember::class, 'family_head_id')
                    ->nullable()
                    ->after('current_country')
                    ->constrained('family_members')
                    ->nullOnDelete();
            }

            if (! Schema::hasColumn('family_members', 'relation_to_family_head')) {
                $table->string('relation_to_family_head', 100)->nullable()->after('family_head_id');
            }

            if (! Schema::hasColumn('family_members', 'marital_status')) {
                $table->string('marital_status', 50)->nullable()->after('relation_to_family_head');
            }

            if (! Schema::hasColumn('family_members', 'graveyard_location')) {
                $table->string('graveyard_location')->nullable()->after('marital_status');
            }
        });

        if (Schema::hasTable('family_relationships')) {
            Schema::table('family_relationships', function (Blueprint $table): void {
                if (! Schema::hasColumn('family_relationships', 'family_id')) {
                    $table->foreignIdFor(Family::class)->after('id')->constrained()->cascadeOnDelete();
                }

                if (! Schema::hasColumn('family_relationships', 'from_member_id')) {
                    $table->foreignIdFor(FamilyMember::class, 'from_member_id')
                        ->after('family_id')
                        ->constrained('family_members')
                        ->cascadeOnDelete();
                }

                if (! Schema::hasColumn('family_relationships', 'to_member_id')) {
                    $table->foreignIdFor(FamilyMember::class, 'to_member_id')
                        ->after('from_member_id')
                        ->constrained('family_members')
                        ->cascadeOnDelete();
                }

                if (! Schema::hasColumn('family_relationships', 'relationship_type')) {
                    $table->string('relationship_type', 32)->after('to_member_id');
                }

                if (! Schema::hasColumn('family_relationships', 'notes')) {
                    $table->text('notes')->nullable()->after('relationship_type');
                }

                if (! Schema::hasColumn('family_relationships', 'created_by')) {
                    $table->foreignIdFor(User::class, 'created_by')
                        ->nullable()
                        ->after('notes')
                        ->constrained('users')
                        ->nullOnDelete();
                }

                if (! Schema::hasColumn('family_relationships', 'created_at')) {
                    $table->timestamps();
                }
            });

            return;
        }

        if (! Schema::hasTable('family_relationships')) {
            Schema::create('family_relationships', function (Blueprint $table): void {
                $table->id();
                $table->foreignIdFor(Family::class)->constrained()->cascadeOnDelete();
                $table->foreignIdFor(FamilyMember::class, 'from_member_id')
                    ->constrained('family_members')
                    ->cascadeOnDelete();
                $table->foreignIdFor(FamilyMember::class, 'to_member_id')
                    ->constrained('family_members')
                    ->cascadeOnDelete();
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
    }

    public function down(): void
    {
        //
    }
};
