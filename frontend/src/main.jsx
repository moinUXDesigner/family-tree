import React from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import { CssBaseline, ThemeProvider } from '@mui/material';
import { App } from './App.jsx';
import { AuthProvider } from './auth/AuthProvider.jsx';
import { registerServiceWorker } from './pwa/registerServiceWorker.js';
import { muiTheme } from './styles/muiTheme.js';
import './styles/index.css';
import './styles.css';

registerServiceWorker();

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <ThemeProvider theme={muiTheme}>
      <CssBaseline />
      <BrowserRouter>
        <AuthProvider>
          <App />
        </AuthProvider>
      </BrowserRouter>
    </ThemeProvider>
  </React.StrictMode>,
);
