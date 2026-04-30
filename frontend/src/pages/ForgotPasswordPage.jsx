import { useState } from 'react';
import { Link, Navigate, useNavigate } from 'react-router-dom';
import { ArrowLeft, Mail } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { Alert, Button, Card, Input } from '../app/components';
import { apiClient } from '../services/apiClient.js';

export function ForgotPasswordPage() {
  const { isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (isAuthenticated) {
    return <Navigate to="/" replace />;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      await apiClient.post('/forgot-password', { email });
      navigate(`/reset-password?email=${encodeURIComponent(email)}`, {
        replace: true,
        state: { fromForgot: true },
      });
    } catch (submitError) {
      setError(submitError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="auth-page">
      <Card className="auth-panel" padding="lg" variant="elevated">
        <p className="eyebrow">Account Recovery</p>
        <h1>Forgot your password?</h1>
        <p className="auth-copy">
          Enter your email to request a reset token, then continue to set a new password.
        </p>

        <form className="auth-form" onSubmit={handleSubmit}>
          <Input
            autoComplete="email"
            label="Email"
            leftIcon={<Mail aria-hidden="true" size={18} />}
            onChange={(event) => setEmail(event.target.value)}
            required
            type="email"
            value={email}
            fullWidth
          />

          {error ? <Alert variant="error">{error}</Alert> : null}

          <Button disabled={isSubmitting} fullWidth isLoading={isSubmitting} type="submit">
            Continue To Reset Password
          </Button>
        </form>

        <p className="auth-switch">
          <Link to="/login">
            <ArrowLeft aria-hidden="true" size={16} /> Back to sign in
          </Link>
        </p>
      </Card>
    </main>
  );
}
