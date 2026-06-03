---
name: performance
description: Use when optimizing database queries, preventing N+1, reducing memory usage, or improving API response times. Covers Laravel performance patterns without requiring Redis.
---

# Performance

## N+1 Prevention

Always eager-load relationships that will be used:

```php
// Bad: N+1
$posts = Post::all();
foreach ($posts as $post) {
    echo $post->user->name;
}

// Good: 2 queries
$posts = Post::with('user')->get();

// Load only when needed
$posts = Post::all();
if ($someCondition) {
    $posts->load('comments');
}
```

## Lazy Collections

Use `lazy()` / `cursor()` for large datasets instead of `all()` / `get()`:

```php
// Bad: loads all rows into memory
Post::all()->each(fn($post) => ...);

// Good: streams rows one at a time
foreach (Post::lazy() as $post) { ... }

// Good: cursor (keeps a single open connection)
foreach (Post::cursor() as $post) { ... }
```

## Chunking

```php
// Process 100 records at a time
Post::chunk(100, function ($posts) {
    foreach ($posts as $post) {
        // process
    }
});

// Chunk with IDs (safer for concurrent writes)
Post::chunkById(100, function ($posts) { ... });
```

## Query Optimization

- Add indexes for columns used in `where`, `orderBy`, `join`, and `groupBy`
- Select only needed columns: `Post::select('id', 'title')->get()`
- Use `whereHas()` instead of `load()->filter()` when you just need existence
- Avoid `whereRaw()` unless needed — use the query builder methods
- Use `doesntHave()` / `has()` for existence checks without loading data

## Database Indexes

```php
Schema::table('posts', function (Blueprint $table) {
    $table->index('published_at');
    $table->index(['user_id', 'created_at']); // composite
});
```

## Session & Cache

- Use file or database drivers for sessions (not Redis)
- Cache expensive queries with file/database driver

```php
// File-based cache (works everywhere)
$posts = Cache::store('file')->remember('posts.active', 3600, fn() =>
    Post::where('active', true)->with('user')->get()
);
```

## Queues

Offload slow tasks to the `database` queue driver:

```php
// .env
QUEUE_CONNECTION=database

// Generate table
php artisan queue:table
php artisan migrate

// Dispatch
ProcessPost::dispatch($post);

// Process
php artisan queue:work
```

## Config Caching

```bash
# Production only (not dev)
php artisan optimize
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## General Tips

- Use `dd()` / `dump()` sparingly in production code paths
- Avoid `@foreach` inside Blade with unloaded relationships
- Use `php artisan optimize:clear` only in development
- Profile before optimizing — measure with Debugbar or Telescope
