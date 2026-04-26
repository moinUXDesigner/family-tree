# Family Tree API

Laravel API for the Family Tree platform.

## Local Setup

Composer is not installed on the Windows host yet, so create the Laravel app by either installing Composer locally or using the Docker PHP image after it is built.

Recommended once Composer is available:

```powershell
composer create-project laravel/laravel backend
cd backend
composer require laravel/sanctum
php artisan key:generate
php artisan migrate
```

For local Docker database values, use `backend/.env.example`.

## Production Hosting

Hostinger shared-hosting target:

```text
/home/u484303972/domains/khajamynuddin.com/public_html/api-familytree
```

The API subdomain document root should point to:

```text
public_html/api-familytree/public
```

Production URL:

```text
https://api-familytree.khajamynuddin.com/api/v1
```

