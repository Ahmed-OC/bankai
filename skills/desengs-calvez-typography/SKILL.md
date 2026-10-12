---
name: desengs-calvez-typography
description: Use when any text block needs a fast typography pass — one typeface with four weights, 1.2–1.5× line-height, 40–70 char lines, 14–25px body, left-aligned, correct dashes, tabular numbers, optical nudges.
source: https://www.pierrickcalvez.com/journal/a-five-minute-guide-to-better-typography; https://cdn.prod.website-files.com/56e7dd1a0b15f5eb36389d7f/64537a9aa2729bbbbe059e97_A%20Five-Minute%20Guide%20to%20Better%20Typography.pdf
category: essay
---

# A Five-Minute Guide to Better Typography (desengs) — Calvez's rapid rules

Source: https://www.pierrickcalvez.com/journal/a-five-minute-guide-to-better-typography — Pierrick Calvez, an 80-slide picture essay (free PDF, © Pierrick Calvez). Its own further reading: "Typography is Impossible" (Medium Engineering) and thepunctuationguide.com. All quotes below are Calvez's verbatim; the Matthew Carter quote is his.

## What it is / Why it exists

Calvez compresses working typography into defaults plus "in doubt" fallbacks — decisions an agent can apply to any text block in five minutes without a type system. Thesis, his opening definition: "Typography is the technique of arranging type for effective communication and a bit of delight." The deck's arc: stop agonizing over fonts ("Type? I has them!" — the paralysis of the font menu), treat text as blocks, establish hierarchy with weight and size contrast, tune spacing, then fix dashes and digits. Final slide, the whole guide in six strokes: "Don't nerd over typefaces, just pick one / Think type as blocks / Align with your eyes / Hierarchy first / Use contrast / Fine-tune with spacing. And voilà."

## The core ideas

| Decision | Calvez's value |
| --- | --- |
| Typefaces per project | 1 (with ≥4 weights: Light, Regular, Medium, Bold) |
| Line spacing | 1.2× font size (short paragraph) to 1.5× (long story) |
| Line length | 40–70 characters per line |
| Body size on screen | 14–25px ("12px size is too small") |
| Body alignment | left ("In doubt, align left.") |
| Size hierarchy | multiply/divide by 2 (100pt → 50pt → 25pt) |
| Weight hierarchy | skip a weight (Bold → Medium → Light) |
| Hyphen `-` | compound terms only: check-in, money-back, pull-up |
| En dash `–` | ranges and connections: 1926–2017, Pages 37–61, Paris–Shanghai |
| Em dash `—` | replaces commas, parentheses, or colons |
| Changing numbers | kerning/width discipline — digits shift layout as they tick |

### 1. One typeface, four weights

"Start with one typeface; pick one that has lots of weights. Four at least." Light / Regular / Medium / Bold "equals a typeface." Font selection is procrastination; hierarchy comes from the weights you already own. For an agent: never spend a decision on font pairing unless a brand demands it — spend it on weight, size, spacing.

### 2. Think in blocks, not letters

Anchor quote (Matthew Carter): "Type is a beautiful group of letters, not a group of beautiful letters." Calvez demonstrates by re-spacing the same two-line quote as discrete blocks — headline block, quote block, attribution block — with the air living *between* blocks. The deck annotates every gap in "lf" units (line-feeds: the body text's own line height). In his worked example a 150pt "Bonjour" sits over a 25px/1.44 body with a gap of ≈1 body line-feed. Mechanism for UI: vertical spacing between typographic blocks in whole multiples of the body `line-height` (e.g. `margin-top: 1.5rem` on a body whose `line-height` is `1.5rem`-equivalent), never arbitrary pixel values.

### 3. Break lines by meaning

His demonstration headline: "Headless Body in Topless Bar". Bad: `Headless Body in / Topless Bar` — the line dies on a dangling preposition. Good: `Headless Body / in Topless Bar` — the function word starts the next line. For an agent: wrap-balanced headings, and glue critical pairs with `&nbsp;` when auto-wrap would strand a word.

```css
h1, h2, h3 { text-wrap: balance; } /* browser avoids orphaned short words */
p          { text-wrap: pretty; }  /* fewer widows/orphans in paragraphs */
<!-- hard case, decide yourself: -->
<h2>Headless Body<br>in Topless Bar</h2>
<h3>The&nbsp;Eiffel&nbsp;Tower</h3> <!-- glue "Eiffel Tower" — no break inside the name -->
```

### 4. Aligned when it feels aligned

"Type is not an exact science. It is aligned when it feels aligned." His slide pair: a 150pt "Bonjour" flush-aligned by bounding box to a 25px paragraph below looks wrong; the correction (shown as a blue ghost, then the fixed black) nudges the display word **left by ~12pt = 0.08em of its own size** so its visual left edge — not its box — matches the body. "Realign if necessary." For an agent: after any display-size element lands mathematically aligned, apply a one-time optical correction; rounded letters (O, C, S, e) need extra (~0.02–0.05em) inset.

```css
.display-word { margin-left: -0.08em; }  /* optical left for display over body text */
.round-initial { margin-left: -0.03em; } /* round openers: O, C, G, S */
```

### 5. Hierarchy: skip a weight, multiply by two

Two "in doubt" fallbacks, plus contrast:

- **Weight**: "In doubt, skip a weight." Title BOLD, subtitle MEDIUM, body LIGHT — adjacent weights (Regular/Medium) read as an accident, skipped weights read as hierarchy.
- **Size**: "In doubt, multiply by two." 100pt / 50pt / 25pt. Halving between levels beats a fiddly 32/28/24 ramp when you need obvious hierarchy fast.
- **Contrast**: his pair — "Do Not Read / The Next / Sentence." (bold, uppercase) over "You little rebel. I like you." (light, lowercase). Maximal difference between levels, not subtle gradients of difference.

```css
/* Calvez defaults as tokens */
--fs-display: 2;  /* ratio 2 between levels */
h1   { font-size: 4rem;   font-weight: 700; } /* Bold    */
.sub { font-size: 2rem;   font-weight: 500; } /* Medium  */
body { font-size: 1rem;   font-weight: 300; } /* Light   */
```

### 6. The three body numbers + alignment

"Pay attention to your line-spacing:" — his too-tight example moans "Naa...", the too-loose one "Noo...". "In doubt, use a line-spacing of 1.2x to 1.5x the font size": **1.2× for a short paragraph, 1.5× for a long story** — tighter leading only earns itself on short blocks. "Tame the flow:" measure (line length) between **40 and 70 characters** — long lines lose the return sweep, short ones chop the text into ribbons. Sizes: "12px size is too small," **14–25px size is better**. "In doubt, align left" — never justify body text (uncontrolled rivers).

```css
body {
  font-size: clamp(16px, 0.6rem + 0.9vw, 20px); /* inside 14–25px */
  line-height: 1.5;        /* 1.2 only for ≤3-line blocks */
  max-width: 68ch;         /* 40–70 chars; ch = width of "0" */
  text-align: left;
}
.short-block { line-height: 1.2; }
```

### 7. Nerdy stuff: the three dashes

Hyphen `-` U+002D, en dash `–` U+2013 (Mac ⌥ -), em dash `—` U+2014 (Mac ⌥ ⇧ -).

- **Hyphen** for compound terms: `check-in`, `money-back`, `pull-up`. Aside: "Hyphenated words are new words in the making" — breakfast, timeout — "language darwinism".
- **En dash** for a range or a connection: `1926–2017`, `Pages 37–61`, `Paris–Shanghai`. Ranges in UI copy ("3–5 days", "ages 18–24") get an en dash, never a hyphen.
- **Em dash** "can beautifully replace commas, parentheses, or colons" — "The em dash is underused in typography—such a waste." No spaces around it in his own setting.

For an agent generating copy or HTML: never emit `--` or ` - ` where an en/em dash belongs; typographic dashes are content, not styling.

### 8. Kerning and numbers

"Finally, pay attention to kerning:" — his "Await" sequence builds the word letter by letter, then shows a corrected copy: at display size the default A–w pair leaves a visible gap; the kerned version (overlaid in blue) tightens it. In CSS, kerning ships on by default (`font-kerning: normal`) — the agent's job is to not defeat it (`letter-spacing` on lowercase text) and to check display headlines for problem pairs (Av, Aw, Ta, Va, LT, y.).

His number sequence: a value ticks `1 → 18 → 18, → 18,1 → 18,15 → 18,150`, with the mutating tail (`150`) highlighted in blue. Point: proportional digits have different widths ("1" narrower than "8"/"0"), so any changing number reflows — width, centering, everything after it jumps. Countermeasure for UI:

```css
.counter, .price, td.num, time {
  font-variant-numeric: tabular-nums; /* equal-width digits, no jiggle */
}
/* layout-level fix when the font lacks tabular figures: */
.counter { min-width: 6ch; text-align: right; display: inline-block; }
```

### 9. The deck's demos, as a symptom → fix table

Every lesson ships as a visible before/after an agent can pattern-match against:

| Symptom in your render | Calvez's demo | Fix |
| --- | --- | --- |
| Three fonts fighting on one screen | "Type? I has them!" font menus | one typeface, ≥4 weights |
| Wall of evenly spaced lines | Carter quote re-set as blocks | group into blocks, space between blocks in lf units |
| Heading ends on "in", "of", "a" | "Headless Body in / Topless Bar" | move function word to next line, `text-wrap: balance` |
| Display word flush-aligned but looks off | blue ghost "Bonjour" shifted −12pt | optical nudge ≈0.08em of display size |
| Levels read as an accident | Bold/Medium/Light re-set | skip a weight between adjacent levels |
| Sizes creep (28/26/24) | 100pt / 50pt / 25pt | halve (or double) between levels |
| Both sizes AND weights near-identical | "Do Not Read…" vs "You little rebel…" | make adjacent levels maximally different: case, weight, size |
| Lines collide or drift apart | "Naa…" / "Noo…" paragraphs | line-height 1.2 (short) – 1.5 (long) |
| Eye loses the return sweep | narrow vs wide "Turnip greens" columns | 40–70 characters per line |
| Body squints on screen | 12px vs 14–25px columns | raise to 14–25px |
| Ragged right looks "unfinished" | "In doubt, align left." | keep left; justification causes rivers |
| "1926-2017", "check—in" | hyphen/en/em triple with ⌥ shortcuts | `-` compounds, `–` ranges, `—` clause breaks |
| Gap in "Await", "Tav" at display size | letter-by-letter "Await" + kerned overlay | trust `font-kerning`, no positive tracking on lowercase |
| Counter/price jumps as it ticks | `1 → 18,150` with blue mutating tail | `tabular-nums` + fixed width/right-align |

## When to use / When NOT to use

Use when: rendering any text block from scratch; doing a fast polish pass on a page, card, modal, hero, or email; picking hierarchy values without a design system; writing UI copy containing ranges or asides.
Skip when: a design system already defines a type scale (obey it, don't improvise 2× jumps inside it); typesetting long-form documents that need indents, small caps, and footnote machinery; non-Latin scripts (CJK and Arabic line-height/measure rules differ — 1.2× will clip); brand typography already specifies a second face. This is triage, not a type system — for the full rulebook go to `desengs-practical-typography`.

## How to apply (the five-minute pass)

1. Set the block's font to the one project typeface; confirm Light/Regular/Medium/Bold exist before inventing hierarchy.
2. Body text: size 16–20px (clamp within 14–25px), `line-height: 1.5` (1.2 if the block is ≤3 lines), `max-width: 68ch`, `text-align: left`.
3. Hierarchy: skip a weight per level (700 → 500 → 300) and/or halve the size per level (e.g. 100 → 50 → 25). Never step by adjacent weights.
4. Headings: `text-wrap: balance`; read every wrapped heading and move stranded function words ("in", "of", "a") to the next line.
5. Space blocks in whole body line-feeds (`1lf` / `2lf` of the body `line-height`), not arbitrary margins.
6. Display-size elements over body text: optical-align — nudge ~0.08em of the display size; extra for round openers.
7. Scan copy for dash errors: ranges/connections get `–` (Pages 37–61), compounds get `-` (check-in), clause breaks get `—` with no padding spaces.
8. Any digit that changes or columns of digits: `font-variant-numeric: tabular-nums` plus fixed width or right alignment.
9. Re-read the rendered result, not the code — alignment "when it feels aligned", realign if necessary.

## AI-slop warning

Typical AI failures against this guide: shipping 12px body text; `line-height: 1.2` on long paragraphs (tight-leading everything); centered paragraphs everywhere ("In doubt, align left." — centering is for ≤2-line blocks at most); hyphens in ranges ("1926-2017") and `--` or `" - "` where en/em dashes belong; proportional digits in live counters so tickers shake; defeating kerning with positive `letter-spacing` on lowercase; spending the prompt's effort on font pairing (Inter + something) instead of weights and spacing — the exact font-menu procrastination the deck mocks with "Type? I has them!". Also: 2× size jumps applied *inside* an existing design system, producing a 100px heading in a 16px product — the ratio is for poster-like hierarchy, not component labels.

## Relations

- `desengs-practical-typography` — Butterick's full rulebook; numbers align (line-height 1.2–1.5 vs 120–145%, 14–25px vs 15–25px web body) but Calvez's measure is stricter (40–70 vs 45–90 chars). Go there for emphasis, quotes, small caps, indent-vs-space paragraphs; use Calvez when there's time for neither.
- `desengs-krehel-skills` — its better-typography section adds what this deck lacks for UI components: truncation, wrapping at real content lengths, variable fonts, OpenType features. Complements sections 6–8 here.
- `desengs-details-feel-better` — same doctrine as section 4 ("aligned when it feels aligned"): craft is optical correction applied after the mathematically correct layout, and it is what users feel as quality.
