---
name: bootstrap
description: Smart repo bootstrapping for Agentic flow (AGENTS.md)
---

Please analyze this codebase and create an `AGENTS.md` file, which will be given to future instances of this AI coding agent (e.g., any AI coding assistant) a simple set of rules to operate in this project.

What to add:

1. Commands that will be commonly used, such as how to build, lint, and run tests. Include the necessary commands to develop in this codebase, such as how to run a single test.
2. High-level code architecture and structure so that future instances can be productive more quickly. Focus on the "big picture" architecture that requires reading multiple files to understand
3. Identify if Go-task (`taskfile.yaml`) is used and document `task` commands instead of direct package manager calls. If a package manager is needed, emphasize `bun` as the default package manager instead of npm or yarn.

Usage notes:

- If there's already an `AGENTS.md`, suggest improvements to it vs creating a new file.
- When you make the initial `AGENTS.md` do not repeat yourself and do not include obvious instructions like "Provide helpful error messages to users", "Write unit tests for all new utilities", "Never include sensitive information (API keys, tokens) in code or commits"
- Avoid listing every component or file structure that can be easily discovered
- Don't include generic development practices
- If there are existing AI assistant rules (e.g., in .cursorrules, .github/copilot-instructions.md), AGENTS.md, or similar context files, make sure to include the important parts.
- If there is a README.md, PROJECT.md, make sure to include the important parts.
- Do not make up information such as "Common Development Tasks", "Tips for Development", "Support and Documentation" unless this is expressly included in other files that you read.
- Be sure to prefix the generated `AGENTS.md` file with the following text:

```text
This file provides guidance to AI coding agents and assistants when working with code in this repository.
```

Best practices:

- Good rules are focused, actionable, and scoped.
- Keep rules under 500 lines
- Avoid vague guidance. Write rules like clear internal docs
- Reuse rules when repeating prompts in chat
