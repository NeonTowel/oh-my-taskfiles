# Extract Skill from Learnings

When a substantial learning is extracted as a skill, it becomes a new agentic skill in the project root:

**File**: `.agents/skills/skill-name/SKILL.md`

## Setup

Create `.agents/skills` directory in project root if it doesn't exist:

```bash
mkdir -p .agents/skills
```

Create new skill folder and `SKILL.md` using the following template instructions.

## SKILL.md template

Template for creating skills extracted from learnings.

```markdown
---
name: skill-name-here
description: "Concise description of when and why to use this skill. Include trigger conditions."
---

# Skill Name

Brief introduction explaining the problem this skill solves and its origin.

## Quick Reference

| Situation   | Action     |
| ----------- | ---------- |
| [Trigger 1] | [Action 1] |
| [Trigger 2] | [Action 2] |

## Background

Why this knowledge matters. What problems it prevents. Context from the original learning.

## Solution

### Step-by-Step

1. First step with code or command
2. Second step
3. Verification step

### Code Example

\`\`\`language
// Example code demonstrating the solution
\`\`\`

## Common Variations

- **Variation A**: Description and how to handle
- **Variation B**: Description and how to handle

## Gotchas

- Warning or common mistake #1
- Warning or common mistake #2

## Related

- Link to related documentation
- Link to related skill

## Source

Extracted from learning entry.

- **Learning ID**: LRN-YYYYMMDD-XXX
- **Original Category**: correction | insight | knowledge_gap | best_practice
- **Extraction Date**: YYYY-MM-DD
```

---

## Minimal Template

For simple skills that don't need all sections:

```markdown
---
name: skill-name-here
description: "What this skill does and when to use it."
---

# Skill Name

[Problem statement in one sentence]

## Solution

[Direct solution with code/commands]

## Source

- Learning ID: LRN-YYYYMMDD-XXX
```

---

## Template with Scripts (taskfiles)

For skills that include executable helpers as `go-task` taskfiles:

```markdown
---
name: skill-name-here
description: "What this skill does and when to use it."
---

# Skill Name

[Introduction]

## Quick Reference

| Command                     | Purpose        |
| --------------------------- | -------------- |
| `./taskfiles/taskfile.yaml` | [What it does] |

## Usage

### Automated (Recommended)

\`\`\`bash
task -f .agents/skills/skill-name/taskfiles/taskfile.yaml [task] [args]
\`\`\`

### Manual Steps

1. Step one
2. Step two

## Taskfiles

| Script                    | Description   |
| ------------------------- | ------------- |
| `taskfiles/taskfile.yaml` | Main taskfile |

## Source

- Learning ID: LRN-YYYYMMDD-XXX
```

**NOTE:** One taskfile should contain all the utility tasks, should the skill need one. Write cross-platform POSIX-safe bash-like scripts as tasks in the taskfile. The go-task has its own shell interpreter. Prefer `go-task` built-in features over complex inline scripts. Optional arguments to tasks can be provided using `ARG=value` syntax after ARG is defined as variable for the task.

---

## Naming Conventions

- **Skill name**: lowercase, hyphens for spaces
  - Good: `docker-m1-fixes`, `api-timeout-patterns`
  - Bad: `Docker_M1_Fixes`, `APITimeoutPatterns`

- **Description**: Start with action verb, mention trigger
  - Good: "Handles Docker build failures on Apple Silicon. Use when builds fail with platform mismatch."
  - Bad: "Docker stuff"

- **Files**:
  - `SKILL.md` - Required, main documentation
  - `scripts/` - Optional, executable code
  - `references/` - Optional, detailed docs
  - `assets/` - Optional, templates

---

## Extraction Checklist

Before creating a skill from a learning:

- [ ] Learning is verified (status: resolved)
- [ ] Solution is broadly applicable (not one-off)
- [ ] Content is complete (has all needed context)
- [ ] Name follows conventions
- [ ] Description is concise but informative
- [ ] Quick Reference table is actionable
- [ ] Code examples are tested
- [ ] Source learning ID is recorded

After creating:

- [ ] Update original learning with `promoted_to_skill` status
- [ ] Add `Skill-Path: .agents/skills/skill-name` to learning metadata
- [ ] Test skill by reading it in a fresh session
