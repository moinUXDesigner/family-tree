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
      const response = await apiClient.post('/login', credentials);
      persistSession(response.data.user, response.data.token);
      return response.data.user;
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
    if (token) {
      await apiClient.post('/logout', {}, token).catch(() => null);
    }

    clearSession();
  }, [clearSession, token]);

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
      isCheckingSession,
      login,
      logout,
      register,
      updateProfile,
      clearSession,
      token,
      user,
    }),
    [clearSession, isCheckingSession, login, logout, register, token, updateProfile, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
