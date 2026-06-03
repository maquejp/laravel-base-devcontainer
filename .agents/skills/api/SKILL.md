---
name: api
description: Use when designing or implementing API endpoints, resources, response structures, pagination, or versioning. Covers Laravel API conventions.
---

# API Design

## Response Structure

Use a consistent envelope for JSON responses:

```php
// Success (single)
return response()->json([
    'data' => $resource,
]);

// Success (collection)
return PostResource::collection($posts);

// Created
return response()->json($resource, 201);

// No content (deletion)
return response()->noContent();
```

## Resources

```php
php artisan make:resource PostResource
php artisan make:resource PostCollection
```

```php
class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'author' => new UserResource($this->whenLoaded('user')),
            'comments' => CommentResource::collection($this->whenLoaded('comments')),
            'created_at' => $this->created_at->toISOString(),
        ];
    }
}
```

## Pagination

```php
// Controller
return PostResource::collection(Post::paginate(20));

// Response shape
{
    "data": [...],
    "meta": {
        "current_page": 1,
        "last_page": 5,
        "per_page": 20,
        "total": 100
    },
    "links": {
        "first": "...",
        "last": "...",
        "prev": null,
        "next": "..."
    }
}
```

Always paginate collection endpoints. Default per_page should match frontend needs.

## Naming

- **Resources**: plural nouns (`/posts`, `/users`, `/posts/{post}/comments`)
- **Actions**: verbs for non-CRUD (`/posts/{post}/publish`, `POST /auth/login`)
- **kebab-case** for multi-word (`/blog-posts`, not `/blog_posts` or `/blogPosts`)
- Version in URL only for breaking changes: `/api/v1/posts`

## Status Codes

| Code | When |
|------|------|
| 200 | GET success, PATCH success |
| 201 | POST created |
| 204 | DELETE success |
| 401 | Unauthenticated |
| 403 | Forbidden |
| 404 | Not found |
| 422 | Validation error |
| 429 | Rate limited |
| 500 | Server error |

## Route Files

- API routes in `routes/api.php` (loaded with `api` middleware group)
- Always generate: `php artisan install:api` (Laravel 11)
