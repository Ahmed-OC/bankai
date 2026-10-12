---
name: use-layouts
description: Use when structuring a page or region and you need a named, proven layout pattern (bento tile, spotlight grid, scroll stack, deck, drawer, infinite canvas) with its plain-CSS mechanism, not an invented box arrangement.
source: https://uselayouts.com/; https://github.com/iurvish/uselayouts
category: library
---

# useLayouts — named layout patterns as primitives

Source: https://uselayouts.com — free library of 64 animated React components by Urvish Mali (@0xUrvish). MIT. Delivered as source you own via a shadcn registry (`npx shadcn@latest add @uselayouts/<name>`), not an npm dependency. Stack: React + Tailwind + Motion (Framer Motion); some entries add vaul (drawers), lenis (smooth scroll), react-use-measure.

## What it is / Why it exists

Despite the name, useLayouts is NOT a static page-skeleton catalog. There is no "holy grail", no sidebar+content template — those are 5-line CSS grid patterns you write yourself. What it ships are **motion-choreographed spatial layouts**: grids that re-flow, decks that stack on scroll, drawers that fold open, canvases that pan forever.

Why it exists — the author's own gap, from the docs: kit defaults ("a scale on hover. A fade on open. The same three transitions on every surface") feel dead; he wanted "motion that tells you the UI is listening" for moments "where a static UI feels rude — waiting, deleting, switching, dragging". Its motion law, verbatim: **"Every animation here is supposed to do a job: feedback, focus, or flow. If it only looks expensive, cut it."**

For an agent, the value is a **named inventory of proven layout patterns with tuned constants** — pick a pattern, port its mechanism in plain CSS, skip the dependency.

## The layout inventory

Site taxonomy: four marketing umbrellas — Layouts (Grid, Bento, Hero, Sections), Navigation (Navbar, Tabs, Menu, Sidebar), Interactions (Hover, Drag, Press, Reveal), User Interface (Cards, Forms, Gallery, Pricing). The layout-bearing patterns, grouped by structure:

### Family A — Grids that re-flow
| Name | Mechanism | Pick when |
|---|---|---|
| `fluid-expanding-grid` | 2×2 grid; clicked tile takes `grid-column: 1 / span 2`, displaced neighbor reflows to the other row; FLIP-animated | Hero for exactly 3–4 items ("a grid that breathes") |
| `dynamic-grid-gallery` | 3×2 grid; hovered row+column tracks grow to 1.95fr, others shrink to 0.9fr; tracks tween | 6-item showcase; one image must take the stage |
| `bento-card` | ONE ~420px bento tile with tabs that swap product previews inside the same card ("layout morph, not a hard cut") | SaaS homepage "see the product" tile inside a larger bento you write yourself |
| `magnified-bento` | Bento tile + draggable magnifier lens over scrolling chips | Feature highlight with dense detail |

Note: bento arrangement itself is yours — `grid-template-areas` with mixed spans. The library only animates content inside one tile.

### Family B — Scroll-driven stacks
| Name | Mechanism | Pick when |
|---|---|---|
| `scroll-stack-deck` | N×110vh track, sticky 100vh stage; scroll progress maps each card to y/scale keyframes | Studio/agency "selected work", case-study index — needs a LONG page |
| `stack-scroll-reveal` | Cards pin, peel, scale, fade as you scroll | Case studies where earlier cards recede |
| `scroll-split-cards` | One photograph splits into three panels on scroll, then flips to copy | Editorial section break |
| `perspective-text-scroll` | Text tilts through scroll perspective | Scroll-statement typography |

### Family C — Decks and carousels
| Name | Mechanism | Pick when |
|---|---|---|
| `editorial-deck` | Stacked story cards; drag front card, it springs back | Story browsing |
| `rolling-card-stack` | Swipe + keyboard card stack, autoplay, paging | Tinder-style browsing of N items |
| `polaroid-stack` / `polaroid-drag` | Physical photo stacks: fan into arc on hover / drag with realistic tilt | Portfolio, about-page personality |
| `pop-tilt-cards` | Deck pops toward cursor in 3D | Small link collections |
| `overlapping-slider` | Full-width card row; on move the left card scales back | Landing rows of portraits/products |
| `wheel-carousel` | Vertical wheel you spin: drag, scroll, keyboard, snap, momentum | Date/category pickers, large catalogs |
| `coverflow-drag` | Drag coverflow: items scale, dim, snap | Media libraries |
| `feature-carousel` | One feature at a time | Feature tours |
| `photo-albums` | Tilted album stacks expand into a shared-element photo grid (FLIP) | Photo narrative |
| `expandable-gallery` | Items grow into place on demand | Mixed-size galleries |

### Family D — Panels and navigation shells
`curve-drawer` (side drawers whose inner edge morphs bulge→straight line), `drawer-buttons` (payment from right, cart from left, 3D fold, staggered fields), `bottom-menu` (floating dock that expands on demand), `dynamic-toolbar` (resizes around its content), `gooey-navbar` (pills melt via SVG goo filter), `discrete-tabs`, `vertical-tabs`, `stacked-list` (stacked expandable list with morphing transitions), `accordionos`, `multi-step-form`.

### Family E — Canvas
`infinite-grid` (Infinite Canvas): free-panning grid that tiles forever — drag, scroll, skim images + captions. For catalog-like exploration where pagination is friction.

## Signature mechanisms in plain CSS

### 1. Spotlight grid (`dynamic-grid-gallery`) — no JS library
```css
.spotlight {
  display: grid;
  grid-template-columns: 0.9fr 0.9fr 0.9fr;   /* idle */
  grid-template-rows: 0.9fr 0.9fr;
  gap: 10px;
  transition: grid-template-columns .5s cubic-bezier(0.25, 1, 0.5, 1),
              grid-template-rows      .5s cubic-bezier(0.25, 1, 0.5, 1);
}
.spotlight.c0 { grid-template-columns: 1.95fr 0.9fr 0.9fr; }
.spotlight.c1 { grid-template-columns: 0.9fr 1.95fr 0.9fr; }
.spotlight.c2 { grid-template-columns: 0.9fr 0.9fr 1.95fr; }
.spotlight.r0 { grid-template-rows: 1.95fr 0.9fr; }
.spotlight.r1 { grid-template-rows: 0.9fr 1.95fr; }
.spotlight > * { min-width: 0; min-height: 0; }  /* fr math holds */
```
```js
// on tile pointerover: r = Math.floor(i / 3), c = i % 3 → add .r{r} .c{c}; remove on leave
```
Only fr-track lists interpolate; px/% track lists snap. Idle tiles get a vignette (`opacity: .4` black gradient) that clears on hover — cheap depth.

### 2. Span-to-expand (`fluid-expanding-grid`) — FLIP without Motion
```js
function flip(el, mutate) {
  const a = el.getBoundingClientRect();       // First
  mutate();                                   // new grid position (Last)
  const b = el.getBoundingClientRect();
  el.animate([{ transform:
    `translate(${a.left - b.left}px, ${a.top - b.top}px)
     scale(${a.width / b.width}, ${a.height / b.height})` },
    { transform: "none" }],                   // Invert → Play
    { duration: 350, easing: "cubic-bezier(0.22, 1, 0.36, 1)" });
}
```
State model: `row1` / `row2` arrays, max 2 ids each. Clicking a tile makes it the sole occupant of its row (`grid-column: 1 / span 2`) and pushes its ex-neighbor into the other row. Native `el.animate` + grid reflow = same effect as Motion's `layout` prop.

### 3. Scroll stack deck — sticky pin + progress mapping
```css
.deck-track { height: calc(var(--n) * 110vh); }   /* 110vh per card */
.deck-stage { position: sticky; top: 0; height: 100vh; overflow: hidden; }
.deck-card  { position: absolute; inset: 0; }
```
```js
// p = scrolled / (trackHeight - vh), smoothed by a spring or rAF lerp.
// Card i of n, transitions at k/n:
//   active        → y: 0,      scale: 1
//   stack depth d → y: -48*d,  scale: 1 - 0.038 * d
//   not yet seen  → y: 900px  (below fold, slides up into place)
```
The spring on scroll progress is what kills wheel-tick stutter — copy the idea, not just the keyframes.

### Mechanism one-liners for the rest
- Drawers: `position: fixed; transform: translateX(100%) → 0`; animate the inner-edge `border-radius` for the curve-drawer morph.
- Gooey navbar: SVG filter `feGaussianBlur stdDeviation≈8` + `feColorMatrix` alpha contrast ≈20 — pills bridge like liquid.
- Wheel/carousels: flex track + `translateX` with snap points; native floor is `scroll-snap-type: x mandatory`.
- Infinite canvas: `overflow: hidden` wrapper; inner grid translated by pointer-drag delta via `translate3d`; tile coordinates taken modulo the grid period so content repeats forever.
- Bento: `grid-template-areas` + spans; animate only entry (stagger children 40–60ms apart, ease-out).

## When to use / When NOT to use

Use when: landing/marketing/story pages where motion means focus or flow; state changes that deserve choreography (expand, open, stack, settle); you can name the pattern from the inventory above.

NOT when: dashboards and dense data UI — motion costs task time; reading/content pages — pinned stacks hijack scroll; touch-primary UI — hover-spotlight grids are invisible without a tap fallback; you need the static skeleton (sidebar, holy-grail, header-footer) — that is plain CSS grid, not a component; the pattern would be the page's third animated region — one mechanism per viewport.

## Install vs build by hand

Install (`npx shadcn@latest add @uselayouts/<name>`) is justified when: already on React + Tailwind + shadcn; you want the author's tuned springs and a working choreographed demo to strip ("a starting point you can ruin on purpose"); you'd otherwise hand-write 150+ lines of scroll/drag math (wheel-carousel, infinite canvas).

Build by hand when: you need ONE mechanism — snippets 1–3 are 10–80 lines; you are not on React; the page has no motion budget; the layout must work with JS disabled. The dependency is never justified for a static arrangement.

## How to apply

1. Name the region's job (browse / story / panel / canvas) and pick the matching family entry — do not invent a novel box arrangement.
2. Write the static skeleton first in plain grid/flex; it must be complete and correct with zero JS.
3. Add exactly one mechanism; port the tuned constants verbatim: 1.95fr spotlight, 500ms `cubic-bezier(0.25,1,0.5,1)`, −48px·d and `1−0.038·d` stack depth, 110vh per card, ~420px bento tile.
4. Apply the source's test to every animation: feedback, focus, or flow? If only "looks expensive", cut it.
5. Guard with `@media (prefers-reduced-motion: reduce) { animation: none; transition: none }` — layout stays, motion goes.
6. Give hover-driven grids a touch fallback (tap-to-select or slow idle rotation).
7. Scroll stacks only on dedicated long pages; never inside a short section.
8. If ≥2 mechanisms needed AND the stack is React+Tailwind+shadcn, install via the registry and delete what you don't use.

## AI-slop warning

Bento-with-hover-grow + sticky stacking cards + draggable polaroid deck became the default 2024–2026 AI-SaaS landing template. Three of these patterns on one page reads generated. This look poisons: internal tools, docs, checkout — anywhere motion sits between intent and action. Failure modes: scroll stacks on short pages (110vh per card traps), spotlight grids without touch fallback, importing Motion for a single fade, bento grids where every tile animates (only the changing region should). The library's own bar applies: "If it only looks expensive, cut it."

## Relations

- `transitions` — the motion vocabulary (springs, easings) these layouts ride on; use it to tune the constants above.
- `magic-ui` — sibling shadcn-registry library biased toward effects; useLayouts is biased toward spatial choreography. Pick one per page.
- `fluid-functionalism` — the philosophy underneath: layout responds to user intent instead of sitting still.
- `web-interface-guidelines` — the a11y/perf guardrails (reduced-motion, scroll behavior) every pattern here must pass.
- `html-can-do-that` — the native floor: scroll-snap, `details`, popover, sticky often replace the JS entirely.
