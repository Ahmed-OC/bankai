---
name: desengs-gradient-border
description: Use when an element needs a gradient or animated border ring. Encodes the mask-composite ring recipe plus border-image, double-background, and rotating conic variants in plain CSS, and when a solid border wins.
source: https://gradient-border.floriankiem.com/; https://github.com/flornkm/gradient-border-plugin
category: tool
---

# Gradient Border Plugin (desengs) — gradient borders without the hacks

Source: https://gradient-border.floriankiem.com/ — Florian Kiem (@flornkm), npm `gradient-border-plugin` v1.1.3, MIT. A Tailwind v4 CSS-first plugin (pure `@theme`/`@utility` CSS, no JS config) that adds gradient borders via `mask-composite`. This skill ports its mechanism to plain CSS; use the plugin only inside a Tailwind v4 codebase.

## What it is / Why it exists

CSS has no `border-color: linear-gradient(...)`. The two "obvious" answers are broken: `border-image` takes a gradient but ignores `border-radius` (square-cut corners), and the double-`background-clip` trick forces the element's interior to be an opaque solid layer. The plugin encodes the third way — paint the gradient on an overlay the size of the element, then punch out the middle with a mask — so the border is decoupled from the element's background, respects any `border-radius`, and scales to any width via `padding`. Its class API mirrors Tailwind's own gradient utilities (`gradient-border-from-*`/`-via-*`/`-to-*`, `-to-r`…, alpha modifiers `/50`), with widths 1–4px and an `animate-gradient-border` variant.

Taste signal in the defaults: the plugin's zero-config gradient is `rgba(0,0,0,0.15) → transparent, to bottom` — a barely-there hairline, not a rainbow. Loud gradients are opt-in. Copy that inversion: ship subtle, dial up deliberately.

## The core ideas

### 1. The mask-composite ring (the plugin's technique — default choice)

```css
.gb {
  position: relative;
  border-radius: 12px;           /* any radius; ring inherits it */
}
.gb::before {
  content: "";
  position: absolute;
  inset: 0;                      /* covers the element's padding box */
  border-radius: inherit;
  padding: 1px;                  /* ← THE border width (1–4px) */
  background: linear-gradient(to right, oklch(0.62 0.19 265), oklch(0.7 0.17 350));
  -webkit-mask:
    linear-gradient(#fff 0 0) content-box,
    linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;   /* WebKit legacy */
  mask:
    linear-gradient(#fff 0 0) content-box,
    linear-gradient(#fff 0 0);
  mask-composite: exclude;       /* standard: subtract content-box from full box */
  pointer-events: none;
}
```

How it works: two full-opacity mask layers — one clipped to the `content-box` (inside the padding), one covering everything. `mask-composite: exclude` (WebKit: `xor`) subtracts the first from the second, leaving an opaque mask ring exactly `padding` wide; the background gradient shows through that ring only. Per-line rationale:

- `padding` is the width knob — change `1px` to `2px`, nothing else.
- `border-radius: inherit` + padding gives a correctly concentric ring for free: CSS shrinks the inner (content-box) curve by the padding automatically.
- `pointer-events: none` keeps the overlay transparent to clicks.
- Costs: consumes `::before`, and the absolutely-positioned overlay paints above in-flow child content (irrelevant for a 1–2px edge ring, but don't put text flush under it).

### 2. Double background (no pseudo-element; solid interior only)

```css
.gb {
  border: 2px solid transparent;
  border-radius: 12px;
  background:
    linear-gradient(#101014, #101014) padding-box, /* interior fill */
    linear-gradient(to right, oklch(0.62 0.19 265), oklch(0.7 0.17 350)) border-box;
}
```

Fits when the interior is one flat color (or its own gradient you can layer). Breaks when the interior must be transparent or semi-transparent — the gradient bleeds through. Also collides with any `background-image` you wanted. If those constraints bite, use technique 1.

### 3. border-image (square corners only)

```css
.gb {
  border: 2px solid;
  border-image: linear-gradient(to right, oklch(0.62 0.19 265), oklch(0.7 0.17 350)) 1;
}
```

One line, no pseudo-element — but `border-radius` is completely ignored by the paint. Legit only on radius-0 surfaces (tables, dividers, brutalist grids). Never combine with rounded UI.

### 3b. Two-element wrap (fallback when the pseudo is taken)

```html
<div class="gb-wrap"><div class="gb-inner">…</div></div>
```

```css
.gb-wrap {
  border-radius: 12px;
  padding: 1px;                 /* border width */
  background: linear-gradient(to right, oklch(0.62 0.19 265), oklch(0.7 0.17 350));
}
.gb-inner {
  border-radius: 11px;          /* outer radius minus padding */
  background: transparent;      /* anything, even an image */
}
```

The pre-mask classic. Same visual, zero `mask` support requirements — reach for it only when `::before` is already used or you target ancient engines; the inner radius must be hand-synced (`outer − padding`), which drifts the moment one side changes.

### Pick in 10 seconds

| Situation | Technique |
|---|---|
| General case, any radius, any interior | 1 — mask-composite ring |
| Flat opaque interior, pseudo-element unavailable | 2 — double background |
| Square corners, simple stops | 3 — border-image |
| Legacy engines / pseudo already consumed | 3b — two-element wrap |
| Must rotate | 4 — @property angle |

### 4. Animated rotating border (@property-registered angle)

```css
@property --gb-angle {
  syntax: "<angle>";
  initial-value: 0deg;
  inherits: false;
}
.gb::before {
  /* technique 1, but: */
  background: conic-gradient(from var(--gb-angle), oklch(0.62 0.19 265), oklch(0.7 0.17 350), oklch(0.62 0.19 265));
  animation: gb-spin 4s linear infinite;
}
@keyframes gb-spin { to { --gb-angle: 360deg; } }
@media (prefers-reduced-motion: reduce) {
  .gb::before { animation: none; }
}
```

The `@property` registration with `syntax: "<angle>"` is what makes the custom property interpolable — without it the angle snaps at the 50% keyframe instead of rotating. Use `linear` timing (constant angular velocity); ≥4s period (the plugin's default); repeat the first stop last so the conic seam is invisible. The plugin animates the same way but rotates the *linear* gradient's direction (`--gradient-border-angle: var(--gradient-border-rotation)`) — a directional sweep; conic-from-angle is the seamless spin. Cost: the gradient+mask repaints every frame (no GPU compositing) — one hero element, never a grid of cards.

### Plugin knobs worth copying as CSS variables

- `--gradient-border` — full gradient override (`conic-gradient(from 90deg, …)`); skips stop composition.
- `--gradient-border-width` (`1px`), `--gradient-border-angle` (`to bottom`), `--gradient-border-duration` (`4s`).
- Stops: `--gradient-border-from` `rgba(0,0,0,0.15)`, `--gradient-border-to` `transparent`; unset `--gradient-border-via` falls back to the from-color (flat half, then fade) — set it explicitly for a real 3-stop ramp.

### Browser quirks and gotchas

- **Declaration order matters**: the `mask` shorthand *resets* `mask-composite` (likewise `-webkit-mask` → `-webkit-mask-composite`). Composite must come after its shorthand — exactly as in the snippet. Wrong order silently yields `add` (full mask, ring disappears).
- Ship both engines: `-webkit-mask-composite: xor` + `mask-composite: exclude`.
- `transparent` equals `rgba(0,0,0,0)`: interpolating toward it can drag luminance down mid-fade. Fade to the end color at 0 alpha (`oklch(0.7 0.17 350 / 0)`), not the keyword.
- `@property` support floor: Safari 16.4+, Chrome 85+, Firefox 128+. Below it the animation degrades to a two-state blink — gate or accept a static ring.
- `inset: 0` positions against the element's padding box: a real CSS `border` on the same element shifts the ring inward. Put the ring on the element that owns the radius and skip the real border.
- 1px rings on fractional DPRs: keep widths integer px; check rendering at 1x, 2x, and 200% zoom before shipping.

## When to use / When NOT to use

Use a gradient border when one element must outrank its siblings visually and a solid border can't carry it: the featured pricing tier, the active/uploading card, an avatar ring, a hero panel on an otherwise quiet page. Static 1px by default; 2px for emphasis; animate only the single focal element.

Do NOT use when:

- A solid 1px border at ~8–15% foreground alpha would do the same job — it usually would; gradient borders are an attention spend, not a texture. This covers lists, tables, forms, dashboards, dense admin UI, docs.
- Border color carries state or semantics (error/success/focus) — solid tokens win on legibility and 3:1 contrast checks.
- The interior is transparent AND you can't spare a pseudo-element (use the two-element wrap: gradient parent + inset solid child).
- Corners are square and stops are simple — `border-image … 1` is one line (technique 3).
- The surface is large or numerous and animated — repaint cost scales with area and count.
- Installing the npm package is only justified in a Tailwind v4 project: it wires stop colors to your theme palette, alpha modifiers, and width tokens (`--gradient-border-width-5: 5px` via `@theme`). Everywhere else the 10-line plain-CSS ring beats a dependency.

## How to apply

1. Default to `border: 1px solid color-mix(in oklab, fg 12%, transparent)`. Escalate to a gradient ring only for the one element that must win.
2. Choose the technique: transparent/layered interior → mask ring (1); flat opaque interior, pseudo busy → double background (2); radius-0 → border-image (3).
3. Set width via `padding` on the ring: 1px quiet, 2px emphasis, 3–4px only hero/demo art.
4. Pull both stops from existing UI accents (link color, primary button). Keep hue distance ≤ ~90° for a quiet ring; 180°+ only for an intentional brand moment.
5. Fade to same-hue 0-alpha stops; verify the ring reads on both page background and interior (aim ≥3:1 against the lighter one for a semantic border; decorative hairlines may go lower deliberately).
6. Ensure `border-radius: inherit` on the ring and that no real border/outline shifts it; keep widths integer px.
7. If animating: register `@property --gb-angle`, conic with repeated first stop, `linear` timing, ≥4s, `prefers-reduced-motion: reduce → animation: none`. One element per viewport.
8. Ship both `-webkit-mask-composite: xor` and `mask-composite: exclude`, composite after the mask shorthand.
9. Final audit: count gradient borders on the screen. If the answer isn't 1 (max 2), demote extras back to solid.

## AI-slop warning

The animated purple→pink conic ring on every card is the single most recognizable AI-generated-landing-page tell (the 2023–25 "Linear clone" kit: gradient ring + glow + dark dashboard + ✨ headline). It poisons exactly the contexts where hierarchy matters most — pricing pages, feature grids, admin tools — because when everything glows, nothing does. The tell is application, not the technique: the plugin itself defaults to a near-invisible `rgba(0,0,0,0.15)` hairline. Rules: one gradient border per viewport, static by default, brand hues not violet-magenta defaults, animate only on explicit "hero moment" intent. If a reviewer can spot a second one without looking for it, remove it.

## Relations

- **desengs-gradientool** — choose and validate the gradient stops themselves (perceptual interpolation, stop count); this skill only handles drawing a chosen gradient as a border ring.
- **desengs-corner-radii** — the ring inherits the radius scale; concentricity and a radius ≥ 2× the ring width decide whether 1–4px reads clean or clipped.
- **desengs-oklch** — define stops in oklch and fade to 0-alpha same-hue stops to kill the muddy-fringe failure mode of `transparent`.
- **desengs-taste** — the restraint budget that explains why the answer to "gradient border here?" is usually "no"; most emphasis is bought with contrast, not chroma.
- **desengs-transitions** — continuous rotation is the one case for `linear` timing and infinite duration; every state-change animation elsewhere wants ease-out and a stop condition.
