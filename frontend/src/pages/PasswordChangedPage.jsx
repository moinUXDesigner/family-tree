import { Link } from 'react-router-dom';
import { CheckCircle2, LogIn } from 'lucide-react';
import { Button, Card } from '../app/components';

export function PasswordChangedPage() {
  return (
    <main className="password-success-page">
      <Card className="password-success-card" padding="lg" variant="elevated">
        <div className="password-success-icon" aria-hidden="true">
          <CheckCircle2 size={44} />
        </div>
        <p className="eyebrow">Security Updated</p>
        <h1>Password changed successfully</h1>
        <p>Your password has been updated. Please sign in with your new password.</p>
        <Button component={Link} to="/login" type="button" variant="primary">
          <LogIn aria-hidden="true" />
          Go To Login
        </Button>
      </Card>
    </main>
  );
}
