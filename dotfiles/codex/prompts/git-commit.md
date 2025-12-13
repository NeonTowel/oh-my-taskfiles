---
description: Smart git commit using staged files + last 5 commits style
---

1. Run `git diff --staged --name-only` to list staged files only. Capture full staged diff with `git diff --staged`.

2. Fetch last 5 commits: `git log --oneline -5`. Analyze their message patterns (format, Conventional Commits, emojis, scopes).

3. Generate commit message matching that style. Describe **staged changes only** from `git diff --staged`. Prefix with $MESSAGE if provided.

4. Commit with `git commit -S -m "<generated message>"`.
