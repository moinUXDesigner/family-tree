# Deployment

GitHub Actions deploys the frontend and backend to Hostinger over SSH.

## Required Secrets

```text
HOSTINGER_SSH_HOST
HOSTINGER_SSH_USER
HOSTINGER_SSH_PORT
HOSTINGER_SSH_PRIVATE_KEY
HOSTINGER_FRONTEND_PATH
HOSTINGER_BACKEND_PATH
VITE_API_BASE_URL
PROD_APP_KEY
PROD_APP_URL
PROD_FRONTEND_URL
PROD_DB_HOST
PROD_DB_DATABASE
PROD_DB_USERNAME
PROD_DB_PASSWORD
```

## Current Hostinger Paths

```text
HOSTINGER_FRONTEND_PATH=/home/u484303972/domains/khajamynuddin.com/public_html/familytree
HOSTINGER_BACKEND_PATH=/home/u484303972/domains/khajamynuddin.com/public_html/api-familytree
```

The API subdomain document root must point to:

```text
/home/u484303972/domains/khajamynuddin.com/public_html/api-familytree/public
```

If Hostinger is temporarily pointing the API subdomain to `api-familytree` instead of `api-familytree/public`, the root `backend/.htaccess` rewrites requests into `public/` as a fallback. The preferred production setup is still to set the subdomain document root directly to `public`.

The API subdomain and SSH runtime must use PHP 8.4. On Hostinger shared hosting the PHP 8.4 CLI binary is expected at:

```text
/opt/alt/php84/usr/bin/php
```

## Production URLs

```text
PROD_APP_URL=https://api-familytree.khajamynuddin.com
PROD_FRONTEND_URL=https://familytree.khajamynuddin.com
VITE_API_BASE_URL=https://api-familytree.khajamynuddin.com/api/v1
```

## Workflows

```text
.github/workflows/deploy-frontend.yml
.github/workflows/deploy-backend.yml
```

Both workflows run automatically on `main` when their matching files change and can also be started manually from GitHub Actions.
