---
name: micro-craft
description: Use during the polish pass (master §5 step 7) and before every delivery — the mechanical last-5% rules with exact formulas (optical corrections, state-layer math, dark-mode elevation, fluid type, focus/pressed/disabled finishing, ambient polish) that separate 9.5/10 from 8.5/10.
source: synthesized from Refactoring UI, Material Design 2/3, NN/g, WCAG 2.2, MDN, Chrome for Developers, LukeW; see per-rule attributions
category: principle
---

# Micro-Craft — the last 5%, as formulas

Source: Refactoring UI, Material Design, NN/g, WCAG, MDN/web.dev. These are constraints, not choices: the polish IS the constraint system (fixed scales, formula-driven states, tiered values). Run this pass after composition and interaction are done — it is cheap and mechanical, and its absence is what users feel as "something is off" without naming it.

## 1. Optical corrections (the eye vs the bounding box)

- Nudge icons off geometric center: triangular/heavy-side shapes need +1-2px toward visual mass; math-centering *looks* misaligned.
- Uppercase gets `letter-spacing: 0.05em-0.1em`; display headings get `-0.01em` to `-0.02em` (inter-letter gaps grow with size).
- Line-height inverse to size: body ~1.5, display ~1.1-1.2.
- Same border reads weaker on dark: `rgba(255,255,255,.1)` borders on dark vs `rgba(0,0,0,.1)` on light — equal physical weight disappears.
- Radius scales with element: 6px inputs → 8px cards → 12px+ modals; one flat radius reads unfinished.
- `font-variant-numeric: tabular-nums` on ALL data (timers, prices, tables, counters) — digits must not wobble.

## 2. Color & elevation craft

- Tint shadows with the brand hue, never pure black (`rgba(brand, .15)` at low blur) — gray shadows clash next to colored elements.
- Dark mode: base `#121212`-class (never #000); elevation via white overlays 5%/8%/11%/14%/16% per level (Material) — shadows are near-invisible on dark.
- State layers as math, not new colors — overlay the content's own color: hover 8%, focus 10%, pressed 10-12%, dragged 16% (M3). One formula, infinite consistent states.
- Border tiers at 8-12% contrast steps (`.06 / .10 / .15` alpha): layout divider / input border / strong separator. Never two arbitrary grays.
- Accent ≤10% of surface: hierarchy must survive in grayscale (weight/size/spacing) before the accent lands.
- Design token order: derive `--hover`/`--active` from the base color by formula (e.g. OKLCH L∓0.03-0.05), not by eyeballing new hexes.

## 3. Typography finishing

- Fluid type: `clamp(min, intercept + slope·vw, max)` — slope = `(max−min)/(maxVW−minVW)×100`; bounds: body min 16px, max ~1.25-1.5× min.
- `text-wrap: balance` on headings; `text-wrap: pretty` on paragraphs (kills orphans). One line each.
- `hanging-punctuation: first` on blockquotes.
- Underlines: `text-decoration-thickness: from-font` (or ~0.08em); `text-underline-offset: 0.2em-0.3em` so descenders clear.
- Real characters: — – ' ' " " … ; hyphens never on centered/headline text; `hyphens: auto` only on justified narrow columns.

## 4. Interaction finishing

- `:focus-visible` only; ring 2px with **2px offset** — the gap keeps the ring legible on any fill.
- Pressed = `transform: scale(0.97)`, never brightness flicker.
- Disclosure hover-intent 300-500ms + WCAG 1.4.13 trio: dismissible (Esc), hoverable, persistent.
- Targets: 24px absolute floor (WCAG 2.5.8), 44px best practice; pad small icon buttons with transparent hit area.
- Disabled: reduced contrast + `cursor: not-allowed` + `aria-disabled` (focusable-but-inert stays discoverable). DOM order = visual order; never positive `tabindex`.
- Cursors as affordance: `pointer` on actions, `text` on selectable copy, `grab`/`grabbing` on draggables.

## 5. States & feedback micro-details

- Empty state = what's missing + why + ONE primary action, light illustration, no apology.
- Errors near the field, human tone, no blame, state how to fix ("That email looks incomplete — check for typos").
- Loading by duration: <100ms no indicator (optimistic update); skeleton for layout-shaped content — **skeleton shape must match final layout** or the reveal feels like bait-and-switch; spinner only 1-3s indeterminate; progress bar when duration is knowable.
- Success confirms WITH consequence summary ("Invoice #42 sent to ana@…"), not a bare checkmark.

## 6. Chrome & ambient polish

- `::selection` in brand color, text keeps ≥4.5:1 on the highlight.
- `scrollbar-width: thin; scrollbar-color: var(--border) transparent; scrollbar-gutter: stable` — skip full webkit redesigns.
- `<meta name="theme-color">` per color-scheme + SVG favicon with embedded `prefers-color-scheme` (adapts to dark tabs).
- `accent-color: var(--brand)` — one line tints checkboxes/radios/ranges natively.
- `@media print`: hide nav/buttons, white bg, expand collapsed content.
- Optionally honor `prefers-contrast: more` (bump border/text tiers) — cheap and rare enough to be a tell of care.

## 7. The feel details

- `transition-property: opacity, transform` — NEVER `all` (ghost transitions, layout thrash).
- Duration tiers: 100-150ms feedback / 200-300ms state changes / 400ms+ large movement only.
- Easing per property: ease-out entrances, ease-in exits, `cubic-bezier(0.4,0,0.2,1)` between on-screen points, linear only for spinners/progress.
- Cap decorative motion: parallax a few px of travel; magnetic buttons ≤4-8px offset — beyond reads as lag, not polish.

## How to apply (the 15-minute pass)

1. Grayscale test: hierarchy survives without the accent? 
2. Run sections 1→7 as a literal checklist against the built file; fix each miss (each is minutes).
3. Verify the state-layer formula produced hover/focus/pressed/disabled for every interactive element.
4. Zoom to 200% and shrink to 320px — fluid type and targets hold?
5. Take one screenshot; ask "what looks slightly off?" — it is almost always section 1 or 2.

## AI-slop warning

Micro-craft inverted: arbitrary durations (240ms, 170ms) instead of tiers; pure-black shadows; wobble in changing numbers; brightness-hover; `transition: all`; default blue selection; skeletons shaped like nothing. These are machine-detectable tells — a reviewer greps for them.

## Relations

`krehel-skills` and `web-interface-guidelines` (the rule systems this consolidates with exact formulas), `details-feel-better` (the per-element feel list), `devouring-details` (prototype-level depth), `impeccable` (bounded verification of this pass), `bankai` (§5 step 7 and §8 gate).
