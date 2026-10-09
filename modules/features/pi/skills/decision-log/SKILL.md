---
name: decision-log
description: Capture architectural or product decisions as durable decision records. Use when a plan includes tradeoffs, when the user says decision log/ADR/record this, or after choosing between meaningful alternatives.
allowed-tools: Read Bash Grep Glob Edit Write
---

# Decision Log

Use this skill to create or update a durable decision record for architectural, product, workflow, or implementation choices.

Default posture: **record the decision, context, and consequences**. Do not over-formalize trivial choices.

## When to Use

Use for decisions that are likely to matter later:

- API/data model choices
- UI behavior and interaction patterns
- Persistence/cache/migration strategies
- Build/tooling/workflow conventions
- Security/performance tradeoffs
- “We considered X but chose Y” moments

Skip for small local implementation details that are obvious from code.

## Find the Repository Convention

Before writing a new file:

1. Search for existing decision records:
   ```bash
   find . -iname '*decision*' -o -iname '*adr*'
   ```
2. Look for directories like:
   - `docs/decisions/`
   - `docs/adr/`
   - `adr/`
   - `architecture/decisions/`
3. Match the existing numbering, filename, and template if one exists.

If no convention exists, ask the user where to put the record. If the user wants a default, use:

```text
docs/decisions/YYYY-MM-DD-short-slug.md
```

## Record Template

Use this template unless the repo has its own:

```markdown
# <Decision title>

Date: YYYY-MM-DD
Status: Proposed | Accepted | Superseded

## Context

What problem are we solving? What constraints, prior decisions, or facts matter?

## Decision

What did we decide?

## Rationale

Why this option? What makes it better for this situation?

## Alternatives considered

- Option A: why not
- Option B: why not

## Consequences

Positive and negative consequences, including migration/rollout/test implications.

## Follow-ups

- [ ] Concrete next action, if any
```

## Writing Guidance

- Keep it factual and concise.
- Include enough context that a future reader can understand without reading the whole chat.
- Separate the decision from the rationale.
- Capture rejected alternatives fairly.
- List consequences honestly, including risks and tradeoffs.
- If the decision is not final, set `Status: Proposed` and list what would make it accepted.

## Updating Existing Decisions

If a decision supersedes another:

- Update the old record status to `Superseded` if appropriate.
- Link both records.
- Do not silently rewrite history; preserve the old context unless it was incorrect.
