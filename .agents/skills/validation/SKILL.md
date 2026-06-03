---
name: validation
description: Use when defining validation rules, form requests, custom rule objects, or error handling. Covers Laravel's validation system.
---

# Validation

## Form Requests

```php
php artisan make:request StorePostRequest
```

```php
class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', Post::class);
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'body' => ['required', 'string', 'min:10'],
            'slug' => ['required', 'string', 'unique:posts,slug'],
            'category_id' => ['required', 'exists:categories,id'],
            'tags' => ['array'],
            'tags.*' => ['exists:tags,id'],
            'published_at' => ['nullable', 'date'],
        ];
    }

    public function messages(): array
    {
        return [
            'title.required' => 'A post title is required.',
        ];
    }
}
```

## Available Rules

| Rule | Usage |
|------|-------|
| Required | `'required'` |
| String | `'string'` |
| Numeric | `'numeric'` |
| Email | `'email'` |
| Unique | `'unique:table,column,ignoreId'` |
| Exists | `'exists:table,column'` |
| Date | `'date'` |
| Boolean | `'boolean'` |
| Array | `'array'` |
| In | `Rule::in(['a', 'b'])` |
| Confirmed | `'confirmed'` (matches `_confirmation` field) |

## Custom Rule Objects

```php
php artisan make:rule Uppercase
```

```php
class Uppercase implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (strtoupper($value) !== $value) {
            $fail('The :attribute must be uppercase.');
        }
    }
}
```

## Inline Validation (in controllers)

```php
$validated = $request->validate([
    'email' => ['required', 'email', Rule::unique('users')->ignore($user->id)],
    'password' => 'required|min:8|confirmed',
]);
```

## Error Handling

```blade
@if ($errors->any())
    <ul>@foreach ($errors->all() as $error) <li>{{ $error }}</li> @endforeach</ul>
@endif

@error('title') <p>{{ $message }}</p> @enderror
```
