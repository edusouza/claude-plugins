# llm-wiki

Andrej Karpathy's **LLM-Wiki** pattern as a plugin: a folder of `sources/`, `inbox/`, and `wiki/`
governed by a schema `CLAUDE.md`, which turns Claude into a disciplined wiki maintainer rather than a
chatbot. Sources go in, cross-linked wiki pages come out, and the maintenance work humans abandon —
triaging the capture backlog, fixing broken links, spotting gaps — the LLM doesn't get bored doing.

The five skills cross-reference each other as one interoperating system, so they ship as a single plugin.

| Skill | What it does | Trigger |
|-------|--------------|---------|
| `bootstrap` | One-time setup. Scaffolds `sources/`, `inbox/`, and `wiki/`, writes the schema `CLAUDE.md` that encodes the structure and operations, and seeds an empty index and log. | "set up a new LLM wiki", "scaffold a Karpathy-style wiki", "start a second brain here" |
| `ingest` | Turns **curated** sources into wiki pages — a summary page plus entity/concept pages and cross-references (a single source typically touches 5–15 pages). No args = batch-scan `sources/`; a path or URL = ingest that one interactively. | "ingest", "process sources", "add this to the wiki", or handing over a URL/file |
| `process-inbox` | Triages the `inbox/` backlog of **fleeting** captures (Readwise highlights, tweet/article exports, clippings). Picks a disposition per item — promote to source, integrate as a nugget, batch-merge, or discard — and deletes the file only after the content is safely integrated. | "process my inbox", "sort my Readwise highlights into the wiki", "empty inbox/" |
| `query` | Answers questions from the wiki with citations, then optionally files the answer back as a new page so explorations compound. | "what does my wiki say about X", comparing or connecting topics |
| `lint` | Audits `wiki/` for structural and content drift, and suggests what to research next. | "lint", "audit the wiki", "what's broken", "what should I research next" |

`bootstrap` is the setup step; day-to-day work runs through the other four.

**`ingest` vs `process-inbox`:** curated material you deliberately chose → `ingest`. Whatever piled up in
`inbox/` → `process-inbox`, which only promotes the substantial items back through the ingest workflow.

## Install
```bash
/plugin install llm-wiki@edusouza-plugins
```

## Dependencies
- Read/write file tools only. No external services, no API keys, no scripts on `PATH`.
- The wiki is a plain folder of Markdown — it works standalone or inside an Obsidian vault.

## License

MIT
