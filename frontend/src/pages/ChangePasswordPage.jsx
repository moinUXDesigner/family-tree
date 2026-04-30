import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { KeyRound, LockKeyhole, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Alert, Button, Card, Input } from '../app/components';
import { apiClient } from '../services/apiClient.js';

export function ChangePasswordPage() {
  const { logout, token, user } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({
    current_password: '',
    password: '',
    password_confirmation: '',
  });
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!user) {
    return null;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      await apiClient.post('/change-password', form, token);
      await logout();
      navigate('/password-changed', { replace: true });
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
            <h1>Change Password</h1>
            <p>Use a strong password with at least 8 characters.</p>
          </div>
        </header>

        <Card className="profile-card" padding="lg" variant="elevated">
          <form className="auth-form" onSubmit={handleSubmit}>
            <Input
              autoComplete="current-password"
              label="Current Password"
              leftIcon={<KeyRound aria-hidden="true" size={18} />}
              onChange={(event) => setForm({ ...form, current_password: event.target.value })}
              required
              type="password"
              value={form.current_password}
              fullWidth
            />

            <Input
              autoComplete="new-password"
              label="New Password"
              leftIcon={<LockKeyhole aria-hidden="true" size={18} />}
              onChange={(event) => setForm({ ...form, password: event.target.value })}
              required
              type="password"
              value={form.password}
              fullWidth
            />

            <Input
              autoComplete="new-password"
              label="Confirm New Password"
              leftIcon={<ShieldCheck aria-hidden="true" size={18} />}
              onChange={(event) => setForm({ ...form, password_confirmation: event.target.value })}
              required
              type="password"
              value={form.password_confirmation}
              fullWidth
            />

            {error ? <Alert variant="error">{error}</Alert> : null}

            <Button disabled={isSubmitting} fullWidth isLoading={isSubmitting} type="submit">
              Update Password
            </Button>
          </form>
        </Card>
      </section>
    </main>
  );
}
