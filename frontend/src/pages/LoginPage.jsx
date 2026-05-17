import { useState } from 'react';
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom';
import { LogIn, Network } from 'lucide-react';
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

  function handleGoogleSignIn() {
    setError('Google Sign-In is coming soon. Please use email and password for now.');
  }

  return (
    <main className="auth-page" style={{ paddingLeft: '2rem', paddingRight: '2rem' }}>
      <Card className="auth-panel auth-panel-cardless" padding="lg" variant="elevated">
        <div className="brand-mark">
          <Network aria-hidden="true" />
        </div>
        <h1>Login</h1>

        <form className="auth-form" onSubmit={handleSubmit}>
          <label className="auth-field-label" htmlFor="login-email">Email</label>
          <Input
            autoComplete="email"
            id="login-email"
            type="email"
            value={form.email}
            onChange={(event) => setForm({ ...form, email: event.target.value })}
            required
            fullWidth
          />

          <div className="auth-password-row">
            <label className="auth-field-label" htmlFor="login-password">Password</label>
            <Link to="/forgot-password">Forgot password?</Link>
          </div>
          <Input
            autoComplete="current-password"
            id="login-password"
            type="password"
            value={form.password}
            onChange={(event) => setForm({ ...form, password: event.target.value })}
            required
            fullWidth
          />

          {error ? <Alert variant="error">{error}</Alert> : null}

          <Button disabled={isSubmitting} fullWidth isLoading={isSubmitting} type="submit">
            <LogIn aria-hidden="true" />
            Login
          </Button>

          <div className="auth-divider" aria-hidden="true">
            <span />
            <strong>or</strong>
            <span />
          </div>

          <Button fullWidth onClick={handleGoogleSignIn} type="button" variant="outline">
            <svg aria-hidden="true" className="google-svg-icon" viewBox="0 0 24 24">
              <path fill="#EA4335" d="M12 10.2v3.9h5.5c-.2 1.3-1.5 3.8-5.5 3.8-3.3 0-6-2.7-6-6s2.7-6 6-6c1.9 0 3.1.8 3.8 1.5l2.6-2.5C16.7 3.4 14.6 2.5 12 2.5 6.8 2.5 2.5 6.8 2.5 12s4.3 9.5 9.5 9.5c5.5 0 9.1-3.9 9.1-9.3 0-.6-.1-1.1-.2-1.6H12z" />
              <path fill="#34A853" d="M3.6 7.6l3.2 2.3C7.7 7.7 9.7 6 12 6c1.9 0 3.1.8 3.8 1.5l2.6-2.5C16.7 3.4 14.6 2.5 12 2.5 8.4 2.5 5.2 4.5 3.6 7.6z" />
              <path fill="#FBBC05" d="M12 21.5c2.6 0 4.7-.9 6.3-2.4l-3-2.4c-.8.6-1.9 1-3.3 1-2.5 0-4.7-1.7-5.5-4l-3.3 2.5c1.6 3.1 4.8 5.3 8.8 5.3z" />
              <path fill="#4285F4" d="M21.1 12.2c0-.6-.1-1.1-.2-1.6H12v3.9h5.5c-.3 1.4-1.1 2.5-2.2 3.2l3 2.4c1.8-1.6 2.8-4.1 2.8-7.9z" />
            </svg>
            Sign in with Google
          </Button>
        </form>

        <p className="auth-switch">
          Don&apos;t have an account? <Link to="/register">Sign up</Link>
        </p>
      </Card>
    </main>
  );
}
