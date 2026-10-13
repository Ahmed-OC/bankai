---
name: details-feel-better
description: Use when doing a final feel-polish pass on any web UI and deciding which micro-details (text-wrap, concentric radii, interruptible motion, staggered enters, subtle exits, shadow borders) to apply and how.
source: https://jakub.kr/writing/details-that-make-interfaces-feel-better
category: essay
---

# Details That Make Interfaces Feel Better — the feel checklist

Source: https://jakub.kr/writing/details-that-make-interfaces-feel-better — Jakub Krehel, personal essay on his site (free, interactive demos for every item). Krehel is a design engineer and author of the "Interfaces" design-engineering magazine. No explicit license. He later packaged these tips as an installable agent skill (`npx skills add jakubkrehel/make-interfaces-feel-better`, run `/make-interfaces-feel-better` in a project root).

## What it is / Why it exists

- Thesis, quoted: "Great interfaces rarely come from a single thing. They're usually a collection of small things that compound into a great experience." The essay is his personal checklist of 11 such small things, each with a working demo.
- The list (his exact items, in order): text wrapping, concentric border radius, animating icons contextually, crispy text, tabular numbers, interruptible animations, splitting/staggering entering elements, subtle exit animations, optical alignment, shadows instead of borders, outlines on images.
- Everything is one-file CSS/JS-adjacent: no dependencies required except where he names Motion (React animation library) as his personal preference for springs. This skill ports every mechanism to plain CSS.

## The core ideas

### 1. Text wrapping: `balance` for titles, `pretty` for paragraphs
- `text-wrap: balance` distributes text evenly across lines — ideal for titles and headings.
- `text-wrap: pretty` prevents orphaned words at the end of a paragraph — for body text, not titles.
- His default pairing: `balance` on the title, `pretty` on the description of a card/section.

```css
h1, h2, h3, .card-title { text-wrap: balance; }
p, .card-description { text-wrap: pretty; }
```

### 2. Concentric border radius: outer = inner + padding
- When nesting elements, the outer radius equals the inner radius plus the padding between them. Demo defaults: inner 12px, padding 8px, outer 20px.
- He calls this "one of the more important concepts that make interfaces feel great and it often goes unnoticed", and notes "there's still a surprising number of apps and interfaces that don't do this and instead mismatch border radii."
- Mechanism: never hardcode both radii independently — derive one from the other.

```css
.card { padding: 8px; border-radius: calc(12px + 8px); } /* 20px */
.card-inner { border-radius: 12px; }
/* token form: --radius-outer: calc(var(--radius-inner) + var(--gap)); */
```

### 3. Animate icons contextually
- When an icon appears because of user context (copy button → checkmark on success), animate `opacity`, `scale`, and `blur` on it rather than swapping instantly. Feels "better and more responsive."
- Pure CSS is enough; he personally prefers Motion only because it makes spring animations easy.

```tsx
<button onClick={handleCopy}>{isCopied ? <CheckIcon /> : <CopyIcon />}</button>
```

```css
.icon { animation: icon-in 200ms ease-out; }
@keyframes icon-in {
  from { opacity: 0; transform: scale(0.8); filter: blur(4px); }
}
```

### 4. Make text crispy: antialias on the root
- On macOS, default subpixel antialiasing renders text heavier than intended. `-webkit-font-smoothing: antialiased` switches to grayscale antialiasing — "thinner, crisper light text."
- Apply once on the layout root (`<body class="font-sans antialiased">`) so it covers all text. (His Tailwind class `antialiased` is exactly this one property — plain CSS shown above needs no framework.)

```css
body { -webkit-font-smoothing: antialiased; }
```

### 5. Tabular numbers wherever digits update
- If numbers shift layout when they update (counters, timers, stats), use `font-variant-numeric: tabular-nums` so all digits are equal width.
- Caveat he flags: some fonts, such as Inter, change the look of their numerals when this is enabled — check the visual result, don't apply blindly.

```css
.stat, .price, .timer { font-variant-numeric: tabular-nums; }
```

### 6. Make animations interruptible
- The core distinction: CSS **transitions** interpolate toward the latest state and can be interrupted mid-flight; CSS **keyframe animations** run on a fixed timeline and do not retarget once started.
- "Users often change their intent mid-interaction" — e.g., open a dropdown, then decide to do something else before the animation finishes. If the animation can't reverse from its current point, "it can make the interface feel broken." He points to iOS, where interruptibility is prevalent for exactly this reason.
- His rule of thumb, quoted: "CSS transitions are great for interactions, while keyframe animations are better for staged sequences that run once."
- Practical consequence: hover/press/toggle/open-close = transition (or a spring driving the same property from current value); one-shot reveals = keyframes.

### 7. Split and stagger entering elements
- Enter animations typically combine `opacity`, `blur`, and `translateY`. Animate smaller chunks individually instead of one big block.
- His exact recipe: sections staggered with `100ms` delay between each; a title split into per-word `<span>`s with `80ms` delay between words; description stays one block; buttons animate individually.

```css
@keyframes enter {
  from { transform: translateY(8px); filter: blur(8px); opacity: 0; }
}
.animate-enter {
  animation: enter 800ms cubic-bezier(0.25, 0.46, 0.45, 0.94) both;
  animation-delay: calc(var(--delay, 0ms) * var(--stagger, 0));
}
.animate-enter-individual-title { --delay: 80ms; } /* words inside the title */
```

```html
<div class="animate-enter" style="--stagger: 1">…title…</div>
<div class="animate-enter" style="--stagger: 2">…description…</div>
<div class="animate-enter" style="--stagger: 3">…buttons…</div>
```

- Each section sets `--stagger: 1, 2, 3` (so section N waits `100ms × (N−1)`); per-word spans share the parent's timing with `--delay: 80ms`.

### 8. Make exit animations subtler than enters
- "The exiting elements don't need the same amount of attention as the ones entering." Exits should be softer and less jarring, not a mirror of the enter.
- Option A (full exit): animate `x` between `0` and `calc(-100% - 4px)` — the drawer's full width plus its padding — so it slides completely off screen.
- Option B (subtle exit, his preferred demo): slide only to `x: -70%` and "let `opacity` and `filter` do most of the work": `exit: { opacity: 0, filter: "blur(4px)", x: "-70%" }`.
- Both use the same spring: `{ type: "spring", duration: 0.45, bounce: 0 }` — no bounce on exits.

```css
.drawer { transition: translate 450ms cubic-bezier(0.22, 1, 0.36, 1), opacity 450ms, filter 450ms; }
.drawer[data-open="false"] { translate: -70% 0; opacity: 0; filter: blur(4px); }
```

### 9. Align optically, not geometrically
- Geometric alignment "works great most of the time, but there are instances where it just looks off. When that happens, it is best to align items optically instead."
- Concrete case: a button with text + icon should have slightly less padding on the icon's side.
- Triangular/play icons are the classic offender; many icon packs already optically correct their shapes, but some don't.
- Fixes in his order of preference: adjust `margin`/`padding` on the container depending on layout; for icons, "the best way to fix it is in the `svg` itself, so no additional `margin` or `padding` needs to be added" (nudge the path or add symmetric viewBox padding).

### 10. Use shadows instead of borders
- Prefer a subtle multi-part `box-shadow` over a border: adds depth in light mode, and in dark mode the 1px ring "looks like a border would."
- His exact three-part shadow (light mode):

```css
.border-shadow {
  box-shadow:
    0 0 0 1px rgba(0, 0, 0, 0.06),
    0 1px 2px -1px rgba(0, 0, 0, 0.06),
    0 2px 4px 0 rgba(0, 0, 0, 0.04);
}
@media (prefers-color-scheme: dark) {
  .border-shadow { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.08); }
}
```

- Hover = the same shadow with darker values (light: alphas 0.08/0.08/0.06; dark ring: 0.12), transitioning via `transition-property: box-shadow`.
- Why shadows win: they use transparency, so they "adapt well to any background" — including images and multi-color backgrounds. Solid border colors only work on the backgrounds they were designed for.

### 11. Add an outline to images
- A `1px` outline at 10% opacity — black or white depending on color mode — creates "a sense of depth and a somewhat consistent outline" on images.

```css
img, .image-frame {
  outline: 1px solid rgba(0, 0, 0, 0.1);
  outline-offset: -1px; /* keep the ring inside the image box */
}
.dark img, .dark .image-frame { outline-color: rgba(255, 255, 255, 0.1); }
```

- Scope: "I mostly use this in design systems where other elements also use borders" — it harmonizes images with bordered siblings, not a universal rule.

## When to use / When NOT to use

Use when:
- Final polish pass on any shipped screen — each item is minutes of work and compounds.
- Cards/sections with title + description text (items 1, 7, 10), drawers/menus/popovers (6, 8), stats and counters (5), nested rounded containers (2), macOS-heavy audiences (4), bordered design systems with imagery (11).

Do NOT use when:
- `text-wrap: balance` on long body copy — it is for headings/titles; balancing paragraphs is costly and wrong (use `pretty` there).
- The element is mid-interaction state (hover, open/close, press): keyframe animations there break interruptibility (item 6) — reserve keyframes for one-shot staged sequences.
- Staggering everything on a page the user visits constantly — enter staggers belong on first-impression surfaces (heroes, landing sections), not daily-driver UI where repeated 800ms entrances read as latency.
- Adding a 1px image outline to a borderless, edge-to-edge photographic layout (item 11 is a design-system harmony move).
- Installing Motion just for items 3/7/8: CSS handles all of them; the library only earns its weight when you want its spring physics across many components (Krehel's own stated reason).

## How to apply

1. Set `body { -webkit-font-smoothing: antialiased; }` once, on the root (item 4).
2. Add `text-wrap: balance` to heading styles and `text-wrap: pretty` to paragraph styles globally (item 1).
3. Make every nested-radius pair concentric: derive the outer radius as `inner + padding` via a token/calc, and audit existing cards for mismatches (item 2).
4. Add `font-variant-numeric: tabular-nums` to every style whose text contains changing digits; verify the font's numerals still look right (item 5).
5. Audit all interactive state changes (hover, toggle, open/close, icon swaps): they must be transitions or from-current-value springs — never fixed keyframes. Convert any keyframed interaction to a transition (item 6).
6. On first-impression entrances, split the block into title/description/buttons (or per-word spans), each with `animation: enter 800ms cubic-bezier(0.25, 0.46, 0.45, 0.94) both`, sections staggered 100ms, words 80ms (item 7).
7. Make every exit shorter/softer than its enter: cap slide at `-70%` with `opacity: 0` + `blur(4px)` carrying the read, spring duration 0.45, bounce 0 (item 8).
8. Replace decorative 1px borders with the three-part `box-shadow` stack (light alphas 0.06/0.06/0.04, dark ring 0.08, hover 0.08/0.08/0.06 and 0.12), transitioned on `box-shadow` (item 10).
9. Give images in bordered contexts a `1px` 10%-opacity mode-aware outline with `outline-offset: -1px` (item 11).
10. Nudge misaligned icon+text pairs optically — less padding on the icon side; fix persistent offenders inside the SVG itself (item 9).
11. Contextual icon changes (copy→check, play→pause) get a 150–250ms opacity+scale+blur entrance on the incoming icon (item 3).

## AI-slop warning

- The classic AI failure is spraying all 11 details uniformly: `animation: balance/pretty` on everything, staggered entrances on every mount of every page (turning an app into a slideshow), blur filters on dozens of nodes simultaneously (rendering cost, muddy text), and 1px outlines on every image regardless of context.
- `text-wrap: balance` on paragraphs and `pretty` on one-line labels is a common inversion — balance is for multi-line headings only.
- AI writes dropdown/menu open-close as `@keyframes` (fixed, non-retargetable), which is precisely the "feels broken" case the essay exists to prevent — interactions must be transitions.
- `-webkit-font-smoothing` is a macOS-rendering tweak; it is a no-op elsewhere and does not excuse choosing fonts that only look good smoothed. Apply it and move on; never "compensate" with lighter font weights globally.
- Copying his exact numbers (`-70%`, `0.45s spring`, `8px` blur, `0.06` alphas) verbatim into a design system with different scale/motion tokens produces mismatched chrome — treat them as defaults to scale from, not constants.
- Regurgitating the Tailwind spellings (`antialiased`, `tabular-nums`) when the project uses plain CSS: the essay's mechanisms are single CSS properties; emit the properties.

## Relations

- **interfaces-dev** — the author's own magazine; this essay is one chapter of that wider program (animation, typography, performance, accessibility). Go there for the depth behind items 6–8.
- **jakub-kr** — portfolio skill for the same author; shows these 11 details applied in his real shipped work, including his typography and radius taste.
- **invisible-details** — Rauno's overlapping canon (state transitions respond to input, restraint on frequent surfaces); it *constraints* this essay — it tells you when to skip the staggered enter entirely, which Krehel does not.
- **corner-radii** — dedicates a full treatment to concentric radii (item 2), including multi-level nesting; use it when two levels aren't enough.
- **animations-dev** — the implementation counterpart to items 3, 6, 7, 8: spring configs, interruption mechanics, and enter/exit choreography beyond the single recipe here.
