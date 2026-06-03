# Laravel Base Devcontainer

A self-contained Laravel development environment with PostgreSQL, PHP 8.5,
Node.js, and a full set of AI-codable project skills.

## Quick Start

```bash
git clone <this-repo> my-project
cd my-project
code .
```

Reopen in Container — the `postCreateCommand` scaffolds a fresh Laravel 11
project inside `app/`, runs `npm install`, and generates an app key.

After the first build, initialize git and Husky:

```bash
git init
cd app && npx husky init && echo "npx lint-staged" > .husky/pre-commit
cd .. && git add -A && git commit -m "chore: initial scaffold"
```

This sets up pre-commit hooks that run Pint (PHP) and Prettier (JS/CSS/MD) on
staged files. The project is ready to go.

### A note on AI usage

The `.agents/` directory contains skills and agent definitions to **assist**
developers who choose to use AI tools — they provide context so the AI produces
better, more Laravel-idiomatic code.

AI is a tool, not a substitute for understanding. Relying on AI without reading,
understanding, and owning the code it produces is "vibe coding" — it creates a
**technology gap** where you can no longer debug, review, or confidently modify
what ships. Every AI-generated line should be reviewed and understood before it
reaches production. Use AI to move faster, not to check out.

## Project Structure

```text
├── .agents/           ← AI skills & agents (tool-agnostic)
│   ├── agents/
│   │   ├── architect.md
│   │   ├── reviewer.md
│   │   └── tinker.md
│   └── skills/
│       ├── api/
│       ├── artisan/
│       ├── blade/
│       ├── caching/
│       ├── commits/
│       ├── eloquent/
│       ├── error-handling/
│       ├── migrations/
│       ├── performance/
│       ├── postgresql/
│       ├── principles/
│       ├── routing/
│       ├── security/
│       ├── testing/
│       └── validation/
├── .devcontainer/     ← Dev environment configuration
│   ├── devcontainer.json
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── setup.sh
├── app/               ← Scaffolded Laravel project ( created on first build )
│   ├── artisan
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── ...
│   └── .env
└── .dockerignore
```

## Devcontainer

- **PHP 8.5** with PostgreSQL extensions (`pdo_pgsql`)
- **PostgreSQL 16** (separate service with health check, named volume for data persistence)
- **Node.js** (via devcontainer features, needed for Vite)
- **Xdebug** enabled
- Bind mount: your host files sync to `/workspace`
- Workspace opens at `/workspace/app`

### Services

| Service         | Port               | Credentials          |
|-----------------|--------------------|----------------------|
| `laravel-app`   | 8000 (Laravel)     | —                    |
| `laravel-app-db`| 5432 (PostgreSQL)  | `laravel` / `laravel`|

## AI Skills

15 skills covering Laravel and PostgreSQL development. Any AI tool that supports skill files can consume them:

| Skill             | What it covers                                         |
|-------------------|--------------------------------------------------------|
| **api**           | JSON responses, resources, pagination, status codes    |
| **artisan**       | Make commands, scheduling, tinker                      |
| **blade**         | Components, layouts, directives                        |
| **caching**       | Query caching, invalidation, response caching          |
| **commits**       | Conventional Commits format                            |
| **eloquent**      | Relationships, scopes, accessors, casts                |
| **error-handling**| Exception mapping, error JSON, logging                 |
| **migrations**    | Schema builder, foreign keys, indexes, seeders         |
| **performance**   | N+1 prevention, chunking, queueing                     |
| **postgresql**    | psql, full-text search, JSON columns, extensions       |
| **principles**    | SOLID, DRY, KISS with Laravel examples                 |
| **routing**       | Routes, controllers, middleware, model binding         |
| **security**      | Sanctum, policies, CORS, rate limiting                 |
| **testing**       | Pest/PHPUnit, factories, HTTP assertions               |
| **validation**    | Form requests, rules, custom validators                |

## AI Agents

Predefined agent personas in `.agents/agents/`:

- **architect** — Plans features end-to-end (DB → routes → controllers → tests)
- **reviewer** — PR reviews focused on Laravel-specific issues
- **tinker** — Ad-hoc debugging and prototyping

## Development

```bash
# Serve the app
php artisan serve --host=0.0.0.0

# Run migrations
php artisan migrate

# Run tests
php artisan test

# Queue worker (database driver)
php artisan queue:work

# Tinker
php artisan tinker
```

## Community

Contributions are welcome — whether it's a new skill, a fix to an existing one, or
an improvement to the devcontainer setup.

- **[Contributing](CONTRIBUTING.md)** — how to get started, commit conventions, and
  PR guidelines
- **[Code of Conduct](CODE_OF_CONDUCT.md)** — everyone participating in this
  project is expected to uphold a respectful and inclusive environment
- **[License](LICENSE)** — this project is open source under the MIT license

## Requirements

- Docker
- Visual Studio Code with the Dev Containers extension
