---
name: liquid-gooey
description: Use when UI pieces should merge, bridge, or trail like liquid — droplet menus, tab indicators, molten image pairs. Encodes the SVG blur + alpha-contrast goo trick behind a crisp silhouette layer.
source: https://gooey.jakubantalik.com/; https://libraries.dev/gooey.html
category: library
---

# Liquid Gooey — SVG goo for organic merges

`Source:` https://gooey.jakubantalik.com/ (now redirects to https://libraries.dev/gooey.html) — Liquid Gooey, npm package `liquid-gooey`, by Jakub Antalík (also author of Thinking Orbs). MIT. React ≥ 18, zero runtime dependencies. Docs = the package README.

## What it is and why it exists

A library of liquid-merge effects for React: touching pieces fuse like metaballs, surfaces morph like jelly, elements trail liquid-rubber tails. Four effects — **Morph** (default), **Move**, **Melt**, **Bend** — plus **`dissolve`**, an orthogonal modifier that melts imagery at contact points. Keywords the author uses: gooey, metaball, liquid, svg-filter, spring.

The stated "why": the classic gooey effect runs blur + alpha-contrast *over your actual UI pixels*. That single decision costs everything downstream — text goes soft, images smear, shadows become impossible (the contrast step eats them), and Safari renders CSS `url()` filters on HTML wrongly. So the effect historically stayed confined to decorative colored circles. Liquid Gooey's answer: split it in two — "a silhouette layer carries the goo and the shadow, your real DOM rides crisp on top. Same liquid, none of the tax." Consequences the author claims and the source confirms:

- **Real shadows**: parsed from `box-shadow` syntax, rebuilt on the *merged* silhouette, so one consistent shadow hugs the liquid through every merge, split, and bridge.
- **Crisp everything**: text, icons, photos are never filtered.
- **Safari included**: filters run on SVG content, never CSS `filter: url()` on HTML — the specific thing WebKit gets wrong.
- **Real UI, not decoration**: the content layer is live DOM — focus rings, hit targets, ARIA, handlers intact.
- **Zero idle cost**: springs compile to GPU-composited CSS `linear()` easings; the measurement loop sleeps completely when nothing moves.

## The core ideas

### 1. The goo mechanism: blur, then alpha-contrast threshold

Two SVG primitives produce metaball merging. Blur the shapes so close neighbours' alpha fields overlap, then crush the alpha channel through a steep slope so the mushy overlap snaps into a solid bridge:

```
alpha' = contrast × alpha + intercept,  where intercept = 0.5 − contrast × (5/12)
```

- Default `blur` = 6 (feGaussianBlur stdDeviation, px), default `contrast` = 18 → matrix row `0 0 0 18 -7` (the canonical goo matrix).
- The threshold is **fixed at alpha ≈ 5/12 ≈ 0.42 regardless of contrast** — contrast only sets edge sharpness. Raise it for a crisper liquid edge, lower it if the boundary looks aliased/jagged.
- **Bridging is a ratio of blur to gap**: neighbours merge once `blur ≳ the gap between them`. Items 8px apart barely bridge at `blur` 5 and merge cleanly at `blur` 12. If pieces that should merge look separate, raise `blur` or close the gap before suspecting anything else.
- `feComposite operator="atop"` composites the original SourceGraphic back over the goo so shapes keep crisp silhouettes inside the merged mass.

### 2. Never filter the real DOM — two layers, one source of truth

The architecture (verified in source):

- **Silhouette layer (below)**: an absolutely-positioned, `aria-hidden`, `pointer-events: none`, `z-index: -1` SVG holding one plain `<rect>` per item, mirroring its geometry including measured `border-radius` (percentage radii, circles, pills just work). The goo filter and shadow chain run here, on SVG content — identical rendering in Chrome, Firefox, Safari.
- **Content layer (above)**: the real, interactive, unfiltered elements. Give them transparent backgrounds — the liquid below is their surface. An opaque child (a full-bleed photo in a circle) covers its own blob, which is correct for image chips.
- The group is `position: relative; isolation: isolate`, sized to contain the *full travel* of its items (a menu reserves its open footprint).
- `will-change: filter, transform` on the SVG promotes the layer — WebKit otherwise repaints the goo a frame or two behind the plain-DOM content.
- Filter region: `filterUnits="userSpaceOnUse"`, padded by `ceil(blur×3 + shadowExtent + 24)` px (the 24 is `filterPadding`, default 24) so travelling blobs never clip. Always set `color-interpolation-filters="sRGB"`.

### 3. Shadows must live on the merged silhouette

- Simple drop shadows (no inset, no spread): a CSS `filter: drop-shadow(x y blur color)` chain on the SVG element itself — GPU-friendly and cross-browser because it's on SVG content.
- Inset or spread shadows need SVG passes: binarize the shape (matrix `0 0 0 60 -29.5`, threshold ≈ 0.49), then `feMorphology` dilate/erode by `|spread|`, `feGaussianBlur` with **stdDeviation = box-shadow blur ÷ 2**, `feOffset` by (x, y), `feFlood` + `feComposite in` for color. Inset bands: silhouette minus its eroded/offset/blurred self (`feComposite out`). One `feMerge` stacks drops (reversed), shape, insets.

### 4. Effect inventory and exact defaults

- **Morph** (default): touching blobs share the group filter, so merging is automatic. `morph={{ shape: true }}` adds jelly shape-change (springs + droplet travel + corner timeline). Knobs: `shape` false, `speed` 1, `bounce` 0.5 (0 = critically damped), `contentBlur` 7 (max px *content* cross-blurs while moving, sharpening as it settles; 0 disables). Advanced: `massStiffness` 320, `cornerDuration` 820, `blobInset` 2, `bridgeGrow` 8.
- **Move**: the liquid trails an element *you* move however you like (CSS, pointer events, any animation lib) with a droplet tail. Knobs: `springiness` 0.5 (0 = heavy syrup, 1 = near-instant), `wobble` 0.5, `stretch` 0.36, `trail` 0.575 (0 disables the tail). Advanced: `stiffness` 380, `damping` 18.
- **Melt**: two images run molten into each other — the goo averages their colours where they touch, crisp faces dissolve back at the seam, a marbling pass folds the palettes into streaks. Pairwise by design: the first two melt items in a group form the pair. Knobs: `blur` 7, `contrast` 40, `reach` 0.8, `fade` 17, `warp` 0, `mix` 1, `mixBlur` 8, `gravity` 1.9, `waviness` 12.
- **Bend**: the body deforms with velocity like a soft bar pulled through liquid — vertical drag arcs the long edges (middle leads, ends lag), horizontal drag blunts the leading cap and stretches the trailing one. No lag, no tail; surface stays glued to content. Knobs: `vertical` 0.6, `horizontal` 0.35. Live bend is published as CSS variables `--lg-bend-x/y` (px) and `--lg-bend-xn/yn` (unitless) so content can lean/rotate along:
  ```css
  .card > * { transform: translateY(calc(var(--lg-bend-y, 0px) * 2))
                           rotate(calc(var(--lg-bend-yn, 0) * 1deg)); }
  ```
- **`dissolve`** (modifier, orthogonal to effect): melts an item's *imagery* into a touching neighbour at the contact point — a liquid warp (SVG displacement), not a blur. Strength ramps with proximity, tracking where the goo bridge actually forms; text is never melted, only imagery. Wire `active` to your drag state to clear on release. Ignored under `move` with a dev warning. Default contact zone = `blur × 2.2 + 4` px.

### 5. Motion: springs compiled away

Component-driven animation compiles spring simulations to cached CSS `linear()` easings — GPU-composited transitions, zero per-frame JS. Fallback (no `linear()` support): `cubic-bezier(0.34, 1.56, 0.64, 1)` when the spring overshoots, `cubic-bezier(0.22, 1, 0.36, 1)` when it doesn't. `transition` accepts `'snappy' | 'smooth' | 'bouncy'`, `{ stiffness, damping, mass }`, or `{ duration, ease }`; `delay` is ms (example uses 40). `x`/`y`/`scale` animate element and liquid in one commit — pixel-perfect sync. The alternative path, `observe`, makes the liquid follow a child's rendered rect (implied by `morph.shape`, `dissolve`, `move`): one per-group rAF loop that sleeps entirely after ~0.5s of stillness and wakes via MutationObserver / transition events / ResizeObserver / pointer events.

### 6. The whole thing from scratch (no dependency)

The signature technique in plain HTML/CSS/JS — a merging two-button group:

```html
<div class="goo-group" style="position:relative;isolation:isolate">
  <!-- Silhouette: SVG only, behind content, untouchable -->
  <svg aria-hidden="true" focusable="false"
       style="position:absolute;inset:0;width:100%;height:100%;overflow:visible;
              pointer-events:none;z-index:-1;will-change:filter,transform">
    <defs>
      <filter id="goo" filterUnits="userSpaceOnUse" x="-42" y="-42" width="340" height="180"
              color-interpolation-filters="sRGB">
        <feGaussianBlur in="SourceGraphic" stdDeviation="6" result="b"/>
        <feColorMatrix in="b" type="matrix"
          values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="goo"/>
        <feComposite in="SourceGraphic" in2="goo" operator="atop"/>
      </filter>
    </defs>
    <g filter="url(#goo)" fill="#fff">
      <rect x="0"  y="0" width="48" height="48" rx="24"/>
      <rect x="52" y="0" width="48" height="48" rx="24"/>
    </g>
  </svg>
  <!-- Content: real DOM, transparent backgrounds, on top -->
  <button class="g-item" style="position:absolute;left:0;width:48px;height:48px;background:transparent">A</button>
  <button class="g-item" style="position:absolute;left:52px;width:48px;height:48px;background:transparent">B</button>
</div>
```

```js
// Keep each blob glued to its element: ONE transform value, written in the same commit.
function place(el, blob, x, y) {
  const t = `translate(${x}px, ${y}px)`;
  el.style.transform = t;
  blob.setAttribute('transform', t);
}
// Animate x from 0 toward 56: the neck forms, stretches, and snaps — the merge.
// Drag this through a CSS transition or spring on both nodes with identical timing.
```

```css
/* Simple drop shadow on the merged liquid — on the SVG element, not the HTML: */
[data-gooey-svg] { filter: drop-shadow(0 2px 6px rgba(0, 0, 0, 0.08)); }
```

Optional liquid waviness (edges read as fluid, not geometric): after the composite, run
`<feTurbulence type="fractalNoise" baseFrequency="0.018" numOctaves="2" seed="7"/>` +
`<feDisplacementMap in="shape" in2="n" xChannelSelector="R" yChannelSelector="G" scale="{waviness×2}"/>` — `waviness` is max px of undulation.

**When installing is actually justified**: hand-rolling Morph's shape physics (droplet travel, corner timelines), Move's trailing tail plus WebKit's repaint offset, or Melt's marbling/seam maths is real engineering — that is the product. For a static or single-merge case, the ~30 lines above are enough. `dissolve` writes `mask-image` onto `<img>`s during contact; `morph.shape` writes `filter: blur()` onto the element mid-morph — don't combine with your own masks/filters there. Rotation is not mirrored by the silhouette (v1).

## When to use / When NOT to use

Use goo when the metaphor is physical: pieces that *belong* together merge.

- Fan-out menus where the plus-button splits like droplets (the library's flagship demo; architecture credited to a "Gooey plus menu" prototype).
- Avatar/face piles, chips, and badge clusters that visually pool into one mass.
- Tab indicators and slider thumbs — a droplet trailing the handle reads as one continuous surface.
- Dragged things: dissolve imagery at the contact point as two surfaces meet.
- Morphing panels (search bar → results pill) where the liquid mass flows to the new centre first.
- Two hero images running molten into each other (Melt) — pairwise only.
- Generic-technique homes that predate this library: gooey loading shapes (metaball spinners), dock magnification where icons swell into neighbours — same blur+contrast filter, same rules below.

NOT:

- Any surface where text or data sits *inside* the filtered area under the naive approach — and under the two-layer approach, any container whose children can't be transparent (the blob is the surface).
- Dense or serious UI: tables, forms, checkout, medical/financial data — organic merging implies a stickiness the product doesn't have.
- As ambient decoration on marketing pages — goo under static content is dead weight (a filtered SVG repainting for nothing).
- When a plain border-radius/transform transition conveys the same thing at 1% of the cost.
- If you need rotation mirrored, or need your own `mask-image` on images / `filter` on morphing elements (conflicts listed above).
- Reduced-motion users: transitions must collapse to instant snaps (`prefers-reduced-motion` is handled; keep it that way).
- Never apply `filter: url(#goo)` to HTML elements for Safari-facing code — that route is broken in WebKit; the filter belongs on SVG content.

## How to apply (numbered checklist)

1. Decide silhouette ownership: every merging child gets `background: transparent`; the goo layer below is its surface. Opaque media (full-bleed photos) may cover their own blob.
2. Measure the largest gap between neighbours; set `blur` ≥ that gap (8px gap → blur 12, not 5). Group container sized to the items' full travel.
3. Start `contrast` 18 (edge too soft → raise; edge crunchy → lower). Threshold stays ≈ 0.42 either way.
4. Build the filter with `filterUnits="userSpaceOnUse"`, region padded `3×blur + shadow extent + 24px`, `color-interpolation-filters="sRGB"`, chain blur → matrix → `atop` composite.
5. Put the filter on the SVG silhouette group (`z-index: -1`, `aria-hidden`, `pointer-events: none`), never on HTML; add `will-change: filter, transform` to avoid WebKit's 1–2 frame lag.
6. Animate element and its blob in one commit (same transform, same frame) — or use rect-observation with a rAF loop that fully sleeps after ~0.5s idle and wakes on transition/resize/mutation/pointer events.
7. Shadows: simple drops as CSS `drop-shadow()` on the SVG element; inset/spread via the SVG pass chain (§3) so they follow the merged outline.
8. Tune character with the three-motion-knob rule: springiness/wobble/trail for Move (0.5/0.5/0.575), speed/bounce/contentBlur for Morph shape (1/0.5/7 px).
9. Respect `prefers-reduced-motion`: collapse to instant snaps.
10. Keep all semantics on the content layer — the silhouette SVG is decoration only.

## AI-slop warning

The gooey blob menu was a CodePen/showreel cliché already once (2014–2016, post-CSS-tricks gooey menu); AI now revives it with glassmorphism gradients into pure noise. It poisons enterprise dashboards, fintech, email clients, and forms — anywhere stability is the promise. The classic AI failure modes on this effect: (1) applying the filter to the real DOM, shipping soft text and smeared icons; (2) using `filter: url()` on HTML and calling it cross-browser; (3) blur cranked to 20+ so everything is syrup and hit-target edges no longer match the visible blob; (4) goo on elements that never touch, paying repaint cost for zero merge; (5) forgetting that the *shape* the user clicks must still match the *shape* they see — an un-padded filter region that clips the blob breaks that contract at the edges. If everything melts, nothing reads as tactile — one goo moment per view, maximum.

## Relations

- **svg-guide** — the primitives underneath (feTurbulence, feDisplacementMap, filter regions, color-interpolation) for going past the stock chain.
- **easing** — the spring-to-`linear()` compilation strategy and when bouncy (`cubic-bezier(0.34,1.56,0.64,1)`) vs smooth (`cubic-bezier(0.22,1,0.36,1)`) is right for the merge.
- **thinking-orbs** — same author (Jakub Antalík), sibling organic-motion vocabulary; orbs for idle/ambient life, goo for contact physics.
- **loading-dev** — loading shapes are the classic standalone goo use; shares the "must loop cheaply" constraints.
- **transitions** — decide whether a merge is warranted at all before paying for one; plain transform transitions cover most neighbour-change stories.
