---
name: artisan
description: Use when running or generating Artisan commands, make classes, or working with Laravel CLI generators. Covers make commands, php artisan flags, and common workflows.
---

# Artisan

## Make Commands (all in `app/`)

| Command | Creates |
|---------|---------|
| `php artisan make:model ModelName -m` | Model + migration |
| `php artisan make:model ModelName -a` | Model + migration + factory + seeder + controller |
| `php artisan make:controller Api/PostController --api` | API controller |
| `php artisan make:controller PostController --resource` | Resource controller |
| `php artisan make:request StorePostRequest` | Form request |
| `php artisan make:rule Uppercase` | Validation rule object |
| `php artisan make:notification PostPublished` | Notification |
| `php artisan make:event PostCreated` | Event |
| `php artisan make:listener SendPostNotification --event=PostCreated` | Listener |
| `php artisan make:job ProcessPost` | Job |
| `php artisan make:mail PostPublished` | Mailable |
| `php artisan make:factory PostFactory --model=Post` | Factory |
| `php artisan make:seeder PostSeeder` | Seeder |
| `php artisan make:middleware EnsurePostIsApproved` | Middleware |
| `php artisan make:policy PostPolicy --model=Post` | Policy |
| `php artisan make:scope TrendingScope` | Query scope |
| `php artisan make:cast JsonCast` | Custom cast |
| `php artisan make:channel PostChannel` | Broadcast channel |
| `php artisan make:command SendPosts` | Custom Artisan command |
| `php artisan make:component Alert` | Blade component |
| `php artisan make:livewire Counter` | Livewire component |

## Common Workflows

```bash
# Fresh migration with seeding
php artisan migrate:fresh --seed

# Run queue worker
php artisan queue:work

# Clear cache
php artisan optimize:clear

# Tinker (REPL)
php artisan tinker

# Route list
php artisan route:list

# Generate IDE helpers (if barryvdh/laravel-ide-helper installed)
php artisan ide-helper:generate
php artisan ide-helper:models
```

## Scheduling

Define in `routes/console.php`:

```php
Schedule::call(function () { ... })->daily();
Schedule::command('emails:send')->hourly();
Schedule::job(ProcessPodcast::class)->everyFiveMinutes();
```

## Custom Commands

`php artisan make:command` creates a class in `app/Console/Commands/`. Define `$signature` and `$description`, implement `handle()`.
