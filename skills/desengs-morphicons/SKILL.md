---
name: desengs-morphicons
description: Use when an icon must morph between states (menu/close, play/pause) instead of swapping. Encodes the pipeline: 64-point arc-length resampling, closed-form Procrustes rotation solving, spring presets.
source: https://www.morphicons.com; https://github.com/GuillermoLG00/morphicons
category: library
---

# morphicons (desengs) — icons that transition between states

Source: https://www.morphicons.com — Guillermo LG (guillermolg.com, GitHub `GuillermoLG00`). An open-source, MIT-licensed, zero-dependency JS library (~6.6–8.9 KB gzip per binding) that morphs any stroke-based SVG icon into any other using spring physics. Ships no icons of its own; consumes any 24×24 stroke set (Lucide, Tabler, Heroicons outline, Iconoir) as raw `d` strings or Lucide `IconNode` data. Demo icons keep their authors' licenses (Lucide ISC, Tabler MIT).

## What it is / Why it exists

A state swap says "one icon left and another arrived." A morph says "the thing you clicked became the thing now on screen" — the single strongest continuity cue available at 24px. Native CSS `transition` on `d` only works when both paths have byte-identical command lists (same letters, same count); otherwise browsers snap silently. Every real icon pair violates that, so every product either ships the snap (most sites) or hand-rigs matched paths (expensive). morphicons fills the gap generically: resample both paths to equal point counts, solve alignment and correspondence in closed form, drive the interpolation with an interruptible spring. Sub-millisecond planning (0.01–0.06 ms at N=64), zero per-frame numeric allocation, one shared rAF for all instances, DOM-untouched core so any framework can drive rendering.

## Inventory (names to know)

- Exports: `morphicons` (pure core, no DOM: `resampleIcon`, `buildPlan`, `interpPolar`, `allocOutputs`, `serialize`), `/dom` (`createMorph`), `/react` (`MorphIcon`, react ≥18), `/vue` (≥3.3), `/svelte` (≥5 runes), `/react-native` (≥0.71 + react-native-svg ≥14), `/element` (`<morph-icon>` custom element), `/adapters` (`svgToIcon`, `maskTarget`, `canvasTarget`).
- Three modes in every binding: declarative (`icon={open ? X : Menu}`), controlled (`from`/`to`/`progress` for gesture/scroll-driven scrubbing), imperative (`ref.morphTo()`, `ref.set()`, `seek(icon, 0.4)`).
- `fitIcon(icon, size)` — re-grids off-canvas packs (Carbon 32, Teenyicons 15) onto 24×24; call once at module scope.
- `IconNode` — `[tag, attrs][]` restricted to `path`, `line`, `circle`, `ellipse`, `rect`, `polyline`, `polygon`. No `<g>`, no `transform` (coordinates must be literal) — other tags throw.

## The core ideas

### 1. Normalize everything to cubic Béziers

All SVG primitives reduce to cubics once, so correspondence and sampling only handle one geometry:
- Line → cubic with controls at 1/3 and 2/3 along (constant pen speed).
- Quadratic → exact degree elevation (controls at Q₀ + ⅔(Q₁−Q₀), Q₂ + ⅔(Q₁−Q₂)).
- Circle → 4 cubics, offset k = r·(4/3)·tan(π/8) ≈ 0.5523·r. Arcs → center parametrization, sliced ≤90° per cubic.

### 2. Resample at N = 64 points, anchored at corners

Each subpath becomes 64 points equidistant by arc length (cubic arc length has no closed form — integrate |B′(t)| with 8-point Gauss-Legendre per segment). Corners (tangent discontinuity above a threshold) are forced onto exact sample points; the rest apportion between corners. Consequences that matter: shapes are exact at rest (a check's vertex is a real sample, never rounded off), corners sharpen/flatten smoothly in flight, and closed paths anchor only corners — never the arbitrary `M` start point — so congruent loops with different starting points resample identically.

### 3. Correspondence is solved, not declared

Three subproblems, all automatic: traversal orientation (both directions tried and scored), start-point offset for closed paths (N circular offsets × 2 directions, brute-force ~4K ops), and subpath pairing with cost `dist(centroids) + 0.35·|ΔL|` (centroid distance plus 0.35 × arc-length delta). Unequal subpath counts use a surjective assignment — leftovers are duplicated in place and separate in flight (the "cell division" effect), and a canonical snap on settle resets the count. You never hand-build from/to pairs or declare rotation groups.

### 4. Rotation is emergent: closed-form 2D Procrustes

Per subpath, solve the optimal similarity (θ, σ, translation) minimizing Σ|σ·R(θ)·(aᵢ−c_A) − (bᵢ−c_B)|² without SVD:

```
θ* = atan2(S_xy − S_yx, S_xx + S_yy)
σ* = [cosθ*·(S_xx+S_yy) + sinθ*·(S_xy−S_yx)] / Σ‖aᵢ‖²
```

The normalized RMS residual is the shape metric: residual ≈ 0 means pure rotation/scale relates the pair. arrow-right → arrow-down yields residual ~0 with θ = 90° and the system rotates instead of melting. A global hybrid pass over concatenated clouds (residual < 5e-3) gives all subpaths one shared (θ, σ) with "block transport" of centroids so congruent icons stay rigid mid-flight (this fixed a ~1px sag, r·(1−cos(θ/2)), on arrow heads). Symmetric shapes get a minimal-rotation tie-break: `score = res + 0.05·|θ|/π`.

### 5. Interpolate in polar form, extrapolate under overshoot

`P(t) = c(t) + σ*ᵗ · R(t·θ*) · [(1−t)·aᶜᵢ + t·b̃ᵢ]` — linear translation, linear angle, log-linear scale (σ*ᵗ = exp(t·ln σ*)). Exact at both endpoints, and because the formula is analytic it extrapolates naturally when a spring overshoots (t > 1) instead of clipping.

### 6. Spring over progress, not keyframes

Damped harmonic oscillator ẍ = k·(1 − x) − c·ẋ, semi-implicit Euler at h = 1/240 s substeps (stable up to ω·h ≈ 2):

| preset | stiffness k | damping c | ζ | character |
|---|---|---|---|---|
| smooth | 170 | 26 | 1.00 | critically damped, no overshoot |
| snappy | 420 | 30 | 0.73 | fast, subtle overshoot — default for toggles |
| bouncy | 300 | 14 | 0.40 | playful, use sparingly |

Interruptions: mid-flight `morphTo` re-plans from the current intermediate shape, resets x to 0, preserves velocity (clamped ±14) — click-spam never jumps. Settles at |1−x| < 0.001 ∧ |v| < 0.02, then the rAF stops and the path snaps to the target's canonical `d` (jump < 0.02px). In-flight subpaths emit as polyline `M x y L x y…` at 2 decimals — the frame's only allocation.

## Using it (mechanism first, install second)

Data in, morph out — icons are values, not components:

```tsx
import { Menu, X } from "lucide";            // data, NOT lucide-react components
<MorphIcon icon={open ? X : Menu} spring="snappy" strokeWidth={1.75}
           label="Menu" reducedMotion="user" aria-expanded={open} />
```

Vanilla, framework-free:

```ts
import { createMorph } from "morphicons/dom";
const m = createMorph(pathEl, Menu);
m.morphTo(X, "snappy");        // or { stiffness: 420, damping: 30 }
m.reducedMotion = "user";
```

The dependency is justified when: pairs are drawn from existing 24×24 stroke sets, morphs are user-triggered and frequent, and you need interruption safety or controlled scrubbing. Not justified for one hero morph — hand-roll it:

```js
// Hand-rolled morph: resample both cubics-chains to equal points, lerp.
// (Skips rotation solving — only for pairs with similar orientation.)
function resample(pathEl, N = 64) { /* arc-length walk, return Float64Array(2N) */ }
const A = resample(menuPath), B = resample(closePath);
function render(t) {
  let d = "";
  for (let i = 0; i < A.length; i += 2) {
    const x = A[i] + (B[i] - A[i]) * t, y = A[i+1] + (B[i+1] - A[i+1]) * t;
    d += (i ? "L" : "M") + x.toFixed(2) + " " + y.toFixed(2);
  }
  pathEl.setAttribute("d", d);   // emit polylines in flight, snap to canonical d on settle
}
// drive t with a spring: x += v*h; v += (k*(1-x) - c*v)*h;  h = 1/240, k=420, c=30
```

Designing a custom pair to morph well: stroke-drawn (`fill="none"`), literal coordinates (no `transform`, no `<g>`), same 24×24 grid, uniform stroke width with round caps/joins. Filled glyphs (Material Symbols, Heroicons solid, Phosphor fill) parse but smear in transit — the pipeline assumes stroked centerlines. Subpath counts do not need to match.

A fuller hand-rolled resampler for the snippet above — flatten each cubic to ~16 segments, walk by accumulated length, force corners onto samples:

```js
function resamplePoints(cmds, N = 64) {
  const pts = [];                       // flatten: 16 t-steps per cubic
  for (const seg of cmds)
    for (let i = 0; i < 16; i++)
      pts.push(cubicAt(seg, i / 16));
  const lens = [0];
  for (let i = 1; i < pts.length; i++)  // cumulative arc length
    lens.push(lens[i-1] + dist(pts[i-1], pts[i]));
  const total = lens.at(-1), out = [];
  let j = 0;
  for (let k = 0; k < N; k++) {         // N points equidistant by arc length
    const target = (k / (N - 1)) * total;
    while (lens[j + 1] < target) j++;
    out.push(lerpPt(pts[j], pts[j + 1], (target - lens[j]) / (lens[j+1] - lens[j])));
  }
  return out;
}
```

This is the whole trick the library automates: equal point counts make any two paths interpolable; corner anchoring and Procrustes alignment are what make the interpolation *read* as one object transforming instead of two smearing.

Adapters extend reach beyond inline SVG: `svgToIcon(markup)` parses pasted `<svg>`/`<path>`/Iconify bodies and rejects fill-drawn markup with a parse-time error (morphability check); `maskTarget(el)` morphs CSS-mask-based icons (UnoCSS presetIcons, Tailwind icon plugins) in place via a hidden double-buffered SVG mask, keeping `currentColor` working; `canvasTarget(canvas | ctx)` renders via `Path2D` for favicons, WebGL textures, and `OffscreenCanvas`. Each tree-shakes alone (3.34 / 0.70 / 0.48 KB).

Lifecycle contract every binding shares (know it or you will misread the modes):
- Lazy driver: the first icon paints without animating; `morphTo` before a driver exists behaves as `set`.
- Controlled wins: while `from` and `to` are both present, the pair owns the path and `icon` changes are ignored — no spring fires.
- Clean re-entry: exiting controlled mode invalidates the frozen pair; re-entering re-bases on `from`.
- SSR: the server emits the exact static SVG, zero flash; the `<morph-icon>` element adopts an already-rendered inner `<svg><path>` verbatim (Astro needs no island); React Native's Fabric rebuilds paths from declared props, so the binding republishes the live `d` each render and re-applies it in a layout effect.

## When to use / When NOT to use

Use for: stateful single icons a user toggles — menu/close, play/pause, expand/collapse, arrow directions, theme switch, volume/mute, favorite. Anywhere the icon *is* the state indicator and the click is pointer-initiated.

Do NOT use for:
- Static or decorative icons — the morph is invisible and you pay the coupling cost.
- Dense toolbars where many icons sit within one fixation — motion at 24px across a 10-icon row reads as noise, not signal.
- Fill-based icon systems — solid glyphs are unreadable mid-morph; use a swap or crossfade there.
- Keyboard-triggered toggles — motion after a keypress reads as lag, not continuity.
- Icons on mismatched grids without `fitIcon` — Procrustes is similarity-invariant so nothing throws, but the mismatch lands in σ as an unwanted zoom and the target draws outside the canvas.
- `maskTarget` on icon-heavy views — per-frame mask re-rasterization runs on the main thread; fine for a toggle, wrong for a 200-icon grid. Hosts with their own render loops (Konva, Chart.js, canvases) need a dedicated canvas, using `onWrite` as the dirty signal.

Accessibility contract: `aria-hidden` by default; pass `label` to get `role="img"` + `<title>`. Reduced-motion defaults to `"never"` (always animate) — ship `reducedMotion="user"` to honor the OS setting, or `"always"` (instant jump) in tests. Pair with `aria-expanded` on the controlling button, not the icon.

## How to apply

1. Identify true state pairs in the UI (one control, two states, pointer-triggered). List them; everything else stays static.
2. Verify both icons are stroke-drawn on the same grid; if not, `fitIcon(icon, sourceSize)` once at module scope.
3. Pick the spring: `snappy` (420/30) for controls, `smooth` (170/26) where overshoot would look wrong (arrows), `bouncy` (300/14) at most once per view.
4. Wire the declarative mode (`icon={cond ? A : B}`) — no keys, no from/to bookkeeping. Reserve controlled mode (`from`/`to`/`progress`) for gesture- or scroll-scrubbed morphs.
5. Set `label` if the icon stands alone; keep `aria-hidden` when a visible text label sits next to it. Set `reducedMotion="user"`.
6. Settle state must equal the canonical target `d` (4-decimal serialization keeps SSR hydration bytes identical across JS engines).
7. Spam-test: alternate states rapidly; the re-plan-from-current-shape behavior should never produce a jump. If it does, you left controlled mode's frozen pair active.

## AI-slop warning

Morphing icons became a portfolio cliché the moment demo reels started menu→X-ing everything. The failure modes: (1) morphing *every* icon because the library makes it free — density plus motion equals noise; cap morphs to stateful controls. (2) morphing semantically distant pairs (settings gear → trash) because any two paths technically interpolate — a morph asserts "same object, new state"; between unrelated glyphs it reads as melting. (3) shipping `reducedMotion` default (`"never"`) — always-animated icons ignore user OS settings. (4) `bouncy` everywhere — ζ = 0.40 on 40 toggles is a circus. (5) Ignoring grid/format constraints silently: fill icons and off-grid icons don't error, they just look broken in flight, and AI agents won't check unless told.

## Relations

- **desengs-morphrig** — the contrarian take: measured over 300 arbitrary Lucide pairs, only ~7.7% of automatic morphs are worth shipping; argues correspondence should be decided at build time as data (slots, arity, parking) rather than solved at runtime. Read both: morphicons gives the automatic pipeline and the numbers, morphrig gives the quality gate and the "is the midpoint a real shape?" litmus test.
- **desengs-emil-skills** — the frequency gate (should this animate at all?) and the spring/interruptibility doctrine this library implements; his "never animate keyboard actions" rule sharpens the when-NOT list above.
- **desengs-svg-guide** — path command mechanics, the identical-command-list constraint on native `d` transitions, and stroke/cap/join fundamentals the "design pairs that morph well" rules depend on.
- **desengs-transitions** — where icon morphs sit in the broader transition hierarchy (swap < crossfade < transform < morph) and how to keep them consistent with page-level transitions.
