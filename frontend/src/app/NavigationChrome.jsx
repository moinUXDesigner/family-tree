import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Network } from 'lucide-react';
import { motion } from 'framer-motion';
import {
  ArrowBack,
  Close,
  FamilyRestroom,
  FeedbackOutlined,
  AddCircle,
  Logout as LogoutIcon,
  ManageAccounts,
  Menu,
  Person,
  PeopleAlt,
  RateReview,
  RecentActors,
  History,
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
  useMediaQuery,
} from '@mui/material';
import { useAuth } from '../auth/useAuth.js';
import { ROLES, ROLE_HOME, ROLE_LABELS } from '../config/roles.js';

const navItems = [
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
    key: 'tree',
    label: 'Tree',
    icon: <Network size={20} />,
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
    key: 'activity',
    label: 'Activity',
    icon: <History />,
    roles: [ROLES.SUPER_ADMIN, ROLES.ADMIN],
    route: {
      [ROLES.SUPER_ADMIN]: '/super-admin/activity',
      [ROLES.ADMIN]: '/admin/activity',
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

const bottomNavHiddenKeys = new Set(['members', 'families', 'root-family', 'users', 'approvals']);

export function NavigationChrome({ active, mobileBackTo = '', role }) {
  const { logout, user } = useAuth();
  const navigate = useNavigate();
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);
  const isMobileViewport = useMediaQuery('(max-width:820px)');
  const visibleNavItems = navItems.filter((item) => !item.roles || item.roles.includes(role));
  const bottomNavItems = visibleNavItems.filter((item) => !bottomNavHiddenKeys.has(item.key));
  const quickAddRoute = `${visibleNavItems.find((item) => item.key === 'members')?.route[role] ?? '/app/members'}?quick_add=1`;

  function openQuickAdd(event) {
    event.preventDefault();
    const separator = quickAddRoute.includes('?') ? '&' : '?';
    navigate(`${quickAddRoute}${separator}open=${Date.now()}`);
  }

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
          <Network aria-hidden="true" />
        </div>
        <div className="mobile-app-profile">
          <span className="mobile-app-role">{ROLE_LABELS[user?.role] ?? 'User'}</span>
          <Avatar className="mobile-app-avatar" src={user?.avatar_url ?? undefined}>
            {initials(user?.name ?? user?.email ?? 'User')}
          </Avatar>
        </div>
      </Paper>

      <button
        aria-label="Close navigation menu"
        className={isMobileSidebarOpen ? 'sidebar-backdrop visible' : 'sidebar-backdrop'}
        onClick={closeMobileSidebar}
        type="button"
      />

      <Paper
        animate={
          isMobileViewport
            ? undefined
            : {
              width: isCollapsed ? 88 : 260,
              paddingLeft: isCollapsed ? 14 : 18,
              paddingRight: isCollapsed ? 14 : 18,
            }
        }
        className={[
          'sidebar',
          isCollapsed ? 'collapsed' : '',
          isMobileSidebarOpen ? 'mobile-open' : '',
        ].filter(Boolean).join(' ')}
        component={motion.aside}
        elevation={0}
        square
        transition={{ duration: 0.24, ease: [0.22, 1, 0.36, 1] }}
      >
        <div className="sidebar-brand">
          <Network aria-hidden="true" />
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
          <Link className={active === 'profile' ? 'nav-feedback-button active' : 'nav-feedback-button'} onClick={closeMobileSidebar} to="/profile">
            <Person aria-hidden="true" />
            <span>Profile</span>
          </Link>
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
        <BottomNavigation className="mobile-bottom-nav" showLabels value={active}>
          {bottomNavItems.map((item) => (
            <BottomNavigationAction
              component={Link}
              icon={item.icon}
              key={item.key}
              label={item.label}
              to={item.route[role] ?? ROLE_HOME[ROLES.USER]}
              value={item.key}
            />
          ))}
          <BottomNavigationAction
            className="quick-add-nav-action"
            component="button"
            icon={<AddCircle />}
            label="Add Member"
            onClick={openQuickAdd}
            value="quick-add"
          />
          <BottomNavigationAction
            component={Link}
            icon={<FeedbackOutlined />}
            label="Feedback"
            to={feedbackRoutes[role]}
            value="feedback"
          />
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
