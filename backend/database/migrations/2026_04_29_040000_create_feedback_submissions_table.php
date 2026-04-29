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
        Schema::create('feedback_submissions', function (Blueprint $table): void {
            $table->id();
            $table->foreignIdFor(User::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(Family::class)->nullable()->constrained()->nullOnDelete();
            $table->string('role', 32);
            $table->text('notes')->nullable();
            $table->string('screenshot_path')->nullable();
            $table->string('screenshot_original_name')->nullable();
            $table->string('screenshot_mime_type', 120)->nullable();
            $table->unsignedInteger('screenshot_size')->nullable();
            $table->string('source_url', 2048)->nullable();
            $table->string('status', 32)->default('open')->index();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('feedback_submissions');
    }
};
