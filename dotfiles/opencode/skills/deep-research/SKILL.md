---
name: deep-research
description: Universal web research and company/code intel. Uses MCPs (like Exa or Firecrawl) to search the web, analyze companies, fetch code context, and synthesize findings.
origin: ECC
---

# Universal Research Skill

Produce thorough, cited research reports from multiple web sources.

## When to Activate

- User asks to research any topic in depth (web search, news, etc.)
- Competitive analysis, technology evaluation, or market sizing
- Due diligence on companies, investors, or technologies
- Searching for code examples, API docs, or technical references
- Finding professional profiles
- User says "search for", "look up", "investigate", or "deep dive"

## Tool Selection (MCPs)

Check your available MCP tools.
- **Exa** (`web_search_exa`, `get_code_context_exa`, `company_research_exa`): Best for neural search, code snippets, company intelligence, and people lookups.
- **Firecrawl** (`firecrawl_search`, `firecrawl_scrape`): Best for crawling specific domains, extracting markdown from URLs, and general structured scraping.
- **Combined**: Use Exa to find the best URLs, and Firecrawl to scrape their full content if Exa's token limits are too restrictive.

If neither is available, inform the user that deep research capabilities are limited, and fall back to standard web search tools if provided.

## Workflow

### Step 1: Understand the Goal
Determine if the goal is learning, code implementation, or business research. Break the topic into 3-5 sub-questions.

### Step 2: Execute Search
**For Code/Technical:**
`get_code_context_exa(query: "TypeScript HonoJS Cloudflare patterns", tokensNum: 3000)`

**For Business/Company:**
`company_research_exa(companyName: "Cloudflare", numResults: 5)`

**For General Web/News:**
`web_search_exa(query: "latest Svelte 5 features", numResults: 5)` OR `firecrawl_search(query: "Svelte 5 release notes")`

### Step 3: Deep-Read Key Sources
For the most promising URLs, fetch the full content:
`crawling_exa(url: "<url>")` OR `firecrawl_scrape(url: "<url>")`

### Step 4: Synthesize and Write Report
Structure the report with an Executive Summary, Major Themes, Key Takeaways, and Cited Sources.
Every claim needs a source. Separate facts from inferences.

## Parallel Research
For broad topics, use your agent's subagent or task delegation capabilities to parallelize research across multiple agents, then synthesize the final report.