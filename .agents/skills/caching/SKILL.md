---
name: caching
description: Use when implementing caching strategies — query caching, response caching, tag-based invalidation, and cache drivers. Works with any cache driver, not Redis-specific.
---

# Caching

## Cache Drivers

Laravel supports `file`, `database`, `dynamodb`, and `redis`. For broadest compatibility, use `file` or `database`:

```env
CACHE_STORE=file
# or
CACHE_STORE=database
```

## Caching Expensive Queries

```php
use Illuminate\Support\Facades\Cache;

// Remember forever (until manually forgotten)
$posts = Cache::remember('posts.all_active', 3600, fn() =>
    Post::where('active', true)->with('user')->get()
);

// Tags (only file/redis/dynamodb, not database)
Cache::tags(['posts'])->remember('posts.active', 3600, fn() => ...);

// Forget on model events
Post::created(fn() => Cache::forget('posts.all_active'));
Post::updated(fn() => Cache::forget('posts.all_active'));
Post::deleted(fn() => Cache::forget('posts.all_active'));
```

## Model Observers for Cache Invalidation

```php
class PostObserver
{
    public function created(Post $post): void
    {
        Cache::forget('posts.active');
    }

    public function updated(Post $post): void
    {
        Cache::forget('posts.active');
        Cache::forget("post.{$post->id}");
    }

    public function deleted(Post $post): void
    {
        Cache::forget('posts.active');
        Cache::forget("post.{$post->id}");
    }
}
```

Register in `AppServiceProvider` or `EventServiceProvider`:

```php
Post::observe(PostObserver::class);
```

## Response Caching (for API)

```php
// In controller
return response()->json($data)->setCache([
    'public' => true,
    'max_age' => 3600,
    'etag' => md5(serialize($data)),
]);

// Client-side: 304 Not Modified if ETag matches
```

## Full Page / Route Caching

```php
// Cache entire API response (middleware approach)
Route::middleware(['cache.headers:public;max_age=3600;etag'])->group(function () {
    Route::get('/posts', [PostController::class, 'index']);
});
```

## Cache Key Convention

```
{model}.{scope}.{identifier}
Examples:
- posts.active
- post.42
- user.5.posts
- home.feed.paginated.1
```

## When To Cache

- Index/list endpoints with stable data
- Expensive aggregations (counts, sums)
- Configuration / settings that change rarely
- External API responses (with TTL)

## When NOT To Cache

- User-specific content (unless keyed by user ID)
- Real-time data (prices, statuses)
- Data that changes every request
