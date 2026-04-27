import { HTMLAttributes, forwardRef } from 'react';
import MuiCard from '@mui/material/Card';

export interface CardProps extends HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'bordered' | 'elevated';
  padding?: 'none' | 'sm' | 'md' | 'lg';
}

export const Card = forwardRef<HTMLDivElement, CardProps>(
  ({ variant = 'default', padding = 'md', className = '', children, ...props }, ref) => {
    const paddingMap = {
      none: 0,
      sm: 1.5,
      md: 2,
      lg: 3,
    };

    return (
      <MuiCard
        ref={ref}
        className={className}
        elevation={variant === 'elevated' ? 2 : 0}
        sx={{
          border: variant === 'elevated' ? 'none' : '1px solid',
          borderColor: 'divider',
          p: paddingMap[padding],
        }}
        {...props}
      >
        {children}
      </MuiCard>
    );
  },
);

Card.displayName = 'Card';
