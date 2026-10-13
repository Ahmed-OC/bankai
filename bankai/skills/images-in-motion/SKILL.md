---
name: images-in-motion
description: Use when animating imagery and the right technique must be picked with its real cost. Distills the inclined infinite-scroll image mosaic: one linear translate3d per lane, with exact speeds, angles, and pause rules.
source: https://iim.smartsquad.io
category: reference
---

# Images in Motion — kinetic image techniques for the web

Source: https://iim.smartsquad.io — "Images in Motion" v1.0.1, an open-source JavaScript library (repo: `smartsquad/images-in-motion`). Designed by Samuel Burlon, implemented by Massimo De Luisa, © 2026 Smart Squad Srl, MIT License. It is not a gallery of many effects: it is a deep study of ONE kinetic image technique — the inclined, infinitely scrolling image mosaic — engineered to the minimum possible runtime cost.

## What it is / Why it exists

The library renders a continuous image mosaic: independent vertical lanes (or horizontal rows) of thumbnails that scroll endlessly, neighboring lanes in opposite directions, each lane at a constant but different speed, the whole sheet tilted by a configurable angle. Default look: vertical columns, 12°, sequential order.

It exists to answer one engineering question: what is the cheapest mechanism that keeps imagery in continuous motion? The docs' own rationale table names what it refuses to do, and what replaces each:

- rAF loop + per-frame style writes → replaced by CSS `@keyframes` on lane containers.
- Canvas/WebGL rendering → replaced by DOM tiles the compositor moves for free.
- Per-frame React/Vue state → replaced by one mount; frameworks never re-render per tick.
- Native mobile views → replaced by the same CSS renderer inside a WebView.
- Video/GIF for moving imagery → replaced by "still images, looping translate" (no media payload, no codec, resolution-independent).

Thesis, verbatim: "Motion is CSS, not a JS frame loop." Everything below follows from it.

## The core ideas

### 1. The cost ladder of image motion

The source studies the cheapest rung. Place any image animation on this ladder before writing code (rungs are mechanism facts; the source's own contrast is against rAF, canvas/WebGL, per-frame state, and video/GIF):

| Technique | Mechanism | Where it runs | Cost | Serves |
|---|---|---|---|---|
| Hover zoom (subtle) | `transform: scale(1.03)` + 200–300ms ease-out | Compositor | Trivial | Content inspection |
| Crossfade | stacked `opacity` transition | Compositor | Trivial | Content transition |
| Ken Burns | slow `scale(1→1.08)` + slight translate, 8–20s loop | Compositor | Low | Decor (heroes) |
| Infinite mosaic drift (this source) | ONE linear `translate3d` per lane | Compositor only | Lowest continuous motion available | Decor (ambient texture) |
| Parallax | translate driven by scroll position | Compositor if `animation-timeline: scroll()`, main thread if JS-driven | Medium | Depth/narrative |
| Scroll reveal (mask/clip) | `clip-path`/`inset` + translate on intersection | Paint on mask change | Medium | Reveal-on-arrival |
| Hover distortion | SVG `feDisplacementMap` filter | Per-pixel paint | High | Decor only |
| WebGL displacement | Custom shader, texture displacement map | GPU, dedicated context, image uploads | Highest | Premium decor only |

Decision rule: pick the lowest rung that achieves the intent. If a translate expresses it, never reach for canvas, WebGL, filters, or video. Per-pixel techniques (displacement, distortion, flows) are the only ones that genuinely require WebGL — everything else on the ladder is transform/opacity and belongs to the compositor.

### 2. The mosaic mechanism, exactly

Vocabulary and the site's exact numbers:

- **Lane/track**: one column (or row) of images. The animated unit is the TRACK, never the tiles. N lanes = N CSS animations total, regardless of image count.
- **Cycle**: the track's full content height (or width) including the final gap — "the last gap is part of the period, so the loop does not jump when it wraps."
- **Two copies**: each track holds the image cycle twice; translating by exactly one cycle length loops seamlessly.
- **Shared keyframes**: one rule for all vertical tracks, one for horizontal, "translate3d from 0 to `var(--iim-cycle)`, linear, infinite":

```css
@keyframes iim-scroll {
  from { transform: translate3d(0, 0, 0); }
  to   { transform: translate3d(0, var(--iim-cycle), 0); } /* cycle is negative */
}
```

- **Per-lane variation without new keyframes** — only custom properties per track: `--iim-cycle` (negative cycle in px), `animation-duration: cycle / speed` (ms), `animation-delay` as phase offset "so neighbours do not line up", `animation-direction: reverse` on odd lanes so neighbors travel opposite ways.
- **Speed**: logical px/second. Default `speedRange: [8, 18]`, clamped 0.1–1000, sorted. Constant within a lane, different between lanes — variance between lanes is what reads as "drift" instead of "conveyor belt".
- **Angle**: default 12° clockwise on the whole sheet via one CSS transform on `.iim-sheet` — "not a per-frame spin". Negative tilts the other way.
- **Tiles**: `tileWidth` responsive 100–220px (clamp 16–4096), `tileAspectRatio` 2/3 (clamp 0.1–10), `gap` 4px (clamp 0–1024). Fit modes: `fixed` (uniform box, `object-fit: cover`), `auto` (each image keeps its own aspect), `static` (one shared size derived from sources), `dynamic` (all stretch to the tallest fitted height).
- **Seams**: `gapColor` (#000000) + `gapOpacity` (1). `gapOpacity: 0` shows whatever is behind the sheet.
- **Tint**: `overlayOpacity` (0–1; omitted mounts no overlay) + `overlayColor` (#000000) — a wash over tiles, the standard trick to keep overlaid text legible.
- **Order**: `sequential` cycles the list; `random` uses a stable shuffle.

### 3. Playback: pause, hover, reduced motion

- `paused: false` default — "eases to a freeze at the current CSS position": ramp `playbackRate` toward 0 over ~0.5s, then `animation-play-state` holds the pose. Tracks are never torn down.
- `prefers-reduced-motion` and hidden tabs snap-pause (no ease) — motion must stop when the user asks or when nobody is watching.
- `stopOnHover: true` eases to stop under the pointer; `animateOnHover: true` runs only under the pointer. Both set → motion stays continuous (explicitly ignored).
- The sheet is a decorative layer: `pointer-events: none`; children (React children / Vue slot) render ABOVE it and stay interactive — hover listeners attach to the outer wrapper so children still receive clicks.

### 4. What ships (and what doesn't)

- CDN IIFE: 17.38 KB minified, 6.47 KB gzip -9, 5.83 KB brotli. Core alone: 2.95 KB gzip. React (≥18) and Vue (≥3.4) are optional peers that only mount the renderer — import one binding, not also the package ("unless you want two copies").
- Images are URL strings, excluded from the bundle and from Studio exports ("image URLs never leave the browser"; the export payload must not match `https?:` or `blob:`). API note: "Prefer thumbnail-sized files."
- JS still runs for mount, resize, image aspect measurement, SVG normalization, and playback flags. "It does not run the scroll."
- Edge cases: zero images → empty black background; one image → repeats safely.

### 5. The nine studies (the source's own presets)

| Study | Key settings | Effect / when it serves |
|---|---|---|
| Vertical, no tilt | `angle: 0`, speed [8,18] | Straight columns; baseline before adding incline |
| Horizontal, no tilt | `motionAxis: 'horizontal'`, `angle: 0` | Straight rows; the axis counterpart |
| Columns (default) | `angle: 12`, sequential | The signature: tilted independent lanes |
| Film strip | rows, `angle: 6`, `tileWidth: 220`, aspect 1.5, speed [14,28] | Wide landscape tiles, gentle tilt, opposing neighbors |
| Gold wash | `angle: 24`, speed [6,14], overlay 0.42 #A59050, random, gap 8 | Steep, slow, tinted — brand-tinted decor |
| Paper gutters | `angle: 10`, gap 10, `gapColor: #F3EFE8` | Cream seams on light pages; joints blend with the stage |
| Dynamic height | `tileFit: 'dynamic'`, width 132, `angle: 14` | Mixed crops stay one uniform row height |
| Dense drift | `tileFit: 'auto'`, width 96, gap 2, `angle: -8`, speed [18,36], random | Tight fast wall, negative tilt, native aspects |
| Slow monument | width 260, aspect 0.72, gap 12, `angle: 16`, speed [3,7], ink overlay 0.28 | Near-still large boxes; calmest register |

Read the spread: speed [3,7] to [18,36] px/s, angle −8° to 24°, tile 96–260px. Ambient walls live at 3–14 px/s; anything above ~30 px/s stops reading as texture.

## Recreate it without the dependency

A fixed decorative wall needs no library — the mechanism is ~40 lines:

```html
<div class="iim" aria-hidden="true">
  <div class="iim-sheet">
    <div class="iim-track" style="--cycle:-1200px; --dur:80s; --delay:-30s">
      <div class="iim-strip"><!-- tiles --></div>
      <div class="iim-strip"><!-- identical tiles --></div>
    </div>
    <!-- 3–5 tracks, each with its own --dur / --delay; content adds to cycle -->
  </div>
</div>
```

```css
.iim { overflow: hidden; height: 20rem; position: relative; }
.iim-sheet {
  transform: rotate(12deg);
  position: absolute; inset: -40%;      /* oversize ~1.5x so tilted sheet covers corners */
  display: flex; gap: 4px;
}
.iim-track {
  flex: 1; display: flex; flex-direction: column; gap: 4px;
  animation: iim-scroll var(--dur) linear infinite;
  animation-delay: var(--delay);        /* phase offset per lane */
}
.iim-track:nth-child(odd) { animation-direction: reverse; }
.iim-strip { display: flex; flex-direction: column; gap: 4px; }
.iim-strip img { width: 100%; aspect-ratio: 2/3; object-fit: cover; }
@keyframes iim-scroll {
  from { transform: translate3d(0, 0, 0); }
  to   { transform: translate3d(0, var(--cycle), 0); }
}
@media (prefers-reduced-motion: reduce) {
  .iim-track { animation: none; }       /* snap, no ease */
}
```

Rules that make it correct: `--cycle` = one strip's outer height INCLUDING the trailing gap, negative; duration = |cycle| / px-per-second; each lane gets a different duration (8–18 px/s band) and an arbitrary negative delay so neighbors never align; overlay text legibility via a tint div (`background: rgb(0 0 0 / .3)`) over the sheet. Eased pause (the library's behavior): ramp `playbackRate` on `getAnimations({subtree: true})` over ~500ms, then set `animation-play-state: paused`.

Installing is justified when you need what hand-rolling lacks: measured `imageAspects` inference, SVG normalization, geometry recomputed on resize, the ~0.5s eased freeze, the settings-export JSON contract, or WebView HTML generation for Expo/NativeScript. A static hero wall does not justify a dependency.

## When to use / When NOT to use

Use when:
- Imagery is texture, not information: hero backgrounds, brand walls, section dividers, ambient panels behind interactive children.
- You want continuous life at the lowest possible cost — one compositor transform per lane, zero JS per frame, thumbnail-sized stills instead of video.

Do NOT use when:
- Users must inspect the images (portfolios, product grids, documentation) — constant motion fights reading; use a static grid + subtle hover zoom (scale 1.03, 200–300ms) instead.
- The motion is meant to respond to scroll or tell a narrative — this technique is ambient and ignores scroll entirely; use scroll-linked parallax/reveals instead.
- Only one or two images are available — one image "repeats safely" but reads as a broken feed; zero images is a black box.
- You cannot ship thumbnails — full-resolution sources in a many-tile wall is a bandwidth bug, and the API explicitly says "prefer thumbnail-sized files".
- The user has signaled reduced motion — snap to still (the source pauses without easing for exactly this case).

## How to apply (numbered checklist)

1. Classify the job: content imagery → static + hover zoom/crossfade (ladder rungs 1–2). Ambient decor → this technique. Depth narrative → scroll-linked. Per-pixel distortion → WebGL, and only for premium decor.
2. Pick the register from the studies: calm (speed 3–7 px/s, large tiles, tint overlay) vs dense (14–36 px/s, tiles ≤96px, gap ≤2). Never exceed ~36 px/s for background use.
3. Tilt: 6–12° subtle, 16–24° expressive, 0° for ordered/corporate, negative to counterbalance page tilt. One transform on the sheet, never per tile.
4. Oversize the rotated sheet (~1.5× host, centered) so corners stay covered.
5. Animate tracks only; one shared keyframes rule; vary `--dur`, `--delay`, `animation-direction` per lane. Odd lanes reversed.
6. Duplicate each strip once; make the trailing gap part of the cycle so the wrap does not jump.
7. Give every lane a distinct speed within an 8–18 px/s band (default) and a phase offset — synchronized lanes read as a broken scroller.
8. If text sits on top, add `overlayOpacity` 0.28–0.42 wash and check contrast against the moving tiles at their brightest.
9. Wire pause rules: `prefers-reduced-motion` → snap stop; hidden tab → stop; optional `stopOnHover`/`animateOnHover` (never both — both means continuous).
10. A11y: `aria-hidden="true"` on the sheet, `pointer-events: none`, interactive children above it with hover listeners on the wrapper. The source documents NO alt/ARIA strategy for tiles — treat every tile as decoration and never place informative images only in the wall.
11. Ship thumbnails (target ≤30–50 KB each), lazy-load below-the-fold walls, count lanes × strip length against your image budget.

## AI-slop warning

The tilted infinite image wall is fast becoming the AI landing page's default "premium" move — every hero gets a 12° drifting mosaic whether or not the product has visual content. The specific slop signature: the source's own Gold wash preset (24°, random order, #A59050 at 0.42) at full intensity behind long-form text, producing a busy, low-contrast shimmer no one can read. Contexts it poisons: content sites, docs, checkout, anywhere motion competes with a primary task; walls built from unrelated stock that fakes vibrancy the product lacks. The equally common engineering misapplication: reaching for WebGL/Three.js, GSAP rAF loops, canvas redraws, or per-tile transitions to deliver what ONE linear `translate3d` keyframe per lane already does on the compositor — or animating `background-position`/`top`/`left` (paint thrash) instead of `transform`. If the wall is removed and nothing on the page gets worse, delete it.

## Relations

- **transitions** — covers state-change motion (enter/exit, view swaps); this skill covers ambient continuous motion. Use transitions for interaction feedback, this for atmosphere; conflating them produces gratuitous motion.
- **easing** — lane drift is deliberately LINEAR (constant speed reads as drift); easing applies only to the ~0.5s pause/freeze ramp and hover zoom transitions, never to the drift itself. That skill's curves pick where this skill forbids them.
- **web-interface-guidelines** — the broader motion-and-reduced-motion compliance rules this technique must satisfy (snap-pause on `prefers-reduced-motion`, pause hidden tabs).
- **magic-ui** — a component-effect library with a heavier per-effect cost model; consult it after this skill's ladder says a transform-only rung cannot express the intent.
