---
name: desengs-krehel-skills
description: Use when reviewing or refining UI typography, colors, layout, motion or microcopy — distills the jakubkrehel/skills collection into exact rules, values and plain-CSS mechanisms for any interface polish pass.
source: https://github.com/jakubkrehel/skills
category: principle
---

# Desengs Krehel Skills (desengs) — interface craft as checkable rules

Source: https://github.com/jakubkrehel/skills — Jakub Krehel's "A collection of agent skills that help you build great interfaces" (MIT), listed on desengs.com. The repo ships 11 skills; this file captures each one, organized by domain, with plain-CSS mechanisms (artisanal CSS — no framework dependency; port to any stack).

## What it is / Why it exists

| Skill | Owns |
| --- | --- |
| `better-typography` | Type scale, spacing, wrapping, truncation, variable fonts, OpenType |
| `better-colors` | Palette ramps, semantic tokens, contrast, gamut, dark mode |
| `better-layout` | Grouping, alignment, reading order, adaptivity, growth |
| `better-ui` | Concentric radius, surfaces, icons, hit areas, animations, performance |
| `better-accessibility` | Native elements, focus, keyboard, forms, reduced motion |
| `better-writing` | Voice, verb-first buttons, errors, empty states |
| `better-interface` | Cross-domain review orchestrator: severity, cap, verdict |
| `interface-review` | Change-scoped review (Introduced / Regression / Pre-existing) |
| `explain-interface` | Explains how an effect/site was built (measured/derived/inferred) |
| `break` | Renders one component in every state on a throwaway page |
| `variant` | Builds 3 variants differing on ONE axis, hosted in the real page |

Review order (foundational failures must not hide behind polish): accessibility → layout → writing → typography → colors → UI polish. The bar for reporting is **evidence, not taste** — a deliberate project choice you merely disagree with is not a finding. Prefer the cheaper fix, in order: delete → use the platform → reuse what exists → correct the value → add something new.

---

## The core ideas

### 1. Typography

"Typography is mostly restraint: a sensible scale, comfortable spacing, enough contrast." Read the rendered page, not just the code — bad wrapping and truncation only appear at real content lengths.

**Fonts.** Serve `.woff2`. Use CSS properties over raw axis tags (`font-weight: 650`, not `font-variation-settings: "wght" 650`). Load the real weights — browsers synthesize missing faces and distort the design. Rarely more than three fonts; pair for contrast (serif headline over sans body reads as deliberate, two similar sans-serifs as a mistake). Below `18px` stay at weight `400`+; weights under 300 are display-only at `28px`+.

**Type scale with semantic names** — a small set of sizes; bundle size + line-height + weight into roles so one decision covers one role:

```css
:root {
  --text-body: 400 1rem/1.5 var(--font-sans);         /* 16px */
  --text-caption: 400 0.8125rem/1.4 var(--font-sans); /* 13px */
  --text-heading: 600 1.125rem/1.3 var(--font-sans);  /* 18px */
  --text-title: 600 1.5rem/1.2 var(--font-sans);      /* 24px */
  --text-display: 600 2.25rem/1.1 var(--font-sans);   /* 36px */
}
```

Emphasis within a role is one weight step up (400 → 500), never a size change. Rules:

- Heading sizes descend with level; a heading is never smaller than body text unless it is an intentional overline label. Adjacent levels may share a size if weight/spacing differs.
- Line-height by role: headings ~`1.1`, body `1.5`–`1.6`, unitless. Anything wrapping to 3+ lines needs at least `1.4`.
- Letter-spacing by size: large headings `-0.02em`; small uppercase labels `0.05em`; body none.
- Cap the measure at **60–75 characters** (`max-width: 65ch` measures it directly).
- Wrap deliberately: `text-wrap: balance` on headings, `text-wrap: pretty` on descriptions, `overflow-wrap: break-word` where long links/IDs escape, `white-space: nowrap` on labels. Skip balance/pretty on long-form text.
- `font-variant-numeric: tabular-nums` on any value that changes (timers, counters, prices).
- Truncate without losing content: one line = ellipsis + `overflow: hidden` + `white-space: nowrap`; several = `line-clamp`. Keep the full value reachable when it matters.
- Store copy in natural case, present with `text-transform`. Smart punctuation: curly quotes in prose, en dash for ranges (`2010–2020`), single `…`, `&nbsp;` inside `16 px`, `&shy;` for long-word breaks.
- Underlines from the font: `text-underline-position: from-font` + `text-decoration-thickness: from-font`; dotted underline signals extra info. Only color animates reliably in `text-decoration` — build animated underlines as separate elements.
- Inputs at `16px` on mobile (iOS Safari zooms below). Floors: body 16px, inputs/menus 14px, captions 13px, rarely below 12px.
- Font smoothing once on the root (`-webkit-font-smoothing: antialiased` + `-moz-osx-font-smoothing: grayscale`). Set `lang`/`dir`; isolate mixed-direction values with `<bdi>`. `text-box: trim-both cap alphabetic` trims font whitespace in buttons/badges (progressive enhancement).

### 2. Colors

"A color system is a small set of ramps, named by role and verified against the backgrounds they actually render on." Never report a contrast value you did not measure; never estimate a color you could compute.

**A system is ramps, not colors.** One neutral ramp (carries 80–90% of the interface), one accent ramp, and only the status ramps the product renders (danger/warning/success/info). A second accent hue earns its place only when two things must be distinguishable at a glance.

**Two tiers.** Primitives name a value (`--indigo-500`) and are never applied in components; semantics name a job and are the only tier components touch — that seam is what makes theming and dark mode possible:

```css
:root {
  /* Tier 1: primitives (never used directly) */
  --indigo-500: oklch(0.585 0.233 277.117);
  /* Tier 2: semantics (what components use) */
  --color-accent-solid: var(--indigo-500);
  --color-bg-surface: oklch(0.18 0.02 275);
  --color-text-secondary: oklch(0.65 0.02 275);
}
```

Grammar: `--color-{role}-{variant}-{state}`. One word per concept: `text`, `bg`, `border`, `accent`. Reserve `accent` for the brand; `primary` means "most prominent of its group" — never both.

**Every step has a job** (Radix defines its 12 steps by role, so role-mapped steps survive theme changes — prefer this model for new systems):

| Role | Radix | Tailwind |
| --- | --- | --- |
| Page bg / subtle bg | 1–2 | 50 |
| Component bg / hover / active | 3–5 | 100–200 |
| Subtle border / border / strong border | 6–8 | 200–400 |
| Solid fill / fill hover | 9–10 | 500–600 |
| Low-contrast / high-contrast text | 11–12 | 700 / 900 |

**Well-formed ramp:** even steps in *perceived* lightness, constant hue end to end, vividness peaking mid-ramp, steps denser at the light end, both ends short of pure black/white. Generate with a library, never by eye:

```js
import { formatHex, interpolate, samples } from 'culori'
const ramp = interpolate(['#eff6ff', '#3b82f6', '#172554'], 'lab')
const steps = samples(11).map((t) => formatHex(ramp(t)))
```

**Usage:** one color, one meaning (hues within `15°` read as the same color; if accent means interactive, that hue on static text misleads). Fill exactly one action per view — color on the background, not the label. Status is never the only signal: pair it with an icon or text, and keep status hues distinct from the accent.

**Contrast** — measure the rendered pair (against the actual card/overlay behind it), then report; don't repaint. APCA is the better default: body text Lc 75+ (prefer 90), non-body Lc 60+, large text (≥36px) Lc 45+, UI components Lc 30+, discernibility floor Lc 15. WCAG 2 for legal gates: 4.5:1 normal text, 3:1 large text and UI. Fix failing pairs by **lightness, not hue**. The light/dark-text crossover sits around 73% perceived lightness — higher than intuition suggests.

**Dark mode** is not a reversed light palette. Swap semantic roles first, then: reduce vividness a step or two (confident on white reads neon on near-black), widen separation at the dark end, recheck every pair (APCA is polarity-aware — a pair passing in light mode can fail reversed). Pick ONE switching mechanism — `prefers-color-scheme`, a `.dark` class, or `light-dark()` with `color-scheme` set — never a mix:

```css
:root {
  color-scheme: dark; /* or light dark */
  --color-bg: light-dark(oklch(0.98 0.003 275), oklch(0.14 0.015 275));
}
```

**P3:** declare the sRGB value first, override inside `@media (color-gamut: p3)`; a P3 color with no fallback is a HIGH finding — it fails, it does not degrade. **Gradients:** interpolation space is a look, not a correctness setting — `in oklab` is the default (even brightness), `in oklch` stays vivid but arcs around the hue wheel, sRGB mutes the midpoint; a gradient going gray mid-way needs a polar space or a middle stop.

### 3. Layout

"Position, spacing and alignment carry hierarchy before a word is read."

- **Group with space, not lines.** Preference order: negative space → background shapes → separator lines (last resort, dense data only). The gap between groups is at least 2× the gap within one: `8px` inside a group → `16px`+ between groups.
- **Keep controls distinct from content:** every interactive element gets a background, border, underline, or a consistent control zone.
- **Align to shared edges.** Every stray edge is noise; one spacing step per level of subordination (`16px` default). Numbers align trailing in tables, text leading, with tabular figures.
- **Logical properties**, not physical, so layouts mirror in RTL: `margin-inline-start`, `padding-inline-end`, `inset-inline-start`, `text-align: start`. Physical left/right only for genuinely physical geometry (notches, gestures).
- **Order by importance:** most important content top + leading edge; identifying content leads a row, metadata and actions trail. One primary action per view; secondary actions behind a menu.
- **Breathing room:** `12px` between adjacent bordered/filled controls; `24px` around borderless text/icon-only controls; `24px`+ between unrelated groups.
- **Content bleeds, controls float:** backgrounds and media reach viewport edges; text and controls stay inside layout margins and safe areas.

```css
/* Full-bleed media inside a constrained column */
.article { display: grid; grid-template-columns: 1fr min(65ch, calc(100% - 48px)) 1fr; }
.article > * { grid-column: 2; }
.article > .full-bleed { grid-column: 1 / -1; }

/* Inset action bar, safe-area aware */
.action-bar { padding-inline: 16px; padding-bottom: calc(16px + env(safe-area-inset-bottom)); }
```

- **Progressive disclosure needs a visible affordance:** let the next item peek `16–32px` past a scroller edge, or show a labelled disclosure control ("Show 12 more results").
- **Hold structure until it breaks.** Breakpoints come from the content, not device presets (768/1024 are not rules); collapse late; prefer container queries for component adaptation; test smallest and largest sizes first.
- **Plan for growth:** no fixed width/height on text containers; buttons size from their label via `padding-inline`; translated strings grow (short ones proportionally more); test with pseudo-localization. Never park a critical action where resizing or scrolling clips it.

### 4. Animations & UI polish

Every duration, curve and scale below is a specific value, not a range — `cubic-bezier(0.2, 0, 0, 1)` is not `cubic-bezier(0.4, 0, 0.2, 1)`, and `0.96` is not `0.95`. Review motion at 10% speed: what feels off slow is subtly wrong at full speed.

**Interruptible animations.** CSS transitions for interactive state changes (they retarget mid-flight); keyframes only for one-shot staged sequences:

```css
/* Good: clicking again mid-animation smoothly reverses */
.drawer { transform: translateX(-100%); transition: transform 200ms ease-out; }
.drawer.open { transform: translateX(0); }
```

**Scale on press:** exactly `scale(0.96)`, never below `0.95`; `150ms ease-out` on `transition-property: scale`. Provide a `static` opt-out where motion distracts.

**Enter animations — split and stagger** (infrequent entrances only: first load of a hero, success/empty states; never stagger hovers, keystrokes, tab switches). Split into semantic chunks (title / description / actions), stagger ~100ms; titles may go per-word at ~80ms:

```css
.stagger-item { opacity: 0; transform: translateY(12px); filter: blur(4px);
  animation: fadeInUp 400ms ease-out forwards; }
.stagger-item:nth-child(2) { animation-delay: 100ms; }
.stagger-item:nth-child(3) { animation-delay: 200ms; }
@keyframes fadeInUp { to { opacity: 1; transform: translateY(0); filter: blur(0); } }
```

**Exits are softer than enters:** small fixed `translateY(-12px)` + fade, `150ms ease-out` — never full-height slides or dramatic scale-downs. Skip the exit entirely when motion adds no context.

**Contextual icon animations:** animate opacity + scale + blur with exact values — scale `0.25 → 1`, opacity `0 → 1`, blur `4px → 0px`, spring `duration: 0.3, bounce: 0` (bounce is always 0). Without a motion library, keep both icons in the DOM (one absolutely positioned) and cross-fade with `cubic-bezier(0.2, 0, 0, 1)` — never add a dependency for this.

**Surfaces:** concentric border radius — `outerRadius = innerRadius + padding` (past `24px` of padding, treat layers as separate). Shadows for elevation, borders for structure: layered transparent shadows replace depth-borders, never dividers or input outlines:

```css
:root {
  --shadow-border:
    0 0 0 1px oklch(0 0 0 / 0.06),
    0 1px 2px -1px oklch(0 0 0 / 0.06),
    0 2px 4px 0px oklch(0 0 0 / 0.04);
}
/* Dark mode: one white ring — layered depth is invisible on dark */
.dark { --shadow-border: 0 0 0 1px oklch(1 0 0 / 0.08); }
```

Image outlines: `outline: 1px solid oklch(0 0 0 / 0.1)` (light) / `oklch(1 0 0 / 0.1)` (dark), `outline-offset: -1px`; pure black/white only — a tinted neutral reads as dirt on the image edge. Optical alignment: icon-side padding = text-side − 2px; play triangles nudge `translateX(2px)`; fix asymmetric icons in the SVG itself when possible.

**Icons:** stroke matches text weight on a 24px grid — `1.5px` beside regular (400), `2px` beside semibold (600), `2.5px` beside bold. One SVG with `currentColor`, states via CSS color/opacity, never separate assets. Outline = default, fill = active/selected. Size `1em`–`1.25em` inline with text; test at the smallest render size (16px).

**Performance & restraint:** never `transition: all` — name exact properties (`transition-property: scale, opacity`). `will-change` only for `transform`/`opacity`/`filter`, only once first-frame stutter appears. High-frequency interactions get instant feedback or ≤150ms on opacity/color, and every animated state change needs a static cue (color, icon, label) — motion is never the only feedback channel. Suppress transitions during a theme switch: inject `*,*::before,*::after{transition:none !important}`, force a reflow (`document.body.offsetHeight`), remove on the next frame.

### 5. Cross-cutting: accessibility, writing, review workflows

**better-accessibility:** native elements first (`<button>`, `<a href>` — never `<div onClick>`; no ARIA is better than bad ARIA). Style `:focus-visible` with a ≥2px solid perimeter verified against every adjacent color. Hit areas: 24×24px WCAG baseline; aim 44×44 touch / 40×40 desktop; extend with a pseudo-element; never overlapping; decorative layers get `pointer-events: none`. Every input has a `<label for>`; a placeholder is never a label. Validate on submit (button stays enabled), mark `aria-invalid`, point `aria-describedby` at the inline error, focus the first invalid field. Modals: `inert` background, trap and restore focus, `overscroll-behavior: contain`. Motion wrapped in `prefers-reduced-motion: no-preference`. The page survives 200% zoom and reflows at 320px.

**better-writing:** clear and brief beats clever; consistent beats varied. Verb-first buttons ("Send", "Delete project" — never "OK!" or bare Yes/No on consequential actions); confirmations repeat the consequence. Errors say how to fix, beside where it broke ("Choose a password with at least 8 characters", not "Invalid name"). Empty states orient and point forward (what this place is + one next action). Placeholders are examples (`name@example.com`), never labels. Toggles describe the ON state. One capitalization policy (sentence case is safest). Links describe their destination, never "Click here"; suffix every "Learn more".

**better-interface (orchestrator):** cap 15 findings, one row per root cause. Escalation triggers are HIGH on sight: no accessible name, no visible focus, pointer-only control, motion ignoring reduced-motion, clipped at 320px/200% zoom, failing contrast pair, meaning by color alone, destructive action without confirmation, unreachable truncated content, uncued hidden content, unrecoverable error, semantic color against its meaning.

**interface-review:** reviews the *change*, not the codebase ("did I make this worse?"). Every finding is `Introduced`, `Regression`, or `Pre-existing` (max 3 pre-existing, outside cap and verdict). Read the `-` side of the diff — regressions are invisible post-change.

**explain-interface:** every claim is Measured (read off the page), Derived (computed), or Inferred (judgement, never stated as fact). Effects are layer stacks in paint order; close on the transferable recipe, not a rebuild snippet. **break:** stress-tests ONE component on a throwaway page — every scenario in one column, one look, report what visibly broke with its owning domain skill. **variant:** builds 3 variants differing on one axis (structure, density, emphasis, type, voice), hosted in the real page behind a `?variant=` picker; quality floor = escalation triggers cleared; present tradeoffs and let the user pick.

### Anti-patterns

| Anti-pattern | Fix |
| --- | --- |
| Hard-coded font sizes, no scale | Named scale; heading levels map to descending steps |
| Thin weight (<300) under 18px | Weight 400+ below 18px; thin is display-only |
| `leading-none` on text wrapping 3+ lines | ≥1.4 on anything past two lines |
| Justified interface text | `text-align: start` |
| Raw color literals in components | Semantic role tokens; primitives never applied directly |
| Token named for appearance (`--color-blue-button`) | Name by role: `--color-accent-solid` |
| Ramp built by varying HSL lightness | Perceived lightness (OKLCH/Lab), constant hue |
| Ramp spaced evenly full-range | Denser light end; 50 and 100 must read as two surfaces |
| Contrast "fixed" by changing hue | Change lightness — the channel contrast responds to |
| Dark mode = reversed light palette | Swap roles, lower vividness, widen dark end, remeasure |
| Mixing `prefers-color-scheme` and `.dark` for different tokens | One switching mechanism |
| Uniform spacing compensated with divider lines | Inter-group gap ≥ 2× intra-group; lines last |
| `margin-left` / `text-align: left` | Logical properties (`margin-inline-start`, …) |
| Breakpoints at 768/1024 by default | Break where content stops fitting; container queries |
| Fixed-width buttons sized to one language | `padding-inline` sizing; pseudo-localization test |
| Same radius on nested card + inner element | Concentric: outer = inner + padding |
| `transition: all` | Name the exact properties |
| Keyframe animation on an interactive toggle | Interruptible CSS transition |
| Dramatic exit (full height, scale 0.5, 400ms) | `-12px` + fade, 150ms ease-out |
| Icon hairline (1.5px) beside bold text | Stroke 2px+ beside weight 600+ |
| Icon-only button with no `aria-label` | Descriptive accessible name |
| Submit disabled until the form is valid | Validate on submit; focus the first error |
| "Oops! Something went wrong." | State what failed and how to recover, beside the field |

---

## When to use / When NOT to use

**Use when:** polishing or reviewing an existing interface (type, color, spacing, motion, microcopy); defining design tokens, type scales, palette ramps, or dark mode from scratch; running a UI review pass and needing severity rules and a findings cap; deciding animation values, icon strokes, radii, or elevation; auditing a diff for regressions.

**Do NOT use when:** a design system already governs the project — apply its tokens, never fork values from here; the task is brand/visual identity exploration, where these constraints are guardrails, not the brief; the surface is not the web platform (native HIGs override hit targets, focus, and motion values); you cannot verify a finding by measurement — unmeasured "improvements" violate the collection's own evidence bar.

## How to apply

1. **Audit before changing:** read the rendered page at real content lengths; inventory font sizes, color literals, radii, spacing steps. Fix foundational-first: accessibility → layout → writing → typography → colors → UI polish.
2. **Type scale:** adopt the role-based scale from §1 as custom properties; body at 16px; headings map to descending steps; `-0.02em` on display, `0.05em` on uppercase labels; at most 3–4 weights loaded.
3. **Tabular numbers:** `font-variant-numeric: tabular-nums` on every value updating in place (IDs, percentages, timestamps, counters).
4. **Two-tier tokens:** keep the brand hue, convert to OKLCH; build a neutral ramp tinted toward the accent hue ("enough to measure, not enough to name"), one accent ramp, and only the status ramps actually used. Components touch semantics only.
5. **Dark palette:** if dark-first, drop solid-fill vividness one or two steps (neon risk), hold hue constant, widen lightness separation between surfaces; one switching mechanism; verify every text pair with APCA (body Lc 75+) against its actual surface, not the page background.
6. **Spacing rhythm:** 2× rule between groups (8px inside → 16px+ between); 24px between unrelated groups; inputs `font-size: 16px` on touch (iOS zoom); captions never below 12px.
7. **Focus:** `:focus-visible` with a ring token, verified against every adjacent surface.
8. **Buttons and radii:** exactly one filled primary per view; press `scale(0.96)` at `150ms ease-out`; concentric radii — audit any mixed radius values down to 2–3 steps.
9. **Elevation:** layered shadow-border tokens replace extra borders on elevated cards; keep real borders on inputs (structure/a11y) and genuine separators.
10. **Motion budget:** at most one choreographed entrance per view (stagger 100ms, wrapped in `prefers-reduced-motion: no-preference`); everything else stays instant in high-frequency tools.
11. **Microcopy pass:** verb-first buttons; errors state the fix beside the field, wired to `aria-invalid` + `aria-describedby`; empty states orient and point forward; sentence case everywhere.
12. **Stress-test before shipping:** `break`-style harness per component (unbreakable 60-char strings, empty lists, longest realistic labels, 320px width, 200% zoom); `variant` (3 variants, one axis) before any redesign decision.

## AI-slop warning

AI misapplies this collection in predictable ways. It treats the exact values as ranges ("~0.96", "about 150ms", the generic `cubic-bezier(0.4, 0, 0.2, 1)`) — the values ARE the content. It sprinkles staggered entrance animations on every mount, hover and tab switch instead of infrequent entrances. It "fixes" contrast by shifting hue instead of lightness, and reports contrast numbers it never measured. It names tokens by appearance, rebuilds with new dependencies when delete → platform → reuse would do, and adds findings based on taste after the evidence runs out. It also applies all rules simultaneously with maximum severity, flattening deliberate contrast (a display weight under 300, a divider in dense data) into uniform compliance — §1's own words apply: typography is mostly restraint, and so is review.

## Relations

- **desengs-practical-typography** — deepens §1: the practical-typography source behind measure, leading, and scale decisions; use it when type needs theory, not just values.
- **desengs-oklch** — the color-space mechanics under §2 (perceived-lightness ramps, contrast by lightness, `in oklch` gradient interpolation); contradicts nothing here, supplies the why.
- **desengs-jakub-kr** — Krehel's own portfolio: the design signature these skills formalize, and which parts are personal taste rather than rule.
- **desengs-interfaces-dev** — the broader interface-craft canon this collection extends; overlapping coverage of focus, motion and layout at different granularity.
