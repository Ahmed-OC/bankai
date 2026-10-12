---
name: liquid-glass
description: Use when building Apple-style Liquid Glass or frosted-glass UI. Encodes the SDF displacement-map refraction technique — SVG feDisplacementMap, chromatic dispersion, specular sheen — with exact optics and browser physics.
source: https://glass.samasante.com/; https://github.com/samasante/liquid-glass; https://aave.com/design/building-glass-for-the-web
category: library
---

# Liquid Glass — the Apple glass material, rebuilt for the web

Source: https://glass.samasante.com/ — live demo + docs for `liquid-glass` by Sam Asante. Code: https://github.com/samasante/liquid-glass (MIT, npm `@samasante/liquid-glass`, React-only peer, zero runtime deps). Technique lineage: Apple's "Liquid Glass" (iOS 26-era material), implementation approach documented by Aave's team in "Building glass for the web"; kindred take in `liquid-dom`. Not affiliated with Apple.

## What it is / Why it exists

A headless React **lens** that refracts the *live* DOM — text stays selectable, links stay clickable — using an SVG `feDisplacementMap` fed by a generated displacement map. Every other approach fails on one axis:

| Approach | Live DOM | Safari + Firefox | Cost |
|---|---|---|---|
| `backdrop-filter: url(#svg)` | yes | **no** — Chromium-only; others drop to flat blur or drop the whole declaration | cheap |
| WebGL + `html2canvas` snapshot | **no** — frozen, stale pixels under the glass | yes | large (three.js) |
| `filter: url(#svg)` on owned DOM (this) | yes | **yes** — Chromium, WebKit (incl. iOS), Firefox | tiny, 0 deps |

Design gap it fills: (a) cross-engine refraction, not just frost; (b) headless — you style the box, it becomes a material, vs. opinionated widget libraries; (c) one optics vocabulary driving both the SVG path and a WebGL path for media. Core honesty: bending *arbitrary* content *behind* a panel requires `backdrop-filter: url()`, which ships in Blink only — so bending everywhere means refracting a copy or your own children.

## The core ideas

### 1. The displacement map is the whole trick

Rasterize a rounded-rect signed-distance field to a canvas (default 512×512) encoding per-pixel:

- **R** = X displacement, **G** = Y displacement — 0.5 (byte 128) is neutral, encode as `(0.5 + d) × 255`
- **B** = specular/glow mask — 128 = none, 255 = full (`127 × spec + 128`)

Outside the SDF (sdf ≥ 0): neutral gray, zero displacement, zero specular. Only the top-left quadrant is computed; the other three mirror it with flipped displacement signs — per-pixel work cut to 1/4. The map regenerates **only when the lens changes shape** (size/radius/optics), never when it moves — motion carries via filter-region shift, so a pointer-following lens stays 60fps.

Displacement field composition: a **spherical-cap dome** for the magnified "liquid" middle — cap radius `R = (a² + h²) / 2h`, gradient `x/√(R² − x²)` normalized so mean displacement lands at 0.5 — plus a **rim meniscus** (`bend`): a bump `6.75·s²(1−s)` peaking at s = 2/3 inside a band of `bendWidth × min(W,H)` (default 0.16), so the background wraps *inside* the lip, never at the clip line. Edge feather uses `erf(x) ≈ tanh(√π·x)`.

### 2. The SVG filter chain

`feDisplacementMap` on the content via `filter: url(#…)`; `dispScale = strength × √((w²+h²)/2)`. Chromatic aberration = 3 displacement passes additively composited (`feComposite arithmetic k2=1 k3=1`): red at `scale × (1 + 0.22·dispersion)`, green at `× (1 + 0.11·dispersion)`, blue at base — each isolated through a zeroing `feColorMatrix`. Specular: lift the map's B channel (128→0, 255→1 via `feColorMatrix` offset `−128/255`), composite over the refraction with `k2 = specular`. Two mandatory hygiene passes: `feFlood rgb(128,128,128)` under the `feImage` map (transparent-black outside it contorts box edges), and a filter-region margin ≈ `ceil(dispScale × 1.2 × 0.5 + 28)` px so rim displacement samples real pixels outside the box.

### 3. Material mode is one CSS property

`backdrop-filter: blur(frost px) saturate(s)` frosts + tints cross-browser; append `url(#id)` for the bend — **Blink only**. Engine-sniff `navigator.userAgentData != null` (Blink exposes it; WebKit/Gecko don't; on iOS every browser is WebKit). Bias toward false negative: a wrongly-*enabled* Safari receives invalid `url()` syntax and drops the **entire** `backdrop-filter` — no frost at all. `@supports` is unreliable here (engines parse `url()` without rendering it).

### 4. Optics vocabulary (exact defaults)

Balanced lens defaults / material-mode overrides: `strength` 0.06 → 0.05 (max pixel move as 0–1 fraction of box; `scaleX`/`scaleY` override per axis for anisotropic lenses); `depth` 0.65 → 0.5 (how far the bend reaches in; **gates** curvature — thin depth keeps the center flat however high curvature is); `curvature` 0.6 → 0.3 (convex dome); `dispersion` 0.5 → 0.32; `bend` 0 → 0.45 (rim meniscus; 0 = plain magnifier); `bendWidth` 0.16; `frost` 0.5 → **6 px** (material mode frost is the CSS blur radius); `saturate` 1.15 (>1 vivid, <1 the milky Apple veil); `sheen` 0.3 → 0.32, `sheenWidth` 3 px, `sheenFalloff` 1.5, `sheenAngle` 45° (directional rim highlight pools toward the light corner; a 0.16 floor keeps a faint rim all around); `glow` 0.12 → 0.1, `glowSpread` 1, `glowFalloff` 0.5 (soft inner glow, smoothstep-faded); `brightness` 0.1 → 0 (white/black veil); `specular` 1 (master gain over sheen + glow); `splay` 0 (corner flare).

### 5. The edge light is CSS, not filter

Cross-browser bright edge, additive over everything: `inset 0 1px 0 rgba(255,255,255,0.55)` (top highlight) + `inset 0 0 0 1px rgba(255,255,255,0.12)` (hairline rim), both scaled by `specular`. **No dark edge anywhere** — a dark line reads as a bevel, which the author explicitly rejects. Tint rule: the wrapper's `background` color IS the tint and must be translucent; a fully opaque background hides the refraction (dev-warn resolves alpha by painting the computed color into a 1×1 canvas, so it catches `oklch`/`color()` too).

### 6. Four modes, one rule

1. **Material** — wrap styled children; frost+tint+edge everywhere, bend in Chrome/Edge.
2. **In-place** — pass geometry (`size` + `center` as 0–1 fractions); the lens bends its own children, no copy.
3. **`refract={node}`** — lens over content it doesn't own (panel over a photo); `behind` fills the copy's bleed edge (or `"transparent"` to opt out).
4. **`src`/`draw` + `lenses`** — one WebGL renderer samples a `<video>`/`<canvas>` (Safari can't SVG-filter live video) and draws many lenses from one surface — each video-player control is its own lens `{x, y, w, h, radius}` in full px.

Invariant across all modes: **children are the crisp layer on top.**

### 7. Motion + the Safari gauntlet

`width`/`height`/`radius`/`center` accept motion values (anything with `{get(); on('change', cb)}` — framer-motion compatible) written imperatively per frame, no React re-render. WebKit fixes that kill most ports, all required: (1) no supersampling — `filterResolution 2` passes WebKit's source-graphic size ceiling and it *silently* drops chroma+specular passes, so force 1×; (2) regen the map only on shape change — `feImage` href churn mid-drag makes Safari throttle and the shine/chroma vanish until you stop; (3) version-bump the filter id (and re-point `style.filter`) every geometry change — WebKit caches filter output by id and freezes stale; (4) read the specular from the pre-composite map — WebKit's `feComposite` ordering differs.

## When to use / When NOT to use

Use for: small, content-sized controls **over dynamic visual content** — video transport bars, a lens/loupe following the pointer over a hero, notifications and context menus floating on wallpapers/photos, macOS-style switches and sliders where the thumb bends the track. Use frost-only (plain `backdrop-filter: blur() saturate()`) when the surface sits over static or low-contrast backdrops — refraction over a flat background reads as noise, not glass.

Do NOT use for: text-heavy reading surfaces (frost + veil + refraction under body copy murders legibility — WCAG contrast must be measured against the *refracted* backdrop, which varies per frame); large surfaces (SVG filters are GPU-bound; Safari's size ceiling drops passes); wide dock-style bars — a single stretched displacement lens blooms an **oval**, use frost-only and reserve the lens for content-sized elements; glass-on-glass stacking; forms and data tables. The cheap native alternative when you don't need bending: translucent `background` + `backdrop-filter: blur(6px) saturate(1.15)` + the two inset shadows — 3 lines, every browser, no library.

## How to apply

1. Decide the mode by what sits *behind* the glass: own children → in-place; sibling node → `refract` + `behind` fill; `<video>`/canvas → `src`/`draw` + `lenses`; arbitrary page behind a fixed panel → accept Blink-only bend or frost-only.
2. Start from the material defaults; change at most 2–3 optics. `strength` ≤ 0.06, `dispersion` ≤ 0.5 — above that the rim turns into a circus.
3. Make the wrapper background translucent (alpha 0.3–0.5 tint); never opaque.
4. Keep the lens content-sized (≈48–160 px controls); never stretch one lens across a wide bar.
5. Add the CSS edge light (2 inset shadows, no dark edge) — it carries most of the "glass" read on non-Blink engines.
6. Drive motion through motion values, not React state; regenerate the map only on shape change; bump the filter id per update.
7. Cap instances: one or a few lenses per viewport; test Safari early for dropped specular/chroma passes.
8. Verify text contrast on top of the glass dynamically (crisp children layer helps — keep type there, never in the refracted layer).

## From scratch (no dependency)

Flat-glass baseline (the 90% case, CSS only):

```css
.glass {
  background: rgba(255, 255, 255, 0.10);          /* the tint — must have alpha */
  backdrop-filter: blur(6px) saturate(1.15);       /* frost + veil */
  border-radius: 20px;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.55),      /* top light */
    inset 0 0 0 1px rgba(255, 255, 255, 0.12),    /* hairline rim */
    0 8px 24px rgba(0, 0, 0, 0.18);               /* lift */
}
```

Real refraction (the mechanism, framework-free): generate the map, expose the filter, apply to DOM you own.

```html
<svg width="0" height="0" style="position:absolute">
  <filter id="lens" x="-30%" y="-30%" width="160%" height="160%">
    <feFlood flood-color="rgb(128,128,128)" result="bg"/>
    <feImage href="DISPLACEMENT_MAP_DATAURL" result="map"
             preserveAspectRatio="none" x="0" y="0" width="W" height="H"/>
    <feComposite in="map" in2="bg" operator="over" result="map"/>
    <!-- chromatic aberration: 3 passes, additively merged -->
    <feDisplacementMap in="SourceGraphic" in2="map" scale="S*1.22"
        xChannelSelector="R" yChannelSelector="G" result="r0"/>
    <feColorMatrix in="r0" type="matrix"
        values="1 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 0" result="rR"/>
    <feDisplacementMap in="SourceGraphic" in2="map" scale="S*1.11"
        xChannelSelector="R" yChannelSelector="G" result="g0"/>
    <feColorMatrix in="g0" type="matrix"
        values="0 0 0 0 0  0 1 0 0 0  0 0 0 0 0  0 0 0 1 0" result="rG"/>
    <feDisplacementMap in="SourceGraphic" in2="map" scale="S"
        xChannelSelector="R" yChannelSelector="G" result="rB"/>
    <feComposite in="rR" in2="rG" operator="arithmetic" k2="1" k3="1" result="rg"/>
    <feComposite in="rg" in2="rB" operator="arithmetic" k2="1" k3="1" result="lens"/>
    <!-- specular: lift map B channel and add it -->
    <feColorMatrix in="map" type="matrix"
        values="0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0 0 1 0 -0.5" result="sheen"/>
    <feComposite in="sheen" in2="lens" operator="arithmetic" k2="1" k3="1"/>
  </filter>
</svg>
```

```js
// Map generator core: R/G = X/Y displacement around 0.5, B = specular.
// Simplified dome: displacement points inward, growing toward the rim.
function lensMap(size, radiusFrac = 1) {          // size: 512; radius in px of half-extent
  const c = document.createElement("canvas"); c.width = c.height = size;
  const ctx = c.getContext("2d");
  const img = ctx.createImageData(size, size), d = img.data;
  const half = size / 2, r = radiusFrac * half;
  for (let y = 0; y < size; y++) for (let x = 0; x < size; x++) {
    const px = x - half + 0.5, py = y - half + 0.5;         // lens coords
    // rounded-rect SDF (clamp corner distance by radius)
    const cx = Math.max(Math.abs(px) - (half - r), 0);
    const cy = Math.max(Math.abs(py) - (half - r), 0);
    const sdf = Math.hypot(cx, cy) + Math.min(Math.max(Math.abs(px), Math.abs(py)) - (half - r), 0) - r;
    let dx = 0, dy = 0, spec = 0;
    if (sdf < 0) {
      const n = Math.hypot(px, py) / half;                  // 0 center → 1 rim
      const edge = Math.min(1, 1 + sdf / (0.16 * size / 2));// rim band (bendWidth 0.16)
      dx = -(px / half) * n * edge * 0.5;                   // push inward, stronger at rim
      dy = -(py / half) * n * edge * 0.5;
      spec = Math.pow(edge, 1.5) * 0.3;                     // sheenFalloff 1.5, sheen 0.3
    }
    const i = (y * size + x) * 4;
    d[i] = (0.5 + dx) * 255; d[i+1] = (0.5 + dy) * 255;
    d[i+2] = 128 + spec * 127; d[i+3] = 255;
  }
  ctx.putImageData(img, 0, 0);
  return c.toDataURL();
}
// Apply to content you own (works in Chrome, Safari, Firefox):
// target.style.filter = "url(#lens)";
// Scale S = strength * Math.sqrt((w*w + h*h) / 2), strength ≈ 0.05–0.06.
// On update: bump the filter id — WebKit caches filter output by id.
```

**When installing is justified:** you need the moving-lens interaction (geometry + motion values without React re-renders), the `refract`-copy plumbing with bleed-fill, the WebGL video path, or the four baked WebKit fixes. All four are edge-case traps; hand-rolling them costs days. For a static frosted panel, the 3-line CSS above is the right tool.

## AI-slop warning

Liquid Glass is 2026's most-abused effect — the new glassmorphism, but with more GPU. The failure pattern: glassifying every surface (navbars, cards, sidebars, modals simultaneously), maxing `dispersion`/`strength`/`bend` because each demo slide looked cool, glass behind long-form text, one stretched lens across a wide bar (oval bloom), glass-on-glass. Apple's own usage is disciplined: small, mostly *transient* controls over dynamic media — not chrome-level reading surfaces. Two silent-degradation traps for AI output: a build that demos in Chrome (Blink `backdrop-filter: url()`) ships a flat blur to every Safari/iOS user, and Safari's dropped filter passes (chroma/specular vanish past the size ceiling) look like a "bug" but are physics. If the backdrop is a flat gradient, delete the glass — there is nothing to refract. Default to frost-only; earn the lens.

## Relations

- **liquid-gooey** — the sibling SVG-filter effect (gooey blob merging); same `fe*`-primitive discipline, opposite material metaphor — read both before hand-writing filter chains.
- **magic-ui** — ornamental component library canon; liquid glass is what those libraries bolted onto everything in 2026 — this skill is the counterweight on when the material is actually warranted.
- **web-interface-guidelines** — backdrop-filter performance budgets and legibility rules that gate whether the glass ships at all; its contrast requirements override aesthetics here.
- **easing** — the pointer-follow and wobble (velocity squash-stretch, rubber-band) motion values in this library need its easing curves; `cubicBezier` and spring feel decide whether the lens reads liquid or laggy.
- **shadowlab** — layered-shadow craft; the inset top-light + hairline rim + outer drop shadow trio here is a special case of its edge-lighting method.
