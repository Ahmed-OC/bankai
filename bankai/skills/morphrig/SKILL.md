---
name: morphrig
description: Use when two UI states show the same object and must animate as one continuous shape (icon, toggle, counter) instead of crossfading. Distills morphrig.dev's rig method: slots, parking, a two-number gate.
source: https://morphrig.dev
category: library
---

# Morphrig — morphing as a first-class UI technique

Source: https://morphrig.dev — Sanyam Punia (frontend engineer, sanyam.sh). A ten-part interactive manual (~71 min read) on how icon morphing actually works, plus the compiler that renders it ("every number on this site came out of the compiler that renders it"). Not an installable package, by design — the thesis is that nothing here needs a dependency. Three borrowed pieces (alignment maths, arc-to-cubic conversion, frame loop) are MIT, credited in `THIRD-PARTY-NOTICES.md`. Origin: Benji Taylor's "Morphing icons with Claude" post; timing informed by Emil Kowalski's animations.dev.

## What it is / Why it exists

Morphing is the strongest form of state animation: it tells the user "the thing you clicked and the thing now on screen are the same object in a different state." A swap says "one button left and another arrived." On one icon that is a detail; across a product it separates an interface that holds together from one that flickers.

The gap Morphrig fills: existing morph libraries solve the wrong half. "Every library in this category will morph any two icons you hand it. None of them will tell you when the result is worth shipping." Measured across 300 arbitrary pairs from 2003 Lucide icons, only **7.7%** produce a morph worth shipping. The manual documents the under-documented fork — deciding correspondence at build time, as data — and gives the two numbers that gate quality before a user ever sees it.

Pattern inventory (names to know): the **rig** (icons that agree on how they are built), **slot**, **arity**, **parking**, the primitives `line` / `lineSlot` / `parked`, `assertRig`/`validateRig` (build-time invariant checks), `compileAuto` (routes straight-tween vs polar sampling by residual), `importSet` + `buildAlignment` (fit arbitrary icons to a rig), the **driver** (2.00 kB JS player), `seek` (render frozen at any progress), and the gate scripts `pregate`/`presweep`.

## The core ideas

### 1. Four techniques — only one is a morph

All demos run 500 ms over the same icon pair:

1. **Swap** — replace the icon. Nothing animates. What most sites ship.
2. **Crossfade** — stack both, trade opacities. At the midpoint both render at 50% and five strokes are on screen; reads as a dissolve, a smudge at small sizes.
3. **Transform** — rotate/scale/translate the icon as one rigid object. Works only when the pair is rotation-related (rotated hamburger bar resembles an X).
4. **Morph** — the geometry itself changes: "at the halfway point there is exactly one shape on screen, and it is neither icon."

Litmus test: **"If the shape at the midpoint is not a real shape, it is not a morph."** Path drawing (`stroke-dasharray` reveal) is not a morph — the line always existed; only the uncovered portion animates. Fill-tweening two SVGs is crossfade with extra steps.

### 2. The mechanism: match command lists, then average numbers

A shape is a chain of cubic Béziers on a 24×24 grid (y grows downward). Browsers interpolate two paths **only if their command sequences match exactly** — same letters, same count — otherwise the shape snaps instantly, with no error and no warning. So `M4 5h16` (M,h) cannot animate toward `M7 7L17 17` (M,L); rewrite both as M,C first.

```js
// A straight stroke stored as a cubic — controls at 1/3 and 2/3 along it,
// so the pen travels at a constant rate (parameterisation stays even).
const line = (x0, y0, x1, y1) => [
  x0, y0,                                  // start
  x0 + (x1 - x0) / 3,  y0 + (y1 - y0) / 3, // control 1
  x0 + 2 * (x1 - x0) / 3, y0 + 2 * (y1 - y0) / 3, // control 2
  x1, y1,                                  // end
];
// "M4 5 C9.333 5 14.667 5 20 5" — draws identically to M4 5h16
```

Interpolation is then weighted averaging of number arrays:

```js
const lerp = (a, b, t) => a + (b - a) * t;
const frame = (a, b, t) => a.map((v, i) => lerp(v, b[i], t));
// menu bar [4,5,20,5] -> cross bar [7,7,17,17] at t=0.5 -> [5.5,6,18.5,11]
```

Conversion rules: only `<path>` has a `d` — convert `<rect>/<circle>/<line>/<polyline>` to paths first. Arcs cannot be averaged (two of their seven parameters are boolean flags); convert arcs to cubics — a circle becomes four cubic segments, accurate at icon sizes to well under 0.1 px.

### 3. Correspondence is the whole problem

A hamburger is three strokes; a cross is two. Before any math, someone decides: which bar becomes which diagonal, what the third bar does, and which end joins which end. There are **24** legal correspondences for hamburger→cross; two six-stroke icons have 46,080. The browser "will faithfully animate whichever correspondence it is handed," including the absurd ones, with no error.

- **End orientation matters**: joining start-to-start when one path runs left-to-right and the other right-to-left makes the stroke cross the whole icon, pass through orientations neither icon contains, and "arrive backwards." Both drawings look identical; only the data differs.
- **Meaning is not in the data**: "Every approach to morphing recovers, from geometry alone, a decision you made from meaning." You know top→diagonal because a hamburger is a stack and a cross is an X; the computer sees two lists of coordinates.
- Mantra: **"Correspondence is the problem, interpolation is arithmetic."**

### 4. The two answers: solve on device vs write it down

Every morphing library stands on one fork; "there is no third answer, and nothing gets both."

**Runtime solver** — normalize to cubics, resample both sides to a shared point count (a quality dial), score subpath pairings on centroid distance and arc length, take the cheapest assignment, **Procrustes-align** each pair (the rotation+scale+translation fit that stops a stroke turning inside out), then interpolate with springs. Wins: zero setup, works on pairs unknown until runtime. Costs: ships the whole solver as JS, and a wrong pairing is permanent — the solver re-derives the same wrong answer on every device forever.

**Write it down (build-time rig)** — fix correspondence as data; every frame becomes a pure function of progress, so it precompiles to CSS keyframes with zero runtime JS. A wrong pairing is a commit away; slots have identity, so per-stroke choreography works (e.g. the middle bar leaving 60 ms early). Costs: a build step, and bytes at rest (a rotation held faithfully runs ~2.3 kB of samples vs ~200 B for a plain tween).

### 5. The rig: slots, arity, parking

```js
const lineSlot = (x0, y0, x1, y1) => ({ segs: [line(x0, y0, x1, y1)] });
const parked = (host) => ({ segs: [], park: host }); // hides on sibling `host`

export const arrowsRig = {
  name: "arrows", grid: 24, slots: 3, arity: [1, 1, 1],
  icons: {
    "arrow-right": [lineSlot(6, 12, 18, 12), lineSlot(13.2, 7.2, 18, 12), lineSlot(13.2, 16.8, 18, 12)],
    "arrow-down":  [lineSlot(12, 6, 12, 18), lineSlot(7.2, 13.2, 12, 18), lineSlot(16.8, 13.2, 12, 18)],
    "minus":       [lineSlot(6, 12, 18, 12), parked(0), parked(0)],
  },
};
```

- **Slot** — one `<path>` that keeps its identity across the whole set: slot 0 always becomes slot 0. That is the entire correspondence mechanism.
- **Arity** — cubic segments per slot, fixed rig-wide (`[1,1,1]`; circle+line icon would be `[4,1]`). Identical command structure is the condition CSS imposes before it will interpolate rather than swap.
- **Parking** — a spare slot sits exactly on a sibling's geometry (with a suppression track, below), so next time it is "born by splitting off that stroke" instead of appearing out of mid-canvas. Parking at canvas centre reads as apparition.
- **Grid: use 24** unless you have a reason not to — Lucide, Tabler, Heroicons outline, and Iconoir all draw on it, so imports need no rescaling.
- Validate rigs at build time (`assertRig`): slot mismatches, arity violations, parking cycles must fail in CI, not as broken animations.

**Parking requires an opacity track.** Overlap alone does not hide: antialiased edges composite twice, so a 50%-covered edge pixel painted twice resolves to 75%, not 50%. Measured: worst pixel 18.8% too dark; at 24 CSS px the worst per-pixel alpha delta along the shared outline is 48/255; at `stroke-opacity: .5` the doubled stroke reads 192 vs 128. The artifact worsens at small sizes. Rule: **"Parking decides where, and opacity decides whether."** Two animated CSS properties is still zero JS.

### 6. Rotation: interpolate polar, not linear

Linear interpolation sends each point along the chord; a chord is shorter than its arc. A quarter-turn morph (arrow-right→arrow-down) retains only **70.7%** of stroke length at the midpoint (cos 45°); a half-turn (arrow-right→arrow-left) **collapses to a single point** mid-flight.

Fix: decompose the pair at build time into rotation + scale + residual, interpolate each in its natural space, re-emit as sampled keyframes — the browser then just tweens adjacent samples:

- **Angle**: linear — turning 30° costs the same wherever you start.
- **Scale**: logarithmic — the midpoint between 1× and 4× is 2×, not 2.5× (halfway between one and two doublings), so growth and shrinkage cost the same.
- **Residual** (the non-rigid remainder): plain lerp in the aligned frame.

Congruent pair (same shape, moved/turned) → residual 0 → pure rotation, worth sampling. Non-congruent → "the rotation term is decoration" → drop back to a 2-keyframe tween (search→x, residual 0.442, fell from 17 keyframes to 2 with no visible loss). Let the residual decide, not your eye. Sample counts are set per pair against a deviation budget — "only real curvature pays for more"; a pair with no rotation still costs 2 keyframes.

### 7. The two-number quality gate

Compute both at build time; **refuse above 0.2 residual or 50% parked**:

1. **Residual** — what is left after the best Procrustes rotation+scale fit. Zero means the shapes really are one shape moved. chevron-down→up: 0.000. circle→guitar: 0.846.
2. **Parked ratio** — slots with no partner over the smaller stroke count. sun→moon scores fine on shape (0.073) but parks 8 of 9 slots: strokes "born from nowhere."

In the 300-pair sweep: 197 failed on shape alone, 27 on parking alone, 53 both; only 23 shipped. A per-slot *confidence* metric failed as a gate — ambiguity is close to the opposite of badness (symmetric icons are ambiguous by construction yet morph fine). On refusal, four options: ship anyway (play→pause works at 0.802), fix the rig and commit, crossfade (the honest answer for sun and crescent), or draw with `stroke-dashoffset` — a single number with nothing to pair, so the correspondence problem "disappears rather than being solved."

### 8. Browser tiers

| Tier | Size | Chromium | Safari |
|---|---|---|---|
| Compiled CSS (`d` in transition/keyframes) | 0 KB | animates | **static icon** |
| SMIL `<animate attributeName="d">` | 0 KB | animates | animates |
| JS driver (writes the `d` attribute) | 2.00 kB | animates | animates |
| React binding over the driver | 2.82 kB | animates | animates |

- Safari has no CSS `d` at all (the value is not even retained on style; `getBBox()` returns zero) and no WAAPI `d`.
- A 2-keyframe morph compiles to a CSS **transition** — runs both directions and interrupts cleanly. Sampled morphs compile to `@keyframes` — one direction only; reversing cuts, because CSS cannot tell a state flip from a first paint.
- SMIL animates any attribute (`points`, `viewBox` too), needs no stylesheet (survives `<img>`), and is not blocked by Safari — but interruption and scrubbing belong to the driver.
- Do not rely on browsers rejecting bad pairings: on mismatched command lists Chromium holds the start value and jumps at the end; Safari interpolates the matching part and snaps.
- **Nothing here is compositor-accelerated.** Only `transform` and `opacity` skip paint; animating `d` re-runs paint every frame on the main thread. Keep rotations and fades riding alongside a morph as transform/opacity, never as extra geometry samples.

### 9. The wider morph family — same principle, other mechanisms

- **Element morph** (one element changes size/position): FLIP.
- **Shared layout transition** (the "same" element moves between containers): View Transitions API or FLIP across DOM locations.
- **Path/icon morph**: this skill — interpolate `d` with matched command structure.
- **Text morph**: glyph outlines cannot interpolate; use per-glyph FLIP/translate, or crossfade. Never squeeze text geometry.
- **Number morph**: tween the value, render with `font-variant-numeric: tabular-nums` so digits don't jitter, or roll digits odometer-style (see number-flow).

```js
// FLIP: First–Last–Invert–Play. Set transform-origin: 0 0 on the element first.
const first = el.getBoundingClientRect();
applyState(); // Last
const last = el.getBoundingClientRect();
el.animate(
  [{ transform: `translate(${first.left - last.left}px, ${first.top - last.top}px)
                     scale(${first.width / last.width}, ${first.height / last.height})` },
   { transform: "none" }],
  { duration: 300, easing: "cubic-bezier(0.22, 1, 0.36, 1)" }
);
```

```js
// View Transitions: name the shared element, change the DOM inside the callback
document.startViewTransition(() => openPanel());
```
```css
.thumb { view-transition-name: hero; }
::view-transition-old(hero), ::view-transition-new(hero) { animation: none; }
```

## When to use / When NOT to use

Use morphing when the two states depict **the same object** — icon toggles (menu/x, play/pause, chevrons, plus/minus, maximize/minimize, volume-on/off), expanding cards, counters. The manual's shipped pairs run at residual ≤ 0.177.

Do NOT morph when:

- **The content is unrelated.** 92% of arbitrary pairs fail the gate. "Two unrelated drawings are usually not one shape moved, and no amount of slot bookkeeping changes that." Crossfade instead — it is the honest answer for sun→moon.
- **A rigid transform suffices.** If the pair differs only by rotation, animate `transform: rotate()` — compositor-friendly, 12 bytes of CSS.
- **The pair is unknown until runtime** — the build-time rig cannot do this at all; use a runtime solver or don't morph.
- **Fills with holes/winding rules** — "a different problem wearing the same hat." Everything here assumes stroked, open paths.
- **You cannot afford the paint cost** on a low-end target and the effect is decorative.
- **Safari must animate with zero JS** — CSS `d` silently renders a static icon; that means SMIL or the 2 kB driver.

## How to apply

1. Classify the intended animation: swap, crossfade, transform, or morph. Apply the midpoint litmus — a real shape at t=0.5, or don't call it a morph.
2. Confirm the pair is the same object in two states. If not, crossfade (≈150 ms) and stop.
3. Convert every shape to `<path>`; convert arcs to cubics; redraw strokes as cubics with controls at 1/3 and 2/3.
4. Choose the fork: pairs known at build time → rig; arbitrary runtime pairs → solver library, and accept you cannot fix wrong pairings.
5. Author the rig: fixed slot count, arity per slot, grid 24; declare parking targets; state for every stroke what it becomes.
6. Park spares on a sibling and always emit the opacity track — geometry + opacity, both, always.
7. Check endpoint orientation so no stroke "arrives backwards."
8. Gate the pair: residual ≤ 0.2 and parked ≤ 50%, else fix, crossfade, or draw (stroke-dashoffset).
9. Route rotation: residual ≈ 0 → polar sampling (angle linear, scale log); otherwise plain 2-keyframe tween.
10. Pick the tier: CSS transition for 2-keyframe toggles; the driver when mid-flight reversal/scrub matters; SMIL only for stylesheet-less SVG (`<img>`) or Safari-with-zero-JS.
11. Keep concurrent rotations/fades as `transform`/`opacity`; never bake them into geometry samples.
12. Validate rigs and gates in CI (`assertRig`, pregate thresholds in one file). Build order if rolling your own: parser → rig format + validator → interpolator (~20 lines) → serialiser (tune rounding — too many decimals triples size, too few visibly steps) → compiler/driver. Watch the arc-flag trap: `a1 1 0 011 1` is flags 0,1 then point (1,1); a naive number scanner reads `011` as eleven, so the parser needs a hand-written scanner.

## AI-slop warning

The AI defaults that this source exists to kill:

- **Crossfading every state change** because an animation library makes it one line — the exact smudge the manual opens on (two 50% icons, five strokes on screen).
- **Morphing any two icons because a library accepts them.** "Every library in this category will morph any two icons you hand it. None of them will tell you when the result is worth shipping." The gate exists because 92.3% of arbitrary pairs are garbage.
- **Writing `transition: d` without matched command structure** — silently snaps with no error, and is a static icon in Safari. Both failures are invisible to the generator and to the console.
- **Linear-interpolated rotations** — the collapsing arrow (70.7% length, or a point at half-turn) reads as broken, not stylized.
- **Parked strokes at full opacity** on their host — the 18.8%-too-dark outline artifact.
- Contexts it poisons: navigation semantics (morphing unrelated icons lies about identity), small sizes (crossfades read as smudge under ~20 px), and anywhere the motion outlouds the state.

## Relations

- **transitions** — the parent pattern: when any state change deserves animation at all; this skill is the geometry-level special case for same-object pairs.
- **easing** — the curve that carries a morph; Morphrig's timing "has reasons behind it instead of defaults" (credited to animations.dev), so pair the rig method with a deliberate ease-out.
- **svg-guide** — the path syntax and Bézier geometry that make the matching-commands rule work; read before writing a parser.
- **number-flow** — the number-morph sibling: digit tweening/odometer rolls where path interpolation does not apply.
- **morphicons** — icon-morph sibling, typically the runtime-solver side of the Part 3 fork this manual declines; use it for pairs unknown until runtime.
