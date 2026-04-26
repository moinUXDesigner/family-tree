import { Navigate, Outlet } from 'react-router-dom';
import { ROLE_HOME, ROLES } from '../config/roles.js';
import { useAuth } from './useAuth.js';

export function RequireRole({ roles }) {
  const { user } = useAuth();

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (!roles.includes(user.role)) {
    return <Navigate to={ROLE_HOME[user.role] ?? ROLE_HOME[ROLES.USER]} replace />;
  }

  return <Outlet />;
}
