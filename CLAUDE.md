# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Oh-My-Taskfiles is a go-task based taskfile library for dev workflow automation. It provides a modular, extensible system for installing and configuring development tools across Linux, macOS, and Windows platforms.

## Key Commands

### Basic Usage

```bash
# List all available tasks
task --list
# or with alias
omt

# Run a specific task
task <taskname>
# Example:
task tools:starship:install
task git:config-global

# Show task details (without executing)
task <taskname> --summary

# Dry run with verbose output
task <taskname> --dry --verbose
```

### Common Tasks

```bash
# Update Oh-My-Taskfiles to latest version
omt update

# Show changelog
omt changelog

# Install tools (see available tools in taskfile.tools.yaml)
omt tools:starship:install
omt tools:zsh:install

# Configure Git globally
omt git:config-global

# Configure IDEs
omt apps:cursor:configure
```

## Architecture

### Entry Point

- [taskfile.yaml](taskfile.yaml) - Main entry point that includes all sub-taskfiles via `includes:` directive

### Category Taskfiles (in root)

These aggregate related tools/apps and flatten them into single namespaces:

- [taskfile.tools.yaml](taskfile.tools.yaml) - CLI tools (zsh, starship, git, k8s, etc.)
- [taskfile.apps.yaml](taskfile.apps.yaml) - Desktop apps (cursor, vscode, 1password, etc.)
- [taskfile.languages.yaml](taskfile.languages.yaml) - Language toolchains (go, rust, node)
- [taskfile.git.yaml](taskfile.git.yaml) - Git configuration tasks
- [taskfile.omt.yaml](taskfile.omt.yaml) - OMT self-management (update, changelog)
- [taskfile.lib.yaml](taskfile.lib.yaml) - Shared library taskfiles (scoop, winget helpers)
- [taskfile.awesome.yaml](taskfile.awesome.yaml) - Curated "awesome" lists

### Helper Taskfiles (taskfiles/ directory)

Internal helper taskfiles referenced with `::` prefix:

- [taskfiles/scoop.yaml](taskfiles/scoop.yaml) - Scoop package manager wrapper (Windows)
- [taskfiles/winget.yaml](taskfiles/winget.yaml) - Winget package manager wrapper (Windows)
- [taskfiles/install-common.yaml](taskfiles/install-common.yaml) - Shared installation success handlers
- [taskfiles/wsl.yaml](taskfiles/wsl.yaml) - WSL-specific tasks
- [taskfiles/ide.yaml](taskfiles/ide.yaml) - IDE configuration helpers (extension install, settings copy)
- [taskfiles/sudo.yaml](taskfiles/sudo.yaml) - Sudo/privilege escalation helpers

### Per-Tool/App Definitions

Individual YAML files in subdirectories:

- `tools/` - Tool-specific taskfiles (e.g., [tools/starship.yaml](tools/starship.yaml))
- `apps/` - App-specific taskfiles (e.g., [apps/cursor.yaml](apps/cursor.yaml))
- `languages/` - Language-specific taskfiles (e.g., [languages/go.yaml](languages/go.yaml))
- `awesome/` - Awesome list taskfiles

### Configuration Files

- `dotfiles/` - Configuration file templates (e.g., starship.toml, glazewm.yaml)

## Task File Patterns

### Structure

```yaml
version: "3"
silent: true # For clean output

tasks:
  install:
    desc: "[CATEGORY] ✨ Description"
    platforms: [windows] # or [linux, darwin]
    deps: [":tools:gum:install"] # Dependencies
    cmds:
      - task: install:windows
        platforms: [windows]
      - task: install:linux
        platforms: [linux]

  install:windows:
    platforms: [windows]
    internal: true # Not shown in --list
    cmds:
      - task: ::scoop:install
        vars: { APP: "app-name" }
```

### Key Conventions

- Task descriptions use format: `desc: "[CATEGORY] ✨ Description"`
- Use emoji prefixes in descriptions: ✨ (install), ⚙️ (configure), 🔍 (find)
- Platform-specific tasks use `platforms: [windows]` or `[linux, darwin]`
- Internal helper tasks marked with `internal: true`
- Parent/imported task references use `::` prefix (e.g., `::scoop:install`)
- Shell commands use multiline `|` blocks for readability
- Self-documenting task/variable names - no code comments

### Package Manager Wrappers

When installing via package managers, use these internal tasks:

```yaml
# Windows - Scoop
task: ::scoop:install
vars: { APP: "package-name" }

# Windows - Winget
task: ::winget:install
vars: { APP: "Publisher.AppName" }

# Windows - Scoop extras bucket
task: ::scoop:extras-install
vars: { APP: "package-name" }

# Windows - Scoop nerd-fonts bucket
task: ::scoop:nerd-fonts-install
vars: { APP: "font-name" }
```

## Development Workflow

### Adding a New Tool

1. Create `tools/newtool.yaml` with `install`, `configure`, and `default` tasks
2. Add to `includes:` section in [taskfile.tools.yaml](taskfile.tools.yaml)
3. Use platform-specific task splits when needed (`:linux`, `:windows`)
4. Reference helper tasks with `::` prefix (e.g., `::scoop:install`)

### Cross-Platform Considerations

- Windows uses Scoop or Winget for package management
- Linux/macOS use curl/wget with manual installation to `$HOME/bin`
- Use `platforms: [...]` to restrict tasks to specific OSes
- Test both paths when adding platform-specific logic

## Code Style (from .cursorrules)

Key principles from [.cursorrules/cursor-usage-standards.mdc](.cursorrules/cursor-usage-standards.mdc):

- Understand existing system before making changes
- Follow existing patterns in codebase
- Modular, testable, clean code
- No comments in YAML taskfiles - use self-documenting names
- One file per response when making changes
- 1600 lines per file maximum

From [.cursorrules/professional-coding-assistant.mdc](.cursorrules/professional-coding-assistant.mdc):

- Production-ready code with zero technical debt
- Apply DRY and KISS principles rigorously
- Self-documenting code with descriptive naming
- No code comments - use clear task/variable names
- Eliminate boilerplate and redundant code
