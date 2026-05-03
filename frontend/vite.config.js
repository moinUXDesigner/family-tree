import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import path from 'node:path';

export default defineConfig(() => {
  const env = process.env;
  const apiTarget = env.VITE_API_PROXY_TARGET ?? 'http://localhost:8000';

  return {
    plugins: [react(), tailwindcss()],
    resolve: {
      alias: {
        react: path.resolve(__dirname, 'node_modules/react'),
        'react-dom': path.resolve(__dirname, 'node_modules/react-dom'),
        '@emotion/react': path.resolve(__dirname, 'node_modules/@emotion/react'),
        '@emotion/styled': path.resolve(__dirname, 'node_modules/@emotion/styled'),
      },
      dedupe: ['react', 'react-dom', '@emotion/react', '@emotion/styled'],
    },
    optimizeDeps: {
      include: [
        'react',
        'react-dom',
        '@emotion/react',
        '@emotion/styled',
        '@mui/material',
        '@mui/icons-material',
      ],
    },
    server: {
      port: 5173,
      proxy: {
        '/api': {
          target: apiTarget,
          changeOrigin: true,
        },
      },
    },
  };
});
