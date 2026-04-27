import { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  AccountTree,
  Dashboard,
  Group,
  Menu,
  PeopleAlt,
} from '@mui/icons-material';
import {
  BottomNavigation,
  BottomNavigationAction,
  IconButton,
  Paper,
  Tooltip,
  Typography,
} from '@mui/material';
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
];

export function NavigationChrome({ active, role }) {
  const [isCollapsed, setIsCollapsed] = useState(false);

  return (
    <>
      <Paper
        className={isCollapsed ? 'sidebar collapsed' : 'sidebar'}
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
        </div>

        <nav aria-label="Dashboard navigation">
          {navItems.map((item) => (
            <Tooltip disableHoverListener={!isCollapsed} key={item.key} placement="right" title={item.label}>
              <Link
                className={active === item.key ? 'nav-item active' : 'nav-item'}
                to={item.route[role] ?? ROLE_HOME[ROLES.USER]}
              >
                {item.icon}
                <span>{item.label}</span>
              </Link>
            </Tooltip>
          ))}
        </nav>
      </Paper>

      <Paper className="bottom-nav-shell" elevation={8}>
        <BottomNavigation showLabels value={active}>
          {navItems.map((item) => (
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
