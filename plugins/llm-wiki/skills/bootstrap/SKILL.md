---
name: bootstrap
description: Scaffold a fresh LLM Wiki (Karpathy's pattern) in a new or empty folder — create the sources/, inbox/, and wiki/ structure, write the schema CLAUDE.md that turns Claude into a disciplined wiki maintainer, seed an empty index and log, and install the ingest / process-inbox / query / lint skill set. Use when the user says "set up a new LLM wiki", "scaffold a Karpathy-style wiki", "start a second brain / knowledge base here", "initialize an LLM wiki in this folder / vault", or wants to adopt the LLM-Wiki pattern somewhere new. This is the one-time setup step; day-to-day work then runs through ingest, process-inbox, query, and lint.
---

# Bootstrap

Stand up a working LLM Wiki so the pattern is portable to any folder or Obsidian vault. Karpathy's insight is that **the schema is everything** — a `CLAUDE.md` that encodes the structure and the operations is what turns a generic chatbot into a disciplined wiki maintainer. This skill lays that foundation, then hands off to the four operational skills.

## Before you build

Confirm two things with the user (briefly — don't over-interrogate):

1. **Target folder.** Default to the current working directory. If it's an existing Obsidian vault, build alongside its `.obsidian/`; if it's a plain folder, that's fine too.
2. **Not clobbering anything.** If `sources/`, `wiki/`, or `CLAUDE.md` already exist with content, stop and confirm before writing — the user may already have a wiki here. Bootstrapping is for empty or new targets.

## What to create

Assets live in [assets/](assets/); copy and fill them rather than composing from scratch.

1. **Folders:** `sources/`, `inbox/`, `wiki/`.
2. **Schema:** copy [assets/schema-CLAUDE.md](assets/schema-CLAUDE.md) to `<target>/CLAUDE.md`. This is the operating guide — architecture, the four operations, page conventions. Adjust the example `sources/` categories to the user's domain if they've named one (books, papers, meetings, research, etc.).
3. **Seed files:** copy [assets/wiki-index.md](assets/wiki-index.md) to `wiki/index.md` and [assets/wiki-log.md](assets/wiki-log.md) to `wiki/log.md`, replacing `<today>` with the current date.
4. **Skills:** ensure the operational skills exist under `<target>/.claude/skills/` — `ingest`, `process-inbox`, `query`, `lint`. If this bootstrap skill was installed as part of the LLM-Wiki set, copy its sibling skill folders in. If it's standalone, tell the user where to get them (the LLM-Wiki skill set) and what each does.

## After building

Show the user the resulting tree and explain the loop in one or two lines each:

- **Drop a source** into `sources/` (or hand over a URL) → run **ingest**.
- **Capture fleeting notes** into `inbox/` → run **process-inbox** to triage and clear them.
- **Ask questions** → run **query**; good answers get filed back as pages.
- **Periodically** → run **lint** to catch drift and surface what to research next.

Then offer to ingest their first source so the wiki isn't empty.

## Rules

- Don't overwrite an existing wiki or schema without explicit confirmation.
- Keep the created `CLAUDE.md` faithful to the pattern: `sources/` immutable, `wiki/` LLM-owned, `[[wikilinks]]` for internal links, the `## [YYYY-MM-DD] operation | title` log prefix. These conventions are what let ingest/process-inbox/query/lint interoperate.
