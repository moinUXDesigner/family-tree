import { useMemo, useState } from 'react';
import { Link, Navigate, useLocation, useNavigate, useSearchParams } from 'react-router-dom';
import { KeyRound, LockKeyhole, Mail, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { Alert, Button, Card, Input } from '../app/components';
import { apiClient } from '../services/apiClient.js';

export function ResetPasswordPage() {
  const { isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [searchParams] = useSearchParams();
  const fromForgot = location.state?.fromForgot;
  const [form, setForm] = useState({
    email: searchParams.get('email') ?? '',
    token: searchParams.get('token') ?? '',
    password: '',
    password_confirmation: '',
  });
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const copy = useMemo(
    () =>
      fromForgot
        ? 'Check your inbox for the reset token or link, then submit a new password here.'
        : 'Use the token from your reset email to update your password.',
    [fromForgot],
  );

  if (isAuthenticated) {
    return <Navigate to="/" replace />;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      await apiClient.post('/reset-password', form);
      navigate('/password-changed', { replace: true });
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="auth-page">
      <Card className="auth-panel" padding="lg" variant="elevated">
        <p className="eyebrow">Password Update</p>
        <h1>Set a new password</h1>
        <p className="auth-copy">{copy}</p>

        <form className="auth-form" onSubmit={handleSubmit}>
          <Input
            autoComplete="email"
            label="Email"
            leftIcon={<Mail aria-hidden="true" size={18} />}
            onChange={(event) => setForm({ ...form, email: event.target.value })}
            required
            type="email"
            value={form.email}
            fullWidth
          />

          <Input
            label="Reset Token"
            leftIcon={<KeyRound aria-hidden="true" size={18} />}
            onChange={(event) => setForm({ ...form, token: event.target.value })}
            required
            type="text"
            value={form.token}
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
            label="Confirm Password"
            leftIcon={<ShieldCheck aria-hidden="true" size={18} />}
            onChange={(event) => setForm({ ...form, password_confirmation: event.target.value })}
            required
            type="password"
            value={form.password_confirmation}
            fullWidth
          />

          {error ? <Alert variant="error">{error}</Alert> : null}

          <Button disabled={isSubmitting} fullWidth isLoading={isSubmitting} type="submit">
            Reset Password
          </Button>
        </form>

        <p className="auth-switch">
          <Link to="/login">Back to sign in</Link>
        </p>
      </Card>
    </main>
  );
}
