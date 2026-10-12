---
name: desengs-inter-alternatives
description: Use when choosing a UI/product typeface, escaping the Inter default, or when button labels refuse to optically center. Two metrics decide—cap-centered verticals and a 70–75% x-height.
source: https://yeptype.com/article/inter-alternatives
category: essay
---

# Inter Alternatives (desengs) — escaping the default font monoculture

Source: https://yeetype.com/article/inter-alternatives — "How to choose a UI font (and 10 Inter alternatives)", Yep! Type Foundry journal, published 2026-07-26. Essay by the foundry's author, a self-described "typography nerd and an actual product designer with more than a decade in the field." Commercial foundry article: 2 of the 12 fonts listed (Innovator Grotesk, Unifora) are their own.

## Why it exists

Every product designer hits the same day: the first concept is set in "everyone's all-time favorite UI font" — Inter — and then someone (customer, boss, or a part of your own soul) says "hey, big fan of it, but it's everywhere, can we maybe try something else?"

Inter earned the default honestly: it is free/open source (SIL OFL), on Google Fonts, ships variable axes, and meets both criteria below at the gold-standard numbers. The objection is distinctiveness, not fitness. So the replacement bar is precise: a font that works as hard as Inter does mechanically, without looking like Inter.

The author's warning against lazy substitution: "I keep a collection of 60+ neo-grotesks (zero Helveticas), and fewer than one in three match these two criteria. So 'just pick a clean sans-serif' isn't enough—most of them will quietly cost you alignment work."

The two criteria, stated as a TL;DR in the source:

1. **Cap-centered vertical metrics** — the space above the cap height equals the space below the baseline inside the font's bounding box (also called "equal vertical metrics"). Labels center optically on buttons and align with icons; one padding token works at every size.
2. **Tall x-height** — lowercase reaches 70–75% of cap height. The word nearly fills its box, so it *looks* evenly centered.

They are not independent rules: "Cap-centering positions the word. A tall x-height is what makes that position look right. They're not two separate rules—the second is what makes the first work."

## The core ideas

### 1. Cap-centered vertical metrics (the alignment criterion)

Inside the font's bounding box, the vertical space above the cap height must equal the vertical space below the baseline. Consequences in code:

Good — one rule, every size:

```css
/* holds at any font size because the font's own metrics center the label */
.button { padding: var(--space-v) var(--space-h); }
```

Bad — the fix has to be redone per size (the author's exact example):

```css
.button      { padding: 13px 16px 11px; } /* 16px text */
.button--sm  { padding: 10px 12px  8px; } /* 14px text — different nudge */
.button--lg  { padding: 17px 20px 15px; } /* 20px text — different again */
```

Those off-by-2px top/bottom padding pairs are the smell of off-center metrics. They multiply through every size variant, chip, tab, and badge in the system, and "manual CSS tweaks to optically center each label [are] hard to support down the line." Cap-centered metrics delete the entire class of nudges.

Secondary effect: a label next to an icon aligns precisely with it, because both are positioned against the same cap-height line.

### 2. Tall x-height, 70–75% of cap height (the perception criterion)

"75% is the gold standard for interface typefaces: Inter, San Francisco, and Innovator Grotesk all sit at 75%."

The mechanism: cap-height centering treats a word as a solid brick as tall as a capital. A word is not a brick — one tall capital plus a row of shorter lowercase. The taller the lowercase, the closer the word comes to reading as a brick, and the more cap-height centering centers the *whole word*.

The boundaries, exactly:

- **75%** — the word "still isn't a perfect brick, but it reads as almost one," and upper/lower contrast stays big enough to look normal.
- **Below 70%** — too much empty space above the lowercase; "the eye reads the word as sitting low, and no cap-centering can fix that."
- **100%** — perfect brick but "essentially a unicase look: the word loses its up-and-down rhythm, its recognizable pattern disappears," and it pulls attention it shouldn't.

### 3. Why anchor on cap height, not x-height

In an average word lowercase outnumbers the capital. But the eye anchors on the **first letter** to judge where a word sits, and a UI label's first letter is usually a capital. Align by lowercase instead and the capital pokes out the top — the word looks unbalanced. An icon to the left reinforces it: "the eye compares the icon with the first letter, not with the whole mass of the word."

Exception stated in the source: an all-lowercase label has no capital to anchor on — but in interfaces most labels start with a capital anyway.

### 4. The 1000px test (how to vet any candidate in 30 seconds)

The author's exact procedure, in Figma (works the same in any design tool):

1. Type "Hanglovers" — a made-up word that "packs in all the key characters that help you assess the typeface vibe."
2. Set font size to 1000px. It must be that large.
3. Zoom to the capital "H" and decrease the text object's line height.
4. Watch the box shrink onto the letters: if the top edge lands on the top of "H" and the bottom edge lands on the baseline **at the same moment**, the font has cap-centered vertical metrics.
5. If the two edges don't meet the letters together, "put the font aside—it'll probably be a great choice for print, but not for screens."

Then check x-height against the same view: lowercase body should reach ≥70%, ideally 75%, of the cap.

### 5. `text-box-trim`: the future fix that is not here yet

CSS `text-box-trim` and `text-box-edge` (originally proposed as `leading-trim` and `text-edge`) trim the font's em box, correcting off-center metrics in the browser:

```css
.label {
  /* shorthand for text-box-trim + text-box-edge */
  /* cap = cap height, alphabetic = baseline */
  text-box: trim-both cap alphabetic;
}
.lowercase-label {
  /* align by x-height instead — the source notes this exists, not that it's right for UI */
  text-box: trim-both ex alphabetic;
}
/* other values: text (font's ascent/descent), auto */
```

Two caveats from the source:

- **Support**: as of mid-2026, ~79% on caniuse — Chrome, Edge, Safari, iOS Safari yes; Firefox no, which keeps it from Baseline. Recommendation stands: pick fonts with built-in cap-centered metrics.
- **Scope**: it "can correct a font's metrics; it can't touch its x-height." A 65% x-height font stays a sitting-low font no matter how you trim.

Progressive-enhancement pattern if you must ship an off-center font:

```css
.label { /* fallback: live with the metrics */ }
@supports (text-box-trim: trim-both) {
  .label { text-box: trim-both cap alphabetic; }
}
```

### 6. The vetted table — 10 Inter/San Francisco alternatives

Every typeface below "is drawn so the cap height sits in the optical vertical center" — the author verified each, so none need re-testing. Inter and San Francisco are the 75% reference points. This is the article's complete list with all data it provides (foundry, x-height):

| Typeface | Foundry | x-height |
| --- | --- | --- |
| Inter | Rasmus Andersson | 75% |
| San Francisco | Apple | 75% |
| Innovator Grotesk | Yep! Type Foundry | 75% |
| Universal Sans | Family Type | 75% |
| Plain | Optimo | 73% |
| SwissNow | Newglyph | 73% |
| Muoto | 205TF | 72% |
| Aktiv Grotesk | Dalton Maag | 72% |
| Akkurat | Lineto | 71% |
| Basier | atipo foundry | 71% |
| CoFo Sans | Contrast Foundry | 70% |
| Unifora | Yep! Type Foundry | 70% |

Quick-pick by need, derived strictly from that table (x-height is the only differentiator the article gives):

| You need | Pick | Why |
| --- | --- | --- |
| Drop-in Inter match, max small-size clarity | Innovator Grotesk, Universal Sans | 75% x-height, identical to Inter/SF |
| Close to Inter, slight distinction | Plain, SwissNow | 73% — "close" per the FAQ |
| Grotesque with a bit more air | Muoto, Aktiv Grotesk | 72% |
| Editorial-grotesque flavor | Akkurat, Basier | 71% |
| Lowest that still centers | CoFo Sans, Unifora | 70% — the floor, do not go below |

Reading the tiers mechanically: every point of x-height below 75% trades a little of that "solid brick" self-centering at small sizes for a slightly more traditional grotesque texture. Nothing below 70% qualifies.

## When to use

- Any product UI where labels sit inside controls (buttons, chips, tabs, inputs, badges) or beside icons.
- Building a design system's type token: cap-centered metrics are what make a single `--space-v` padding token viable across all sizes.
- Escaping the Inter default on merit, not fashion — the replacement must pass both criteria or you inherit per-size CSS nudges.
- Small/dense screens especially: the tall x-height effect (word reads as a brick) matters most at 12–16px UI sizes.

## When NOT to use

- Print and large-format work: a font that fails the test "will probably be a great choice for print, but not for screens."
- Display/editorial headlines where a lower x-height is the elegance; the criteria are for interface text.
- All-lowercase wordmarks/logotypes — the cap-anchor rationale doesn't apply (no capital to anchor on).
- Don't abandon Inter for its own sake: if nobody objects and it fits the brand, Inter at 75%/cap-centered is mechanically optimal and free. The essay exists for when distinctiveness is required.
- Don't reach for arbitrary Google Fonts sans-serifs as "alternatives" — the author's 60+ neo-grotesk collection puts the pass rate below 1 in 3.

## How to apply (numbered checklist)

1. Hear "can we try something other than Inter?" → go to the vetted table first; pick by x-height tier. All ten pass both criteria already.
2. Evaluating any font NOT in the table → run the "Hanglovers" @ 1000px line-height test; both box edges must hit cap top and baseline simultaneously.
3. Check x-height in the same test: lowercase ≥70% of cap, 75% ideal. Reject below 70% regardless of how the metrics test went.
4. Lock one vertical padding token (`--space-v`) for all label-bearing controls; forbid size-specific top/bottom padding pairs that differ by 1–2px nudges — that pattern means the font failed step 2.
5. Icon + label rows: the icon's box aligns to the cap-height line (first letter), not to the em box or the lowercase mass.
6. If an off-center font is unavoidable (brand mandate), add `text-box: trim-both cap alphabetic` inside `@supports`, keep the padding-token discipline, and know ~21% of browsers (Firefox, others) still see the untrimmed rendering.
7. Remember `text-box-trim` fixes metrics only — a short x-height cannot be CSS-repaired; reject the font.
8. Licensing, pairing, weights, and variable axes: the article decides none of this. Check license terms at each foundry (commercial, independent foundries), and get pairing/measure/leading rules from `desengs-practical-typography`.

## What changes day-to-day for an AI building UI

- Never emit magic-number vertical padding (`padding: 13px 16px 11px`) to "fix" label centering — treat it as a metrics failure to escalate, not a style to copy.
- When told to swap Inter, propose from the vetted table with the x-height number attached, not from generic font recall.
- When generating a type scale, cap-centered metrics are the precondition for uniform padding tokens; verify the font before generating component CSS.

## AI-slop warning

How AI misapplies this essay:

- **Substituting slop for slop**: asked for "an Inter alternative," models grab the nearest famous sans (Roboto, Open Sans, Work Sans, Montserrat, Helvetica Now) — fonts that mostly fail one or both criteria. The author's stat is the rebuttal: fewer than 1 in 3 neo-grotesks pass; assume unvetted fonts fail.
- **Nudge-padding as a reflex**: when a label sits low, the slop response is per-size asymmetric padding or a `translateY(1px)` — the exact anti-pattern the source shows. The correct response is a font-metrics fix (or `text-box-trim`), never a positional patch.
- **Treating "clean sans-serif" as a spec**: the quote to internalize — "'just pick a clean sans-serif' isn't enough—most of them will quietly cost you alignment work."
- **Over-reading the table**: the article ranks by two numbers only. It does not license the claim that, e.g., Akkurat "feels more technical" — inventing per-font personality profiles the source never states is its own slop. Verify tone with eyes on the specimen, at real UI sizes.

## Relations

- `desengs-practical-typography` — the operational layer this essay skips: pairing display and text faces, line length, leading, hierarchy sizes. Use it after this skill picks the font.
- `desengs-taste` — why escaping a monoculture default is a taste decision, and how to change defaults deliberately rather than by fashion; frames when staying on Inter is the tasteful call.
- `desengs-calvez-typography` — sibling essay on typography-driven design; complements the metrics-first method here with composition-level typographic judgment.
- `desengs-web-interface-guidelines` — where the chosen font lands: baseline grid, spacing tokens, and control sizing that assume labels center correctly.
