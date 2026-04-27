import { useEffect, useState } from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { familyConnectionApi } from '../services/familyConnectionApi.js';
import { useAuth } from './useAuth.js';

export function RequireFamilyConnection() {
  const { token } = useAuth();
  const [isConnected, setIsConnected] = useState(null);

  useEffect(() => {
    let isMounted = true;

    familyConnectionApi
      .status(token)
      .then((status) => {
        if (isMounted) {
          setIsConnected(status.is_connected);
        }
      })
      .catch(() => {
        if (isMounted) {
          setIsConnected(false);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [token]);

  if (isConnected === null) {
    return <div className="screen-loader">Checking family connection...</div>;
  }

  if (!isConnected) {
    return <Navigate to="/app/connect" replace />;
  }

  return <Outlet />;
}
