# Environment Guide

## Local Development

```text
React Vite: http://localhost:5173
Laravel API: http://localhost:8000
MariaDB:     localhost:3306
```

Frontend local env:

```env
VITE_APP_NAME="Family Tree"
VITE_APP_ENV=local
VITE_API_BASE_URL=http://localhost:8000/api/v1
```

Backend local env:

```env
APP_URL=http://localhost:8000
FRONTEND_URL=http://localhost:5173
SANCTUM_STATEFUL_DOMAINS=localhost:5173,127.0.0.1:5173
DB_HOST=mariadb
DB_DATABASE=family_tree
DB_USERNAME=family_user
DB_PASSWORD=family_password
```

## Hostinger Production

```text
Frontend folder: public_html/familytree
Backend folder:  public_html/api-familytree
Backend public:  public_html/api-familytree/public
```

Production frontend env:

```env
VITE_APP_NAME="Family Tree"
VITE_APP_ENV=production
VITE_API_BASE_URL=https://api-familytree.khajamynuddin.com/api/v1
```

Production backend env:

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api-familytree.khajamynuddin.com
FRONTEND_URL=https://familytree.khajamynuddin.com
SANCTUM_STATEFUL_DOMAINS=familytree.khajamynuddin.com
SESSION_DOMAIN=.khajamynuddin.com
```

