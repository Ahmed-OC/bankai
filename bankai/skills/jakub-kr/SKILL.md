---
name: jakub-kr
description: Use when building a personal site, portfolio or content page that should feel quiet, warm and alive — distills jakub.kr's near-monochrome gray ramp, quiet underlines, 200ms hover choreography and hand-drawn identity marks into copyable mechanisms.
source: https://jakub.kr/
category: portfolio
---

# Jakub Krehel — the portfolio of the craft evangelist

Source: https://jakub.kr/ — Jakub Krehel, founding design engineer at Interfere (previously OpenSea), author of interfaces.dev, the `/skills` agent-skill collection and oklch.fyi. One page, three sections (Projects / Writing / Links). No license stated; all mechanisms below were read from the shipped HTML/CSS and are re-expressed in plain CSS (the site itself is Tailwind-compiled — every utility was ported by hand).

## What it is / Why it exists

The site is the argument made flesh: one page, near-monochrome, system fonts by default, and a handful of 150–300ms micro-interactions. Krehel's stated stance — "I care deeply about craft and quality and I like to make people feel something through my work" — plus an evangelist output of essays on restraint, details, gestures, gradients and OKLCH. The portfolio exists to demonstrate that "minimal" is not "unfinished": every quiet surface has a measured token behind it and every hover has choreography. Treat this skill as the *reference implementation* of minimal-with-warmth.

## The core ideas

### 1. Warm near-monochrome — a 12-step gray ramp, never #000 on #fff

Two full gray ramps (light + dark), no hue anywhere except one danger red. Off-pure endpoints are the warmth: light text `#202020` on `#fcfcfc`, dark text `#ebebeb` on `#0c0c0c`.

```css
:root {
  --gray-bg: #fcfcfc;  --text: #202020;  --text-paragraph: #424242;
  --gray-100:#fcfcfc; --gray-200:#f6f6f6; --gray-300:#f0f0f0;
  --gray-400:#e8e8e8; --gray-500:#e0e0e0; --gray-600:#d9d9d9;
  --gray-700:#cecece; --gray-800:#bbbbbb; --gray-900:#8d8d8d;
  --gray-1000:#838383; --gray-1100:#6f6f6f; --gray-1200:#202020;
  --danger: #fb2c36;  --danger-strong: #e40014;
}
@media (prefers-color-scheme: dark) {
  :root {
    --gray-bg: #0c0c0c;  --text: #ebebeb;  --text-paragraph: #d8d8d8;
    --gray-100:#0d0d0d; --gray-200:#161616; --gray-300:#202020;
    --gray-400:#232323; --gray-500:#2f2f2f; --gray-600:#383838;
    --gray-700:#464646; --gray-800:#5e5e5e; --gray-900:#6c6c6c;
    --gray-1000:#797979; --gray-1100:#b2b2b2; --gray-1200:#ebebeb;
  }
}
```

Roles, not raw values: body copy `--text-paragraph` (one step softer than `--text`), headings and link text `--text`, quiet chrome `--gray-900/1000`, hairlines `--gray-600`. Set `theme-color` meta per scheme (`#fcfcfc` / `#0c0c0c`) so mobile browser chrome matches.

### 2. Typography: system sans, fractional weights, serif-italic accents

- Default stack is the **system font**: `font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif`. Custom fonts are an accent, not a base — load at most three faces (he ships a two-weight display sans, a text serif with italic, and one italic-only serif).
- **Fractional weights do the hierarchy**: body/links `font-weight: 450`, headings `550`, strong UI labels `500`. On variable system fonts (SF, Roboto Flex) these hit real, distinct weights — cheaper than a size scale.
- **Italic accent trick**: `<em>` swaps to a serif italic (`font-family: "Libre Baskerville", Georgia, serif; font-style: italic`) inside the sans body — one line of CSS, instant editorial warmth.
- Body `line-height: 1.625` (`leading-relaxed`); measure capped at `43.25rem` (692px) with `padding: 0 24px`; page top padding 48px → 96px at ≥640px. Titles get `text-wrap: pretty`.
- Any custom webfont gets a **metric-override fallback** so swap causes zero shift:

```css
@font-face { /* fallback that matches the real font's metrics */
  font-family: "MySerif Fallback"; src: local(Arial);
  ascent-override: 106%; descent-override: 38%; size-adjust: 93.7%;
}
```

(Values per face; his range 89–106% ascent, 93.7–108.9% size.) `font-display: swap` on the real faces.

### 3. Quiet links — real underlines that darken, no tricks

Inline links are `font-weight: 450`, real `text-decoration: underline` at low emphasis, animated on hover:

```css
a.quiet {
  text-decoration-line: underline;
  text-decoration-color: var(--gray-600); /* #d9d9d9 — visible but shy */
  text-underline-offset: 3px;
  transition: color .2s ease, text-decoration-color .2s ease;
}
a.quiet:hover { color: var(--text); text-decoration-color: var(--gray-1100); }
```

Ban background-size underline hacks here — the decoration-color transition is the mechanism, and it respects text that wraps.

### 4. List-row choreography — the signature hover pattern

Projects and writing render as stacked rows (16px radius, 8px inner padding, 8px row gap) with four coordinated details:

```css
.row {
  position: relative; display: flex; align-items: center;
  margin-inline: -8px; padding: 8px; border-radius: 16px;
}
/* 1. Enlarged hit area without visual padding change */
.row::before { content: ""; position: absolute; inset: -4px 0; }
/* 2. Arrow appears: fade + slide + unscale, 200ms ease-out */
.row .arrow {
  opacity: 0; translate: -2px 0; scale: .75;
  transition: opacity .2s ease-out, translate .2s ease-out, scale .2s ease-out;
}
@media (hover: hover) { .row:hover .arrow { opacity: 1; translate: 0 0; scale: 1; } }
/* 3. Favicon rendered as a tiny browser chip: 3px frame + inner 40×48 preview */
.favicon-chip { padding: 3px; border-radius: 8px; background: var(--gray-bg);
  box-shadow: var(--shadow-rest); transition: box-shadow .2s ease-out; }
.favicon-chip > img { width: 40px; height: 48px; border-radius: 5px; }
@media (hover: hover) { .row:hover .favicon-chip { box-shadow: var(--shadow-hover); } }
/* 4. Multi-part logo deconstructs: each path translates its own amount, 300ms */
.logo path { transition: transform .3s ease-out; }
@media (hover: hover) {
  .row:hover .logo path:nth-child(1) { transform: translateY(4px); }
  .row:hover .logo path:nth-child(2) { transform: translateY(-2px); }
  .row:hover .logo path:nth-child(3) { transform: translateY(3px); }
}
```

Every hover state is wrapped in `(hover: hover)` — touch devices get zero hover styling, not stuck styling. Arrow size 18px, baseline-aligned at `-0.2em`.

### 5. Layered whisper shadows

The only elevation system is one rest shadow and one hover shadow, ring-first:

```css
:root {
  --shadow-rest: 0 0 0 1px rgba(0,0,0,.06), 0 1px 2px -1px rgba(0,0,0,.06),
                 0 2px 4px 0 rgba(0,0,0,.04);
  --shadow-hover: 0 0 0 1px rgba(0,0,0,.08), 0 1px 2px -1px rgba(0,0,0,.08),
                  0 2px 4px 0 rgba(0,0,0,.06);
}
@media (prefers-color-scheme: dark) {
  :root { --shadow-rest: 0 0 0 1px rgba(255,255,255,.09);
          --shadow-hover: 0 0 0 1px rgba(255,255,255,.14); }
}
```

Hover = the same recipe ~30% stronger, never a different direction. Dark mode keeps only the ring.

### 6. Hand-drawn identity mark

The avatar is a hand-drawn signature squiggle (one 837-unit viewBox, 12.6 stroke, 44px render) split into ~60 stacked paths, each faded toward the background with an opacity ramp — the ink appears to trail off:

```css
.signature path:nth-child(n) {
  stroke: color-mix(in srgb, currentColor 35%, var(--gray-bg)); /* 3%→99% per path */
}
```

Mechanism: `color-mix(currentColor N%, background)` per path instead of flat opacity, so overlapping strokes keep ink density. Any hand-drawn SVG (doodle, arrow, underline) gets depth this way; generate paths ordered so the ramp follows the drawing direction.

### 7. Motion budget (his essays make it explicit)

- 150ms `cubic-bezier(.4,0,.2,1)` for state flips; 200ms ease-out for hover-entering feedback; 300ms ease-out for logo deconstruction. Nothing else on a content page.
- Animate only `opacity, transform, color, box-shadow, text-decoration-color`.
- From "Less is more, more or less": a macOS context menu opened ~200×/day with a 300ms open animation "wastes about a minute per day or more than 6 hours per year" — do the frequency×duration math before animating a high-frequency action. "Animating something and animating something well are two very different things."
- From "The invisible side of design engineering": the real job is "accessibility, responsiveness, performance" and "edge cases that only show up when people actually start using your product" — "a lot of what makes a great experience is *invisible*."

### 8. Machine-friendly content

The site publishes itself as markdown: `<link rel="alternate" type="text/markdown" href="/index.md">` plus an RSS feed at `/api/rss`. Every outbound icon link carries `sr-only` text ("opens in a new tab"); decorative SVGs are `aria-hidden` with `role="graphics-symbol"`. A one-page site with a markdown mirror is fully indexable by agents — do this on any content site you build.

## His work (what the portfolio funnels into)

- **interfaces.dev** — a design engineering magazine (curated interface craft).
- **/skills** (jakub.kr/skills → github.com/jakubkrehel/skills) — agent skills for building interfaces (11 skills: typography, colors, layout, a11y, writing, review orchestrators).
- **oklch.fyi** — a guide to OKLCH colors.
- **Essays**: less is more, more or less; the invisible side of design engineering; details that make interfaces feel better; using gestures in Motion; drag gestures on the web; using AI as a design engineer; how I use shared layout animations; understanding gradients; what are OKLCH colors.

## When to use / When NOT to use

Use when building: personal sites, portfolios, docs, blogs, content-first marketing pages — anywhere the content is the interface and trust comes from restraint. Use the gray-ramp + quiet-underline combo as a default starting palette when no brand exists.

Do NOT use when: the product needs brand color recognition (this palette deliberately erases hue), data-dense dashboards need stronger figure/ground than `#6f6f6f` captions provide (drop to `#424242` minimum for table copy), or the brief calls for expressive/brutalist motion — Krehel's budget tops out at 300ms transforms; anything looped or scroll-driven contradicts the source.

## How to apply

1. Set the two gray ramps and role tokens (`--text`, `--text-paragraph`, `--gray-bg`) before writing any component; ban `#000`/`#fff` literals.
2. Default to the system font stack; express hierarchy with weights 450/550, not new sizes; cap measure at 692px, body line-height 1.625.
3. If loading custom fonts: ≤3 faces, `woff2`, `swap`, each with a metric-override Arial fallback (`ascent-override` 89–106%, `size-adjust` 94–109%).
4. Style all inline links with the quiet underline (offset 3px, decoration `--gray-600` → `--gray-1100` on hover, 200ms `ease`).
5. Build list rows with the 16px-radius / -8px margin-bleed / `::before` -4px hit-area pattern; add the arrow reveal (fade+slide+unscale, 200ms ease-out) only inside `@media (hover: hover)`.
6. Use exactly two shadows (rest/hover, ring-first recipe above) and transition `box-shadow` 200ms ease-out.
7. Give any multi-path logo a per-path hover transform at 300ms ease-out; give any hand-drawn SVG the `color-mix` stroke ramp.
8. Do the animation math: frequency × duration per year. Skip animations on actions used >50×/day; keep enter animations ≤300ms.
9. Mirror the page as markdown (`/index.md`) and link it via `<link rel="alternate" type="text/markdown">`; ship RSS.
10. Set `theme-color` for both schemes; add `sr-only` labels on new-tab links; `aria-hidden` on decorative SVGs.
11. Before shipping, run the "invisible" checklist: keyboard path, reduced-motion (`@media (prefers-reduced-motion)` strips all 200/300ms transitions), dark-mode shadow flip, wrapping titles (`text-wrap: pretty`).

## AI-slop warning

The failure mode is copying the surface and missing the math: an agent slaps `border-radius: 16px` + one shadow on gray cards and calls it "warm minimal," then adds a 400ms staggered entrance to a list that users visit hourly. This look became the default 2024–26 "tasteful dev portfolio" — replicate the *token discipline* (12 steps, role names, metric-locked fonts, frequency-based motion budget) or it reads as slop. Second trap: fractional weights (`450`) render as synthesized bold on static system fonts (Windows Segoe UI) — verify a real intermediate face exists or fall back to 400/500. Third: the quiet underline at `#d9d9d9` fails contrast as *text* — it is decoration only; never use gray-600-range tokens for body copy.

## Relations

- **krehel-skills** — his own agent-skill collection distilled; the codified review order (accessibility → layout → writing → typography → colors → UI) this site visually complies with. Use it to *check* what this skill *builds*.
- **interfaces-dev** — his magazine; the canon of craft examples this portfolio's techniques are drawn from. Adds component-level reference beyond the one-page site.
- **details-feel-better** — his essay whose patterns (concentric radii, contextual icon motion, text wrapping) appear live in these rows and chips. Adds the detail inventory.
- **using-ai-as-de** — his essay on encoding judgment into agent standards (`/codebase-standards` + review commands); explains why his own skills repo exists. Adds the AI-workflow half.
- **oklch** — complements his oklch.fyi project; where to go when the gray ramp needs a hue.
