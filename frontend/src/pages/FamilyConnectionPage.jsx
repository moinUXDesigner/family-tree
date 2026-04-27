import { useEffect, useMemo, useState } from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import { GitBranch, Hash, Link2, LogOut, Network } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { Alert, Badge, Button, Card, Input } from '../app/components';
import { PwaInstallPrompt } from '../pwa/PwaInstallPrompt.jsx';
import { familyConnectionApi } from '../services/familyConnectionApi.js';

const fallbackRelationships = [
  'grandfather',
  'grandmother',
  'father',
  'mother',
  'son',
  'daughter',
  'child',
  'grandson',
  'granddaughter',
  'grandchild',
  'great grandson',
  'great granddaughter',
  'great grandchild',
  'husband',
  'wife',
  'spouse',
  'brother',
  'sister',
  'sibling',
  'uncle',
  'aunt',
  'nephew',
  'niece',
  'cousin',
  'guardian',
  'ward',
  'relative',
];

export function FamilyConnectionPage() {
  const { logout, token, user } = useAuth();
  const navigate = useNavigate();
  const [connectionType, setConnectionType] = useState('root_member');
  const [familyId, setFamilyId] = useState('');
  const [relationship, setRelationship] = useState('');
  const [status, setStatus] = useState(null);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showInstallPrompt, setShowInstallPrompt] = useState(false);

  const relationships = useMemo(
    () => status?.relationships ?? fallbackRelationships,
    [status],
  );

  useEffect(() => {
    let isMounted = true;

    async function loadStatus() {
      setIsLoading(true);
      setError('');

      try {
        const nextStatus = await familyConnectionApi.status(token);

        if (!isMounted) {
          return;
        }

        setStatus(nextStatus);
        setRelationship(nextStatus.relationships?.[0] ?? fallbackRelationships[0]);

        if (
          nextStatus.is_connected &&
          nextStatus.approval_status === 'approved' &&
          !sessionStorage.getItem('familyTreeInstallPromptShown')
        ) {
          setShowInstallPrompt(true);
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

    loadStatus();

    return () => {
      isMounted = false;
    };
  }, [token]);

  if (user.role !== ROLES.USER) {
    return <Navigate to="/" replace />;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      const result = await familyConnectionApi.connect(token, {
        connection_type: connectionType,
        family_id: connectionType === 'family_id' ? Number(familyId) : null,
        relationship_to_root: relationship,
      });

      const nextStatus = await familyConnectionApi.status(token);
      setStatus(nextStatus);

      if (result.approval_status === 'approved') {
        sessionStorage.setItem('familyTreeInstallPromptShown', 'true');
        setShowInstallPrompt(true);
      }
    } catch (connectError) {
      setError(connectError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="connect-page">
      <PwaInstallPrompt
        isOpen={showInstallPrompt}
        onClose={() => {
          sessionStorage.setItem('familyTreeInstallPromptShown', 'true');
          navigate('/app/dashboard', { replace: true });
        }}
      />

      <Card className="connect-panel" padding="lg" variant="elevated">
        <header className="connect-header">
          <div className="brand-mark">
            <Network aria-hidden="true" />
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        <Badge variant="primary">Family connection</Badge>
        <h1>Connect your account to the family tree</h1>
        <p>
          Start from root member {status?.root_member_name ?? 'Shaik Nanne Saheb'}, or enter
          a Family ID if you were invited to a specific family.
        </p>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {!error && status?.is_connected ? (
          <Alert variant={status.approval_status === 'approved' ? 'success' : 'info'}>
            {status.approval_status === 'approved'
              ? `Connected as ${status.member?.display_name} in ${status.member?.family_name}.`
              : status.approval_status === 'rejected'
                ? `Your request for ${status.member?.family_name} was rejected. Contact the Super Admin for access.`
                : `Request sent for ${status.member?.family_name}. Super Admin approval is required before dashboard access.`}
          </Alert>
        ) : null}

        {status?.is_connected && status.approval_status !== 'approved' ? (
          <Card padding="md" variant="bordered">
            <div className="section-heading">
              <div>
                <h2>{status.approval_status === 'rejected' ? 'Access not approved' : 'Waiting for approval'}</h2>
                <p>
                  {status.approval_status === 'rejected'
                    ? 'Your account is connected, but family access is not approved right now.'
                    : `Your account is connected to ${status.member?.family_name}. A Super Admin must approve your access request before member lists, tree, and links become available.`}
                </p>
              </div>
            </div>
          </Card>
        ) : null}

        {!status?.is_connected ? (
          <form className="connect-form" onSubmit={handleSubmit}>
          <div className="connect-choice-grid" role="radiogroup" aria-label="Connection type">
            <label className={connectionType === 'root_member' ? 'connect-choice active' : 'connect-choice'}>
              <input
                checked={connectionType === 'root_member'}
                name="connection_type"
                onChange={() => setConnectionType('root_member')}
                type="radio"
                value="root_member"
              />
              <GitBranch aria-hidden="true" />
              <span>Root member</span>
              <strong>{status?.root_member_name ?? 'Shaik Nanne Saheb'}</strong>
            </label>

            <label className={connectionType === 'family_id' ? 'connect-choice active' : 'connect-choice'}>
              <input
                checked={connectionType === 'family_id'}
                name="connection_type"
                onChange={() => setConnectionType('family_id')}
                type="radio"
                value="family_id"
              />
              <Hash aria-hidden="true" />
              <span>Family ID</span>
              <strong>Use an existing family number</strong>
            </label>
          </div>

          {connectionType === 'family_id' ? (
            <Input
              label="Family ID"
              min="1"
              type="number"
              value={familyId}
              onChange={(event) => setFamilyId(event.target.value)}
              required
              fullWidth
            />
          ) : null}

          <label className="field-group">
            Your relationship with root member
            <select
              value={relationship}
              onChange={(event) => setRelationship(event.target.value)}
              required
            >
              {relationships.map((relation) => (
                <option key={relation} value={relation}>
                  {relationLabel(relation)}
                </option>
              ))}
            </select>
          </label>

          <Button
            disabled={isLoading || isSubmitting || !relationship || (connectionType === 'family_id' && !familyId)}
            fullWidth
            isLoading={isSubmitting}
            type="submit"
          >
            <Link2 aria-hidden="true" />
            Connect and continue
          </Button>
          </form>
        ) : null}

        {status?.is_connected && status.approval_status === 'approved' ? (
          <Button
            fullWidth
            onClick={() => navigate('/app/dashboard', { replace: true })}
            type="button"
            variant="outline"
          >
            Continue to dashboard
          </Button>
        ) : null}
      </Card>
    </main>
  );
}

function relationLabel(relation) {
  return relation
    .split(' ')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}
