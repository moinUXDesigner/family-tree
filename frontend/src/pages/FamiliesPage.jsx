import { useEffect, useMemo, useState } from 'react';
import { LogOut, Plus, ShieldCheck, Trash2, UsersRound } from 'lucide-react';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card, Input } from '../app/components';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { approvalApi } from '../services/approvalApi.js';
import { familyApi } from '../services/familyApi.js';

const emptyFamilyForm = {
  name: '',
  description: '',
};

export function FamiliesPage() {
  const { logout, token } = useAuth();
  const [families, setFamilies] = useState([]);
  const [requests, setRequests] = useState([]);
  const [form, setForm] = useState(emptyFamilyForm);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const totalMembers = useMemo(
    () => families.reduce((total, family) => total + Number(family.members_count ?? 0), 0),
    [families],
  );

  useEffect(() => {
    let isMounted = true;

    async function loadData() {
      setIsLoading(true);
      setError('');

      try {
        const [nextFamilies, nextRequests] = await Promise.all([
          familyApi.listFamilies(token),
          approvalApi.listRequests(token),
        ]);

        if (!isMounted) {
          return;
        }

        setFamilies(nextFamilies);
        setRequests(nextRequests);
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

  async function handleCreateFamily(event) {
    event.preventDefault();
    setError('');
    setSuccess('');
    setIsSubmitting(true);

    try {
      const family = await familyApi.createFamily(token, {
        name: form.name,
        description: form.description || null,
        is_active: true,
      });

      setFamilies((current) => [...current, family].sort(sortFamilies));
      setForm(emptyFamilyForm);
      setSuccess('Family created.');
    } catch (createError) {
      setError(createError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  async function handleDeleteFamily(family) {
    setError('');
    setSuccess('');

    try {
      await familyApi.deleteFamily(token, family.id);
      setFamilies((current) => current.filter((item) => item.id !== family.id));
      setSuccess('Family deleted.');
    } catch (deleteError) {
      setError(deleteError.message);
    }
  }

  async function updateApproval(request, approvalStatus) {
    setError('');
    setSuccess('');

    try {
      await approvalApi.updateRequest(token, request.id, approvalStatus);
      setRequests((current) => current.filter((item) => item.id !== request.id));
      setSuccess(
        approvalStatus === 'approved'
          ? `${request.name} approved for family access.`
          : `${request.name} request rejected.`,
      );
    } catch (approvalError) {
      setError(approvalError.message);
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="families" role={ROLES.SUPER_ADMIN} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">Super Admin</Badge>
            <h1>Families</h1>
            <p>Review all families, create new family spaces, and approve member access requests.</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <section className="metric-grid" aria-label="Family platform summary">
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Families</span>
            <strong>{families.length}</strong>
          </Card>
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Members</span>
            <strong>{totalMembers}</strong>
          </Card>
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Pending approvals</span>
            <strong>{requests.length}</strong>
          </Card>
        </section>

        <Card padding="lg" variant="bordered">
          <div className="section-heading">
            <div>
              <h2>Pending access requests</h2>
              <p>{isLoading ? 'Loading requests...' : `${requests.length} users waiting for approval.`}</p>
            </div>
            <ShieldCheck aria-hidden="true" />
          </div>

          <div className="member-list">
            {requests.map((request) => (
              <article className="member-row" key={request.id}>
                <div className="member-avatar" aria-hidden="true">
                  {initials(request.name)}
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <strong>{request.name}</strong>
                    <Badge variant="neutral">{request.family_name ?? 'No family linked'}</Badge>
                    <Badge variant="primary">
                      {request.relationship_label
                        ? `Relation: ${request.relationship_label}`
                        : 'Relation not selected'}
                    </Badge>
                  </div>
                  <p>{request.email}</p>
                  <small>Status: {request.approval_status}</small>
                </div>
                <div className="member-meta">
                  <Button onClick={() => updateApproval(request, 'approved')} type="button">
                    Approve
                  </Button>
                  <button
                    className="text-action danger"
                    onClick={() => updateApproval(request, 'rejected')}
                    type="button"
                  >
                    Reject
                  </button>
                </div>
              </article>
            ))}

            {!isLoading && requests.length === 0 ? (
              <div className="empty-state compact">
                <ShieldCheck aria-hidden="true" />
                <strong>No pending approvals</strong>
                <p>New member signups will appear here after they connect to the root.</p>
              </div>
            ) : null}
          </div>
        </Card>

        <Card padding="lg" variant="elevated">
          <div className="section-heading">
            <div>
              <h2>Create family</h2>
              <p>Add another family group that Super Admins can manage.</p>
            </div>
          </div>

          <form className="member-form" onSubmit={handleCreateFamily}>
            <Input
              label="Family name"
              value={form.name}
              onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))}
              required
              fullWidth
            />
            <label className="field-group member-form-wide">
              Description
              <textarea
                value={form.description}
                onChange={(event) => setForm((current) => ({ ...current, description: event.target.value }))}
                rows={3}
              />
            </label>
            <Button
              className="member-form-action"
              disabled={isSubmitting || !form.name.trim()}
              isLoading={isSubmitting}
              type="submit"
            >
              <Plus aria-hidden="true" />
              Add family
            </Button>
          </form>
        </Card>

        <Card padding="lg" variant="elevated">
          <div className="section-heading">
            <div>
              <h2>All families</h2>
              <p>{isLoading ? 'Loading families...' : `${families.length} families available.`}</p>
            </div>
            <UsersRound aria-hidden="true" />
          </div>

          <div className="member-list">
            {families.map((family) => (
              <article className="member-row" key={family.id}>
                <div className="member-avatar" aria-hidden="true">
                  {initials(family.name)}
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <strong>{family.name}</strong>
                    <Badge variant={family.is_active ? 'success' : 'neutral'}>
                      {family.is_active ? 'Active' : 'Inactive'}
                    </Badge>
                  </div>
                  <p>{family.description || 'No description added'}</p>
                  <small>Family ID: {family.id} | Members: {family.members_count ?? 0}</small>
                </div>
                <div className="member-meta">
                  <button
                    className="text-action danger"
                    onClick={() => handleDeleteFamily(family)}
                    type="button"
                  >
                    <Trash2 aria-hidden="true" size={16} />
                    Delete
                  </button>
                </div>
              </article>
            ))}
          </div>
        </Card>
      </section>
    </main>
  );
}

function sortFamilies(first, second) {
  return first.name.localeCompare(second.name);
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
