import { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  AccountTree,
  ArrowBack,
  Close,
  Dashboard,
  FamilyRestroom,
  FeedbackOutlined,
  Group,
  Logout as LogoutIcon,
  ManageAccounts,
  Menu,
  PeopleAlt,
  RateReview,
  RecentActors,
  VerifiedUser,
} from '@mui/icons-material';
import {
  Avatar,
  BottomNavigation,
  BottomNavigationAction,
  IconButton,
  Paper,
  Tooltip,
  Typography,
} from '@mui/material';
import { useAuth } from '../auth/useAuth.js';
import { ROLES, ROLE_HOME } from '../config/roles.js';

const navItems = [
  {
    key: 'overview',
    label: 'Overview',
    icon: <Dashboard />,
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/dashboard',
      [ROLES.ADMIN]: '/admin/dashboard',
      [ROLES.USER]: '/app/dashboard',
    },
  },
  {
    key: 'members',
    label: 'Members',
    icon: <PeopleAlt />,
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/members',
      [ROLES.ADMIN]: '/admin/members',
      [ROLES.USER]: '/app/members',
    },
  },
  {
    key: 'relationships',
    label: 'Links',
    icon: <Group />,
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/relationships',
      [ROLES.ADMIN]: '/admin/relationships',
      [ROLES.USER]: '/app/relationships',
    },
  },
  {
    key: 'tree',
    label: 'Tree',
    icon: <AccountTree />,
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/tree',
      [ROLES.ADMIN]: '/admin/tree',
      [ROLES.USER]: '/app/tree',
    },
  },
  {
    key: 'families',
    label: 'Families',
    icon: <RecentActors />,
    roles: [ROLES.SUPER_ADMIN],
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/families',
    },
  },
  {
    key: 'approvals',
    label: 'Approvals',
    icon: <VerifiedUser />,
    roles: [ROLES.SUPER_ADMIN],
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/approvals',
    },
  },
  {
    key: 'users',
    label: 'Users',
    icon: <ManageAccounts />,
    roles: [ROLES.SUPER_ADMIN],
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/users',
    },
  },
  {
    key: 'root-family',
    label: 'Nanne Tree',
    icon: <FamilyRestroom />,
    roles: [ROLES.SUPER_ADMIN],
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/root-family',
    },
  },
];

const feedbackRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/feedback',
  [ROLES.ADMIN]: '/admin/feedback',
  [ROLES.USER]: '/app/feedback',
};

const feedbackInboxRoutes = {
  [ROLES.SUPER_ADMIN]: '/super-admin/feedbacks',
  [ROLES.ADMIN]: '/admin/feedbacks',
};

export function NavigationChrome({ active, mobileBackTo = '', role }) {
  const { logout, user } = useAuth();
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);
  const visibleNavItems = navItems.filter((item) => !item.roles || item.roles.includes(role));

  function closeMobileSidebar() {
    setIsMobileSidebarOpen(false);
  }

  return (
    <>
      <Paper className="mobile-app-bar" component="header" elevation={3} square>
        {mobileBackTo ? (
          <IconButton
            aria-label="Go back"
            className="mobile-app-menu"
            component={Link}
            size="large"
            to={mobileBackTo}
          >
            <ArrowBack />
          </IconButton>
        ) : (
          <IconButton
            aria-label="Open navigation menu"
            className="mobile-app-menu"
            onClick={() => setIsMobileSidebarOpen(true)}
            size="large"
          >
            <Menu />
          </IconButton>
        )}
        <div className="mobile-app-title">
          <AccountTree aria-hidden="true" />
          <strong>Family Tree</strong>
        </div>
        <Avatar className="mobile-app-avatar" src={user?.avatar_url ?? undefined}>
          {initials(user?.name ?? user?.email ?? 'User')}
        </Avatar>
      </Paper>

      <button
        aria-label="Close navigation menu"
        className={isMobileSidebarOpen ? 'sidebar-backdrop visible' : 'sidebar-backdrop'}
        onClick={closeMobileSidebar}
        type="button"
      />

      <Paper
        className={[
          'sidebar',
          isCollapsed ? 'collapsed' : '',
          isMobileSidebarOpen ? 'mobile-open' : '',
        ].filter(Boolean).join(' ')}
        component="aside"
        elevation={0}
        square
      >
        <div className="sidebar-brand">
          <AccountTree aria-hidden="true" />
          <Typography component="span" variant="subtitle1">
            Family Tree
          </Typography>
          <Tooltip title={isCollapsed ? 'Expand navigation' : 'Collapse navigation'}>
            <IconButton
              aria-label={isCollapsed ? 'Expand navigation' : 'Collapse navigation'}
              className="sidebar-toggle"
              onClick={() => setIsCollapsed((current) => !current)}
              size="small"
            >
              <Menu fontSize="small" />
            </IconButton>
          </Tooltip>
          <IconButton
            aria-label="Close navigation menu"
            className="sidebar-mobile-close"
            onClick={closeMobileSidebar}
            size="small"
          >
            <Close fontSize="small" />
          </IconButton>
        </div>

        <nav aria-label="Dashboard navigation">
          {visibleNavItems.map((item) => (
            <Tooltip disableHoverListener={!isCollapsed} key={item.key} placement="right" title={item.label}>
              <Link
                className={active === item.key ? 'nav-item active' : 'nav-item'}
                onClick={closeMobileSidebar}
                to={item.route[role] ?? ROLE_HOME[ROLES.USER]}
              >
                {item.icon}
                <span>{item.label}</span>
              </Link>
            </Tooltip>
          ))}
        </nav>

        <div className="sidebar-footer">
          {feedbackInboxRoutes[role] ? (
            <Link className="nav-feedback-button" onClick={closeMobileSidebar} to={feedbackInboxRoutes[role]}>
              <RateReview aria-hidden="true" />
              <span>User Feedbacks</span>
            </Link>
          ) : null}
          <Link className="nav-feedback-button" onClick={closeMobileSidebar} to={feedbackRoutes[role]}>
            <FeedbackOutlined aria-hidden="true" />
            <span>Send Feedback</span>
          </Link>
          <button className="nav-logout-button" onClick={logout} type="button">
            <LogoutIcon aria-hidden="true" />
            <span>Logout</span>
          </button>
        </div>
      </Paper>

      <Paper className="bottom-nav-shell" elevation={8}>
        <BottomNavigation showLabels value={active}>
          {visibleNavItems.map((item) => (
            <BottomNavigationAction
              component={Link}
              icon={item.icon}
              key={item.key}
              label={item.label}
              to={item.route[role] ?? ROLE_HOME[ROLES.USER]}
              value={item.key}
            />
          ))}
        </BottomNavigation>
      </Paper>
    </>
  );
}

function initials(name) {
  return name
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');
}
