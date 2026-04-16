# Global Development Principles

## Memory & Context

> **This section applies to all agents. Memory retrieval MUST happen before any task.**

This project uses the `memory` MCP server (`@modelcontextprotocol/server-memory`) as the
persistent knowledge graph across all sessions. Treat it as your primary source of user
and project context — always prefer recalled memory over assumptions.

### Session Start Protocol

At the start of every interaction:

1. Say only `"Remembering..."` and invoke the `memory` MCP tools to retrieve all
   entities and observations relevant to the current user and project context.
2. Assume you are interacting with `default_user` unless memory identifies otherwise.
   If `default_user` has not yet been identified, proactively ask for identification
   and store the result immediately.
3. Always refer to the knowledge graph as your "memory" when communicating with the user.

### What to Remember

While conversing, capture new information in these categories:

- **Identity** — name, location, role, education, seniority
- **Behaviors** — habits, workflows, tooling preferences
- **Preferences** — communication style, language, output format
- **Goals** — current targets, project objectives, aspirations
- **Relationships** — professional and personal connections (up to 3 degrees)

### Memory Update Protocol

After each interaction where new information was gathered:

1. Create entities for recurring people, organizations, and significant events
2. Connect new entities to existing ones using typed relations
3. Store discrete facts as observations on the relevant entity
4. Update existing observations if they have changed — do not duplicate

***

## Project Onboarding & Codebase Context

> **Required before delegating or implementing any task in an unfamiliar codebase.**

### AGENTS.md Check

1. **Check if `AGENTS.md` exists** in the project root before starting any task.
2. **If `AGENTS.md` exists**: read it fully — it is the authoritative guide to project
   conventions, tooling, and prescribed workflows. All task delegation must conform to it.
3. **If `AGENTS.md` does not exist**: invoke the `@bootstrap` skill to generate it from
   the codebase before proceeding with any tasks. Do not skip or defer this step.
   `AGENTS.md` is a prerequisite for reliable, convention-aware task delegation.

### Codebase Context Gate

Before delegating any implementation, fix, or deployment task:

1. Use `grep`, `file`, and `git` tools to read existing patterns, tooling conventions,
   and prescribed workflows in the current project.
2. Identify the established method for the task type in this codebase.
3. Cross-reference with memory — prior sessions may contain relevant project context.
4. Delegate tasks **within** the established workflow.
   Never substitute an alternative approach because the prescribed one is failing.

> **A working result achieved by bypassing established project conventions is task
> FAILURE, not completion.** If the prescribed workflow cannot be made to work within
> retry limits, stop and report — do not invent workarounds.

***

## Code Quality Standards

@~/.config/opencode/shared/style-guide.md
@~/.config/opencode/shared/quality-gates.md

***

## Commit Practices

- Use conventional commits: `type(scope): description`
- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
- Keep commits atomic and focused
- Use `git commit -S ...` to trigger user interaction for SSH key commit signing
- Never change global or local Git configuration
- If Git commands produce any errors, stop immediately and ask the user for guidance
- Do not push, pull, or fetch
- Do not create or delete branches or tags
- Do not add co-authored or other attribution lines

***

## Communication

- Ask clarifying questions when ambiguous
- Flag risks proactively (performance, security, breaking changes)
- Use `TODO` comments with context for deferred work
- Prefer direct, specific language — avoid filler phrases and generic reassurances
