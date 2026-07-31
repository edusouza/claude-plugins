---
name: query
description: Answer questions by searching and synthesizing the LLM Wiki, then optionally file the answer back as a new wiki page so explorations compound. Use when the user asks a question about their knowledge base, wants to compare or analyze topics across sources, asks "what does my wiki say about X", or wants to explore connections between ideas.
---

# Query

Search the wiki, synthesize an answer with citations, then decide whether the answer is worth filing back as a new wiki page.

## Workflow

### 1. Search

Read `wiki/index.md` to find pages relevant to the question. Drill into the 3–10 most relevant pages. Follow `[[wikilinks]]` when a page references another that's likely relevant.

### 2. Synthesize

Answer the question from the wiki's accumulated knowledge. Always cite the wiki pages you drew from (use `[[wikilinks]]`). Where the wiki has gaps, say so explicitly rather than drawing on outside knowledge.

### 3. Choose output format

Match format to the question type:

| Question type | Format |
|---|---|
| Conceptual / explanatory | Inline markdown response |
| Comparison across sources | Markdown table |
| Multi-topic overview | Structured markdown page |
| Visual relationships | JSON Canvas (`.canvas`) |
| Presentation | Marp slide deck |

Default to inline response unless another format serves the answer better.

### 4. File back (if valuable)

Karpathy: *"Good answers can be filed back into the wiki as new pages. A comparison you asked for, an analysis, a connection you discovered — these are valuable and shouldn't disappear into chat history."*

File the answer back when it:
- Synthesizes across multiple sources in a way that took real work to produce
- Surfaces a connection that isn't captured anywhere in the wiki yet
- Would be useful to answer a similar question in the future

If filing back: save to `wiki/<kebab-case-title>.md` with frontmatter (`title`, `tags: [query-synthesis]`, `updated`), add to `wiki/index.md`, and append to `wiki/log.md`.

If not filing back: explain briefly why (e.g., too ephemeral, already covered).

### 5. Log

Append to `wiki/log.md`:

```markdown
## [<today>] query | <question summary>

- Pages consulted: [[page1]], [[page2]], ...
- Filed back: [[new page]] / no
```

## Rules

- Answers should reflect what the wiki actually contains — don't silently supplement with outside knowledge. If the wiki doesn't have enough, say so and suggest what source to ingest next.
- Filing back is the norm for substantial queries, not the exception. Explorations should compound.
