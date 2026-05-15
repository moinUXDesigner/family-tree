import { useEffect, useMemo, useRef, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Alert as MuiAlert, Snackbar } from '@mui/material';
import MenuItem from '@mui/material/MenuItem';
import TextField from '@mui/material/TextField';
import {
  CalendarDays,
  Clock3,
  Globe2,
  LogOut,
  Mail,
  MapPin,
  Search,
  Eye,
  Pencil,
  Phone,
  Plus,
  Network,
  UserRound,
  UsersRound,
  X,
  Upload,
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
  birth_time: '',
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
  const [viewingMember, setViewingMember] = useState(null);
  const [directoryFamilyId, setDirectoryFamilyId] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState('name_asc');
  const [addStep, setAddStep] = useState(1);
  const [isStep3Confirmed, setIsStep3Confirmed] = useState(false);
  const [photoFile, setPhotoFile] = useState(null);
  const [photoPreviewUrl, setPhotoPreviewUrl] = useState('');
  const [photoObjectUrl, setPhotoObjectUrl] = useState('');
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [cameraError, setCameraError] = useState('');
  const videoRef = useRef(null);
  const canvasRef = useRef(null);
  const cameraStreamRef = useRef(null);

  const canDeleteMembers = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const canEditMembers = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const canUploadMemberPhotos = Boolean(token);
  const isMemberFormOpen = isAddingMember || Boolean(editingMember);
  const isEditingMember = Boolean(editingMember);
  const isViewingMember = Boolean(viewingMember);
  const selectedFamilyId = form.family_id || directoryFamilyId || families[0]?.id || user.family_id || '';
  const canSubmitMemberForm = isEditingMember
    ? Boolean(selectedFamilyId && form.first_name)
    : canSubmitAddMemberForm(selectedFamilyId, form) && isStep3Confirmed;

  const stats = useMemo(() => {
    const livingCount = members.filter((member) => member.is_living).length;

    return [
      ['Members', members.length],
      ['Living', livingCount],
    ];
  }, [members]);

  const filteredMembers = useMemo(() => {
    const query = searchTerm.trim().toLowerCase();
    const source = query
      ? members.filter((member) => [
        member.display_name,
        member.email,
        member.phone,
        member.display_family_name,
        member.household_name,
        member.current_city,
        member.current_country,
      ]
        .filter(Boolean)
        .join(' ')
        .toLowerCase()
        .includes(query))
      : [...members];

    return source.sort((a, b) => {
      if (sortBy === 'name_desc') {
        return b.display_name.localeCompare(a.display_name);
      }

      if (sortBy === 'living_first') {
        return Number(b.is_living) - Number(a.is_living) || a.display_name.localeCompare(b.display_name);
      }

      if (sortBy === 'deceased_first') {
        return Number(a.is_living) - Number(b.is_living) || a.display_name.localeCompare(b.display_name);
      }

      return a.display_name.localeCompare(b.display_name);
    });
  }, [members, searchTerm, sortBy]);

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
    if (!canSubmitMemberForm) {
      setError('Please complete required fields before submitting.');
      return;
    }
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
      const requestPayload = buildMemberRequestPayload(payload, photoFile);

      if (isEditingMember) {
        const member = await familyApi.updateMember(token, editingMember.id, requestPayload);
        setMembers((current) => current.map((item) => (item.id === member.id ? member : item)).sort(sortMembers));
        setDirectoryFamilyId(String(member.family_id));
        setForm({ ...emptyForm, family_id: String(member.family_id) });
        clearPhotoState('');
        setEditingMember(null);
        setIsAddingMember(false);
        setSuccess('Family member updated.');
        return;
      }

      const result = await familyApi.createMember(token, requestPayload);
      await loadFamilyContext(selectedFamilyId);
      setDirectoryFamilyId(selectedFamilyId);
      setForm({ ...emptyForm, family_id: selectedFamilyId });
      clearPhotoState('');
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

  async function handleMemberPhotoUpload(memberId, file) {
    if (!file) {
      return;
    }

    setError('');
    setSuccess('');

    try {
      const updated = await familyApi.updateMemberPhoto(token, memberId, file);
      setMembers((current) => current.map((item) => (item.id === updated.id ? updated : item)).sort(sortMembers));
      setSuccess('Profile photo updated.');
    } catch (uploadError) {
      setError(uploadError.message);
    }
  }

  function clearPhotoState(nextPreview = '') {
    if (photoObjectUrl) {
      URL.revokeObjectURL(photoObjectUrl);
      setPhotoObjectUrl('');
    }
    setPhotoFile(null);
    setPhotoPreviewUrl(nextPreview);
  }

  function stopCamera() {
    if (cameraStreamRef.current) {
      cameraStreamRef.current.getTracks().forEach((track) => track.stop());
      cameraStreamRef.current = null;
    }
    setIsCameraOpen(false);
  }

  async function openCamera() {
    setCameraError('');
    if (!navigator.mediaDevices?.getUserMedia) {
      setCameraError('Camera is not supported in this browser.');
      return;
    }

    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'environment' },
        audio: false,
      });
      cameraStreamRef.current = stream;
      setIsCameraOpen(true);
      setTimeout(() => {
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
        }
      }, 0);
    } catch {
      setCameraError('Unable to access camera. Please allow camera permission.');
    }
  }

  function captureFromCamera() {
    if (!videoRef.current || !canvasRef.current) {
      return;
    }

    const video = videoRef.current;
    const canvas = canvasRef.current;
    canvas.width = video.videoWidth || 640;
    canvas.height = video.videoHeight || 480;
    const context = canvas.getContext('2d');
    if (!context) {
      return;
    }
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    canvas.toBlob((blob) => {
      if (!blob) {
        return;
      }
      clearPhotoState(editingMember?.photo_url ?? '');
      const file = new File([blob], `camera-${Date.now()}.jpg`, { type: 'image/jpeg' });
      const nextObjectUrl = URL.createObjectURL(file);
      setPhotoObjectUrl(nextObjectUrl);
      setPhotoFile(file);
      setPhotoPreviewUrl(nextObjectUrl);
      stopCamera();
    }, 'image/jpeg', 0.9);
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
    setAddStep(1);
    setIsStep3Confirmed(false);
  }

  function showAddMemberForm() {
    setError('');
    setSuccess('');
    setEditingMember(null);
    setForm({ ...emptyForm, family_id: selectedFamilyId });
    setAddStep(1);
    setIsStep3Confirmed(false);
    clearPhotoState('');
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
    setAddStep(1);
    setIsStep3Confirmed(false);
    clearPhotoState('');
    setForm((current) => ({
      ...emptyForm,
      family_id: current.family_id || selectedFamilyId,
      add_member_type: addType,
      existing_person_id: needsExistingPerson(addType) ? existingPersonId : '',
      marital_status: ['child', 'sibling'].includes(addType) ? 'unmarried' : 'married',
    }));
  }, [location.search, selectedFamilyId]);

  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const editMemberId = params.get('edit_member_id');

    if (!editMemberId) {
      return;
    }

    const target = members.find((member) => String(member.id) === String(editMemberId));
    if (!target) {
      return;
    }

    showEditMemberForm(target);
  }, [location.search, members]);

  useEffect(
    () => () => {
      if (photoObjectUrl) {
        URL.revokeObjectURL(photoObjectUrl);
      }
    },
    [photoObjectUrl],
  );

  function hideAddMemberForm() {
    setError('');
    setForm({ ...emptyForm, family_id: selectedFamilyId });
    setAddStep(1);
    setIsStep3Confirmed(false);
    clearPhotoState('');
    stopCamera();
    setEditingMember(null);
    setIsAddingMember(false);
  }

  function showEditMemberForm(member) {
    setError('');
    setSuccess('');
    setEditingMember(member);
    stopCamera();
    setAddStep(1);
    setIsStep3Confirmed(false);
    setIsAddingMember(false);
    clearPhotoState(member.photo_url ?? '');
    setForm({
      ...emptyForm,
      family_id: String(member.display_family_id ?? member.family_id ?? selectedFamilyId),
      tree_family_id: String(member.family_id ?? selectedFamilyId),
      first_name: member.first_name ?? '',
      last_name: member.last_name ?? '',
      gender: member.gender ?? '',
      birth_date: member.birth_date ?? '',
      birth_time: member.birth_time ?? '',
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

  function canProceedStep(step) {
    if (step === 1) {
      if (!form.add_member_type) {
        return false;
      }

      if (needsExistingPerson(form.add_member_type) && !form.existing_person_id) {
        return false;
      }

      if (needsHousehold(form.add_member_type) && !form.household_id) {
        return false;
      }

      return true;
    }

    if (step === 2) {
      if (form.add_member_type === 'existing_to_household') {
        return true;
      }

      return Boolean(form.first_name);
    }

    return true;
  }

  function isExistingToHouseholdFlow() {
    return !isEditingMember && form.add_member_type === 'existing_to_household';
  }

  function canOpenStep(step) {
    if (isExistingToHouseholdFlow()) {
      return step === 1;
    }

    if (isEditingMember) {
      return true;
    }

    if (step <= addStep) {
      return true;
    }

    for (let currentStep = 1; currentStep < step; currentStep += 1) {
      if (!canProceedStep(currentStep)) {
        return false;
      }
    }

    return true;
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="members" role={role} />

      <section className="dashboard-content">
        <header className="dashboard-header">
          {!isMemberFormOpen ? (
            <div>
              <div className="members-header-row">
                <h1>Family Members</h1>
                <Button
                  className="members-desktop-add-btn"
                  onClick={showAddMemberForm}
                  type="button"
                >
                  <Plus aria-hidden="true" />
                  Add Member
                </Button>
              </div>
            </div>
          ) : <div />}
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        <Snackbar
          anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
          autoHideDuration={5000}
          onClose={() => setSuccess('')}
          open={Boolean(success)}
        >
          <MuiAlert elevation={6} onClose={() => setSuccess('')} severity="success" variant="filled">
            {success}
          </MuiAlert>
        </Snackbar>

        {!isMemberFormOpen ? (
          <div className="members-summary-row">
            <section className="metric-grid members-metric-strip" aria-label="Family member summary">
              {stats.map(([label, value]) => (
                <Card className="metric-card" key={label} padding="md" variant="elevated">
                  <span>{label}</span>
                  <strong>{value}</strong>
                </Card>
              ))}
            </section>
            <label className="members-sort-control">
              <span className="sr-only">Sort members</span>
              <select value={sortBy} onChange={(event) => setSortBy(event.target.value)}>
                <option value="name_asc">Name A-Z</option>
                <option value="name_desc">Name Z-A</option>
                <option value="living_first">Living first</option>
                <option value="deceased_first">Deceased first</option>
              </select>
            </label>
          </div>
        ) : null}

        {!isMemberFormOpen ? (
          <div className="feedback-search-shell">
            <Search aria-hidden="true" />
            <input
              aria-label="Search members"
              onChange={(event) => setSearchTerm(event.target.value)}
              placeholder="Search members by name, family, city, phone..."
              value={searchTerm}
            />
          </div>
        ) : null}

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
                  <div className="member-form-wide">
                    <div className="members-stepper">
                      {[
                        [1, 'Input'],
                        [2, 'Review'],
                        [3, 'Contact'],
                        [4, 'Photo'],
                        [5, 'Done'],
                      ].map(([step, label]) => (
                        <button
                          className={addStep === step ? 'active' : ''}
                          key={step}
                          disabled={!canOpenStep(step)}
                          onClick={() => {
                            if (canOpenStep(step)) {
                              setAddStep(step);
                            }
                          }}
                          type="button"
                        >
                          <span className="step-circle">{step}</span>
                          <span className="step-label">{label}</span>
                        </button>
                      ))}
                    </div>
                  </div>

                  {addStep === 1 ? (
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
                </>
              ) : null}

              {(isEditingMember || addStep === 2) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
                <>
                  <Input
                    label="Full name"
                    leftIcon={<UserRound aria-hidden="true" size={18} />}
                    value={form.first_name}
                    onChange={(event) => updateForm('first_name', event.target.value)}
                    required
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
                  <Input
                    label="Birth time"
                    leftIcon={<Clock3 aria-hidden="true" size={18} />}
                    type="time"
                    value={form.birth_time}
                    onChange={(event) => updateForm('birth_time', event.target.value)}
                    fullWidth
                  />
                  <TextField
                    fullWidth
                    label="Gender"
                    onChange={(event) => updateForm('gender', event.target.value)}
                    select
                    value={form.gender}
                  >
                    <MenuItem value="">Select gender</MenuItem>
                    <MenuItem value="male">Male</MenuItem>
                    <MenuItem value="female">Female</MenuItem>
                    <MenuItem value="non_binary">Non-binary</MenuItem>
                    <MenuItem value="prefer_not_to_say">Prefer not to say</MenuItem>
                  </TextField>
                </>
              ) : null}

              {(isEditingMember || addStep === 3) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
                <>
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

              {(isEditingMember || addStep === 4) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
                <div className="member-form-wide member-photo-section">
                  <div className="member-photo-preview">
                    {photoPreviewUrl ? (
                      <img alt="Member preview" src={photoPreviewUrl} />
                    ) : (
                      <Network aria-hidden="true" size={26} />
                    )}
                  </div>
                  <div className="member-photo-actions">
                    <label className="field-group">
                      Upload Photo
                      <input
                        accept="image/*"
                        onChange={(event) => {
                          const file = event.target.files?.[0] ?? null;
                          clearPhotoState(editingMember?.photo_url ?? '');
                          if (!file) {
                            return;
                          }
                          const nextObjectUrl = URL.createObjectURL(file);
                          setPhotoObjectUrl(nextObjectUrl);
                          setPhotoFile(file);
                          setPhotoPreviewUrl(nextObjectUrl);
                        }}
                        type="file"
                      />
                    </label>
                    <label className="field-group">
                      Take Picture (Mobile)
                      <input
                        accept="image/*"
                        capture="environment"
                        onChange={(event) => {
                          const file = event.target.files?.[0] ?? null;
                          clearPhotoState(editingMember?.photo_url ?? '');
                          if (!file) {
                            return;
                          }
                          const nextObjectUrl = URL.createObjectURL(file);
                          setPhotoObjectUrl(nextObjectUrl);
                          setPhotoFile(file);
                          setPhotoPreviewUrl(nextObjectUrl);
                        }}
                        type="file"
                      />
                    </label>
                    <div className="member-photo-camera">
                      <Button onClick={openCamera} type="button" variant="outline">
                        Open Camera
                      </Button>
                      {cameraError ? <small>{cameraError}</small> : null}
                      {isCameraOpen ? (
                        <div className="member-camera-panel">
                          <video autoPlay playsInline ref={videoRef} />
                          <div className="member-camera-actions">
                            <Button onClick={captureFromCamera} type="button">Capture</Button>
                            <Button onClick={stopCamera} type="button" variant="outline">Cancel</Button>
                          </div>
                        </div>
                      ) : null}
                      <canvas ref={canvasRef} style={{ display: 'none' }} />
                    </div>
                    <small>
                      Upload an image file or capture from camera. Recommended square photo up to 5MB.
                    </small>
                  </div>
                </div>
              ) : null}

              {(isEditingMember || addStep === 5) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
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

                  {!isEditingMember ? (
                    <label className="field-group member-form-wide">
                      <span>Confirmation</span>
                      <label className="members-confirm-checkbox">
                        <input
                          checked={isStep3Confirmed}
                          onChange={(event) => setIsStep3Confirmed(event.target.checked)}
                          type="checkbox"
                        />
                        <span>I have reviewed this member information and want to create it.</span>
                      </label>
                    </label>
                  ) : null}
                </>
              ) : null}

              {!isEditingMember ? (
                <div className="member-form-wide members-step-actions">
                  {isExistingToHouseholdFlow() ? (
                    <Button
                      className="member-form-action"
                      disabled={isSubmitting || !canSubmitMemberForm}
                      isLoading={isSubmitting}
                      type="submit"
                    >
                      <Plus aria-hidden="true" />
                      Add member
                    </Button>
                  ) : (
                    <>
                      {addStep > 1 ? (
                        <Button onClick={() => setAddStep((current) => Math.max(1, current - 1))} type="button" variant="outline">
                          Back
                        </Button>
                      ) : <span />}
                      {addStep < 5 ? (
                        <Button disabled={!canProceedStep(addStep)} onClick={() => setAddStep((current) => Math.min(5, current + 1))} type="button">
                          Next
                        </Button>
                      ) : (
                        <Button
                          className="member-form-action"
                          disabled={isSubmitting || !canSubmitMemberForm}
                          isLoading={isSubmitting}
                          type="submit"
                        >
                          <Plus aria-hidden="true" />
                          Add member
                        </Button>
                      )}
                    </>
                  )}
                </div>
              ) : (
                <Button
                  className="member-form-action"
                  disabled={isSubmitting || !canSubmitMemberForm}
                  isLoading={isSubmitting}
                  type="submit"
                >
                  <Pencil aria-hidden="true" />
                  Update member
                </Button>
              )}
            </form>
          </Card>
        ) : (
          <div className="member-list">
            {isViewingMember ? (
              <section className="member-fullscreen-view" aria-label="Member details">
                <div className="member-fullscreen-header">
                  <h3>{viewingMember.display_name}</h3>
                  <button className="text-action" onClick={() => setViewingMember(null)} type="button">
                    <X aria-hidden="true" size={16} />
                    Close
                  </button>
                </div>
                <div className="member-fullscreen-grid">
                  <div><strong>Status</strong><p>{viewingMember.is_living ? 'Living' : 'Deceased'}</p></div>
                  <div><strong>Family</strong><p>{viewingMember.display_family_name || 'Not added'}</p></div>
                  <div><strong>Household</strong><p>{viewingMember.household_name || 'Not added'}</p></div>
                  <div><strong>Birth Date</strong><p>{viewingMember.birth_date || 'Not added'}</p></div>
                  <div><strong>Death Date</strong><p>{viewingMember.death_date || 'Not added'}</p></div>
                  <div><strong>Gender</strong><p>{viewingMember.gender || 'Not added'}</p></div>
                  <div><strong>Email</strong><p>{viewingMember.email || 'Not added'}</p></div>
                  <div><strong>Phone</strong><p>{viewingMember.phone || 'Not added'}</p></div>
                  <div><strong>City</strong><p>{viewingMember.current_city || 'Not added'}</p></div>
                  <div><strong>Country</strong><p>{viewingMember.current_country || 'Not added'}</p></div>
                  <div><strong>Relationship</strong><p>{viewingMember.family_head_name && viewingMember.relation_to_family_head ? `${relationshipLabel(viewingMember.relation_to_family_head)} of ${viewingMember.family_head_name}` : 'Not added'}</p></div>
                  <div><strong>Added By</strong><p>{[viewingMember.creator_name, viewingMember.creator_email].filter(Boolean).join(' | ') || 'Not recorded'}</p></div>
                </div>
              </section>
            ) : null}

            {!isViewingMember ? filteredMembers.map((member) => (
              <article className="member-row" key={member.id}>
                <div className="member-leading">
                  <div className="member-avatar" aria-hidden="true">
                  {member.photo_url ? (
                    <img alt="" src={member.photo_url} />
                  ) : (
                      <Network aria-hidden="true" size={18} />
                  )}
                  </div>
                  <div className="member-leading-meta">
                    <Badge variant={member.is_living ? 'success' : 'neutral'}>
                      {member.is_living ? 'Living' : 'Deceased'}
                    </Badge>
                    <button
                      className="text-action"
                      onClick={() => setViewingMember(member)}
                      type="button"
                    >
                      <Eye aria-hidden="true" size={16} />
                      View
                    </button>
                  </div>
                </div>
                <div className="member-main">
                  <div className="member-title-line">
                    <strong>{member.display_name}</strong>
                  </div>
                  <small>
                    {[
                      member.household_name ?? member.display_family_name,
                      [member.current_city, member.current_country].filter(Boolean).join(', '),
                    ].filter(Boolean).join(' | ') || 'No details'}
                  </small>
                </div>
                <div className="member-meta">
                  {canUploadMemberPhotos ? (
                    <label className="text-action" htmlFor={`member-photo-${member.id}`}>
                      <Upload aria-hidden="true" size={16} />
                      Upload Photo
                      <input
                        accept="image/*"
                        id={`member-photo-${member.id}`}
                        onChange={(event) => {
                          const file = event.target.files?.[0] ?? null;
                          void handleMemberPhotoUpload(member.id, file);
                          event.target.value = '';
                        }}
                        style={{ display: 'none' }}
                        type="file"
                      />
                    </label>
                  ) : null}
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
            )) : null}

            {!isViewingMember && !isLoading && filteredMembers.length === 0 ? (
              <div className="empty-state">
                <UsersRound aria-hidden="true" />
                <strong>{searchTerm ? 'No members found' : 'No members yet'}</strong>
                <p>{searchTerm ? 'Try a different search keyword.' : 'Add the first family member to start building the tree.'}</p>
              </div>
            ) : null}
          </div>
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

function relationshipLabel(value) {
  return relationshipOptions.find(([optionValue]) => optionValue === value)?.[1] ?? value;
}

function buildMemberRequestPayload(payload, photoFile) {
  if (!photoFile) {
    return payload;
  }

  const formData = new FormData();

  Object.entries(payload).forEach(([key, value]) => {
    if (value === null || value === undefined || value === '') {
      return;
    }

    if (typeof value === 'boolean') {
      formData.append(key, value ? '1' : '0');
      return;
    }

    formData.append(key, String(value));
  });

  formData.append('photo', photoFile);
  return formData;
}
