# Family Tree API

Laravel API for the Family Tree platform.

## Local Development

The local API is designed to run through the root `docker-compose.yml`.

```powershell
docker compose up -d mariadb
docker compose run --rm backend composer install
docker compose run --rm backend php artisan key:generate
docker compose run --rm backend php artisan migrate
docker compose up backend
```

Local API URL:

```text
http://localhost:8000/api/v1
```

## Auth Endpoints

```text
GET  /api/v1/health
POST /api/v1/register
POST /api/v1/login
GET  /api/v1/me
POST /api/v1/logout
```

Protected role probes:

```text
GET /api/v1/super-admin/ping
GET /api/v1/admin/ping
GET /api/v1/user/ping
```

## Roles

```text
super_admin
admin
user
```

## Hostinger Production

Hostinger shared-hosting target:

```text
/home/u484303972/domains/khajamynuddin.com/public_html/api-familytree
```

The API subdomain document root should point to:

```text
public_html/api-familytree/public
```

Set the API subdomain PHP version to PHP 8.4 or newer.
