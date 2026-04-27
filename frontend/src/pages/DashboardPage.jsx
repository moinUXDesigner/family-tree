import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Heart, LogOut, ShieldCheck, UsersRound } from 'lucide-react';
import { useAuth } from '../auth/useAuth.js';
import { ROLE_HOME, ROLE_LABELS, ROLES } from '../config/roles.js';
import { NavigationChrome } from '../app/NavigationChrome.jsx';
import { Badge, Button, Card, StatCard } from '../app/components';
import { familyConnectionApi } from '../services/familyConnectionApi.js';

const memberRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/members',
  [ROLES.ADMIN]: '/admin/members',
  [ROLES.USER]: '/app/members',
};

const relationshipRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/relationships',
  [ROLES.ADMIN]: '/admin/relationships',
  [ROLES.USER]: '/app/relationships',
};

const treeRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/tree',
  [ROLES.ADMIN]: '/admin/tree',
  [ROLES.USER]: '/app/tree',
};

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
  const { logout, token, user } = useAuth();
  const config = dashboardConfig[role] ?? dashboardConfig[ROLES.USER];
  const [rootCouple, setRootCouple] = useState(null);

  useEffect(() => {
    let isMounted = true;

    if (role !== ROLES.USER) {
      return () => {
        isMounted = false;
      };
    }

    familyConnectionApi
      .status(token)
      .then((status) => {
        if (isMounted) {
          setRootCouple(status.root_couple);
        }
      })
      .catch(() => {
        if (isMounted) {
          setRootCouple(null);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [role, token]);

  return (
    <main className="dashboard-page">
      <NavigationChrome active="overview" role={role} />

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

        {rootCouple ? (
          <Card className="root-couple-strip" padding="md" variant="bordered">
            <Heart aria-hidden="true" />
            <div>
              <span>Root family</span>
              <strong>{rootCouple.root_member?.display_name ?? 'Shaik Nanne Saheb'}</strong>
              <small>Wife: {rootCouple.wife?.display_name ?? 'Not added yet'}</small>
            </div>
          </Card>
        ) : null}

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
            <h2>Tree view</h2>
            <p>
              Use member and relationship records to view the first family tree graph.
            </p>
            <Link className="inline-action" to={treeRoutes[role]}>
              Open tree
            </Link>
          </div>
        </Card>
      </section>
    </main>
  );
}
