---
name: development
description: Development principles to follow before delegating any implementation, fix, or deployment task.
---

# Development Principles

## Project Onboarding & Codebase Context

> **Required before delegating or implementing any task in an unfamiliar codebase.**

### AGENTS.md Check

1. **Check if `AGENTS.md` exists** in the project root before starting any task.
2. **If `AGENTS.md` exists**: read it fully — it is the authoritative guide to project
   conventions, tooling, and prescribed workflows. All task delegation must conform to it.
3. **If `AGENTS.md` does not exist**: call the `skill` tool with name `bootstrap` to
   generate it from the codebase before proceeding with any tasks. (`bootstrap` is a
   skill, invoked via the `skill` tool — not a subagent.) Do not skip or defer this
   step. `AGENTS.md` is a prerequisite for reliable, convention-aware task delegation.

### Codebase Context Gate

Before delegating any implementation, fix, or deployment task:

1. Use `tokensave` and `rtk` tools - if they are available - to read existing patterns, tooling conventions,
   and prescribed workflows in the current project.
2. Identify the established method for the task type in this codebase.
3. Cross-reference with memory — prior sessions may contain relevant project context (invoke `self-improvement` skill for instructions).
4. Delegate tasks **within** the established workflow.
   Never substitute an alternative approach because the prescribed one is failing.

> **A working result achieved by bypassing established project conventions is task
> FAILURE, not completion.** If the prescribed workflow cannot be made to work within
> retry limits, stop and report — do not invent workarounds.

## Commit Practices (Git)

When making changes on a Git repo, see [the commit practices guide](references/commit-practices.md) for details.

## Code Style Instructions

1. Before any task to work with the codebase, invoke the `clean-code` and `codebase-design` skills.
3. When designing new features, or writing code, see [the code style guide](references/code-style.md) for details.

## Edit Discipline

1. Perform precise and atomic code edits.
2. Prefer `tokensave` MCP tools if they are available in the project.

## Testing Instructions

Touch only related tests. Cover happy path and everything-on-fire path.

## Quality Gates

See [the quality gates guide](references/quality-gates.md) for details.
