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

const endUserAddMemberTypes = ['spouse', 'child', 'parent', 'sibling'];

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
  const [sortBy, setSortBy] = useState('recent_first');
  const [addStep, setAddStep] = useState(1);
  const [isStep3Confirmed, setIsStep3Confirmed] = useState(false);
  const [photoFile, setPhotoFile] = useState(null);
  const [photoPreviewUrl, setPhotoPreviewUrl] = useState('');
  const [photoObjectUrl, setPhotoObjectUrl] = useState('');
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [cameraError, setCameraError] = useState('');
  const [createdMember, setCreatedMember] = useState(null);
  const videoRef = useRef(null);
  const canvasRef = useRef(null);
  const cameraStreamRef = useRef(null);

  const canDeleteMembers = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const canEditMembers = role === ROLES.SUPER_ADMIN || role === ROLES.ADMIN;
  const canUploadMemberPhotos = Boolean(token);
  const isMemberFormOpen = isAddingMember || Boolean(editingMember);
  const isEditingMember = Boolean(editingMember);
  const isViewingMember = Boolean(viewingMember);
  const isEndUserAddFlow = role === ROLES.USER && !isEditingMember;
  const isEndUserRole = role === ROLES.USER;
  const allowedAddMemberTypes = useMemo(
    () => (role === ROLES.USER ? endUserAddMemberTypes : addMemberTypeOptions.map(([value]) => value)),
    [role],
  );

  const addMemberTypeOptionsForRole = useMemo(
    () => (role === ROLES.USER ? addMemberTypeOptions.filter(([value]) => endUserAddMemberTypes.includes(value)) : addMemberTypeOptions),
    [role],
  );
  const selectedFamilyId = form.family_id || directoryFamilyId || families[0]?.id || user.family_id || '';
  const linkedMemberId = useMemo(
    () => (
      members.find((item) => item.user_id === user.id)?.id
      ?? members.find((item) => item.email && user.email && item.email.toLowerCase() === user.email.toLowerCase())?.id
      ?? ''
    ),
    [members, user.email, user.id],
  );
  const linkedHouseholds = useMemo(
    () => households.filter((household) => (
      Number(household.primary_person_id) === Number(linkedMemberId)
      || Number(household.spouse_person_id) === Number(linkedMemberId)
    )),
    [households, linkedMemberId],
  );
  const requiresHouseholdSelection = isEndUserAddFlow && form.add_member_type === 'child' && linkedHouseholds.length > 1;
  const resolvedHouseholdId = useMemo(() => {
    if (form.add_member_type !== 'child') {
      return form.household_id;
    }

    if (form.household_id) {
      return form.household_id;
    }

    if (linkedHouseholds.length === 1) {
      return String(linkedHouseholds[0].id);
    }

    return '';
  }, [form.add_member_type, form.household_id, linkedHouseholds]);
  const effectiveForm = useMemo(
    () => ({
      ...form,
      existing_person_id: isEndUserAddFlow && needsExistingPerson(form.add_member_type)
        ? (form.existing_person_id || String(linkedMemberId || ''))
        : form.existing_person_id,
      household_id: isEndUserAddFlow && form.add_member_type === 'child'
        ? resolvedHouseholdId
        : form.household_id,
    }),
    [form, isEndUserAddFlow, linkedMemberId, resolvedHouseholdId],
  );
  const requiresStepConfirmation = !isEditingMember && !isEndUserAddFlow && form.add_member_type !== 'existing_to_household';
  const canSubmitMemberForm = isEditingMember
    ? Boolean(selectedFamilyId && form.first_name)
    : canSubmitAddMemberForm(selectedFamilyId, effectiveForm, {
      ignoreHouseholdRequirement: isEndUserAddFlow && form.add_member_type !== 'child',
    }) && (!requiresStepConfirmation || isStep3Confirmed);

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
      if (sortBy === 'recent_first') {
        const aDate = a.created_at ? Date.parse(a.created_at) : null;
        const bDate = b.created_at ? Date.parse(b.created_at) : null;

        if (aDate && bDate) {
          return bDate - aDate;
        }

        if (aDate) {
          return -1;
        }

        if (bDate) {
          return 1;
        }

        return Number(b.id) - Number(a.id);
      }

      if (sortBy === 'dob_oldest_first') {
        const aDob = a.birth_date ? Date.parse(a.birth_date) : Infinity;
        const bDob = b.birth_date ? Date.parse(b.birth_date) : Infinity;

        return aDob - bDob || a.display_name.localeCompare(b.display_name);
      }

      if (sortBy === 'dob_newest_first') {
        const aDob = a.birth_date ? Date.parse(a.birth_date) : -Infinity;
        const bDob = b.birth_date ? Date.parse(b.birth_date) : -Infinity;

        return bDob - aDob || a.display_name.localeCompare(b.display_name);
      }

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
      const resolvedExistingPersonId = needsExistingPerson(addMemberType)
        ? (form.existing_person_id || (isEndUserAddFlow ? String(linkedMemberId || '') : ''))
        : '';
      const resolvedSubmitHouseholdId = needsHousehold(addMemberType)
        ? (form.household_id || (isEndUserAddFlow && addMemberType === 'child' ? resolvedHouseholdId : ''))
        : '';
      if (!isEditingMember && needsExistingPerson(addMemberType) && !resolvedExistingPersonId) {
        setError('Could not find your linked member profile. Open Tree and use quick add from your card, or ask admin to link your account.');
        setIsSubmitting(false);
        return;
      }
      if (!isEditingMember && needsHousehold(addMemberType) && !resolvedSubmitHouseholdId) {
        setError('Please select a household before adding a child.');
        setIsSubmitting(false);
        return;
      }
      const payload = {
        ...form,
        family_id: Number(isEditingMember ? form.tree_family_id || editingMember.family_id : selectedFamilyId),
        add_member_type: addMemberType,
        existing_person_id: needsExistingPerson(addMemberType) && resolvedExistingPersonId
          ? Number(resolvedExistingPersonId)
          : null,
        household_id: needsHousehold(addMemberType) && resolvedSubmitHouseholdId ? Number(resolvedSubmitHouseholdId) : null,
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
      
      // For end user flow, show success screen
      if (isEndUserAddFlow) {
        setCreatedMember(result);
        setAddStep(9); // Success screen
      } else {
        setForm({ ...emptyForm, family_id: selectedFamilyId });
        clearPhotoState('');
        setSuccess(createMemberSuccessMessage(result));
        setIsAddingMember(false);
      }
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
    setAddStep(isEndUserAddFlow ? 2 : 1); // Skip to confirm for end users
    setIsStep3Confirmed(false);
  }

  function showAddMemberForm() {
    setError('');
    setSuccess('');
    setEditingMember(null);
    setForm({
      ...emptyForm,
      family_id: selectedFamilyId,
      add_member_type: allowedAddMemberTypes.includes(form.add_member_type)
        ? form.add_member_type
        : allowedAddMemberTypes[0],
      marital_status: ['child', 'sibling'].includes(form.add_member_type) ? 'unmarried' : 'married',
    });
    setAddStep(isEndUserAddFlow ? 1 : 1); // End users start at relationship selection
    setIsStep3Confirmed(false);
    setCreatedMember(null);
    clearPhotoState('');
    setIsAddingMember(true);
  }

  useEffect(() => {
    const params = new URLSearchParams(location.search);
    if (params.get('quick_add') !== '1') {
      return;
    }

    const type = params.get('type') ?? 'spouse';
    const addType = allowedAddMemberTypes.includes(type) ? type : allowedAddMemberTypes[0] || 'spouse';
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
  }, [location.search, selectedFamilyId, allowedAddMemberTypes]);

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
    setCreatedMember(null);
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
    if (isEndUserAddFlow) {
      // Screen 1: Relationship Selection
      if (step === 1) {
        return Boolean(form.add_member_type);
      }
      // Screen 2: Confirm Relationship
      if (step === 2) {
        if (form.add_member_type === 'child' && requiresHouseholdSelection) {
          return Boolean(form.household_id);
        }

        return true; // Can always proceed
      }
      // Screen 3: Basic Details (Name, Gender)
      if (step === 3) {
        return Boolean(form.first_name && form.gender);
      }
      // Screen 4: Birth Details (DOB, Birth Time)
      if (step === 4) {
        return Boolean(form.birth_date);
      }
      // Screen 5: Contact Details (Email, Phone, Location)
      if (step === 5) {
        return Boolean(form.email && form.phone && form.current_city && form.current_country);
      }
      // Screen 6: Photo Upload
      if (step === 6) {
        return true; // Photo is optional
      }
      // Screen 7: Status Details (Living, Married)
      if (step === 7) {
        return Boolean(form.living_status && form.marital_status);
      }
      // Screen 8: Review Screen
      if (step === 8) {
        return true; // Can always review
      }
      // Screen 9: Success Screen
      if (step === 9) {
        return Boolean(createdMember);
      }
      return true;
    }

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

      <section className={`dashboard-content ${isMemberFormOpen ? 'members-form-open' : ''}`}>
        {!isMemberFormOpen ? (
          <header className="dashboard-header">
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
            <Button onClick={logout} type="button" variant="outline">
              <LogOut aria-hidden="true" />
              Logout
            </Button>
          </header>
        ) : null}

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
                <option value="recent_first">Recently added</option>
                <option value="name_asc">Name A-Z</option>
                <option value="name_desc">Name Z-A</option>
                <option value="dob_oldest_first">DOB oldest first</option>
                <option value="dob_newest_first">DOB newest first</option>
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
                  {isEndUserAddFlow ? (
                    <div className="member-add-flow-fullscreen">
                      {/* Screen 1: Relationship Selection */}
                      {addStep === 1 && (
                        <div className="flow-screen flow-screen-1">
                          <h2>Who do you want to add?</h2>
                          <div className="flow-options">
                            {addMemberTypeOptionsForRole.map(([value, label]) => (
                              <button
                                key={value}
                                className={`flow-option-card ${form.add_member_type === value ? 'active' : ''}`}
                                onClick={() => updateAddMemberType(value)}
                                type="button"
                              >
                                <span className="option-text">{label.replace('Add ', '')}</span>
                              </button>
                            ))}
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(2)}
                              disabled={!canProceedStep(1)}
                              fullWidth
                            >
                              Next
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 2: Confirm Relationship */}
                      {addStep === 2 && (
                        <div className="flow-screen flow-screen-2">
                          <h2>Confirm the relationship</h2>
                          <div className="flow-confirmation">
                            <div className="confirmation-item">
                              <span className="label">Relationship:</span>
                              <span className="value">{addMemberTypeOptionsForRole.find(([value]) => value === form.add_member_type)?.[1].replace('Add ', '')}</span>
                            </div>
                            <div className="confirmation-item">
                              <span className="label">Related to:</span>
                              <span className="value">You (the logged-in user)</span>
                            </div>
                            {form.add_member_type === 'child' && requiresHouseholdSelection ? (
                              <label className="field-group member-form-wide">
                                Household / Couple Family
                                <select
                                  value={form.household_id}
                                  onChange={(event) => updateForm('household_id', event.target.value)}
                                  required
                                >
                                  <option value="">Select household</option>
                                  {linkedHouseholds.map((household) => (
                                    <option key={household.id} value={household.id}>
                                      {household.name}
                                    </option>
                                  ))}
                                </select>
                                <small>
                                  You have multiple households. Select where this child should be added.
                                </small>
                              </label>
                            ) : null}
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(1)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={() => setAddStep(3)}
                              fullWidth
                            >
                              Confirm
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 3: Basic Details (Name, Gender) */}
                      {addStep === 3 && (
                        <div className="flow-screen flow-screen-3">
                          <h2>Basic information</h2>
                          <div className="flow-inputs">
                            <Input
                              label="Full Name"
                              leftIcon={<UserRound aria-hidden="true" size={20} />}
                              value={form.first_name}
                              onChange={(event) => updateForm('first_name', event.target.value)}
                              placeholder="Enter full name"
                              required
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
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(2)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={() => setAddStep(4)}
                              disabled={!canProceedStep(3)}
                              fullWidth
                            >
                              Next
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 4: Birth Details */}
                      {addStep === 4 && (
                        <div className="flow-screen flow-screen-4">
                          <h2>Date of birth</h2>
                          <div className="flow-inputs">
                            <Input
                              label="Birth Date"
                              leftIcon={<CalendarDays aria-hidden="true" size={20} />}
                              type="date"
                              value={form.birth_date}
                              onChange={(event) => updateForm('birth_date', event.target.value)}
                              required
                              fullWidth
                            />
                            <Input
                              label="Birth Time (optional)"
                              leftIcon={<Clock3 aria-hidden="true" size={20} />}
                              type="time"
                              value={form.birth_time}
                              onChange={(event) => updateForm('birth_time', event.target.value)}
                              fullWidth
                            />
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(3)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={() => setAddStep(5)}
                              disabled={!canProceedStep(4)}
                              fullWidth
                            >
                              Next
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 5: Contact Details */}
                      {addStep === 5 && (
                        <div className="flow-screen flow-screen-5">
                          <h2>Contact information</h2>
                          <div className="flow-inputs">
                            <Input
                              label="Email"
                              leftIcon={<Mail aria-hidden="true" size={20} />}
                              type="email"
                              value={form.email}
                              onChange={(event) => updateForm('email', event.target.value)}
                              required
                              fullWidth
                            />
                            <Input
                              label="Phone"
                              leftIcon={<Phone aria-hidden="true" size={20} />}
                              value={form.phone}
                              onChange={(event) => updateForm('phone', event.target.value)}
                              required
                              fullWidth
                            />
                            <Input
                              label="City"
                              leftIcon={<MapPin aria-hidden="true" size={20} />}
                              value={form.current_city}
                              onChange={(event) => updateForm('current_city', event.target.value)}
                              required
                              fullWidth
                            />
                            <Input
                              label="Country"
                              leftIcon={<Globe2 aria-hidden="true" size={20} />}
                              value={form.current_country}
                              onChange={(event) => updateForm('current_country', event.target.value)}
                              required
                              fullWidth
                            />
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(4)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={() => setAddStep(6)}
                              disabled={!canProceedStep(5)}
                              fullWidth
                            >
                              Next
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 6: Photo Upload */}
                      {addStep === 6 && (
                        <div className="flow-screen flow-screen-6">
                          <h2>Add a photo</h2>
                          <div className="flow-photo-section">
                            <div className="flow-photo-preview">
                              {photoPreviewUrl ? (
                                <img alt="Member preview" src={photoPreviewUrl} />
                              ) : (
                                <Network aria-hidden="true" size={48} />
                              )}
                            </div>
                            <div className="flow-photo-actions">
                              <label className="flow-photo-upload">
                                <Upload aria-hidden="true" size={20} />
                                <span>Choose Photo</span>
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
                                  style={{ display: 'none' }}
                                />
                              </label>
                              <Button
                                onClick={openCamera}
                                variant="outline"
                                fullWidth
                              >
                                <span>Take Photo</span>
                              </Button>
                            </div>
                            {isCameraOpen && (
                              <div className="flow-camera-panel">
                                <video autoPlay playsInline ref={videoRef} />
                                <div className="flow-camera-actions">
                                  <Button onClick={captureFromCamera} fullWidth>
                                    Capture
                                  </Button>
                                  <Button onClick={stopCamera} variant="outline" fullWidth>
                                    Cancel
                                  </Button>
                                </div>
                              </div>
                            )}
                            {cameraError && <p className="flow-error">{cameraError}</p>}
                            <canvas ref={canvasRef} style={{ display: 'none' }} />
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(5)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={() => setAddStep(7)}
                              fullWidth
                            >
                              Next
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 7: Status Details */}
                      {addStep === 7 && (
                        <div className="flow-screen flow-screen-7">
                          <h2>Current status</h2>
                          <div className="flow-inputs">
                            <TextField
                              fullWidth
                              label="Marital Status"
                              onChange={(event) => updateForm('marital_status', event.target.value)}
                              select
                              value={form.marital_status}
                            >
                              <MenuItem value="unmarried">Unmarried</MenuItem>
                              <MenuItem value="married">Married</MenuItem>
                            </TextField>
                            <TextField
                              fullWidth
                              label="Living Status"
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
                              select
                              value={form.living_status}
                            >
                              <MenuItem value="living">Living</MenuItem>
                              <MenuItem value="deceased">Deceased</MenuItem>
                            </TextField>
                            {form.living_status === 'deceased' && (
                              <>
                                <Input
                                  label="Date of Passing"
                                  leftIcon={<CalendarDays aria-hidden="true" size={20} />}
                                  type="date"
                                  value={form.death_date}
                                  onChange={(event) => updateForm('death_date', event.target.value)}
                                  fullWidth
                                />
                                <Input
                                  label="Graveyard Location"
                                  leftIcon={<MapPin aria-hidden="true" size={20} />}
                                  value={form.graveyard_location}
                                  onChange={(event) => updateForm('graveyard_location', event.target.value)}
                                  fullWidth
                                />
                              </>
                            )}
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(6)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={() => setAddStep(8)}
                              disabled={!canProceedStep(7)}
                              fullWidth
                            >
                              Review
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 8: Review */}
                      {addStep === 8 && (
                        <div className="flow-screen flow-screen-8">
                          <h2>Review your information</h2>
                          <div className="flow-review">
                            <div className="review-section">
                              <div className="review-item">
                                <span className="label">Relationship:</span>
                                <span className="value">{addMemberTypeOptionsForRole.find(([value]) => value === form.add_member_type)?.[1].replace('Add ', '')}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Full Name:</span>
                                <span className="value">{form.first_name || 'Not set'}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Gender:</span>
                                <span className="value">{form.gender || 'Not set'}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Birth Date:</span>
                                <span className="value">{form.birth_date || 'Not set'}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Email:</span>
                                <span className="value">{form.email || 'Not set'}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Phone:</span>
                                <span className="value">{form.phone || 'Not set'}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Location:</span>
                                <span className="value">{[form.current_city, form.current_country].filter(Boolean).join(', ') || 'Not set'}</span>
                              </div>
                              {form.add_member_type === 'child' ? (
                                <div className="review-item">
                                  <span className="label">Household:</span>
                                  <span className="value">
                                    {linkedHouseholds.find((household) => String(household.id) === String(resolvedHouseholdId))?.name || 'Not selected'}
                                  </span>
                                </div>
                              ) : null}
                              <div className="review-item">
                                <span className="label">Marital Status:</span>
                                <span className="value">{form.marital_status}</span>
                              </div>
                              <div className="review-item">
                                <span className="label">Living Status:</span>
                                <span className="value">{form.living_status === 'living' ? 'Living' : 'Deceased'}</span>
                              </div>
                            </div>
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={() => setAddStep(7)}
                              variant="outline"
                              fullWidth
                            >
                              Back
                            </Button>
                            <Button
                              onClick={handleSubmit}
                              disabled={!canSubmitMemberForm || isSubmitting}
                              isLoading={isSubmitting}
                              fullWidth
                            >
                              Add Member
                            </Button>
                          </div>
                        </div>
                      )}

                      {/* Screen 9: Success */}
                      {addStep === 9 && createdMember && (
                        <div className="flow-screen flow-screen-9">
                          <div className="flow-success">
                            <div className="success-avatar">
                              {createdMember.photo_url || photoPreviewUrl ? (
                                <img
                                  alt={createdMember.display_name}
                                  src={createdMember.photo_url || photoPreviewUrl}
                                />
                              ) : (
                                <Network aria-hidden="true" size={80} />
                              )}
                            </div>
                            <h2>{createdMember.display_name}</h2>
                            <p className="success-subtitle">
                              {addMemberTypeOptionsForRole.find(([value]) => value === form.add_member_type)?.[1].replace('Add ', '')} added successfully!
                            </p>
                            <div className="flow-confirmation">
                              <div className="confirmation-item">
                                <span className="label">Child Name:</span>
                                <span className="value">{createdMember.display_name || form.first_name || 'Not set'}</span>
                              </div>
                              <div className="confirmation-item">
                                <span className="label">Gender:</span>
                                <span className="value">{createdMember.gender || form.gender || 'Not set'}</span>
                              </div>
                              <div className="confirmation-item">
                                <span className="label">Date of Birth:</span>
                                <span className="value">{createdMember.birth_date || form.birth_date || 'Not set'}</span>
                              </div>
                              <div className="confirmation-item">
                                <span className="label">Age:</span>
                                <span className="value">{memberAge(createdMember.birth_date || form.birth_date)}</span>
                              </div>
                            </div>
                          </div>
                          <div className="flow-actions">
                            <Button
                              onClick={hideAddMemberForm}
                              fullWidth
                            >
                              Done
                            </Button>
                          </div>
                        </div>
                      )}
                    </div>
                  ) : (
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
                  )}
                </>
              ) : null}

              {(!isEndUserAddFlow && (isEditingMember || addStep === 2)) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
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

              {(!isEndUserAddFlow && (isEditingMember || addStep === 3)) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
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

              {(!isEndUserAddFlow && (isEditingMember || addStep === 4)) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
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

              {(!isEndUserAddFlow && (isEditingMember || addStep === 5)) && (form.add_member_type !== 'existing_to_household' || isEditingMember) ? (
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

              {!isEndUserAddFlow && !isEditingMember ? (
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
              ) : isEditingMember ? (
                <Button
                  className="member-form-action"
                  disabled={isSubmitting || !canSubmitMemberForm}
                  isLoading={isSubmitting}
                  type="submit"
                >
                  <Pencil aria-hidden="true" />
                  Update member
                </Button>
              ) : null}
            </form>
          </Card>
        ) : (
          <div className="member-list">
            {isViewingMember ? (
              <section className={`member-fullscreen-view ${isEndUserRole ? 'member-profile-view' : ''}`} aria-label="Member details">
                {isEndUserRole ? (
                  <>
                    <div className="member-profile-topbar">
                      <button className="text-action" onClick={() => setViewingMember(null)} type="button">
                        <X aria-hidden="true" size={16} />
                        Close
                      </button>
                      <button className="member-profile-edit-fab" onClick={() => showEditMemberForm(viewingMember)} type="button">
                        <Pencil aria-hidden="true" size={16} />
                      </button>
                    </div>
                    <div className="member-profile-hero" />
                    <div className="member-profile-head">
                      <div className="member-profile-avatar" aria-hidden="true">
                        {viewingMember.photo_url ? (
                          <img alt="" src={viewingMember.photo_url} />
                        ) : (
                          <Network aria-hidden="true" size={46} />
                        )}
                      </div>
                      <h3>{viewingMember.display_name}</h3>
                      <p>{viewingMember.household_name || viewingMember.display_family_name || 'Family member'}</p>
                      <small>{[viewingMember.current_city, viewingMember.current_country].filter(Boolean).join(', ') || 'Location not added'}</small>
                    </div>
                    <div className="member-profile-card">
                      <div className="member-profile-grid">
                        <div><strong>Date of Birth</strong><p>{viewingMember.birth_date || 'Not added'}</p></div>
                        <div><strong>Gender</strong><p>{viewingMember.gender || 'Not added'}</p></div>
                        <div><strong>Age</strong><p>{memberAge(viewingMember.birth_date)}</p></div>
                        <div><strong>Status</strong><p>{viewingMember.is_living ? 'Living' : 'Deceased'}</p></div>
                        <div><strong>Mobile Number</strong><p>{viewingMember.phone || 'Not added'}</p></div>
                        <div><strong>E-Mail ID</strong><p>{viewingMember.email || 'Not added'}</p></div>
                        <div><strong>Relationship</strong><p>{viewingMember.family_head_name && viewingMember.relation_to_family_head ? `${relationshipLabel(viewingMember.relation_to_family_head)} of ${viewingMember.family_head_name}` : 'Not added'}</p></div>
                        <div><strong>Family</strong><p>{viewingMember.display_family_name || 'Not added'}</p></div>
                      </div>
                    </div>
                  </>
                ) : (
                  <>
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
                  </>
                )}
              </section>
            ) : null}

            {!isViewingMember && isLoading ? (
              [...Array(5)].map((_, index) => (
                <article className="member-row member-row-skeleton" key={`member-skeleton-${index}`}>
                  <div className="member-leading">
                    <div className="member-avatar member-skeleton-block" aria-hidden="true" />
                    <div className="member-leading-meta">
                      <span className="member-skeleton-pill" />
                      <span className="member-skeleton-line short" />
                    </div>
                  </div>
                  <div className="member-main">
                    <div className="member-title-line">
                      <span className="member-skeleton-line medium" />
                    </div>
                    <small className="member-skeleton-line long" />
                  </div>
                  <div className="member-meta">
                    <span className="member-skeleton-line short" />
                  </div>
                </article>
              ))
            ) : null}

            {!isViewingMember && !isLoading ? filteredMembers.map((member) => (
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
                      className={isEndUserRole ? 'text-action member-inline-action' : 'text-action'}
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
                      className={isEndUserRole ? 'text-action member-inline-action' : 'text-action'}
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

function canSubmitAddMemberForm(
  selectedFamilyId,
  form,
  {
    ignoreHouseholdRequirement = false,
    ignoreExistingPersonRequirement = false,
  } = {},
) {
  if (!selectedFamilyId || !canSubmitAddMemberType(form.add_member_type)) {
    return false;
  }

  if (form.add_member_type === 'existing_to_household') {
    return Boolean(form.existing_person_id && form.household_id);
  }

  if (!ignoreExistingPersonRequirement && needsExistingPerson(form.add_member_type) && !form.existing_person_id) {
    return false;
  }

  if (!ignoreHouseholdRequirement && needsHousehold(form.add_member_type) && !form.household_id) {
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

function memberAge(birthDate) {
  if (!birthDate) {
    return 'Not set';
  }

  const dob = new Date(birthDate);
  if (Number.isNaN(dob.getTime())) {
    return 'Not set';
  }

  const today = new Date();
  let age = today.getFullYear() - dob.getFullYear();
  const monthDelta = today.getMonth() - dob.getMonth();

  if (monthDelta < 0 || (monthDelta === 0 && today.getDate() < dob.getDate())) {
    age -= 1;
  }

  return age >= 0 ? `${age} years` : 'Not set';
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
