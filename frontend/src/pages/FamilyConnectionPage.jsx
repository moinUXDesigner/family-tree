import { useEffect, useMemo, useState } from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import { GitBranch, Link2, LogOut, Network, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLES } from '../config/roles.js';
import { Alert, Badge, Button, Card, Input } from '../app/components';
import { LoadingCard } from '../app/components/LoadingCard.jsx';
import { PwaInstallPrompt } from '../pwa/PwaInstallPrompt.jsx';
import { familyConnectionApi } from '../services/familyConnectionApi.js';

const fallbackRelationships = [
  'child',
  'spouse',
  'parent',
  'sibling',
];

export function FamilyConnectionPage() {
  const { logout, token, user } = useAuth();
  const navigate = useNavigate();
  const [anchorMemberId, setAnchorMemberId] = useState('');
  const [relationship, setRelationship] = useState('');
  const [evidenceNotes, setEvidenceNotes] = useState('');
  const [status, setStatus] = useState(null);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showInstallPrompt, setShowInstallPrompt] = useState(false);

  const relationships = useMemo(
    () => status?.relationships ?? fallbackRelationships,
    [status],
  );
  const anchorMembers = status?.anchor_members ?? [];

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
        setAnchorMemberId(String(nextStatus.root_member?.id ?? nextStatus.anchor_members?.[0]?.id ?? ''));

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

  if (isLoading) {
    return (
      <LoadingCard
        messages={['Verifying your approved family connection...']}
        variant="relationships"
      />
    );
  }

  if (status?.is_connected && status?.approval_status === 'approved') {
    return <Navigate to="/app/tree" replace />;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      const result = await familyConnectionApi.connect(token, {
        anchor_member_id: Number(anchorMemberId),
        relationship_to_anchor: relationship,
        evidence_notes: evidenceNotes || null,
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
          navigate('/app/tree', { replace: true });
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
        <h1>Request access to the Nanne Saheb tree</h1>
        <p>
          Select an existing verified family member and your exact relationship to that person.
          A Super Admin must approve the claim before family access opens.
        </p>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {!error && status?.is_connected ? (
          <Alert variant={status.approval_status === 'approved' ? 'success' : 'info'}>
            {status.approval_status === 'approved'
              ? `Connected as ${status.member?.display_name} in ${status.member?.family_name}.`
              : status.approval_status === 'rejected'
                ? `Your request for ${status.member?.family_name} was rejected. Contact the Super Admin for access.`
                : `Request sent for ${status.member?.family_name}. Super Admin approval is required before tree access.`}
          </Alert>
        ) : null}

        {!status?.is_connected && status?.connection_request ? (
          <Alert variant={status.connection_request.status === 'rejected' ? 'error' : 'info'}>
            {status.connection_request.status === 'rejected'
              ? `Your claim as ${status.connection_request.relationship_label} of ${status.connection_request.anchor_member_name} was rejected. You can submit a corrected request.`
              : `Your claim as ${status.connection_request.relationship_label} of ${status.connection_request.anchor_member_name} is waiting for Super Admin approval.`}
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
          <div className="connect-choice-grid" aria-label="Connection guide">
            <div className="connect-choice active">
              <GitBranch aria-hidden="true" />
              <span>Root family</span>
              <strong>{status?.root_member_name ?? 'Shaik Nanne Saheb'}</strong>
            </div>

            <div className="connect-choice active">
              <ShieldCheck aria-hidden="true" />
              <span>Approval required</span>
              <strong>Verified by Super Admin</strong>
            </div>
          </div>

          <label className="field-group">
            Existing family member you connect through
            <select
              value={anchorMemberId}
              onChange={(event) => setAnchorMemberId(event.target.value)}
              required
            >
              <option value="">Select family member</option>
              {anchorMembers.map((member) => (
                <option key={member.id} value={member.id}>
                  {member.display_name}
                </option>
              ))}
            </select>
          </label>

          <label className="field-group">
            Your relationship to selected member
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

          <label className="field-group">
            Notes for Super Admin
            <textarea
              value={evidenceNotes}
              onChange={(event) => setEvidenceNotes(event.target.value)}
              placeholder="Example: I am the son of Abdul Rahman. My father can confirm this request."
              rows={3}
            />
          </label>

          <Button
            disabled={isLoading || isSubmitting || !anchorMemberId || !relationship}
            fullWidth
            isLoading={isSubmitting}
            type="submit"
          >
            <Link2 aria-hidden="true" />
            Connect and continue
          </Button>
          </form>
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
