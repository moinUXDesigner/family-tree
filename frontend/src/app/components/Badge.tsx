import { HTMLAttributes, forwardRef } from 'react';
import Chip from '@mui/material/Chip';

export interface BadgeProps extends HTMLAttributes<HTMLSpanElement> {
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'error' | 'info' | 'neutral';
  size?: 'sm' | 'md';
}

export const Badge = forwardRef<HTMLSpanElement, BadgeProps>(
  ({ variant = 'primary', size = 'md', className = '', children, ...props }, ref) => {
    const color = {
      primary: 'primary',
      secondary: 'secondary',
      success: 'success',
      warning: 'warning',
      error: 'error',
      info: 'info',
      neutral: 'default',
    }[variant] as 'primary' | 'secondary' | 'success' | 'warning' | 'error' | 'info' | 'default';

    return (
      <Chip
        ref={ref}
        className={className}
        color={color}
        label={children}
        size={size === 'sm' ? 'small' : 'small'}
        variant={variant === 'neutral' ? 'outlined' : 'filled'}
        {...props}
      />
    );
  },
);

Badge.displayName = 'Badge';
