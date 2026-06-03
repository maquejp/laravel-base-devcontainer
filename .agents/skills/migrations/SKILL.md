---
name: migrations
description: Use when creating or modifying database migrations, schema definitions, seeders, or rolling back changes. Covers Laravel's schema builder.
---

# Migrations

## Naming Convention

```
2024_01_01_000000_create_posts_table.php
2024_01_02_000000_add_fields_to_posts_table.php
2024_01_03_000000_create_post_user_table.php
```

## Schema Builder

```php
Schema::create('posts', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('title');
    $table->text('body')->nullable();
    $table->string('slug')->unique();
    $table->boolean('is_published')->default(false);
    $table->timestamp('published_at')->nullable();
    $table->softDeletes();
    $table->timestamps();
});
```

## Modifying Columns

```php
// Always add a separate migration (never edit existing ones in source control)
Schema::table('posts', function (Blueprint $table) {
    $table->string('subtitle')->nullable()->after('title');
    $table->dropColumn('legacy_field');
    $table->renameColumn('old_name', 'new_name');
    $table->integer('votes')->default(0)->change();
});
```

## Column Types

| Type | Method |
|------|--------|
| Auto-increment | `$table->id()` |
| UUID | `$table->uuid('id')->primary()` |
| Foreign UUID | `$table->foreignUuid('user_id')->constrained()` |
| Enum | `$table->string('status')->default('draft')` |
| JSON | `$table->json('metadata')` |
| Nullable timestamps | `$table->timestamp('approved_at')->nullable()` |
| Index | `$table->index(['column1', 'column2'])` |

## Foreign Keys

```php
$table->foreignId('user_id')->constrained()->cascadeOnDelete();
// cascadeOnUpdate(), nullOnDelete(), restrictOnDelete()
```

## Seeders

```php
class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            UserSeeder::class,
            PostSeeder::class,
        ]);
    }
}

// In PostSeeder
Post::factory(50)->create();
```

## Commands

```bash
php artisan migrate
php artisan migrate:fresh   # drop all tables, re-run
php artisan migrate:rollback
php artisan make:migration add_fields_to_posts_table
```
