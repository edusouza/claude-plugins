# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this vault.

## What This Is

An Obsidian vault implementing Karpathy's **LLM Wiki** pattern. The LLM (you) builds and maintains the wiki. The user curates sources and asks questions; you do everything else — summarizing, cross-referencing, filing, and bookkeeping.

> "Obsidian is the IDE, the LLM is the programmer, the wiki is the codebase."

The key difference from RAG: the wiki is a **persistent, compounding artifact**. Knowledge is compiled once during ingestion and kept current — not re-derived on every query. Cross-references are already there. Contradictions already flagged. Synthesis already reflects everything read.

## Architecture

```
sources/   → Raw input — immutable, never edit these files
inbox/     → Fleeting captures — process and clear
wiki/      → LLM-generated knowledge pages (you own this layer)
CLAUDE.md  → This schema
```

`sources/` is organized by topic category (e.g., `sources/ai/`, `sources/books/`). Files here are the source of truth — **never modify them**.

`inbox/` is for quick captures and fleeting notes (highlights, clippings, exports) to be processed into wiki pages, then cleared.

`wiki/` contains all generated pages, plus two special files:

- **`wiki/index.md`** — content-oriented catalog of every wiki page: link, one-line summary, optional metadata, organized by category. Update on every ingest. Read this first when answering queries.
- **`wiki/log.md`** — append-only chronological record of all operations. Each entry uses the prefix `## [YYYY-MM-DD] <operation> | <title>`, which keeps it grep-parseable.

## Operations

The four operations are implemented as skills in `.claude/skills/`:

- **ingest** — process a curated source (a file in `sources/`, or a URL/path) into a summary page plus the entity/concept pages it touches; update index and log. A single source typically touches 5–15 pages.
- **process-inbox** — triage the `inbox/` backlog (promote / integrate as nugget / batch-merge / discard), then clear each file. The inbox-clearing counterpart to ingest.
- **query** — answer a question by searching and synthesizing the wiki with citations, then file good answers back as new pages so explorations compound.
- **lint** — health-check the wiki for contradictions, stale claims, orphans, missing pages, and weak cross-references, and suggest what to investigate next.

Read `wiki/index.md` first to find existing pages to update before creating new ones. Never summarize in isolation — always integrate into the existing network.

## Wiki Page Conventions

Use Obsidian Flavored Markdown with YAML frontmatter:

```yaml
---
title: Page Title
tags:
  - concept          # canonical set: concept, person, source-summary, framework, topic, index, query-synthesis
related:
  - "[[Linked Page]]"
updated: YYYY-MM-DD
---
```

- Use `[[wikilinks]]` for all internal links — never relative paths or bare filenames.
- Use Obsidian callouts (`> [!note]`, `> [!summary]`, `> [!warning]`) for key insights and caveats.
- Each wiki page should have a **Sources** section listing which `sources/` files contributed to it.
- Write for a reader who hasn't seen the source — synthesize, don't transcribe.
