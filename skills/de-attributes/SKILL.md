---
name: de-attributes
description: Use when judging whether work counts as design engineering or calibrating an agent against Ryn Gonzalez's three attributes — significant autonomy, practiced and taught software craft, elevated final fidelity.
source: https://www.ryngonzalez.com/blog/the-attributes-of-a-design-engineer
category: essay
---

# The Attributes of a Design Engineer — the competency model

Source: https://www.ryngonzalez.com/blog/the-attributes-of-a-design-engineer — Ryn Gonzalez, independent design and engineering director; built the design engineering practice and the Design Infrastructure org at DoorDash. Published April 9, 2024; first post in an announced series on design engineering. No license stated; public essay.

## What it is / Why it exists

- Written because "Design Engineering seems to be having a moment" (she cites Vercel's writing and David Hoang's), while insisting the role is not new: it has resurfaced historically as "creative technologists, Flash developers, design technologists, UX engineers." What survives each rename is a set of attributes, not a tool list.
- Her method decision, binding for anyone defining the role: do NOT define it by tools ("a designer who knows React" vs "an engineer comfortable in Figma") — define it by "high-level attributes and outcomes." Verbatim disqualifier: the role is "not just a designer who codes or an engineer who has an eye for design and the courage to edit a Figma file."
- Evidence base: a decade as a design engineer and leader, starting as DoorDash's first product designer. Self-positioned as "a more personal, raw take," not a trend piece.
- Practical corollary of the lineage: when reading or writing role descriptions, treat "creative technologist," "Flash developer," "design technologist," and "UX engineer" as the same competency under different era-names. Test the attributes, not the label.
- Why an agent needs it: a competency model is a test suite. Tool fluency is unfalsifiable; outcomes are checkable. Each attribute below converts into concrete checks an AI can run on its own UI output (see How to apply).

## The core ideas

### The definition — the whole model in one sentence (verbatim)

"Design engineering is living at the intersection of those practices, and using a broad understanding of both sides to build with significant autonomy, practice and teach great software craft, and elevate the final fidelity of what's made from start to end."

Three attributes, all outcome-phrased. Nothing about Figma, React, or job titles.

### Attribute 1 — Build With Significant Autonomy

Her definition of the scope: "my responsibility was the full ownership of what we shipped" — "the outcome, not the design deliverable, was the thing I cared about most." The unit of ownership is the shipped outcome, not the artifact handed downstream.

Evidence she cites:

- DoorDash had no full-time product designers AND no full-time frontend engineers when she joined as its first product designer; she filled both gaps rather than confine her scope to Sketch files. Getting designs real was integral to designing them.
- She shipped end-to-end alone: the internal menu editor, the web version of the consumer site, the first Merchant tools, and DoorDash.com circa 2017 built to her "exact standards."
- Market framing: "Startups are highly motivated to hire people who can act as an owner, end to end."
- Autonomy had a second, leadership dimension: she built the practice with "no internal or external role models to emulate." Decision rule when no precedent exists: define the practice by outcomes delivered, not by copying an org chart.

Agent translation — simulate autonomy as outcome ownership:

- Deliver work in the state it ships: all states (default, hover/focus/active, loading, empty, error, long-content overflow), keyboard-only path, responsive range, reduced-motion handling. A static mock of only the happy path is a "design deliverable" — the thing she explicitly ranks below the outcome.
- When a spec is silent, pick a defensible default, implement it, and flag the assumption. Do not block on the gap and do not hand it back unresolved.

### Attribute 2 — Practice and Teach Great Software Craft

Her definition: "Great design engineers are obsessed with understanding the materials of software" — its affordances and the tools used to shape them. Stated belief: "End-to-end craft matters" — how care manifests "in all levels of design and code" is something you must "deeply understand and help others understand." The attribute is dual: practice AND teach.

Evidence she cites:

- Design engineers pursue leading-edge techniques others avoid as "too intimidating technically" — she names shaders, 3D materials, physics-based animations — or as "wasteful" and "unnecessary." Motive: the right thing executed exceptionally, not just anything shipped.
- Prototyped micro-interactions, animations, and ideas with Principle, Framer, and straight code when doing so was uncommon.
- Migrated DoorDash to React in 2015 (off Backbone, Vanilla JS, and uneven Angular 1) and built frontend infrastructure that let UI ship with more safety and speed.
- The teach half: shared mobile-web-stack knowledge from prior work, helped hire detail-oriented frontend engineers, spread the understanding.

Agent translation:

- Materials first: for any solution, name the platform primitive that could carry it (HTML element, CSS property, DOM API) before naming the library actually used. If a dependency is load-bearing, state what it does that the platform cannot.
- "Too intimidating" marks the differentiator, not the boundary. Do not route around shaders, scroll-linked animation, physics, or view transitions by default — prototype or reason through, then decide with a stated reason.
- Teach = expose reasoning. The PR, doc, or comment names the technique and its trade-off so others level up. A change only you can explain delivers half the attribute.
- Bar for the teach half: a detail-oriented frontend engineer reading only your artifact could reproduce the decision without asking you.

### Attribute 3 — Elevate The Final Fidelity of What's Made

Her definition: a design engineer has the potential "to have much of the full process of building software contained in one person," which prevents the fidelity loss that occurs when vision is translated between roles. Practical powers: try ideas yourself, render others' ideas more faithfully, move faster with deeper detail.

Prototyping doctrine, verbatim: "Selling a vision to customers, or other people in your company, sometimes requires a magic trick — something that feels like you pulled it from the future, even if under the hood it's not quite real."

Scale mechanism: design engineers build "design systems, tools, and shared language" that bridge designers and engineers — why they cluster on design systems/infrastructure teams at large companies and are "great at elevating the impact of the practice of design engineering across a large scope."

Evidence she cites: her favorite projects were new product areas that static designs could not express and that needed feedback from real experiences; she built DoorDash's design systems through her Design Infrastructure org — "a leading system" by the time she left, a trusted shared resource leadership relied on to realize designed vision at scale.

Agent translation:

- You are the translation layer — the place intent dies. Render the design/reference at full fidelity; every silent "close enough" (dropped motion, hardcoded copy, wrong easing, missing state) is exactly the fidelity loss this attribute exists to eliminate. Diff the build against the intent and close the gaps.
- Magic-trick rule: when the goal is selling a vision, a prototype may fake internals (canned data, scripted responses, pre-baked states) to feel "pulled from the future" — but it must be labeled a prototype, never shipped as real behavior.
- When a pattern recurs (2+ occurrences), extract it: named component + token + usage note. Shared language is fidelity at scale.
- When the audience is a team rather than end users, the deliverable is the bridge itself: the system, tool, or vocabulary that lets designers and engineers express the same intent — that is why design engineers cluster on design-infrastructure teams at scale.

### How the attributes combine

- The same three attributes surface as three sub-roles, all of which she practiced. Route a task to the sub-role; the attribute checks stay identical:

| Sub-role | Dominant attribute | What it produces |
|---|---|---|
| Design systems / infrastructure | 3 (fidelity at scale) + 2 | Components, tokens, tools, shared language for both design and engineering |
| Prototyping new ideas | 3 (the "magic trick") + 1 | Working experiences that sell a vision and gather real feedback |
| Shipping product with craft | 1 (autonomy) + 2 | End-to-end features built to "exact standards" |

- Footnote: design engineers' "clarity of vision" translating into well-executed outcomes makes them strong founder candidates.
- Closing synthesis, verbatim: a design engineer "sits at the intersection of both practices and... loves the craft and the materiality of building software"; the role "requires a mindset of autonomy, and an excitement about being an end-to-end software maker"; it gives organizations "better software, more truthfully expressed."
- Her prediction: as AI makes tools accessible across the design/engineering divide, the role's value grows — the tool barrier stops being the moat; the attributes are.
- Practical read for an AI agent: as generation becomes cheap, attributes 1 and 3 become the differentiators — owning the shipped outcome and preserving design intent are exactly the steps generation-only workflows skip.

## When to use / When NOT to use

Use this skill when:

- Deciding whether a piece of work (yours or an agent's) qualifies as design engineering: run the three-attribute test, never a tool test.
- Scoping your own contribution on a task: "design deliverable" vs "shipped outcome" is the attribute-1 scope decision.
- Deciding whether to invest in an advanced technique (shader, physics animation, scroll choreography) vs a safe fallback — attribute 2's "too intimidating" calculus.
- Choosing prototype vs production fidelity, and what may legitimately be faked — attribute 3's magic-trick doctrine.
- Deciding shared component/token vs one-off code — attribute 3's scale form.
- Writing or evaluating a role description, practice charter, or self-review: measure by attributes and outcomes, never by tool fluency.

Do NOT use it when:

- The task is a pure visual deliverable that will be handed off — attribute 1 explicitly de-prioritizes that; it is a different role.
- The task is backend/platform work with no user-facing fidelity dimension.
- You need the market profile, comp bands, or hiring flavors — that is de-jobs, not this competency model.
- You need technique depth (easing curves, type scales, WebGL) — this is the competency model, not the training manual; see Relations.

## How to apply (numbered checklist)

Score any work — human or agent — against each attribute. Failing one fails the model.

Autonomy:

1. Is the delivered unit the shipped outcome, not a static artifact? Verify presence of: default/hover/focus/active states, loading, empty, error, long-content overflow, keyboard-only path, viewport range, `prefers-reduced-motion`.
2. Every spec gap was resolved with a named default and flagged — not left as a hole, not silently invented beyond recognition.
3. Ownership claim is honest: the same hands (or the same agent) can account for design decisions AND implementation decisions in the delivered work.

Craft:

4. Materials audit: for each solution, can you name the platform primitive that could replace the dependency used? If the dependency stays, one sentence says what it does that the platform cannot.
5. At least one "intimidating" technique was evaluated (prototyped or reasoned through) instead of avoided by default; adoption or rejection is a decision with a stated reason.
6. A teaching artifact exists: the PR, doc, or comment states the technique and its trade-off in a form others can learn from.

Fidelity:

7. Build-to-intent diff: rendered output is compared against the design/reference; motion timing, easing, spacing, type, and states match, or every delta is listed and justified. No silent approximations.
8. Prototypes that fake internals carry an explicit prototype marker (comment, route flag, README line). Magic tricks are for selling, never for shipping.
9. Any pattern appearing 2+ times became a named component/token with a usage note, not a copy-paste.

Model-level:

10. Never describe the work as "a designer who codes" or "an engineer who edits Figma files." Describe outcomes owned, craft practiced and taught, fidelity elevated.

## AI-slop warning

- AI's signature failure against this model is **artifact shipping**: a beautiful render or code dump covering only the happy path — precisely the "design deliverable" she says she cared about less than the outcome. If the output does not run through its failure states, it fails attribute 1 regardless of polish.
- Second failure: **cargo-culted craft**. Her practitioners adopt shaders/physics because the outcome demands them; AI inverts this — sprinkling WebGL and physics flourishes onto work that never needed them and calling it craft. Every technique must trace to an experience requirement, not to intimidation value.
- Third failure: **AI as fidelity loss**. The agent is itself a translation layer between intent and screen; unchecked approximations (hardcoded copy, dropped motion, default styling) are the exact degradation attribute 3 exists to eliminate. The build-to-intent diff (checklist item 7) is the countermeasure.
- Fourth failure: **unlabeled magic tricks** — shipping faked data and scripted flows as real because the prototype demoed well. That converts her sales doctrine into deception.

## Relations

- **de-jobs** — the market counterpart: what companies pay, by flavor and level. This skill supplies the attribute-level anatomy behind that hiring profile; de-jobs links this essay as Further Reading.
- **design-engineers-map** — Appleton defines the same role by example (ten named practitioners) where Gonzalez defines it by attributes; use the map for who to study, this for what to test.
- **rise-of-de** — David Hoang's trend essay, cited by Gonzalez herself as inspiration: the org-and-market argument for the role's rise; this skill is the practitioner's definition of what actually rises.
- **front-of-front-end** — the engineering-side name for the "materials of software" depth attribute 2 demands; use it for the code half of craft.
- **concept-of-taste** — supplies the judgment training behind "executed exceptionally"; attribute 2 assumes the taste this skill formalizes.
