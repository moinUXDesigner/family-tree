import { useEffect, useState } from 'react';
import { LogOut, ShieldCheck } from 'lucide-react';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card } from '../app/components';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { approvalApi } from '../services/approvalApi.js';

export function ApprovalsPage() {
  const { logout, token } = useAuth();
  const [requests, setRequests] = useState([]);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    let isMounted = true;

    async function loadRequests() {
      setIsLoading(true);
      setError('');

      try {
        const nextRequests = await approvalApi.listRequests(token);

        if (isMounted) {
          setRequests(nextRequests);
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
    }

    loadRequests();

    return () => {
      isMounted = false;
    };
  }, [token]);

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
      <NavigationChrome active="approvals" role={ROLES.SUPER_ADMIN} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">Super Admin</Badge>
            <h1>Approvals</h1>
            <p>Review pending member access requests and approve or reject family access.</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <section className="metric-grid" aria-label="Approval summary">
          <Card className="metric-card" padding="md" variant="elevated">
            <span>Pending requests</span>
            <strong>{requests.length}</strong>
          </Card>
        </section>

        <Card padding="lg" variant="elevated">
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
                  {request.phone ? <p>{request.phone}</p> : null}
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
      </section>
    </main>
  );
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
