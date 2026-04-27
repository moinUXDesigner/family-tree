import { useEffect, useMemo, useState } from 'react';
import { LogOut, Search, ShieldCheck, Trash2, UserCheck, UserCog, UserX } from 'lucide-react';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card, Input } from '../app/components';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { familyApi } from '../services/familyApi.js';
import { userManagementApi } from '../services/userManagementApi.js';

const roleLabels = {
  [ROLES.SUPER_ADMIN]: 'Super Admin',
  [ROLES.ADMIN]: 'Admin',
  [ROLES.USER]: 'User',
};

const approvalLabels = {
  pending: 'Pending',
  approved: 'Approved',
  rejected: 'Rejected',
};

export function UsersPage() {
  const { logout, token, user: currentUser } = useAuth();
  const [users, setUsers] = useState([]);
  const [families, setFamilies] = useState([]);
  const [roles, setRoles] = useState(Object.values(ROLES));
  const [approvalStatuses, setApprovalStatuses] = useState(['pending', 'approved', 'rejected']);
  const [query, setQuery] = useState('');
  const [roleFilter, setRoleFilter] = useState('all');
  const [stateFilter, setStateFilter] = useState('all');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [busyUserId, setBusyUserId] = useState(null);

  useEffect(() => {
    let isMounted = true;

    async function loadData() {
      setIsLoading(true);
      setError('');

      try {
        const [userData, familyData] = await Promise.all([
          userManagementApi.listUsers(token),
          familyApi.listFamilies(token),
        ]);

        if (!isMounted) {
          return;
        }

        setUsers(userData.users);
        setRoles(userData.roles);
        setApprovalStatuses(userData.approval_statuses);
        setFamilies(familyData);
      } catch (loadError) {
        if (isMounted) {
          setError(loadError.message);
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    }

    loadData();

    return () => {
      isMounted = false;
    };
  }, [token]);

  const metrics = useMemo(() => ({
    total: users.length,
    active: users.filter((item) => item.is_active).length,
    blocked: users.filter((item) => !item.is_active).length,
    superAdmins: users.filter((item) => item.role === ROLES.SUPER_ADMIN).length,
  }), [users]);

  const filteredUsers = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();

    return users.filter((item) => {
      const matchesQuery = !normalizedQuery || [
        item.name,
        item.email,
        item.phone,
        item.family_name,
      ].filter(Boolean).some((value) => value.toLowerCase().includes(normalizedQuery));
      const matchesRole = roleFilter === 'all' || item.role === roleFilter;
      const matchesState =
        stateFilter === 'all' ||
        (stateFilter === 'active' && item.is_active) ||
        (stateFilter === 'blocked' && !item.is_active) ||
        item.approval_status === stateFilter;

      return matchesQuery && matchesRole && matchesState;
    });
  }, [query, roleFilter, stateFilter, users]);

  async function updateUser(targetUser, payload, message) {
    setError('');
    setSuccess('');
    setBusyUserId(targetUser.id);

    try {
      const updatedUser = await userManagementApi.updateUser(token, targetUser.id, payload);
      setUsers((current) => current.map((item) => (item.id === updatedUser.id ? updatedUser : item)));
      setSuccess(message);
    } catch (updateError) {
      setError(updateError.message);
    } finally {
      setBusyUserId(null);
    }
  }

  async function deleteUser(targetUser) {
    setError('');
    setSuccess('');
    setBusyUserId(targetUser.id);

    try {
      await userManagementApi.deleteUser(token, targetUser.id);
      setUsers((current) => current.filter((item) => item.id !== targetUser.id));
      setSuccess(`${targetUser.name} deleted.`);
    } catch (deleteError) {
      setError(deleteError.message);
    } finally {
      setBusyUserId(null);
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="users" role={ROLES.SUPER_ADMIN} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">Super Admin</Badge>
            <h1>User Management</h1>
            <p>Control account access, roles, family assignment, approval state, and blocked users.</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <section className="metric-grid" aria-label="User management summary">
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Total users</span>
            <strong>{metrics.total}</strong>
          </Card>
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Active</span>
            <strong>{metrics.active}</strong>
          </Card>
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Blocked</span>
            <strong>{metrics.blocked}</strong>
          </Card>
        </section>

        <Card padding="lg" variant="bordered">
          <div className="section-heading">
            <div>
              <h2>Accounts</h2>
              <p>{isLoading ? 'Loading users...' : `${filteredUsers.length} of ${users.length} users shown.`}</p>
            </div>
            <UserCog aria-hidden="true" />
          </div>

          <div className="user-tools">
            <Input
              label="Search users"
              leftIcon={<Search aria-hidden="true" size={18} />}
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              fullWidth
            />
            <label className="field-group">
              Role
              <select value={roleFilter} onChange={(event) => setRoleFilter(event.target.value)}>
                <option value="all">All roles</option>
                {roles.map((role) => (
                  <option key={role} value={role}>
                    {roleLabels[role] ?? role}
                  </option>
                ))}
              </select>
            </label>
            <label className="field-group">
              State
              <select value={stateFilter} onChange={(event) => setStateFilter(event.target.value)}>
                <option value="all">All states</option>
                <option value="active">Active</option>
                <option value="blocked">Blocked</option>
                {approvalStatuses.map((status) => (
                  <option key={status} value={status}>
                    {approvalLabels[status] ?? status}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <div className="member-list">
            {filteredUsers.map((targetUser) => {
              const isSelf = targetUser.id === currentUser.id;
              const isBusy = busyUserId === targetUser.id;

              return (
                <article className="member-row user-row" key={targetUser.id}>
                  <div className="member-avatar" aria-hidden="true">
                    {initials(targetUser.name)}
                  </div>
                  <div className="member-main">
                    <div className="member-title-line">
                      <strong>{targetUser.name}</strong>
                      {isSelf ? <Badge variant="info">You</Badge> : null}
                      <Badge variant={targetUser.is_active ? 'success' : 'error'}>
                        {targetUser.is_active ? 'Active' : 'Blocked'}
                      </Badge>
                      <Badge variant={roleBadge(targetUser.role)}>
                        {roleLabels[targetUser.role] ?? targetUser.role}
                      </Badge>
                      {targetUser.role === ROLES.USER ? (
                        <Badge variant={approvalBadge(targetUser.approval_status)}>
                          {approvalLabels[targetUser.approval_status] ?? targetUser.approval_status}
                        </Badge>
                      ) : null}
                    </div>
                    <p>{[targetUser.email, targetUser.phone].filter(Boolean).join(' | ')}</p>
                    <small>
                      {targetUser.family_name ?? 'No family linked'} | {targetUser.is_connected ? 'Connected' : 'Not connected'} | Sessions: {targetUser.active_sessions}
                    </small>
                  </div>
                  <div className="member-meta user-actions">
                    <label className="field-group compact-field">
                      Role
                      <select
                        disabled={isBusy}
                        value={targetUser.role}
                        onChange={(event) => updateUser(
                          targetUser,
                          { role: event.target.value },
                          `${targetUser.name} role updated.`,
                        )}
                      >
                        {roles.map((role) => (
                          <option key={role} value={role}>
                            {roleLabels[role] ?? role}
                          </option>
                        ))}
                      </select>
                    </label>

                    <label className="field-group compact-field">
                      Family
                      <select
                        disabled={isBusy}
                        value={targetUser.family_id ?? ''}
                        onChange={(event) => updateUser(
                          targetUser,
                          { family_id: event.target.value ? Number(event.target.value) : null },
                          `${targetUser.name} family updated.`,
                        )}
                      >
                        <option value="">No family</option>
                        {families.map((family) => (
                          <option key={family.id} value={family.id}>
                            {family.name}
                          </option>
                        ))}
                      </select>
                    </label>

                    {targetUser.role === ROLES.USER ? (
                      <label className="field-group compact-field">
                        Approval
                        <select
                          disabled={isBusy}
                          value={targetUser.approval_status}
                          onChange={(event) => updateUser(
                            targetUser,
                            { approval_status: event.target.value },
                            `${targetUser.name} approval updated.`,
                          )}
                        >
                          {approvalStatuses.map((status) => (
                            <option key={status} value={status}>
                              {approvalLabels[status] ?? status}
                            </option>
                          ))}
                        </select>
                      </label>
                    ) : null}

                    <Button
                      disabled={isBusy}
                      onClick={() => updateUser(
                        targetUser,
                        { is_active: !targetUser.is_active },
                        targetUser.is_active ? `${targetUser.name} blocked.` : `${targetUser.name} unblocked.`,
                      )}
                      size="sm"
                      type="button"
                      variant={targetUser.is_active ? 'outline' : 'primary'}
                    >
                      {targetUser.is_active ? <UserX aria-hidden="true" /> : <UserCheck aria-hidden="true" />}
                      {targetUser.is_active ? 'Block' : 'Unblock'}
                    </Button>

                    <Button
                      disabled={isBusy || isSelf}
                      onClick={() => deleteUser(targetUser)}
                      size="sm"
                      type="button"
                      variant="danger"
                    >
                      <Trash2 aria-hidden="true" />
                      Delete
                    </Button>
                  </div>
                </article>
              );
            })}

            {!isLoading && filteredUsers.length === 0 ? (
              <div className="empty-state compact">
                <ShieldCheck aria-hidden="true" />
                <strong>No users found</strong>
                <p>Adjust the search or filters to see more accounts.</p>
              </div>
            ) : null}
          </div>
        </Card>
      </section>
    </main>
  );
}

function roleBadge(role) {
  if (role === ROLES.SUPER_ADMIN) {
    return 'primary';
  }

  if (role === ROLES.ADMIN) {
    return 'secondary';
  }

  return 'neutral';
}

function approvalBadge(status) {
  if (status === 'approved') {
    return 'success';
  }

  if (status === 'rejected') {
    return 'error';
  }

  return 'warning';
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
