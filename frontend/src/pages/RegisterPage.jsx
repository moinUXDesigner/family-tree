import { useState } from 'react';
import { Link, Navigate, useNavigate } from 'react-router-dom';
import { Mail, ShieldCheck, User, UserPlus } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_HOME, ROLES } from '../config/roles.js';
import { Alert, Button, Card, Input } from '../app/components';

export function RegisterPage() {
  const { isAuthenticated, register, user } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ name: '', email: '', password: '' });
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (isAuthenticated && user) {
    return <Navigate to={ROLE_HOME[user.role] ?? ROLE_HOME[ROLES.USER]} replace />;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      const nextUser = await register(form);
      navigate(ROLE_HOME[nextUser.role] ?? ROLE_HOME[ROLES.USER], { replace: true });
    } catch (registerError) {
      setError(registerError.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="auth-page">
      <Card className="auth-panel" padding="lg" variant="elevated">
        <div className="brand-mark">
          <UserPlus aria-hidden="true" />
        </div>
        <p className="eyebrow">End User Registration</p>
        <h1>Create your family member account</h1>
        <p className="auth-copy">
          New registrations are created as End User accounts. Admin roles are assigned by platform or family admins.
        </p>

        <form className="auth-form" onSubmit={handleSubmit}>
          <Input
            autoComplete="name"
            label="Full name"
            leftIcon={<User aria-hidden="true" size={18} />}
            value={form.name}
            onChange={(event) => setForm({ ...form, name: event.target.value })}
            required
            fullWidth
          />

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
            autoComplete="new-password"
            helperText="Use at least 8 characters."
            label="Password"
            leftIcon={<ShieldCheck aria-hidden="true" size={18} />}
            minLength={8}
            type="password"
            value={form.password}
            onChange={(event) => setForm({ ...form, password: event.target.value })}
            required
            fullWidth
          />

          {error ? <Alert variant="error">{error}</Alert> : null}

          <Button disabled={isSubmitting} fullWidth isLoading={isSubmitting} type="submit">
            <UserPlus aria-hidden="true" />
            Create account
          </Button>
        </form>

        <p className="auth-switch">
          Already have access? <Link to="/login">Sign in</Link>
        </p>
      </Card>
    </main>
  );
}
