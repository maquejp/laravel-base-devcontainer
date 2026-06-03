---
name: testing
description: Use when writing tests, factories, HTTP tests, feature tests, unit tests, or working with Pest/PHPUnit. Covers test conventions and common patterns.
---

# Testing

## Conventions

- Tests live in `tests/` mirroring `app/` structure
- `tests/Feature/` — HTTP requests, database, full stack
- `tests/Unit/` — isolated class/function tests (no DB)
- Method naming: `it_can_do_something` or `testSomething`
- Base test class extends `Tests\TestCase`

## Factories

```php
class PostFactory extends Factory
{
    public function definition(): array
    {
        return [
            'title' => fake()->sentence(),
            'body' => fake()->paragraphs(3, true),
            'user_id' => User::factory(),
            'published_at' => null,
        ];
    }

    public function published(): static
    {
        return $this->state(fn(array $attrs) => [
            'published_at' => now(),
        ]);
    }
}
```

## HTTP Tests

```php
public function test_guests_cannot_create_posts(): void
{
    $response = $this->postJson('/api/posts', [
        'title' => 'Test',
    ]);

    $response->assertUnauthorized();
}

public function test_authenticated_user_can_create_post(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->postJson('/api/posts', [
            'title' => 'My Post',
            'body' => 'Content here',
        ]);

    $response->assertCreated();
    $this->assertDatabaseHas('posts', ['title' => 'My Post']);
}
```

## Pest (if used instead of PHPUnit)

```php
uses(Tests\TestCase::class)->in('Feature');

it('creates a post', function () {
    $post = Post::factory()->create();
    expect($post->title)->toBeString();
});

describe('authentication', function () {
    it('rejects unauthenticated requests', function () { ... });
    it('allows valid token', function () { ... });
});
```

## Common Assertions

```php
$response->assertOk();                     // 200
$response->assertCreated();                // 201
$response->assertNoContent();              // 204
$response->assertRedirect('/home');        // 302
$response->assertUnauthorized();           // 401
$response->assertForbidden();              // 403
$response->assertNotFound();               // 404
$response->assertUnprocessable();          // 422
$response->assertJsonStructure(['id', 'name']);
$response->assertJsonPath('data.email', '...');
```

## Database Assertions

```php
$this->assertDatabaseHas('users', ['email' => '...']);
$this->assertDatabaseMissing('users', ['email' => '...']);
$this->assertDatabaseCount('users', 5);
```
