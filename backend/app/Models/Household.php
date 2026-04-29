<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'family_id',
    'name',
    'primary_person_id',
    'spouse_person_id',
    'created_by',
])]
class Household extends Model
{
    use HasFactory;

    public const ROLE_HUSBAND = 'husband';
    public const ROLE_WIFE = 'wife';
    public const ROLE_SPOUSE = 'spouse';
    public const ROLE_CHILD = 'child';
    public const ROLE_GUARDIAN = 'guardian';
    public const ROLE_OTHER = 'other';

    /**
     * @return BelongsTo<Family, $this>
     */
    public function family(): BelongsTo
    {
        return $this->belongsTo(Family::class);
    }

    /**
     * @return BelongsTo<FamilyMember, $this>
     */
    public function primaryPerson(): BelongsTo
    {
        return $this->belongsTo(FamilyMember::class, 'primary_person_id');
    }

    /**
     * @return BelongsTo<FamilyMember, $this>
     */
    public function spousePerson(): BelongsTo
    {
        return $this->belongsTo(FamilyMember::class, 'spouse_person_id');
    }

    /**
     * @return HasMany<HouseholdMember, $this>
     */
    public function members(): HasMany
    {
        return $this->hasMany(HouseholdMember::class);
    }

    /**
     * @return BelongsToMany<FamilyMember, $this>
     */
    public function memberRecords(): BelongsToMany
    {
        return $this->belongsToMany(FamilyMember::class, 'household_members', 'household_id', 'member_id')
            ->withPivot('role')
            ->withTimestamps();
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
