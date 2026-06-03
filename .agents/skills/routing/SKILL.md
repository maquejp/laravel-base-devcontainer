---
name: routing
description: Use when defining routes, organizing route files, applying middleware, using route model binding, or configuring controllers.
---

# Routing

## File Organization

| File | Purpose |
|------|---------|
| `routes/web.php` | Web routes (session, cookies, CSRF) |
| `routes/api.php` | API routes (stateless, rate-limited) |
| `routes/console.php` | Artisan command schedules |
| `routes/channels.php` | Broadcast channels |

## Route Definitions

```php
// Verb methods
Route::get('/posts', [PostController::class, 'index']);
Route::post('/posts', [PostController::class, 'store']);
Route::put('/posts/{post}', [PostController::class, 'update']);
Route::delete('/posts/{post}', [PostController::class, 'destroy']);
Route::patch('/posts/{post}', [PostController::class, 'partial']);

// Resourceful
Route::resource('posts', PostController::class);
Route::apiResource('posts', PostController::class); // no create/edit

// Nested
Route::resource('posts.comments', CommentController::class)->shallow();

// Grouped
Route::middleware('auth')->group(function () { ... });
Route::prefix('admin')->group(function () { ... });
Route::name('admin.')->group(function () { ... });
```

## Route Model Binding

```php
// Implicit binding (typed parameter name matches route param)
Route::get('/posts/{post}', fn(Post $post) => $post);

// Custom key
Route::get('/posts/{post:slug}', fn(Post $post) => $post);

// Explicit binding (in RouteServiceProvider or boot())
Route::bind('post', fn(string $value) => Post::where('slug', $value)->firstOrFail());
```

## Controller Organization

```php
// Single action controller
php artisan make:controller ShowPostController --invokable

// API resource controller
php artisan make:controller PostController --api --model=Post
```

## Middleware

```php
Route::middleware(['auth', 'verified'])->group(function () { ... });
Route::get('/profile', fn() => ...)->withoutMiddleware('auth');
```

## Route Caching

```bash
# Cache routes (never in local dev)
php artisan route:cache
php artisan route:clear
```
