---
name: desengs-interface-craft
description: Use when an interface works but feels forgettable, before locking in a first design direction, or when refining details with an AI agent — Puckett's conceptual range, refinement passes, motion as proof of care.
source: https://www.interfacecraft.dev/; https://joshpuckett.me/
category: reference
---

# Interface Craft (desengs) — essays on building high-craft interfaces

Source: https://www.interfacecraft.dev/ — Josh Puckett (~2 decades designing products at Wealthfront and Dropbox, startup advisor, creator of DialKit and Pica). A paid working library ("pay once, access for life") of 40+ articles, interactive walkthroughs, videos, skill files, and tools, launched Feb 2026. Distilled here from the site's three free previews, its public updates log, and the author's essays at joshpuckett.me — paid articles are represented only by their publicly logged titles.

## What it is / Why it exists

- Thesis (site's own words): "Every day, software gets easier and easier to make. And most of what gets made will probably be fine. Functional, but forgettable. Made too quickly without enough thought." The library is for people "who want to make something else" — an "almost unreasonable level of consideration."
- The enemy is not broken software; it is *fine* software. The method is not more features but a repeatable craft loop: **breadth → depth → refinement pass → motion as proof**.
- Library taxonomy (its own vocabulary, mirror it if you cite the system): **Working Knowledge** (frameworks, principles, models), **Practical Demonstrations** (walkthroughs refining real interfaces), **Collaborating with AI** (agent workflows, videos), **Means & Methods** (11 articles, 100+ topics), **Interface Kit** (component collection + skills).
- Companion concepts the site names explicitly: *conceptual range*, *conceptual depth*, *facets of quality*, *tool mastery*, *animations as proof of care*, *noticing details*, *dialing everything in*.
- Audience: designers, engineers, PMs alike; implementation-agnostic (Figma or code), assumes design fundamentals — it is a refinement curriculum, not a beginner one.
- Public content inventory (updates log, for orienting further reading): "Conceptual Range" (article), "Refining a Task App Interface" (article), "Refining a Generative Graphic" (video, 9 min), "Designing Library Cards" and a three-part "Redesigning a Mobile Web App" (practical demonstrations), "Animations as Proof of Care" (article), "Designing Gifting," "Using DialKit Timeline," "Compound Motion" (videos), the Means & Methods collection (11 articles), and versioned agent skill files. Cadence: meaningful additions roughly monthly since launch.

## The core ideas

### 1. Conceptual range — breadth before depth

- The first idea is easy because you have seen it before; it usually carries an unexamined assumption. Photo-backup example: everyone refines *manual selection* (tap, drag-select, group-by-day) — the winning answer to "why do we need users to do anything at all?" is *automatic backup, no interface*.
- Restyling one idea is not range. Three numpads ($3–$7 keys, reversed order, ± keys) are one concept at three depths. True range means concepts that answer *different questions*: presets (15% / 20% / 25% buttons), a slider from $0, a gamified pick — each with different pros/cons, each spawning further ideas.
- Five techniques to force range (use all five when stuck):
  1. Remove or add a constraint — "what if it weren't a screen?", "what if it happened automatically?"
  2. Blend domains — "what if this were a game?", "what if Muji made it?"
  3. Invert the problem — help users *eliminate* what they don't want instead of finding what they want.
  4. Set an arbitrary quota — force 5, 12, or 20 concepts before judging any.
  5. Optimize for facets — take the facets of quality (durable, differentiation, desirability…) and ask "what would a 10/10-durable version look like? a 10/10-differentiated one?"
- Breadth is a hedge against limited taste: "your taste is limited by what you've seen." Case: 15 structurally different cover directions for one book (rulers, kintsugi, WD-40, passport, pop art, snap-off kit…) before going deep; Heston Blumenthal's scrambled-egg-and-bacon ice cream came from an extreme concept range, not from refining a soufflé.
- Order is non-negotiable: breadth first, then depth. Going straight to depth on a familiar idea robs you of everything you wouldn't ordinarily try.

### 2. The refinement pass — a 6-flaw critique of a "good" interface

Puckett's case study starts from an interface that is *at or above industry standard* — refinement is what separates craft from standard. The flaws he finds form a reusable audit:

1. **Inconsistent icon styles** — one filled icon among outline icons. Unify stroke style everywhere.
2. **Too many vertical rules** — four competing left-alignment systems (containers, titles+icons, section labels, task text). Reduce to **two visually dominant rules**; give section header, primary content, and secondary list one shared left edge.
3. **Container without function** — a boxed toolbar "for no functional gain" adds "unnecessary weight and noise." Delete the chrome; use floating buttons. Follow platform convention: primary action on the **right**, visually emphasized (iOS), secondaries left.
4. **Orphaned visual treatment** — a fine outline used exactly once in the whole interface. Every treatment must recur or die.
5. **Divider inconsistency** — one list with dividers, one without. Standardize (and later consider removing both — see below).
6. **Untokenized text roles** — system-generated category labels styled like user-entered titles ("too small and too bright" for its role). Style system text and user text as distinct tokens.

Refinement order from the same walkthrough: platform conventions → collapse alignment rules → add missing dividers → tokenize text roles → *revert* the divider change because "it may be simpler without" → unify icon stroke weights and colors (both had drifted) → tighten padding for optical balance.

- Meta-lessons: changes are small and individually preferential, but cumulatively they "reduce the visual weight" and make the design "feel more at home" on its platform. Test-and-revert is part of the method, not failure. Craft here is mostly *subtraction* (removing a container, removing dividers, removing two alignment rules), not ornament.
- Calibration point: the audit found six flaws in a screen already "at or slightly above" industry standard. If a pass over your screen finds nothing, the pass was shallow — run it again against each of the six categories.

### 3. Noticing details and dialing everything in with an agent

- The third free piece ("Refining a Generative Graphic", video): the loop is **notice → direct an agent → evaluate → repeat**. Noticing is the scarce skill; the agent is the hands. "Dialing everything in" = many small parameter corrections, not one heroic redesign.
- The library ships **skill files** for agents (its DialKit skill is versioned and updated like a dependency) and its "Collaborating with AI" collection covers working with coding agents and generative tools. Treat agent-facing skills/checklists as first-class parts of a design system, versioned with it.
- The author's agent-prompt pattern (from his melt-effect essay): give the agent the *mechanism* (e.g., "combine feTurbulence fractal noise with feDisplacementMap, apply via CSS filter") and require it to **expose live controls for every parameter** (sliders for scale and both frequency axes) so tuning happens on-screen instead of through re-prompting.

### 4. Animations as proof of care

- A paid article carries this exact title; the updates log glosses it as "using motion to demonstrate care." Motion is evidence that someone attended to the interface — reserve it for moments where attention is real. A companion video, "Compound Motion," teaches combining simple motions rather than authoring complex ones.
- The site practices its doctrine on itself: a customize-your-library-card onboarding with a "Replay onboarding" control, j/k keyboard navigation for walkthroughs, crossfade transitions, sounds. When you build, ship one such self-demonstrating detail.

### 5. The signature technique on public record — organic "melt" via SVG filters

The library's one fully public technical essay (joshpuckett.me/melt-effect) melts any element with a single filter, no dependencies:

```html
<svg aria-hidden style="position:absolute;width:0;height:0">
  <defs>
    <filter id="melt" x="-150%" y="-150%" width="400%" height="400%"
            color-interpolation-filters="sRGB">
      <feTurbulence type="fractalNoise" baseFrequency="0.012 0.035"
                    numOctaves="3" seed="4" result="noise"/>
      <feDisplacementMap in="SourceGraphic" in2="noise" scale="20"
                         xChannelSelector="R" yChannelSelector="G"/>
    </filter>
  </defs>
</svg>
```

```css
.anything { filter: url(#melt); }
```

Build order to re-derive it (the essay's own teaching sequence):
1. Understand the map: `feDisplacementMap` "treats red as the X shift, green as the Y shift, and mid-tones as null" — mid-gray (128) displaces nothing.
2. `scale` is the maximum pixels a point can be pushed; start at 0 and raise until the distortion reads organic, not broken.
3. `baseFrequency`: low values give wide smooth waves, high values tight jitter — then decouple the axes (X 0.012, Y 0.035).
4. Only then animate all three parameters together over ~5s; static first, motion last.
5. Prove generality by applying to an image (scale 12) and live text (scale 6).

Exact values that make it work:
- **Decouple X/Y frequencies** (0.012 vs 0.035) — this is "the trick to a truly organic feel"; equal axes read as mechanical noise.
- Expanded filter region (−150%/−150%, 400%/400%) is mandatory or displaced pixels clip at the element's original bounds.
- Per-subject scale: icons/text ~6, images ~12, hero distortion 20. Animated over a 5s loop: scale 0→40, freqX 0.005→0.012, freqY 0.020→0.035.
- Text stays selectable/copyable — the DOM is intact, only pixels distort. Never rasterize to fake this.
- Performance: animating filter attributes re-evaluates the whole filter graph every frame. One instance is cheap; several concurrent ones drop frames (Safari worst). Heavy use → recreate in WebGL.

### 6. Transmission — why the library exists at all

The author's companion essay ("On Being An Elder") states the ethic behind publishing the system: eldership "is service, not seniority," and its duties are concrete:

- **Pass down what would be lost** — wisdom lives in individual stories, mistakes, and the *why* behind decisions, not in training data; preserve rationale without turning it into cargo-cult ritual.
- **Admit mistakes** — each generation inherits sins as well as advances; honesty about past error keeps the status quo from calcifying into tradition.
- **Let the young teach you** — knowledge is never complete mid-shift; "old dogs should still learn new tricks."

For interface work this means: every rule you apply should carry its reason, and every inherited pattern should be re-derivable, not just repeatable. The library itself is the demonstration — a senior practitioner converting private judgment into inspectable method.

## When to use / When NOT to use

Use when:
- An interface already functions at industry-standard quality and must rise above "fine but forgettable."
- Starting any non-trivial feature: run the range exercise before committing (assumption → quota → facets).
- Auditing an existing screen: run the 6-flaw critique, then the refinement order.
- Pairing with an AI agent on visual work: parameterize, then dial in.
- Deciding where motion belongs: as proof of care at attended moments.

Do NOT use when:
- Usability is broken — fix function and information architecture first; this system polishes working software.
- The user needs a beginner curriculum or an installable component kit (the Interface Kit collection is paid; this skill transmits method, not assets).
- Performance budgets are tight: skip per-element SVG filter animations, skip concurrent filter animation entirely on Safari.
- Speed legitimately trumps distinction (internal tools, throwaway prototypes) — "functional but forgettable" is an acceptable target there.

## How to apply

1. State the load-bearing assumption of the current concept in one sentence; ask "why does the user need to do anything at all?" If the answer is "they don't," ship the automatic path.
2. Before depth: generate 5–12 concepts that differ in *structure*, not styling — each must answer a different question. Score each against facets (durable / differentiation / desirability, 1–10).
3. Take one concept deep only after the quota is met; record why it won so the rationale survives.
4. Run the 6-flaw audit on the deep version: icon stroke consistency; count vertical alignment rules (target ≤ 2 dominant); containers without function; orphaned treatments; divider consistency; system-text vs user-text tokenization.
5. Refine in order: platform conventions (primary action placement/emphasis) → alignment collapse → tokenization → stroke/color unification → optical padding. Budget one deliberate revert.
6. With an agent: define the mechanism once, demand live parameter controls, then dial in by eye — never re-prompt for each value.
7. Add motion last and sparingly — compound 2–3 simple motions; one attended moment beats five ambient ones.
8. Ship one self-demonstrating detail (replayable moment, keyboard shortcut, considered sound) as the product's own proof of care.

## AI-slop warning

- AI's signature failure against this system is **fake range**: it returns "three options" that are one layout at three colors and calls it exploration. Force structural difference (different input model, different question answered) before accepting any option set.
- AI over-containers: it boxes toolbars, wraps groups in bordered cards, adds dividers between everything — weight with no function. Default to subtraction; make every border and container justify itself functionally.
- AI styles system text and user-entered text identically and drifts icon strokes/colors across a screen — tokenize roles and unify strokes explicitly.
- AI animates everything with one generic ease and calls it polish; proof-of-care motion is targeted and compounded from simple parts.
- AI applies filters like the melt to many nodes simultaneously and animates them — instant frame drops; one animated filter graph per view, Safari worst-case.
- Do not ornament to simulate craft: in every case study here, craft removed things (a toolbar chrome, dividers, two alignment rules) rather than adding them.

## Relations

- **desengs-rauno** — Freiberg's inventory of invisible details (Puckett's endorser); complements the 6-flaw audit with web-native detail checks this source doesn't enumerate.
- **desengs-dialkit** — Puckett's own live parameter-tuning tool; the concrete instrument for the "dial everything in" loop described here.
- **desengs-easing** — supplies the exact curves and durations this source's "animations as proof of care" presupposes but leaves unstated.
- **desengs-devouring-details** — a parallel refinement-pass philosophy from another practitioner; pair for a second audit ordering.
- **desengs-shedsgns-taste** — taste as trainable exposure; conceptual range is this source's operational hedge against the same limitation.
