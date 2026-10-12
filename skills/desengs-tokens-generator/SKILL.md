---
name: desengs-tokens-generator
description: Use when starting a project or normalizing an existing one and a complete, well-named token set is needed — brand seed to ramps to semantic slots with dark mode. Distills design.dev's generator.
source: https://design.dev/ai/design-tokens-generator/
category: tool
---

# Design Tokens Generator (desengs) — AI token sets and the structure they follow

Source: https://design.dev/ai/design-tokens-generator/ — free, fully client-side token generator by design.dev ("Nothing leaves your browser"; works offline). Input: a brand seed color plus font/spacing/radius preferences, or a pasted Figma / Tokens Studio / DTCG / flat-JSON / CSS-vars export. Output: `tokens.css`, a Tailwind v4 `@theme`, DTCG `tokens.json`, and an agent-rules file. This skill encodes the structure of the set it produces so you can generate or normalize one by hand, with or without the tool.

## What it is / Why it exists

A generator that turns one brand color into a complete, two-layer token system. It exists because hand-built systems rot: ramp steps go missing, semantic names drift per file, dark mode inverts instead of remapping, and every AI-authored component invents new hex literals. The tool's contract: "Brand colors or a Figma export in. tokens.css, a Tailwind v4 @theme, and tokens.json out." Three hard guarantees worth copying:

- **Completeness** — every slot in the vocabulary gets a value in both modes; no `var(--x, #fallback)` escapes.
- **Two layers** — primitives (scales) never appear in components; semantic tokens (roles) never appear in ramps.
- **Mode-swap in one place** — dark mode "remaps each semantic token to the alternate primitive… derived semantically — not by simply inverting colors — so contrast holds in both modes." Components contain zero mode logic.

## The core ideas

### 1. Taxonomy: two layers, strict reference direction

| Layer | Names | Consumed by |
| --- | --- | --- |
| Primitives | scale positions: `--brand-50…950`, `--neutral-*`, `--success-*`, `--warning-*`, `--danger-*`, `--radius-sm/md/lg/xl`, `--shadow-sm/md/lg`, `--font-sans/mono/display` | only semantic tokens and theme definitions |
| Semantic | roles: `--background`, `--foreground`, `--card`, `--primary`, `--muted`, `--border`, `--ring`, … | components, exclusively |

Reference direction is one-way: semantic → primitive. The tool's rule: "Names describe what a color does (background), not what it looks like (blue-600)." A component writing `var(--brand-600)` directly is a bug even though it resolves.

### 2. The scales it emits

- **Color ramps**: 11 steps 50–950 per family (brand, optional accent, neutral, optional success/warning/danger). 50 = lightest wash, 950 = near-black. Neutrals are optionally tinted with the brand hue instead of pure gray — shipped `--neutral-950: #0b0f1a` is blue-black, not `#000`; intermediate steps run `#141a28`, `#202940`, `#2e3a56`, `#47536b`, `#64748b`, `#8b98af`, `#b3bdcf`, `#dde2ec`, `#eceff5`, `#f5f7fa` up to 50.
- **Radius**: small fixed set derived from a configurable base (0–16px): `--radius-sm: 6px; --radius-md: 10px; --radius-lg: 14px; --radius-xl: 20px`.
- **Shadow**: three steps sm/md/lg — matching card, dropdown, modal elevations.
- **Typography**: three font roles (`--font-sans`, `--font-mono`, `--font-display`), configurable base size, modular scale ratio 1.125 / 1.2 / 1.25 / 1.333. Sizes are derived, not eyeballed: `--text-*` steps are base × ratio^n.
- **Spacing**: integer multiples of a unit — 2, 4, or 8px.
- **Motion**: NOT emitted by this tool. If the project animates, extend the same pattern by hand: `--duration-fast: 150ms; --duration-base: 200ms; --duration-slow: 300ms; --ease-out: cubic-bezier(0.22,1,0.36,1)`.

### 3. The semantic vocabulary and its light/dark mapping

```css
:root {
  --background:          var(--neutral-50);    /* dark: var(--neutral-950) */
  --foreground:          var(--neutral-950);   /* dark: var(--neutral-50)  */
  --card:                #ffffff;              /* dark: var(--neutral-900) */
  --card-foreground:     var(--neutral-950);   /* dark: var(--neutral-50)  */
  --popover:             #ffffff;              /* dark: var(--neutral-900) */
  --popover-foreground:  var(--neutral-950);   /* dark: var(--neutral-50)  */
  --primary:             var(--brand-600);     /* dark: var(--brand-500)   */
  --primary-foreground:  #ffffff;              /* dark: #ffffff            */
  --secondary:           var(--neutral-100);   /* dark: var(--neutral-800) */
  --secondary-foreground: var(--neutral-900);  /* dark: var(--neutral-50)  */
  --muted:               var(--neutral-100);   /* dark: var(--neutral-800) */
  --muted-foreground:    var(--neutral-600);   /* dark: var(--neutral-400) */
  --accent:              var(--brand-100);     /* dark: var(--brand-900)   */
  --accent-foreground:   var(--brand-900);     /* dark: var(--brand-100)   */
  --destructive:         var(--danger-600);    /* dark: var(--danger-500)  */
  --destructive-foreground: #ffffff;           /* dark: #ffffff            */
  --border:              var(--neutral-200);   /* dark: var(--neutral-800) */
  --input:               var(--neutral-200);   /* dark: var(--neutral-800) */
  --ring:                var(--brand-600);     /* dark: var(--brand-500)   */
}
```

Rules the mapping reveals:

- Light `--background` sits at neutral-50, one step off white; pure white is reserved for `--card`/`--popover`. Dark flips depth: background at 950, cards lift to 900.
- Primary steps down one notch in dark (600 → 500): dark surfaces make mid tones read brighter, so accents need less lightness to hold contrast.
- `--primary-foreground` and `--destructive-foreground` are white in both modes — the chosen step must clear 4.5:1 against white.
- `--muted-foreground` (neutral-600 light / neutral-400 dark) is the slot that fails contrast most; the tool's WCAG 2.2 table "nudges muted text along the scale" until it passes 4.5:1.
- `--border` and `--input` share a value; `--ring` follows primary.
- `--accent` is the brand's inverse-contrast pair (100 ↔ 900 across modes) — for hovered/selected fills, not decoration.

### 3b. The emitted file, end to end

The tool's `tokens.css` (demo seed = Tailwind blue; abridged to structure) shows the exact layout to reproduce:

```css
:root {
  /* primitives — brand ramp (tinted neutrals as in §2) */
  --brand-50:  #eff6ff;  --brand-100: #dbeafe;  --brand-500: #3b82f6;
  --brand-600: #2563eb;  --brand-900: #1e3a8a;  --brand-950: #172554;
  --neutral-50: #f5f7fa; /* …through*/ --neutral-950: #0b0f1a;
  --success-50: /* … */; --warning-50: /* … */; --danger-50: /* … */;

  /* primitives — non-color scales (font stacks are whatever you configure) */
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --font-display: "Inter", sans-serif;
  --radius-sm: 6px;  --radius-md: 10px; --radius-lg: 14px; --radius-xl: 20px;
  --shadow-sm: 0 1px 2px rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);

  /* semantic — light values (see §3 for the full slot list) */
  --background: var(--neutral-50);
  --foreground: var(--neutral-950);
  --primary: var(--brand-600);
  --ring: var(--brand-600);
}
.dark {
  /* semantic — dark values: same slots, alternate primitives */
  --background: var(--neutral-950);
  --foreground: var(--neutral-50);
  --primary: var(--brand-500);
  --ring: var(--brand-500);
}
```

Order matters for readability and diffing: primitives grouped by family, then semantics, then one dark block that touches only semantics. A `.dark` block that redefines a primitive is a smell — primitives are mode-invariant by definition.

### 3c. Importing an existing system (normalization mode)

The paste tab accepts five formats: DTCG, Tokens Studio, Figma plugin, flat JSON, CSS vars. Workflow it encodes: parse → resolve aliases → report every alias that cannot be resolved against a ramp → keep the incoming names only if they already match the role vocabulary; otherwise map them onto it. When normalizing a real codebase, do the same: inventory existing literals and aliases, resolve each to a ramp step or semantic slot, and surface (don't silently drop) anything unresolvable — an unresolvable alias means the old system used a value outside the new scales, which is a decision, not noise.

### 4. Output formats and file placement

Four exports from one internal model:

1. **`tokens.css`** — the two-layer CSS above: primitives in `:root`, semantics below them, `.dark` overrides last.
2. **Tailwind v4** — primitives become `--color-*`, `--font-*`, `--text-*`, `--radius-*`, `--shadow-*` inside `@theme` (yielding utilities like `bg-brand-500`); semantic tokens stay in `:root`/`.dark` and are exposed via `@theme inline` so `bg-background` / `text-foreground` flip modes automatically. (Source is Tailwind-based; plain-CSS port: `@theme` entries are just custom properties — declaring `--color-*` on `:root` gives any stylesheet the same access, and hand-written CSS needs no `@theme inline` re-export because it consumes the variables directly.) A Tailwind v3 config export also exists.
3. **`tokens.json`** — DTCG: `$type`/`$value` per token, `{group.token}` references for aliases, dark values under `$extensions`. Style Dictionary v4 compatible.
4. **Agent rules** — an AGENTS.md block of token rules for coding agents ("Semantic tokens first", "No raw hex", "One source of truth").

Settings: hex or `oklch()` values, custom variable prefix, and an import report that flags unresolvable aliases when pasting an existing export. Recommended placement: `tokens.css` → `styles/`, theme → `styles/theme.css`, `tokens.json` → `design/` (or `tokens/`), agent rules → repo root.

### 5. Dark-mode strategies

Four options: `.dark` class, `[data-theme="dark"]`, `prefers-color-scheme`, or class with system fallback. Class-strategy toggle: `document.documentElement.classList.toggle('dark')`. Whichever is chosen, only token blocks change — component CSS never mentions mode.

### 6. The algorithm: reproduce the set by hand

1. **Seed**: brand hex → OKLCH `L C H`. Optional accent hue; status hues ≈ success 145, warning 90, danger 25.
2. **Ramp per family**: hold H constant; distribute L evenly across 50–950, clamped to `[max(0.05, L−0.4), min(0.95, L+0.4)]`; set each step's chroma as a percentage of that L/H gamut max (the 50/950 ends get less — correct, keeps steps in gamut). Neutrals: C ≈ 0, or a few percent of brand chroma for tinted neutrals.
3. **Derived scales**: spacing = unit × {1, 2, 3, 4, 6, 8, 12, 16} (default unit 4px); radius from your base toward {6, 10, 14, 20}px; shadow sm/md/lg; type = base × ratio^n rounded (1.125 from 16px → 18, 20, 23, 26, 29, 32, 36).
4. **Map semantics** per the §3 table — every slot gets a value in both modes.
5. **Dark**: walk the table and remap each slot to its alternate primitive; never invert, never filter.
6. **Contrast-gate**: text pairs ≥ 4.5:1, large text/UI ≥ 3:1 (WCAG 2.2). Fix failures by moving the slot to a neighboring ramp step, never by editing the step's value.
7. **Emit once, derive the rest**: write CSS first; derive JSON / Tailwind / agent rules from the same values. One source of truth.

### 7. When the tool beats manual work

Use the tool when: normalizing an existing export (ingests DTCG, Tokens Studio, Figma-plugin, flat JSON, CSS vars, and reports unresolvable aliases); you need all four outputs consistent in one pass; you want the WCAG 2.2 contrast table computed for you. Go manual when: no browser available; you need perceptually even ramps (its hex output is numerically even — see Relations); your vocabulary extends past its slot list (no motion, z-index, or breakpoint tokens in its output).

## When to use / When NOT to use

Use when: starting a project's styling from zero; an existing codebase has scattered literals and needs a token backbone; migrating Figma variables into code; standing up dark mode for the first time.

Not when: a token system already exists and is consumed — extend it, don't re-seed it; the surface is a throwaway page; the target environment can't use CSS custom properties; the team hasn't picked fonts yet (garbage in, garbage out).

## How to apply

1. Collect inputs: brand hex (accent?), fonts (sans/mono/display), spacing unit (2/4/8, default 4px), radius base (0–16px), ratio (1.125–1.333).
2. Generate the 11-step ramp per family (§6.2) — 50 through 950, no missing steps.
3. Write `tokens.css` in the tool's exact layout: primitives grouped by family in `:root`, semantic tokens below them, `.dark` overrides last.
4. Map every semantic slot in both modes; only `--card`/`--popover` (light white) and the two `*-foreground` whites may resolve to literals.
5. Contrast-check fg/bg pairs at 4.5:1 / 3:1; nudge failing slots to neighboring steps until they pass.
6. Consume only semantics in components; lint for raw hex/rgb outside token files.
7. Ship derivatives: Tailwind `@theme` (primitives) + `@theme inline` (semantics) if v4, `tokens.json` for non-CSS tools, agent rules at repo root.
8. Audit both directions: every primitive referenced by ≥ 1 semantic token; every semantic token consumed by ≥ 1 component.

## AI-slop warning

Tool-flavored slop: generating only colors and calling it a token set (no spacing/radius/shadow/type — half a system); emitting ramps but writing components with `--brand-600` or raw hex anyway; semantic names that leak appearance (`--blue-background`); dark mode via `filter: invert(1)` or per-component mode branches; rebuilding a different slot vocabulary in every file; inventing 15-step ramps where 11 suffice "because more looks thorough"; tokens defined but never consumed. The shadcn-style default vocabulary is a feature — agents already know `bg-background` — but it also means every output is structurally identical: differentiate via the brand ramp, not by renaming slots. And the tool's evenly-spaced numbers are not evenly-spaced perceptions: run generated hex through a perceptual check before trusting it (see desengs-oklch).

## Relations

- **desengs-oklch** — the ramp math behind §6.2: L-clamped even distribution plus per-step chroma percentages makes generated ramps perceptually even, not just numerically even; also the `oklch()` output setting used well.
- **desengs-aicss** — conventions for AI-authored CSS; the generator's agent-rules export ("semantic tokens first", "no raw hex") is a concrete instance of that discipline.
- **desengs-ds-checklist** — design-system audits; use it to verify the emitted set (slot coverage, consumption, dark parity) after generation.
- **desengs-ui-ux-master** — the canon this skill belongs to; token generation is step one of its build flow, everything downstream consumes these slots.
