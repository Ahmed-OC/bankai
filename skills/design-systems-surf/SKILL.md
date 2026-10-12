---
name: design-systems-surf
description: Use when designing or auditing a design system's architecture. Proven structural patterns from 90+ leading systems: foundations coverage, component taxonomy, doc schema, status and trust model.
source: https://designsystems.surf/
category: reference
---

# Design Systems Surf — how leading design systems are structured

Source: https://designsystems.surf/ — Ilya Greben (Dzeya OÜ), launched fall 2023. A curated database of 90+ "best-in-class" design systems (Apple HIG, IBM Carbon, Amazon Cloudscape, Shopify Polaris, GitHub Primer…) organized along two axes: Foundations directories (1,000+ sources) and Components (2,500+ sources), plus blueprints, articles, and paid foundation products. The site's editorial through-line: systems contain the assets AI needs but lack the context saying which decisions are current, approved, and safe to reuse.

## What it is / Why it exists

A cross-system reference that normalizes how real systems are built. Instead of admiring one system, it indexes every system against the same axes, exposing coverage gaps, naming drift, and documentation patterns. Use it as evidence, not inspiration: when you must decide "do we need a theming doc?", "is `switch` or `toggle` the right name?", "what states must a component document?", the site answers with what IBM, Atlassian, and 88 others actually did.

## The core ideas

### 1. The two-axis catalog: foundations × components

Every system in the database is measured on exactly two numbers:

- **D** — how many of the 14 foundation directories the system documents (observed range 4–19; IBM Carbon: 14).
- **C** — how many components it ships with docs (observed range 0–41; IBM Carbon: 31, Apple HIG: 21).

The 14 foundation topics are the de facto coverage checklist:

```
accessibility · color system · component overview · data visualization
figma · icons · layout · motion · patterns · repository · spacing
storybook · theming · typography
```

A system without docs for a topic is a system where consumers guess. Treat this list as the minimum table of contents; audit your own system against it and write the missing page before adding a 32nd component.

### 2. The five component categories

The site's taxonomy for organizing components (from its "building blocks" article). Every component in a system must land in exactly one:

1. **Actions** — turn intention into movement: button, link, action button, chip, menu. Buttons are conversational and consistent; links invite exploration without demanding decisions.
2. **Feedback** — acknowledge actions: alert banner (persists until acknowledged), snackbar/toast (brief, demands nothing back), dialog, modal, inline message, empty state, tooltip, help text.
3. **Inputs** — where users talk back: **15 components** including text field, checkbox, radio, switch, search, label, dropdown, date picker. Frame forms as conversation, not "give me your data."
4. **Navigation** — where am I: tabs, sidebar, page header, breadcrumbs (most useful deep in complex hierarchies: `Home > Projects > Q2 Reports`).
5. **Status indicators** — ambient awareness: badge, progress bar, progress indicator. Every color/position/word choice signals urgency; the goal is visibility without noise.

When your component list has items fitting no category, that is a signal it is a pattern (composite) or a variant, not a component.

### 3. The component documentation schema (the Blueprint pattern)

The site's blueprints (checkbox, chip, radio, segmented control, slider, switch, tabs) prescribe one fixed documentation shape per component. Copy it verbatim as your spec template:

```markdown
# <Component>
## Anatomy          — named parts and the role of each part
## States           — full interactive state list
## Behavior         — what happens on interaction, and when it counts as "done"
## Usage            — 2–3 real interface contexts (settings, filters, state toggles)
## When (not) to use — decision boundaries + contrast with sibling controls
## Best practices   — binary rules, not suggestions
```

Canonical state list from the switch blueprint — five states, no system ships fewer without gaps:

```
enabled · hover (web-only) · focus (keyboard, "crucial for accessibility")
pressed · disabled
```

Behavior rules worth copying exactly:

- The label is clickable too (a11y + small screens).
- The component counts as toggled "when its thumb reaches the opposite end of the track" — define completion, not just start.
- Inline label naming the controlled feature; standalone only when context makes the target obvious.

The decision-matrix section is the load-bearing part: a switch spec that doesn't say "switch = instant binary state; checkbox = multi-select applied on submit; radio = exactly one of N; segmented = view switching" will be misused within a quarter.

### 4. Naming: expect drift, design for it

Across the 74 systems documenting the same control, the site shows an even split: ~half name it `switch` (Spectrum, Ant Design, Material, Carbon, PatternFly, Radix), ~half `toggle` (Atlassian, Cloudscape, Pajamas, Zendesk Garden, Geist), some compound `toggle-switch`. Grouping also drifts: "selection-controls" (Audi, Elastic), "inputs" (Workday), "forms" (SumUp), "data-entry" (INPS Sirio).

Implications:

- Pick one name per concept, publish it, and map aliases. Do not chase universal names — they don't exist even among the best.
- Cross-source name drift (`emphasis` in Figma, `variant` in code, `type` in docs) "looks like three separate APIs"; AI "picks one at random" — the fix is an explicit mapping, not identical names.
- System naming itself splits: branded (Polaris, Lightning, Paste, Geist) vs unbranded ("Audi Design System"). Branded names age better when the system spans multiple products.

### 5. Publish artifacts: the trio

Every catalogued system exposes some subset of: live docs site, source repository, Figma library, Storybook. The strongest systems ship all four; entries with none (Audi at time of indexing) are effectively undocumented. Storybook with a linked playground tab (Cloudscape `tabId=playground`, Kajabi `tab=preview`) is the emerging standard for interactive docs. Platform-split docs (Thumbtack `/ios/`) are only justified when behavior genuinely differs per platform.

### 6. The AI-readiness doctrine (the site's core thesis)

Four "guess zones" — valid assets lacking clear boundaries — where AI (and new hires) start inventing:

1. **Asset without meaning** — near-identical gray tokens for secondary text vs borders vs disabled; type scales without usage rules; `8px` without "tight grouping or responsive padding?". Fix: Apple HIG's model — semantic colors "defined by purpose rather than raw hex values," with each role's accessibility and context written down. "Semantic purpose trumps visual similarity."
2. **Missing states/behavior** — no loading state during destructive actions; no line between warning and error; motion tokens that never say when to animate or how to honor reduced motion. "Available values don't explain allowed behavior" — when a state is missing, "AI just invents one." Fix: Cloudscape's model — document interaction behavior next to visuals (when an alert takes focus vs uses a live region).
3. **Conflicting sources** — Figma ahead of code, stale docs, production one-offs. "Throwing more files at an LLM won't fix this." Fix: a declared trust model (below) plus component status: Primer-style `Experimental / Ready / Deprecated` with migration paths; Atlassian-style release phases `Early Access → Beta → GA → Deprecation`.
4. **Compound amplification** — the first plausible guess becomes the next reference: mockups seed future kits, snippets copy across features, "AI-written docs become truth for new hires." Human errors stay local; AI errors spread "across design, code, documentation and QA — remarkably consistent in all the wrong ways."

The trust model to declare per source:

```
code      = runtime behavior (but don't canonize legacy workarounds)
figma     = approved structure
docs      = usage rules
tokens    = machine-readable relationships
releases  = what is currently supported
```

"The goal is not to force every type of truth into one file" — it is enough mapping to connect them. Concretely, per decision record: purpose, boundaries, status, authority, and cross-source name mapping. Fluent's "one primary button per layout; equal-priority actions use outline/subtle" and SAP Fiori's message-box-interrupts / toast-is-brief / strip-stays / value-states-attach-to-fields are the caliber of rule this layer must hold.

### 7. Named systems and their distinctive structural choices

| System | Distinctive choice worth stealing |
|---|---|
| Apple HIG | Semantic colors by purpose, not hex; smallest foundation set that still covers (D:13/C:21) |
| IBM Carbon | Widest coverage (14 foundations, 31 components); dataviz treated as a first-class foundation |
| Amazon Cloudscape | Behavior documented beside visuals; interactive playground as default doc mode |
| GitHub Primer | Component lifecycle status (Experimental/Ready/Deprecated) with alternatives and migration |
| Atlassian | Release phases Early Access → Beta → GA → Deprecation make status legible |
| Microsoft Fluent | Usage boundaries as explicit rules ("one primary button per layout") |
| SAP Fiori | Adjacent-feedback decision matrix (message box vs toast vs strip vs value state) |
| WorkOS Radix | Headless primitives layer separated from styled layer |
| Shopify Polaris / Twilio Paste | Branded system name spanning product + marketing + docs |
| GOV.UK / USWDS | Accessibility as its own documented foundation, not a footnote |

## When to use / When NOT to use

Use when:

- Architecting a new system: pick the foundation checklist (idea 1), the category taxonomy (idea 2), and the doc schema (idea 3) before writing CSS.
- Auditing an existing system: score D and C, find guess zones, declare the trust model.
- Writing any single component spec: the blueprint schema is the template.
- Deciding governance: status labels, release phases, name-mapping tables.

Do NOT use when:

- You need visual styling rules (spacing values, type scales, easing curves) — this source covers structure, not styling; use typography/motion siblings.
- The task is a one-off landing page with no reuse — a system's overhead is only repaid at ≥3 surfaces.
- You are tempted to copy one system wholesale: the site's own value is cross-system comparison; single-system cargo-culting (e.g., "make it like Material") is exactly the misreading it exists to prevent.

## How to apply

1. List your foundation pages against the 14-topic checklist; write the missing ones before any new component.
2. Slot every existing/planned component into the 5 categories; anything unslottable is a pattern or variant — move it out of the component list.
3. Write each component spec in the blueprint shape: anatomy → 5 states → behavior (incl. completion definition) → usage contexts → when-not-to-use + sibling-control matrix → binary best practices.
4. Choose one canonical name per concept; record aliases and a Figma↔code↔docs mapping table so `emphasis`/`variant`/`type` cannot drift silently.
5. Tag every component and token doc with status (`Experimental | Ready | Deprecated`) and give deprecated items a migration path.
6. Declare the trust model in your README: what code, Figma, docs, tokens, and releases are each authoritative for.
7. Convert every "tribal knowledge" rule into a written boundary ("danger buttons may not load", "one primary action per view") — anything implicit becomes an AI guess.
8. Ship the artifact trio: docs site + repository + Figma library + Storybook with a live playground tab; missing artifacts = undocumented.
9. Re-audit quarterly: recount D and C, hunt the four guess zones, and mark which decisions AI may make autonomously vs where it must stop and ask a human.

## AI-slop warning

The failure mode this source names directly: an AI given a half-documented system produces "plausible local decisions" that stack into "a parallel layer of rules built entirely on AI assumptions" — consistent, confident, and wrong. Watch for: near-identical grays chosen by visual similarity instead of semantic role; invented states (a "loading" variant nobody approved); renaming props on the fly to blend conflicting sources; treating production legacy as recommended practice. Also the curator's trap: browsing 90 systems invites maximalism — copying Carbon's 31-component breadth into a product that needs 12. Coverage numbers are diagnostic, not a leaderboard; the catalog rewards documented decisions, not component count.

## Relations

- **ds-checklist** — complements this skill with the audit-side checklist; this skill supplies the structural taxonomy and named exemplars.
- **code-source-of-truth** — argues code is the single source of truth; this skill's trust model tempers that: code owns runtime behavior, but usage authority belongs to docs and status records.
- **tokens-generator** — the tooling counterpart to idea 6: generates the token layer whose semantic roles must be documented by purpose, per the guess-zone fixes here.
- **bankai** — the umbrella canon that dispatches to this skill whenever the task is system architecture rather than single-screen craft.
