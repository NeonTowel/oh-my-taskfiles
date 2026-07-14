This file provides guidance to AI coding agents and assistants when working with code in this repository.

# AGENTS.md - Oh-My-Taskfiles

## Commands

Use Go-task as the primary interface for this repository.

- List top-level tasks: `task --list`
- List all tasks, including internal tasks: `task --list-all`
- Run a task: `task <taskname>` (for example, `task tools:bun:install`)
- Inspect what a task does: `task <taskname> --summary`
- Dry-run a task before changing the system: `task <taskname> --dry --verbose`
- Use the installed CLI equivalent when working from an installed `~/.omt`: `omt <taskname>`

CLI development commands live under `cmd/taskfile.yaml`:

- Build the OMT CLI for the current supported platform: `task --taskfile cmd/taskfile.yaml build`
- Build Windows and Linux CLI binaries: `task --taskfile cmd/taskfile.yaml build:all`
- Run Go tests: `task --taskfile cmd/taskfile.yaml test`
- Run Go vet: `task --taskfile cmd/taskfile.yaml lint`
- Run a single Go test when needed: from `cmd/`, use `go test ./... -run TestName`

## Architecture

This is a Go-task based taskfile library for development environment automation, plus a small Go CLI wrapper named `omt`.

- `taskfile.yaml` is the main entrypoint. It sets global vars, includes category taskfiles, and makes the default task list available tasks and check for updates.
- `tools.yaml`, `apps.yaml`, and `languages.yaml` are category aggregators. Add new tool/app/language taskfiles there so names are exposed under namespaces like `tools:<name>:install`, `apps:<name>:install`, or `lang:<name>:install`.
- `tools/`, `apps/`, and `languages/` contain per-tool task definitions. These usually provide a `default` task that lists that file's tasks and an `install` task that delegates to platform-specific internal tasks.
- `lib.yaml` includes shared helpers from `lib/`. Some helpers are flattened into the root namespace (`install-common`, `omt`, `awesome`), while others remain namespaced (`git`, `sudo`, `wsl`, `ide`).
- `lib/scoop.yaml`, `lib/winget.yaml`, and related helper files centralize package-manager behavior. Prefer delegating to these helpers instead of duplicating install commands in individual Windows tasks.
- `dotfiles/` stores configuration templates installed or referenced by taskfiles.
- `cmd/` is the Go module for the `omt` CLI. The CLI forwards arbitrary task arguments and supported flags to `task --dir ~/.omt`, and has an `install` subcommand with platform-specific implementation files.
- `.github/workflows/release.yaml` builds and bundles the Go CLI for Linux, macOS, and Windows on tags and validates CLI changes on pull requests.

## Taskfile conventions

- Use `version: '3'` for new taskfiles.
- Prefer `silent: true` at entrypoints when clean output matters.
- Task descriptions should follow the existing pattern: `desc: "[CATEGORY] ✨ Description"`.
- Mark implementation-only tasks with `internal: true`.
- Use `platforms: [windows]`, `[linux]`, `[darwin]`, or combinations for OS-specific tasks.
- For cross-platform installs, expose a public `install` task and delegate to `install:{{ OS }}` or explicit platform-specific tasks.
- Reference parent/root helper tasks with `::` when inside included taskfiles, for example `::scoop:install`.
- Use existing helper variables and tasks such as `{{ .gum_ok }}`, `install-success`, `scoop:*`, and `winget:*` rather than recreating status or success behavior.
- Put shell scripts in multiline `|` blocks when they contain branching or multiple commands.
- Keep taskfiles self-documenting; avoid comments in YAML taskfiles unless they clarify non-obvious behavior.

## Package manager guidance

- Prefer task commands over direct package-manager calls.
- For JavaScript/Node-related work, default to Bun. Use existing Bun installation tasks (`tools:bun:install`) instead of adding npm/yarn assumptions.
- On Windows install tasks, prefer Scoop helpers first when an app is available through Scoop; use Winget helpers only when that matches existing patterns for the tool.

## Go CLI conventions

- The Go module root is `cmd/`, not the repository root.
- Keep CLI behavior as a thin wrapper around Go-task unless a change specifically needs installation or argument-forwarding logic.
- When adding CLI flags, ensure they are forwarded to `task` consistently with existing flags in `cmd/main.go`.
- Run `task --taskfile cmd/taskfile.yaml test` and `task --taskfile cmd/taskfile.yaml lint` after CLI changes.
