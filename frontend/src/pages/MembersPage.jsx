import { useEffect, useMemo, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
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
  tree_family_id: '',
  add_member_type: 'spouse',
  existing_person_id: '',
  household_id: '',
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
  marital_status: 'married',
  living_status: 'living',
};

const addMemberTypeOptions = [
  ['spouse', 'Add Spouse', false],
  ['child', 'Add Child', false],
  ['parent', 'Add Parent', false],
  ['sibling', 'Add Sibling', false],
  ['existing_to_household', 'Add Existing Person to Household', false],
];

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
  ['brother_in_law', 'Brother-in-law'],
  ['sister_in_law', 'Sister-in-law'],
  ['in_law', 'In-law'],
  ['guardian', 'Guardian'],
  ['ward', 'Ward'],
];

export function MembersPage({ role }) {
  const { logout, token, user } = useAuth();
  const location = useLocation();
  const [families, setFamilies] = useState([]);
  const [members, setMembers] = useState([]);
  const [households, setHouseholds] = useState([]);
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
  const canSubmitMemberForm = isEditingMember
    ? Boolean(selectedFamilyId && form.first_name)
    : canSubmitAddMemberForm(selectedFamilyId, form);

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
        const [nextMembers, nextHouseholds] = await Promise.all([
          familyApi.listMembers(token, firstFamilyId),
          familyApi.listHouseholds(token, firstFamilyId),
        ]);

        if (!isMounted) {
          return;
        }

        setFamilies(nextFamilies);
        setMembers(nextMembers);
        setHouseholds(nextHouseholds);
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
      const addMemberType = isEditingMember ? null : form.add_member_type;
      const payload = {
        ...form,
        family_id: Number(isEditingMember ? form.tree_family_id || editingMember.family_id : selectedFamilyId),
        add_member_type: addMemberType,
        existing_person_id: needsExistingPerson(addMemberType) && form.existing_person_id
          ? Number(form.existing_person_id)
          : null,
        household_id: needsHousehold(addMemberType) && form.household_id ? Number(form.household_id) : null,
        family_head_id: isEditingMember && form.family_head_id ? Number(form.family_head_id) : null,
        relationship_to_family_head: isEditingMember ? form.relationship_to_family_head : null,
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
      await loadFamilyContext(selectedFamilyId);
      setDirectoryFamilyId(selectedFamilyId);
      setForm({ ...emptyForm, family_id: selectedFamilyId });
      setSuccess(createMemberSuccessMessage(result));
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

  async function loadFamilyContext(nextFamilyId) {
    const [nextMembers, nextHouseholds] = await Promise.all([
      familyApi.listMembers(token, nextFamilyId),
      familyApi.listHouseholds(token, nextFamilyId),
    ]);

    setMembers(nextMembers);
    setHouseholds(nextHouseholds);
  }

  async function handleDirectoryFamilyChange(nextFamilyId) {
    setDirectoryFamilyId(nextFamilyId);
    setForm((current) => ({ ...current, family_id: nextFamilyId }));
    setError('');
    setSuccess('');
    setIsLoading(true);

    try {
      await loadFamilyContext(nextFamilyId);
    } catch (loadError) {
      setError(loadError.message);
    } finally {
      setIsLoading(false);
    }
  }

  async function handleFormFamilyChange(nextFamilyId) {
    setDirectoryFamilyId(nextFamilyId);
    setForm((current) => ({
      ...current,
      family_id: nextFamilyId,
      existing_person_id: '',
      household_id: '',
    }));
    setError('');
    setSuccess('');
    setIsLoading(true);

    try {
      await loadFamilyContext(nextFamilyId);
    } catch (loadError) {
      setError(loadError.message);
    } finally {
      setIsLoading(false);
    }
  }

  function updateForm(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
  }

  function updateAddMemberType(value) {
    setForm((current) => ({
      ...current,
      add_member_type: value,
      existing_person_id: '',
      household_id: '',
      first_name: value === 'existing_to_household' ? '' : current.first_name,
      last_name: value === 'existing_to_household' ? '' : current.last_name,
      marital_status: ['child', 'sibling'].includes(value) ? 'unmarried' : 'married',
    }));
  }

  function showAddMemberForm() {
    setError('');
    setSuccess('');
    setEditingMember(null);
    setForm({ ...emptyForm, family_id: selectedFamilyId });
    setIsAddingMember(true);
  }

  useEffect(() => {
    const params = new URLSearchParams(location.search);
    if (params.get('quick_add') !== '1') {
      return;
    }

    const type = params.get('type') ?? 'spouse';
    const addType = ['spouse', 'child', 'parent', 'sibling', 'existing_to_household'].includes(type) ? type : 'spouse';
    const existingPersonId = params.get('existing_person_id') ?? '';

    setEditingMember(null);
    setIsAddingMember(true);
    setForm((current) => ({
      ...emptyForm,
      family_id: current.family_id || selectedFamilyId,
      add_member_type: addType,
      existing_person_id: needsExistingPerson(addType) ? existingPersonId : '',
      marital_status: ['child', 'sibling'].includes(addType) ? 'unmarried' : 'married',
    }));
  }, [location.search, selectedFamilyId]);

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
      family_id: String(member.display_family_id ?? member.family_id ?? selectedFamilyId),
      tree_family_id: String(member.family_id ?? selectedFamilyId),
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
            <div className="members-header-row">
              <h1>Family Members</h1>
              {!isMemberFormOpen ? (
                <Button className="add-member-button" onClick={showAddMemberForm} type="button">
                  <Plus aria-hidden="true" />
                  Add Member
                </Button>
              ) : null}
            </div>
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
                    : 'Create relatives or attach an existing person to the right household.'}
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
                    onChange={(event) => handleFormFamilyChange(event.target.value)}
                    disabled={isEditingMember}
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

              {!isEditingMember ? (
                <>
                  <label className="field-group member-form-wide">
                    Add Member Type
                    <select
                      value={form.add_member_type}
                      onChange={(event) => updateAddMemberType(event.target.value)}
                      required
                    >
                      {addMemberTypeOptions.map(([value, label, isDisabled]) => (
                        <option disabled={isDisabled} key={value} value={value}>
                          {label}
                        </option>
                      ))}
                    </select>
                  </label>

                  {needsExistingPerson(form.add_member_type) ? (
                    <label className="field-group member-form-wide">
                      Existing person
                      <select
                        value={form.existing_person_id}
                        onChange={(event) => updateForm('existing_person_id', event.target.value)}
                        required
                      >
                        <option value="">Select existing person</option>
                        {members.map((member) => (
                          <option key={member.id} value={member.id}>
                            {member.display_name}
                          </option>
                        ))}
                      </select>
                      <small>
                        {existingPersonHelpText(form.add_member_type)}
                        {members.length === 0 ? ' No members are loaded for this family yet.' : ''}
                      </small>
                    </label>
                  ) : null}

                  {needsHousehold(form.add_member_type) ? (
                    <label className="field-group member-form-wide">
                      Household / Couple Family
                      <select
                        value={form.household_id}
                        onChange={(event) => updateForm('household_id', event.target.value)}
                        required
                      >
                        <option value="">Select household</option>
                        {households.map((household) => (
                          <option key={household.id} value={household.id}>
                            {household.name}
                          </option>
                        ))}
                      </select>
                      <small>
                        {form.add_member_type === 'existing_to_household'
                          ? 'Select the household this existing person should be attached to.'
                          : 'Select the couple household this child belongs to.'}
                        {households.length === 0 ? ' Add a spouse first to create a household.' : ''}
                      </small>
                    </label>
                  ) : null}
                </>
              ) : null}

              {form.add_member_type !== 'existing_to_household' || isEditingMember ? (
                <>
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
                </>
              ) : null}

              {form.add_member_type !== 'existing_to_household' || isEditingMember ? (
                <>
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
                </>
              ) : null}

              <Button
                className="member-form-action"
                disabled={isSubmitting || !canSubmitMemberForm}
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
                    {member.household_name || member.display_family_name ? (
                      <Badge variant="neutral">{member.household_name ?? member.display_family_name}</Badge>
                    ) : null}
                  </div>
                  <p>
                    {[member.current_city, member.current_country].filter(Boolean).join(', ') ||
                      'Location not added'}
                  </p>
                  <small>
                    {[member.email, member.phone].filter(Boolean).join(' | ') ||
                      'No contact details'}
                  </small>
                  <div className="member-detail-lines">
                    {member.linked_user_email ? (
                      <span>
                        Signed up: {member.linked_user_name || member.linked_user_email}
                        {member.linked_user_name ? ` (${member.linked_user_email})` : ''}
                      </span>
                    ) : (
                      <span>
                        Added by: {[member.creator_name, member.creator_email].filter(Boolean).join(' | ') ||
                          'Not recorded'}
                      </span>
                    )}
                    {member.family_head_name && member.relation_to_family_head ? (
                      <span>
                        {relationshipLabel(member.relation_to_family_head)} of {member.family_head_name}
                      </span>
                    ) : null}
                    {member.household_name ? <span>Household: {member.household_name}</span> : null}
                  </div>
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

function canSubmitAddMemberForm(selectedFamilyId, form) {
  if (!selectedFamilyId || !canSubmitAddMemberType(form.add_member_type)) {
    return false;
  }

  if (form.add_member_type === 'existing_to_household') {
    return Boolean(form.existing_person_id && form.household_id);
  }

  if (needsExistingPerson(form.add_member_type) && !form.existing_person_id) {
    return false;
  }

  if (needsHousehold(form.add_member_type) && !form.household_id) {
    return false;
  }

  return Boolean(form.first_name);
}

function canSubmitAddMemberType(addMemberType) {
  return ['spouse', 'child', 'parent', 'sibling', 'existing_to_household'].includes(addMemberType);
}

function needsExistingPerson(addMemberType) {
  return ['spouse', 'parent', 'sibling', 'existing_to_household'].includes(addMemberType);
}

function needsHousehold(addMemberType) {
  return ['child', 'existing_to_household'].includes(addMemberType);
}

function existingPersonHelpText(addMemberType) {
  return {
    spouse: 'Select the person this new spouse should be linked to.',
    parent: 'Select the existing child this new parent should be linked to.',
    sibling: 'Select the existing person this new sibling should be linked to.',
    existing_to_household: 'Select the existing person to add to the household.',
  }[addMemberType] ?? 'Select the related existing person.';
}

function createMemberSuccessMessage(result) {
  if (result.household?.name) {
    return `Family member added to ${result.household.name}.`;
  }

  return 'Family member added.';
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}

function relationshipLabel(value) {
  return relationshipOptions.find(([optionValue]) => optionValue === value)?.[1] ?? value;
}
