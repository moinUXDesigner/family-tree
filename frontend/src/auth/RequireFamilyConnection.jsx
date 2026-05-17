import { useEffect, useState } from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { LoadingCard } from '../app/components/LoadingCard.jsx';
import { familyConnectionApi } from '../services/familyConnectionApi.js';
import { useAuth } from './useAuth.js';

export function RequireFamilyConnection() {
  const { token } = useAuth();
  const [status, setStatus] = useState(null);

  useEffect(() => {
    let isMounted = true;

    familyConnectionApi
      .status(token)
      .then((status) => {
        if (isMounted) {
          setStatus(status);
        }
      })
      .catch(() => {
        if (isMounted) {
          setStatus({ is_connected: false, approval_status: 'pending' });
        }
      });

    return () => {
      isMounted = false;
    };
  }, [token]);

  if (status === null) {
    return (
      <LoadingCard
        messages={[
          'Verifying your approved family connection...',
        ]}
        variant="tree_in"
      />
    );
  }

  if (!status.is_connected || status.approval_status !== 'approved') {
    return <Navigate to="/app/connect" replace />;
  }

  return <Outlet />;
}
