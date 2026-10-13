---
name: fancy-components
description: Use when a landing page or hero needs one signature playful effect (scramble text, gooey filter, image trail, physics bodies) and you must know each mechanism, its cost, and the one-effect-per-page limit.
source: https://www.fancycomponents.dev/; https://github.com/danielpetho/fancy
category: library
---

# Fancy Components — playful visual-effect components: copy the code, keep the mechanism

Source: https://www.fancycomponents.dev/ — docs site + component registry by **danielpetho** ("nonzeroexitcode"), repo https://github.com/danielpetho/fancy (~3.2k stars), **MIT license**, free for personal and commercial use. A curated set of ~40 React microinteraction/effect components, each documented with installable source, live demos, and a prop table. Full index at `https://www.fancycomponents.dev/llms.txt` (each component also serves `.md` at its docs URL — fetch those when building).

## What it is / Why it exists

- Premise (the author's): the web has become homogeneous; the library recreates the effects seen on award-winning sites as "ready-to-use" components so working devs can ship them without reverse-engineering awwwards demos.
- **Not web components.** Despite the name, these are **React + TypeScript + Tailwind CSS + Motion (Framer Motion)** source files. Distribution is the shadcn registry model, not npm: add `"@fancy": "https://fancycomponents.dev/r/{name}.json"` to `components.json`, then `npx shadcn add @fancy/<component>`. Caveats: the CLI only *writes* extra deps to `package.json` — you still run the install; Tailwind + `motion` are assumed baseline.
- The design decision that matters: **you copy the source, you own the code.** There is no runtime package to stay pinned to. For any non-React/Tailwind stack, the value is the *mechanisms* — every one ports to plain CSS/JS in under 50 lines (ports below; the source's Tailwind utilities are rewritten as plain CSS on purpose).
- When installing is actually justified: you are already on React + Tailwind + Motion, want the maintained source with prop tables and demos, and the effect needs the one heavy dep some components carry (Matter.js for physics).

## The core ideas

### Mechanism families (map any effect to one of these before writing code)

| Family | Used by | Cost driver |
|---|---|---|
| SVG filters (blur → alpha contrast → composite) | Gooey SVG Filter, Pixelate SVG Filter | filter region × repaint area; Safari broken |
| Timed string mutation (`setInterval` + char pool) | Scramble Hover/In, Typewriter, Random/3D Letter Swap, Number Ticker | text length × interval rate |
| DOM grid + pointer→cell math | Pixel Trail | cell count (≈5,000 divs full-HD @20px) |
| Physics engine + transform mirror | Gravity, Cursor Attractor & Gravity, Elastic Line | body count, vertex count |
| Distance-threshold spawn + fixed pool | Image Trail, Parallax Floating | pool size × media weight |
| Pure CSS 3D / keyframes | CSS Box, Float, Marquees, Stacking Cards, Underline*, Box Carousel | compositing only — cheapest |

### Inventory (~40, verified against the site's llms.txt)

- **Text (20):** Letter Swap, Letter 3D Swap, Random Letter Swap, Vertical Cut Reveal, Text Rotate, Variable Font Hover By Letter, Variable Font Hover By Random Letter, Scroll And Swap, Text Cursor Proximity, Variable Font & Cursor, Variable Font Cursor Proximity, Breathing Text, Underline Animation, Underline To Background, Basic Number Ticker, Typewriter, Scramble Hover, Text Highlighter, Scramble In, Text Along Path.
- **Physics (3):** Elastic Line, Gravity, Cursor Attractor & Gravity (all Matter.js).
- **Image (2):** Image Trail, Parallax Floating.
- **Background (2):** Animated Gradient With SVG, Pixel Trail.
- **Filter (2):** Gooey SVG Filter, Pixelate SVG Filter.
- **Blocks (10):** Drag Elements, Circling Elements, Media Between Text, CSS Box, Screensaver, Sticky Footer, Float, Stacking Cards, Simple Marquee, Marquee Along SVG Path.
- **Carousel (1):** Box Carousel.

### Flagship mechanism 1 — Gooey filter (pure SVG, no JS)

Pipeline (credited by the author to Lucas Bebber's CSS-Tricks "Gooey Effect"): blur nearby shapes together → harden the alpha channel with a contrast spike → composite back onto the original silhouette so edges stay crisp. Animation comes from whatever moves *inside* the filtered container; the filter itself is static.

```html
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
  <filter id="goo">
    <feGaussianBlur in="SourceGraphic" stdDeviation="15" result="blur"/>
    <feColorMatrix in="blur" mode="matrix"
      values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 24 -12" result="goo"/>
    <feComposite in="SourceGraphic" in2="goo" operator="atop"/>
  </filter>
</svg>
```
```css
/* apply to a container of moving shapes; pad it >= 2x stdDeviation or the
   blur gets clipped at the filter region edge (the #1 visual bug) */
.goo-field { filter: url(#goo); padding: 40px; }
```

- `strength` prop (default 15) maps to `stdDeviation`. Alpha row `0 0 0 24 -12` is the contrast threshold — raise the multiply for harder blob edges.
- **Safari support for SVG filters is limited** — the library's own demos disable the effect there. Ship a fallback (plain shapes, no filter) or, if the goo must be cross-browser, write a WebGL shader instead. Pixelate SVG Filter: **no Safari support at all**.

### Flagship mechanism 2 — Scramble text (interval + revealed-index set)

```js
function scramble(el, { speed = 50, pool = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" } = {}) {
  const original = el.textContent;
  let revealed = 0;
  const t = setInterval(() => {
    el.textContent = original.split("").map((c, i) =>
      i < revealed || c === " " ? c : pool[(Math.random() * pool.length) | 0]
    ).join("");
    if (revealed++ >= original.length) { el.textContent = original; clearInterval(t); }
  }, speed);
}
```

- Defaults from the source: `scrambleSpeed` 50ms, `maxIterations` 10 (random mode), sequential mode reveals start→end→center-out. Spaces always preserved. Monospace fonts recommended — variable-width pools cause layout jitter.
- Every character renders as its own `<span>` (per-char styling support), so each tick re-renders n nodes — fine for a 20-char headline, wrong for a paragraph.
- **A11y pattern to copy:** keep the original string in a visually-hidden span and mark the mutating layer `aria-hidden="true"`. Never scramble live regions or focused text.
- Use the text's own unique characters as the pool (source shuffles them with Fisher–Yates) when random glyphs feel too "terminal".

### Flagship mechanism 3 — Pixel trail (a DOM grid, not canvas)

- Grid math: `cols = ceil(w / pixelSize)`, `rows = ceil(h / pixelSize)` with `pixelSize` default 20 → **1920×1080 ≈ 5,000 divs rendered upfront**. Memoize dots; only hovered cells animate.
- Pointer→cell lookup is O(1): floor the coordinates, `getElementById` the cell. Each dot exposes its animate handle on the DOM node; the "recolor" is really opacity `[1 → 0]` over `fadeDuration` (default 500ms) on a background-colored div. Color lives in the dot's class, not JS.
- `fadeDuration: 0` + `delay: 500–600` = persistent, non-fading paint trail. Layer it under a gooey filter for liquid pixels (Safari excluded).
- Keep the trail container's z-index below content so links still get pointer events.

### Flagship mechanism 4 — Physics gravity (Matter.js + transform mirror)

- Bodies are sized from the DOM (`offsetWidth/Height`) — style the child, the body matches. `bodyType`: rectangle, circle (`max(w,h)/2`), or `svg` (path sampled every `sampleLength` 15px via svg-path-commander + poly-decomp).
- Two loops run in parallel: `Runner.run` steps the simulation; a `requestAnimationFrame` loop writes transforms — the docs call this "the illusion that your DOM elements are actually affected by physics":

```js
Runner.run(runner, engine);
(function sync() {
  for (const [el, body] of bodies)
    el.style.transform =
      `translate(${body.position.x - el.offsetWidth / 2}px, ` +
      `${body.position.y - el.offsetHeight / 2}px) rotate(${body.angle}rad)`;
  requestAnimationFrame(sync);
})();
```

- Perf rules from the docs: complex/multi-path SVGs explode vertex count and collision math — use a rectangle/circle body with the SVG as a visual overlay; the initial path→vertices conversion is itself slow. Resize triggers a full engine teardown/rebuild (debounced 500ms).
- Draggable bodies use `pointer-events: none` so Matter's MouseConstraint (stiffness 0.2) receives events — children are unclickable while dragging. Tunables: `restitution` 0.7 for bouncy, `friction`, `density`, `gravity` default `{x:0, y:1}`.

### Flagship mechanism 5 — Image trail (event-driven pooling, no rAF)

```js
let last = null, cursor = 0;
const THRESHOLD = 100; // px of travel before the next spawn
field.addEventListener("pointermove", (e) => {
  if (last && Math.hypot(e.clientX - last.x, e.clientY - last.y) < THRESHOLD) return;
  last = { x: e.clientX, y: e.clientY };
  const item = pool[cursor = (cursor + 1) % pool.length]; // fixed pool, modulo recycle
  place(item, e.clientX, e.clientY); // follow-target lerps toward pointer at 0.3/frame
});
```

- No rAF ticker, no scroll listener — purely pointer-event-driven; `Math.hypot` distance gating (threshold 100px, lerp factor 0.3) plus a fixed pool recycled by modulo. Items render hidden at mount (`repeatChildren` ×3), so **all media loads upfront** — the docs warn against large images/videos here.
- `will-change: transform` on pooled items hints GPU compositing; keyframe in/out via the animation lib or `@keyframes`.

## When to use

- Marketing/landing pages, portfolio and studio sites, launch moments — one signature interaction that buys "this site is alive" in the first viewport.
- Case Studies sections where a single effect carries the brand (e.g., gooey nav blob, image-trail case gallery).
- You are on React + Tailwind + Motion and want owned, editable source with a prop table instead of a black-box npm dep.
- Hover-driven variants (letter swaps, scramble hover) are desktop-pointer contexts by design — treat them as desktop-only progressive enhancement.

## When NOT to use

- **App UI, dashboards, docs, checkout, forms** — anywhere reading and clicking are the job. Scramble/typewriter text measurably slows reading; physics bodies sit on top of hit targets.
- Touch-primary pages: hover effects do nothing; trails and gravity need a pointer.
- Safari-significant traffic: both SVG filters are out (Pixelate: unsupported; Gooey: limited, demos disable it).
- Tight performance budgets: 5,000-div grids, Matter simulations, and upfront-loaded video pools don't belong on the same page as each other or with heavy ads/analytics.
- When the native path is cheaper: underline/float/marquee/stacking are pure CSS (`transition`, `@keyframes`, `position: sticky`) — don't import React+Tailwind+Motion for those; the library's own CSS-family components are reference implementations, not dependencies you need.
- npm-dep hygiene matters and you're not on Tailwind/Motion: port the mechanism (above) instead of adopting the stack for one effect.

## How to apply

1. Pick **one** effect per page — hero *or* footer, never both. Everything else stays quiet (system typography, flat surfaces, standard transitions).
2. Choose the cheapest mechanism family that reads correctly: CSS 3D/keyframes > SVG filter > string mutation > pooling > physics. Physics is a hero-only commitment.
3. Port rules for any filter: pad the container ≥ 2× blur radius; define one `<filter>` per document and reference by id; write the Safari fallback first.
4. Port rules for text mutation: sr-only original + `aria-hidden` visual layer; monospace or tabular glyphs; cap length ≤ ~30 chars; honor `prefers-reduced-motion` (skip to final state).
5. Port rules for pointer effects: distance-threshold gate (~100px) not per-event spawn; fixed pool (≤ ~12 items) recycled modulo; `will-change: transform`; keep effect layers below content z-index.
6. If installing for real: registry entry + `shadcn add @fancy/<name>`, then run the package install yourself; check the component's page for extra deps (Matter.js, svg-path-commander) and the `.md` endpoint for the current prop table.
7. Tune defaults away from template values (50ms speed, 100px threshold, 0.3 lerp, 20px cells, ×3 pool) — shipped-as-is defaults are the fingerprint of an unmodified copy.

## AI-slop warning

Stacking these is the single fastest route to the AI-generated landing look: scramble-text hero + image trail + gooey nav + pixel-trail background + marquee logo wall + gravity footer on one page reads as "prompted v0 site, 2025". The library's own premise is trend-recreation, so heavy use dates the page *fast* — awwwards effects have a half-life of roughly one design-trend cycle. Specific tells: default prop values left untouched, hover-only effects shipped on mobile where they dead-end, five effects competing so none is a moment, effects applied to real content (scrambling an H1 that must be read, physics on a button). Rule of thumb: if the user notices two Fancy-style effects on one page, delete one.

## Relations

- **liquid-gooey** — the gooey/SVG-filter technique in full depth; this skill covers only the Fancy usage port and its Safari limits.
- **magic-ui** — same copy-paste React+Motion registry model, different inventory; consult for choosing between the two ecosystems (or skipping both).
- **images-in-motion** — cursor-following media sits in a broader family than Image Trail alone; sequencing and choreography rules live there.
- **taste** — the restraint doctrine that governs when any of these effects survives the cut.
- **easing** — the timing values that separate a tuned port from the default-props template look.
