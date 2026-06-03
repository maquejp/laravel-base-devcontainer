---
name: security
description: Use when implementing authentication, authorization, CORS, rate limiting, or reviewing code for security vulnerabilities in a Laravel API.
---

# Security

## Authentication

```bash
# Laravel 11 API auth
php artisan install:api

# Sanctum (stateless token-based)
# config/sanctum.php
```

```php
// Issue token (e.g., in LoginController)
$token = $user->createToken('api-token')->plainTextToken;

// Protect routes
Route::middleware('auth:sanctum')->group(function () { ... });

// Get authenticated user
$user = $request->user(); // or auth()->user()
```

## Authorization

```php
// Generate policy
php artisan make:policy PostPolicy --model=Post
```

```php
class PostPolicy
{
    public function view(User $user, Post $post): bool
    {
        return $user->id === $post->user_id;
    }

    public function create(User $user): bool { return true; }
    public function update(User $user, Post $post): bool { ... }
    public function delete(User $user, Post $post): bool { ... }
}
```

```php
// In controller
$this->authorize('update', $post);

// Via Gate facade
Gate::authorize('update', $post);

// In blade
@can('update', $post) ... @endcan
```

Use policies instead of `$request->user()->id === $model->user_id` sprinkled across controllers.

## CORS

Configured in `config/cors.php` (Laravel 11: `config/cors.php` or middleware):

```php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [env('FRONTEND_URL', 'http://localhost:5173')],
    'allowed_headers' => ['*'],
    'supports_credentials' => true,
];
```

## Rate Limiting

```php
// In AppServiceProvider or RouteServiceProvider
RateLimiter::for('api', fn() => Limit::perMinute(60));

// Apply via middleware
Route::middleware('throttle:api')->group(function () { ... });

// Per-user limits
RateLimiter::for('api', fn(User $user) =>
    Limit::perMinute(60)->by($user->id)
);
```

## General Rules

- Never trust user input: validate, sanitize, escape
- Use prepared statements / Eloquent (protects against SQL injection automatically)
- Never expose sensitive fields (passwords, tokens) in JSON output — use `$hidden` on models or `->except()` on resources
- Apply `$guarded` or `$fillable` on all models to prevent mass-assignment
- Use HTTPS in production
- Hash passwords with bcrypt (Laravel default)
- Validate file uploads: type, size, mime
- Log security events (failed logins, unauthorized access attempts)
