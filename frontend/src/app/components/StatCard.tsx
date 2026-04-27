import { ReactNode } from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import { Card } from './Card';

export interface StatCardProps {
  title: string;
  value: string | number;
  icon?: ReactNode;
  trend?: {
    value: string;
    direction: 'up' | 'down';
  };
  color?: 'primary' | 'secondary' | 'success' | 'warning' | 'purple' | 'teal';
}

export const StatCard = ({ title, value, icon, trend }: StatCardProps) => (
  <Card variant="elevated" padding="md">
    <Box sx={{ alignItems: 'flex-start', display: 'flex', justifyContent: 'space-between' }}>
      <Box sx={{ flex: 1 }}>
        <Typography color="text.secondary" variant="body2">
          {title}
        </Typography>
        <Typography color="text.primary" variant="h5">
          {value}
        </Typography>
        {trend ? (
          <Typography color={trend.direction === 'up' ? 'success.main' : 'error.main'} variant="caption">
            {trend.direction === 'up' ? 'Up' : 'Down'} {trend.value}
          </Typography>
        ) : null}
      </Box>
      {icon ? <Box sx={{ color: 'primary.main', fontSize: 28 }}>{icon}</Box> : null}
    </Box>
  </Card>
);
