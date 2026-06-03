---
name: postgresql
description: Use when working with PostgreSQL in or outside Laravel — connection config, migrations, queries, indexing, JSON, full-text search, and psql tips.
---

# PostgreSQL

## Connection (already configured in docker-compose)

```
DB_CONNECTION=pgsql
DB_HOST=laravel-app-db
DB_PORT=5432
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=laravel
```

## psql (inside container)

```bash
psql -h laravel-app-db -U laravel -d laravel
```

## Laravel Specifics

### Schema Builder

```php
// JSON columns
$table->json('metadata');
$table->jsonb('settings');

// Full-text
$table->fullText(['title', 'body']);

// Generated columns
$table->integer('subtotal')->virtualAs('quantity * price');

// UUID
$table->uuid('id')->primary();
$table->foreignUuid('user_id')->constrained();

// Geometry (if postgis extension is enabled)
$table->point('location');
```

### Indexes

```php
$table->index('email');
$table->unique('slug');
$table->fullText(['title', 'body']);
// Partial index via raw expression
DB::statement('CREATE INDEX ... WHERE ...');
```

## Useful PostgreSQL Features

### Full-Text Search

```sql
-- Create tsvector column
ALTER TABLE posts ADD COLUMN search_vector tsvector
    GENERATED ALWAYS AS (to_tsvector('english', coalesce(title,'') || ' ' || coalesce(body,''))) STORED;

CREATE INDEX posts_search_idx ON posts USING GIN(search_vector);

-- Query
SELECT * FROM posts WHERE search_vector @@ plainto_tsquery('english', 'search term');
```

### Array Columns

```php
// Migration
$table->addColumn('integer[]', 'tag_ids')->nullable();

// Query
Post::whereRaw('? = ANY(tag_ids)', [$tagId])->get();
```

### Window Functions

```php
use Illuminate\Support\Facades\DB;

$posts = Post::select('title', 'category_id',
    DB::raw('RANK() OVER (PARTITION BY category_id ORDER BY created_at DESC) as rank')
)->get();
```

## Maintenance

```bash
# Analyze for query planner
psql -c "ANALYZE;"

# Kill idle connections
psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE state = 'idle';"
```

## Extensions

Enable in a migration:

```php
public function up(): void
{
    DB::statement('CREATE EXTENSION IF NOT EXISTS pg_trgm');  // Trigram matching
    DB::statement('CREATE EXTENSION IF NOT EXISTS unaccent');  // Accent-insensitive
    DB::statement('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'); // UUID generation
}
```
