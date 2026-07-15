# Wiki Page Formats

## Summary page

Path: `wiki/<kebab-case-title>.md`

```yaml
---
title: "<Title>"
tags:
  - source-summary
related:
  - "[[Concept Page]]"
  - "[[Person Page]]"
source: "[[sources/category/filename]]"
updated: <today>
---
```

Sections:
- **Overview** — 2–3 sentence synthesis of the main idea
- **Key Points** — bullet list of the most important takeaways
- **Connections** — `[[wikilinks]]` to related wiki pages, one sentence each explaining the connection
- **Notable Quotes** — 1–3 direct quotes that capture something essential (optional)

## Entity / concept page

Use for people, frameworks, concepts that appear across multiple sources.

```yaml
---
title: "<Entity Name>"
tags:
  - concept    # or: person, framework, topic
related:
  - "[[Related Page]]"
updated: <today>
---
```

Sections:
- Brief description (2–3 sentences)
- **Key ideas** (concepts) or **Background** (people)
- **Sources** — list of `[[source summary pages]]` that reference this entity

## index.md

One entry per wiki page, grouped by category:

```markdown
## Source Summaries
- [[Page Title]] — one-line summary

## Concepts
- [[Concept Name]] — one-line summary

## People
- [[Person Name]] — one-line summary
```

## log.md

Append-only. Each entry must use this exact prefix format so it is grep-parseable:

```markdown
## [YYYY-MM-DD] ingest | <Source Title>

- Summary page: [[wiki page name]]
- Pages updated: [[page1]], [[page2]], ...
- Pages created: [[page3]], ...
```
