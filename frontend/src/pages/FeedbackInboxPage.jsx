import { useEffect, useMemo, useState } from 'react';
import {
  ChevronRight,
  ExternalLink,
  Image as ImageIcon,
  MessageSquareText,
  Search,
  SlidersHorizontal,
  Tag,
} from 'lucide-react';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert } from '../app/components';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { feedbackApi } from '../services/feedbackApi.js';

const backRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/tree',
  [ROLES.ADMIN]: '/admin/tree',
};

const statusTabs = [
  ['all', 'All'],
  ['open', 'New'],
  ['in_review', 'In Review'],
  ['resolved', 'Resolved'],
];

const statusActions = [
  ['open', 'New'],
  ['in_review', 'In Review'],
  ['resolved', 'Resolved'],
];

export function FeedbackInboxPage({ role }) {
  const { token } = useAuth();
  const [activeStatus, setActiveStatus] = useState('all');
  const [search, setSearch] = useState('');
  const [hasScreenshot, setHasScreenshot] = useState(false);
  const [feedbacks, setFeedbacks] = useState([]);
  const [stats, setStats] = useState({ total: 0, open: 0, in_review: 0, resolved: 0 });
  const [expandedId, setExpandedId] = useState(null);
  const [updatingId, setUpdatingId] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const backRoute = backRoutes[role] ?? '/';

  useEffect(() => {
    let isMounted = true;
    const timeoutId = window.setTimeout(async () => {
      setIsLoading(true);
      setError('');

      try {
        const data = await feedbackApi.listFeedback(token, {
          hasScreenshot,
          search,
          status: activeStatus,
        });

        if (isMounted) {
          setFeedbacks(data.feedbacks ?? []);
          setStats(data.stats ?? { total: 0, open: 0, in_review: 0, resolved: 0 });
        }
      } catch (loadError) {
        if (isMounted) {
          setError(loadError.message);
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    }, 220);

    return () => {
      isMounted = false;
      window.clearTimeout(timeoutId);
    };
  }, [activeStatus, hasScreenshot, search, token]);

  const tabCounts = useMemo(
    () => ({
      all: stats.total,
      open: stats.open,
      in_review: stats.in_review,
      resolved: stats.resolved,
    }),
    [stats],
  );

  async function updateStatus(feedbackId, nextStatus) {
    const previousStatus = feedbacks.find((item) => item.id === feedbackId)?.status;

    setUpdatingId(feedbackId);
    setError('');

    try {
      const updatedFeedback = await feedbackApi.updateFeedbackStatus(token, feedbackId, nextStatus);

      setFeedbacks((current) =>
        current
          .map((feedback) => (feedback.id === feedbackId ? updatedFeedback : feedback))
          .filter((feedback) => activeStatus === 'all' || feedback.status === activeStatus),
      );
      setStats((current) => rebalanceStats(current, previousStatus, nextStatus));
    } catch (updateError) {
      setError(updateError.message);
    } finally {
      setUpdatingId(null);
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="tree" mobileBackTo={backRoute} role={role} />

      <section className="dashboard-content feedback-inbox-content">
        <header className="feedback-inbox-header">
          <h1>User Feedbacks</h1>
          <p>Review issues, suggestions, and comments submitted by users.</p>
        </header>

        <div className="feedback-status-tabs" role="tablist" aria-label="Feedback status">
          {statusTabs.map(([value, label]) => (
            <button
              className={activeStatus === value ? 'active' : ''}
              key={value}
              onClick={() => setActiveStatus(value)}
              type="button"
            >
              {label}
              <span>{tabCounts[value] ?? 0}</span>
            </button>
          ))}
        </div>

        <div className="feedback-search-shell">
          <Search aria-hidden="true" />
          <input
            aria-label="Search feedbacks"
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search feedbacks..."
            value={search}
          />
          <button
            className={hasScreenshot ? 'active' : ''}
            onClick={() => setHasScreenshot((current) => !current)}
            type="button"
          >
            <SlidersHorizontal aria-hidden="true" />
            Filter
          </button>
        </div>

        {error ? <Alert variant="error">{error}</Alert> : null}

        <div className="feedback-inbox-list">
          {feedbacks.map((feedback) => (
            <FeedbackInboxCard
              feedback={feedback}
              isExpanded={expandedId === feedback.id}
              isUpdating={updatingId === feedback.id}
              key={feedback.id}
              onToggle={() => setExpandedId((current) => (current === feedback.id ? null : feedback.id))}
              onUpdateStatus={updateStatus}
            />
          ))}

          {!isLoading && feedbacks.length === 0 ? (
            <div className="feedback-inbox-empty">
              <MessageSquareText aria-hidden="true" />
              <strong>No feedback found</strong>
              <p>New user feedback will appear here after submission.</p>
            </div>
          ) : null}

          {isLoading ? (
            <div className="feedback-inbox-empty">
              <MessageSquareText aria-hidden="true" />
              <strong>Loading feedbacks...</strong>
            </div>
          ) : null}
        </div>
      </section>
    </main>
  );
}

function FeedbackInboxCard({ feedback, isExpanded, isUpdating, onToggle, onUpdateStatus }) {
  const category = categoryFor(feedback);

  return (
    <article className="feedback-inbox-card">
      <div className="feedback-card-main">
        <div className={`feedback-inbox-avatar ${category.value}`} aria-hidden="true">
          {initials(feedback.user_name)}
        </div>

        <div className="feedback-inbox-copy">
          <div className="feedback-inbox-title-row">
            <strong>{feedback.user_name}</strong>
            <span className={`feedback-status-badge ${feedback.status}`}>
              {feedback.status_label}
            </span>
          </div>

          <div className="feedback-inbox-meta">
            <Tag aria-hidden="true" />
            <span className={`feedback-category-badge ${category.value}`}>{category.label}</span>
            <span aria-hidden="true">.</span>
            <span>{formatSubmittedAt(feedback.created_at)}</span>
          </div>

          <p>{feedback.notes || 'Screenshot-only feedback.'}</p>

          <div className="feedback-inbox-counts">
            <span>
              <ImageIcon aria-hidden="true" />
              {feedback.screenshot_count} {pluralize('Screenshot', feedback.screenshot_count)}
            </span>
            <span aria-hidden="true">.</span>
            <span>
              <MessageSquareText aria-hidden="true" />
              {feedback.notes_count} {pluralize('Note', feedback.notes_count)}
            </span>
          </div>
        </div>

        {feedback.screenshot_url ? (
          <a
            className="feedback-inbox-thumb"
            href={feedback.screenshot_url}
            rel="noreferrer"
            target="_blank"
          >
            <img alt="" src={feedback.screenshot_url} />
          </a>
        ) : null}
      </div>

      {isExpanded ? (
        <div className="feedback-detail-panel">
          <dl>
            <div>
              <dt>Email</dt>
              <dd>{feedback.user_email ?? 'Not available'}</dd>
            </div>
            <div>
              <dt>Family</dt>
              <dd>{feedback.family_name ?? 'No family linked'}</dd>
            </div>
            <div>
              <dt>Submitted from</dt>
              <dd>
                {feedback.source_url ? (
                  <a href={feedback.source_url} rel="noreferrer" target="_blank">
                    Open page
                    <ExternalLink aria-hidden="true" />
                  </a>
                ) : (
                  'Not captured'
                )}
              </dd>
            </div>
          </dl>

          <div className="feedback-detail-notes">
            <strong>Notes</strong>
            <p>{feedback.notes || 'No notes were added.'}</p>
          </div>

          <div className="feedback-status-actions">
            {statusActions.map(([value, label]) => (
              <button
                className={feedback.status === value ? 'active' : ''}
                disabled={isUpdating || feedback.status === value}
                key={value}
                onClick={() => onUpdateStatus(feedback.id, value)}
                type="button"
              >
                {label}
              </button>
            ))}
          </div>
        </div>
      ) : null}

      <button className="feedback-detail-toggle" onClick={onToggle} type="button">
        {isExpanded ? 'Hide Details' : 'View Details'}
        <ChevronRight aria-hidden="true" />
      </button>
    </article>
  );
}

function rebalanceStats(stats, previousStatus, nextStatus) {
  if (!previousStatus || previousStatus === nextStatus) {
    return stats;
  }

  return {
    ...stats,
    [previousStatus]: Math.max(0, (stats[previousStatus] ?? 0) - 1),
    [nextStatus]: (stats[nextStatus] ?? 0) + 1,
  };
}

function categoryFor(feedback) {
  const text = `${feedback.category ?? ''} ${feedback.notes ?? ''}`.toLowerCase();

  if (text.includes('bug') || text.includes('issue') || text.includes('error') || text.includes('not showing')) {
    return { label: 'Bug', value: 'bug' };
  }

  if (text.includes('suggest') || text.includes('please add') || text.includes('option')) {
    return { label: 'Suggestion', value: 'suggestion' };
  }

  return { label: 'Feedback', value: 'feedback' };
}

function formatSubmittedAt(value) {
  if (!value) {
    return 'Date unavailable';
  }

  const submittedAt = new Date(value);
  const now = new Date();
  const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const startOfSubmitted = new Date(submittedAt.getFullYear(), submittedAt.getMonth(), submittedAt.getDate());
  const dayDelta = Math.round((startOfToday - startOfSubmitted) / 86400000);

  if (dayDelta === 0) {
    return `Today, ${submittedAt.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' })}`;
  }

  if (dayDelta === 1) {
    return 'Yesterday';
  }

  return submittedAt.toLocaleDateString([], {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
}

function pluralize(label, count) {
  return count === 1 ? label : `${label}s`;
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
