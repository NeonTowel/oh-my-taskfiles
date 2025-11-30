# AGENTS.md - Oh-My-Taskfiles

## Commands
- List all tasks: `task --list` or `omt`
- Run a task: `task <taskname>` (e.g., `task tools:install`)
- Dry run: `task <taskname> --dry --verbose`
- Task info: `task <taskname> --summary`

## Architecture
This is a go-task based taskfile library for dev workflow automation.
- `taskfile.yaml` - Main entry point, includes all sub-taskfiles
- `taskfile.*.yaml` - Category taskfiles (tools, apps, languages, git, etc.)
- `taskfiles/` - Helper taskfiles (scoop, winget, wsl, ide, sudo)
- `apps/`, `tools/`, `languages/`, `awesome/` - Per-tool/app task definitions
- `dotfiles/` - Configuration file templates

## Code Style (YAML Taskfiles)
- Use `version: '3'` header
- Use `silent: true` for clean output
- Task descriptions: `desc: "[CATEGORY] ✨ Description"`
- Mark helper tasks as `internal: true`
- Use `platforms: [windows]` or `[linux, darwin]` for OS-specific tasks
- Reference parent tasks with `::` prefix (e.g., `::scoop:install`)
- Shell commands in multiline `|` blocks
- No comments in code; self-documenting task/var names
