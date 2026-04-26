import { ReactNode, HTMLAttributes } from 'react';

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
}: AlertProps) => {
  const variantStyles = {
    success: 'bg-success-light border-success text-success',
    warning: 'bg-warning-light border-warning text-warning',
    error: 'bg-error-light border-error text-error',
    info: 'bg-info-light border-info text-info',
  };

  const defaultIcons = {
    success: '✓',
    warning: '⚠',
    error: '✕',
    info: 'ℹ',
  };

  return (
    <div
      className={`flex gap-3 p-4 rounded-md border-l-4 ${variantStyles[variant]} ${className}`}
      {...props}
    >
      <div className="flex-shrink-0 text-xl">
        {icon || defaultIcons[variant]}
      </div>
      <div className="flex-1">
        {title && <h4 className="font-semibold mb-1">{title}</h4>}
        <div className="text-sm opacity-90">{children}</div>
      </div>
      {onClose && (
        <button
          onClick={onClose}
          className="flex-shrink-0 hover:opacity-70 transition-opacity"
        >
          ✕
        </button>
      )}
    </div>
  );
};
