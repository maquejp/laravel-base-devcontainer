---
name: eloquent
description: Use when building Eloquent models, relationships, scopes, query builder chains, accessors, mutators, casts, or optimizing database queries.
---

# Eloquent

## Model Conventions

- Models live in `app/Models/`
- Table names: snake_case plural of class (`User` → `users`)
- Primary key: `id` (auto-incrementing integer)
- Timestamps: `created_at`, `updated_at` (auto-managed)
- Soft deletes: use `Illuminate\Database\Eloquent\SoftDeletes` trait

## Relationships

```php
class Post extends Model
{
    // One-to-One
    public function profile(): HasOne { return $this->hasOne(Profile::class); }

    // Inverse
    public function user(): BelongsTo { return $this->belongsTo(User::class); }

    // One-to-Many
    public function comments(): HasMany { return $this->hasMany(Comment::class); }

    // Many-to-Many
    public function tags(): BelongsToMany { return $this->belongsToMany(Tag::class); }

    // Has-Many-Through
    public function comments(): HasManyThrough { return $this->hasManyThrough(Comment::class, Post::class); }

    // Morph
    public function photos(): MorphMany { return $this->morphMany(Photo::class, 'imageable'); }
    public function photo(): MorphOne { return $this->morphOne(Photo::class, 'imageable'); }

    // Morph many-to-many
    public function tags(): MorphToMany { return $this->morphToMany(Tag::class, 'taggable'); }
}
```

## Query Scopes

```php
// Local scope (in model)
public function scopePopular(Builder $query, int $min = 100): Builder
{
    return $query->where('votes', '>=', $min);
}

// Global scope (class implementing Scope interface)
// Usage: Post::popular()->active()->get()
```

## Eager Loading

```php
Post::with(['comments.user', 'tags'])->get();
Post::load(['comments' => fn($q) => $q->where('approved', true)]);
Post::withCount('comments');
```

## Accessors & Mutators

```php
// Accessor (Laravel 11+ style)
protected function name(): Attribute
{
    return Attribute::make(get: fn(string $value) => ucfirst($value));
}

// Mutator
protected function name(): Attribute
{
    return Attribute::make(set: fn(string $value) => strtolower($value));
}
```

## Casts

```php
protected function casts(): array
{
    return [
        'is_admin' => 'boolean',
        'config' => 'array',
        'metadata' => 'collection',
        'price' => 'decimal:2',
        'expires_at' => 'datetime',
        'data' => AsEnumCollection::class,
    ];
}
```

## Performance Tips

- Always eager-load relationships in views
- Use `cursor()` or `lazy()` for memory-heavy iteration
- Prefer `whereHas()` over `load()` when filtering
- Add DB indexes for columns used in `where`, `orderBy`, or joins
- Use `chunk()` or `each()` for batch processing large datasets
