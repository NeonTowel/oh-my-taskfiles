# Global Development Principles

## Code Quality Standards

@~/.config/opencode/shared/style-guide.md
@~/.config/opencode/shared/quality-gates.md

## Commit Practices

- Use conventional commits: `type(scope): description`
- Types: feat, fix, refactor, test, docs, chore
- Keep commits atomic and focused
- Use 'git commit -S ...' to trigger user interaction for SSH key commit signing.
- Never change global or local Git configuration.
- If Git commands produce any errors, stop immediately and ask the user for interaction.
- Do not push, pull or fetch.
- Do not create or delete branches or tags.
- Do not add co-authored or other attribution lines.

## Communication

- Ask clarifying questions when ambiguous
- Flag risks proactively (performance, security, breaking changes)
- Use TODO comments with context for deferred work

## Available agents

Use Workflow coordinator agent to coordinate, analyze and execute tasks.
