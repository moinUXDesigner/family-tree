<?php

namespace App\Models;

use Database\Factories\FamilyMemberFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'family_id',
    'user_id',
    'first_name',
    'last_name',
    'gender',
    'birth_date',
    'birth_time',
    'death_date',
    'photo_path',
    'email',
    'phone',
    'current_city',
    'current_country',
    'family_head_id',
    'relation_to_family_head',
    'marital_status',
    'graveyard_location',
    'notes',
    'is_living',
    'is_private',
    'created_by',
])]
class FamilyMember extends Model
{
    /** @use HasFactory<FamilyMemberFactory> */
    use HasFactory;

    /**
     * @return BelongsTo<Family, $this>
     */
    public function family(): BelongsTo
    {
        return $this->belongsTo(Family::class);
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * @return BelongsTo<FamilyMember, $this>
     */
    public function familyHead(): BelongsTo
    {
        return $this->belongsTo(self::class, 'family_head_id');
    }

    /**
     * @return HasMany<FamilyRelationship, $this>
     */
    public function relationshipsFrom(): HasMany
    {
        return $this->hasMany(FamilyRelationship::class, 'from_member_id');
    }

    /**
     * @return HasMany<FamilyRelationship, $this>
     */
    public function relationshipsTo(): HasMany
    {
        return $this->hasMany(FamilyRelationship::class, 'to_member_id');
    }

    /**
     * @return HasMany<HouseholdMember, $this>
     */
    public function householdMemberships(): HasMany
    {
        return $this->hasMany(HouseholdMember::class, 'member_id');
    }

    /**
     * @return BelongsToMany<Household, $this>
     */
    public function households(): BelongsToMany
    {
        return $this->belongsToMany(Household::class, 'household_members', 'member_id', 'household_id')
            ->withPivot('role')
            ->withTimestamps();
    }

    /**
     * @return HasMany<FamilyConnectionRequest, $this>
     */
    public function anchoredConnectionRequests(): HasMany
    {
        return $this->hasMany(FamilyConnectionRequest::class, 'anchor_member_id');
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'birth_date' => 'date:Y-m-d',
            'death_date' => 'date:Y-m-d',
            'family_head_id' => 'integer',
            'is_living' => 'boolean',
            'is_private' => 'boolean',
        ];
    }
}
