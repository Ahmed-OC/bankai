---
name: oklch
description: Use when building or fixing a UI color system — tonal ramps, semantic tokens, dark mode, contrast, or P3 gamut. Encodes the OKLCH perceptual-color method from oklch.fyi with concrete CSS recipes.
source: https://oklch.fyi/; https://github.com/jakubkrehel/oklch-skill; https://evilmartians.com/chronicles/oklch-in-css-why-we-quit-rgb-and-hsl
category: principle
---

# OKLCH — perceptual color spaces for interfaces that hold up

Source: https://oklch.fyi/ — interactive OKLCH guide, converter, palette browser (incl. Radix scales converted to OKLCH) by Jakub Krehel. The site ships its own agent skill at https://github.com/jakubkrehel/oklch-skill (MIT). Companion deep-dive: "OKLCH in CSS: why we quit RGB and HSL" by Andrey Sitnik & Roman Shamin, Evil Martians. OKLCH is the cylindrical form of Björn Ottosson's OKLab.

## What it is / Why it exists

`oklch(L C H / a)` is a CSS Color 4 function (Baseline 2023, ~96% browser coverage) in a perceptually uniform space: equal numeric steps look like equal steps to the eye. Every classic color-system failure traces back to spaces that don't match human vision:

- **Hex/RGB**: three magic numbers encoding machine signals; unreadable, uneditable by hand, cannot express P3 wide-gamut colors at all.
- **HSL**: `lightness: 50%` is not one lightness. `hsl(60 100% 50%)` (yellow) and `hsl(240 100% 50%)` (blue) share an L but differ wildly in perceived brightness — a palette of equal-L HSL buttons looks uneven, "some pop more and some less." Lightening a blue drifts ~18° toward purple (`hsl(240 80% 20%)` → OKLCH H≈269; `hsl(240 80% 90%)` → H≈285). The space is deformed: every hue gets the same 0–100% saturation range even though real displays max out differently per hue.
- **LCH**: hue-shift bug in blues between H 270–330 — changing only lightness or chroma turns blue into purple: `lch(0.35 110 300)` blue, `lch(0.35 40 300)` very purple. OKLCH fixed this: `oklch(0.48 0.27 274)`, `oklch(0.48 0.185 274)`, `oklch(0.48 0.1 274)` all stay blue.

The payoff: palettes become arithmetic. Fix lightness, vary hue → colors that match. Fix hue and chroma, vary lightness → shades that never drift. Contrast becomes a single-channel (L) problem.

## The core ideas

### 1. The three axes

| Channel | Range | Meaning |
| --- | --- | --- |
| L — lightness | 0–1 (0 = black, 1 = white) | Perceptual. `oklch(0.5 0 0)` is visual mid-gray. Use floats (`0.87`), not `%` — percent breaks `calc()` and relative colors. |
| C — chroma | 0 → < 0.37 always (sRGB and P3) | Colorfulness. 0 = gray. Max depends on L and H (see §6). |
| H — hue | 0–360° | Stable: constant at every L and C. |

Hue anchors (Evil Martians mnemonic, ~50° per Roy G. Biv letter): red 20, yellow 90, green 140, blue 220, purple 320. In shipped palettes: red-500 ≈ H 25, green-500 ≈ 145, blue-500 ≈ 250–260 (Tailwind blue-500 = 259.815). Alpha uses slash syntax: `oklch(0.8 0.05 200 / 0.5)` — never commas. Format L and C to 3 decimals, drop trailing zeros; any hue at L = 1 renders white.

### 2. Recipe: tonal ramp (the core mechanic)

To generate predictable shades of a base color, hold hue constant and vary only lightness. Standard scale: 50 (lightest) → 950 (darkest); 9 steps is the default (50, 100, 200, 300, 500, 700, 800, 900, 950).

1. `delta = 0.4`; `minL = max(0.05, baseL - 0.4)`; `maxL = min(0.95, baseL + 0.4)` — clamp to [0.05, 0.95] because pure black/white have zero chroma.
2. Distribute L evenly from maxL (step 50) down to minL (step 950).
3. Per step: `C = (chromaPercentage / 100) × findMaxChroma(stepL, H, sRGB)`. Chosen via binary search on `color()` conversion, or read off the oklch.fyi gamut visualizer.

The lightest and darkest steps get less chroma — that is correct, not a bug; it keeps every step in gamut and mirrors how real inks/pigments behave.

```css
:root { /* blue, H 250, chroma as % of per-step max */
  --color-50:  oklch(0.971 0.012 250);
  --color-100: oklch(0.932 0.028 250);
  --color-300: oklch(0.812 0.078 250);
  --color-500: oklch(0.623 0.188 250);
  --color-700: oklch(0.445 0.138 250);
  --color-900: oklch(0.289 0.078 250);
  --color-950: oklch(0.215 0.048 250);
}
```

### 3. Recipe: multi-hue palettes that look even

Same L for every hue → equal perceived brightness. Same chroma *percentage of each hue's max*, not same absolute C → equal vividness. Different hues have different max chroma at the same L; a shared absolute C makes some colors neon and others dull.

```css
:root { /* all L 0.623, all 80% of that hue's max chroma */
  --blue-500:  oklch(0.623 0.141 250); /* 80% of max 0.176 */
  --green-500: oklch(0.623 0.157 145); /* 80% of max 0.196 */
  --red-500:   oklch(0.623 0.202 25);  /* 80% of max 0.253 */
}
```

### 4. Recipe: semantic tokens and dark mode

Components reference semantic custom properties only. Themes swap values in one place — zero `@media (prefers-color-scheme)` inside component CSS. Dark mode = reverse the ramp mapping (lightest step ↔ darkest step) and/or re-emit surfaces with lower L at the same hue; perceptual uniformity makes the reversed steps equally readable. Evilmartians-style surface set:

```css
:root {
  --surface-0: oklch(0.96 0.005 300);
  --surface-1: oklch(1 0 0);
  --surface-2: oklch(0.99 0 0 / 85%);
  --text-primary: oklch(0 0 0);
  --text-secondary: oklch(0.54 0 0);
  --accent: oklch(0.57 0.18 286);
  --danger: oklch(0.59 0.23 7);
}
@media (prefers-color-scheme: dark) {
  :root {
    --surface-0: oklch(0 0 0);
    --surface-1: oklch(0.29 0.01 300); /* same hue, re-tuned L */
    --surface-2: oklch(0.29 0 0 / 85%);
    --text-primary: oklch(1 0 0);
  }
}
```

Or purely by remapping ramp slots (no new values):

```css
:root      { --color-bg: var(--color-50);  --color-text: var(--color-950); }
.dark      { --color-bg: var(--color-950); --color-text: var(--color-50); }
```

### 5. Recipe: contrast

Contrast is controlled by L alone — chroma's effect is negligible. Failing pair? Move L apart, keep C and H. Verify with APCA (perceptual, pairs naturally with OKLCH); use WCAG 2 only for formal conformance claims.

| Check | Threshold |
| --- | --- |
| APCA normal text | \|Lc\| ≥ 60 pass, ≥ 75 pass+ |
| APCA large text | \|Lc\| ≥ 45 pass, ≥ 60 pass+ |
| APCA UI components | \|Lc\| ≥ 30 |
| WCAG 2 AA / AAA normal text | 4.5:1 / 7:1 |
| WCAG 2 AA large text & UI graphics | 3:1 |
| Light bg (L > 0.85) | fg L < 0.45 |
| Dark bg (L < 0.25) | fg L > 0.75 |
| Is this bg light? | L > 0.6 → dark text; else light text |

Two hard rules from the Evil Martians article: any background with L ≥ 87% contrasts reliably with black text (no `color-contrast()` needed — set `oklch(from var(--user-input) 0.87 0.06 h)` and `color: black`); a 20% lightness gap is NOT sufficient for text. Hue-drift audit: convert each ramp step to OKLCH, compare H values — spread > 10° across steps means visible drift; rebuild the ramp with constant H.

### 6. Recipe: gamut, chroma clipping, P3

sRGB renders only ~35% of human-visible colors; P3 screens (all modern Apple, many OLED) add ~30% more. Not every L/C/H is displayable: `oklch(0.7 0.4 40)` is valid math but exceeds every real gamut — browsers clip or map it, and the result looks nothing like intent. The gamut boundary is irregular; in sRGB at L 0.5: purple (H ≈ 285) maxes near C 0.29, red-orange (H 0–30) near 0.20, cyan (H ≈ 195) near 0.09 — always the lowest. The peak hue shifts with L (magenta at L 0.7, green at L 0.9).

Fix for out-of-gamut: reduce C, keep L and H (`oklch(0.7 0.35 150)` → `oklch(0.7 0.22 150)`). CSS Color 4 mandates OKLCH-based gamut mapping, but Chrome/Safari currently clip — so do it manually and ship the P3 boost behind a query (raise chroma only):

```css
.accent { color: oklch(0.7 0.2 145); }        /* sRGB base */
@media (color-gamut: p3) {
  .accent { color: oklch(0.7 0.29 145); }     /* more chroma, same L/H */
}
```

Full fallback stack for legacy browsers (in-gamut OKLCH renders identically to its hex — the fallback is compatibility, not a visual downgrade):

```css
.accent { color: #6bbf6e; }                    /* hex first */
@supports (color: oklch(0 0 0)) {
  .accent { color: oklch(0.7 0.2 145); }
  @media (color-gamut: p3) {
    .accent { color: oklch(0.7 0.29 145); }
  }
}
```

Grays are identical in sRGB and P3 — never wrap them. Enforce with a stylelint rule banning hex/rgb()/hsl() and requiring P3 colors inside `@media (color-gamut: p3)`.

### 7. Gradients

RGB interpolation produces muddy midpoints and uneven brightness. OKLCH interpolation fixes evenness — but H is circular, so a gradient between distant hues "can take unexpected detours" through colors you never picked. For gradients, prefer `oklab` (straight-line interpolation): `linear-gradient(in oklab, oklch(0.9 0.1 100), oklch(0.3 0.15 280))`. Convert the stops, never the interpolation function.

### 8. Relative color syntax for variants

`oklch(from <origin> L C H)` — keep a channel by writing its letter, change it with a value or `calc()` using `l`/`c`/`h`. No `%` inside these calcs; use floats.

```css
:root { --error: oklch(0.6 0.16 30); }
.message.is-error   { background: oklch(from var(--error) l c h / 60%); }      /* alpha only */
.message.is-error   { border-color: oklch(from var(--error) calc(l - 0.1) c h); }
.button:hover       { background: oklch(from var(--button-color) calc(l + 0.1) c h); }
.button             { --button-color: var(--accent); }
.button.is-secondary{ --button-color: var(--dimmed); }
.button.is-error    { --button-color: var(--error); }
```

One hover rule for every variant; success = error hue-swapped: `oklch(from var(--error) l c 140)`.

### 9. Converting an existing codebase

Convert values only — don't restructure CSS or touch interpolation functions. Replace hex (3/6/8-digit), `rgb()/rgba()`, `hsl()/hsla()` with `oklch()` equivalents (`#3b82f6` → `oklch(0.623 0.188 259.815)`); alpha → slash syntax; omit alpha when 1. Leave alone: `currentColor`, `inherit`, `initial`, `unset`, `transparent`, and third-party configs that expect hex. Tailwind v4 note: its default palette is already defined in OKLCH; custom `@theme` scales are plain custom properties in disguise — the same values in `:root` give you the system without the dependency.

## When to use / When NOT to use

Use when: building a palette or ramp from a brand color; fixing "colors look uneven across hues"; generating dark mode from light mode; ensuring contrast programmatically; targeting P3 displays; auditing an HSL palette for drift.

Skip or defer when: the target environment predates CSS Color 4 and no `@supports` fallback layer is acceptable; a third-party system demands hex input; the surface is pure grayscale (grays are gamut-identical, C = 0 — OKLCH buys nothing); converting a frozen legacy file with no palette changes planned (churn without benefit — in-gamut OKLCH is pixel-identical to its hex).

## How to apply

1. Pick the base color; read its `L C H` (converter at oklch.fyi, or compute). Remember C < 0.37 in practice.
2. Build the ramp: clamp L to [baseL − 0.4, baseL + 0.4] within [0.05, 0.95]; 9 steps 50→950; distribute L evenly; per step set C = chroma% × maxChroma(stepL, H, sRGB); H constant everywhere.
3. For each additional hue: reuse the same L values and the same chroma percentage — never the same absolute C.
4. Wrap ramp steps in semantic tokens (`--surface-*`, `--text-*`, `--accent`, `--danger`) at `:root`; components consume only semantics.
5. Derive dark mode by reversing the slot mapping or re-emitting surfaces at same-H lower-L; keep all `prefers-color-scheme` logic in token definitions.
6. Check contrast with APCA (Lc 60/45/30 targets); fix failures by moving L only, ≥ 0.3 apart for text pairs; verify bg L > 0.6 ⇔ dark text.
7. Clamp any C above the hue/L maximum before shipping; add `@media (color-gamut: p3)` boosts (chroma-only) for accents that deserve it.
8. Emit fallbacks where legacy matters: hex → `@supports (color: oklch(0 0 0))` → nested P3 query.
9. Derive hover/disabled/ghost variants via relative color syntax on the token, not new literals.
10. Audit HSL heritage: convert every ramp step to OKLCH; H spread > 10° → rebuild with constant H.

## AI-slop warning

How AI typically misapplies this principle: it "generates a palette" by nudging hex values ±10%, reproducing HSL hue drift and uneven lightness in new notation. It uses one absolute chroma across hues (neon cyan, dull red). It writes physically undisplayable colors like `oklch(0.7 0.4 40)` and never clamps — the browser clips and the result looks unrelated to the spec. It maxes chroma everywhere (C > 0.15 on large surfaces reads as toxic neon; accents rarely need more). It fixes contrast by gray-washing (dropping C) or trial-and-error across all channels instead of moving L apart. It "upgrades" to P3 chroma without the `@media (color-gamut: p3)` wrapper, or ships oklch with no `@supports` fallback into legacy targets. It also over-refactors: rewriting gradient functions and keywords (`transparent`, `currentColor`) it was told to leave alone. Slop tell: any color system where L values don't form an even arithmetic sequence, or where hue isn't constant within a ramp.

## Relations

- **tokens-generator** — generates token-scale scaffolding mechanically; feed it this skill's L-distribution and chroma-percentage math so generated scales are perceptually even, not just numerically even.
- **ds-checklist** — system-level audits; add this skill's hue-drift check (> 10° spread) and APCA thresholds (Lc 60/45/30) as line items.
- **aicss** — conventions for AI-authored CSS; pair its rules with the oklch-only color lint (ban hex/rgb/hsl in new code, P3 only inside the gamut query) defined here.
- **beautiful-ui** — visual-polish heuristics; its color-harmony advice should be executed as same-L / same-C% relationships in OKLCH rather than eyeballed hex picks.
