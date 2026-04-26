import { LogOut, ShieldCheck, TreePine, UsersRound } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_LABELS, ROLES } from '../config/roles.js';

const dashboardConfig = {
  [ROLES.SUPER_ADMIN]: {
    title: 'Platform Command Center',
    subtitle: 'Manage families, admins, users, and platform-wide controls.',
    stats: [
      ['Scope', 'All families'],
      ['Primary task', 'Assign admins'],
      ['Access level', 'Platform'],
    ],
  },
  [ROLES.ADMIN]: {
    title: 'Family Admin Dashboard',
    subtitle: 'Manage your family members, relationships, invitations, and tree data.',
    stats: [
      ['Scope', 'Own family'],
      ['Primary task', 'Member management'],
      ['Access level', 'Family'],
    ],
  },
  [ROLES.USER]: {
    title: 'Family Member Dashboard',
    subtitle: 'View your profile, family tree, events, and allowed family information.',
    stats: [
      ['Scope', 'Allowed family data'],
      ['Primary task', 'Explore family'],
      ['Access level', 'Member'],
    ],
  },
};

export function DashboardPage({ role }) {
  const { logout, user } = useAuth();
  const config = dashboardConfig[role] ?? dashboardConfig[ROLES.USER];

  return (
    <main className="dashboard-page">
      <aside className="sidebar">
        <div className="sidebar-brand">
          <TreePine aria-hidden="true" />
          <span>Family Tree</span>
        </div>
        <nav aria-label="Dashboard navigation">
          <a className="nav-item active" href="#overview">
            Overview
          </a>
          <a className="nav-item" href="#members">
            Members
          </a>
          <a className="nav-item" href="#tree">
            Family Tree
          </a>
        </nav>
      </aside>

      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{ROLE_LABELS[user.role]}</p>
            <h1>{config.title}</h1>
            <p>{config.subtitle}</p>
          </div>
          <button className="secondary-action" onClick={logout} type="button">
            <LogOut aria-hidden="true" />
            Logout
          </button>
        </header>

        <section className="identity-strip">
          <ShieldCheck aria-hidden="true" />
          <div>
            <span>Signed in as</span>
            <strong>{user.name}</strong>
            <small>{user.email}</small>
          </div>
        </section>

        <section className="metric-grid" aria-label="Role access summary">
          {config.stats.map(([label, value]) => (
            <article className="metric-card" key={label}>
              <span>{label}</span>
              <strong>{value}</strong>
            </article>
          ))}
        </section>

        <section className="next-work">
          <UsersRound aria-hidden="true" />
          <div>
            <h2>Next module</h2>
            <p>
              Family and member management will plug into this authenticated shell next.
            </p>
          </div>
        </section>
      </section>
    </main>
  );
}
