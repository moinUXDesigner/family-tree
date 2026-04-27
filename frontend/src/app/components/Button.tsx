import { ButtonHTMLAttributes, forwardRef } from 'react';
import MuiButton from '@mui/material/Button';

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  fullWidth?: boolean;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      variant = 'primary',
      size = 'md',
      isLoading = false,
      fullWidth = false,
      className = '',
      children,
      disabled,
      ...props
    },
    ref,
  ) => {
    const muiVariant = {
      primary: 'contained',
      secondary: 'contained',
      outline: 'outlined',
      ghost: 'text',
      danger: 'contained',
    }[variant] as 'contained' | 'outlined' | 'text';

    const color = {
      primary: 'primary',
      secondary: 'secondary',
      outline: 'primary',
      ghost: 'inherit',
      danger: 'error',
    }[variant] as 'primary' | 'secondary' | 'inherit' | 'error';

    const muiSize = {
      sm: 'small',
      md: 'medium',
      lg: 'large',
    }[size] as 'small' | 'medium' | 'large';

    return (
      <MuiButton
        ref={ref}
        className={className}
        color={color}
        disabled={disabled || isLoading}
        fullWidth={fullWidth}
        size={muiSize}
        variant={muiVariant}
        {...props}
      >
        {isLoading ? 'Loading...' : children}
      </MuiButton>
    );
  },
);

Button.displayName = 'Button';
