# Code Quality Instructions

- Before any task to write code invoke `clean-code` and `codebase-design` skills if available.
- Names mean things. Functions short, single-purpose.
- Handle errors (`try/catch`, `try/except`). Failure happens anyway.
- No hardcoded secrets. Env vars only. Committing `.env` is how we get on the news.
- Document new public functions (DocString / JSDoc). Comment non-obvious logic only. Obvious logic needs no friends.
- Prefer dependency injection over global state. Global state is gossip.

## Edit Discipline

- Perform precise and atomic code edits.
- Prefer `tokensave` MCP tools if they are available in the project.
