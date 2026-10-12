---
name: corner-radii
description: Use when setting border-radius on cards, buttons, nested surfaces, or defining radius tokens. Encodes the concentric rule — inner radius = max(0, outer − padding).
source: https://corner-radii.xyz/
category: tool
---

# Corner Radii — radius systems that optically align

Source: https://corner-radii.xyz/ — Sam Limby (product designer, https://www.samlimby.com). A single-purpose interactive calculator: "A tool to calculate perfect nested border radius." Updated Sep 2026. No license stated; site is a closed Vite SPA, mechanics extracted from its bundle and verified.

## What it is / Why it exists

A one-screen tool: a card-in-card preview with redline measurements (outer R, inner R, gap, width/height), four sliders — Outer (0–48, step 4), Inner (0–48, step 4), Padding (0–100, step 1), Size (160–360), defaults `outer 40 / inner 20 / padding 20` — and a "Calculation" disclosure that prints the formula. It exists because the most common corner bug in generated UI is invisible at the token level: parent and child each get "the" radius, and the nested arcs silently disagree. The tool makes one rule impossible to ignore: **you do not choose the inner radius — you derive it.**

## The core ideas

### 1. The concentric formula (the whole tool)

```
inner radius = max(0, outer radius − padding between the two arcs)
```

The tool's exact output, copy-pasteable CSS: `max(0px, calc(40px - 20px))`. Two arcs look continuous only when they are concentric (share a center). Two boxes with the *same* pixel radius are geometrically equal but optically wrong: the inner arc is not offset inward, so the gap between the curves pinches at the corners. Subtracting the padding shifts the inner arc's center onto the outer arc's center — that is the optical correction. This is math, not style; it holds for every radius value.

### 2. Radius is a derived value, never an independent token

The tool's own state logic is the lesson: dragging Outer or Padding recomputes Inner; dragging Inner back-solves `padding = outer − inner`; Inner can never exceed Outer. Do the same in CSS — tokenize the *outer* radius and the *padding*, compute the child:

```css
.card {
  --radius: 20px;
  --padding: 20px;
  border-radius: var(--radius);
  padding: var(--padding);
}
.card__inner {
  border-radius: max(0px, calc(var(--radius) - var(--padding)));
}
```

Consequence: when padding changes at a breakpoint, the inner radius stays aligned automatically. A hardcoded `border-radius: 12px` on the child is a latent misalignment.

### 3. The zero floor: know when to go square

When `padding >= outer radius`, the formula clamps to 0 — the tool prints: "Padding exceeds the outer radius, so the inner corner is square." A corner too small to hold the curve gets no curve. Nested three levels deep with modest padding, square inner corners are correct, not a failure. Never force rounding into a corner that cannot fit it.

### 4. Subtract everything between the arcs

Padding is just the common case. The general rule: inner radius = outer radius − (sum of distances between the two rounded edges). For a bordered parent with border width `b` and gap `g`: `inner = R − b − g` — the arc starts at the inner edge of the border, not the outer.

### 5. The 4px scale (from the tool's slider stops)

The tool's radius stops are `[4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44]` — a strict 4px grid. Encode a scale, not free values:

```css
:root {
  --r-0: 0px;   /* tables, code, data-dense */
  --r-xs: 4px;  /* inline badges, dense chips */
  --r-sm: 8px;  /* buttons, inputs */
  --r-md: 12px; /* small cards, dropdowns */
  --r-lg: 16px; /* cards */
  --r-xl: 24px; /* modals, hero panels */
  --r-2xl: 32px;/* large sheets, media */
  --r-full: 9999px; /* pills, avatars */
}
```

Rule of use: at most 3 radius steps visible on one screen plus `--r-full`. A fourth distinct value is drift, delete it.

### 6. Per-context defaults (calibration layer — the tool is context-agnostic)

- Buttons/inputs/selects (h 32–40px): `--r-sm` (8px). Fixed-height controls keep one radius across all sizes in the set.
- Tags/chips/avatars/status pills: `--r-full` (pill = radius ≥ half the height; `9999px` achieves it).
- Cards and list containers: `--r-lg` (16px). Modals/sheets: `--r-xl`–`--r-2xl` (24–32px).
- Media flush inside a card: derived — `card radius − card padding` via the formula, with `overflow: hidden` (or `border-radius: inherit`) on the media wrapper; a bare `<img>` will square-clip the card's corners.
- Media occupying one edge of a card: round only the outer corners — `border-radius: var(--r-lg) var(--r-lg) 0 0` for a top banner; the flush edge gets 0.
- Tables, code blocks, terminals, inline data: `--r-0`. Rounding dense text grids reads as decoration and costs edge scanning.
- Content near a curve: keep text/padding ≥ the inner radius so content clears the arc; if it can't, reduce the radius, not the padding.

Quick lookup (outer × padding → inner), all clamped at 0:

| outer | padding | inner |
|------:|--------:|------:|
| 8     | 12      | 0 (square) |
| 12    | 8       | 4  |
| 16    | 12      | 4  |
| 16    | 4       | 12 |
| 20    | 20      | 0 (square) |
| 24    | 16      | 8  |
| 24    | 8       | 16 |
| 32    | 16      | 16 |
| 32    | 8       | 24 |

Read it as: the deeper the nesting (more padding per level), the flatter the inner corners get. Three levels: `32/16 → 16`, then `16/12 → 4`, then square — that decay is correct and universal; fight it only by increasing the outer radius, never by inflating inner values past the formula.

### 7. Per-corner and flush-edge radii

`border-radius` takes four values; most flush attachments need only some corners rounded. Connected button/segment groups: round the outer corners of the group ends, 0 on the shared vertical edges (`8px 0 0 8px` + `0 8px 8px 0`). Toast attached to a screen edge: round only the corners facing content. Chat/message bubbles: full pill on the user side, flat (or 4px) on the tail side toward the avatar. Card media at top: `var(--r-lg) var(--r-lg) 0 0`; footer at bottom: `0 0 var(--r-lg) var(--r-lg)`. Rule: a corner that touches a flush edge gets 0 — the container owns the rounding.

### 8. Sharp vs rounded (when radius 0 is the answer)

### 7. Sharp vs rounded (when radius 0 is the answer)

Zero radius is a decision, not an absence: technical/developer surfaces (terminals, code, log tables), editorial and typography-led layouts, dense data grids, and brands built on hard geometry. Mixed language — sharp tables inside rounded cards — is fine; the container rounds, the content stays sharp.

### 9. Squircles / smooth corners (superellipse) — progressive enhancement only

`border-radius` always draws circular arcs; a squircle (superellipse ≈ n 4–5) bulges fuller toward the corner and matches hardware/OS icon shapes. CSS now has it natively:

```css
.card {
  border-radius: 24px;              /* size of the corner — required */
}
@supports (corner-shape: squircle) {
  .card { corner-shape: squircle; } /* curvature of the corner */
}
```

Facts that change decisions: `corner-shape` (values `squircle`, `bevel`, `scoop`, `superellipse(n)`) is Chromium 139+ only (as of late 2026) — no Firefox/Safari; it does nothing without `border-radius > 0`; `border-radius` sets the corner's size, `corner-shape` sets its curvature. Never ship a JS squircle polyfill or per-element SVG clip for static corners — plain circular rounding is the baseline and looks correct; reserve SVG smooth-corner paths for icon-scale assets where the difference is legible. The concentric formula (idea 1) applies unchanged to superellipse corners: same subtraction, same zero floor.

## When to use / When NOT to use

Use when: building radius tokens; styling any card > section > content nesting; putting images, headers, or footers flush inside a rounded container; a design review flags that nested corners "look off" (they are — fix with the formula, not by eyeballing); deciding pills vs rounded rectangles.

Not needed when: the surface is deliberately sharp (idea 7); shapes are true circles/avatars (`--r-full`); you need a one-off value — compute `max(0px, calc(R − p))` inline and move on. The interactive tool itself beats manual work only for exploring/teaching the effect; production output is one `calc()` line, not a tool visit.

## How to apply

1. Define the radius scale (idea 5) as tokens; forbid raw pixel radii in components.
2. Assign per-context defaults (idea 6); every component reads a token, none invents a value.
3. For every nested pair, apply `inner = max(0, outer − padding)` via CSS vars (idea 2). Audit every parent-child border-radius pair in the layout — each is either derived or wrong.
4. Add border-width to what you subtract when the parent has a visible border (idea 4).
5. Clamp flat: padding ≥ outer radius ⇒ inner corner is 0 (idea 3).
6. Wrap flush media with `overflow: hidden` + derived (or edge-only) radius; never let a square image clip a rounded card.
7. Pills: `9999px` on fixed-height controls only; never on multi-line content.
8. Optional: layer `corner-shape: squircle` behind `@supports`; no polyfills, no gating.
9. Verify like the tool's Redlines mode: overlay the two radii, the gap, and check the arcs share a center at 100% zoom.

Worked example — card (r 24, padding 16) containing a header strip and a media block:

```css
.card    { border-radius: 24px; padding: 16px; }
.card__header { border-radius: max(0px, calc(24px - 16px)); }  /* 8px */
.card__media  { border-radius: 12px 12px 0 0; overflow: hidden; }
/* media sits 8px inside the card edge: 24 - 8 = 16 rounded top,
   flush with the header below: 0 bottom */
```

## AI-slop warning

The canonical AI failure is exactly what this tool fixes: every box gets the same radius regardless of nesting, so cards-in-cards bulge or pinch at corners. Second failure: "radius soup" — 6, 8, 10, 12, 14, 18px all on one screen because each component was styled in isolation; if the screen shows more than 3 steps + pill, collapse to the scale. Third: hardcoding inner radii that silently break when responsive padding changes — derive, don't type. Fourth: `9999px` on rectangles of varying heights produces pills of inconsistent curvature across a set — reserve it for fixed-height controls. Fifth: applying squircle via JS/clip-path hacks or shipping `corner-shape` without the plain-`border-radius` baseline. Sixth: rounding everything because rounded exists — sharp is a legitimate system decision for technical and editorial surfaces.

## Relations

- **tokens-generator** — this skill fixes the *values*; that one covers generating the token file/ramp structure the radius scale lives in.
- **devouring-details** — same craft category as the concentric rule: optical micro-corrections (like optical alignment of icons) that separate adequate from deliberate UI.
- **web-interface-guidelines** — supplies the spacing/sizing grammar (4px base grid) the 4px radius scale assumes; apply together.
- **ds-checklist** — adds the audit step: nested-radius derivation belongs in any design-system review checklist.
- **bankai** — the umbrella canon; this skill is its radius-system leaf: radii as a derived system, never isolated pixels.
