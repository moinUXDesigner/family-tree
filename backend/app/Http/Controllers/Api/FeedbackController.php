<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FeedbackSubmission;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class FeedbackController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $data = $request->validate([
            'status' => ['nullable', 'string', Rule::in(array_merge(['all', 'new'], FeedbackSubmission::statuses()))],
            'search' => ['nullable', 'string', 'max:120'],
            'has_screenshot' => ['nullable', 'boolean'],
        ]);

        $user = $request->user();
        $baseQuery = $this->scopedFeedbackQuery($user);
        $stats = [
            'total' => (clone $baseQuery)->count(),
            'open' => (clone $baseQuery)->where('status', FeedbackSubmission::STATUS_OPEN)->count(),
            'in_review' => (clone $baseQuery)->where('status', FeedbackSubmission::STATUS_IN_REVIEW)->count(),
            'resolved' => (clone $baseQuery)->where('status', FeedbackSubmission::STATUS_RESOLVED)->count(),
        ];

        $status = $this->normalizedStatus($data['status'] ?? 'all');
        $feedbackQuery = $this->scopedFeedbackQuery($user)
            ->with(['user:id,name,email,role,family_id', 'family:id,name'])
            ->latest();

        if ($status) {
            $feedbackQuery->where('status', $status);
        }

        if ($data['has_screenshot'] ?? false) {
            $feedbackQuery->whereNotNull('screenshot_path');
        }

        $search = trim((string) ($data['search'] ?? ''));

        if ($search !== '') {
            $feedbackQuery->where(function ($query) use ($search): void {
                $query
                    ->where('notes', 'like', "%{$search}%")
                    ->orWhere('source_url', 'like', "%{$search}%")
                    ->orWhereHas('user', function ($userQuery) use ($search): void {
                        $userQuery
                            ->where('name', 'like', "%{$search}%")
                            ->orWhere('email', 'like', "%{$search}%");
                    })
                    ->orWhereHas('family', function ($familyQuery) use ($search): void {
                        $familyQuery->where('name', 'like', "%{$search}%");
                    });
            });
        }

        return response()->json([
            'status' => true,
            'message' => 'Feedback submissions loaded.',
            'data' => [
                'feedbacks' => $feedbackQuery->limit(100)->get()->map(fn (FeedbackSubmission $feedback) => $this->feedbackPayload($feedback)),
                'stats' => $stats,
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'notes' => ['nullable', 'string', 'max:1000'],
            'screenshot' => ['nullable', 'image', 'mimes:jpg,jpeg,png', 'max:10240'],
            'source_url' => ['nullable', 'string', 'max:2048'],
        ]);

        $notes = trim((string) ($data['notes'] ?? ''));

        if (! $request->hasFile('screenshot') && $notes === '') {
            throw ValidationException::withMessages([
                'notes' => 'Please add feedback notes or attach a screenshot.',
            ]);
        }

        $user = $request->user();
        $file = $request->file('screenshot');
        $path = $file?->store('feedback-screenshots', 'public');

        $feedback = FeedbackSubmission::query()->create([
            'user_id' => $user->id,
            'family_id' => $user->family_id,
            'role' => $user->role,
            'notes' => $notes !== '' ? $notes : null,
            'screenshot_path' => $path,
            'screenshot_original_name' => $file?->getClientOriginalName(),
            'screenshot_mime_type' => $file?->getClientMimeType(),
            'screenshot_size' => $file?->getSize(),
            'source_url' => $data['source_url'] ?? null,
            'status' => FeedbackSubmission::STATUS_OPEN,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Feedback submitted. Thank you for helping improve the family tree.',
            'data' => [
                'feedback' => [
                    'id' => $feedback->id,
                    'status' => $feedback->status,
                    'has_screenshot' => (bool) $feedback->screenshot_path,
                    'created_at' => $feedback->created_at?->toISOString(),
                ],
            ],
        ], 201);
    }

    public function update(Request $request, FeedbackSubmission $feedbackSubmission): JsonResponse
    {
        $this->authorizeFeedbackAccess($request->user(), $feedbackSubmission);

        $data = $request->validate([
            'status' => ['required', 'string', Rule::in(FeedbackSubmission::statuses())],
        ]);

        $feedbackSubmission->update([
            'status' => $data['status'],
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Feedback status updated.',
            'data' => [
                'feedback' => $this->feedbackPayload($feedbackSubmission->refresh()->load(['user:id,name,email,role,family_id', 'family:id,name'])),
            ],
        ]);
    }

    private function scopedFeedbackQuery(User $user)
    {
        $query = FeedbackSubmission::query();

        if (! $user->hasRole(User::ROLE_SUPER_ADMIN)) {
            $query->where('family_id', $user->family_id ?: 0);
        }

        return $query;
    }

    private function authorizeFeedbackAccess(User $user, FeedbackSubmission $feedback): void
    {
        if ($user->hasRole(User::ROLE_SUPER_ADMIN)) {
            return;
        }

        if ($feedback->family_id && (int) $feedback->family_id === (int) $user->family_id) {
            return;
        }

        abort(403, 'You do not have permission to manage this feedback.');
    }

    private function normalizedStatus(string $status): ?string
    {
        return match ($status) {
            'new' => FeedbackSubmission::STATUS_OPEN,
            'open', 'in_review', 'resolved' => $status,
            default => null,
        };
    }

    /**
     * @return array<string, mixed>
     */
    private function feedbackPayload(FeedbackSubmission $feedback): array
    {
        $screenshotUrl = $feedback->screenshot_path
            ? Storage::disk('public')->url($feedback->screenshot_path)
            : null;

        return [
            'id' => $feedback->id,
            'user_id' => $feedback->user_id,
            'user_name' => $feedback->user?->name ?? 'Unknown user',
            'user_email' => $feedback->user?->email,
            'user_role' => $feedback->user?->role ?? $feedback->role,
            'family_id' => $feedback->family_id,
            'family_name' => $feedback->family?->name,
            'category' => 'feedback',
            'notes' => $feedback->notes,
            'notes_count' => $feedback->notes ? 1 : 0,
            'screenshot_count' => $feedback->screenshot_path ? 1 : 0,
            'screenshot_url' => $screenshotUrl,
            'screenshot_original_name' => $feedback->screenshot_original_name,
            'screenshot_size' => $feedback->screenshot_size,
            'source_url' => $feedback->source_url,
            'status' => $feedback->status,
            'status_label' => $this->statusLabel($feedback->status),
            'created_at' => $feedback->created_at?->toISOString(),
        ];
    }

    private function statusLabel(string $status): string
    {
        return match ($status) {
            FeedbackSubmission::STATUS_IN_REVIEW => 'In Review',
            FeedbackSubmission::STATUS_RESOLVED => 'Resolved',
            default => 'New',
        };
    }
}
