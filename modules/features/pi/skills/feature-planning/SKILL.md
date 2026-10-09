---
name: feature-planning
description: Create an implementation plan before non-trivial feature work or refactors. Use when the user asks to plan, sketch, scope, design, or start a feature; especially when multiple files, data flow, UI states, APIs, tests, or migration risks are involved.
allowed-tools: Read Bash Grep Glob Edit Write
---

# Feature Planning

Use this skill before implementing a non-trivial feature, refactor, or product change.

Default posture: **plan first, do not code yet**. If the user explicitly asks to both plan and implement, finish the plan, call out assumptions, then proceed only after the plan is clear enough to act on.

## Workflow

1. **Clarify the goal**
   - Restate the feature in one or two sentences.
   - Capture success criteria and non-goals.
   - Ask only the questions that materially change the design; otherwise list assumptions and continue.

2. **Map the existing system**
   - Read project instructions (`AGENTS.md`, `CLAUDE.md`, README, package files) when relevant.
   - Search for existing implementations, analogous components, data models, tests, and naming conventions.
   - Prefer reusing existing patterns over inventing new ones.

3. **Identify affected surfaces**
   - Data model / schema / API / generated clients.
   - State management and cache invalidation.
   - UI components, keyboard/accessibility behavior, loading/empty/error states.
   - Tests and validation commands.
   - Migration, rollout, and backwards compatibility concerns.

4. **Propose a design**
   - Include the smallest viable design first.
   - Note alternatives considered and why they were rejected.
   - Split risky work into phases.
   - Call out dependencies and assumptions.

5. **Create an implementation plan**
   - Ordered steps, each small enough to review.
   - For each step, list files likely to change and the validation for that step.
   - Include explicit stop points where the user may want to review before continuing.

6. **Validation plan**
   - List the targeted commands/tests to run.
   - If commands are expensive or environment-dependent, identify the minimal useful subset and what remains unverified.

## Output Format

Use this structure unless the user asks for a different format:

```markdown
## Goal

## Current system notes

## Proposed approach

## Phased plan

1. ...
2. ...

## Files likely involved

- `path/to/file`: why

## Validation plan

## Risks / open questions
```

## Plan Files

If the user asks to write a plan file:

- Prefer an existing planning/docs convention in the repo.
- If no convention exists, write to a clearly named root-level file like `FEATURE_PLAN.md` or `docs/<feature>-plan.md`.
- Do not bury important decisions only in the conversation; include them in the plan file.

## Guardrails

- Do not make code changes during pure planning unless explicitly asked.
- Do not over-design speculative infrastructure.
- Prefer one reusable primitive only when at least two callsites need it now or the first callsite is clearly intended as a shared foundation.
- Keep plans actionable; avoid vague steps like “update UI” without identifying the component/state involved.
