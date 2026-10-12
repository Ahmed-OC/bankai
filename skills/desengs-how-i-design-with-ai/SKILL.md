---
name: desengs-how-i-design-with-ai
description: Use when an AI agent is building UI and output drifts toward generic slop. Encodes a 7-rule loop: constraints first, subtract, design-tool variants, components, preview deploys, stolen references, taste reps.
source: https://ref.tools/blog/how-i-design-with-ai
category: essay
---

# How I Design with AI (desengs) — a pro's AI design loop

Source: https://ref.tools/blog/how-i-design-with-ai — Ref.tools (Reference, the visual reference tool) team blog, written by an engineer at Ref who is "not a designer and hates slop". A field-guide essay on de-slopping product design when an AI agent holds the pen. No license stated.

## What it is / Why it exists

Thesis: AI agents have made everyone capable of producing UI, and almost all of it is slop — generic, over-added, disjoint patchwork. The fix is not better prompts for one-off fixes; it is a disciplined design *loop* run by a product engineer who supplies constraints, subtraction, real data, references, and taste. The author's team ships designed product this way with no full-time designer.

The essay's seven rules are the loop. Each rule exists because agents fail in a specific, repeatable way when the rule is skipped:

- No constraints doc → agent invents the problem's shape → disjoint patchwork.
- No subtraction pass → agent adds copy, lines, icons you never asked for.
- Iterating in the product repo → "prototype gravity" locks in the first design.
- No components → every view re-implements its own button; patchwork look.
- Mock-data review → designs that only work with placeholder strings.
- No references → agent invents UX patterns that were solved a decade ago.
- No reflection → you can feel it's wrong but ship it anyway.

## The core ideas — the seven rules

### 1. Always consider the whole

The author's design process, lifted from Christopher Alexander's *Notes on the Synthesis of Form*:

1. Lay out all the constraints you are designing for.
2. Consider an array of solutions that satisfy those constraints.
3. If you realize a constraint must be added or one can be removed, go to #1.

Constraints are yours to decide, not the agent's. Typical constraint classes:

- Typography and sizing rules (type scale, base spacing unit, grid).
- Workflows the UI must support (entry points, happy path, recovery path).
- Business-logic states (empty, loading, error, permission-denied, partial data, offline).

The failure mode the rule guards against: skipping step 3 and "playing design wackamole" — a user gets confused, you prompt "Make X more prominent" or "Add an affordance to do Y", and the product becomes a patchwork that randomly prioritizes some interactions over others. When feedback arrives, first ask whether it *changes your constraints*; only then jump to solutions.

Operational habit from the essay: keep a running document of papercuts and annoyances. Fix the obviously-correct ones fast; batch the minor ones and address them cohesively at the next redesign instead of spot-patching.

A constraints doc is small enough to keep in-repo:

```markdown
# <Screen> constraints
- Type scale: 12/14/16/20/28px, line-height 1.4 body / 1.2 headings
- Spacing: 4px base; container padding 24px; max content width 720px
- Workflows: create item (primary), browse items, recover from failed save
- States: empty, loading skeleton, error-with-retry, read-only (viewer role)
- Hard rules: no modal-in-modal; destructive actions require confirm
```

### 2. Remove stuff

Agents are additive by default — the same bias that produces belt-and-suspenders logic, extra try-catch blocks, and re-implemented utilities in code shows up in UI as extra copy, extra divider lines, extra icons. The author's verdict on typical agent UI: it "looks better than most engineers would make by hand" but is "actually kind of bad".

Your job in review is subtraction. Ask of every element: "Do I actually need that?" Concretely, hunt for:

- Helper text that restates the label or the button.
- A third button (tertiary actions you never specced).
- Icon-next-to-every-label; decorative dividers; redundant badges.
- Empty-state illustrations where one sentence would do.

### 3. Iterate in a design tool, not in the product

"Prototype gravity is the silent killer": once the agent builds version 1 in your real codebase, refining it feels cheaper than exploring alternatives — so alternatives never get explored, and the shipped design is a graft of the first draft onto production code.

The rule: iterate wherever you have fine control, fast iteration, and minimal extra context. The author: "Figma is still the GOAT" (its AI integration is improving); cursor-style design modes and agent-built HTML prototypes are also fine. Whatever the medium, have the AI generate 3–4 variants of everything before refining one.

Decision rule: until a direction is chosen from variants, the design does not touch application code. Code is where the chosen design gets *built*, not *explored*.

### 4. Use components and libraries

Separate views from logic and build reusable components, so the app reads as one system instead of "a patchwork of re-implemented buttons". This is the structural defense against rule-2 slop: additions land inside a component contract, not as per-view one-offs.

The author's team maintains a `/showcase` page in the product: agents build new UI components there first, where they can be played with in isolation, before being connected to the main app. This is a cheap, high-leverage pattern — a playground route per component library.

Mechanism, framework-neutral — one button, variant-driven, zero per-call re-implementation:

```css
.btn {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 8px 14px; border-radius: 8px; border: 1px solid transparent;
  font: inherit; font-weight: 500; cursor: pointer;
}
.btn--primary { background: var(--accent); color: var(--on-accent); }
.btn--ghost   { background: transparent; border-color: var(--border); }
.btn--danger  { background: var(--danger); color: var(--on-danger); }
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
```

An agent instructed "add a small button here" must compose from this file. If it writes inline styles or a new `<button style>`, that is the patchwork smell — reject it.

### 5. Use preview deploys

"The best way to evaluate a design is with real data." A design that looks right with mock strings can be wrong the moment real names, real empty states, and real error responses flow through it. There will always be polish and rework — plan for it instead of being surprised by it.

For large features, split the work:

- Backend PR first, verified with unit and integration tests.
- Frontend PR second, requiring human verification against a preview deploy.
- One preview deploy per frontend PR (a routine CI action), so sharing a clickable URL is free.

### 6. Steal stuff

"Most UX problems have already been solved" — your job is to find the existing solutions and assemble them. Spend real time looking at products that solved similar problems.

The author: "Every good designer starts every project by pulling together screenshots." A screenshot collection is "amazing context for your agent" — reference images in the prompt are how you transfer proven layouts, spacing rhythms, and interaction patterns instead of asking the model to invent them. (This is the essay a visual-reference tool would write: references are the anti-slop input.)

Stealing is reference-driven prompting: feed 5–10 screenshots of adjacent products plus the constraints doc, then ask for variants. The agent interpolates between real designs instead of regressing to its mean.

### 7. Explore your taste

Taste, per the author (digging at Kyle Chayka): "reflecting on your own reaction to something". It is mandatory for creating and for not creating slop.

The engineer's predicament: product engineers are excellent at identifying when a design doesn't work, and have a hard time knowing how to fix it — they lack the solution library that comes from years of reps. The library is built only by trying things and reflecting on the results.

The team ritual: "agricultural threshing" — put the design in the middle of the group and beat it with sticks until it feels good. Structured group critique converts vague discomfort into named fixes. Record each reaction ("the hierarchy is flat here", "this state feels unhandled") — those are constraints for the next loop iteration (rule 1).

## When to use / When NOT to use

Use when:

- An AI agent owns any part of UI creation or refinement (greenfield screen, redesign, feature addition).
- Output has started to look generic, over-decorated, or locally-patched.
- You are about to prompt a spot-fix ("make X more prominent") — stop, run the loop instead.

Skip or shrink when:

- The task is pure backend or logic with no visual surface — rules 1–7 mostly don't apply.
- The screen is brand-critical and pixel-final — the loop still applies, but variant exploration belongs in a design tool with a human art-directing, not in code.
- Constraints are genuinely unknown — write them first (rule 1); an agent given no constraints will invent them badly.

## How to apply (numbered checklist)

1. Write the constraints doc before any generation: type scale, spacing base, workflows, every business-logic state, hard interaction rules.
2. Collect 5–10 screenshots of products that solved the adjacent problem; attach them as visual context to every design prompt.
3. Generate 3–4 variants of the screen in a design tool or isolated HTML prototype. Do not start from, or refine, a version already grafted into app code.
4. Pick a direction against the constraints doc — not by polish of any single variant.
5. Build as reusable components on a showcase/playground route first; compose screens from the component contract only.
6. Run a subtraction review: delete every element that fails "Do I actually need that?" — helper text, tertiary buttons, decorative lines, redundant icons.
7. Evaluate on a preview deploy with real data. Split large features: backend PR with tests, then frontend PR with human verification.
8. Log incoming feedback as either a constraint change (rerun the loop) or a papercut (batch for cohesive redesign). No wackamole patches.
9. Thresh: group-critique the design, record each reaction as a named fix or new constraint.
10. Loop until no constraint is added or removed — then ship.

## AI-slop warning

How AI typically violates this essay, and what to enforce:

- **Wackamole prompts**: "make X more prominent", "add an affordance for Y" produce patchwork that randomly prioritizes interactions. Require constraint-level reasoning before any local fix.
- **Additive bias**: default agent output ships extra copy, icons, and dividers. Every review must include a deletion pass; treat unrequested additions as review blockers, not gifts.
- **Prototype gravity**: agents (and their orchestrators) prefer building v1 straight in the repo. Without a forced variant step, the first draft becomes the shipped design.
- **Per-view re-implementation**: an agent will happily write a fifth button style inline. Enforce the component contract mechanically — reject inline-styled primitives.
- **Mock-data complacency**: designs validated only against placeholder data pass review and fail reality. Preview deploys with real data are the gate.
- **Invented UX**: asked to design without references, models regress to the mean of training-data slop. References in context are the single highest-leverage anti-slop input.
- **No reflection**: "looks fine" is not taste. If nobody can name why a design works, it will regress the moment the agent iterates again.

## Relations

- **desengs-using-ai-as-de** — sibling AI-workflow essay from a design engineer's angle; this skill adds the constraints-first loop, the prototype-gravity warning, and the references-as-context habit.
- **desengs-shedsgns-taste** — taste as acquired, articulable discrimination; supplies the "solution library" theory behind rule 7's reps-and-reflect training.
- **desengs-concept-of-taste** — the conceptual grounding of taste as reflection on one's own reaction; complements this skill's operational version (threshing, recorded reactions as constraints).
- **desengs-component-gallery** — generalizes the author's `/showcase` route: gallery-first component development with live isolated examples before app integration.
