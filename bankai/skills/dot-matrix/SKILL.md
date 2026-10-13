---
name: dot-matrix
description: Use when a UI needs a loader for an indeterminate wait (generation, rendering, synthesis, processing) or a generic spinner feels dishonest. Expressive dot-grid choreography in plain CSS, zero dependencies.
source: https://dotmatrix.zzzzshawn.cloud
category: library
---

# Dot Matrix — expressive dot-grid loading states from one keyframes and many delays

Source: https://dotmatrix.zzzzshawn.cloud — open-source loader library by shawn (repo `zzzzshawn/matrix`),
React + shadcn-registry components you own as local code.

## What it is / Why it exists

[Dot Matrix](https://dotmatrix.zzzzshawn.cloud) is an open-source library of **55+ dot-matrix loaders** —
"expressive loading primitives you install via the shadcn registry and own as local code". Installing one
item (`npx shadcn@latest add @dotmatrix/dotm-square-3`) drops the source into your repo; there is no
runtime dependency. It exists because a bare spinner carries zero information: during a 90-second wait a
rotating arc reads as "frozen". Loading states deserve deliberate craft — the library's goal is to "ship
loading states that feel designed, lightweight, and easy to maintain", as "expressive loading primitives
for modern React interfaces without a full design framework". It "stays compact on purpose" and the
loaders "blend into your existing UI language instead of forcing a separate aesthetic".

Every loader family shares one visual grammar: a **5x5 (or 3x3) grid of tiny dots** whose choreography is
expressed through named pieces like Neon Drift, Core Spiral, Rail Scan, Frame Chase, Echo Rings, Comet
Trail, Lunar Breathe, Hourglass Flip, CRT Glide, Glyph Flip, Sound Bars.

The registry targets Tailwind + shadcn `components.json`; the mechanism itself is plain CSS and ports
cleanly to any stack — this skill keeps the technique dependency-free (below), honoring the library's
own ownership philosophy: the code is yours.

## The core ideas

- **Real CSS grid, per-dot custom properties.** Every dot is a `<span>` carrying its geometry:
  `--dmx-distance` (from center), `--dmx-row` / `--dmx-col`, `--dmx-angle`, `--dmx-manhattan`, plus
  per-pattern ordering vars (`--dmx-path`, `--dmx-ripple-ring`, `--dmx-spiral-order`).
- **One shared `@keyframes` per animation family; the choreography lives entirely in per-dot
  `animation-delay`.** Canonical form from the manual-setup docs:
  `animation-delay: calc(var(--dmx-path, 0) * 0.2333 * var(--dmx-cycle) * var(--dmx-speed, 1))` —
  a normalized position variable (0..1) times the cycle duration.
- **An opacity triplet keeps the grid "alive" but quiet**: base `0.16`, mid `0.32`, peak `1`
  (`--dmx-opacity-base/mid/peak`). The grid reads as a designed shape even when paused.
- **Only `opacity` and `transform` animate — never layout.** GPU-friendly, jank-free even during heavy
  main-thread work.
- **One base cycle (`--dmx-cycle: 1500ms`) and an inverse speed multiplier** (`speedScale = 1 / speed`)
  scale duration without touching keyframes.
- **Patterns mask participation**: `diamond`, `full`, `outline`, `cross`, `rings` select which of the 25
  dots exist. Dot shapes: circle / square / diamond / heart. Color presets include gradients (sunset,
  ocean, neon, aurora); a bloom/halo is layered `drop-shadow`.
- **Accessibility is built in**: `role="status"`, `aria-live="polite"`, `aria-label`, and
  `prefers-reduced-motion` disables the animation in both CSS and a JS hook.
- The library's own usage guidance: use an inline loader when only a local region is pending; prefer
  skeletons when preserving content shape matters; **pair motion with accessible text** when context is
  not obvious; avoid multiple competing loaders in one viewport.

### Core principles

1. **One keyframes, many delays.** Write a single `@keyframes` pulse; express each loader as a pure
   function `(row, col, n) => normalizedDelay` evaluated per dot.
2. **Base opacity keeps the grid visible.** Dots rest at ~0.16 so the shape reads before and after the
   wave — the loader looks designed even when paused.
3. **Animate only opacity + transform.** No repaint storms during long waits.
4. **Motion is decoration, text is information.** The dots carry the mood; a `role="status"` wrapper plus
   a visible label naming the actual stage carries the facts.
5. **Honesty over optimism.** No fake percentages for indeterminate work; show stage names and elapsed
   time instead.
6. **Respect `prefers-reduced-motion`.** Freeze to a static mid-opacity grid — still communicates
   "working" without motion.
7. **Match the ambient theme and wait length.** Dots inherit theme tokens (e.g. `--primary`, `--accent`,
   `--muted`, or `currentColor`); scale the cycle to the expected wait — short wait = faster tighter
   loop, long wait = slow calm one.

## When to use / When NOT to use

Use when:

- A wait is long enough that a generic spinner reads as frozen or dishonest (generation, synthesis,
  encoding, rendering, multi-step pipelines — typically 2 s to 2 min).
- The wait is indeterminate: real progress % is unknowable (streamed tokens, queue position, encode
  passes), so a determinate bar would be a lie.
- A local region is pending and an inline, compact indicator beats a full-page overlay.

Do NOT use when:

- The wait is under ~300 ms perceived — render the result; a flashing loader is noise.
- Real progress is knowable — use a true progress bar with honest increments.
- Preserving the shape of upcoming content matters more than mood — use a skeleton.
- The viewport already hosts another loader (explicitly warned against in Dot Matrix's own docs): one
  loader per waiting region; disable the triggering button instead of adding another.
- The stack already ships Tailwind + shadcn and the team prefers registry ownership — then installing
  the actual `@dotmatrix` item is justified; otherwise copy the technique, keep zero deps.

### Anti-patterns

- **Generic spinner for long waits.** A single rotating arc carries zero information; this is the exact
  failure Dot Matrix exists to fix.
- **Lying loaders.** Fake progress bars that jump to 90% and stall, randomized increments, invented ETAs.
  For genuinely unknown durations show the current stage name and elapsed seconds.
- **Multiple competing loaders in one viewport.** One loader per waiting region.
- **Animating layout properties** (`width`, `margin`, `top`) per dot — repaint storms. Only `opacity`
  and `transform` animate.
- **GIF/Lottie/icon-font for a dot grid.** Cannot recolor via `currentColor`/CSS vars; adds weight and
  dependencies for something 25 spans and 20 lines of CSS do better.
- **Label-less motion.** A pulsing grid with no text fails screen readers and leaves sighted users
  guessing which stage is running. Always `role="status"` + a human-readable stage label in the UI
  language.

## How to apply (numbered checklist)

1. Classify the backend work: **thinking** (text/LLM), **rasterizing** (image generation), **sequential
   frame work** (video/render/encode), **inspecting** (analysis, QA, synthesis). The motion metaphor
   should match what the system is actually doing.
2. Pick the choreography from that metaphor: ripple (thinking), scan (rasterizing), frame chase
   (sequential), breathe (inspecting) — implementations below.
3. Pick grid size: 5x5 for standalone wait regions, 3x3 inline next to a button or inside a card.
4. Scale the cycle to expected wait: ~1200 ms short, 1600–1800 ms medium, 2000–2400 ms long.
5. Add the shared CSS once to a global stylesheet (below) — base opacity 0.16, only opacity/transform
   animated, reduced-motion freeze included.
6. Render dots via a `DelayFn` returning a normalized 0..1 delay; return negative to omit a dot
   (hollow patterns).
7. Wrap in `role="status"` + `aria-live="polite"` with a visible stage label; keep the grid itself
   `aria-hidden`.
8. Color from theme tokens, not hardcoded hex; for long waits show stage label + elapsed time, never an
   invented percentage.

### 1. Shared CSS — add once to any global stylesheet

```css
/* ---- Dot-matrix loaders (technique from dotmatrix.zzzzshawn.cloud) ---- */
.dmx {
  display: inline-grid;
  grid-template-columns: repeat(var(--cols, 5), var(--dmx-dot, 4px));
  gap: 4px;
  vertical-align: middle;
}
.dmx-dot {
  width: var(--dmx-dot, 4px);
  height: var(--dmx-dot, 4px);
  border-radius: 50%;
  background: var(--dmx-color, var(--primary, currentColor));
  opacity: 0.16; /* base — grid is always faintly visible */
  animation: dmx-pulse var(--dmx-cycle, 1600ms) cubic-bezier(0.4, 0, 0.6, 1) infinite;
  animation-delay: calc(var(--t, 0) * var(--dmx-cycle, 1600ms));
}
@keyframes dmx-pulse {
  0%, 100% { opacity: 0.16; transform: scale(0.8); }  /* base */
  50%      { opacity: 1;    transform: scale(1.15); } /* peak */
}
/* LED/CRT variant: square dots, hard on/off switch (Glyph/CRT Glide family) */
.dmx--led .dmx-dot { border-radius: 1px; animation-name: dmx-bit; animation-timing-function: linear; }
@keyframes dmx-bit {
  0%, 49.9% { opacity: 0.12; }
  50%, 100% { opacity: 1; }
}
.dmx-row { display: flex; align-items: center; gap: 10px; }
@media (prefers-reduced-motion: reduce) {
  .dmx-dot { animation: none; opacity: 0.5; transform: none; }
}
```

### 2. Generic grid component + four choreographies (React; the DelayFn ports to any stack)

```tsx
import type { CSSProperties, ReactNode } from "react";

// Returns a normalized delay 0..1 within the cycle; negative = dot omitted.
type DelayFn = (row: number, col: number, n: number) => number;

export function DotGrid({ n = 5, delay, cycle = 1600, color, className = "" }: {
  n?: number; delay: DelayFn; cycle?: number; color?: string; className?: string;
}) {
  const dots: ReactNode[] = [];
  for (let r = 0; r < n; r++)
    for (let c = 0; c < n; c++) {
      const t = delay(r, c, n);
      if (t < 0) continue;
      dots.push(<span key={`${r}-${c}`} className="dmx-dot" style={{ "--t": t } as CSSProperties} />);
    }
  const style = { "--cols": n, "--dmx-cycle": `${cycle}ms`, ...(color && { "--dmx-color": color }) } as CSSProperties;
  return <span className={`dmx ${className}`} aria-hidden="true" style={style}>{dots}</span>;
}

// Wave radiating from center, ring by ring ("Neon Drift" ripple family) — thinking.
export const ripple: DelayFn = (r, c, n) => {
  const k = (n - 1) / 2;
  return (Math.max(Math.abs(r - k), Math.abs(c - k)) / k) * 0.4;
};

// Column sweep, left to right ("Rail Scan" / "Column Rake") — rasterizing pixels.
export const scan: DelayFn = (_r, c, n) => (c / (n - 1)) * 0.5;

// Clockwise perimeter chase ("Frame Chase" / "Twin Perimeter") — sequential frame work.
export const frame: DelayFn = (r, c, n) => {
  const m = n - 1;
  if (r > 0 && r < m && c > 0 && c < m) return -1; // hollow: only the border runs
  const o = r === 0 ? c : c === m ? m + r : r === m ? 2 * m + (m - c) : 3 * m + (m - r);
  return (o / (4 * m)) * 0.75;
};

// Diagonal breathe ("Lunar Breathe") — calm inspection pulse.
export const breathe: DelayFn = (r, c, n) => ((r + c) / (2 * (n - 1))) * 0.6;
```

### 3. Wiring — motion is always paired with a real status text

```tsx
<div className="dmx-row" role="status" aria-live="polite">
  <DotGrid delay={ripple} n={5} cycle={1800} />
  <span>Generating copy…</span>
</div>
```

### 4. Wait-type → choreography mapping (the distilled defaults)

| Wait type | Typical duration | Loader | Label pattern |
|---|---|---|---|
| Text/LLM generation (document, script, plan) | 10–40 s | `ripple n={5} cycle={1800}` — radiating wave reads as "thinking" | "Writing the outline…" / stage name |
| Short inline action (enhance/rewrite a prompt) | 3–10 s | `ripple n={3} cycle={1200}` inline next to the button | "Improving…" |
| Speech/audio synthesis, per item | 2–10 s | `breathe n={3} cycle={1200}` small, inline | "Synthesizing…" |
| Image generation | 5–15 s / image | `scan n={5} cycle={1400} color="var(--accent)"` inside the placeholder card — a sweep reads as rasterizing pixels | "Generating image…" |
| Video generation | 30–90 s | `frame n={5} cycle={2000}` | "Generating video…" |
| Render/encode pipeline | 30–120 s | `frame n={5} cycle={2200} className="dmx--led"` — perimeter chase = sequential frame work, slow cycle conveys long haul | current stage name + elapsed time |
| Inspection / analysis / QA pass | 10–60 s | `breathe n={3} cycle={2400} color="var(--muted)"` — calm, deliberate | "Checking…" |

Rules of thumb behind the mapping:

- **Thinking** → radiating `ripple`; **rasterizing** → directional `scan`; **sequential frame work** →
  `frame` chase; **inspecting** → calm `breathe`. The motion metaphor should match what the system is
  actually doing.
- For a multi-step pipeline, the honest display is loader + live stage label + elapsed time. If the
  pipeline exposes its current step, surface it — never replace it with an invented progress bar.
- First paint matters: because delays are positive (`calc(var(--t) * cycle)`), the wave starts from an
  all-dim grid and sweeps in — intentional, matches the original library's behavior.

## AI-slop warning

- **The same ripple everywhere is the new spinner.** Pasting one 5x5 pulse onto every wait in an app
  reproduces the exact emptiness Dot Matrix fixes. Each loader must encode a real metaphor
  (think/raster/chase/inspect), or it is decoration.
- **Contexts this look poisons:** dense dashboards with several simultaneous async regions (competing
  loaders), calm/precision domains (finance, medical, legal) where playfulness erodes trust, and any
  surface where motion runs while the user types or scrolls.
- **Gradient-dot slop:** sprinkling the sunset/neon/aurora presets decoratively across an app is the
  fastest way to make the technique read as AI-generated. Dots inherit theme tokens; gradients are a
  one-off accent at most.
- **Typical AI misapplications:** installing the registry item into a non-Tailwind, non-shadcn codebase
  (port the ~30 lines of CSS instead); writing 25 `nth-child` delay rules instead of one `DelayFn`;
  animating layout properties; skipping `role="status"`, the visible label, and the
  `prefers-reduced-motion` freeze; using a dot grid where a determinate progress bar is honest.

## Relations

- **dither-kit** — the static sibling: same dot-grid/dither texture vocabulary for images and
  hero surfaces. Dot Matrix animates that grid in time; combine only when one metaphor dominates.
- **loading-dev** — the broader loading-animation catalog; Dot Matrix contributes the
  one-keyframes-many-delays architecture, the 0.16/0.32/1 opacity triplet, and the metaphor mapping.
- **you-dont-need-animations** — counterweight: for sub-300 ms waits or motion with no
  metaphor, a static label beats any loader. Read it before adding choreography.
- **web-interface-guidelines** — the accessibility contract (`status` role, live regions,
  reduced motion) every loader must satisfy before aesthetics.

## Sources

- Site: https://dotmatrix.zzzzshawn.cloud (introduction / usage / manual-setup pages)
- Repo: https://github.com/zzzzshawn/matrix (`loaders/base/dot-matrix-base.tsx`,
  `loaders/dmx/dotmatrix-loader.css`, `lib/registry-config.ts`)
