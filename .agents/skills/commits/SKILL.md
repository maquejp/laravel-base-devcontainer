---
name: commits
description: Use when committing code — enforce Conventional Commits format and write commit messages for the user. This skill triggers on every git commit operation.
---

# Conventional Commits

All commits **must** follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

## Types

| Type     | When to use                                  |
|----------|----------------------------------------------|
| `feat`   | A new feature                                |
| `fix`    | A bug fix                                    |
| `chore`  | Maintenance, dependencies, tooling           |
| `docs`   | Documentation only                           |
| `style`  | Formatting, whitespace (not CSS)             |
| `refactor` | Code change that neither fixes nor adds    |
| `perf`   | Performance improvement                      |
| `test`   | Adding or fixing tests                       |
| `ci`     | CI/CD configuration changes                  |

## Scope (optional)

Area of the codebase (e.g., `auth`, `api`, `posts`, `payments`).

## Examples

```
feat(auth): add social login via GitHub
fix(posts): prevent SQL injection in search query
refactor(api): extract payment logic into service
docs(readme): update installation instructions
test(users): add factory for User model
chore(deps): upgrade Laravel to 11.20
style: apply Pint formatting
```

## Breaking Changes

Append `!` after the type/scope and add a `BREAKING CHANGE:` footer:

```
feat!(api): remove v1 endpoints

BREAKING CHANGE: v1 endpoints are removed. Migrate to v2.
```

## Body

Use the body to explain **what** and **why**, not how. Wrap at 72 characters.

## Rules

- Description is lowercase, no trailing period
- Imperative mood ("add" not "added" / "adds")
- Max 72 characters for the header line
- No merge commits — use rebase instead
