import { Navigate, Route, Routes } from 'react-router-dom';
import { LoginPage } from './pages/LoginPage.jsx';
import { RegisterPage } from './pages/RegisterPage.jsx';
import { DashboardPage } from './pages/DashboardPage.jsx';
import { FamilyConnectionPage } from './pages/FamilyConnectionPage.jsx';
import { MembersPage } from './pages/MembersPage.jsx';
import { RelationshipsPage } from './pages/RelationshipsPage.jsx';
import { TreePage } from './pages/TreePage.jsx';
import { RequireAuth } from './auth/RequireAuth.jsx';
import { RequireFamilyConnection } from './auth/RequireFamilyConnection.jsx';
import { RequireRole } from './auth/RequireRole.jsx';
import { ROLE_HOME, ROLES } from './config/roles.js';
import { useAuth } from './auth/useAuth.js';

function HomeRedirect() {
  const { user } = useAuth();

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return (
    <Navigate
      to={user.role === ROLES.USER ? '/app/connect' : ROLE_HOME[user.role] ?? ROLE_HOME[ROLES.USER]}
      replace
    />
  );
}

export function App() {
  return (
    <Routes>
      <Route path="/" element={<HomeRedirect />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      <Route element={<RequireAuth />}>
        <Route element={<RequireRole roles={[ROLES.SUPER_ADMIN]} />}>
          <Route
            path="/super-admin/dashboard"
            element={<DashboardPage role={ROLES.SUPER_ADMIN} />}
          />
          <Route
            path="/super-admin/members"
            element={<MembersPage role={ROLES.SUPER_ADMIN} />}
          />
          <Route
            path="/super-admin/relationships"
            element={<RelationshipsPage role={ROLES.SUPER_ADMIN} />}
          />
          <Route path="/super-admin/tree" element={<TreePage role={ROLES.SUPER_ADMIN} />} />
        </Route>

        <Route element={<RequireRole roles={[ROLES.ADMIN]} />}>
          <Route path="/admin/dashboard" element={<DashboardPage role={ROLES.ADMIN} />} />
          <Route path="/admin/members" element={<MembersPage role={ROLES.ADMIN} />} />
          <Route path="/admin/relationships" element={<RelationshipsPage role={ROLES.ADMIN} />} />
          <Route path="/admin/tree" element={<TreePage role={ROLES.ADMIN} />} />
        </Route>

        <Route element={<RequireRole roles={[ROLES.USER]} />}>
          <Route path="/app/connect" element={<FamilyConnectionPage />} />
          <Route element={<RequireFamilyConnection />}>
            <Route path="/app/dashboard" element={<DashboardPage role={ROLES.USER} />} />
            <Route path="/app/members" element={<MembersPage role={ROLES.USER} />} />
            <Route path="/app/relationships" element={<RelationshipsPage role={ROLES.USER} />} />
            <Route path="/app/tree" element={<TreePage role={ROLES.USER} />} />
          </Route>
        </Route>
      </Route>

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
