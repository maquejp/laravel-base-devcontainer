---
name: blade
description: Use when writing Blade templates, components, layouts, directives, or rendering views. Covers Laravel's templating engine.
---

# Blade

## Template Inheritance

```blade
{{-- layout.blade.php --}}
<html><body>
@yield('content')
{{ $slot ?? '' }}
</body></html>

{{-- child.blade.php --}}
@extends('layout')
@section('content') <p>Hello</p> @endsection
```

## Components

```blade
{{-- app/View/Components/Alert.php + resources/views/components/alert.blade.php --}}
<x-alert type="error" :message="$message" />

{{-- Anonymous component: resources/views/components/button.blade.php --}}
<x-button />

{{-- Component with slots --}}
<x-card>
    <x-slot:header>Title</x-slot>
    <p>Body content</p>
</x-card>
```

## Directives

```blade
{{-- Conditionals --}}
@if ($condition) ... @elseif (...) ... @else ... @endif
@unless ($condition) ... @endunless
@isset($var) ... @endisset
@empty($var) ... @endempty

{{-- Loops --}}
@foreach ($items as $item) ... @endforeach
@forelse ($items as $item) ... @empty ... @endforelse
@while ($condition) ... @endwhile

{{-- Auth --}}
@auth ... @endauth
@guest ... @endguest
@can('update', $post) ... @endcan

{{-- Assets --}}
@vite(['resources/css/app.css', 'resources/js/app.js'])

{{-- Raw JS --}}
@verbatim <div>{{ $var }}</div> @endverbatim
```

## Display

- `{{ $var }}` — escaped
- `{!! $var !!}` — raw (XSS risk)
- `{{ $var ?? 'default' }}` — with default

## Layouts (Laravel 11)

Use component-based layouts:

```blade
{{-- resources/views/components/layout.blade.php --}}
<!DOCTYPE html>
<html><body>
{{ $slot }}
</body></html>

{{-- Page --}}
<x-layout>
    <h1>Welcome</h1>
</x-layout>
```
