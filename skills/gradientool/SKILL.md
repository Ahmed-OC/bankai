---
name: gradientool
description: Use when building any gradient — backgrounds, gradient text, borders, or generative art. Encodes Oklab interpolation, 3–4-stop lightness ramps anchored to the base color, hue drift, and stepped bands instead of naive two-stop sRGB fades.
source: https://gradientool.com/
category: tool
---

# GRADIENTOOL — the method behind good gradients

Source: https://gradientool.com/ — free browser tool by Leo Benzoni (@leobenzoni). A generative gradient-artwork editor (Space to randomize, locks, rolls, layers, animation, PNG/JPG/MP4/standalone-HTML export). No public docs; the methodology below is recovered from the site's client bundle (verifiable constants cited inline). No license stated.

## What it is / Why it exists

A canvas-based generator that turns one 3–4 stop gradient plus a "skyline" of bars, rings, or wedges into finished artwork. It exists because hand-picking gradient stops in sRGB produces muddy midpoints and dead halos; the tool solves this mechanically — every interpolation happens in **Oklab**, palettes are generated as anchored lightness ramps, and composition is found by generate-and-test with a coverage gate, not by search. The tool is art-oriented, but the gradient engine is a general method: apply it whenever you emit a gradient, whether as a background, clipped text, or a border.

## The core ideas

### 1. Interpolate in Oklab, never raw sRGB

Every blend in the tool (stop-to-stop, duotone LUT, grain) goes hex → linear sRGB → Oklab → lerp → sRGB. CSS equivalent — declare the space:

```css
background: linear-gradient(in oklab, #000 0%, #2345e0 44%, #ff9dc5 72%, #fbf0ee 100%);
```

That exact declaration is the tool's default gradient. `in oklab` (and `in oklch`) works for `linear-`, `radial-`, and `conic-gradient()` in all modern browsers. Without it, sRGB interpolation drags blue→pink through gray-purple. Ban two-stop sRGB gradients (`linear-gradient(#a, #b)`) outright unless both stops are the same hue.

### 2. The stop scaffold: 3–4 stops, pad to the ends, jitter the middle

The tool's own generator picks **3 stops (2/3 of the time) or 4 stops (1/3)**, then:
- sorts stops by position, clamps positions to [0,1];
- **pads**: the first color is duplicated down to 0%, the last up to 100% — never leave an unpainted gap before the first stop;
- **jitters middle stops ±9%** around even spacing — perfectly even stops read as mechanical.

Use its shipped default as the canonical ramp shape: dark anchor (0%), saturated mid (~44%), tint (~72%), near-white (100%) — i.e., a monotonic lightness climb with hue travel packed into the middle.

### 3. Palette generation = lightness ramp anchored to the base color

The randomizer (verbatim algorithm, HSL terms; `bg` = the artwork background):

```js
function palette(bgHex) {                      // bg: the surface the gradient lives on
  const [bh, bs, bl] = hsl(bgHex);
  const dir  = bl < 50 ? 1 : -1;               // dark bg -> climb lighter; light bg -> sink darker
  const span = dir > 0 ? 100 - bl : bl;        // room available in the travel direction
  const hue0 = Math.random() * 360;
  const hueSpan = pick([0, 30, 60, 120, 180]); // hue travel: none | analogous | split | half-wheel
  const hueDir  = Math.random() < 0.5 ? -1 : 1;
  const n = pick([3, 3, 4]);
  const stops = [];
  for (let i = 0; i < n; i++) {
    const t = i / (n - 1);
    const pos = (i === 0 || i === n - 1) ? t : t + (Math.random() - 0.5) * 0.18;
    let h, s, l;
    if (i === 0)                               // anchor: bg hue, slightly oversaturated
      [h, s, l] = [bh, clamp(bs * 0.85 + rand(0, 12)), clamp(bl + dir * rand(0, 6))];
    else if (i === n - 1)                      // terminus: 55–92% of the available range
      [h, s, l] = [hue0 + hueDir * hueSpan, rand(30, 95), clamp(bl + dir * rand(0.55, 0.92) * span)];
    else                                       // mids: monotonic ramp, high chroma
      [h, s, l] = [hue0 + hueDir * hueSpan * t, rand(55, 95),
                   clamp(bl + dir * (0.15 + 0.7 * t) * span + rand(-8, 8))];
    stops.push({ pos: clamp(pos), color: hslToHex(h, s, l) });
  }
  return stops.sort((a, b) => a.pos - b.pos);
}
```

Rules worth hard-coding: lightness moves **monotonically** away from the base color; mids carry saturation 55–95, the terminus may drop to 30; hue moves monotonically along a span of 0/30/60/120/180°; stop 1 keeps the base hue.

### 4. Hue discipline: rotate in Oklab, drift across elements

- **Hue rotate** (global retint) rotates the a/b plane in Oklab per stop — identical to `oklch(from <color> l c calc(h + <deg>))` in relative-color CSS. Use it to retheme a finished gradient without re-picking colors.
- **Hue drift** shifts hue per element across a series: linear layout uses a ramp from −drift/2 to +drift/2 (`deg * (i/(n−1) − 0.5)`); full-circle layouts (radial/orbit, sweep 360°) use a triangular profile (`deg * (0.5 − |2i/n − 1|)`) so the hue returns to its start and the loop closes seamlessly. The randomizer uses drift 0 for 55% of rolls and otherwise ≤ ±90°.

```css
/* per-element hue drift over a series of custom props */
--c1: oklch(from var(--base) l c calc(h + calc(var(--i) / var(--n) * 60deg - 30deg)));
```

### 5. Stepped bands: quantize instead of dithering

`steps` (N ∈ {2,3,4,5,6,8}) re-samples the continuous ramp into N flat bands — band i takes the color at its center `(i + 0.5) / N`, emitted as hard stop pairs. The randomizer keeps it smooth 75% of the time. CSS shape:

```css
background: linear-gradient(in oklab,
  #000  0%,   #000  24.9%,
  #2345e0 25%, #2345e0 49.9%,
  #ff9dc5 50%, #ff9dc5 74.9%,
  #fbf0ee 75%, #fbf0ee 100%);
```

Pair each boundary as `X% / X−0.1%` to avoid browser anti-alias fringes.

### 6. Three ways to map one gradient onto repeated elements

- **field** — one full-height gradient behind every element (single parent background; elements punch through). Default mental model.
- **bar** — each element gets its own gradient starting at its own top edge and ending at the field's bottom, so color is continuous across elements of different heights. Replicate by hand: bake the ramp once, then per element compute its stop positions as `(0 − top)/H … (1 − top)/H` clamped — or emit the ramp on the parent and make children transparent.
- **across** — each element is a flat color sampled at `i / (n − 1)`; the series *reads as* the gradient. Cheapest for wide layouts and data-driven strips.

Randomizer weights: bar 60%, field 25%, across 15%.

### 7. Alpha ramps for depth/shadow: eased, not linear

The tool's relief shading uses fixed alpha stops `1 / 0.844 / 0.5 / 0.156 / 0` at `0 / 25 / 50 / 75 / 100%` (a cosine-shaped ease-out), and a second ramp `a / 0.5a / 0.15a / 0` at `0 / 30 / 65 / 100%` for soft shadows. Steal both for vignettes, glows, and `box-shadow` falloffs — linear alpha ramps band visibly on dark UI.

```css
box-shadow: inset 0 -60px 80px -20px rgb(0 0 0 / 0.5),
            inset 0 -140px 120px rgb(0 0 0 / 0.156);
```

### 8. Composition by generate-and-test, gated on coverage

Randomize rolls structure up to **12 times**, accepting the first roll where every layer's coverage `mean(min(1, barHeight)) ≥ 0.15` (non-linear layouts scale the threshold by `√(sweep/360)`). Translation for UI work: when composing a gradient system, generate several candidates against a cheap numeric gate (min contrast, stop count, lightness monotonicity) instead of hand-tuning one.

### 9. Baking sampler (replicates the tool's engine)

The tool pre-samples every gradient into **40 evenly spaced Oklab-lerped colors** before painting — this is what feeds canvas `addColorStop`:

```js
function bake(stops, N = 40) {                 // stops: [{pos, color:'#rrggbb'}]
  const s = [...stops].sort((a, b) => a.pos - b.pos);
  if (s[0].pos > 0) s.unshift({ ...s[0], pos: 0 });       // pad to 0/1 (idea 2)
  if (s.at(-1).pos < 1) s.push({ ...s.at(-1), pos: 1 });
  const out = [];
  for (let i = 0; i <= N; i++) {
    const t = i / N;
    let k = 0; while (k < s.length - 2 && s[k + 1].pos <= t) k++;
    const u = (t - s[k].pos) / (s[k + 1].pos - s[k].pos || 1);
    out.push([t, oklabLerp(s[k].color, s[k + 1].color, u)]);  // Oklab lerp, idea 1
  }
  return out;                                   // [[t, cssColor]...] — feed to any renderer
}
```

Use baking when the target can't interpolate in oklab itself (canvas 2D, SVG `<linearGradient>`, older browsers); otherwise prefer native `in oklab`.

### 10. Finishing passes the tool always applies

- **Layers**: max 2, second layer default `mix-blend-mode: multiply`, per-layer opacity.
- **Grain**: gaussian-ish (sum of 3 uniforms) luminance noise ±40/255 plus chroma noise ±5/255 — applied at 0.35–0.75 intensity on most rolls. A few percent of noise kills gradient banding.
- **Treatments** (mono/duotone): luminance = `0.2126r + 0.7152g + 0.0722b`; duotone maps it through a 256-entry LUT interpolated **bg→fg in Oklab**, blended by an `intensity` knob. Also available: dither (blue noise / Bayer 4×4 / 8×8, 2–8 levels), halftone, threshold, lines, crosshatch, contour, ASCII, blockify, pixel sort, VHS.
- **Structure defaults** when generating bar/ring art: 9 bars, min depth 0.45, curve exponent 1 (range 0.3–4), width exponent 0 (range −2–2), gap ≤ 0.45, sweep 360°, inner radius 0.35.

## When to use / When NOT to use

Use when: any hero/section background, gradient text (`background-clip: text`), gradient borders, image overlays, generative art or placeholder covers, dark-mode surfaces needing depth without shadows.
Skip when: the design calls for flat color or a hard edge (gradients are not texture filler); brand palettes already fix exact stops; performance-critical large animated areas (animate `--angle` on a hue-span-0 ramp, which stays cheap, or use a static asset).

## How to apply

1. Take the surface's base color. Compute `dir` and `span` (idea 3). If the base is mid-gray, pick a direction deliberately — do not straddle.
2. Generate 3–4 stops: anchor at base hue; mids at `base ± (0.15 + 0.7t)·span` lightness, S 55–95; terminus at 0.55–0.92 of span. Hue span from {0, 30, 60, 120, 180}°.
3. Emit CSS with `in oklab`. Pad first/last colors to 0%/100%. Jitter middle stops a few percent off even spacing.
4. Series of elements? Choose field / bar / across (idea 6); add hue drift ≤ 90° (linear profile for rows, triangular for loops).
5. Need bands instead of a smooth ramp? Quantize to 2–8 steps with paired hard stops (idea 5).
6. Add finishing: ≤ 2 layers (multiply for the second), grain 2–5% on large areas, eased alpha for any shadow/vignette (idea 7).
7. Validate: lightness monotonic along the ramp; midpoint not gray; contrast of text over the lightest/darkest regions ≥ 4.5:1 (or pin a scrim).
8. For canvas/SVG targets, bake 40 Oklab samples (idea 9) instead of trusting the renderer's default interpolation.

## AI-slop warning

The failure mode this skill prevents: two-stop sRGB gradients between a "brand blue" and a "brand purple" — gray middles, no lightness plan. The failure mode it can cause: over-decoration. Hue spans > 180°, 5+ stops, drift on every element, grain on buttons — each reads as AI-generated wallpaper. Keep the tool's own odds: 3 stops usually, hue span 30–120 usually, drift zero more often than not, smooth (not stepped) 75% of the time. A gradient must survive having text placed on it; if you squint and see only "light top, dark bottom", it is doing its job.

## Relations

- **oklch** — the color-space math underneath idea 1; use it for building the palette itself (perceptual lightness steps), while this skill governs ramp construction and stop placement.
- **easing** — the tool's animation easings (in `t²`, out `1−(1−t)²`, sine `(1−cos πt)/2`, ping-pong) mirror idea 7's alpha curves; same curves drive motion between keyframes.
- **gradient-border** — application target: border treatments built from these ramps (`border-image` or double-background padding-box/border-box technique).
- **taste** — the restraint governor for the slop risks above; consult before shipping any hero-scale gradient.
