import { useState } from 'react';
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom';
import { LogIn, Mail, Network, ShieldCheck } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_HOME, ROLES } from '../config/roles.js';
import { Alert, Button, Card, Input } from '../app/components';

export function LoginPage() {
  const { isAuthenticated, login, user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [form, setForm] = useState({ email: '', password: '' });
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (isAuthenticated && user) {
    return (
      <Navigate
        to={user.role === ROLES.USER ? '/app/connect' : ROLE_HOME[user.role] ?? ROLE_HOME[ROLES.USER]}
        replace
      />
    );
  }

  const redirectTo = location.state?.from?.pathname;

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      const nextUser = await login(form);
      const nextRoute =
        nextUser.role === ROLES.USER
          ? '/app/connect'
          : redirectTo ?? ROLE_HOME[nextUser.role] ?? ROLE_HOME[ROLES.USER];

      navigate(nextRoute, { replace: true });
    } catch (loginError) {
      setError(loginError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="auth-page">
      <Card className="auth-panel" padding="lg" variant="elevated">
        <div className="brand-mark">
          <Network aria-hidden="true" />
        </div>
        <p className="eyebrow">Family Network Platform</p>
        <h1>Sign in to your family workspace</h1>
        <p className="auth-copy">
          Access is role-aware for Super Admin, Admin, and End User accounts.
        </p>

        <form className="auth-form" onSubmit={handleSubmit}>
          <Input
            autoComplete="email"
            label="Email"
            leftIcon={<Mail aria-hidden="true" size={18} />}
            type="email"
            value={form.email}
            onChange={(event) => setForm({ ...form, email: event.target.value })}
            required
            fullWidth
          />

          <Input
            autoComplete="current-password"
            label="Password"
            leftIcon={<ShieldCheck aria-hidden="true" size={18} />}
            type="password"
            value={form.password}
            onChange={(event) => setForm({ ...form, password: event.target.value })}
            required
            fullWidth
          />

          {error ? <Alert variant="error">{error}</Alert> : null}

          <Button disabled={isSubmitting} fullWidth isLoading={isSubmitting} type="submit">
            <LogIn aria-hidden="true" />
            Sign in
          </Button>
        </form>

        <p className="auth-switch">
          New family member? <Link to="/register">Create an account</Link>
        </p>
      </Card>
    </main>
  );
}
