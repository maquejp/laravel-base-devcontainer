---
name: markdown
description: Use when writing or editing any .md file in this project. Lint with markdownlint-cli and respect the project's `.markdownlint.jsonc` config.
---

# Markdown

After editing any `.md` file, run markdownlint and fix all reported issues:

```bash
npx markdownlint-cli '**/*.md'
```

The project config is in `.markdownlint.jsonc` at the root:
- `MD013` line length: 120 (not 80)
- `MD033` inline HTML: allowed

Do not override the project config. Fix violations directly.
