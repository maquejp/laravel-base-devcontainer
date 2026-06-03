---
name: principles
description: Use when writing or reviewing code to enforce SOLID, DRY, KISS, and Laravel conventions. Keeps architecture clean and consistent.
---

# Principles

## SOLID

### Single Responsibility
A class should have one reason to change.

```php
// Bad: controller handles HTTP + email + logging
class PostController { ... }

// Good: controller only handles HTTP
class PostController { ... }
// Good: separate notification class
class PostPublishedNotification { ... }
// Good: separate logging middleware / action
class LogPostCreation { ... }
```

### Open/Closed
Open for extension, closed for modification. Use strategies, pipelines, or polymorphic dispatch instead of big `switch`/`if` blocks.

```php
// Bad
public function pay(string $method) {
    if ($method === 'stripe') { ... }
    elseif ($method === 'paypal') { ... }
}

// Good
interface PaymentGateway { ... }
class StripeGateway implements PaymentGateway { ... }
class PayPalGateway implements PaymentGateway { ... }
```

### Liskov Substitution
Subtypes must be substitutable for their base types. Don't override a method to throw `NotSupportedException` or no-op.

### Interface Segregation
Many small, focused interfaces > one large interface. Split by consumer role.

### Dependency Inversion
Depend on abstractions, not concretions. Use Laravel's container to bind interfaces to implementations.

```php
// In AppServiceProvider
$this->app->bind(PaymentGateway::class, StripeGateway::class);

// Inject the interface
public function __construct(private PaymentGateway $gateway) {}
```

## DRY

Don't repeat yourself. Extract duplication into:

- **Form requests** — duplicate validation in multiple controllers → single form request
- **Query scopes** — duplicate `where('active', true)` → `scopeActive()`
- **Service classes** — duplicate logic across controllers/jobs → `PostService::publish()`
- **Actions** (single-action classes) — one-off operations shared by jobs and controllers
- **Traits** — shared behavior across unrelated models (use sparingly)
- **Blade components** — repeated UI patterns

Don't DRY prematurely — two occurrences is coincidence, three is a pattern.

## KISS

Keep It Simple. Prefer:

- Eloquent over raw SQL unless performance demands otherwise
- Controllers over complex action chains for simple CRUD
- Small focused classes over deep inheritance hierarchies
- Array/collection methods over custom loops
- Clear verbose names over clever abbreviations

### Laravel-specific simplicity

```php
// Prefer this
User::where('active', true)->get();

// Over this (unless needed)
DB::table('users')->where('active', true)->get();
```

- Use Laravel conventions before custom abstractions
- Reach for dedicated classes (Jobs, Listeners, Events) only when a controller/method grows too large
- Don't build a service layer by default—Laravel's MVC is enough for most features

## When To Break The Rules

- **YAGNI** — don't build abstractions for features that don't exist yet
- **Duplication is cheaper than the wrong abstraction** (Sanderson)
- Simple CRUD endpoints rarely need a service layer—stop at the controller
