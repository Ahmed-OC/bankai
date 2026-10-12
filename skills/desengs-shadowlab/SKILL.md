---
name: desengs-shadowlab
description: Use when an element needs elevation, depth, or a card/popover/modal shadow. Encodes shadowLab's multi-layer system - 2-3 stacked layers at 4-8% alpha, one overhead light, border-replacing rings.
source: https://shadowlab.mocarski.design/
category: tool
---

# shadowLab (desengs) — elevation and shadow as a system

Source: https://shadowlab.mocarski.design/ — Adam Mocarski (design engineer, London). A free in-browser box-shadow stack editor ("a playground for creating box shadows for web and React Native", per the site's own description). No license stated; values below were extracted verbatim from the tool's presets and exporters.

## What it is / Why it exists

shadowLab is a generator for **stacked** box-shadows. It rejects the one-line `box-shadow: 0 4px 8px rgba(0,0,0,.1)` habit and replaces it with a layer model:

- Each shadow is an array of 2–3+ layers. Even the default state on load ("Subtle strong") is 3 layers — the tool never ships a single-layer shadow.
- Per layer: X offset (−100..100), Y offset (−100..100), blur (0..100), spread (−100..100), opacity (0..100), a hex color, and an inset flag. Alpha = opacity/100 exactly.
- Layers are drag-reorderable; order matters (first layer in the list paints on top).
- Exports: `Plain CSS`, `Tailwind @theme var`, `Tailwind inline`, `React Native` — same stack, four serializations.
- The preview canvas flips across the full neutral range — white, black, and 9 families (slate, gray, zinc, neutral, stone, taupe, mauve, mist, olive) × 11 steps (50–950) — because a shadow tuned on white dies on gray-700.

Why it exists: hand-tuning multi-layer shadows in DevTools is blind iteration. The tool encodes a methodology: consistent light, low alpha, stacked layers, proof against every background you ship.

## The core ideas

### 1. One light source, always overhead

Every preset layer has `offsetX: 0` and `offsetY >= 0`. Light comes from above, everywhere, at every elevation. Never mix x-offsets across layers of one system — two shadows cast in different directions read as a rendering bug, not depth.

### 2. Alpha lives at 4–8%, never 10%+

All preset layers use opacity 4, 5, 6, or 8 (→ alpha .04–.08). Depth comes from **stacking 2–3 cheap layers**, not from one heavy one. Two .06 layers read softer and more physical than one .16 layer.

### 3. The layer recipe: contact + ambient (+ ring)

Each preset combines:
- **Contact layer** — small offset (y 1–4), small blur (2–8): the tight dark edge hugging the element.
- **Ambient layer** — larger offset (y 4–20), larger blur (8–40): the diffuse pool beneath.
- **Ring layer** (optional) — `0px 0px 0px 1px` at alpha .04–.06: a hairline that replaces a border.

### 4. The five presets, exact values (tool's own output)

```css
/* Subtle — resting inputs, list rows, flat cards */
box-shadow: 0px 0px 0px 1px rgba(0,0,0,0.06), 0px 1px 2px -1px rgba(0,0,0,0.06), 0px 2px 4px 0px rgba(0,0,0,0.04);

/* Subtle strong — the tool's default; cards on white */
box-shadow: 0px 0px 4px 0px rgba(0,0,0,0.04), 0px 4px 8px 0px rgba(0,0,0,0.06), 0px 0px 0px 1px rgba(0,0,0,0.05);

/* Card — minimal card shadow */
box-shadow: 0px 0px 0px 1px rgba(0,0,0,0.04), 0px 2px 8px 0px rgba(0,0,0,0.06);

/* Soft lift — hovered/raised card */
box-shadow: 0px 1px 3px 0px rgba(0,0,0,0.08), 0px 4px 12px 0px rgba(0,0,0,0.05);

/* Subtle border — popovers, menus, floating overlays */
box-shadow: 0px 8px 20px -4px rgba(0,0,0,0.08), 0px 20px 40px -10px rgba(0,0,0,0.06);
```

Note "Subtle border" is named literally: for glassy/gradient surfaces where a real border breaks the illusion, elevation **is** the border.

### 5. Negative spread on big blur

`Subtle border` gives its 20px-blur layer spread −4 and its 40px-blur layer spread −10 (≈ −20% to −25% of blur). Rule: once blur ≥ 20, pull spread negative by 20–50% of blur so the halo doesn't spill past the element's silhouette.

### 6. Build an elevation scale by hand (levels 1–5)

Map presets to z-roles, then extend by the observed pattern — each step up roughly **doubles** y and blur while alpha stays in .04–.08:

| Level | Role | Stack (ambient layer) | Recipe |
|---|---|---|---|
| 1 | input, resting row | y 2, blur 4 | `Subtle` verbatim |
| 2 | card default | y 2–4, blur 4–8 | `Card` / `Subtle strong` |
| 3 | card hover, drag ghost | y 4, blur 12 | `Soft lift` |
| 4 | popover, dropdown, tooltip | y 8/20, blur 20/40 | `Subtle border` |
| 5 | modal, dialog, command palette | y ~16/40, blur ~40/80 | extrapolate `Subtle border` one doubling, keep α ≤ .08, spread ≈ −25% of blur |

Levels 1–4 are the tool's presets; level 5 is a derivation from its doubling pattern, not a shipped preset. Generator function (derived from the presets' geometry):

```js
// elevation(level 1..5) -> layer array matching the presets' structure
function elevation(n) {
  const y = [2, 4, 4, 8, 16][n - 1];          // ambient y offset
  const blur = [4, 8, 12, 20, 40][n - 1];      // ambient blur
  const spread = blur >= 20 ? -Math.round(blur / 4) : 0; // -20..-25% of blur
  const a = (v) => `rgba(0,0,0,0.0${v})`;
  return [
    `0px 1px 3px 0px ${a(8)}`,                // contact
    `0px ${y}px ${blur}px ${spread}px ${a(6)}`, // ambient
    ...(n <= 2 ? [`0px 0px 0px 1px ${a(5)}`] : []), // ring only near the surface
  ].join(", ");
}
```

### 6b. Dark-mode variant of the same scale

Black-on-dark is a no-op, so ship a second token set rather than reusing light values (dark threshold per the tool: step ≥ 700):

```css
:root             { --shadow-e2: 0px 0px 4px 0px rgba(0,0,0,0.04), 0px 4px 8px 0px rgba(0,0,0,0.06), 0px 0px 0px 1px rgba(0,0,0,0.05); }
[data-theme=dark] { --shadow-e2: 0px 0px 0px 1px rgba(255,255,255,0.08), 0px 4px 8px 0px rgba(0,0,0,0.4); }
```

On dark surfaces: keep the ring but lighten it (white at .06–.10), and let the drop layer go black at .3–.5 — only the ring is truly legible there; the drop just mass. Elevation on dark themes is mostly surface tone + ring, shadow is garnish.

### 6c. Animating between levels

Transitioning a 3-layer shadow forces repaint of every blur layer per frame. Standard mechanism: put each level's stack on a pseudo-element and crossfade opacity (compositable), while the card itself transitions `transform`:

```css
.card { transition: transform 150ms cubic-bezier(0.22,1,0.36,1); }
.card::after { content: ""; position: absolute; inset: 0; border-radius: inherit;
  box-shadow: var(--shadow-e3); opacity: 0; transition: opacity 150ms ease-out; }
.card:hover { transform: translateY(-1px); }
.card:hover::after { opacity: 1; }
```

### 7. Proof across backgrounds — the dark threshold

The tool's own dark-detection logic: `bg-black` is dark, and any neutral family at step **≥ 700** is dark. So:
- Test every shadow on white, a mid neutral (300–500), a dark neutral (700–950), and black.
- Black shadows are invisible on ≥700 surfaces. On dark UI, either lighten the shadow color, or express elevation with a surface fill + `0 0 0 1px` ring instead of a drop shadow.
- The tinted families (taupe, mauve, mist, olive) exist to catch a second failure: pure black shadows look dirty on warm/cool-tinted grays. On tinted surfaces, tint the shadow toward the background hue at the same low alpha (derived practice; presets ship black). Example on a warm stone surface: `rgba(66,50,36,0.06)` instead of `rgba(0,0,0,0.06)` — same alpha discipline, hue pulled from the background.

### 8. Shadows are data, serialized per platform

The tool stores one layer array and emits four formats from it:

```css
/* token (Tailwind @theme / CSS var) */
--shadow-e4: 0px 8px 20px -4px rgba(0,0,0,0.08), 0px 20px 40px -10px rgba(0,0,0,0.06);
```

```css
/* Tailwind v4 inline (inset layers split into inset-shadow-[...]) */
/* class: shadow-[0px_8px_20px_-4px_rgba(0,0,0,0.08),0px_20px_40px_-10px_rgba(0,0,0,0.06)] */
```

```js
// React Native (0.76+ boxShadow)
boxShadow: [
  { offsetX: 0, offsetY: 8, blurRadius: 20, spreadDistance: -4, color: "rgba(0,0,0,0.08)", inset: false },
  { offsetX: 0, offsetY: 20, blurRadius: 40, spreadDistance: -10, color: "rgba(0,0,0,0.06)", inset: false },
]
```

Define the scale once as tokens (`--shadow-e1` … `--shadow-e5`), never as scattered inline literals.

### 9. When shadows beat borders beat surfaces

- **Shadow** = transient lift: hover, popovers, modals, drag ghosts, anything that floats above the page.
- **Border / 1px ring** = static grouping and edge definition: cards that never move, table dividers, inputs at rest. Cheaper, stable, works in dark mode.
- **Surface fill** = permanent hierarchy: distinct background tones for page vs card vs nested well. If two elements always sit at different levels, a surface tone beats a permanent shadow (constant modal-scale shadows everywhere = noise).

## When to use / When NOT to use

Use when: building or auditing an elevation scale; styling cards, popovers, modals; needing CSS + React Native parity; a design calls for "depth" without specifics.

Skip when: the design system already defines elevation tokens (use them, don't fork); the aesthetic is deliberately flat/brutalist (borders are the point); animating elevation — transition `transform` + `opacity` on a pseudo-element carrying the shadow, not the multi-layer shadow itself (repainting 3 blur layers per frame is expensive).

## How to apply

1. Assign each floating component a level 1–5 from the table above; copy the recipe verbatim, don't freestyle values.
2. Keep `offsetX: 0` in every layer. Light is overhead, system-wide.
3. Compose 2–3 layers: contact (y ≤ 4, blur ≤ 8) + ambient (y and blur 2–4× the contact) + optional 1px ring at .04–.06.
4. Cap every layer at alpha .08. If it looks weak, add a layer or step up a level — never raise alpha past .1.
5. Blur ≥ 20 → set spread to −20%…−50% of blur.
6. Replace decorative card borders with `0 0 0 1px rgba(0,0,0,.04–.06)` when the card also casts a shadow (no double edges, no layout shift).
7. Proof each level on white, a mid neutral, a ≥700 neutral, and black. If it vanishes on dark, switch that theme to surface + ring.
8. Emit tokens (`--shadow-e1..e5`) and, for RN, keep the structured object form.
9. Audit: adjacent levels must be distinguishable at a glance; if E2 and E3 look identical, delete one.

## AI-slop warning

The tell-tale AI shadow is `box-shadow: 0 4px 8px rgba(0,0,0,.1)` — single layer, 10% alpha, no contact layer, no ring, indistinguishable from ten thousand generated sites. Other failure modes: every element gets a modal-scale shadow (elevation inflation); light direction flips between components (x offsets appear); black shadows slapped onto dark themes where they do nothing; one-off shadow literals in every component instead of a 5-step scale. If a shadow's level can't be named (1–5), it shouldn't exist.

## Relations

- **desengs-corner-radii** — radius and shadow interlock: the 1px ring and contact layer must follow the element's radius scale or edges smear.
- **desengs-tokens-generator** — turn the e1–e5 recipes into theme variables with dark-mode variants.
- **desengs-web-interface-guidelines** — broader elevation/z-index doctrine; this skill supplies the exact layer values.
- **desengs-taste** — when shadow "polish" is craft vs. decoration stacked on decoration.
- **desengs-ui-ux-master** — canon index; elevation scale feeds its depth chapter.
