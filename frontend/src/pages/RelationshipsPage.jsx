import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  ArrowRight,
  GitBranch,
  Heart,
  LogOut,
  Plus,
  ShieldCheck,
  UsersRound,
} from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_HOME, ROLE_LABELS, ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card } from '../app/components';
import { familyApi } from '../services/familyApi.js';
import { relationshipApi } from '../services/relationshipApi.js';

const memberRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/members',
  [ROLES.ADMIN]: '/admin/members',
  [ROLES.USER]: '/app/members',
};

const relationshipRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/relationships',
  [ROLES.ADMIN]: '/admin/relationships',
  [ROLES.USER]: '/app/relationships',
};

const treeRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/tree',
  [ROLES.ADMIN]: '/admin/tree',
  [ROLES.USER]: '/app/tree',
};

const relationshipLabels = {
  parent: 'Parent of',
  spouse: 'Spouse of',
  sibling: 'Sibling of',
  guardian: 'Guardian of',
};

const emptyForm = {
  family_id: '',
  from_member_id: '',
  to_member_id: '',
  relationship_type: 'parent',
  notes: '',
};

export function RelationshipsPage({ role }) {
  const { logout, token, user } = useAuth();
  const [families, setFamilies] = useState([]);
  const [members, setMembers] = useState([]);
  const [relationships, setRelationships] = useState([]);
  const [relationshipTypes, setRelationshipTypes] = useState(Object.keys(relationshipLabels));
  const [form, setForm] = useState(emptyForm);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const canManageRelationships = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const selectedFamilyId = form.family_id || families[0]?.id || user.family_id || '';

  const stats = useMemo(() => {
    const parentLinks = relationships.filter((relationship) => relationship.relationship_type === 'parent').length;
    const spouseLinks = relationships.filter((relationship) => relationship.relationship_type === 'spouse').length;

    return [
      ['Relationships', relationships.length],
      ['Parent links', parentLinks],
      ['Spouse links', spouseLinks],
    ];
  }, [relationships]);

  useEffect(() => {
    let isMounted = true;

    async function loadData() {
      setIsLoading(true);
      setError('');

      try {
        const nextFamilies = await familyApi.listFamilies(token);
        const firstFamilyId = nextFamilies[0]?.id ?? user.family_id ?? '';
        const [nextMembers, relationshipPayload] = await Promise.all([
          familyApi.listMembers(token, firstFamilyId),
          relationshipApi.listRelationships(token, firstFamilyId),
        ]);

        if (!isMounted) {
          return;
        }

        setFamilies(nextFamilies);
        setMembers(nextMembers);
        setRelationships(relationshipPayload.relationships);
        setRelationshipTypes(relationshipPayload.relationship_types ?? Object.keys(relationshipLabels));
        setForm((current) => ({
          ...current,
          family_id: current.family_id || firstFamilyId,
        }));
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
  }, [token, user.family_id]);

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setSuccess('');
    setIsSubmitting(true);

    try {
      const relationship = await relationshipApi.createRelationship(token, {
        ...form,
        family_id: Number(selectedFamilyId),
        from_member_id: Number(form.from_member_id),
        to_member_id: Number(form.to_member_id),
      });

      setRelationships((current) => [relationship, ...current]);
      setForm({ ...emptyForm, family_id: selectedFamilyId });
      setSuccess('Family relationship added.');
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  async function handleDelete(relationshipId) {
    setError('');
    setSuccess('');

    try {
      await relationshipApi.deleteRelationship(token, relationshipId);
      setRelationships((current) => current.filter((relationship) => relationship.id !== relationshipId));
      setSuccess('Family relationship removed.');
    } catch (deleteError) {
      setError(deleteError.message);
    }
  }

  function updateForm(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="relationships" role={role} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>Relationships</h1>
            <p>
              Connect people records into parent, spouse, sibling, and guardian links
              that the tree builder can use next.
            </p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <section className="metric-grid" aria-label="Family relationship summary">
          {stats.map(([label, value]) => (
            <Card className="metric-card" key={label} padding="md" variant="elevated">
              <span>{label}</span>
              <strong>{value}</strong>
            </Card>
          ))}
        </section>

        {canManageRelationships ? (
          <Card padding="lg" variant="bordered">
            <div className="section-heading">
              <div>
                <h2>Add relationship</h2>
                <p>Choose the source person, the relationship type, and the target person.</p>
              </div>
              <Badge variant="secondary">Admin action</Badge>
            </div>

            <form className="relationship-form" onSubmit={handleSubmit}>
              {families.length > 1 ? (
                <label className="field-group">
                  Family
                  <select
                    value={form.family_id}
                    onChange={(event) => updateForm('family_id', event.target.value)}
                    required
                  >
                    {families.map((family) => (
                      <option key={family.id} value={family.id}>
                        {family.name}
                      </option>
                    ))}
                  </select>
                </label>
              ) : null}

              <label className="field-group">
                From member
                <select
                  value={form.from_member_id}
                  onChange={(event) => updateForm('from_member_id', event.target.value)}
                  required
                >
                  <option value="">Select member</option>
                  {members.map((member) => (
                    <option key={member.id} value={member.id}>
                      {member.display_name}
                    </option>
                  ))}
                </select>
              </label>

              <label className="field-group">
                Relationship
                <select
                  value={form.relationship_type}
                  onChange={(event) => updateForm('relationship_type', event.target.value)}
                  required
                >
                  {relationshipTypes.map((type) => (
                    <option key={type} value={type}>
                      {relationshipLabels[type] ?? type}
                    </option>
                  ))}
                </select>
              </label>

              <label className="field-group">
                To member
                <select
                  value={form.to_member_id}
                  onChange={(event) => updateForm('to_member_id', event.target.value)}
                  required
                >
                  <option value="">Select member</option>
                  {members.map((member) => (
                    <option key={member.id} value={member.id}>
                      {member.display_name}
                    </option>
                  ))}
                </select>
              </label>

              <label className="field-group relationship-form-wide">
                Notes
                <textarea
                  value={form.notes}
                  onChange={(event) => updateForm('notes', event.target.value)}
                  rows={3}
                />
              </label>

              <Button
                className="member-form-action"
                disabled={isSubmitting || members.length < 2}
                isLoading={isSubmitting}
                type="submit"
              >
                <Plus aria-hidden="true" />
                Add relationship
              </Button>
            </form>
          </Card>
        ) : (
          <Card className="identity-strip" padding="md" variant="bordered">
            <ShieldCheck aria-hidden="true" />
            <div>
              <span>Read-only access</span>
              <strong>End users can view approved relationship records.</strong>
            </div>
          </Card>
        )}

        <Card padding="lg" variant="elevated">
          <div className="section-heading">
            <div>
              <h2>Relationship directory</h2>
              <p>
                {isLoading
                  ? 'Loading relationships...'
                  : `${relationships.length} links available.`}
              </p>
            </div>
            <GitBranch aria-hidden="true" />
          </div>

          <div className="relationship-list">
            {relationships.map((relationship) => (
              <article className="relationship-row" key={relationship.id}>
                <div className="relationship-icon" aria-hidden="true">
                  {relationship.relationship_type === 'spouse' ? <Heart /> : <GitBranch />}
                </div>
                <div className="relationship-main">
                  <strong>{relationship.from_member_name}</strong>
                  <span>
                    {relationship.relationship_label}
                    <ArrowRight aria-hidden="true" />
                  </span>
                  <strong>{relationship.to_member_name}</strong>
                  {relationship.family_name ? <Badge variant="neutral">{relationship.family_name}</Badge> : null}
                  {relationship.notes ? <p>{relationship.notes}</p> : null}
                </div>
                {canManageRelationships ? (
                  <button
                    className="text-action danger"
                    onClick={() => handleDelete(relationship.id)}
                    type="button"
                  >
                    Delete
                  </button>
                ) : null}
              </article>
            ))}

            {!isLoading && relationships.length === 0 ? (
              <div className="empty-state">
                <UsersRound aria-hidden="true" />
                <strong>No relationships yet</strong>
                <p>Add relationship links after at least two members are available.</p>
              </div>
            ) : null}
          </div>
        </Card>
      </section>
    </main>
  );
}
