# Inbox Triage

The decision rules behind `process-inbox`. Every inbox item gets exactly one of four dispositions. When in doubt, ask: *would a reader ever want to link to this as its own thing?* If yes → it's a page (promote). If it's a fact or line that belongs on a page that should already exist → nugget. If it's one of many siblings → merge. If no one would miss it → discard.

## The four dispositions

### 1. Promote to source
The item is a first-class source that happens to be sitting in the inbox — a book, a substantial article, a talk transcript. It deserves its own summary page and the network of updates a real source triggers.

**Action:** copy the file into `sources/<category>/<title>.md` (infer the category — `books`, `articles`, `ia`, etc.), then run the `ingest` workflow on it: write a summary page, update/create the concept and person pages it touches, update index and log. The copy in `sources/` is now the immutable source of truth; the inbox copy is deleted.

**Signals:** many highlights (roughly 8+), a coherent thesis, an author you'd cite, content that already recurs across other captures.

### 2. Integrate as nugget
The item is a single idea, quote, statistic, or definition that belongs *inside* a page — usually a concept or person page that already exists or clearly should.

**Action:** append it to the most relevant page under the appropriate section, as a sentence or a short quote with attribution, and add a `[[wikilink]]` back to the person/source. Create the target concept page if it's missing but clearly warranted (a concept referenced across several captures). Do **not** spawn a dedicated page for the capture itself.

**Signals:** a thin article with one or two highlights; a single memorable tweet; a lone definition. Example: the article *1 Year of Event Sourcing and CQRS* carries one highlight ("a command is usually synchronous, an event asynchronous") → a nugget on an [[Event Sourcing]] or [[CQRS]] concept page, cited to the article — not its own summary page.

### 3. Batch-merge
Many small items share one source or one tight topic. Filing them separately would shatter the wiki into fragments.

**Action:** consolidate the group into **one** page. All highlights from one book → one book-summary page (this is really "promote" applied to a highlight collection). A person's tweet stream that's worth keeping → one page for that person's ideas, or distributed as nuggets across the concept pages they touch. Merge first, then delete every file in the group, logged together.

**Signals:** a whole `Books/<title>.md` of highlights; a `Tweets From <person>.md` thread; several clippings on the same event.

### 4. Discard
Nothing here earns a place in the wiki.

**Action:** delete, and record the reason in the disposition log (so the decision is auditable, never silent).

**Signals:** exact duplicates of already-processed content; pure logistics/noise; ephemeral chatter with no lasting idea. **Before discarding, rescue any user annotation** (see below) — discard the boilerplate, keep the original thought.

## Readwise playbook (this vault's inbox)

Readwise exports are the bulk of `inbox/`. They share a shape: an `# Title`, a cover image, a `## Metadata` block (`Author` as a `[[wikilink]]`, a `Category` tag like `#books`/`#articles`/`#tweets`, sometimes a `URL`), and a `## Highlights` list. Heuristics:

- **`Books/`** → almost always **promote / batch-merge**: one book-summary page in `wiki/`, source copied to `sources/books/`. Pull the thesis from the arc of the highlights; keep 3–6 of the sharpest as Notable Quotes.
- **`Articles/`** → **depends on depth**: a rich article promotes; a one-or-two-highlight article becomes a **nugget** on the concept it's about.
- **`Tweets/`** → usually **nugget or discard**. A thread carrying a real idea (e.g. a career/technical thread) → nuggets on the relevant person/concept page. Throwaway tweets → discard.
- **`Full Document Contents/`** → the full text behind a clipping; treat as an article (promote if substantial, else nugget), and dedupe against any matching Articles entry so the same piece isn't filed twice.

### Two Readwise gotchas
- **Re-export duplication:** Readwise appends a `## New highlights added <date>` section that repeats earlier highlights verbatim. Collapse these — dedupe within the file before you decide anything.
- **User annotations (`- Note:`):** sub-bullets under a highlight are the user's *own* words — connections, disagreements, "research this" flags. These are the single most valuable thing in the inbox and must never be discarded with the boilerplate. File them on the target page (a personal connection can live in a callout), or, when a Note asks a question, surface it to the user and consider logging it as a research thread. Content is often pt-BR — keep quotes and Notes in their original language; write your synthesis in the wiki's prevailing language.

## Disposition log format

Append one entry per batch to `wiki/log.md`, using the standard grep-parseable prefix. Account for **every** file in the batch.

```markdown
## [YYYY-MM-DD] process-inbox | <folder or batch label>

- Files processed: <count>
- Promoted → source: [[Book Summary Page]] (from Books/Title.md), ...
- Integrated → nugget: [[Concept Page]] ← Articles/Title.md, ...
- Merged: [[Page]] ← <n> items from Tweets/Person.md
- Discarded: <file> — <reason>, ...
- Notes rescued: <count> user annotations preserved
```

The `## [YYYY-MM-DD] process-inbox | ...` prefix matches the ingest/query/lint convention, so the whole log stays parseable and the dedupe check in step 1 keeps working on the next run.
