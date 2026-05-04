import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import { UserRound, ShieldCheck, Pencil, X } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLES, ROLE_HOME, ROLE_LABELS } from '../config/roles.js';
import { familyApi } from '../services/familyApi.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Button, Card, Input } from '../app/components';

const memberRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/members',
  [ROLES.ADMIN]: '/admin/members',
  [ROLES.USER]: '/app/members',
};

export function ProfilePage() {
  const { token, updateProfile, user } = useAuth();
  const [isEditing, setIsEditing] = useState(false);
  const [name, setName] = useState(user?.name ?? '');
  const [phone, setPhone] = useState(user?.phone ?? '');
  const [member, setMember] = useState(null);
  const [isLoadingMember, setIsLoadingMember] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  if (!user) {
    return null;
  }

  useEffect(() => {
    let isMounted = true;

    async function loadMemberProfile() {
      if (!token || !user.family_id) {
        if (isMounted) {
          setMember(null);
        }
        return;
      }

      setIsLoadingMember(true);

      try {
        const members = await familyApi.listMembers(token, user.family_id);
        if (!isMounted) {
          return;
        }

        const linkedMember = members.find((item) => item.user_id === user.id)
          ?? members.find((item) => item.email && user.email && item.email.toLowerCase() === user.email.toLowerCase())
          ?? null;
        setMember(linkedMember);
      } catch {
        if (isMounted) {
          setMember(null);
        }
      } finally {
        if (isMounted) {
          setIsLoadingMember(false);
        }
      }
    }

    loadMemberProfile();

    return () => {
      isMounted = false;
    };
  }, [token, user.email, user.family_id, user.id]);

  const memberEditRoute = useMemo(() => {
    const baseRoute = memberRoutes[user.role] ?? ROLE_HOME[user.role] ?? '/app/members';
    return member?.id ? `${baseRoute}?edit_member_id=${encodeURIComponent(member.id)}` : baseRoute;
  }, [member?.id, user.role]);

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setSuccess('');

    if (!name.trim()) {
      setError('Name is required.');
      return;
    }

    setIsSubmitting(true);
    try {
      await updateProfile({
        name: name.trim(),
        phone: phone.trim() || null,
      });
      setSuccess('Profile updated successfully.');
      setIsEditing(false);
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="dashboard-page">
      <NavigationChrome active="profile" role={user.role} />

      <section className="dashboard-content profile-content">
        <header className="dashboard-header">
          <div>
            <h1>Your Profile</h1>
            <p>Review your account information and keep your password secure.</p>
          </div>
        </header>

        {error ? <Alert variant="error">{error}</Alert> : null}
        {success ? <Alert variant="success">{success}</Alert> : null}

        <Card className="profile-card" padding="lg" variant="elevated">
          <div className="profile-header">
            <div className="profile-avatar" aria-hidden="true">
              {member?.photo_url ? <img alt="" src={member.photo_url} /> : <UserRound size={30} />}
            </div>
            <div>
              <h2>{user.name}</h2>
              <p>{ROLE_LABELS[user.role] ?? user.role}</p>
            </div>
          </div>

          {isEditing ? (
            <form className="member-form" onSubmit={handleSubmit}>
              <Input
                label="Name"
                value={name}
                onChange={(event) => setName(event.target.value)}
                required
                fullWidth
              />
              <Input
                label="Phone"
                value={phone}
                onChange={(event) => setPhone(event.target.value)}
                fullWidth
              />
              <div className="member-form-wide members-step-actions">
                <Button
                  onClick={() => {
                    setIsEditing(false);
                    setName(user.name ?? '');
                    setPhone(user.phone ?? '');
                    setError('');
                  }}
                  type="button"
                  variant="outline"
                >
                  <X aria-hidden="true" />
                  Cancel
                </Button>
                <Button disabled={isSubmitting} isLoading={isSubmitting} type="submit">
                  <Pencil aria-hidden="true" />
                  Save
                </Button>
              </div>
            </form>
          ) : (
            <>
              <dl className="profile-fields">
                <div>
                  <dt>Email</dt>
                  <dd>{user.email}</dd>
                </div>
                <div>
                  <dt>Phone</dt>
                  <dd>{user.phone || 'Not provided'}</dd>
                </div>
                <div>
                  <dt>Approval Status</dt>
                  <dd>{user.approval_status || 'N/A'}</dd>
                </div>
                <div>
                  <dt>Family ID</dt>
                  <dd>{user.family_id ?? 'Not connected'}</dd>
                </div>
              </dl>

              <div className="profile-member-shell">
                <div className="profile-member-title-row">
                  <h3>Member Details</h3>
                  {member ? (
                    <Button component={Link} to={memberEditRoute} type="button" variant="outline">
                      <Pencil aria-hidden="true" />
                      Edit Member Details
                    </Button>
                  ) : null}
                </div>
                {isLoadingMember ? (
                  <p className="profile-member-empty">Loading member details...</p>
                ) : null}
                {!isLoadingMember && !member ? (
                  <p className="profile-member-empty">No linked member details found for this account.</p>
                ) : null}
                {member ? (
                  <div className="profile-member-steps">
                    <section className="profile-member-step">
                      <h4>Step 1: Input</h4>
                      <dl className="profile-fields">
                        <div>
                          <dt>Add Member Type</dt>
                          <dd>{member.add_member_type || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Family</dt>
                          <dd>{member.display_family_name || member.family_name || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Household</dt>
                          <dd>{member.household_name || 'N/A'}</dd>
                        </div>
                      </dl>
                    </section>

                    <section className="profile-member-step">
                      <h4>Step 2: Review</h4>
                      <dl className="profile-fields">
                        <div>
                          <dt>Full Name</dt>
                          <dd>{member.display_name || [member.first_name, member.last_name].filter(Boolean).join(' ') || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Birth Date</dt>
                          <dd>{member.birth_date || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Birth Time</dt>
                          <dd>{member.birth_time || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Gender</dt>
                          <dd>{member.gender || 'N/A'}</dd>
                        </div>
                      </dl>
                    </section>

                    <section className="profile-member-step">
                      <h4>Step 3: Contact</h4>
                      <dl className="profile-fields">
                        <div>
                          <dt>Email</dt>
                          <dd>{member.email || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Phone</dt>
                          <dd>{member.phone || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>City</dt>
                          <dd>{member.current_city || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Country</dt>
                          <dd>{member.current_country || 'N/A'}</dd>
                        </div>
                      </dl>
                    </section>

                    <section className="profile-member-step">
                      <h4>Step 4: Done</h4>
                      <dl className="profile-fields">
                        <div>
                          <dt>Marital Status</dt>
                          <dd>{member.marital_status || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Living Status</dt>
                          <dd>{member.is_living ? 'Living' : 'Deceased'}</dd>
                        </div>
                        <div>
                          <dt>Date of Expiry</dt>
                          <dd>{member.death_date || 'N/A'}</dd>
                        </div>
                        <div>
                          <dt>Graveyard Location</dt>
                          <dd>{member.graveyard_location || 'N/A'}</dd>
                        </div>
                      </dl>
                    </section>
                  </div>
                ) : null}
              </div>

              <div className="profile-actions">
                <Button onClick={() => setIsEditing(true)} type="button" variant="outline">
                  <Pencil aria-hidden="true" />
                  Edit Profile
                </Button>
                <Button component={Link} to="/change-password" type="button" variant="primary">
                  <ShieldCheck aria-hidden="true" />
                  Change Password
                </Button>
              </div>
            </>
          )}
        </Card>
      </section>
    </main>
  );
}
