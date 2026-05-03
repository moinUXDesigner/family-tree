import { useState } from 'react';
import { Link } from 'react-router-dom';
import { UserRound, ShieldCheck, Pencil, X } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_LABELS } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Button, Card, Input } from '../app/components';

export function ProfilePage() {
  const { updateProfile, user } = useAuth();
  const [isEditing, setIsEditing] = useState(false);
  const [name, setName] = useState(user?.name ?? '');
  const [phone, setPhone] = useState(user?.phone ?? '');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  if (!user) {
    return null;
  }

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
              <UserRound size={30} />
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
