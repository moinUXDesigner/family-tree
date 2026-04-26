<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'family_id',
    'from_member_id',
    'to_member_id',
    'relationship_type',
    'notes',
    'created_by',
])]
class FamilyRelationship extends Model
{
    use HasFactory;

    public const TYPE_PARENT = 'parent';
    public const TYPE_SPOUSE = 'spouse';
    public const TYPE_SIBLING = 'sibling';
    public const TYPE_GUARDIAN = 'guardian';

    /**
     * @return array<int, string>
     */
    public static function types(): array
    {
        return [
            self::TYPE_PARENT,
            self::TYPE_SPOUSE,
            self::TYPE_SIBLING,
            self::TYPE_GUARDIAN,
        ];
    }

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
    public function fromMember(): BelongsTo
    {
        return $this->belongsTo(FamilyMember::class, 'from_member_id');
    }

    /**
     * @return BelongsTo<FamilyMember, $this>
     */
    public function toMember(): BelongsTo
    {
        return $this->belongsTo(FamilyMember::class, 'to_member_id');
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
