---
name: ui-wiki
description: Use when implementing or reviewing UI motion, typography, sound, shadows, or interaction latency and you need the exact term, value, or rule for it. Distills userinterface.wiki's 152-rule canon.
source: https://userinterface.wiki/; https://github.com/raphaelsalaja/userinterface-wiki
category: reference
---

# UserInterface.wiki — the encyclopedia of UI terms and components

Source: https://userinterface.wiki/ — Raphael Salaja (@raphaelsalaja). "A living manual for better interfaces": 9 article-length chapters (Laws of UX, 12 Principles of Animation, To Spring or Not to Spring, Mastering Animate Presence, Morphing Icons, Animating Container Bounds, Sounds on the Web, Generating Sounds with AI, Pseudo Elements) with 37 live demos, distilled into an open skill of 152 rules across 12 impact-ranked categories (v3.0.0, March 2026). MIT. Repo: github.com/raphaelsalaja/userinterface-wiki.

## What it is

Not a component-pattern catalog — there is no toast/snackbar or tooltip/popover entry anywhere on it. It is a vocabulary + rule canon for UI *mechanics*: motion timing, exits, pseudo-elements, UI sound, numerals, shadows, UX-psychology thresholds, prefetching. Its value is naming the thing correctly before coding it:

- **spring / easing / none** — the three timing-function families; each has exactly one job.
- **entrance / exit / view-transition / progress** — four motion contexts, four curves.
- **exit / presence / mode** — three layers of one problem: removing an element gracefully.
- **tabular / oldstyle / slashed-zero / fractions** — one numeric variant per context.
- **noise / oscillator** — the two raw materials of UI sound, split by percussion vs tone.
- **trajectory / hover prefetch** — two intent signals separated by 100–200ms.

Every rule is falsifiable: a wrong snippet, a right snippet, and a number — citable at file:line during review.

## The taxonomy (the wiki's own 12 sections, impact-ranked)

| # | Section | Impact | Prefixes | What it settles |
|---|---|---|---|---|
| 1 | Animation principles | CRITICAL | `timing-` `physics-` `staging-` | duration ceilings, :active, squash/stretch, focal point |
| 2 | Timing functions | HIGH | `spring-` `easing-` `duration-` `none-` | which family governs a given motion |
| 3 | Exit animations | HIGH | `exit-` `presence-` `mode-` `nested-` | removal lifecycle, presence modes |
| 4 | Pseudo-elements | MEDIUM | `pseudo-` `transition-` `native-` | decoration without DOM nodes; View Transitions |
| 5 | Audio feedback | MEDIUM | `a11y-` `appropriate-` `impl-` `weight-` | when sound is allowed at all |
| 6 | Sound synthesis | MEDIUM | `context-` `envelope-` `design-` `param-` | Web Audio values (ms, Hz, Q, gain) |
| 7 | Morphing icons | LOW | `morphing-` | 3-line SVG icon system, 14×14 viewBox |
| 8 | Container animation | MEDIUM | `container-` | animating width/height without feedback loops |
| 9 | Laws of UX | HIGH | `ux-` | 23 cognitive laws as build rules |
| 10 | Predictive prefetching | MEDIUM | `prefetch-` | trajectory vs hover vs viewport intent |
| 11 | Typography | MEDIUM | `type-` | OpenType, numeric variants, wrapping defaults |
| 12 | Visual design | HIGH | `visual-` | radius, shadows, spacing scale, alpha borders |

## The core ideas

### 1. Name the motion, then the curve (sections 1–2)

Decision flow from "To Spring or Not to Spring":

1. High-frequency interaction (typing, keyboard nav, rapid toggles) → **no animation**. Keyboard navigation is always instant.
2. User-driven, gestural, interruptible (drag, flick, swipe, dismiss) → **spring**. Springs preserve the hand's velocity on release and re-target mid-flight; easing curves cannot. Balanced params, e.g. `stiffness: 500, damping: 30` — no visible oscillation excess.
3. System-driven state change (open, expand, toggle) → **easing curve**, chosen by direction:
   - entrance → `ease-out` (arrive fast, settle gently)
   - exit → `ease-in`
   - view transition → `ease-in-out`
   - progress/time representation → `linear`; linear anywhere else is a bug
4. "Feels slow" → shorten the duration first; never re-curve to compensate.

Hard duration bands:

| Interaction | Duration |
|---|---|
| press / hover | 120–180ms |
| small state change | 180–260ms |
| any user-initiated animation | ≤ 300ms (CRITICAL) |
| inside presence `mode="wait"` | halve the above (wait serializes exit+enter ≈ doubles elapsed time) |

Physics vocabulary: every interactive element needs a `:active` scale transform; squash/stretch stays in the 0.95–1.05 range; overshoot-and-settle is a spring job, never easing keyframes; stagger < 50ms per item. Staging: one prominent animation at a time; dim the background behind modals/dialogs; animated elements respect existing z-index layers. Context menus: **no entrance animation, exit only** — they must feel summoned, not performed.

Plain CSS has no spring: when motion must be interruptible or carry gesture velocity, a JS spring (or Motion) is the justified dependency; an ease-out transition is the non-interruptible fallback.

### 2. Exits: three words, one lifecycle (section 3)

- **exit** — the removal animation itself; it mirrors the element's `initial` for symmetry.
- **presence** — the wrapper that keeps a departing element mounted until its exit finishes; without it the element vanishes mid-animation.
- **mode** — how presence sequences siblings: `wait` (exit fully, then enter — halve durations), `sync` (simultaneous — invites layout conflicts), `popLayout` (exiting items pop out of flow — for list reordering).

Stack-neutral mechanism: keep mounted → play reverse of entrance → unmount on `transitionend`/`animationend`. Rules that survive any stack: key dynamic lists by identity, never index; disable pointer events on exiting elements; nested removals need coordinated parent/child durations (child finishes within parent); async cleanup completes before unmount.

### 3. Container animation: measure-and-animate, never both on one element (section 8)

Two-div pattern — measuring and animating the same element creates a feedback loop:

```tsx
const [ref, bounds] = useMeasure(); // ResizeObserver inside
<motion.div animate={{ height: bounds.height > 0 ? bounds.height : "auto" }}>
  <div ref={ref}>{children}</div>
</motion.div>
```

- Measure with `ResizeObserver`, not `getBoundingClientRect`.
- Guard `bounds === 0` on first render → fall back to `"auto"` or the element animates from 0 on mount.
- `overflow: hidden` on the animated container during transitions.
- Reserve the pattern for buttons, accordions, small interactive containers — not page layout.
- A small transition delay on the container reads as natural "catching up".

### 4. Numerals: one variant per context (section 11)

| Context | Setting |
|---|---|
| aligned columns — tables, dashboards, pricing, timers | `font-variant-numeric: tabular-nums` |
| numbers inside running prose | `font-variant-numeric: oldstyle-nums` |
| code-adjacent UI (terminals, hashes, keys) | `font-variant-numeric: slashed-zero` |
| fractions in measurements/recipes | `font-variant-numeric: diagonal-fractions` |

Rest of the type section, as rules: `text-wrap: balance` on headings, `text-wrap: pretty` on body; letter-spacing on uppercase/small-caps; `font-synthesis: none` (never let the browser fake bold/italic); `font-optical-sizing: auto`; `font-display: swap` on webfonts; continuous weights 100–900 only with variable fonts; `text-align: justify` only paired with `hyphens: auto`; underline offset clear of descenders; keep `calt` on; stylistic set `ss02` where I/l/1 and 0/O must be distinguished; antialiased smoothing on retina.

### 5. Depth vocabulary (section 12)

Concentric radius — inner radius = outer radius − gap; equal radii nest unevenly:

```css
.outer { --pad: 8px; --r: 8px; border-radius: calc(var(--r) + var(--pad)); padding: var(--pad); }
.inner { border-radius: var(--r); }
```

Layered shadows — 3+ shadows, blur grows, opacity falls; one light source (same offset direction across the whole UI); never pure black; shadow size encodes elevation on one consistent scale:

```css
box-shadow:
  0 1px 2px rgba(0, 0, 0, 0.06),
  0 4px 8px rgba(0, 0, 0, 0.04),
  0 12px 24px rgba(0, 0, 0, 0.03);
```

Borders: semi-transparent color (adapts to any background) over hardcoded hex. Buttons get the six-layer anatomy — outer 0.5px cut shadow, 1px inset ambient highlight, inset top highlight, 3+ layered depth shadows, text drop-shadow, and a gradient subtle enough not to read as one. Animate elevation by transitioning a pseudo-element's shadow opacity, never `box-shadow` itself. Spacing comes from one fixed scale — no arbitrary values.

### 6. UX-law numbers to hard-code (section 9)

- **400ms** (Doherty): every interaction acknowledged on screen within 400ms or it feels slow; past the threshold, fake speed — optimistic updates, skeletons, progress indicators.
- **32px** (Fitts): minimum interactive target; expand hit areas with a pseudo-element (`position: absolute; inset: -8px -12px;`) instead of wrapper markup.
- **5–9** (Miller): chunk information into groups of 5–9 for scannability.
- The non-numeric laws as build rules: minimize simultaneous choices (Hick); reuse familiar patterns (Jakob); accept messy input, output clean (Postel); polish raises perceived usability (aesthetic-usability); four grouping laws — proximity (tighter spacing within groups), similarity (alike looks alike), common-region (boundaries), uniform-connectedness (lines/frames); make the important thing visually distinct (von Restorff); first and last positions win (serial position); end with an explicit success state (peak-end); complexity belongs to the system, not the user (Tesler); show progress and incompletion (goal-gradient, Zeigarnik); simplify forms (Prägnanz); build the critical 20% first (Pareto); disclose complexity progressively; cut extraneous cognitive load.

### 7. Sound: confirmation-only, with exact synthesis values (sections 5–6)

Allowed for: confirmations (payments, uploads, submissions) and errors that must not be overlooked. Banned on: hover, decoration, typing, keyboard navigation, punishment. Non-negotiables: a visual equivalent for every sound; a toggle to disable; respect `prefers-reduced-motion`; independent volume; default gain ~0.3; preload audio; reset `currentTime` before replay. Sound weight and duration match the action — soft click for a toggle, chime for a purchase.

Synthesis vocabulary (Web Audio): one shared `AudioContext` (resume if suspended; disconnect nodes after playback); filtered noise for percussion — clicks are 5–15ms bursts through a bandpass at 3000–6000Hz, Q 2–5; oscillator with pitch sweep for tonal sounds; envelopes use exponential ramps targeting 0.001 (never 0 — undefined math), with the initial value set before ramping; gain always < 1.0.

### 8. Prefetch vocabulary (section 10)

Trajectory prediction beats hover by 100–200ms — it fires while the cursor is still moving toward the target; widen the prediction cone with `hitSlop` (~20px); fall back gracefully on touch (no cursor) and prefetch when keyboard focus approaches; prefetch by intent, never viewport-wide (`prefetch={false}` on ambient links, let prediction decide); deploy only where latency is actually noticeable.

### 9. Pseudo-element and native vocabulary (section 4)

`::before`/`::after` require `content` and a positioned (`relative`) parent; prefer them over extra DOM nodes for decoration; layer with z-index. Native pseudos over custom markup: `::marker` (list bullets), `::first-line`, `::backdrop` (dialog scrim), `::placeholder`, `::selection`. View Transitions: participating elements need a `view-transition-name`, unique while the transition runs, removed after; prefer the API over JS animation libraries; customize via `::view-transition-*` pseudo-elements.

### 10. Morphing icons (section 7, LOW — the author's own system)

Every icon is exactly 3 SVG `<line>`s in one shared 14×14 viewBox; icons needing fewer lines collapse the extras to invisible points, so any icon can morph into any other. Round `stroke-linecap`; grouped rotational variants (e.g. arrows) share base lines and rotate by spring; non-grouped icons jump instantly; SVGs are `aria-hidden`; respect `prefers-reduced-motion`.

## When to use / When NOT to use

Use when: choosing or reviewing timing functions and durations; building removal/reorder lifecycles; animating container size; picking numeric variants for data vs prose; constructing a shadow/elevation or spacing system; adding UI sound; citing UX-law thresholds in review; wiring prefetch.
Do NOT use for: component-pattern naming (toast vs snackbar, tooltip vs popover vs hovercard are not defined here — use a component-gallery skill); full accessibility audits (only audio, reduced-motion, and 32px targets are covered); icon systems you don't intend to rebuild on the 3-line constraint — it is all-or-nothing by design; sections 3 and 8 assume Motion/Framer — in vanilla projects port the mechanism (mount-until-transition-ends, two-div measuring), not the API.

## How to apply (checklist)

1. Classify each animation: high-frequency → none; gesture → spring (`stiffness`≈500, `damping`≈30); state change → easing.
2. Match curve to direction: entrance `ease-out`, exit `ease-in`, view transition `ease-in-out`, progress `linear`.
3. Assign duration: 120–180ms press/hover; 180–260ms small state; ≤300ms everything user-initiated; halve inside `mode="wait"`.
4. Every removal: presence wrapper, exit mirrors initial, key by identity, pointer-events off while exiting, context menus exit-only.
5. Animating size: two-div pattern + `ResizeObserver`, guard the initial 0 with `"auto"`, `overflow: hidden`.
6. Numerals: `tabular-nums` wherever digits align; `oldstyle-nums` in prose; slashed zero next to code; `diagonal-fractions` for fractions.
7. Nesting and depth: inner radius = outer − padding; shadows layered 3+, one light direction, no pure black; alpha borders; one spacing scale.
8. Anything slower than 400ms: optimistic update, skeleton, or progress on screen immediately.
9. Sound only for confirmations and critical errors; gain 0.3 default; visual twin; off-switch.
10. Prefetch by trajectory (hitSlop ~20) where latency hurts; never viewport-wide.

## AI-slop warning

- AI quotes the 300ms ceiling while shipping 600ms modal entrances — the number *is* the rule, not decoration.
- AI copies Motion API names (`AnimatePresence`, `popLayout`) into plain-CSS projects; these rules map to a keep-mounted-until-exit-ends mechanism, not to a required library.
- AI adds hover/keystroke sounds as "delight" — explicitly banned here; sound is confirmation-only with a visual twin.
- AI applies the six-shadow button anatomy to every element; it is for primary buttons, the last 5% of polish, not a base style.
- AI treats "springs feel natural" as license for springs everywhere; the wiki's split is conditional — springs for gestures/interruptible, easing for state changes, nothing for high frequency.
- AI adopts the 3-line icon rule partially (4-line icons "for clarity"), which breaks morphing entirely; it is one author's all-or-nothing system, not a general standard.

## Relations

- **laws-of-ux** — full treatment of section 9's source material; use it for a law's rationale and history, use this skill for the file:line rule and number.
- **easing** — deep dive on the curve vocabulary this wiki compresses into four rules (entrance/exit/transition/linear); adds the curve math the wiki omits.
- **ui-skills** — ibelick's polish baseline overlaps on typography and motion but is stricter ("never add animation unless requested"); where they conflict, that skill governs *whether* to animate, this one governs *how* once animation is justified.
- **number-flow** — animated number transitions; pair its rolling digits with `tabular-nums` so columns stay aligned mid-animation.
- **bankai** — canon index that routes here when a task needs exact values or correct UI-mechanics vocabulary.
