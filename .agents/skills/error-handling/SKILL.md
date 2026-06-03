---
name: error-handling
description: Use when implementing exception handling, error responses, logging, or debugging in a Laravel API. Covers consistent error JSON responses.
---

# Error Handling

## Consistent JSON Error Format

All API errors should return a uniform structure:

```json
{
    "message": "The given data was invalid.",
    "errors": {
        "email": ["The email field is required."]
    }
}
```

```json
{
    "message": "Post not found.",
    "code": "POST_NOT_FOUND"
}
```

## Exception Handling (`bootstrap/app.php`)

```php
->withExceptions(function (Exceptions $exceptions) {
    // 404
    $exceptions->render(function (NotFoundHttpException $e) {
        return response()->json([
            'message' => 'Resource not found.',
        ], 404);
    });

    // 403
    $exceptions->render(function (AuthorizationException $e) {
        return response()->json([
            'message' => 'This action is unauthorized.',
        ], 403);
    });

    // 401
    $exceptions->render(function (AuthenticationException $e) {
        return response()->json([
            'message' => 'Unauthenticated.',
        ], 401);
    });

    // 429
    $exceptions->render(function (ThrottleRequestsException $e) {
        return response()->json([
            'message' => 'Too many requests.',
            'retry_after' => $e->getHeaders()['Retry-After'] ?? null,
        ], 429);
    });

    // 500 (only show details in local)
    $exceptions->render(function (Throwable $e) {
        return response()->json([
            'message' => app()->isLocal() ? $e->getMessage() : 'Server error.',
        ], 500);
    });
})
```

## Validation Errors

Form request validation automatically returns 422 with the format above — no extra work needed.

## Business Logic Exceptions

```php
class PostNotFoundException extends Exception
{
    public function render(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'Post not found.',
            'code' => 'POST_NOT_FOUND',
        ], 404, ['X-Error-Code' => 'POST_NOT_FOUND']);
    }
}
```

## Logging

```php
// Global context (AppServiceProvider)
Log::shareContext([
    'user_id' => auth()->id(),
    'request_id' => request()->header('X-Request-Id'),
]);

// Specific
Log::error('Payment failed', [
    'user_id' => $user->id,
    'amount' => $amount,
    'stripe_error' => $e->getMessage(),
]);

// Channels: daily files, Slack, stderr
// Configure in config/logging.php
```

## Debugging (dev only)

```bash
# See all queries
DB::enableQueryLog();
// ... run queries ...
dump(DB::getQueryLog());

# Laravel debugbar (barryvdh/laravel-debugbar)
# Telescope for full request/query/job inspection
php artisan telescope:install
```
