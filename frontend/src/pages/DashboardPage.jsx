import { LogOut, ShieldCheck, TreePine, UsersRound } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_LABELS, ROLES } from '../config/roles.js';
import { Badge, Button, Card, StatCard } from '../app/components';

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
            <Badge variant="primary">{ROLE_LABELS[user.role]}</Badge>
            <h1>{config.title}</h1>
            <p>{config.subtitle}</p>
          </div>
          <Button onClick={logout} type="button" variant="outline">
            <LogOut aria-hidden="true" />
            Logout
          </Button>
        </header>

        <Card className="identity-strip" padding="md" variant="bordered">
          <ShieldCheck aria-hidden="true" />
          <div>
            <span>Signed in as</span>
            <strong>{user.name}</strong>
            <small>{user.email}</small>
          </div>
        </Card>

        <section className="metric-grid" aria-label="Role access summary">
          {config.stats.map(([label, value], index) => (
            <StatCard
              color={['primary', 'secondary', 'teal'][index] ?? 'primary'}
              key={label}
              title={label}
              value={value}
            />
          ))}
        </section>

        <Card className="next-work" padding="lg" variant="elevated">
          <UsersRound aria-hidden="true" />
          <div>
            <h2>Next module</h2>
            <p>
              Family and member management will plug into this authenticated shell next.
            </p>
          </div>
        </Card>
      </section>
    </main>
  );
}
