import { useEffect, useMemo, useState } from 'react';
import { LogOut, Plus, RefreshCw, UsersRound } from 'lucide-react';
import { Alert, Badge, Button, Card, Input } from '../app/components';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_LABELS, ROLES } from '../config/roles.js';
import { rootFamilyApi } from '../services/rootFamilyApi.js';

const emptyForm = {
  anchor_member_id: '',
  relationship_to_anchor: 'child',
  first_name: '',
  last_name: '',
  gender: '',
  birth_date: '',
  email: '',
  phone: '',
  current_city: '',
  current_country: '',
  notes: '',
};

export function RootFamilyPage() {
  const { logout, token, user } = useAuth();
  const [rootFamily, setRootFamily] = useState(null);
  const [form, setForm] = useState(emptyForm);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const members = rootFamily?.members ?? [];
  const rootMember = rootFamily?.root_member;

  const spouseCount = useMemo(
    () => (rootFamily?.relationships ?? []).filter((item) => item.relationship_type === 'spouse').length,
    [rootFamily],
  );

  const childLinkCount = useMemo(
    () => (rootFamily?.relationships ?? []).filter((item) => item.relationship_type === 'parent').length,
    [rootFamily],
  );

  useEffect(() => {
    loadRootFamily();
  }, []);

  async function loadRootFamily() {
    setIsLoading(true);
    setError('');

    try {
      const data = await rootFamilyApi.getRootFamily(token);
      setRootFamily(data);
      setForm((current) => ({
        ...current,
        anchor_member_id: current.anchor_member_id || data.root_member?.id || '',
      }));
    } catch (loadError) {
      setError(loadError.message);
    } finally {
      setIsLoading(false);
    }
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setSuccess('');
    setIsSubmitting(true);

    try {
      const data = await rootFamilyApi.addMember(token, {
        ...form,
        anchor_member_id: Number(form.anchor_member_id),
        is_living: true,
        is_private: false,
      });

      setRootFamily(data);
      setForm({ ...emptyForm, anchor_member_id: data.root_member?.id || '' });
      setSuccess('Member added to the Nanne Saheb tree.');
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  function updateForm(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="root-family" role={ROLES.SUPER_ADMIN} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>Nanne Saheb Tree</h1>
            <p>
              Create Shaik Nanne Saheb&apos;s wife, children, and descendants under the root family tree.
            </p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <section className="metric-grid" aria-label="Nanne Saheb tree summary">
          {[
            ['Root', rootMember?.display_name ?? 'Shaik Nanne Saheb'],
            ['Members', members.length],
            ['Child links', childLinkCount],
            ['Spouse links', spouseCount],
          ].map(([label, value]) => (
            <Card className="metric-card" key={label} padding="md" variant="elevated">
              <span>{label}</span>
              <strong>{value}</strong>
            </Card>
          ))}
        </section>

        <Card padding="lg" variant="bordered">
          <div className="section-heading">
            <div>
              <h2>Add member under tree</h2>
              <p>Select Shaik Nanne Saheb or any existing member, then add wife or child under that person.</p>
            </div>
            <Button disabled={isLoading} onClick={loadRootFamily} type="button" variant="outline">
              <RefreshCw aria-hidden="true" />
              Refresh
            </Button>
          </div>

          <form className="member-form" onSubmit={handleSubmit}>
            <label className="field-group">
              Add under
              <select
                value={form.anchor_member_id}
                onChange={(event) => updateForm('anchor_member_id', event.target.value)}
                required
              >
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
                value={form.relationship_to_anchor}
                onChange={(event) => updateForm('relationship_to_anchor', event.target.value)}
                required
              >
                <option value="child">Child</option>
                <option value="wife">Wife / Spouse</option>
              </select>
            </label>

            <Input
              label="First name"
              value={form.first_name}
              onChange={(event) => updateForm('first_name', event.target.value)}
              required
              fullWidth
            />
            <Input
              label="Last name"
              value={form.last_name}
              onChange={(event) => updateForm('last_name', event.target.value)}
              fullWidth
            />
            <label className="field-group">
              Gender
              <select value={form.gender} onChange={(event) => updateForm('gender', event.target.value)}>
                <option value="">Select gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="non_binary">Non-binary</option>
                <option value="prefer_not_to_say">Prefer not to say</option>
              </select>
            </label>
            <Input
              label="Birth date"
              type="date"
              value={form.birth_date}
              onChange={(event) => updateForm('birth_date', event.target.value)}
              fullWidth
            />
            <Input
              label="Email"
              type="email"
              value={form.email}
              onChange={(event) => updateForm('email', event.target.value)}
              fullWidth
            />
            <Input
              label="Phone"
              value={form.phone}
              onChange={(event) => updateForm('phone', event.target.value)}
              fullWidth
            />
            <Input
              label="City"
              value={form.current_city}
              onChange={(event) => updateForm('current_city', event.target.value)}
              fullWidth
            />
            <Input
              label="Country"
              value={form.current_country}
              onChange={(event) => updateForm('current_country', event.target.value)}
              fullWidth
            />
            <label className="field-group member-form-wide">
              Notes
              <textarea
                value={form.notes}
                onChange={(event) => updateForm('notes', event.target.value)}
                rows={3}
              />
            </label>
            <Button
              className="member-form-action"
              disabled={isSubmitting || !form.anchor_member_id}
              isLoading={isSubmitting}
              type="submit"
            >
              <Plus aria-hidden="true" />
              Add to tree
            </Button>
          </form>
        </Card>

        <Card padding="lg" variant="elevated">
          <div className="section-heading">
            <div>
              <h2>Root family members</h2>
              <p>{isLoading ? 'Loading tree members...' : `${members.length} people in this tree.`}</p>
            </div>
            <UsersRound aria-hidden="true" />
          </div>

          <div className="member-list">
            {members.map((member) => (
              <article className="member-row" key={member.id}>
                <div className="member-avatar" aria-hidden="true">
                  {initials(member.display_name)}
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <strong>{member.display_name}</strong>
                    {member.id === rootMember?.id ? <Badge variant="secondary">Root</Badge> : null}
                  </div>
                  <p>
                    {[member.current_city, member.current_country].filter(Boolean).join(', ') ||
                      'Location not added'}
                  </p>
                  <small>{member.notes || 'No notes added'}</small>
                </div>
                <Badge variant={member.is_living ? 'success' : 'neutral'}>
                  {member.is_living ? 'Living' : 'Deceased'}
                </Badge>
              </article>
            ))}
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
