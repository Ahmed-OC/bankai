---
name: desengs-rise-of-de
description: Use when deciding whether and how to fill the design-code gap as a design engineer — post-AI slop checks, learnable taste, the no-handoff model, and the 110% shipping standard.
source: https://www.youtube.com/watch?v=uEMEs499fUs; https://www.warp.co/blog/rise-of-design-engineering
category: essay
---

# The Rise of Design Engineering (desengs) — the talk, distilled

Source: https://www.youtube.com/watch?v=uEMEs499fUs — "The Rise of Design Engineering | Raphael Salaja | MIT Startup Week", talk video on the Warp Design channel (MIT Startup Week; on warp.co Mar 2, 2026; ~112K views). Speaker: Raphael Salaja, design engineer at Warp, based in Ireland (previously Avara, OpenSea, Daybreak). Distilled from the author's own edited essay version of the same talk: https://www.warp.co/blog/rise-of-design-engineering (Aug 5, 2026), mirrored at https://www.raphaelsalaja.com/library/the-rise-of-design-engineering. No explicit license. A video transcript was not retrievable; the essay is the author's authoritative edit of the talk, so quotes below are his published wording.

## What it is / Why it exists

- Thesis: a design engineer "works in code and design as one job" (some teams title it "product design engineer"). The role exists "to fill the gap where quality usually dies, between a static Figma file and what actually ships."
- The forcing function is historical, not stylistic: it has never been easier to ship something functional (AI generates a working site in seconds), so functionality stopped being the differentiator. What separates products now is the layer AI does not produce — judgment, coherency, feel.
- Salaja's prediction: another renaissance, because people can tell generated work from cared-for work even when they can't say why. The design engineer is the person who makes the difference legible.

## The core ideas

### 1. The gap, and why quality dies there

- Most teams split into people who care how things look and people who care how they work. Between them sits a knowledge gap neither side can fully bridge. Quoted: "That gap is where quality dies."
- The gap is bidirectional friction: designers hand off to engineers who lack knowledge of type systems; engineers walk designers through constraints ("this auth flow forces a design change") that reshape the design after it was "done."
- The design engineer is "fluent in both, refusing to treat them as separate": reads the code underneath a Figma file, and takes a backend engineer's rough API and shapes it into something that feels right on screen.

### 2. What the role does day-to-day — two archetypes, one standard

- Last-mile archetype (Salaja's own work at Warp): owns the final stretch between a handed-off design and what ships — fills gaps in the design, pushes beauty further, adds the animation and transitions the mock never specified, critiques built work, improves what he receives. This instinct drove Warp's from-scratch UI rebuild (Warp 2.0).
- Systems archetype (his colleague at Warp): component architecture and codebase quality — a codebase as carefully made as the product, because consistency is what survives scale in startups and large companies alike.
- Design engineers sit on a spectrum between those poles with different strengths, but share one obsession: "how the interface feels." The bar is absolute: "We want everything at 110%." / "No gaps. No 'good enough.'"

### 3. Role boundaries — what a design engineer is NOT

- Not a front-end engineer: a front-end engineer builds exactly what the static design shows. Since most Figma files contain no motion specs, they build what is shown and move on — not wrong, but they treat the file as the deliverable. The design engineer "refuses to let the static design be the ceiling" — the static file is "a floor instead of a ceiling."
- Not a full-stack engineer: breadth across the stack buys shallower depth at the surface layer, which is exactly where the design engineer lives — "the tiny interactions people never name but always feel." Full-stack engineers understandably gloss over these.
- Not a product designer: the designer's work ends in Figma, and "You can't browse a website inside Figma." The design engineer designs the full experience AND ships the code — no handoff at all. Salaja calls skipping handoff the real distinction of the role.

### 4. Why the role is rising now — slop, taste, speed

The talk's premise: it has never been easier to ship something functional, and that is precisely why the role emerged. Three drivers:

- Slop: AI generates a full website in seconds — purple gradients, generic layouts. People sense the missing human hand without being able to name it: bad scroll-driven animation, off layouts, wrong color and copy, "Spacing that's almost fine." The design engineer's job is making sure none of that ships. This is the difference between a product people want to use and one they have to — the want-to/have-to line is the talk's business case for the role.
- Taste: the Rick Rubin analogy. Rubin is present for landmark records without being a trained musician; artists ask him "Is this good or bad?" A design engineer must be that trusted ear — the opinionated voice that says "let's rework this, let's try something else." Opinionated taste is what turns good into special.
- Speed: Salaja built a Web Audio API sound lab with zero sound-design background. What used to mean two weeks of synthesizer research took hours with AI. But the point was not the speed: once AI produced something functional but ugly, taste supplied the color pops and subtle morphing. Quoted: "Speed without taste is still slop. Speed with taste is the whole job."

The three drivers compound: AI collapsed the cost of functional (slop risk up), which moved the differentiator to judgment (taste), which is now applied to a much larger volume of generated drafts (speed). The role is the intersection, not any one of the three.

### 5. Taste is learned — three methods (Salaja started with no design background)

- Study: examine good and bad work (his sources: X and Are.na) and copy pieces one-for-one until sensitivity develops. His benchmark of what years of study buy you: noticing that Linear's nav bar content bleeds slightly outside its container during page transitions (a missing content-visibility wrapper) — offered explicitly not as criticism, since "they ship some of the most considered software out there." Study teaches you to see the detail AND know the fix.
- Take notes: coherency is everything. Mismatched timing or easing curves across an app produce an unnameable "something's off" feeling. Training yourself to notice AND name the inconsistency is what enables fixing it — an unnamed problem is an unfixed problem.
- Build: citing Steal Like an Artist — he copied countless interfaces (never to publish) to internalize the reasoning behind decisions, building a mental archive of when to use springs vs. easing curves, when tight letter-spacing does real work. Quoted: "You learn by doing. If you're not doing, you're not learning."

### 6. What it implies for organizations

- The handoff model is the bug: staffing only designers-who-hand-off and engineers-who-receive guarantees the gap ships slop. Put at least one person whose job description is the gap itself.
- Staff both archetypes or split them consciously: last-mile polish (feel, motion, critique) and systems (component architecture, code quality) are different strengths; a team of only one kind plateaus.
- Making the jump, per the talk: designers already have the eye and need technical fluency — "Go build in Claude or Cursor," start smaller than a full app, until you visualize code the way you visualize a Figma layout. Engineers have the harder technical half (most technical problems are already solved by teammates) and need the eye — relentlessly study favorite products and ask why each choice was made.
- Interview/hiring signal implied by the talk: ask candidates what they notice in a shipped product and whether they can name the fix (the Linear-nav test), not just what tools they use. Sensitivity plus named fixes — not tool lists — is the role's evidence.

### 7. What changes day-to-day for an AI building UI

- Two-pass workflow by default: pass one uses AI for the functional draft (fast, ugly, complete); pass two is the taste pass — color, motion, micro-interaction, detail. Never merge the passes and never skip the second; the draft is the starting point, not the deliverable.
- Treat every received spec (mock, screenshot, prompt) as a floor, never a ceiling: the motion, transition, and empty/error/loading states the spec omits are your job, not an optional extra.
- Run a slop pass on every generated surface using Salaja's own list as the checklist: scroll-driven animation quality, layout correctness, color and copy fit, spacing that is "almost fine."
- Adopt the 110% rule as a stopping criterion: "good enough" and "matches the spec" are not shippable states; there is always one more coherency or feel fix.
- Be the Rick Rubin on your own output: before shipping, ask "is this good or bad?" — and when the honest answer is "fine," rework it rather than shipping it.
- Keep a written decision archive (the "notes" method): every timing/easing/spacing choice gets named and reused, so the next surface inherits the decision instead of re-guessing it.
- Name inconsistencies in review output: an AI review that says "looks good" is useless; one that says "this modal eases out in 150ms but the menu uses 250ms" has converted a felt "something's off" into a fixable defect.
- Never review design in the mock: review in the running artifact, because you cannot browse a website inside Figma — and you cannot feel an interface in a screenshot.

## Mechanisms: making the talk's checks enforceable

Coherency, per the talk, is what users feel as "something's off" when timing/easing drift between surfaces. Enforce it with tokens so drift is mechanically impossible (values below are implementation defaults, not talk quotes):

```css
:root {
  --dur-fast: 120ms;   /* hovers, presses, toggles */
  --dur-base: 200ms;   /* menus, dialogs, reveals */
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1); /* use for one archetype of motion only */
}
/* Every transition in the app consumes these; a literal ms value in a
   component is an unnamed inconsistency — the "something's off" bug. */
.button { transition: background-color var(--dur-fast) var(--ease-out); }
```

The Linear-nav lesson — content escaping its container during transitions — is the class of detail study teaches you to see. The fix pattern:

```css
/* Contain paint + overflow so animated content cannot bleed past its box. */
.nav {
  contain: paint;                /* or layout paint */
  overflow: clip;                /* modern replacement for overflow:hidden */
}
/* If children are virtualized/animated, add the wrapper the detail demands: */
.nav-item { content-visibility: auto; contain-intrinsic-size: auto 48px; }
```

The slop pass, as an explicit gate before shipping any generated surface:

1. Scroll behavior: scroll-driven animation tracks the scroll position exactly; nothing stutters, overshoots, or parallaxes at the wrong rate.
2. Layout: alignment on the grid it claims; no orphaned labels, no near-miss spacing — measure, don't eyeball.
3. Color and copy: palette is intentional (not default purple gradient); copy matches the surface's real states.
4. Coherency: durations, easings, and radii match the tokens and the rest of the app.
5. Feel: hover/press/focus feedback exists on every interactive element; empty/error/loading states are designed, not missing.

## When to use / When NOT to use

Use when:
- Deciding how to staff or behave on the seam between design and code — especially whether to hand off or design-in-code.
- Reviewing AI-generated UI for shippability (the slop checklist above is the minimum bar).
- Defining your own or an agent's stopping criterion for UI work (110%, not "matches spec").
- Structuring learning for someone (human or agent) acquiring taste: study, notes, build.

Do NOT use when:
- The task is backend, infra, or data-layer work — the role is defined by the surface layer; applying 110% polish priorities there is miscast effort.
- A design system with strict locked-down components governs the surface — the systems archetype's consistency rules outrank last-mile novelty (see the flexibility decision in desengs-front-of-front-end).
- Deadline is genuinely now: the 110% standard is a quality bar for shipping products, not a license to gold-plate an internal prototype past its purpose.

## How to apply

1. Classify each UI task by archetype before starting: last-mile (feel, motion, critique of built work) or systems (component architecture, codebase quality) — then apply that archetype's rigor.
2. Treat the incoming design as a floor: enumerate what the static spec omits (motion specs, transitions, states) and decide each one explicitly; "not specified" is a decision you own.
3. Run the slop pass on every screen: scroll-driven animation behavior, layout integrity, color and copy fit, spacing precision — anything "almost fine" gets fixed, flagged, or reverted before ship.
4. Define coherency as tokens (durations, easings, springs) at the root and consume them everywhere; audit for literal values that bypass the tokens.
5. Contain animated containers (`contain: paint`, `overflow: clip`) so content cannot bleed during transitions — the class of bug the talk uses as its sensitivity benchmark.
6. Keep the decision archive: record every named choice (spring vs. easing, tight tracking, timing) with a one-line why; consult it before new surfaces.
7. Critique built work out loud: "let's rework this, let's try something else" — push back on your own first output instead of shipping it.
8. Review only in the running artifact (browser, device), never in the static file.
9. Copy to learn: reproduce one good interface one-for-one (never to publish) per study session; log what the copy taught.
10. Use AI for speed, then do the taste pass by hand: color pops, morphing details, micro-interactions — the generated functional-but-ugly draft is the starting point, not the deliverable.
11. When staffing or agent-role design: assign the gap to a named owner; do not leave it split between "looks" and "works."
12. Stop condition is 110%: no gap between surfaces, no "good enough" state shipped.

## AI-slop warning

- The canonical AI failure is speed without taste: ship the functional-but-ugly draft because it runs. Salaja's exact line — "Speed without taste is still slop" — names this; the slop signature is purple gradients, generic layout, near-miss spacing, and mechanical scroll-driven animation.
- Second failure: treating the spec as the ceiling. An agent that pixel-matches the mock and stops has done the front-end engineer's job, not the design engineer's — the motion and feel layer the spec omits is precisely the deliverable.
- Third failure: unnamed incoherency. Different durations/easings per component, spacing that varies by 1–2px between similar screens — users feel it as "something's off" and the agent can't fix what it never named. Tokens + archive are the countermeasure.
- Inverted failure: using "110%" to justify decoration — gradients and motion bolted on for taste-theater. The talk's standard is coherency and feel, not ornament; opinionated taste includes restraint.
- Do not use the role as an excuse to skip the systems archetype: an agent that ships gorgeous screens into an incoherent, low-quality codebase has moved the gap, not closed it.

## Relations

- desengs-front-of-front-end — supplies the prerequisite split (look-and-feel vs functionality) that made "design engineer" a coherent job; this talk is the role's why-now and day-to-day on top of that split.
- desengs-taste — the underlying argument that taste is real and decisive; this skill adds Salaja's operational method for acquiring it (study, notes, build) and the Rick Rubin "trusted ear" framing.
- desengs-using-ai-as-de — the working method for the speed half; this talk supplies the governing rule that AI output is the starting draft and taste is the mandatory second pass ("speed with taste is the whole job").
- desengs-code-source-of-truth — the artifact argument behind "you can't browse a website inside Figma"; together they ban mock-first review in favor of reviewing in the running code.
- desengs-design-engineers-map — the landscape taxonomy of design-engineering roles; use it to place Salaja's last-mile vs. systems archetypes within the wider field before staffing or self-positioning.
