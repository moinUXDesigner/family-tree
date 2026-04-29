<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'user_id',
    'family_id',
    'anchor_member_id',
    'claimed_member_id',
    'relationship_to_anchor',
    'status',
    'claimed_first_name',
    'claimed_last_name',
    'claimed_email',
    'claimed_phone',
    'evidence_notes',
    'resolved_by',
    'resolved_at',
])]
class FamilyConnectionRequest extends Model
{
    use HasFactory;

    public const STATUS_PENDING = 'pending';
    public const STATUS_APPROVED = 'approved';
    public const STATUS_REJECTED = 'rejected';

    /**
     * @return array<int, string>
     */
    public static function statuses(): array
    {
        return [
            self::STATUS_PENDING,
            self::STATUS_APPROVED,
            self::STATUS_REJECTED,
        ];
    }

    /**
     * @return array<int, string>
     */
    public static function relationshipOptions(): array
    {
        return [
            'child',
            'son',
            'daughter',
            'spouse',
            'wife',
            'husband',
            'parent',
            'father',
            'mother',
            'sibling',
            'brother',
            'sister',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
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
    public function anchorMember(): BelongsTo
    {
        return $this->belongsTo(FamilyMember::class, 'anchor_member_id');
    }

    /**
     * @return BelongsTo<FamilyMember, $this>
     */
    public function claimedMember(): BelongsTo
    {
        return $this->belongsTo(FamilyMember::class, 'claimed_member_id');
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function resolver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'resolved_by');
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'resolved_at' => 'datetime',
        ];
    }
}
