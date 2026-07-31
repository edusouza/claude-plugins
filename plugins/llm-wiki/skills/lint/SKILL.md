---
name: lint
description: Health-check the LLM Wiki. Audits wiki/ for structural and content issues, then suggests what to investigate next. Use when the user says "lint", "health check the wiki", "audit the wiki", "what's broken", or "what should I research next".
---

# Lint

Periodically audit the wiki to keep it healthy as it grows. The goal is twofold: fix structural problems and surface what to do next.

## Workflow

### 1. Orient

Read `wiki/index.md` to get the full map of pages. Read `wiki/log.md` to understand what has recently changed — `ingest`, `process-inbox`, and `query` all log here, and any of them can introduce a fresh claim that contradicts or supersedes an older page. This informs stale-claim and contradiction checks.

### 2. Audit

Work through each check category below. Read pages as needed — follow links when checking contradictions or missing cross-references.

**Structural checks** (mechanical — identify all instances):
- **Broken wikilinks** — `[[links]]` whose target page doesn't exist in `wiki/`
- **Orphan pages** — wiki pages with no inbound links from other *content* pages. Ignore links from `index.md` and `log.md` when judging this: both link to nearly every page by design, so counting them would hide every orphan.
- **Missing frontmatter** — pages lacking required YAML fields (`title`, `tags`, `related`, `updated`; summary pages also need `source`)

**Content checks** (judgment — flag the most significant instances):
- **Contradictions** — pages on the same topic making conflicting claims
- **Stale claims** — assertions on older pages superseded by content from more recently ingested sources
- **Missing concept pages** — entities (people, frameworks, topics) mentioned across multiple pages but lacking their own dedicated page
- **Weak cross-references** — related pages that don't link to each other but clearly should

**Forward-looking checks** (generative — think beyond what's already there):
- **Data gaps** — important questions the wiki touches on but can't answer from current sources
- **Suggested sources** — specific articles, papers, or resources worth ingesting to fill those gaps
- **Research threads** — questions worth exploring that the current wiki suggests but doesn't resolve

### 3. Report

Present findings grouped by category. For each issue include: the affected page(s), what the problem is, and what to do about it.

Use this structure:

```
## Structural Issues
[broken links, orphans, missing frontmatter — be exhaustive]

## Content Issues
[contradictions, stale claims, missing pages, weak links — top findings only]

## What to Do Next
[data gaps, suggested sources, open research threads]
```

For "What to Do Next," be specific: name the gap, suggest a concrete source or search query, and explain what it would add to the wiki.

### 4. Log

Append to `wiki/log.md`:

```markdown
## [<today>] lint | wiki health check

- Pages audited: <count>
- Issues found: <brief summary>
- Top suggestions: <1–3 bullet points>
```

## Rules

- Don't fix issues automatically — report them and let the user decide what to act on.
- Structural issues: be exhaustive. Content issues: prioritize the most impactful findings, not every minor gap.
- The "What to Do Next" section is as valuable as the bug report — Karpathy: *"The LLM is good at suggesting new questions to investigate and new sources to look for."*
