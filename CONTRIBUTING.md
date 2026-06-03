# Contributing

## Getting Started

1. Fork the repository
2. Clone your fork
3. Open in VS Code and reopen in container
4. Create a branch: `git checkout -b feat/my-feature`

## Development

- Edit skills in `.agents/skills/<name>/SKILL.md`
- Edit agents in `.agents/agents/<name>.md`
- Edit devcontainer config in `.devcontainer/`

After editing markdown files, run:

```bash
npx markdownlint-cli '**/*.md'
```

## Committing

This project uses Conventional Commits:

```text
feat(artisan): add make:policy generator docs
fix(readme): correct port number
chore(deps): update PHP image version
```

## Pull Requests

- Keep PRs focused — one feature or fix per PR
- Update relevant skills if your change affects Laravel conventions
- Ensure all markdown passes linting
- Reference any related issues
