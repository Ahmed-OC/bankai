---
name: fluid-functionalism
description: Use when a brief asks for fluid, organic, or satisfying interface motion. Distills Fluid Functionalism — motion is information: three spring speeds, one gliding hover per list, weight shifts without reflow.
source: https://www.fluidfunctionalism.com/; https://www.fluidfunctionalism.com/docs
category: principle
---

# Fluid Functionalism — every transition exists to make a state change legible

Source: https://www.fluidfunctionalism.com/ — created by @micka_design (mickadesign); a design philosophy published as a shadcn/ui component registry plus seven system docs (Fluid Hover, Motion, Typography, Sizes, Surfaces, Scrollbars, Skill). MIT. Source code is React + framer-motion + Tailwind v4; every mechanism below is ported to plain CSS/JS.

## What it is / Why it exists

A stance: **motion is information, not decoration**. Every animation must point at something — reveal a relationship, confirm a target, make a state change legible. An animation that points at nothing is deleted. The philosophy exists because stock UI motion fails three specific ways:

- Plain CSS `:hover` blinks off at every gap between rows (the source's demo: 9 blinks per pass), pulling the eye back to the list.
- Fixed-duration eases can't be interrupted — "if a user reverses mid-transition, the animation adapts" only with springs.
- State changes (selected/active/open) either reflow the layout (weight change widens text) or aren't visible at all.

Five theses from the intro docs, in the author's own terms:

1. **Motion that communicates** — merged selection backgrounds signal items belong together; hover highlights confirm the row you're about to select.
2. **Hover as preview** — "The interaction starts before you click." The element nearest the cursor gets a faint highlight and buttons gain weight as you approach, giving a moment to reconsider, "which is mostly the point."
3. **Springs, not durations** — interrupted animations reverse from the current state instead of finishing first.
4. **Slow in, faster out** — a dismissal reads crisp and final; never replay the entrance in reverse.
5. **Tokenized timing** — "No component invents its own timing, so things you've never thought about together will move at the same pace."

## The core ideas

### 1. Three spring speeds — the entire motion budget

| Token | Duration | Bounce | Leads |
|---|---|---|---|
| `fast` | 0.08s | 0 | hover highlight, focus rings, fades, tooltips, selection indicators, accordion |
| `moderate` | 0.16s | 0 | critically damped — dropdown/tab indicators, switch thumb, mobile drawer, merged selection backgrounds (must land exactly, no overshoot) |
| `slow` | 0.24s | 0.12 | dialogs, side panels, stepped flows — large surfaces only |

Rule: **the bigger the thing that moves, the slower the spring.** Small state flip → fast; traveling indicator/panel → moderate; surface that takes over the view → slow. Never invent a fourth speed; never hand-write a duration — all timing lives in one tokens file. Plain-CSS port: `transition-duration` of 80/160/240ms; bounce 0.12 ≈ a slight-overshoot `linear()` curve on `slow` only. CSS transitions are already interruptible (they retarget from the current computed value), which is exactly the property the philosophy wants from springs.

### 2. Slow in, faster out

Enters are springs; exits are plain tweens one tier quicker:

| Enter | Exit | Exit value |
|---|---|---|
| fast (0.08s) | `fast.exit` | 0.06s |
| moderate (0.16s) | `moderate.exit` | 0.12s |
| slow (0.24s) | `slow.exit` | 0.16s |

A toggle that flips in place (no unmount) picks its transition off state: enter token when opening, exit token when closing. The source's demo: two identical modals open on slow; the one that also closes on slow "drags, and bounces" — "that slight drag on the way out is exactly what you're trying to avoid."

### 3. Fluid hover — one gliding highlight per list

Mechanism: the item whose **center is nearest the cursor** wins; a single absolutely-positioned overlay springs (fast) to that item's rect. The cursor in a gap, in container padding, or past the last row still lights the nearest row. Cost: 1 overlay element, travels on `transform`, 0 layout writes per frame (a `top`/`left` animation writes layout every frame).

Rules that keep it honest:
- Axis matches the shape: `y` for lists (menus, tables, radios), `x` for strips (tabs), `xy` for grids (card groups).
- A gap click lands on the lit row (what is lit is what a click hits); cap it with `maxDistance` — the card grid uses 16px; disable per list if needed.
- One list per group of alternatives: split at dividers; children ride with their parent's list; disabled rows stay registered but are skipped; **only click targets register** — lighting a non-clickable row promises a click with nowhere to land.
- Submenus: crossing a sibling row to reach an open submenu keeps the parent row lit until the pointer stops on another row.
- Fresh pointer entry fades the overlay in at the nearest row (never slides across the screen from its last position).

```js
// One overlay per list; nearest center wins; transform-only travel.
const list = document.querySelector(".menu");           // position: relative
const overlay = Object.assign(document.createElement("div"), {});
overlay.style.cssText = "position:absolute;pointer-events:none;" +
  "transition:transform 80ms,width 80ms,height 80ms,opacity 80ms";
list.prepend(overlay);
const rows = [...list.querySelectorAll("[data-item]")];
list.addEventListener("pointermove", (e) => {
  let best = null, bestD = Infinity;
  for (const r of rows) {
    if (r.getAttribute("aria-disabled") === "true") continue;  // skip, don't unregister
    const c = r.getBoundingClientRect();
    const d = Math.hypot(e.clientX - (c.left + c.width / 2),
                         e.clientY - (c.top + c.height / 2));
    if (d < bestD) { bestD = d; best = c; }
  }
  const base = list.getBoundingClientRect();
  if (!best) { overlay.style.opacity = "0"; return; }
  overlay.style.opacity = "1";
  overlay.style.transform =
    `translate(${best.left - base.left}px, ${best.top - base.top}px)`;
  overlay.style.width = best.width + "px";   // width/height change only
  overlay.style.height = best.height + "px"; // between differently sized items
});
```

### 4. Weight without reflow — the ghost-span pattern

Selected/checked/active/open text gets heavier. A heavier weight is wider; animating it on a bare text node reflows the layout. The pair: regular 400 → semibold 550, with a tighter optical size (`opsz`) paired to the heavier weight so advance width stays within ±0.4px. Animate `font-variation-settings`, never `font-weight`; reserve width with an invisible copy of the label at the heaviest weight; the transition list must include `font-variation-settings` or the weight snaps. Requires a variable font with both `wght` and `opsz` axes (source: Inter Variable). Skip the ghost only when weight never changes or the box is fixed-size.

```html
<style>
  .lbl { display: inline-grid; }
  .lbl > span { grid-area: 1 / 1; }
  .lbl .vis { transition: color 80ms, font-variation-settings 80ms;
              font-variation-settings: "wght" 400, "opsz" 14; }
  .lbl .vis.on { font-variation-settings: "wght" 550, "opsz" 18; }
  .lbl .ghost { visibility: hidden;
                font-variation-settings: "wght" 550, "opsz" 18; }
</style>
<span class="lbl">
  <span class="vis on">Inbox</span>                        <!-- animates -->
  <span class="ghost" aria-hidden="true">Inbox</span>      <!-- reserves width -->
</span>
```

### 5. Icon swaps — two glyphs, one cell

copy→check, play→pause: both glyphs stay mounted in one grid cell the size of the icon and crossfade; the slot never resizes. Leaving glyph: opacity 1→0, blur 0→4px, scale 1→0.6 on 60ms ease-in. Arriving glyph: 0→1, 4→0px, 0.6→1 on 80ms ease-out — **an appear always outlasts a disappear** (why tweens, not springs: a critically damped spring settles before its nominal duration and would invert that order; blur is a filter string a spring can't drive). Screen readers hear "Copied" from a visually hidden span in an `aria-live="polite"` region.

```css
.swap { display: grid; width: 16px; height: 16px; }
.swap > svg { grid-area: 1 / 1; transition: opacity 60ms ease-in,
              filter 60ms ease-in, transform 60ms ease-in; }
.swap .in { opacity: 0; filter: blur(4px); transform: scale(.6); }
.swap[data-on] .out { opacity: 0; filter: blur(4px); transform: scale(.6); }
.swap[data-on] .in  { opacity: 1; filter: blur(0); transform: scale(1);
                      transition-duration: 80ms; transition-timing-function: ease-out; }
```

### 6. Typography — 5 styles, 3 weights, 2 colors, 1 family

| Style | Use | Size/leading | Weight + opsz |
|---|---|---|---|
| Display | page titles | 28/34 | 700, opsz 25 |
| Title | section titles | 16/22 | 550, opsz 18 |
| Subtitle | sub-headings, card titles | 14/20 | 550, opsz 18 |
| Body | labels, menu items, paragraphs | 13/20 | 400, opsz 14 |
| Caption | descriptions, meta rows | 12/16 | 400, opsz 14 |

No-gos: **no uppercase** (hierarchy comes from size and weight), **no letter-spacing** (optical sizing handles it), **no eyebrow labels** (a section starts with its title), **no special markdown styling**, **no text opacity** — text is foreground or muted, never a faded foreground. Tweaks: `tabular-nums` for counts ("Installed 10 of 48 components"), `text-box: trim-both cap alphabetic` so padding matches visible space, `text-wrap: balance` for headings, `text-wrap: pretty` for paragraphs. Add space above blocks only, so streaming text never shifts.

### 7. Sizes — a two-step rhythm, region-level

Two sizes only: 36px default, 28px compact (dense, data-heavy tools only). Every size scales text, icons, and padding together: control height 36/28; label text 13/20 vs 12/18; **field text 16px on touch so iOS doesn't zoom on focus**; icons 16 vs 14; control padding 12/8 vs 10/6; gaps 8 vs 4. Density is a region decision (one provider wraps an area; context crosses portals so menus follow), never per-control. Menu rows share the control token so they align with their trigger. "An interface reads as one product when its controls share a sizing rhythm."

### 8. Surfaces — eight levels that nest

Elevation tokens are bg/shadow pairs. Light mode flattens to white after level 2 — shadow alone carries elevation beyond that. Dark mode keeps lightening the background (white-opacity + layered shadow) each level. A container knows its own level (substrate context) and anything that opens inside lifts exactly one step off it — no props passed between components. Hover fill is +6%, selected +10% at every level. The failure it fixes: a dark dialog at `#333333` with a dropdown that is also `#333333` — indistinguishable; correct: dialog `#333333`, its menu `#414141`.

### 9. Reduced motion — fewer and gentler, not none

Keep opacity and color fades (they aid comprehension); drop transforms, position, scale, and layout shifts. Wire it once at the root (framer: `<MotionConfig reducedMotion="user">`); any component that can't count on that wrapper reads the media query itself and snaps position while keeping the fade.

### 10. Transform and opacity only; never stack measured collapses

Animate `transform` and `opacity`, never `top`/`left`/`width`/`height`: layout properties are off the compositor fast path AND they escape reduced-motion auto-coverage — one fix for both. Never nest two animated measured-height collapses: a wrapper that springs to a measured height must snap (`duration: 0`) when a child re-measures underneath it. Measured before the guard: child lands in 218ms, wrapper in 326ms, diverging ~80px mid-flight — "what makes a deep tree feel sludgy."

### 11. Selection merges

Contiguous selected rows in menus and checkbox groups share one background (moderate spring) and split apart where unselected rows sit between them — motion literally draws the grouping. Hover and selection fills come from shared tokens, not ad-hoc grays, so they read correctly on every surface level.

### 12. Scrollbars stay out of the way but never disappear

The thumb rests narrow and low-contrast; on hover it widens and darkens — "stays quiet until you reach for it." Touch-primary devices defer entirely to native overflow scrolling ("platform physics beat any custom scrollbar"). Edge fades are CSS masks dissolving content toward the edges that have more to scroll, with a scroll-driven animation keeping the true start and end crisp — no JavaScript.

## When to use / When NOT to use

Use when: the brief says fluid, organic, alive, satisfying, or polished; the product is tool-like UI (menus, tables, dialogs, sidebars, command palettes, chat); motion should explain state — grouping, targeting, confirmation; a list currently blinks between rows or labels jump when selected.

Skip fluid hover when: a wrong click would hurt; only some cards are clickable; there's lots of empty space; rows move on scroll. Skip the stance when motion budget must be near zero (kiosk, performance-critical, strictly sober contexts). The source's own audit rule: **"a behavior the app has never had is a question, not a finding"** — stillness is often deliberate; introducing a signature motion "changes how the whole thing feels, so ask."

Installing the actual registry is justified when the project is React 19 + Tailwind v4 + shadcn and wants the whole system at once (`npx shadcn@latest registry add @fluid`, then `add @fluid/<name>`; `base/` prefix for the Base UI flavor; `--overwrite` to replace stock shadcn files — non-interactive shells exit at the first prompt otherwise). In every other stack, port the mechanisms above — they are the philosophy.

## How to apply (numbered checklist)

1. Define the three motion tokens before writing any animation: 80ms / 160ms / 240ms, exits 60 / 120 / 160ms. All durations live in one place; a literal duration anywhere else is a bug.
2. Classify each animated surface by size: state flip → fast; traveling indicator/panel → moderate; view-taking-over surface → slow (+bounce only on slow).
3. Give every list/menu/strip/grid ONE hover overlay that glides to the nearest item center; delete per-row `:hover` backgrounds in lists.
4. Route gap clicks to the lit row (cap at 16px on grids); split lists at dividers; register only click targets; skip disabled rows.
5. Exits one tier faster than entrances, as tweens.
6. Selected/active labels shift weight 400→550 via `font-variation-settings` + ghost span; load the variable font with both `wght` and `opsz` axes.
7. Animate only transform/opacity; re-express any top/left/width/height animation; snap (0ms) any wrapper whose measured height changes underneath it.
8. Reduced motion: keep fades, drop movement; wire once at the root, self-check in floating components.
9. Icon state changes crossfade in one fixed cell (leave 60ms ease-in, arrive 80ms ease-out, blur 4px, scale 0.6) with an `aria-live="polite"` label.
10. Merge contiguous selections into one background; fills from shared tokens so they read on every surface level.
11. Type: one family, 5 styles, 3 weights, 2 colors; no uppercase, no letter-spacing, no text opacity; `tabular-nums`, `text-wrap: balance`/`pretty`.
12. Two control sizes (36/28) set per region, scaling text + icons + padding together; 16px field text on touch.
13. Elevation: nested layers step one level at a time via context; light mode stops lightening backgrounds after level 2.
14. Before advising changes to an existing app: measure what actually ships (the source's audit moves a real pointer to see whether hover glides or blinks); rank 2–5 upgrades by what users will notice; never front a migration the user didn't ask for. "No changes recommended" is a valid outcome.

## AI-slop warning

How AI typically misapplies this principle:

- Sprays springs and bounce everywhere. The source has exactly three speeds and only one carries bounce (slow, 0.12). A fourth duration, or overshoot on a dropdown, is drift — the system exists because "exit timings drifted before they were tokenised."
- Applies fluid hover indiscriminately. The source skips it when wrong clicks hurt, when only some items are clickable, or in sparse/moving layouts — and warns that introducing it changes how the whole product feels: ask first.
- Animates `font-weight` directly (reflow), animates layout properties (top/left/width/height), or hand-writes exit durations — the three specific drifts the source tokenized against.
- Adds uppercase or letter-spacing to labels, or fades text with opacity instead of using a muted color (explicit no-gos).
- Decorates: entrance staggers on everything, floating gradients, parallax. None of it points at a state change; under this philosophy it is deleted.
- Genericizes the vocabulary into "nice micro-interactions." The actual terms: fluid hover (one overlay, nearest center), springs not durations, weight without reflow, slow in / faster out, surfaces that nest.

## Relations

- transitions — broader transition/easing craft; Fluid Functionalism constrains it: no bespoke curves or durations, only the three tiers and their paired exits.
- easing — curve-level theory; this philosophy replaces curve-picking with token-picking and adds the bounce-only-on-slow rule.
- magic-ui — animated-component libraries for one-off effects; use this philosophy instead when the whole product must move at consistent magnitudes.
- taste — the judgment layer this philosophy defers to: stillness is often deliberate; ask before introducing a signature motion.
- web-interface-guidelines — baseline interaction rules this system assumes and extends with its motion, typography, and surface specifics.
