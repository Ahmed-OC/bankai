---
name: rams
description: Use when building or reviewing UI that must survive a taste audit. Fuses Dieter Rams' ten principles with rams.ai's scored design review (348 rules, critical caps) into a ten-question check.
source: https://www.rams.ai/
category: principle
---

# Rams — the ten principles, applied to digital interfaces

Source: https://www.rams.ai/ — a design-eval engine for coding agents by HSLA0001 Inc. ("Agents write UI. Rams judges it."). Named for Dieter Rams, whose ten principles of good design (canonical Vitsoe wording, © Vitsoe) are the site's moral anchor. Site content proprietary; no license granted.

> Note: rams.ai does not restate the ten principles verbatim — it operationalizes the ethos ("Stop bad UI. Kill slop in its tracks."). Below, each principle is quoted in Rams' canonical wording, then translated into digital-UI decisions, with enforcement mechanics drawn from rams.ai's published rule engine (rams.ai/rules) and its free skill (rams.ai/rams.md, ~80,714 installs).

## What it is / Why it exists

Design review does not scale with agent-written UI velocity; unreviewed agents ship slop — "purple-to-pink gradients, glow shadows, vague hero copy, identical filled buttons, the output of unedited prompts."
rams.ai's answer: a reviewer that scores every change 0–100 against 348 rules across 9 categories — "review judgments, not linter rules" — with one whole category (Craft, 38 rules) aimed squarely at AI antipatterns.
The category split, each reviewing like a specialist on a design team: Accessibility 33, Color 27, Typography 43, Spacing 30, Components 22, UX 76, Motion 59, Craft 38, Native 20.
The philosophy is Rams': the engine is a machine for "less, but better" (Weniger, aber besser). This skill is the harness: run a ten-question audit over any design, score it, fix by patch, re-verify.

## The core ideas

### The ten principles, translated to digital UI

**1. "Good design is innovative."**
- Innovation clarifies; it does not decorate. Novelty is justified only when it makes an interaction faster or more understandable (command palette over nested menus; optimistic UI over spinners).
- Bans: shipping unedited prompt output; template residue ("vague hero copy", generic feature-card grids) presented as design.
- Test: a new visual effect is not innovation; a solved interaction problem is. Ask what the novelty makes easier — no answer means cut it.

**2. "Good design makes a product useful."**
- Usefulness includes every state, not the happy path: loading, empty, error, disabled, success (a booking-success page that goes blank with no loading or error state is a real Rams finding on a 49k-star repo).
- Bans: two filled CTAs in one row ("Get Started" + "Learn More" both `bg-white text-black` at equal size — "two primary-weight buttons don't make a hierarchy"); six feature cards with identical weight ("the grid reads as a wall, and the strongest claim never lands").
- Every screen must answer: what is the ONE next action, and what happens when it fails?

**3. "Good design is aesthetic."**
- Aesthetic is execution, not ornament: a spacing scale (4/8/16), one type scale, one gray scale, semantic color tokens.
- The enforced floor: body text ≥ 4.5:1 contrast (computed from actual hex/token values — "label at `opacity-50` lands near 2.8:1" is a real finding); hover and focus states on everything.
- Beauty below the legibility floor is noise; never trade the floor for a mood.

**4. "Good design makes a product understandable."**
- The UI explains itself: semantic HTML, headings in order (h1→h2, no skips), labels on every input, `aria-label` on icon-only buttons (a screen reader announcing just "button" is an understandable-failure).
- A stranger should infer function from structure alone; structure is documentation.
- Bans: `<div onClick>` without role+tabIndex+keyboard handlers; `tabIndex` > 0; information carried by color alone (status = color + icon + text).

**5. "Good design is unobtrusive."**
- Tools recede; the task dominates. Chrome, ornament, and motion all compete with the user's content for attention.
- Digital translation: no decorative gradients, no glow shadows, no autoplay motion; motion communicates state and nothing else.
- Unobtrusive is WHY the Craft bans exist — every ornament is a tax on the user's primary goal.

**6. "Good design is honest."**
- The UI does not manipulate and does not promise what it can't deliver: no fake urgency, no fake activity (progress bars that pretend), no fabricated social proof.
- For AI features this is the core rule: show uncertainty, cite sources, never fake confidence; distinguish "I don't know" from confident wrongness in the interface.
- rams.ai models it in its own product: "the number never claims more coverage than the review had" — sampled repos cap at 98, 100 is reserved for code read end-to-end.
- An honest UI also states what it did NOT check (a11y pass ≠ visual-quality pass).

**7. "Good design is long-lasting."**
- Anti-trend, and therefore anti-slop: the fashionable tell ages in months (purple-pink gradient, glow shadow, glass-everything, hero blobs) — AI slop is trend-chasing at generation speed.
- Long-lasting = systems that survive a re-skin: colors as semantic tokens (inline `#22c55e` "hardcodes a value that should live in tokens" — real finding); spacing from the scale (never arbitrary `pt-[6.5rem]`); components reused, not copy-pasted.
- Test: if a style decision can't be justified without the word "trendy", cut it. A redesign should touch tokens, not screens.

**8. "Good design is thorough down to the last detail."**
- Every interactive element has hover, focus-visible, active, disabled, loading, error — a missing state is a bug, not a polish item.
- `prefers-reduced-motion` honored on every animation ("unguarded motion violates WCAG and leaves motion-sensitive users dizzy or unwell"); dark mode checked, not assumed.
- Details are where agents cut corners — Craft exists for their absence: magic numbers, unused props, overly defensive null checks, copy-paste duplication, shared icons meaning different things (Important and Warning callouts with the identical "!" icon is a real finding).
- Native platforms have their own details: SF Symbols over emoji, Dynamic Type, safe areas, semantic system colors, right-to-left.

**9. "Good design is environmentally-friendly."**
- Rams meant physical resources; the digital translation is compute/data/battery frugality.
- Rules: self-hosted fonts or system stacks ("Inter loaded from third-party CDN delays first text paint" — real finding); animate only `transform`/`opacity` (GPU-friendly); no blur > 20px; no infinite loops; no background video by default; images sized to their layout box.
- Wasted bytes, battery, and CPU are the exhaust of poor discipline; performance here is ethics, not optimization.

**10. "Good design is as little design as possible."**
- Subtractive: fewer type sizes (~5 steps), one gray scale, palette limits, gap over margin, a small z-index scale.
- In a dashboard this bans: more than one primary CTA per view; more than ~3 card treatments; decorative chrome on data; any element that survives "delete it — does anything break?".
- As little design ≠ as little effort: it means removing until only load-bearing choices remain (Rams: "Less, but better").

### The score model (rams.ai's exact mechanics)

- Severity-weighted 0–100 deducted per finding: Critical (breaks core functionality, blocks accessibility, ships visible bugs) — heaviest; Serious (degrades quality, leaks design-system intent, user-facing regressions) — moderate deduction; Moderate (polish/convention) — light, excluded from public view to keep focus.
- **Criticals cap the score: one caps at 59, two at 49, three or more at 39. A score of 60 or above always means zero critical issues.**
- Score bands: 90+ low risk, 75–89 moderate risk, 55–74 elevated, <55 high. The number answers one question: "is this ready to merge?"
- "Measures before it judges": contrast and token usage are computed from the code, not vibes; findings the code cannot evidence are dropped; every critical is re-verified before it can cap; zero findings on clean work is a valid verdict.
- Two-pass pipeline: fast triage across the diff, then a deep line-level review of the highest-risk files.
- Fixes ship as patches the agent applies; a re-review then verifies each resolved finding by name, and the score recovers.
- Out of scope on purpose — don't score what you didn't read: visual aesthetics/brand fit ("taste — yet"), performance (Lighthouse's job), bundle size, backend logic.

## When to use / When NOT to use

Use when:
- Generating or reviewing any UI: new screen, component, or pull request, human- or agent-authored.
- Deciding what to cut from a cluttered or "AI-feeling" design (principles 5/7/10 are the knife).
- Judging AI-generated UI for slop before a human sees it (the Craft questions).
- Setting a merge bar for frontend work: "zero criticals" maps to score ≥ 60.

Not for:
- Backend, business logic, or non-rendering code — out of the model's boundary.
- Brand/marketing aesthetics that need human taste; the score explicitly does not measure taste.
- Performance or bundle audits — dedicated tooling.
- Expressive marketing/motion pieces where ornament IS the product; apply 5/10 only to the page's navigation and core task flows.

## How to apply — the ten-question audit

Run over code plus rendered UI. Each question cites its principle (P#); answer with evidence (file:line); drop unevidenced findings. One pass, then patch, then re-verify.

1. **P4 Understandable:** semantic HTML; heading order intact; every input has a `<label>`/`aria-label`; every icon-only button named (`aria-label="Close"`); no `div`/`span onClick` without role+tabIndex+onKeyDown; no `tabIndex` > 0; no color-only meaning. Criticals live here — they cap the score.
2. **P2 Useful:** every flow defines loading, empty, error, disabled, success; forms validate with visible messages; destructive actions confirm; nothing dead-ends or blanks out.
3. **P3 Aesthetic:** body text ≥ 4.5:1 (compute from real values — `opacity-50` labels fail); touch targets ≥ 24×24px (44×44 recommended); hover AND focus-visible on all interactives; dark mode consistent.
4. **P10 As little design as possible:** one primary CTA per view; type sizes from a scale (~5 steps); one gray scale; spacing from the 4/8 grid — flag every arbitrary value and magic number; gap over margin.
5. **P6 Honest:** no fake urgency, no fake activity, no fabricated provenance; AI output shows uncertainty and sources; empty ≠ spinner; the UI states what it didn't check.
6. **P7 Long-lasting:** zero inline hex — all colors are semantic tokens; no trend tells (purple-pink gradient, glow, glass duplicates); components reused, not duplicated; a re-theme touches tokens only.
7. **P8 Thorough:** enumerate states per component (hover/focus/active/disabled/loading/error); `prefers-reduced-motion` guarded; icons semantically distinct; no unused props, no impossible-state null checks; native platforms: SF Symbols, Dynamic Type, RTL.
8. **P5 Unobtrusive:** no decorative gradient or glow; motion only to communicate state; no autoplay/infinite loops; blur ≤ 20px; no `transition: all` — transition named properties.
9. **P9 Environmentally-friendly:** self-hosted or system fonts; animate `transform`/`opacity` only; images sized to layout; smallest JS that does the job; no render-blocking third-party font CDN.
10. **P1 Innovative:** strip prompt-template residue — vague hero copy, feature-card walls, identical buttons; the screen leads with ITS specific value; if the layout could belong to any product, it fails.

Rate every finding Critical/Serious/Moderate, start at 100, deduct by severity, apply the cap ladder (1 critical → 59 max, 2 → 49, 3+ → 39). Output format (adapted from rams.md):

```
RAMS AUDIT: [target]
CRITICAL (n)  [P# Category] file:line — issue. Fix: <concrete change>.
SERIOUS  (n)  [P# Category] file:line — issue. Fix: <concrete change>.
MODERATE (n)  ...
SUMMARY: n critical, n serious, n moderate — Score: NN/100 (band)
```

Mechanisms for the most common fixes (plain CSS/JS, copy-pasteable):

```css
/* P4: visible focus — never remove outline without replacement */
:focus-visible { outline: 2px solid currentColor; outline-offset: 2px; }

/* P5/P8: guarded motion, named properties */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms; transition-duration: 0.01ms; }
}
.btn { transition: background-color 150ms cubic-bezier(0.22,1,0.36,1), transform 150ms; }

/* P7/P10: tokens, not literals */
:root {
  --space-1: 4px; --space-2: 8px; --space-3: 16px;
  --text-primary: oklch(0.2 0 0);   /* ~16:1 on white */
  --text-muted:   oklch(0.45 0 0);  /* still ≥ 4.5:1 */
}
.card { padding: var(--space-3); border-radius: 8px; }
```

```jsx
// P4: understandable interactive — name, semantics, keyboard
<button aria-label="Close" onClick={onClose}><XIcon className="h-4 w-4" /></button>
// P2/P8: a button with all its states
<button disabled={submitting} className="btn btn--primary">
  {submitting ? <Spinner size={16} /> : null} Save
</button>
```

Then loop like the engine: apply fixes as patches → re-check each finding by name → score climbs; all resolved = clean pass. Zero findings on clean work is a valid verdict — never invent findings to look thorough.

## AI-slop warning

How AI typically misapplies Rams:
- **P10 as "as little effort as possible"** — ships screens missing states and focus styles. Minimalism ≠ incompleteness; subtraction happens AFTER the states exist.
- **P5 as "blank and gray"** — flat monotone walls where every card has identical weight and nothing draws the eye. Visual monotony is a Craft violation, not minimalism: hierarchy is required.
- **P6 structurally violated** — agents fake confidence in AI features, emit placeholder text ("Lorem", "Your text here"), fabricate social proof and loading states.
- **P7 violated at generation speed** — every current trend tell in one page: purple-pink gradient + glow + `transition: all` + emoji standing in for icons.
- **P8 where agents cut hardest** — no disabled/loading/error states, unguarded motion, unused props, magic numbers left in code.
- **P1 inverted** — innovation performed via novelty effects instead of solved interactions.
Loudest slop tells, straight from the Craft category: gradients, glow, `transition: all`, placeholder text, visual monotony, magic numbers, arbitrary radii. If the output could be any product's output, it is slop.

## Relations

- **principles** — broader principle collections; Rams is the sharpest, most subtractive lens; use it as the tiebreaker when principles conflict.
- **taste** — trains the judgment Rams presumes; "as little design as possible" still requires taste to know what to keep.
- **laws-of-ux** — complementary audit: Rams asks "should it exist", Laws of UX asks "how will humans behave"; run Rams first (subtraction), then Laws (prediction).
- **web-interface-guidelines** — the exhaustive rule-level companion; where Rams' ten questions and these guidelines disagree on a detail, the guidelines win on mechanics, Rams wins on direction.
- **you-dont-need-animations** — deepens P5/P8 motion restraint with the full argument for removal; overlaps the no-`transition:all`, reduced-motion, and no-infinite-loop rules here.
