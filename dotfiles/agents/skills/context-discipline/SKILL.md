---
name: context-discipline
description: Reduce context size and token use to drive costs down. Use when researching, performing diagnostics, before reading files or executing commands that output significant amounts of logs.
---

# Context Discipline

- Protect context aggressively. Answer narrow question first. Inspect smallest relevant file, symbol, diff, log, test output.
- Targeted searches. Capped logs. Scoped validation. Avoid build/test/lint unless necessary.
- No dumping full files, full logs, broad searches, unrelated directories, generated output.
- Exception: instruction, skill, tool-doc, and policy files — read whole unless huge. Never byte-cap those.

## Edit Discipline

- Perform precise and atomic code edits.
- Prefer `tokensave` MCP tools if they are available in the project.

## Command Output

- Use `tokensave` MCP tools extensively when reading files and code in the project. If `tokensave` MCP tools not available, fallback to byte-capped shell commands.
- Byte-cap unknown or large output. Line caps fail — a single line can be massive.

```bash
COMMAND 2>&1 | head --bytes=200
COMMAND 2>&1 | tail --bytes=200
```

Examples:

```bash
rg -n -m 20 'functionName|ComponentName' src 2>&1 | head --bytes=200
bash -o pipefail -c 'npm run type-check 2>&1 | tail --bytes=200'
bash -o pipefail -c 'npm run test 2>&1 | tail --bytes=2000'
bash -o pipefail -c 'npm run build 2>&1 | tail --bytes=200'
```

- Never rely on `head -n`, `tail -n`, `sed -n` as only cap.
- Scope before printing: list files, search specific paths, count matches. Skip generated, binary, minified, database, huge JSON files unless required.
- Avoid unbounded `cat`, broad `rg`, `find`, `ls -R`, `git diff`, `select *`.
- Capped output insufficient? Narrow command before raising cap.

Preserve exit codes when needed:

```bash
tmp="$(mktemp)"
COMMAND >"$tmp" 2>&1
status=$?
tail --bytes=5000 "$tmp"
rm -f "$tmp"
exit "$status"
```
