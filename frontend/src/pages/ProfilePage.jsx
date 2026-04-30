import { Link } from 'react-router-dom';
import { UserRound, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_LABELS } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Button, Card } from '../app/components';

export function ProfilePage() {
  const { user } = useAuth();

  if (!user) {
    return null;
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
            <Button component={Link} to="/change-password" type="button" variant="primary">
              <ShieldCheck aria-hidden="true" />
              Change Password
            </Button>
          </div>
        </Card>
      </section>
    </main>
  );
}
