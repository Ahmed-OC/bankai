---
name: easing
description: Use when animating any UI element and picking its timing curve or spring. Full easing.dev catalog — 28 bezier curves and 10 springs with exact values — so you choose by purpose instead of defaulting to ease.
source: https://www.easing.dev/
category: reference
---

# Easing Graphs — the easing curves and when each is right

Source: https://www.easing.dev/ — "Easing Graphs" (2026), built by Alex Vanderzon (@alexvanderzon) and Lochie Axon (@lochieaxon). A curated interactive catalog: 28 cubic-bezier curves + 10 parameterized springs, each with a graph, x1/y1/x2/y2 sliders, a duration slider (0.1–2s), and code export in six formats (CSS, Motion, SwiftUI, UIKit, Core Animation, Raw). The named curves and all ten springs are curated by Lochie Axon. Frequently mis-attributed to Emil Kowalski — it is not his site. No license stated; the family curves are the standard Penner bezier approximations, the named ones are original curation.

## What it is / Why it exists

- The site exists to end `transition-timing-function: ease` by default. It gives you a graph per curve so you pick easing the way you pick a typeface: by looking at it, then copying an exact value.
- Two collections, toggled by tabs: **Cubic Easing** (28 curves, filterable In / Out / In-Out) and **Spring** (10 named springs at `easing.dev/spring`). A "New Graph" editor lets you drag your own curve — x1/x2 are clamped to [0, 1] (CSS spec), y1/y2 are allowed from −1 to 2 (anticipation below the start, overshoot past the end).
- The site ships graphs and numbers, no prose prescriptions. The catalog structure itself is the guidance: the ladder of families (quad→expo), the five hand-named curves, the y-bounds, and which curve the site's own UI uses. Selection rules in this skill are derived from each curve's velocity profile and the set's implicit hierarchy — they are not site quotes.
- Telling detail: easing.dev's own tab container animates its height with `cubic-bezier(0.19, 1, 0.22, 1)` — the curve it names **Snappy Out**. That is the house default.

## The core ideas

### 1. Read velocity off the graph

The curve plots progress (y) against time (x). **Slope = velocity.** Where the curve is steep the element moves fast; where it flattens, it settles.

- Bows down (slow start, steep end) = **accelerating** — "in".
- Bows up (steep start, flat end) = **decelerating** — "out". Objects entering a screen should decelerate: fast arrival reads as responsive, the settle makes the end state legible.
- S-curve = accelerate then decelerate — "in-out", for elements that stay on screen and move between two visible states.
- Curve exceeds y = 1 = **overshoot** (passes the target, comes back). Curated overshoot tops out at y2 = 1.275 — 27.5% past target. Never exceed the site's slider bound of y = 2.
- Curve dips below y = 0 = **anticipation** (wind-up in the opposite direction before launch). Curated value: y1 = −0.4 — a 40% backwind. Use only on deliberately playful, user-triggered motion.

### 2. The CSS keywords deconstructed (and the one to escape)

| Site name | Value | Equals | Verdict |
|---|---|---|---|
| Linear | `cubic-bezier(0, 0, 1, 1)` | `linear` | Constant velocity — for progress bars, spinners, hue loops; dead for enter/exit |
| In | `cubic-bezier(0.42, 0, 1, 1)` | `ease-in` | Exits only |
| Out | `cubic-bezier(0, 0, 0.58, 1)` | `ease-out` | Generic entry, weakest member of the out family |
| In Out | `cubic-bezier(0.42, 0, 0.58, 1)` | `ease-in-out` | Position moves within the viewport |
| In Out Base | `cubic-bezier(0.25, 0.1, 0.25, 1)` | `ease` (the CSS default) | What you are replacing — asymmetric and mushy; never choose it deliberately |

### 3. The five curated curves (Lochie Axon's taste, the site's real payload)

| Name | Value | Character | Use when |
|---|---|---|---|
| Quick Out | `cubic-bezier(0, 0, 0.2, 1)` | Instant start, long glide (same curve as Material's deceleration) | Entrances that must feel immediate: toasts, tooltips, hover states |
| Snappy Out | `cubic-bezier(0.19, 1, 0.22, 1)` | Launches ~80% in the first moments, silky settle | The default for entering UI — modals, dropdowns, popovers, panels |
| Swift Out | `cubic-bezier(0.175, 0.885, 0.32, 1.1)` | Fast out + 10% overshoot, one soft correction | Playful entrances where a hint of life beats a pure settle |
| Overshoot Out | `cubic-bezier(0.175, 0.885, 0.32, 1.275)` | Fast out + 27.5% overshoot, visible bounce back | Reward moments: toggle thumbs, confetti triggers, celebratory UI |
| Anticipate | `cubic-bezier(1, -0.4, 0.35, 0.95)` | Wind-up backwards 40%, then slingshot | Deliberate cartoon physics on user-initiated drags/flings — sparingly |

Escalation rule embedded in the set: Quick Out → Snappy Out → Swift Out → Overshoot Out is one axis (settle → 10% past → 27.5% past). Climb it only as the interaction earns attention.

### 4. The power ladder: quad → cubic → quart → quint → expo → circ

Each family is the same shape at increasing intensity — for `out`, a sharper initial burst and a longer tail; for `in`, a later launch and harder landing. Quad is barely off linear; expo is near-instant to ~90% then a long glide; circ has the sharpest catch at the start of its out curve (its bezier sends y1 to 0.82 by x1 = 0.075).

Full catalog (exact values from each page):

| Family | In | Out | In-Out |
|---|---|---|---|
| Quad | `(0.55, 0.085, 0.68, 0.53)` | `(0.25, 0.46, 0.45, 0.94)` | `(0.455, 0.03, 0.515, 0.955)` |
| Cubic | `(0.55, 0.055, 0.675, 0.19)` | `(0.215, 0.61, 0.355, 1)` | `(0.645, 0.045, 0.355, 1)` |
| Quart | `(0.895, 0.03, 0.685, 0.22)` | `(0.165, 0.84, 0.44, 1)` | `(0.77, 0, 0.175, 1)` |
| Quint | `(0.755, 0.05, 0.855, 0.06)` | `(0.23, 1, 0.32, 1)` | `(0.86, 0, 0.07, 1)` |
| Expo | `(0.95, 0.05, 0.795, 0.035)` | `(0.19, 1, 0.22, 1)` | `(1, 0, 0, 1)` |
| Circ | `(0.6, 0.04, 0.98, 0.335)` | `(0.075, 0.82, 0.165, 1)` | `(0.785, 0.135, 0.15, 0.86)` |

- Note: **Out Expo `(0.19, 1, 0.22, 1)` is numerically identical to Snappy Out.** The site re-named the Penner expo-out approximation and made it its flagship. This is the strongest endorsement in the catalog.
- In-Out Expo `(1, 0, 0, 1)` is the extreme of the ladder: hold still, then blast through, then glide. Reserve for very large, deliberate transitions.
- Working defaults from the ladder: Out Cubic (small controls), Out Quart (mid), Snappy Out/Out Expo (default), In-Out Quint (full-screen position moves).

### 5. Springs: the second collection

Ten named springs (all by Lochie Axon), each just three numbers — `stiffness`, `damping`, `mass`. Damping ratio ζ = damping / (2·√(stiffness·mass)) predicts behavior: ζ ≥ 1 no overshoot, ζ ≈ 0.7 one small overshoot, ζ < 0.5 visible bounce. Computed from the site's values:

| Name | stiffness / damping / mass | ζ (computed) | Feel | Use when |
|---|---|---|---|---|
| Swift | 280 / 18 / 0.3 | 0.98 | Nearly critical, fast | Default interruptible UI motion |
| Snap | 320 / 20 / 0.4 | 0.88 | Quick, minimal overshoot | Toggles, chips, small controls |
| Stern | 550 / 30 / 1.2 | 0.58 | Heavy, one firm overshoot | Assertive state changes |
| Fling | 800 / 80 / 4 | 0.71 | Powerful, one soft overshoot | User-thrown elements settling |
| Elegant | 150 / 19 / 1.2 | 0.71 | Slow, one gentle overshoot | Large panels, hero elements |
| Slow | 26.7 / 4.1 / 0.2 | 0.89 | Deliberate, no bounce | Ambient/background drift |
| Float | 290 / 15 / 2 | 0.31 | Soft, multiple bounces | Dreamy, ambient motion |
| Bob | 131.1 / 2.3 / 0.1 | 0.32 | Light, obvious bounce | Playful icons, mascots |
| Bouyant | 900 / 80 / 10 | 0.42 | Heavy mass, slow bounce | Drag release of large surfaces |
| Boingoingoing | 1000 / 1.5 / 0.1 | 0.075 | Barely damped, wild oscillation | Gag/celebration only |

The springs' settle times run ~0.15–1.23s across the set — treat that as the sanctioned range for spring durations in UI (never multi-second).

### 6. Choosing by scenario (derived matrix)

- **Entering the screen** (modal, dropdown, toast): out-easing. Snappy Out for 90% of cases, Quick Out when latency must read as zero, Overshoot Out only for delight moments. Duration 150–400ms.
- **Exiting the screen** (dismiss, close): in-easing, shorter than the entrance (~2/3 of it, 100–250ms). The user has already decided; don't make them wait for a settle they don't need.
- **Moving while visible** (list reorder, carousel, tab indicator): in-out family (In-Out Quint or Cubic). Both endpoints are on screen, so both ends need softness.
- **User-initiated motion** (drag, fling, toggle): spring. Springs retarget mid-flight without velocity jumps — the actual reason to prefer them over bezier, not the bounce.
- **Environment-initiated motion** (page load, auto-reveal): bezier. No interruption expected, so the physics simulation buys nothing.
- **Distance scales duration**: same curve, longer distance → longer duration. Small (≤64px) 150–250ms; medium 250–400ms; large/full-screen 400–600ms.
- **Transform vs color/opacity**: transforms and opacity can take any curve incl. overshoot (GPU-cheap, y > 1 is safe). Color, background, box-shadow: no overshoot, no anticipation — overshooting a color produces ugly out-of-gamut intermediates. Use Out/Quick Out 150–250ms, or crossfade opacity instead.
- **Continuous/looping** (spinners, progress, marquee): Linear only. Easing a loop reads as stutter.

## When to use / When NOT to use

Use when: writing any `transition` or `animation`; choosing spring parameters; building an easing token set; diagnosing motion that "feels off" (it is almost always the timing function, not the duration).

Do NOT use: in place of deciding *whether* to animate (see you-dont-need-animations — if removing the animation changes nothing, no curve helps); for `prefers-reduced-motion` users (swap curves for instant or opacity-only transitions); overshoot/anticipation curves on text-heavy or data-dense surfaces; In easings on entrances (an element that starts stationary after appearing reads as laggy); springs for color/box-shadow (per-frame re-solve of non-composited properties jank).

## How to apply

1. Classify the animation: enter / exit / move / loop; distance band (small / medium / large); property type (transform+opacity vs color).
2. Pick from the matrix above; when torn, take Snappy Out `(0.19, 1, 0.22, 1)` for entries, In `(0.42, 0, 1, 1)` for exits, In-Out Quint `(0.86, 0, 0.07, 1)` for moves.
3. Define the catalog once as tokens; never inline raw beziers at call sites:

```css
:root {
  /* CSS keyword equivalents */
  --ease-linear: cubic-bezier(0, 0, 1, 1);
  --ease-in: cubic-bezier(0.42, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.58, 1);
  --ease-in-out: cubic-bezier(0.42, 0, 0.58, 1);
  /* curated set (Lochie Axon) */
  --ease-quick-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-snappy-out: cubic-bezier(0.19, 1, 0.22, 1);
  --ease-swift-out: cubic-bezier(0.175, 0.885, 0.32, 1.1);
  --ease-overshoot-out: cubic-bezier(0.175, 0.885, 0.32, 1.275);
  --ease-anticipate: cubic-bezier(1, -0.4, 0.35, 0.95);
  /* ladder picks */
  --ease-out-cubic: cubic-bezier(0.215, 0.61, 0.355, 1);
  --ease-in-out-quint: cubic-bezier(0.86, 0, 0.07, 1);
}
```

4. Apply asymmetric enter/exit — entrances settle, exits hurry:

```css
.panel       { transition: transform 250ms var(--ease-snappy-out), opacity 250ms; }
.panel[data-closing] { transition: transform 150ms var(--ease-in), opacity 150ms var(--ease-in); }
```

5. For springs, implement the mechanism (Hooke's law + drag), or feed the three numbers to a spring engine:

```js
// The physics every spring library runs — stiffness/damping/mass, per frame:
function spring(stiffness, damping, mass, from, to, done) {
  let x = from, v = 0, last = performance.now();
  (function tick(now) {
    const dt = Math.min((now - last) / 1000, 0.064); last = now;
    const a = (-stiffness * (x - to) - damping * v) / mass;
    v += a * dt; x += v * dt;
    if (Math.abs(x - to) < 0.001 && Math.abs(v) < 0.001) return done(x);
    done(x); requestAnimationFrame(tick);
  })(last);
}
spring(320, 20, 0.4, 0, 1, v => el.style.transform = `scale(${v})`); // "Snap"
```

6. Installing a spring/animation library is justified only when you need interruption-aware retargeting (drag-follow, gesture velocity handoff) or scroll-linked motion — the three numbers above then port directly (`stiffness: 320, damping: 20, mass: 0.4`).
7. Verify against the source behavior: preview at easing.dev, cross-check the y-extremes (overshoot ≤ 1.275, anticipation ≥ −0.4) and duration bands (150–600ms bezier, 0.15–1.2s spring) before shipping.
8. Gate everything: `@media (prefers-reduced-motion: reduce) { * { transition-duration: 0.01ms !important; animation-duration: 0.01ms !important; } }`.

## AI-slop warning

AI defaults to `ease` everywhere, or to one loud curve everywhere. Both are slop. The tells: overshoot on color fades (out-of-gamut flashes), `ease-in` on entrances (elements that appear to hesitate), a bouncy spring (ζ < 0.3) on every micro-interaction until nothing reads as urgent, anticipation curves on system-triggered motion (wind-up the user never caused), and 800ms+ durations on 8px movements. Also: easing is not a personality — three escalating curves on one screen reads as noise. Pick the one-line house set (Quick Out, Snappy Out, In, In-Out Quint + one spring), tokenize it, and deviate only with a reason. Do not credit Emil Kowalski for these curves in comments or docs — easing.dev is Alex Vanderzon and Lochie Axon's site.

## Relations

- **transitions** — when to animate at all and which property pairs to transition; this skill supplies the timing-function values for those transitions.
- **emil-skills** — Kowalski's animation teaching (frequently and wrongly cited as easing.dev's author); his enter/exit duration doctrine pairs with this catalog's curves.
- **you-dont-need-animations** — the veto that runs before this skill: no curve choice rescues an animation that shouldn't exist.
- **number-flow** — spring-driven number interpolation in production; consumes the spring table (§5) directly.
- **web-interface-guidelines** — its motion section prescribes duration classes and animation types; combine with these exact beziers.
