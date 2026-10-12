---
name: desengs-loading-dev
description: Use when any UI wait needs a loading treatment — pick or build the right spinner family, duration, and rhythm for the wait length, or choose a skeleton or progress bar instead.
source: https://loading.dev/; https://github.com/jakubkrehel/loading
category: library
---

# loading.dev (desengs) — crafted loading animations for every wait

Source: https://loading.dev/ — documentation site for `loading-dev` (npm), a loading-indicator library by Jakub Krehel (github.com/jakubkrehel/loading). MIT license, v0.3.x, zero runtime dependencies, requires React 19+. The repo's own vocabulary lives in its `CONTEXT.md` ("motion contract", `ld-` keys) and is quoted here.

## What it is / Why it exists

29 hand-tuned indeterminate loading indicators — spinners, dots, ripples, sweeps, morphs — each shipped as one React component plus one CSS stylesheet. No JS animation loop, no animation framework, no canvas: every indicator is SVG shapes or plain `div`s driven by CSS keyframes.

The gap it fills: the web's default loading state is the same tired gray border-spinner in every button. loading.dev's position is that a wait is a designed moment — the indicator's *rhythm* (period, easing, family) should match the length and mood of the wait. Its two structural opinions:

1. **Motion is a contract, not a prop pile.** Duration, playback, size, and per-child phase are CSS custom properties that cascade — one ancestor declaration can drive a whole subtree of indicators in sync.
2. **The indicator is decorative.** Every spinner root is `aria-hidden="true"`; surrounding UI owns announcing that loading is happening. The library animates; it does not narrate.

## The core ideas

### The motion contract (the part worth stealing in any stack)

Four CSS variables, set on the root element, define every indicator:

- `--ld-size` (px; default 20) — all internal geometry derives from it via `calc()`, so one number scales the whole indicator.
- `--ld-duration` (ms) — every `animation` shorthand uses `var(--ld-duration, <default>ms)`.
- `--ld-play-state` (`running` | `paused`) — wired to `animation-play-state`; pause without JS.
- `--ld-step` (integer, set inline per child) — the child's index in a stagger.

```css
.indicator {
  animation: spin var(--ld-duration, 800ms) linear infinite;
  animation-play-state: var(--ld-play-state, running);
}
```

Precedence: prop on the element, then ancestor variable, then the spinner's own default. An omitted prop leaves the variable unset so an ancestor's value still reaches it. Color rides plain CSS `currentColor` — set `color` once on the root and every shape inherits.

### Inventory — 29 indicators grouped by family, with shipped default durations

The site presents a flat catalog (no duration taxonomy), but each indicator ships a tuned default duration in `SPINNER_MOTION` — the library's own opinion of its energy. Fast = perky inline feedback; slow = theatrical blocking waits.

| Family | Indicators (default ms) |
|---|---|
| Rotating stroke (SVG) | Arc 800, Ring 800, Comet 700, Orbit 750, Dual 1000, Snake 1400, Cascade 1500, Atom 1000, Swirl 1200, Clock 1200, Compass 500, Radar 1500, Eclipse 1200, Loading 1000 |
| Dash-trace (SVG outline) | Trace 1200 |
| Radial fade sweep | Classic 1200, ClassicV2 800, CircularDots 800 |
| Staggered pulse (divs) | BouncingDots 500, LinearDots 900, Wave 900, Leap 1800, Slide 2400 |
| Grid sweep | Blocks 1300 (3x3 grid), Gather 1600 |
| Expanding rings | Ripple 1200, Pulse 1200 |
| Shape morph | Morph 1200 (square↔circle), Flip 1200 |

Shared props on all: `size`, `color`, `duration`, `playState`, `className`. Rotating/stroked ones add `easing` (`linear` | `ease-in-out` | `stacked`) and `cap` (`round` | `flat`); some add family options (`Blocks sweep`: columns/rows/diagonal; `Ripple direction`: in/out; `Wave origin`: bottom/center).

### Family mechanisms in plain CSS/SVG

**Rotating arc** — one SVG circle, one keyframe. The arc is a dash on the circumference: circle r=10 → circumference ≈ 62.8; `stroke-dasharray="18 44.8"` leaves a single 18px open stroke. Dash fraction is the personality dial: small dash = eager Arc; near-full ring fading into its tail = Comet.

```html
<svg viewBox="0 0 24 24" aria-hidden="true">
  <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor"
          stroke-width="2.5" stroke-linecap="round"
          stroke-dasharray="18 44.8" class="arc"/>
</svg>
```
```css
.arc { transform-origin: center;
  animation: spin var(--ld-duration, 800ms) linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
```

**Dash-trace** — same trick, but animate `stroke-dashoffset` along a rounded square: perimeter = `4×(side−2r) + 2πr`; a 16px dash marches around by offsetting exactly one perimeter per cycle (`to { stroke-dashoffset: -62.8 }`). Faint full outline underneath at `opacity: 0.2` shows the track.

**Stagger phase-distribution** — the library's signature formula. N children share one keyframe animation, phase-shifted by *negative* delay computed from the child's step, so the group never shows a visible "start" and motion is continuous from frame one:

```css
.dots { width: var(--ld-size, 20px); height: var(--ld-size, 20px);
  display: flex; align-items: center; gap: calc(var(--ld-size,20px) * 0.2); }
.dot { width: calc(var(--ld-size,20px) * 0.25); aspect-ratio: 1;
  background: currentColor; border-radius: 9999px;
  animation: bounce var(--ld-duration, 500ms) ease-in-out alternate infinite;
  animation-delay: calc(var(--ld-duration, 500ms) * (var(--ld-step) - 3) / 3); }
@keyframes bounce { from { transform: translateY(28%) } to { transform: translateY(-72%) } }
```
Each dot sets `--ld-step: 0 | 1 | 2` inline → delays 0, −1/3, −2/3 of the cycle. This one formula powers dots, Wave (5 bars, keyframe animates `height` 30%↔100%), LinearDots, Leap, Slide.

**Radial fade sweep (the iOS classic, rebuilt)** — 12 bars rotated radially, identical fade animation, phase-distributed by the same formula:

```css
.bar { position: absolute;
  transform: rotate(calc(var(--ld-step) * 30deg)) translate(146%);
  animation: fade 1200ms linear infinite;
  animation-delay: calc(1200ms * (var(--ld-step) - 12) / 12); }
@keyframes fade { from { opacity: 1 } to { opacity: 0.15 } }
```

**Grid sweep (Blocks)** — 3×3 CSS grid; every cell runs `scale(1) → scale(0) at 35% → scale(1)`; each cell's delay index is `row + col` (diagonal), or just `row`/`col` for band sweeps. One keyframe, three sweep geometries from index math alone.

**Expanding rings (Ripple/Pulse)** — 3 absolutely-positioned rings, `scale(0)→scale(1)` while `opacity: 1→0`, `ease-out`, staggered by the formula; `direction: in` is just `animation-direction: reverse`.

**Stacked easing** — the library's one novel curve: two copies of the same rotation composed, one `linear`, one `ease-in-out`, so speed varies without ever stopping:

```css
.stacked { animation-name: spin, spin;
  animation-timing-function: linear, ease-in-out;
  animation-composition: add; }
```

**Reduced motion** — global kill switch plus designed static fallbacks. Kill: `@media (prefers-reduced-motion: reduce) { .ld-x, .ld-x * { animation: none; } }`. Fallback: each family ships a static pose so the indicator stays legible frozen — Ripple rings rest at `scale((step+1)/3)`, Classic bars at `opacity: 0.5`, Blocks cells at `scale(0.8)`, Wave bars at stepped heights. Never reduce to `display: none`: the user still needs to see "busy".

### Choosing the treatment by wait length

loading.dev deliberately does not prescribe this mapping — it ships indeterminate indicators only (no skeletons, no progress bars, no shimmer). The selection logic below is standard practice the skill applies *around* the library:

- **< 100ms**: no indicator. Below perception threshold; any indicator flickers.
- **100ms–1s**: default to no indicator. If one is shown, delay its mount ~500ms so fast responses never flash it.
- **1–4s**: indeterminate indicator — loading.dev's whole domain. Match energy: inline feedback (button submitting, toggling) → 500–900ms family (BouncingDots, Compass, Comet, Arc); blocking single-task wait → 1200ms (Classic, Ripple, Trace); long ambiguous wait where you want motion that doesn't nag → 1600–2400ms (Gather, Leap, Slide).
- **4–10s**: determinate progress bar with real percent or steps. A spinner past ~4s reads as "maybe it's stuck."
- **> 10s**: progress + status text + escape hatch, or background the work and notify on completion.
- **Full page/route load**: skeleton of the actual layout, not a centered spinner — it preserves structure and makes the wait feel shorter.
- **Optimistic actions** (like, star, checkbox): no indicator at all; update instantly, reconcile on failure.

One indicator family per screen; two families on screen at once reads as two different systems.

### Accessibility contract

The spinner is `aria-hidden` and (for SVG) `role="presentation"` — correct, because a spinning glyph means nothing to assistive tech. The obligation transfers to you: pair every indicator with a live region.

```html
<div role="status" aria-live="polite">
  <span class="visually-hidden">Loading results…</span>
  <Arc size={16} />
</div>
```

## When to use / When NOT to use

Use when: a wait is 1–4s, indeterminate, and belongs to a control or region small enough that a spinner is honest about it. Use one family per product so waits feel like one system.

Do NOT use a spinner when:

- The wait is < 1s — render nothing, or delay-mount the indicator.
- The wait has a known extent (upload, export, install) — a determinate progress bar respects the user; a spinner hides what you know.
- Content has a predictable layout (page/route/card) — a skeleton previews structure; a spinner previews nothing.
- The action is reversible and instant-feeling — optimistic UI beats any indicator.
- You cannot pair it with a text alternative — then it is decoration for sighted users only.

Installing the package is justified only for React 19+ apps wanting all 29 maintained components for free. Everything above is ~30 lines of CSS/SVG per indicator under MIT — for one or two indicators, or any non-React stack, port the mechanism (the snippets above are the whole library minus the JSX).

## How to apply

1. Measure or estimate the real wait (p95, not average). It, not taste, picks the family: none / spinner / progress / skeleton.
2. Pick one indicator family for the product; record its name and default duration as a token (e.g., `loading: arc, 800ms`).
3. Scale by context: 16px inline in buttons next to their label, 20px default, 32–48px for blocking regions.
4. Set `color: currentColor` wiring so indicators inherit text color — one gray-level decision made once.
5. Delay-mount indicators at ~500ms so sub-half-second responses never flash.
6. Add `role="status"` + visually-hidden text beside every indicator; keep the indicator itself `aria-hidden`.
7. Include the reduced-motion static pose in whatever you port — never only `animation: none`.
8. If pausing is a feature (e.g., pause offscreen indicators), use `animation-play-state` via one cascading variable, not per-node JS.
9. Verify the loop has no visible start: staggered children must use the negative-delay formula, not `for i in n: delay = i * 100ms`.
10. Kill the indicator the frame data arrives — a spinner outliving its data by 300ms is a bug.

## AI-slop warning

The cliché this library exists to kill, AI recreates in one move: putting the same 16px border-spinner (or the same `<Arc>`) in every button, every table, and every page — "spinner cursor" thinking with nicer code. Poisoned contexts: dashboards where six identical spinners race; spinners on sub-second actions (flicker); spinners over full-page loads (hides that you know the layout); centered 24px spinner as the entire mobile route transition. Other failure modes: porting the component but dropping the `aria-hidden` + live-region pair; shipping motion without the reduced-motion pose; mixing three families on one screen; animating a progress bar to 90% and stalling (fake progress is a lie with extra steps). And the inverse slop: reaching for this library when the honest answer is no indicator at all.

## Relations

- **desengs-easing** — same timing-curve discipline; loading.dev's `stacked` easing (`animation-composition: add`) is an advanced case of it.
- **desengs-transitions** — entry/exit motion vs waiting motion; both should share one duration scale per product.
- **desengs-thinking-orbs** — the AI-generation wait specifically: branded thinking states instead of a generic spinner.
- **desengs-you-dont-need-animations** — the counterweight: most waits need less motion, not more; read it before adding indicator #2.
- **desengs-magic-ui** — when a wait indicator should be one effect inside a broader animated component system.
