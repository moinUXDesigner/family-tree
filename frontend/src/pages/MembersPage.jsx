import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  CalendarDays,
  Globe2,
  LogOut,
  Mail,
  MapPin,
  Pencil,
  Phone,
  Plus,
  UserRound,
  UsersRound,
} from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_HOME, ROLE_LABELS, ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Badge, Button, Card, Input } from '../app/components';
import { familyApi } from '../services/familyApi.js';

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

const emptyForm = {
  family_id: '',
  first_name: '',
  last_name: '',
  gender: '',
  birth_date: '',
  death_date: '',
  graveyard_location: '',
  email: '',
  phone: '',
  current_city: '',
  current_country: '',
  family_head_id: '',
  relationship_to_family_head: '',
  marital_status: 'unmarried',
  living_status: 'living',
};

const relationshipOptions = [
  ['father', 'Father'],
  ['mother', 'Mother'],
  ['son', 'Son'],
  ['daughter', 'Daughter'],
  ['child', 'Child'],
  ['husband', 'Husband'],
  ['wife', 'Wife'],
  ['spouse', 'Spouse'],
  ['brother', 'Brother'],
  ['sister', 'Sister'],
  ['sibling', 'Sibling'],
  ['guardian', 'Guardian'],
  ['ward', 'Ward'],
];

export function MembersPage({ role }) {
  const { logout, token, user } = useAuth();
  const [families, setFamilies] = useState([]);
  const [members, setMembers] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isAddingMember, setIsAddingMember] = useState(false);
  const [editingMember, setEditingMember] = useState(null);
  const [directoryFamilyId, setDirectoryFamilyId] = useState('');

  const canDeleteMembers = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const canEditMembers = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const isMemberFormOpen = isAddingMember || Boolean(editingMember);
  const isEditingMember = Boolean(editingMember);
  const selectedFamilyId = form.family_id || directoryFamilyId || families[0]?.id || user.family_id || '';

  const stats = useMemo(() => {
    const livingCount = members.filter((member) => member.is_living).length;
    const linkedCount = members.filter((member) => member.user_id).length;

    return [
      ['Members', members.length],
      ['Living', livingCount],
      ['Linked users', linkedCount],
    ];
  }, [members]);

  useEffect(() => {
    let isMounted = true;

    async function loadData() {
      setIsLoading(true);
      setError('');

      try {
        const nextFamilies = await familyApi.listFamilies(token);
        const firstFamilyId = nextFamilies[0]?.id ?? user.family_id ?? '';
        const nextMembers = await familyApi.listMembers(token, firstFamilyId);

        if (!isMounted) {
          return;
        }

        setFamilies(nextFamilies);
        setMembers(nextMembers);
        setDirectoryFamilyId(firstFamilyId);
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
      const payload = {
        ...form,
        family_id: Number(selectedFamilyId),
        family_head_id: form.family_head_id ? Number(form.family_head_id) : null,
        is_living: form.living_status === 'living',
        death_date: form.living_status === 'deceased' ? form.death_date : null,
        graveyard_location: form.living_status === 'deceased' ? form.graveyard_location : null,
        is_private: false,
      };

      if (isEditingMember) {
        const member = await familyApi.updateMember(token, editingMember.id, payload);
        setMembers((current) => current.map((item) => (item.id === member.id ? member : item)).sort(sortMembers));
        setDirectoryFamilyId(String(member.family_id));
        setForm({ ...emptyForm, family_id: String(member.family_id) });
        setEditingMember(null);
        setIsAddingMember(false);
        setSuccess('Family member updated.');
        return;
      }

      const result = await familyApi.createMember(token, payload);
      const member = result.member;

      setMembers((current) => [...current, member].sort(sortMembers));
      if (result.family) {
        setFamilies((current) => [...current, result.family].sort(sortFamilies));
      }
      setDirectoryFamilyId(selectedFamilyId);
      setForm({ ...emptyForm, family_id: selectedFamilyId });
      setSuccess(result.family ? `Family member added. ${result.family.name} was created.` : 'Family member added.');
      setIsAddingMember(false);
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  async function handleDelete(memberId) {
    setError('');
    setSuccess('');

    try {
      await familyApi.deleteMember(token, memberId);
      setMembers((current) => current.filter((member) => member.id !== memberId));
      setSuccess('Family member removed.');
    } catch (deleteError) {
      setError(deleteError.message);
    }
  }

  async function handleDirectoryFamilyChange(nextFamilyId) {
    setDirectoryFamilyId(nextFamilyId);
    setForm((current) => ({ ...current, family_id: nextFamilyId }));
    setError('');
    setSuccess('');
    setIsLoading(true);

    try {
      const nextMembers = await familyApi.listMembers(token, nextFamilyId);
      setMembers(nextMembers);
    } catch (loadError) {
      setError(loadError.message);
    } finally {
      setIsLoading(false);
    }
  }

  function updateForm(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
  }

  function showAddMemberForm() {
    setError('');
    setSuccess('');
    setEditingMember(null);
    setForm({ ...emptyForm, family_id: selectedFamilyId });
    setIsAddingMember(true);
  }

  function hideAddMemberForm() {
    setError('');
    setForm({ ...emptyForm, family_id: selectedFamilyId });
    setEditingMember(null);
    setIsAddingMember(false);
  }

  function showEditMemberForm(member) {
    setError('');
    setSuccess('');
    setEditingMember(member);
    setIsAddingMember(false);
    setForm({
      ...emptyForm,
      family_id: String(member.family_id ?? selectedFamilyId),
      first_name: member.first_name ?? '',
      last_name: member.last_name ?? '',
      gender: member.gender ?? '',
      birth_date: member.birth_date ?? '',
      death_date: member.death_date ?? '',
      graveyard_location: member.graveyard_location ?? '',
      email: member.email ?? '',
      phone: member.phone ?? '',
      current_city: member.current_city ?? '',
      current_country: member.current_country ?? '',
      family_head_id: member.family_head_id ? String(member.family_head_id) : '',
      relationship_to_family_head: member.relation_to_family_head ?? '',
      marital_status: member.marital_status ?? 'unmarried',
      living_status: member.is_living ? 'living' : 'deceased',
    });
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="members" role={role} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>Family Members</h1>
            <p>
              Create and review the people records that will power relationships,
              family trees, maps, and timelines.
            </p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <section className="metric-grid" aria-label="Family member summary">
          {stats.map(([label, value]) => (
            <Card className="metric-card" key={label} padding="md" variant="elevated">
              <span>{label}</span>
              <strong>{value}</strong>
            </Card>
          ))}
        </section>

        {role === ROLES.SUPER_ADMIN && families.length > 1 && !isMemberFormOpen ? (
          <Card padding="md" variant="bordered">
            <label className="field-group tree-family-select">
              Family
              <select
                value={directoryFamilyId}
                onChange={(event) => handleDirectoryFamilyChange(event.target.value)}
              >
                {families.map((family) => (
                  <option key={family.id} value={family.id}>
                    {family.name}
                  </option>
                ))}
              </select>
            </label>
          </Card>
        ) : null}

        {isMemberFormOpen ? (
          <Card padding="lg" variant="bordered">
            <div className="section-heading">
              <div>
                <h2>{isEditingMember ? 'Edit member' : 'Add member'}</h2>
                <p>
                  {isEditingMember
                    ? 'Update the existing member profile.'
                    : 'Capture the member profile and attach the first relationship to the family head.'}
                </p>
              </div>
              <Button onClick={hideAddMemberForm} type="button" variant="outline">
                Cancel
              </Button>
            </div>

            <form className="member-form" onSubmit={handleSubmit}>
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

              <Input
                label="First name"
                leftIcon={<UserRound aria-hidden="true" size={18} />}
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
              <Input
                label="Birth date"
                leftIcon={<CalendarDays aria-hidden="true" size={18} />}
                type="date"
                value={form.birth_date}
                onChange={(event) => updateForm('birth_date', event.target.value)}
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
                label="Email"
                leftIcon={<Mail aria-hidden="true" size={18} />}
                type="email"
                value={form.email}
                onChange={(event) => updateForm('email', event.target.value)}
                fullWidth
              />
              <Input
                label="Phone"
                leftIcon={<Phone aria-hidden="true" size={18} />}
                value={form.phone}
                onChange={(event) => updateForm('phone', event.target.value)}
                fullWidth
              />
              <Input
                label="City"
                leftIcon={<MapPin aria-hidden="true" size={18} />}
                value={form.current_city}
                onChange={(event) => updateForm('current_city', event.target.value)}
                fullWidth
              />
              <Input
                label="Country"
                leftIcon={<Globe2 aria-hidden="true" size={18} />}
                value={form.current_country}
                onChange={(event) => updateForm('current_country', event.target.value)}
                fullWidth
              />

              <label className="field-group">
                Select Family Head
                <select
                  value={form.family_head_id}
                  onChange={(event) => updateForm('family_head_id', event.target.value)}
                  required={!isEditingMember}
                >
                  <option value="">Select family head</option>
                  {members.filter((member) => member.id !== editingMember?.id).map((member) => (
                    <option key={member.id} value={member.id}>
                      {member.display_name}
                    </option>
                  ))}
                </select>
              </label>

              <label className="field-group">
                Relation to Family Head
                <select
                  value={form.relationship_to_family_head}
                  onChange={(event) => updateForm('relationship_to_family_head', event.target.value)}
                  required={!isEditingMember}
                >
                  <option value="">Select relation</option>
                  {relationshipOptions.map(([value, label]) => (
                    <option key={value} value={value}>
                      {label}
                    </option>
                  ))}
                </select>
              </label>

              <label className="field-group member-form-wide">
                Married / Unmarried
                <select
                  value={form.marital_status}
                  onChange={(event) => updateForm('marital_status', event.target.value)}
                  required
                >
                  <option value="unmarried">Unmarried</option>
                  <option value="married">Married</option>
                </select>
              </label>

              <label className="field-group member-form-wide">
                Living Status
                <select
                  value={form.living_status}
                  onChange={(event) => {
                    if (event.target.value === 'living') {
                      setForm((current) => ({
                        ...current,
                        living_status: 'living',
                        death_date: '',
                        graveyard_location: '',
                      }));
                      return;
                    }

                    updateForm('living_status', event.target.value);
                  }}
                  required
                >
                  <option value="living">Living</option>
                  <option value="deceased">Deceased</option>
                </select>
              </label>

              {form.living_status === 'deceased' ? (
                <>
                  <Input
                    label="Date of Expiry"
                    leftIcon={<CalendarDays aria-hidden="true" size={18} />}
                    type="date"
                    value={form.death_date}
                    onChange={(event) => updateForm('death_date', event.target.value)}
                    fullWidth
                  />
                  <Input
                    label="Graveyard Location"
                    leftIcon={<MapPin aria-hidden="true" size={18} />}
                    value={form.graveyard_location}
                    onChange={(event) => updateForm('graveyard_location', event.target.value)}
                    fullWidth
                  />
                </>
              ) : null}

              <Button
                className="member-form-action"
                disabled={
                  isSubmitting ||
                  !selectedFamilyId ||
                  (!isEditingMember && (!form.family_head_id || !form.relationship_to_family_head))
                }
                isLoading={isSubmitting}
                type="submit"
              >
                {isEditingMember ? <Pencil aria-hidden="true" /> : <Plus aria-hidden="true" />}
                {isEditingMember ? 'Update member' : 'Add member'}
              </Button>
            </form>
          </Card>
        ) : (
          <Card padding="lg" variant="elevated">
          <div className="section-heading">
            <div>
              <h2>Member directory</h2>
              <p>{isLoading ? 'Loading members...' : `${members.length} records available.`}</p>
            </div>
            <Button onClick={showAddMemberForm} type="button">
              <Plus aria-hidden="true" />
              Add member
            </Button>
          </div>

          <div className="member-list">
            {members.map((member) => (
              <article className="member-row" key={member.id}>
                <div className="member-avatar" aria-hidden="true">
                  {member.photo_url ? (
                    <img alt="" src={member.photo_url} />
                  ) : (
                    initials(member.display_name)
                  )}
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <strong>{member.display_name}</strong>
                    {member.family_name ? <Badge variant="neutral">{member.family_name}</Badge> : null}
                  </div>
                  <p>
                    {[member.current_city, member.current_country].filter(Boolean).join(', ') ||
                      'Location not added'}
                  </p>
                  <small>
                    {[member.email, member.phone].filter(Boolean).join(' | ') ||
                      'No contact details'}
                  </small>
                </div>
                <div className="member-meta">
                  <Badge variant={member.is_living ? 'success' : 'neutral'}>
                    {member.is_living ? 'Living' : 'Deceased'}
                  </Badge>
                  {canEditMembers ? (
                    <button
                      className="text-action"
                      onClick={() => showEditMemberForm(member)}
                      type="button"
                    >
                      <Pencil aria-hidden="true" size={16} />
                      Edit
                    </button>
                  ) : null}
                  {canDeleteMembers ? (
                    <button
                      className="text-action danger"
                      onClick={() => handleDelete(member.id)}
                      type="button"
                    >
                      Delete
                    </button>
                  ) : null}
                </div>
              </article>
            ))}

            {!isLoading && members.length === 0 ? (
              <div className="empty-state">
                <UsersRound aria-hidden="true" />
                <strong>No members yet</strong>
                <p>Add the first family member to start building the tree.</p>
              </div>
            ) : null}
          </div>
          </Card>
        )}
      </section>
    </main>
  );
}

function sortMembers(first, second) {
  return first.display_name.localeCompare(second.display_name);
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
