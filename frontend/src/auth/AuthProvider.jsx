import { createContext, useCallback, useEffect, useMemo, useState } from 'react';
import { apiClient } from '../services/apiClient.js';

const TOKEN_KEY = 'family_tree_token';
const USER_KEY = 'family_tree_user';

export const AuthContext = createContext(null);

function readStoredUser() {
  const stored = localStorage.getItem(USER_KEY);

  if (!stored) {
    return null;
  }

  try {
    return JSON.parse(stored);
  } catch {
    localStorage.removeItem(USER_KEY);
    return null;
  }
}

export function AuthProvider({ children }) {
  const [token, setToken] = useState(() => localStorage.getItem(TOKEN_KEY));
  const [user, setUser] = useState(readStoredUser);
  const [isCheckingSession, setIsCheckingSession] = useState(Boolean(token));
  const [authTransition, setAuthTransition] = useState({
    active: false,
    message: '',
    messages: [],
    variant: 'tree_in',
    mode: 'card',
  });
  const [routeTransition, setRouteTransition] = useState({
    active: false,
    message: 'Connecting family relationships...',
    variant: 'relationships',
    mode: 'bare',
  });

  const persistSession = useCallback((nextUser, nextToken) => {
    localStorage.setItem(TOKEN_KEY, nextToken);
    localStorage.setItem(USER_KEY, JSON.stringify(nextUser));
    setToken(nextToken);
    setUser(nextUser);
  }, []);

  const clearSession = useCallback(() => {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(USER_KEY);
    setToken(null);
    setUser(null);
  }, []);

  useEffect(() => {
    if (!token) {
      setIsCheckingSession(false);
      return;
    }

    let isMounted = true;

    apiClient
      .get('/me', token)
      .then((response) => {
        if (!isMounted) {
          return;
        }

        const nextUser = response.data.user;
        localStorage.setItem(USER_KEY, JSON.stringify(nextUser));
        setUser(nextUser);
      })
      .catch(() => {
        if (isMounted) {
          clearSession();
        }
      })
      .finally(() => {
        if (isMounted) {
          setIsCheckingSession(false);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [clearSession, token]);

  const login = useCallback(
    async (credentials) => {
      setAuthTransition({
        active: true,
        message: 'Checking family connection...',
        messages: [
          '1) Checking family Connection',
          '2) Building your family relationship',
          '3) Connecting family relationships',
        ],
        variant: 'login_tree',
        mode: 'bare',
      });

      try {
        const response = await apiClient.post('/login', credentials);
        persistSession(response.data.user, response.data.token);
        setTimeout(() => {
          setAuthTransition((current) => (current.active ? { ...current, active: false } : current));
        }, 500);
        return response.data.user;
      } catch (error) {
        setAuthTransition((current) => ({ ...current, active: false }));
        throw error;
      }
    },
    [persistSession],
  );

  const register = useCallback(
    async (payload) => {
      const response = await apiClient.post('/register', payload);
      persistSession(response.data.user, response.data.token);
      return response.data.user;
    },
    [persistSession],
  );

  const logout = useCallback(async () => {
    setAuthTransition({
      active: true,
      message: 'Signing you out safely...',
      messages: [],
      variant: 'tree_out',
      mode: 'bare',
    });

    if (token) {
      await apiClient.post('/logout', {}, token).catch(() => null);
    }

    clearSession();
    setTimeout(() => {
      setAuthTransition((current) => (current.active ? { ...current, active: false } : current));
    }, 500);
  }, [clearSession, token]);

  const startRouteTransition = useCallback((next = {}) => {
    setRouteTransition((current) => ({
      ...current,
      ...next,
      active: true,
    }));
  }, []);

  const stopRouteTransition = useCallback(() => {
    setRouteTransition((current) => ({ ...current, active: false }));
  }, []);

  const updateProfile = useCallback(
    async (payload) => {
      if (!token) {
        throw new Error('Not authenticated.');
      }

      const response = await apiClient.put('/me', payload, token);
      const nextUser = response.data.user;
      localStorage.setItem(USER_KEY, JSON.stringify(nextUser));
      setUser(nextUser);
      return nextUser;
    },
    [token],
  );

  const value = useMemo(
    () => ({
      isAuthenticated: Boolean(token && user),
      authTransition,
      routeTransition,
      isCheckingSession,
      login,
      logout,
      register,
      updateProfile,
      clearSession,
      startRouteTransition,
      stopRouteTransition,
      token,
      user,
    }),
    [authTransition, clearSession, isCheckingSession, login, logout, register, routeTransition, startRouteTransition, stopRouteTransition, token, updateProfile, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
