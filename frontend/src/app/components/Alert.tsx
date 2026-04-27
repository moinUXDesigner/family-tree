import { ReactNode, HTMLAttributes } from 'react';
import MuiAlert from '@mui/material/Alert';
import AlertTitle from '@mui/material/AlertTitle';

export interface AlertProps extends HTMLAttributes<HTMLDivElement> {
  variant?: 'success' | 'warning' | 'error' | 'info';
  title?: string;
  icon?: ReactNode;
  onClose?: () => void;
}

export const Alert = ({
  variant = 'info',
  title,
  icon,
  onClose,
  children,
  className = '',
  ...props
}: AlertProps) => (
  <MuiAlert
    className={className}
    icon={icon}
    onClose={onClose}
    severity={variant}
    variant="standard"
    {...props}
  >
    {title ? <AlertTitle>{title}</AlertTitle> : null}
    {children}
  </MuiAlert>
);
