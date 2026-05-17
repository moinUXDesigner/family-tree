import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { LoadingCard } from '../app/components/LoadingCard.jsx';
import { useAuth } from './useAuth.js';

export function RequireAuth() {
  const { isAuthenticated, isCheckingSession } = useAuth();
  const location = useLocation();

  if (isCheckingSession) {
    return (
      <LoadingCard
        messages={['Checking your secure session...']}
        variant="relationships"
      />
    );
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  return <Outlet />;
}
