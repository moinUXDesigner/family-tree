import { useEffect, useState } from 'react';
import { LogOut, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card } from '../app/components';
import { familyApi } from '../services/familyApi.js';
import { activityApi } from '../services/activityApi.js';

export function ActivityPage({ role }) {
  const { logout, token, user } = useAuth();
  const [families, setFamilies] = useState([]);
  const [familyId, setFamilyId] = useState('');
  const [activities, setActivities] = useState([]);
  const [memberDirectoryByFamily, setMemberDirectoryByFamily] = useState({});
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setIsLoading(true);
      try {
        const nextFamilies = await familyApi.listFamilies(token);
        setFamilies(nextFamilies);
        setFamilyId('');
        const rows = await activityApi.listActivities(token, '');
        setActivities(rows);
        const fallbackFamilyId = role === ROLES.ADMIN ? String(user?.family_id || rows[0]?.family_id || '') : '';
        if (fallbackFamilyId) {
          await hydrateFamilyMemberDirectory(fallbackFamilyId);
        }
      } catch (loadError) {
        setError(loadError.message);
      } finally {
        setIsLoading(false);
      }
    }

    load();
  }, [role, token, user?.family_id]);

  async function onFamilyChange(nextFamilyId) {
    setFamilyId(nextFamilyId);
    setIsLoading(true);
    try {
      const rows = await activityApi.listActivities(token, nextFamilyId);
      setActivities(rows);
      if (nextFamilyId) {
        await hydrateFamilyMemberDirectory(nextFamilyId);
      }
    } catch (loadError) {
      setError(loadError.message);
    } finally {
      setIsLoading(false);
    }
  }

  async function hydrateFamilyMemberDirectory(targetFamilyId) {
    if (!targetFamilyId || memberDirectoryByFamily[targetFamilyId]) {
      return;
    }

    try {
      const members = await familyApi.listMembers(token, targetFamilyId);
      const directory = members.reduce((accumulator, member) => {
        accumulator[String(member.id)] = {
          name: member.display_name || [member.first_name, member.last_name].filter(Boolean).join(' ') || null,
          household: member.household_name || null,
          relationship: member.relation_to_family_head || null,
        };
        return accumulator;
      }, {});
      setMemberDirectoryByFamily((current) => ({
        ...current,
        [targetFamilyId]: directory,
      }));
    } catch {
      // Keep logs usable even when member lookup fails.
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="activity" role={role} />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <h1>Activity</h1>
            <p>Audit trail for changes in this application.</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}

        {role === ROLES.SUPER_ADMIN && families.length > 1 ? (
          <Card padding="md" variant="bordered">
            <label className="field-group tree-family-select">
              Family
              <select value={familyId} onChange={(event) => onFamilyChange(event.target.value)}>
                <option value="">All</option>
                {families.map((family) => (
                  <option key={family.id} value={family.id}>
                    {family.name}
                  </option>
                ))}
              </select>
            </label>
          </Card>
        ) : null}

        <Card padding="lg" variant="elevated">
          <div className="member-list">
            {isLoading ? (
              [...Array(6)].map((_, index) => (
                <article className="member-row member-row-skeleton" key={`activity-skeleton-${index}`}>
                  <div className="member-avatar member-skeleton-block" aria-hidden="true" />
                  <div className="member-main">
                    <div className="member-title-line">
                      <span className="member-skeleton-line medium" />
                      <span className="member-skeleton-pill" />
                    </div>
                    <small className="member-skeleton-line long" />
                    <small className="member-skeleton-line medium" />
                  </div>
                </article>
              ))
            ) : null}
            {activities.map((activity) => (
              <article className="member-row" key={activity.id}>
                {(() => {
                  const presentation = buildActivityPresentation(
                    activity,
                    memberDirectoryByFamily[String(activity.family_id)] || {},
                  );

                  return (
                    <>
                      <div className="member-avatar" aria-hidden="true">
                        <ShieldCheck size={20} />
                      </div>
                      <div className="member-main">
                        <div className="member-title-line">
                          <strong>
                            {presentation.actor} {presentation.actionText}
                            {presentation.memberName ? (
                              <>
                                {' '}
                                &apos;<span style={{ fontWeight: 700 }}>{presentation.memberName}</span>&apos;
                              </>
                            ) : null}
                            {presentation.householdName && presentation.action === 'member_added' ? ` to ${presentation.householdName}` : ''}
                          </strong>
                          <Badge variant="neutral">{presentation.category}</Badge>
                        </div>
                        <small>
                          Role: {formatRole(activity.user_role)} | {formatDateTime(activity.created_at)}
                        </small>
                        <details style={{ marginTop: '0.35rem' }}>
                          <summary style={{ cursor: 'pointer', color: 'var(--color-muted-foreground, #667085)', fontSize: '0.85rem' }}>
                            Technical details
                          </summary>
                          <small style={{ display: 'block', marginTop: '0.35rem', color: 'var(--color-muted-foreground, #667085)' }}>
                            {(activity.method || 'UNKNOWN').toUpperCase()} {activity.path || '-'}
                          </small>
                          {presentation.memberId ? (
                            <small style={{ display: 'block', marginTop: '0.25rem', color: 'var(--color-muted-foreground, #667085)' }}>
                              Member ID: {presentation.memberId}
                            </small>
                          ) : null}
                          {presentation.relationship ? (
                            <small style={{ display: 'block', marginTop: '0.25rem', color: 'var(--color-muted-foreground, #667085)' }}>
                              Relationship: {presentation.relationship}
                            </small>
                          ) : null}
                          {presentation.rawPayload ? (
                            <small style={{ display: 'block', marginTop: '0.25rem', color: 'var(--color-muted-foreground, #667085)', whiteSpace: 'pre-wrap' }}>
                              Payload: {presentation.rawPayload}
                            </small>
                          ) : null}
                        </details>
                      </div>
                    </>
                  );
                })()}
              </article>
            ))}
            {!isLoading && activities.length === 0 ? (
              <div className="empty-state">
                <ShieldCheck aria-hidden="true" />
                <strong>No activity yet</strong>
                <p>Activity logs will appear here once users perform actions.</p>
              </div>
            ) : null}
          </div>
        </Card>
      </section>
    </main>
  );
}

function activityCategoryLabel(activity) {
  const action = detectAction(activity);

  return {
    login: 'Login',
    logout: 'Logout',
    member_added: 'Member Added',
    member_removed: 'Member Removed',
    member_updated: 'Member Updated',
  }[action] ?? 'Activity';
}

function buildActivityTitle(activity) {
  const actor = activity.user_name || formatRole(activity.user_role);
  const action = detectAction(activity);

  if (action === 'login') return `${actor} logged in`;
  if (action === 'logout') return `${actor} logged out`;
  if (action === 'member_added') return `${actor} added a family member`;
  if (action === 'member_removed') return `${actor} removed a family member`;
  if (action === 'member_updated') return `${actor} updated family member details`;
  if (action === 'approval') return `${actor} approved a member`;
  return `${actor} performed an activity`;
}

function detectAction(activity) {
  const method = String(activity.method || '').toUpperCase();
  const path = String(activity.path || '').toLowerCase();

  if (method === 'POST' && path.includes('/login')) {
    return 'login';
  }

  if (method === 'POST' && path.includes('/logout')) {
    return 'logout';
  }

  if (method === 'POST' && path.includes('/family-members')) {
    return 'member_added';
  }

  if (method === 'PUT' && path.includes('/family-members/') && path.includes('/soft-delete')) {
    return 'member_removed';
  }

  if (method === 'PUT' && path.includes('/family-members/')) {
    return 'member_updated';
  }

  if (method === 'DELETE' && path.includes('/family-members/')) {
    return 'member_removed';
  }

  if (method === 'PUT' && path.includes('/approvals/')) {
    return 'approval';
  }

  return 'other';
}

function buildActivityPresentation(activity, familyDirectory) {
  const action = detectAction(activity);
  const payload = activity?.meta?.payload ?? {};
  const memberIdFromPath = extractMemberIdFromPath(activity.path);
  const payloadMemberId = String(payload.member_id || payload.family_member_id || '');
  const memberId = memberIdFromPath || payloadMemberId || '';
  const payloadName = extractMemberNameFromPayload(payload);
  const directoryMatch = memberId ? familyDirectory[String(memberId)] : null;
  const memberName = payloadName || directoryMatch?.name || '';
  const householdName = payload.household_name || directoryMatch?.household || '';
  const relationship = payload.relationship_to_family_head || payload.relation_to_family_head || payload.add_member_type || directoryMatch?.relationship || '';
  const actor = activity.user_name || formatRole(activity.user_role);
  const category = activityCategoryLabel(activity);
  const rawPayload = payload && Object.keys(payload).length > 0 ? JSON.stringify(payload) : '';
  const actionText = {
    login: 'logged in',
    logout: 'logged out',
    member_added: 'added family member',
    member_removed: 'removed family member',
    member_updated: 'updated',
    approval: 'approved member',
  }[action] ?? 'performed an activity';

  return {
    action,
    category,
    actor,
    actionText,
    memberName,
    memberId,
    householdName,
    relationship,
    rawPayload,
  };
}

function extractMemberIdFromPath(path) {
  const match = String(path || '').match(/family-members\/(\d+)/i);
  return match?.[1] ?? '';
}

function extractMemberNameFromPayload(payload) {
  const fullName = String(
    payload.member_name
      || payload.display_name
      || payload.name
      || payload.full_name
      || '',
  ).trim();
  if (fullName) {
    return fullName;
  }

  const firstName = String(payload.first_name || '').trim();
  const lastName = String(payload.last_name || '').trim();
  return [firstName, lastName].filter(Boolean).join(' ');
}

function formatRole(rawRole) {
  const role = String(rawRole || '').toLowerCase();

  if (role === 'super_admin') {
    return 'Super Admin';
  }

  if (role === 'admin') {
    return 'Admin';
  }

  if (role === 'user' || role === 'end_user') {
    return 'End User';
  }

  return rawRole || 'Unknown';
}

function formatDateTime(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return 'Unknown time';
  }

  return date.toLocaleString(undefined, {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
  });
}
