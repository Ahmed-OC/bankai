---
name: dither-kit
description: Use when a design needs dithered pixel texture — charts, gradient washes, hero fades — or when smooth gradients band. Covers Bayer ordered dithering, density fades, and opacity-based colour that survives light and dark themes.
source: https://www.tripwire.sh/dither-kit; https://github.com/Boring-Software-Inc/dither-kit
category: library
---

# dither-kit — dithering as an aesthetic and a technique

Source: https://www.tripwire.sh/dither-kit — docs + live demos by Boring Software Inc (tripwire.sh); source of truth is `registry/dither-kit/` in github.com/Boring-Software-Inc/dither-kit (MIT-style shadcn registry; files land in your repo). Aesthetic credit in the source goes to Evil Charts (evilcharts.com). The kit is Tailwind/shadcn-based; every mechanism below is ported to plain CSS/JS.

## What it is / Why it exists

A family of dithered components — area/line/bar/pie/radar charts, `Sparkline`, `DitherAvatar`, `DitherButton`, `DitherGradient` — all rendered by one tiny ordered-dither canvas engine (~1 file, `dither-paint.ts`). No recharts; a recharts-style children-as-config API (`data` + `config` + `<Area dataKey=… variant=…>`). Runtime deps are capped at `react, motion, d3-scale, d3-shape, clsx, tailwind-merge` (a stated repo rule).

Why it was designed:

1. **Texture over smoothness.** Flat fills read as default; smooth gradients read as generic SaaS. An ordered-dither fill gives data-viz and backgrounds a deliberate retro-1-bit texture (early Mac, Game Boy, dot-matrix terminals) at near-zero cost.
2. **Banding fix.** Large subtle gradients band in 8-bit displays. Dithering trades banding for intentional noise — the eye reads texture, not steps.
3. **One look, both themes.** The engine's stated guiding rule (verbatim from `dither-paint.ts`): "Work with opacities instead of different shades of the same color. This will make sure it looks good on both light and dark mode." A lighter shade that pops on dark reads as a harsh speck on light; the same hue at lower alpha just blends.

## The core ideas

### 1. Ordered (Bayer) dithering — the engine's algorithm

A fixed threshold matrix tiled across pixels; a cell is lit when its target coverage ("density") exceeds the threshold. The kit's exact matrix (`BAYER4`):

```js
// 4x4 Bayer matrix, normalized to 0-1 thresholds: (v + 0.5) / 16
const BAYER = [
  [0, 8, 2, 10],
  [12, 4, 14, 6],
  [3, 11, 1, 9],
  [15, 7, 13, 5],
].map((row) => row.map((v) => (v + 0.5) / 16))

// coverage 0-1 -> boolean per cell (x, y in cell units)
const lit = density > BAYER[y & 3][x & 3] - 0.1 * intensity  // hover lifts threshold
```

- 2×2 Bayer `[[0,2],[3,1]]/4` = coarse, chunky; 4×4 (above) = the kit's choice, reads "pixelated" while still rendering ramps; 8×8 = finer, more photographic. Bigger matrix = smoother gradient, less retro.
- Ordered dithering is **deterministic and stable**: a cell's value depends only on (x mod 4, y mod 4) and density, so the texture never shimmers on resize, hover, or animation. This is why the kit uses Bayer rather than error-diffusion (below).

### 2. Error diffusion (Floyd–Steinberg) — the classic alternative, deliberately NOT used here

FS pushes each pixel's quantization error to neighbors, producing photo-accurate 1-bit images:

```js
// per pixel, top-left to bottom-right, err = old - new (per channel)
dist[x + 1][y]     += err * 7 / 16
dist[x - 1][y + 1] += err * 3 / 16
dist[x][y + 1]     += err * 5 / 16
dist[x + 1][y + 1] += err * 1 / 16
```

Because each pixel depends on every pixel before it, FS output reorders wholesale on resize and animates as shimmer. Use it for static images (posters, processed hero images), never for interactive charts. The kit's density-modulated Bayer gives the same "dissolving gradient" feel with zero temporal instability.

### 3. Palette quantization

Reducing to a small palette: pick nearest entry per pixel (Euclidean RGB is fine for pixel aesthetics), then dither the residual with Bayer or FS. For 1-bit, threshold luminance `0.2126R + 0.7152G + 0.0722B` at 0.5, or at `BAYER[y&3][x&3]` for ordered 1-bit. The kit's own quantization is binary within one hue: a cell is either lit (full alpha tier) or off (faint tint of the same hue) — 7 seed fills:

```js
// kit palette (fill RGB): green [40,210,110]  blue [53,143,243]  purple [150,110,255]
// pink [240,90,190]  orange [255,150,50]  red [240,70,70]  grey [92,92,100] (no-data)
```

### 4. Density-modulated dither (the signature fill)

For an area/bar column, density ramps 0 at the value line → 1 at the floor, so fill is solid at the base and dissolves upward toward the line. Exact constants from the engine:

```js
const CELL = 2            // css px per dither cell — chunky enough to read pixelated
const BORDER_ALPHA = 0.72 // top outline, "just under solid" so it reads as a soft edge
const OFF_TIER = 0.4      // off-cell alpha relative to on-cell (never a stark hole)

function paintColumn(octx, x, top, floor, fill, { variant, intensity = 0, stacked } = {}) {
  let density = (y - top) / (floor - top)            // per row y: 0 at line, 1 at floor
  if (stacked) density = 0.5 + 0.5 * density         // stacked layers: denser, solid floor
  const bias = (variant === "dotted" ? 0.12 : 0) + (stacked ? 0.2 : 0)
  if (variant === "hatched" && ((x + y) & 3) >= 2) continue  // diagonal hatch mask
  const lit = variant === "solid" || density > BAYER[y & 3][x & 3] - 0.1 * intensity - bias
  const k = (0.3 + density * 0.7) * (1 + 0.22 * intensity)   // hover lifts alpha 22%
  const alpha = lit ? k : k * OFF_TIER                       // off = same hue, 0.4x alpha
  octx.fillStyle = rgba(fill, alpha); octx.fillRect(x, y, 1, 1)
  // then: top outline at 0.72 alpha + one feather row at 0.36 beneath it
}
```

Variants are masks over this one loop: `gradient` (density fade), `dotted` (+0.12 bias, real gaps left unlit), `hatched` (`((x+y)&3)>=2` skip), `solid` (no dither).

### 5. The rendering trick: low-res canvas + `image-rendering: pixelated`

Never draw dither cells at device resolution. Paint 1 cell = 1 backing-canvas pixel, cap the backing store (kit: 520×200 cells for charts, 960×600 for background washes), scale up via CSS:

```jsx
const cols = Math.min(520, Math.round(width / CELL))   // e.g. 600px wide -> 300 cols
canvas.width = cols; canvas.height = rows              // tiny backing store
// CSS: position absolute, inset 0, width/height 100%, and:
<canvas style={{ imageRendering: "pixelated" }} />
```

A full-width dithered chart costs a 300×150-ish canvas — cheaper than any SVG filter.

### 6. Bloom — colour-faithful glow, pure CSS

A second canvas layered over the crisp one: a blurred copy composited additively so each hue glows in its own colour instead of a grey wash:

```js
// presets from the kit (CSS on the bloom layer, canvas content is a plain copy):
low:  { blur: "3px",  brightness: 1.35, opacity: 0.70, saturate: 1.4 }
high: { blur: "5px",  brightness: 1.50, opacity: 0.78, saturate: 1.5 }
aura: { blur: "15px", brightness: 2.90, opacity: 0.10, saturate: 3.0 }
// style: filter: blur() brightness() saturate(); mix-blend-mode: plus-lighter;
```

### 7. Two-tone dither blend and dissolve (DitherGradient)

A background wash filling its nearest positioned ancestor, repainted once per size change (ResizeObserver), no animation loop. `t` runs 0 at the solid edge → 1 at the dissolve edge, `density = 1 - t`:

- Two colours: every cell painted; the dither decides **which** colour (`lit ? from : to`).
- Dissolve to transparent: lit cells `alpha = 0.35 + 0.65 * density`; off cells keep a faint tint `0.12 * density` (the anti-banding tier trick again); skip cells below `alpha <= 0.004`.

### 8. Deterministic generative avatars (DitherAvatar)

32 mirrored pattern bits × 2 mirror axes × 180 hues ≈ 1.5 trillion avatars, stable per name: FNV-1a hash (`h = 0x811c9dc5`, `h ^= code; h = Math.imul(h, 0x01000193)`) seeding an xorshift32 PRNG (`s^=s<<13; s^=s>>>17; s^=s<<5`). Same inputs → same avatar, no storage.

### 9. Interaction hygiene

Entrance easing `easeInOutCubic`; hover lift = threshold shift `0.1 * intensity` + alpha `×(1 + 0.22·intensity)`; everything static unless interacting. Both primitives gate on `matchMedia("(prefers-reduced-motion: reduce)")` — entrances snap, sparkles hold steady. Copy this gate.

## When to use / When NOT to use

Use dithered fills when:
- Dev tools, terminal-style UIs, CLI brands, changelogs — the texture signals "close to the metal".
- Hero/footer background washes where a smooth gradient would band or read generic; dither is the intentional version of the noise-dither you'd add anyway.
- Dashboard charts needing identity without heavy theming — one 2px-cell canvas replaces gradient fills and works on light/dark unchanged (the opacity rule).
- Sparklines, generative avatars (deterministic per user), poster-style 1-bit imagery (FS for static photos).

Do NOT when:
- Text sits on the dither — 2px cells shred glyphs; keep text panels solid or blur the dither behind them.
- Precise analytical reading matters — dithered area density can be misread as data (more dots = more value). Use `solid` variant or plain charts for analyst-facing tools.
- Conservative/enterprise contexts — the aesthetic reads as stylized/retro, not neutral.
- The surface is smaller than ~8×8 cells (16px at CELL=2) — the pattern collapses into mud; drop to a plain fill.
- You need photographic smoothness — dither is a look, not a free lunch; 8×8+ matrices only get you "grainy".

## How to apply

1. Decide the cell size first: 2px = chunky retro (kit default), 3px for background washes (`DitherGradient` default), 1px only for fine 8×8 matrices.
2. Paint to a capped low-res backing canvas (≤520×200 for in-page charts, ≤960×600 for washes) and scale with `image-rendering: pixelated`. Never dither at device resolution.
3. Use the 4×4 Bayer matrix verbatim (it is the canonical one); compare `density > BAYER[y & 3][x & 3]`.
4. One hue per surface, two alpha tiers: on = `(0.3 + 0.7·density)`, off = on × 0.4. No second shade, no raw background holes.
5. For fades, drive density geometrically toward the edge you want visible; outline the edge at 0.72 alpha with one 0.36 feather row.
6. Bloom via a duplicated blurred layer with `mix-blend-mode: plus-lighter`; start from the `aura` preset for page washes, `low` for charts; keep the crisp layer untouched underneath.
7. Static images only: Floyd–Steinberg (7/3/5/16 kernel) for photo-accurate 1-bit; never FS on anything that resizes or animates.
8. Gate all entrance animation on `prefers-reduced-motion`; entrances use `easeInOutCubic` over ~300–600ms.
9. Limit dither to ONE surface per view (hero wash OR hero chart, not both, not also the button and avatar).

## AI-slop warning

Dither has become a terminal-core cliché (2024–26): green-monochrome, CRT-glow, dithered-everything "cyberdeck" landing pages — now an AI-generated-dev-tool tell. The failure mode is applying it as a costume: dithered hero + dithered chart + dithered buttons + dithered avatar + scanlines on one page reads as parody. Also: do not fake dither with random noise or `feTurbulence` — that is film grain, not an ordered matrix, and it visibly shimmers; do not animate FS dither frame-to-frame (nauseating); do not dither photographs of people (reads as distortion, not style); do not place body text over dithered fills. If the brand isn't technical or playful, a dithered surface is slop on arrival.

## Relations

- **dot-matrix** — sibling retro-1-bit aesthetic (dot-matrix/impact-printer grids vs screen-pixel Bayer texture); use for the same brand families, never both textures on one surface.
- **gradientool** — smooth-gradient craft; dithering is the counter-move when gradients band or feel generic — read both before choosing.
- **images-in-motion** — image treatment/animation effects; its rules for static-image processing pair with FS dithering for poster-style hero media.
- **web-interface-guidelines** — the a11y guardrails (contrast, reduced-motion) that dithered surfaces must not violate; the 0.4 off-tier exists to preserve perceived contrast.
- **bankai** — canon index that dispatches to this skill when a dithered or pixel-textured surface is requested.
