---
name: 3d-craft
description: Use when a surface earns real depth — product heroes, configurators, studio/Play signatures, data sculptures — the vanilla 3D toolbox (CSS 3D planes, Canvas point projection, SVG isometrics), the interaction contract (draggable never passive), and the domain gates that keep 3D from becoming slop.
source: synthesized from DeSandro 3D transforms, Codrops, CSS-Tricks, MDN, Apple-product dissections (attributions inline)
category: library
---

# 3D Craft — depth without dependencies

Source: David DeSandro's *Intro to CSS 3D Transforms*, Codrops, CSS-Tricks, MDN, and dissections of acclaimed "3D" sites. Core truth from the references: **perceived dimension = smooth scrubbing + lighting, not geometry** — Apple's famous AirPods/Watch spins are pre-rendered image sequences scrubbed by scroll, not 3D. Choose the tier that serves the interaction, never the heaviest one.

## The toolbox tiers

**Tier 1 — CSS 3D planes** (default). `perspective: 600-1200px` on the parent (lower = more distortion; <400px warps type), `transform-style: preserve-3d` on the child; children float at `translateZ(...)`.
- **Tilt-on-pointer**: normalize pointer offset to −1..1, clamp ±8°, LERP in the single shared rAF (`cur += (target−cur)*0.1`) — never transform inside the event handler.
- **Holographic cards**: preserve-3d + child layers at translateZ(40/60px) + a glare gradient whose position tracks the tilt — the production pattern for product cards.
- **Flips**: two stacked faces, `backface-visibility: hidden`.
- **Cubes/carousels**: faces at `rotateY(n×90deg) translateZ(size/2)` (half-dimension rule); ring radius `tz = (panelWidth/2)/tan(π/n)`; to face panel k: `translateZ(-tz) rotateY(-k×step)`.
- **Gotcha**: `overflow:hidden`, `filter`, or `opacity<1` on an element force flattening and silently break preserve-3d.

**Tier 2 — Canvas 2D point projection** (when the object must be genuinely rotatable). The whole pipeline:
```js
// rotate Y then X with drag angles, then perspective-divide:
const s = fov / (fov + p.z);                 // fov ≈ 300
const sx = cx + p.x*s, sy = cy + p.y*s;
const a = clamp((fov + 200 - p.z)/300, 0, 1); // alpha by depth
```
Per-frame z-sort descending (painter's algorithm) so near composites over far. Point spheres (Fibonacci-distributed on unit sphere), starfields, wireframes — same loop. Budget **1500-3000 points**; beyond that 2D fill-rate chokes. Fake fog = alpha by depth; fake DOF = 2-3 stacked planes with graduated blur.

**Tier 3 — SVG isometrics** (flat art with dimension). Iso top face: `transform="matrix(0.866,0.5,-0.866,0.5,x,y)"` (rotate 45°, skew ±30°, 0.866 scale); extruded type = layered duplicates stepping 1px darker, or CSS translateZ stacking.

**Fake-3D compositing** (fidelity over control): scroll-scrubbed image sequence on a pinned canvas (the Apple trick — sprite-sheet it), or 3-layer parallax (bg/mid/fg `data-depth` multipliers) lerped toward pointer in one rAF plus a moving light gradient. Most award-tier "3D-feeling" heroes are exactly this.

**Rule of thumb**: default Tier 1; Tier 2 only when rotation must be real; fake-3D compositing when fidelity matters more than control.

## The interaction contract (non-negotiable)

3D is **operable, never a passive video**: pointer-drag with `setPointerCapture` + inertia (velocity ×0.95/frame decay); scroll-scrub where scrollytelling; **keyboard path** (`tabindex=0`, `role="img"` + aria-label describing the scene, arrows rotate 5°/step, visible focus); auto-rotation pauses on pointerenter and while dragging. `prefers-reduced-motion` swaps to a composed static HERO POSE (a chosen frame, not frame zero). Touch gets the same drag (touch-action:none on the 3D zone only).

## Domain gates (when 3D is warranted)

| Context | Verdict |
|---|---|
| Product configurators / e-commerce heroes | YES — rotation/color-swap aids decisions (reported up to 94% conversion lift, 5-40% fewer returns) |
| Creative studio / Play signatures | YES, budgeted like a logo |
| Data "sculptures" in analytics | Sparingly — a projected point-cloud hero, never the working chart |
| Games/entertainment | Yes, that IS the product |
| Fintech dashboards, health, civic, reading surfaces | NO |

**The test**: does rotation change a decision or convey structure? If the same information survives as a flat image, the 3D is slop.

## Performance laws

Transform/opacity only; single rAF shared with the page's other motion (`dynamism`); pause on `document.hidden` + IO offscreen; delta-time normalization for frame-rate independence; DPR cap `min(devicePixelRatio, 2)`; `will-change: transform` set on interaction start and removed on settle; cache bounding rects, re-measure on resize only.

## The tell-list (3D slop)

Passive spinning logos nobody can grab; loading spinners cosplaying as 3D that never resolve; 3D heroes sitting ON the content instead of behind it; 1px-extruded text shadows as "depth"; no touch/keyboard path; no reduced-motion hero pose; warped perspective (<400px) on type.

## How to apply

1. Gate by domain and mode; name what the depth CONVEYS (structure? decision? presence?).
2. Pick the cheapest tier that delivers it; wire the interaction contract FIRST (drag + keyboard + RM pose), then the render.
3. Compose: canvas backdrop + CSS-3D DOM objects + light gradient + grain is the reliable "award feel".
4. Budget against the signature law — the 3D element usually IS the signature; if it isn't, it's decoration: cut it.

## AI-slop warning

2026's emerging tell: the drifting wireframe sphere + particle field pasted behind every hero ("the gradient orb of 3D"). If your point cloud ignores the pointer, it is a screensaver. Depth must respond, inform, or go.

## Relations

`spectacle` (the signature law this serves), `dynamism` (the shared rAF and ladder), `images-in-motion` + `fluid-functionalism` (movement siblings), `ui-camera` (staged product visuals — the non-realtime cousin), `domain-fit` (the gates).
