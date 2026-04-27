import { InputHTMLAttributes, forwardRef, ReactNode } from 'react';
import InputAdornment from '@mui/material/InputAdornment';
import TextField from '@mui/material/TextField';

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  helperText?: string;
  leftIcon?: ReactNode;
  rightIcon?: ReactNode;
  fullWidth?: boolean;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  (
    {
      label,
      error,
      helperText,
      leftIcon,
      rightIcon,
      fullWidth = false,
      className = '',
      ...props
    },
    ref,
  ) => (
    <TextField
      className={className}
      error={Boolean(error)}
      fullWidth={fullWidth}
      helperText={error || helperText}
      inputRef={ref}
      label={label}
      slotProps={{
        input: {
          startAdornment: leftIcon ? <InputAdornment position="start">{leftIcon}</InputAdornment> : undefined,
          endAdornment: rightIcon ? <InputAdornment position="end">{rightIcon}</InputAdornment> : undefined,
        },
      }}
      {...props}
    />
  ),
);

Input.displayName = 'Input';
