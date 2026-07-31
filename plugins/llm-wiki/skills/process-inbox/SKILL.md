---
name: process-inbox
description: Triage the inbox/ backlog of fleeting captures (Readwise highlights, book/article/tweet exports, quick notes, web clippings) into the LLM Wiki, then clear each file. For each item it picks a disposition — promote to a source, integrate as a nugget into existing pages, batch-merge many small items into one page, or discard — and only deletes the inbox file after the content is safely integrated. Use whenever the user says "process my inbox", "clear the inbox", "sort my Readwise notes / highlights into the wiki", "what's in my inbox and what should happen to it", "empty inbox/", or drops a pile of captures to be filed. This is the inbox-clearing counterpart to `ingest` (which handles curated sources in sources/) — if the material lives in inbox/, reach for this skill, not ingest.
---

# Process Inbox

`inbox/` is where fleeting captures land — Readwise highlights, book/article/tweet exports, quick notes, web clippings. Left alone it only grows. This skill is the maintenance muscle Karpathy says humans abandon but the LLM doesn't get bored doing: read each capture, decide its fate, fold the worthwhile content into the wiki's existing network, and clear the file. Nothing valuable is lost; noise doesn't accumulate.

See [inbox-triage.md](references/inbox-triage.md) for the full disposition taxonomy, the Readwise-specific playbook, and the disposition-log format. Read it before your first classification.

## Process inbox vs. ingest

Both add knowledge to the wiki, so be deliberate about which one applies:

| | `ingest` | `process-inbox` (this skill) |
|---|---|---|
| Input | A curated source in `sources/`, or a URL/path the user hands you | The `inbox/` pile of low-ceremony captures |
| Ceremony | Each source gets its own summary page | Most items become nuggets or merges; only substantial ones get a page |
| The file after | `sources/` is immutable — kept forever | The inbox file is fleeting — **deleted** once integrated |

If the material is already in `inbox/`, this skill owns it. When an inbox item turns out to deserve first-class treatment, this skill *promotes* it into `sources/` and then runs the ingest workflow on it — so the two compose rather than compete.

## Modes

- **Dry-run (classify-only):** report each item's proposed disposition and target pages, writing and deleting nothing. This is the right response to "what's in my inbox and what should happen to each thing?" — it lets the user steer before anything changes.
- **Interactive (sample):** a named file or a small batch. Show your classification decisions, integrate on confirmation.
- **Batch:** the whole inbox or a named subfolder (e.g. "process the Books folder"). Work autonomously folder-by-folder and report a disposition summary at the end.

Default to dry-run when the inbox is large and the user hasn't clearly asked you to just do it — a 500-file inbox is worth a look before you touch it.

## Workflow

### 1. Orient

Read `wiki/index.md` for the current page map and `wiki/log.md` for what's already been processed. Both `ingest` and prior `process-inbox` runs log here, so this is also your **dedupe check**: skip any inbox file already recorded in a prior `process-inbox` log entry. Key this on the *file* recorded in the log, not on whether a page exists — the log captures every file's fate (promoted / integrated / merged / discarded), so this catches nuggets and merges too, which never get their own page. In batch mode, re-read `index.md` between groups to pick up pages you just created.

### 2. Survey and group

List the inbox files (skip any `inbox/_processed/` archive — those are already done). **Group before you classify** — many captures belong together (all highlights from one book, a person's whole tweet stream). Handling a group as a unit is what prevents 40 fragment pages. Within a single Readwise file, collapse the duplicate `## New highlights added <date>` re-export sections so you don't file the same highlight twice.

### 3. Classify

Give every item exactly one disposition (details and examples in [inbox-triage.md](references/inbox-triage.md)):

1. **Promote to source** — substantial enough to stand alone (a book, a rich article). Copy the file into `sources/<category>/`, then run the ingest workflow: a dedicated summary page plus updates to the entity/concept pages it touches.
2. **Integrate as nugget** — a highlight, quote, or idea that belongs *inside* an existing page. Append it to the relevant concept/person/source page and add cross-links. No new page.
3. **Batch-merge** — many small related items → consolidate into **one** page rather than N fragments.
4. **Discard** — noise, exact duplicates, or nothing wiki-worthy. Delete, with the reason logged.

**Never discard the user's own annotations.** In Readwise files these are the `- Note:` sub-bullets — original thinking, personal connections, "research this" flags. They are the highest-value content in the pile. Preserve them on the target page (or as a flagged research thread), even when you discard the surrounding boilerplate.

### 4. Integrate

Write the changes per disposition, following the wiki's page conventions — the same summary and entity/concept page formats `ingest` uses (frontmatter with `title`/`tags`/`related`/`updated`, `[[wikilinks]]` for every internal link, an Obsidian callout for a key caveat). Prefer updating an existing page over creating a new one. Keep quotes in their original language; write synthesis in the wiki's prevailing language.

### 5. Log, then clear

Once a batch's items are integrated, **write the disposition-log entry before deleting the files** — append one entry per batch to `wiki/log.md` (format in [inbox-triage.md](references/inbox-triage.md)) recording every file's fate, add any new pages to `wiki/index.md`, and only then delete the batch's inbox files. Logging before deleting means an interruption can never leave a deleted file with no record of where it went — the worst case is a file that's already integrated but not yet deleted, which the dedupe check in step 1 skips on the next run.

## Rules

- **Integrate, then log, then delete** — in that order — and never drop a file silently: every inbox file must appear in the disposition log as promoted / integrated / merged / discarded before it's removed. Logging ahead of deletion is what makes a bulk clear-out recoverable.
- **Dedupe against `wiki/log.md`** (keyed on the recorded file, per step 1) so a re-run never reprocesses or double-files anything.
- **Never modify `sources/`** except to *add* a promoted file. Existing sources are immutable.
- **Bound the work.** For a large inbox, go folder-by-folder in reviewable batches and report progress; don't try to swallow 500 files in one silent pass. (This is naturally parallelizable across groups, but the instructions here stay execution-agnostic.)
- If the user prefers an archive over deletion, move cleared files to `inbox/_processed/` instead — but the default, per the vault schema, is delete.
