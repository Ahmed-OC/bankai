---
name: desengs-impeccable
description: Use when building, reviewing, or polishing any frontend UI that risks the generic "AI slop" aesthetic. Carries the Impeccable doctrine: modes, anti-pattern bans, and a verifiable quality floor.
source: https://impeccable.style/
category: principle
---

# Impeccable (desengs) — the counter-doctrine against AI-slop frontends

Source: https://impeccable.style/ — Paul Bakaus (github.com/pbakaus/impeccable, Apache 2.0). Self-described as "1 skill, 20 commands, and curated anti-patterns for impeccable frontend design"; the repo now ships 23 commands, all listed below.

## What it is and why it exists

Every AI model trained on the same SaaS-template corpus produces the same tells: Inter everywhere, indigo gradients, icon-tile cards, kickers above headings, bounce easing. Impeccable packages a counter-doctrine: named modes, a command vocabulary, a catalog of anti-patterns with concrete fixes, and a quality floor verified on the built result — never on intentions.

## Core ideas

1. **Boldness.** Go all out. No hedging, no shortcuts. Work should be distinct, beautiful, inspiring. Boring defaults are the enemy, not risk.
2. **The brief wins.** Pinned aesthetics, eras, fonts, and palettes override your taste and any saturation warning. Your habits do not outrank the brief.
3. **Refinement preserves; redesign replaces.** Refining keeps incumbent identity and copy. Redesigning keeps product truth and function but treats the old look as an anti-reference.
4. **Four modes**, chosen from the surface, not the product:
   - *Persuade* — landing/marketing: expression leads.
   - *Operate* — operate-mode products: tools where scanability beats expression (dashboards, editors, IDEs, admin panels).
   - *Read* — docs/articles: structure for comprehension.
   - *Experience* — portfolios/showcases: the artifact leads.
5. **Product truth ≠ visual direction.** Durable facts (audience, purpose, constraints, voice) live in PRODUCT.md; surface choices live in DESIGN.md. A missing DESIGN.md doesn't make a project greenfield.
6. **Bounded verification.** Build fully, then inspect in ONE batched round (desktop + mobile together). Fix everything in one batch, confirm with at most one more round, then stop. Open-ended self-QA burns money and converges worse than the final handoff.
7. **Evidence, not proof.** Clean checks are evidence. Visual and accessibility quality still require human inspection across viewports.
8. **Commit.** When torn between refined and committed, commit.

## The command vocabulary

All prefixed `/impeccable` upstream (`pin` creates standalone shortcuts like `/audit`). Use them as a shared vocabulary for UI work orders.

- **Build:** `init` (product context → PRODUCT.md) · `document` (→ DESIGN.md from code) · `extract` (pull components/tokens into the design system) · `shape` (plan UX/UI before coding) · `craft` (full shape-then-build flow)
- **Evaluate:** `critique` (UX: hierarchy, clarity, emotional resonance) · `audit` (technical: a11y, performance, responsive — scored /20, P0–P3)
- **Refine:** `polish` (final pass, ship readiness) · `bolder` / `quieter` (amplify / tone down) · `distill` (strip to essence) · `harden` (errors, i18n, overflow, edge cases) · `onboard` (first-run, empty states, activation)
- **Enhance:** `animate` (purposeful motion) · `colorize` (strategic color) · `typeset` (fonts, hierarchy) · `layout` (spacing, rhythm) · `delight` (moments of joy) · `overdrive` (technically extraordinary effects)
- **Fix:** `clarify` (unclear copy) · `adapt` (different devices) · `optimize` (performance)
- **Iterate:** `live` (visual variants in the browser)

Grouped use: new surface → `shape` → build → `critique` + `audit` → `polish`.

## Anti-patterns and concrete fixes

Handcrafted CSS/JS; no utility frameworks. All "bans" are defaults — the brief's wording can redeem any of them EXCEPT the kicker (hard ban).

### Page scaffolds

**1. Uniform icon-heading-text cards as page structure.** The lazy container; nested cards are always wrong.
```css
/* Instead of card-per-item, use aligned list rows on a shared surface */
.spec-row { display: grid; grid-template-columns: 16rem 1fr; padding: 12px 0; border-bottom: 1px solid var(--border); }
.spec-row dt { color: var(--muted); }
```

**2. Hero-metric template** (big number, small label, supporting stats, accent color). A filler layout. Redesign the hero around the actual product world — real screenshot, real copy, real workflow.

**3. Kicker/eyebrow label above a heading.** The SOLE unconditional ban. Delete the label; let the heading carry itself.
```jsx
{/* NO: <p class="eyebrow">FEATURES</p><h2>Everything included</h2> */}
<h2>Everything included, nothing more</h2>
```

**4. Section numbers (01 / 02 / 03).** Remove unless the sequence itself conveys needed information.

**5. Modals for tasks needing neither interruption nor protected focus.** Prefer inline, non-blocking UI.
```jsx
// Inline confirmation beats a modal for low-stakes actions
{confirming && <p>Delete this item? <button onClick={doDelete}>Yes</button> <button onClick={cancel}>No</button></p>}
```

### Surface habits

**6. Gradient text.** Emphasis comes from weight or size, never a background-clip gradient.

**7. Glass/blur as decoration.** Blur is legitimate only as a specific, purposeful effect (e.g., a scrim over video), never "to look modern."

**8. Colored left/right borders above 1px** on cards, list items, callouts, alerts. Tint the whole surface instead:
```css
/* NO: border-left: 3px solid var(--primary); */
.callout { background: color-mix(in oklab, var(--primary) 10%, var(--panel)); border: 1px solid var(--border); border-radius: 10px; }
```

**9. Hard offset shadows** (`4px 4px 0 #000`) outside a genuinely neobrutalist world — "a costume, not a depth system." Real depth: offset + soft blur, tinted by shadow of the surface hue.
```css
box-shadow: 0 8px 24px color-mix(in oklab, var(--bg) 60%, black);
```

**10. Sparklines, progress rings, soft-shadowed rounded rectangles standing in for real content.** Ship the real data or omit the decoration.

**11. Monospace as a "technical" costume.** Reserve `monospace` for code, data, and measurement — not vibes.

**12. System display faces (Impact, Arial Black, platform sans) or overused fonts (Inter, Arial, system defaults) as the typographic voice.** The nearest installed font "is a failure, not a fallback." Source and self-host:
```css
@font-face { font-family: "Bricolage Grotesque"; src: url("/fonts/bricolage.woff2") format("woff2"); font-display: swap; }
body { font-family: "Instrument Sans", sans-serif; }
h1, h2 { font-family: "Bricolage Grotesque", sans-serif; letter-spacing: -0.02em; }
```

**13. Unicode glyphs/emoji as icons.** Icons must come from a real library or authored SVG in one consistent stroke and weight:
```jsx
const Icon = { Copy: () => (<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15V5a2 2 0 0 1 2-2h10"/></svg>) };
```

**14. Geometric masks approximating organic contours** (circle/polygon/radial cutouts on photos). Reads worse than no effect; derive a real alpha matte or ship the asset.

**15. Light/dark mode chosen by category convention.** Choose from the use scene: who uses the surface, where, under what ambient light — a tool used for long sessions in a dim room justifies dark. Justify the choice either way.

### Detector-flagged tells (from the 61-rule engine)

- Gray text on colored backgrounds → tint secondary text from the surface hue or foreground, never `#888`.
- Pure black/gray anywhere → always tint: a hue-tinted dark like `#0b0d16` or muted `#8b93a8` is correct; `#000` and `#808080` are not.
- Purple gradients, dark glows, rounded-square icon tile above every heading, bounce easing, line length violations, cramped padding, touch targets under 44×44px, skipped heading levels.

## Quality floor (verify on the built result, never intentions)

- **Contrast:** body ≥ 4.5:1, large text ≥ 3:1.
- **Depth:** shadows have offset + soft blur; a zero-offset colored halo is decoration.
- **Spacing:** tight inside groups, generous between them; MORE space above a heading than below (`margin: 1.4em 0 0.6em`). Verify computed values, don't eyeball.
- **Type:** body measure 65–75ch, display capped at 6rem, tracking floor −0.04em, clear scale/weight jumps, `text-wrap: balance` on headings, real copy at every breakpoint (fix overflow).
- **Motion:** ONE authored moment per surface — not identical entrances per section. Exponential ease-out from an already-visible default; reach beyond transform/opacity into blur, clip-path, shadow when smooth. No bounce/elastic (dated).
```css
@media (prefers-reduced-motion: no-preference) {
  .reveal { animation: rise 480ms cubic-bezier(0.16, 1, 0.3, 1) both; }
  @keyframes rise { from { opacity: 0; translate: 0 8px; filter: blur(4px); } }
}
```
- **States:** hover, disabled, loading, error, empty + real content, keyboard focus (`:focus-visible` on EVERY interactive element), responsive composition.
- **Browser surfaces — the cheapest built-vs-assembled signal:** theme `::selection`, `caret-color`, scrollbars, focus rings, `font-variant-numeric: tabular-nums` on dates/numbers, underline offset. Most often skipped; do it.
- **Copy:** the product's own language; controls name their action ("Generate", not "OK"); errors name problem AND recovery.
- **Coverage:** every requirement present and findable within seconds.

## When to use / When NOT to use

Use when:
- Before shipping any UI change — run the review checklist below.
- A screen "looks AI-generated": uniform cards, gradient text, default fonts.
- Choosing fonts, colors, spacing, motion, or page structure for any new surface.
- Asked to critique, audit, polish, bolden, quiet down, or animate a view.
- Deciding light vs dark mode, or whether something should be a modal.

Do NOT use (or suspend it) when:
- The brief pins a banned pattern — the brief wins; every ban is a default except the kicker, which is unconditional.
- The surface is genuinely neobrutalist — hard offset shadows are then the world, not a costume.
- Asked to refine: refinement preserves incumbent identity and copy; do not import redesign energy (and vice versa).
- A check passed: clean checks are evidence, not proof — stop the loop and hand off for human inspection.

## How to apply (remediation order)

1. **Replace stock fonts** (Inter/Arial/system) with self-hosted distinctive faces — one display + one text — via `@font-face` with `font-display: swap` (anti-pattern 12).
2. **Kill >1px colored side borders** on cards/callouts — swap for a tinted surface with a full 1px border (anti-pattern 8).
3. **Break uniform multi-column card grids**: keep cards only for genuinely selectable options; use labeled rows for secondary info.
4. **Add `:focus-visible` to every interactive element** (buttons, nav, cards, chips) — one shared ring: `outline: 2px solid var(--accent); outline-offset: 2px`.
5. **Theme the browser surfaces**: `::selection` from `--primary`, `caret-color`, styled scrollbars, `font-variant-numeric: tabular-nums` on dates, labels, and counters.
6. **Author ONE motion moment** per surface (e.g. rise + de-blur, exponential ease-out), gated behind `prefers-reduced-motion`. No per-section entrance animations.
7. **Keep uppercase letter-spaced labels above fields** (acceptable metadata) — never introduce eyebrow-over-heading patterns (hard ban).
8. **Audit stock accent colors**: Tailwind indigo `#6366f1` is an AI tell — shift toward the product's own hue (logo/brand territory) or a desaturated brand tone.
9. **Write PRODUCT.md + DESIGN.md** at repo root: product truth (audience, purpose, constraints, voice, mode) vs design language (fonts, tokens, spacing rhythm, motion rule) — so every future UI change has a brief to honor.
10. **Run the review checklist** before each delivery — desktop + 360px in ONE batched round, fix in one batch, confirm once, stop.

### Review checklist (before every delivery)

1. [ ] No kicker/eyebrow label above any heading.
2. [ ] No new uniform card grid; no nested cards; no card added where a row/section would do.
3. [ ] Fonts self-hosted and distinctive; no Inter/Arial/system as the voice; monospace only for code/data.
4. [ ] No gradient text, no decorative blur, no side border > 1px, no hard offset shadow, no purple gradient, no glow.
5. [ ] No emoji/unicode icons; icons are consistent SVG.
6. [ ] All grays hue-tinted; contrast ≥ 4.5:1 body / 3:1 large; nothing pure `#000`/`#808080`.
7. [ ] Spacing: more above headings than below; measure 65–75ch on prose; no cramped padding.
8. [ ] One authored motion moment, ease-out, `prefers-reduced-motion` respected, no bounce.
9. [ ] Every interactive element has hover, focus-visible, disabled; loading/error/empty states exist.
10. [ ] `::selection`, caret, scrollbars, tabular numerals themed from the palette.
11. [ ] Heading hierarchy unskipped; touch targets ≥ 44×44; no horizontal scroll at 360px.
12. [ ] UI copy in the product's real language, actions named, errors actionable.
13. [ ] Detector-level checks pass (evidence, not proof) — then human look across viewports.

## AI-slop warning

How AI typically misapplies this doctrine:
- Applies Persuade-mode expression to Operate-mode products — gradient heroes and delight moments on dashboards where scanability must lead.
- Treats the bans as absolute when the brief redeems them (kicker excepted), or as redeemable when it doesn't.
- Overcorrects into flat, unstyled UI: boldness means a committed identity, not a decoration budget of zero.
- Runs open-ended self-QA loops — "one more pass" — instead of bounded verification; convergence gets worse, cost rises.
- Treats passing detector checks as proof of quality; they are evidence only.
- Refines when asked to redesign, or redesigns when asked to refine — mixing the two destroys either's value.

## Relations

- **desengs-taste** — defines what "distinct and beautiful" actually means; Impeccable demands commitment, taste supplies the judgment.
- **desengs-web-interface-guidelines** — the reference depth behind this floor: interaction, accessibility, and input rules Impeccable only summarizes.
- **desengs-ui-ux-master** — the canon index that routes UI work here; consult it to see which sibling applies to a given surface.

Doctrine in one line: *"When torn between refined and committed, commit."*
