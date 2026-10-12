---
name: desengs-torph
description: Use when a label, status, or formatted number changes in place (Copy to Copied, $1,204 to $1,318) and the swap must read as continuous motion, not an instant cut. Encodes grapheme-diff text morphing with place-value digits.
source: https://torph.lochie.me/; https://github.com/lochie/torph
category: library
---

# Torph (desengs) — morph text changes in place so state transitions read as continuous

Source: https://torph.lochie.me/ (v0.1.3) and https://github.com/lochie/torph — Lochie (@lochieaxon). A dependency-free animated text-morphing component for React, Vue, Svelte, and vanilla JS. MIT. Tagline: "Text continuity for interfaces on the web." The name and method come from Benji Taylor's "Family Values" essay (benji.org/family-values, 2024 — sibling skill `desengs-family-values`). Related projects the README itself cites: number-flow and easing.dev (same author ecosystem as `desengs-easing`).

## What it is / Why it exists

When button text swaps instantly ("Continue" → "Confirm"), users routinely miss that a significant state change happened. Benji's team answered with a native-app system that "leverages shared letters — such as the 'Con' in both words": unchanged characters stay put while the rest animate out/in, so the eye tracks *what changed* instead of re-reading the whole label. They applied it to evolving labels, to counts ("the number and text displayed on the button adjust effortlessly"), and even to commas that "shift visually from place to place as the number is inputted."

Torph ports that craft to the web as one component, `<TextMorph />`, and closes three gaps DIY versions usually miss:

1. **Text and numbers in one primitive** — place-value digit morphing is on by default, with currency symbols, separators, and signs traveling with their digit places.
2. **User-typed input** — caret matching (`cursorIndex`) so morphing an input's live value adds digits where you typed instead of renumbering columns.
3. **Framework parity** — same behavior in React, Vue, Svelte, and vanilla, zero dependencies.

## The core ideas

### 1. The continuity contract: never animate what did not change
Segment old and new text into graphemes (locale-aware — `segmentText(value, locale)`), diff them (`diffSegments` → segments that persist / enter / exit). Persisting segments keep their DOM nodes and stay visually untouched. Only entering and exiting segments animate. This is the whole point: continuity of the unchanged part is what makes the change legible.

### 2. The default recipe (exact numbers)
- Duration: **400ms** (`duration`, default 400).
- Easing: **`cubic-bezier(0.19, 1, 0.22, 1)`** — a hard ease-out (expo-class) so new text arrives fast and settles.
- Exiting segments **scale down** (`scale`, default true) as they leave; entering segments animate in.
- Interrupt rule: a new morph mid-flight cancels the old one; **exactly one of `onAnimationComplete` / `onAnimationCancel` fires per morph**.
- `respectReducedMotion` defaults to **true**: honor `prefers-reduced-motion`, skip the morph.
- `as` defaults to `"span"`; `disabled: false`; `locale: "en"`; `debug` adds visual indicators.

### 3. Numbers morph by place value, symbols travel with their places
For any value containing a number (default `numbers: true`): digits slide along the **block axis** (vertically, in horizontal text — odometer style), and the symbols around them (currency, commas, signs, suffixes) travel with the places they belong to. Documented example: `1,204 → 1,318` rolls the hundreds and tens while the thousands digit stays put. Plain strings pass through `Intl` formatting when you feed the component a raw number: `<TextMorph decimals={2} locale="de-DE">{1234.5}</TextMorph>`. Set `numbers={false}` to force character-level morphing everywhere.

### 4. Typed input matches by caret, not by value
Place matching suits self-updating values (counters, totals, readouts). But if a user types `1` before `20`, place matching would renumber the columns instead of adding a digit. `cursorIndex` switches to caret matching: `<TextMorph cursorIndex={caret}>{value}</TextMorph>` (React) or `morph.update("$120", 2)` (vanilla — caret is the second argument). No Vue/Svelte prop exists because caret position is a DOM concern.

### 5. Springs when physics matter
`ease` accepts spring parameters instead of a CSS curve; duration is then derived from the spring, and `duration` is ignored. Defaults: `stiffness: 100`, `damping: 10`, `mass: 1`, `precision: 0.001` (settle threshold). Example: `<TextMorph ease={{ stiffness: 200, damping: 20 }}>`.

### 6. Layout mechanics the morph depends on
- Each animating grapheme must be its own inline-level box (`display: inline-block` or grid cell) or transforms/scale on exit won't apply — plain text nodes cannot be transformed.
- The container's width changes as segments enter/exit; let it transition (or set `min-width` from the longest expected state) or neighbors will jump horizontally mid-morph.
- Segment by **grapheme**, not UTF-16 code unit: emoji, combining accents, and CJK need `Intl.Segmenter` — a `[...str]` split breaks them and the diff produces garbage morphs.
- Odometer columns must clip (`overflow: hidden`) with a fixed line-height; fractional leading makes the roll wobble vertically.

### 7. Full inventory
- Component + `useTextMorph({ duration, ease })` hook (React, returns `{ ref, update }`); `TextMorph` per framework; vanilla class `new TextMorph({ element, ... })` with `.update(text, caretIndex?)`.
- Options: `text`/`children`, `duration`, `ease`, `scale`, `numbers`, `decimals`, `locale`, `cursorIndex`, `debug`, `disabled`, `respectReducedMotion`, `className`, `style`, `as`.
- Events: `onAnimationStart`, `onAnimationComplete`, `onAnimationCancel`.
- Multi-line: newlines render as breaks and morphing proceeds across them.
- Utilities for custom behavior: `segmentText(value, locale): Segment[]`, `diffSegments(oldSegments, newText, locale): DiffResult`.

## The mechanism in plain code

Minimal re-creation of the core effect — grapheme diff + Web Animations API (choices the source does not document are marked "pick"):

```js
const graphemes = (t, locale = "en") =>
  [...new Intl.Segmenter(locale, { granularity: "grapheme" }).segment(t)]
    .map(s => s.segment);

// Longest-common-subsequence of graphemes = the persisting set.
// Everything else in old = exit, everything else in new = enter.
function diff(old, next) {
  // standard LCS table over graphemes, then walk it:
  // persist = chars in the LCS (keep their DOM nodes, no animation)
  // exit    = old graphemes not in LCS
  // enter   = new graphemes not in LCS
  return { persist, exit, enter };
}

function morph(el, next, locale = "en") {
  const { persist, exit, enter } = diff(graphemes(el.dataset.text, locale),
                                        graphemes(next, locale));
  // render: persist spans untouched; wrap exit+enter in their own spans
  el.replaceChildren(...renderNodes(persist, exit, enter));
  el.dataset.text = next;

  const EASE = "cubic-bezier(0.19, 1, 0.22, 1)", D = 400; // torph defaults
  el.querySelectorAll(".exit").forEach(n => n.animate(
    [{ opacity: 1, transform: "none", scale: 1 },
     { opacity: 0, scale: 0.75 }], // scale-down on exit = torph default
    { duration: D, easing: EASE, fill: "forwards" }));
  el.querySelectorAll(".enter").forEach(n => n.animate(
    [{ opacity: 0, transform: "translateY(0.25em)", scale: 0.75 }, // slide pick
     { opacity: 1, transform: "none", scale: 1 }],
    { duration: D, easing: EASE }));
  if (matchMedia("(prefers-reduced-motion: reduce)").matches) return; // default on
}
```

Place-value digit morphing, odometer column in pure CSS — this is the "digits slide along the block axis" mechanism:

```html
<span class="place"><span class="stack"><span class="old">2</span><span class="new">3</span></span></span>
```

```css
.place { display: inline-block; overflow: hidden; /* clip the slide */ }
.place .stack {
  display: grid;               /* old on row 1, new on row 2 */
  transition: transform 400ms cubic-bezier(0.19, 1, 0.22, 1);
}
.place.morphed .stack { transform: translateY(-100%); } /* roll to new digit */
```

Separators/currency travel with places: render `$` and `,` as ordinary inline segments attached to the neighboring digit's column, not as their own morphing units — so when the hundreds roll, the comma to their left rides along.

**When installing torph is justified:** repeated state-driven text changes across a product (buttons, money, statuses) where you want consistent caret matching, spring support, interruption handling, multi-framework parity, and reduced-motion compliance for free. For a single one-off label, the ~60 lines above suffice.

## When to use / When NOT to use

Use when:
- A control's label encodes state: Copy → Copied, Continue → Confirm, Send → Sending.
- Formatted values tick: `$1,204` → `$1,318`, `12/30 items`, timestamps, step counters.
- Text width changes would cause layout jump; morphing keeps the eye on the change.
- Live preview of typed input where digits should insert at the caret (with `cursorIndex`).

Do NOT use when:
- Long copy, paragraphs, or fully-different strings — nothing persists, so you pay complexity for a generic crossfade.
- High-frequency updates faster than ~400ms (tickers, stopwatches) — every update cancels the last morph; use a purpose-built odometer or format-per-frame instead.
- Safety-critical or error text — those should change instantly and loudly; a 400ms morph softens urgency.
- Static labels — `disabled` exists, but then you are carrying a dependency for nothing.
- Pure numeric tickers with heavy formatting/perf needs — number-flow (sibling `desengs-number-flow`) is the specialized tool; torph wins when text and numbers mix.

## How to apply

1. Wrap only the changing span: `<TextMorph as="span">{label}</TextMorph>` — never morph whole paragraphs.
2. Keep defaults first (400ms, `cubic-bezier(0.19,1,0.22,1)`, `scale: true`, `numbers: true`); they encode the author's taste. Deviate only with a reason.
3. For money/counts, pass the formatted string (`toLocaleString`) or the number with `locale`/`decimals`; keep `numbers: true` so digits roll by place.
4. For morphing a controlled input's value, feed `cursorIndex={selectionStart}` on every change; otherwise skip it.
5. Reserve springs (`ease={{ stiffness: 200, damping: 20 }}`) for large hero numbers; 400ms curves for labels.
6. Leave `respectReducedMotion` on; verify the component still updates text with motion off.
7. If updates can outrun the animation, handle `onAnimationCancel` (or debounce the source) so state stays truthful.
8. Verify with `debug` enabled (visual indicators) that the diff persists what you expect — "Con" in Continue→Confirm must not animate.
9. QA pass: toggle the state 5x rapidly (morph must cancel cleanly, never stack), test with `prefers-reduced-motion: reduce` (text must still update), test the longest label state for wrapping/clipping, and for typed input confirm IME composition doesn't morph mid-composition.
10. Prototype the effect by hand (snippets above) before adding the dependency — install when the pattern appears in 3+ places.

## AI-slop warning

Since 2024 the morphing-label has spread from craft signal to cliché: dashboards where every stat blurs-and-rolls on any refresh, AI-generated landing pages that morph headlines on scroll, tickers that never stop moving. The effect only communicates when it marks a *significant, user-relevant* transition (Continue → Confirm) — morph everything and it signifies nothing while adding constant motion noise. Specific failure modes: morphing text the user is speed-reading (tables, lists); applying it during typing without caret matching (digits visibly renumber — the library's own documented trap); 600ms+ durations on rapid toggles so the label is permanently mid-morph; disabling reduced-motion support to "keep the vibe." If the text change is not an event the user should notice, do not morph it.

## Relations

- **desengs-family-values** — the origin essay: shared-letter morphing, label evolution, commas shifting place to place. Read for the *why*; torph is the web *how*.
- **desengs-number-flow** — specialized animated-number library torph's README cites; prefer it for pure numeric tickers, prefer torph when text and digits mix.
- **desengs-easing** — same author ecosystem (easing.dev, cited as related); source of the default curve's rationale and spring-parameter literacy.
- **desengs-transitions** — torph is the text-level instance of the general rule that identity persists while state animates.
- **desengs-you-dont-need-animations** — the counterweight: most text swaps should stay instant; torph must clear the bar that essay sets.
