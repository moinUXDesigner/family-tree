# Family Tree App

Full-stack family network platform.

## Structure

```text
frontend/   React + Vite frontend deployed to Hostinger `public_html/familytree`
backend/    Laravel API deployed to Hostinger `public_html/api-familytree`
docker/     Local PHP configuration for Docker development
```

## Local URLs

```text
Frontend: http://localhost:5173
Backend:  http://localhost:8000
MariaDB:  localhost:3306
phpMyAdmin: http://localhost:8080
```

## Production URLs

```text
Frontend: https://familytree.khajamynuddin.com
API:      https://api-familytree.khajamynuddin.com/api/v1
```

## Deployment

Deployment is handled by GitHub Actions over SSH. See `docs/deployment.md`.

## Phase 1 Status

- Frontend foundation is scaffolded.
- Local Docker services are defined for Laravel PHP 8.4 + MariaDB.
- phpMyAdmin is available locally for browsing the database.
- Hostinger shared-hosting paths are documented.
- Laravel app creation is the next backend setup step.

## Local Demo Users

After running backend seeders, use these accounts:

```text
superadmin@familytree.test / password123
admin@familytree.test      / password123
user@familytree.test       / password123
```
