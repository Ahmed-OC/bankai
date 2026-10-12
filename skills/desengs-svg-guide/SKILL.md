---
name: desengs-svg-guide
description: Use when animating SVG icons, illustrations, or loaders. Picks the correct technique per effect — CSS properties, SMIL, or JS — with morphing, line-drawing, mask, and filter mechanics.
source: https://www.svg.guide/; https://www.nan.fyi/svg-paths
category: reference
---

# Interactive SVG Animations (desengs) — SVG animation techniques for interfaces

Source: https://www.svg.guide/ — "Interactive SVG Animations", a paid interactive course (39 lessons, 13 exercises, 5 modules) by Nanda Syahrasyad (leads design engineering at Cloudflare; ex-Vercel design engineer on v0, dashboard, design system; author of the NaN blog). Free companion: the author's path-command series at https://www.nan.fyi/svg-paths. Commercial course, all rights reserved.

> Note: the course body is paywalled — distilled from the public landing page, the free Foundations lesson (courses.nan.fyi/svg/00-svg-foundations), and the author's free path-commands series. Line-drawing, viewBox, filter, and performance mechanics extend the course's module framework with the standard SVG behavior those modules teach.

## What it is / Why it exists

Most engineers treat exported SVG as opaque Figma output. The course exists to make the syntax legible so it can be animated deliberately: "everything you need to know about SVGs and how to animate them" — syntax first, then the animation ladder, then SVG-only effects "typically impossible with HTML, CSS, and JavaScript alone" (gradients, masks, filters). Its five modules are themselves the decision ladder:

- Module 0 — Foundations: SVG as markup, coordinate system, embedding.
- Module 1 — Your First Animation: many SVG attributes double as CSS properties; animate them with CSS + quirks + chaining.
- Module 2 — Animating the Unanimatable: SMIL (`<animate>`) for attributes CSS cannot touch.
- Module 3 — Paths and Path Animations: the `d` attribute, path commands, animating them.
- Module 4 — Advanced SVG Details: gradients, masks, filters, and JS-driven animation "when SMIL falls short".

## The core ideas

### 1. The three-tier technique ladder (CSS → SMIL → JS)

Pick the lowest tier that can do the job:

| Tier | Use when | Mechanism | Runs in `<img>`? |
|---|---|---|---|
| CSS | Attribute is also a CSS property: `fill`, `stroke`, `stroke-width`, `stroke-dasharray`, `stroke-dashoffset`, `opacity`, `transform`, `stop-color` | transitions / `@keyframes` | yes |
| SMIL | Attributes CSS can't animate: `points`, `d`, `viewBox`, `x`/`y` on shapes | `<animate attributeName to dur>` | yes |
| JS | Scrubbing (scroll/state-driven), mismatched-path morphs, React-controlled values | `requestAnimationFrame` + attribute writes | no |

Course example (Module 2, verbatim) — morphing a polyline's vertices, impossible in CSS:

```html
<polyline points="10,50 30,70 50,30 70,50" fill="none" stroke="currentColor"
  stroke-linejoin="round" stroke-linecap="round">
  <animate attributeName="points" to="10,50 30,30 50,70 70,50" dur="1s" />
</polyline>
```

SMIL essentials: `attributeName`, `to`/`from`/`values`, `dur`, `begin` (time or `"otherAnim.end"` for chaining), `fill="freeze"` to hold the end state, `repeatCount="indefinite"` for loops. Trigger from JS with `el.beginElement()` — that is the "integrate SMIL in modern codebases" move (e.g., restart on click).

CSS-side chaining: `animation-delay` + `animation-fill-mode: forwards`, or SMIL `begin="a.end"`.

### 2. The transform-origin quirk (Module 1's "quirks")

On SVG elements, `transform-origin` resolves in the viewBox coordinate system, not the element's box. Course example (verbatim):

```css
.lid {
  transform: rotate(30deg);
  transform-origin: 55px 30px; /* px = user units in the viewBox, not screen px */
}
```

Two correct options: (a) compute the pivot in viewBox units like above, or (b) opt into element-relative origin:

```css
.icon-part {
  transform-box: fill-box;      /* origin now relative to the element's own bbox */
  transform-origin: 50% 50%;
}
```

Forgetting this is why icons orbit the canvas corner instead of spinning in place.

### 3. Path commands = the morphing substrate (Module 3 + svg-paths series)

`d` is a series of commands, "a single-letter code followed by a series of numbers" — like function calls. Uppercase = absolute (from viewBox origin 0,0); lowercase = relative (from the previous command's endpoint).

- `M`/`m` move cursor (draws nothing), `L`/`l` line to, `H`/`h` horizontal, `V`/`v` vertical, `Z` close
- `Q`/`q` quadratic (1 control point): `Q controlX controlY endX endY`; `T`/`t` chains quadratics using the reflection of the previous control point
- `C`/`c` cubic (2 control points — more points, more complex curves; quadratics preferable when you don't need the extra shape); `S`/`s` smooth-chains cubics
- `A`/`a` arc — "the least intuitive": `A rx ry rotation large-arc-flag sweep-flag x y`

Rounded-corner recipe from the series: `M 5 0 v 5 Q 5 15 15 15 h 5`.

**Morph rule:** `d` interpolates (SMIL or JS) only when both keyframe strings have the identical command sequence — same letters, same count, same arity. Same for `points`: same number of coordinate pairs.

```html
<path d="M10 50 Q 40 5 70 50" fill="none" stroke="currentColor" stroke-width="3">
  <animate attributeName="d" dur="0.4s" to="M10 50 Q 40 95 70 50" />
</path>
```

Mismatched paths (hamburger → X exported from different sources) will not interpolate: normalize them to a shared command list by hand, or use JS interpolation (flubber is the one justified install here — it morphs arbitrary path pairs).

### 4. Line drawing with dasharray/dashoffset

The "draw itself" effect for icons, underlines, signature strokes:

```css
.draw {
  stroke-dasharray: 100;   /* must equal path length */
  stroke-dashoffset: 100;  /* fully hidden */
  animation: draw 0.8s cubic-bezier(0.22, 1, 0.36, 1) forwards;
}
@keyframes draw { to { stroke-dashoffset: 0; } }
```

Never guess the length — measure it:

```js
const p = document.querySelector('.draw');
const len = p.getTotalLength();
p.style.strokeDasharray = len;
p.style.strokeDashoffset = len;
p.getBoundingClientRect(); // force layout so the start state paints
p.style.transition = 'stroke-dashoffset 0.8s cubic-bezier(0.22,1,0.36,1)';
p.style.strokeDashoffset = 0;
```

Multi-path illustrations: stagger `transition-delay` per path (60–120ms apart), longest paths first.

### 5. viewBox choreography (Module 0's coordinate system, animated)

`viewBox="minX minY width height"` is the camera. Animating it pans/zooms every child at once without touching them — the cheapest "camera move" in SVG:

```html
<svg viewBox="0 0 100 100">
  <animate attributeName="viewBox" to="25 25 50 50" dur="1s" fill="freeze" />
  <!-- children unchanged -->
</svg>
```

JS-driven camera (scrub with scroll): write `svg.setAttribute('viewBox', ...)` per frame, interpolating the four numbers. Use for zoom-into-detail illustrations and infographic reveals; do not use for layout-scale responsiveness (use width/height + preserveAspectRatio there).

### 6. Masks and clips (Module 4)

`<mask>` is luminance-based: white paints, black hides — any alpha/soft reveal. `<clipPath>` is hard geometry. The landing example (verbatim shape):

```html
<defs>
  <mask id="circle-mask">
    <circle cx="25" cy="25" r="15" fill="#fff" />
    <circle cx="55" cy="55" r="15" fill="#fff" />
  </mask>
</defs>
<rect mask="url(#circle-mask)" fill="gray" />
```

Animate the mask's inner shapes (grow `r`, translate a white rect) to reveal content — circular menu reveals, spotlight effects, image-to-text wipes. The masked content never re-renders; only the mask geometry animates.

### 7. Gradient animation

Stops are presentation attributes → CSS can animate them:

```css
@keyframes sunset { to { stop-color: #ff5f6d; } }
linearGradient stop:first-child { animation: sunset 2s ease-in-out infinite alternate; }
```

For shimmer/position sweeps, animate `gradientTransform` (SMIL `attributeName="gradientTransform"` or JS) instead of stop colors — one matrix write, stops untouched. Keep animated gradients on `fill` of vector shapes, not as full-page backgrounds.

### 8. Filters: the gooey trick

The signature SVG-only effect — metaball merging. Blur, then crush the alpha channel so soft overlaps become solid unions:

```html
<filter id="gooey">
  <feGaussianBlur in="SourceGraphic" stdDeviation="8" />
  <feColorMatrix values="1 0 0 0 0
                         0 1 0 0 0
                         0 0 1 0 0
                         0 0 0 20 -9" />
</filter>
```

Apply to a `<g filter="url(#gooey)">` of blobs; animate the blobs with `transform` only. The filter re-runs every frame the group changes — keep the filtered region small (loaders, chat-bubble tails, tab indicators), never full-screen.

### 9. Performance rules

- `transform` and `opacity` composite on the GPU; everything else in SVG (`d`, `points`, `cx`, `stroke-dashoffset`, mask geometry, filter params) repaints the element each frame.
- Geometry/mask animation is fine for icons and loaders (≤ ~200×200 px); avoid it on full-bleed artwork.
- Filters are the most expensive per-frame cost in SVG — small regions only, and never animate `stdDeviation` on large areas.
- One moving SVG beats many: group and transform a `<g>` rather than animating each child separately.
- `will-change: transform` only on the few elements that actually animate, and remove it after.
- Embedded via `<img>` or `background-image`: declarative animation (SMIL/CSS) still runs, JS does not — external sprites must be SMIL/CSS-only. External files need `xmlns="http://www.w3.org/2000/svg"` and buy caching + smaller DOM; inlining buys JS access at DOM-node cost.
- Respect `prefers-reduced-motion`: keep state changes, drop loops and camera moves.

## When to use / When NOT to use

Use when: animating icons, illustrations, loaders, progress indicators, hero artwork, or any effect that needs SVG-only machinery (masks, gooey, path morphing, line drawing, camera moves). Use SVG animation instead of video/Lottie when the asset is vector, needs theming (`currentColor`), or must scale crisply.

Do NOT use when: the same effect exists in plain CSS on HTML elements (a simple fade/slide of a `<div>` needs no SVG); when the artwork is raster or photographic; when you need DOM/accessibility semantics per element (SVG text and children are poor interactive targets); when the SVG is decorative and static — then it is an `<img>` with width/height and no code. A 3-property CSS transition always beats a SMIL graph; do not use SMIL where CSS works (CSS is debuggable, inspectable, and pausable in DevTools).

## How to apply

1. Inline the SVG (JS interactivity needed) or reference externally (pure decoration) — decide embedding first; add `xmlns` if external.
2. Clean the export: strip editor metadata, convert fills to `currentColor` where theming is needed, name parts with `class`es.
3. Classify each animated value: CSS property → CSS animation; SVG-only attribute → SMIL; state/scroll-driven → JS.
4. Check `transform-box`/`transform-origin` before any rotation — pivot in viewBox units or `fill-box` percentages.
5. For morphs, verify both `d`/`points` strings share the exact command sequence; normalize or reach for JS interpolation if not.
6. For line drawing, measure with `getTotalLength()`; stagger paths 60–120ms.
7. Keep per-frame writes to `transform`/`opacity` wherever possible; confine filters and mask animation to small regions.
8. Gate loops and camera moves behind `prefers-reduced-motion: reduce`.
9. Test the `<img>` sprite separately if the asset ships external — JS-driven animation silently no-ops there.

## AI-slop warning

Typical AI failures this skill prevents: CSS-animating attributes that are not CSS properties (silently no-ops — e.g., transitioning `points` or `d` in a stylesheet; CSS `d` support is uneven across browsers, so SMIL/JS is the portable route); rotating an icon without fixing `transform-origin`, so it orbits the canvas corner; stroke-dashoffset values that don't match `getTotalLength()`, producing crawling dash artifacts instead of a clean draw; morphing exported paths with different command lists, which snaps instead of interpolating; slapping the gooey filter or line-draw-on-load onto everything (both were fresh in 2016 — now they read as demo-reel filler outside loaders and deliberate hero moments); and animating six child elements when one `<g transform>` would do.

## Relations

- **desengs-easing** — this skill picks the technique; that one supplies the durations and curves (e.g., 0.4s, cubic-bezier(0.22,1,0.36,1)) to feed them.
- **desengs-transitions** — frames when SVG animation is a UI state change vs decoration; use its criteria to decide whether to animate at all.
- **desengs-loading-dev** — loaders are the highest-value target for these loops (SMIL in sprites, dashoffset spinners); adds loader-specific patterns.
- **desengs-morphicons** — packaged icon-morph effects built on the same same-command-sequence `d` rule; consult before hand-rolling morphs.
- **desengs-liquid-gooey** — the gooey filter as a maintained effect; cross-check its parameters before copying the filter above ad hoc.
