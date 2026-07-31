---
name: ingest
description: Process curated sources into the LLM Wiki. With no arguments, scans sources/ for all unprocessed files and ingests them in batch (non-interactive). With a file path or URL, ingests a single source interactively — showing the summary and discussing key takeaways before writing. Use when the user says "ingest", "process sources", "add this to the wiki", or provides a URL or file to add to the knowledge base. This skill is for curated sources in sources/ or a specific file/URL handed over — for the inbox/ backlog of fleeting captures (Readwise highlights, tweet/clipping exports, quick notes), use the process-inbox skill instead.
---

# Ingest

Reads sources, integrates knowledge into the wiki (summary page + entity/concept pages + cross-references), updates `wiki/index.md`, and logs to `wiki/log.md`. A single source typically touches 5–15 wiki pages.

This skill is for **curated sources** — a file in `sources/`, or a URL/path the user hands over. For the `inbox/` backlog of fleeting captures (Readwise highlights, tweet/clipping exports), use the `process-inbox` skill instead; it triages those and only promotes the substantial ones back through this workflow.

See [page-format.md](references/page-format.md) for all page templates and log format.

## Modes

**Single (interactive):** User provides a file path or URL. After extracting key takeaways, share them with the user and let them guide emphasis before writing. Karpathy: *"I prefer to ingest sources one at a time and stay involved — I read the summaries, check the updates, and guide the LLM on what to emphasize."*

**Batch (non-interactive):** No argument given. Scan `sources/` for all unprocessed files and process them one by one without stopping to ask questions. Report a summary at the end.

## Detecting unprocessed files

A source is unprocessed if `wiki/log.md` has no ingest entry matching its title or filename. List all `.md` files under `sources/` recursively, cross-reference against `wiki/log.md`, and collect the unprocessed set before starting.

## Per-source workflow

### 1. Fetch (URL only)

```bash
defuddle parse <url> --md
```

Save to `sources/<category>/<title>.md` with frontmatter (`title`, `source`, `author`, `published`, `created`, `tags: [clippings]`). Infer category from content; create the subfolder if needed.

### 2. Orient

Read `wiki/index.md` to find related existing pages. In batch mode, re-read it between sources to pick up pages created during the run.

### 3. Extract and (single mode) discuss

Identify: main thesis, key concepts and frameworks, people mentioned, claims that confirm or challenge existing wiki pages, connections to already-ingested sources.

In single mode: share these takeaways with the user before writing. Adjust emphasis based on their response.

### 4. Write

- Create the summary page in `wiki/`.
- For each significant person, concept, or framework: update its existing wiki page, or create one if it doesn't exist.
- Use `[[wikilinks]]` for every internal reference — never relative paths.
- Prefer updating existing pages over creating new ones.

### 5. Update index and log

- Add the summary page to `wiki/index.md` under the right category.
- Append an entry to `wiki/log.md` using the format in [page-format.md](references/page-format.md).
- Create either file if it doesn't exist yet.

## After batch completes

Report: sources processed, pages created (by type), pages updated, notable cross-connections found across sources.

## Rules

- **Never modify files in `sources/`.** Immutable source of truth.
- Always read `wiki/index.md` before writing — integrate into the existing network, never summarize in isolation.
- All internal links must be `[[wikilinks]]`.
