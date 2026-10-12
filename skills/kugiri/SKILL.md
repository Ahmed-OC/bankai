---
name: kugiri
description: Use when splitting text into lines, words, or chars for staggered reveals. Reads the browser's own painted line breaks via Range rects, writes inert units, then stops — animation, resize, and re-splitting stay yours.
source: https://edoardolunardi.github.io/kugiri/
category: tool
---

# kugiri — the art of division in interfaces

Source: https://edoardolunardi.github.io/kugiri/ — Edoardo Lunardi. A dependency-free ES2022 module (`npm install kugiri`, ~7.6 kB min+gzip, MIT) plus a ~50-case specimen page. Scope check: despite the broad title, kugiri (区切り, "the point where one segment ends and the next begins") is about one division only — cutting rendered text into lines/words/chars at the exact points the browser already broke it. It says nothing about page-level whitespace, `<hr>`s, or ma; do not use it as authority for those.

## What it is / Why it exists

`splitText(target, options?)` splits a text target in place and returns a `TextSplit` (`lines`, `words`, `chars`, `masks`, `revert()`). It exists because every other splitter (GSAP SplitText included) pre-wraps words in inline-block boxes and infers lines from word tops — which changes the layout it is trying to measure. Hyphenated and overflow-broken words come back with phantom extra lines; whitespace-only layouts (`pre-line`) collapse; Japanese (no spaces) splits on the wrong character. kugiri's fix: measure the untouched paint, then write. It is the tool to reach for when a per-line reveal must match what the user actually sees.

## The core ideas

### 1. Division is the browser's job

The splitter never decides where a line breaks; the browser did that already. kugiri finds the line boxes the browser painted, the words and graphemes inside them, and nothing else. Mechanism: `Range.getClientRects()` over the original text nodes — because "no box can move a wrap." If you pre-wrap before measuring, the wrap you measured is yours, not the browser's. Group word rects into lines by rounded `top` (±1 px), not by inference from offsets.

### 2. The split stops at the split

The library writes the units and stops: no animation, no watching the viewport, the fonts, or the text. A split is a snapshot of one layout. Everything downstream — reveal, resize re-split, translation handling — is the caller's job, and the site shows those as plain examples, not shipped code. When you build this by hand, keep the same seams: one function that reads and writes units, separate code that animates them.

### 3. Units are classified by layout, not tag

- Inline elements are cut into: a link spanning two lines is cloned per line (its `id` is duplicated — a documented caveat), inline styles inherited; no empty clones.
- Inline-blocks, replaced elements (media, buttons, tables — "they are not text"), ruby, flex/grid rows stay whole; inline ones ride along as one word.
- Floats and drop caps are not units: repositioned before their line block at the same top, never moved by the reveal.
- `ignore` selector: matched elements are never cut into, never wrapped, never a unit (chips, footnote marks).
- Closed `<details>` bodies and hidden content are untouched.
- `::first-line` styles are restated on the first line block; a styled `::first-letter` on the glyph itself — because those pseudo rules no longer match once real elements wrap the text.

### 4. Words and chars: what breaks

- Words become `display: inline-block` units, punctuation attached.
- Chars: one unit per grapheme cluster (`Intl.Segmenter` — Chrome 87, Safari 14.1, Firefox 125; fallback to code points breaks emoji like 🧑‍🎨, 👍🏽, Zürich). Kerning between letters is lost — inherent to a char split; don't fight it.
- Breaking inside words is honored: `overflow-wrap: anywhere` cuts land where the paint broke; `hyphens: auto` soft hyphens get the drawn hyphen restated; a broken word becomes two units; a `<wbr>` is never a piece.
- Scripts: Japanese wraps between characters — use `Intl.Segmenter` for words, never split on spaces; RTL (Arabic) keeps rag on the left with reveal following reading order; `writing-mode: vertical-rl` lines are columns read right-to-left.

### 5. Masks need reach, and must be cleared at rest

A mask is a clipping wrapper (`clip-path: inset(0)`, inline) a line can slide out from. Set reach past the line box — `{ lines: ".25em" }` — so descenders (g/y/p) and accents ride with their line. After the animation finishes, set `clipPath = "none"` on every mask: "A mask clips at rest too (descenders, focus rings)."

### 6. The DOM is the API

Units get `data-line`/`data-word`/`data-char` indexes plus matching `--line`/`--word`/`--char` custom properties; masks get `data-mask`; the target gets `data-split` and `--lines`/`--words`/`--chars` counts. Indexes count in document order, so CSS alone can stagger (`calc(var(--word) * 30ms)`) or reverse-stagger (`calc((var(--words) - var(--word)) * 30ms)`). Every line carries `translate="no"` so page translators don't rewrite boxed words lazily; to translate: `revert()`, restore source `innerHTML`, let the translator run, re-split (watch the root's `lang` attribute).

### 7. Read everything, then write everything

One read phase, one write phase, no forced reflow. Batching multiple targets: every target is planned before any is written, so a whole page costs the layout of one target (~10 ms for a 2,000-word article into lines). Looping `splitText` per element instead forces a layout per element. `revert()` restores the original markup but loses state/listeners added between split and revert.

## Replicate it by hand (the mechanism)

For a single heading, you don't need the library — the core is ~30 lines:

```js
async function splitLines(el) {
  await document.fonts.ready;                    // fonts change every wrap
  const words = [];
  const w = document.createTreeWalker(el, NodeFilter.SHOW_TEXT);
  let n;
  while ((n = w.nextNode()))
    for (const m of n.data.matchAll(/\S+/g)) {   // READ: measure the paint
      const r = document.createRange();
      r.setStart(n, m.index); r.setEnd(n, m.index + m[0].length);
      words.push({ n, start: m.index, end: m.index + m[0].length,
                   rect: r.getBoundingClientRect() });
    }
  const lines = [];                              // GROUP: by rounded top
  for (const word of words) {
    const top = Math.round(word.rect.top);
    const last = lines.at(-1);
    (last && Math.abs(last.top - top) <= 1 ? last.words : lines.push({ top, words: [] }) && lines.at(-1)).words.push(word);
  }
  // WRITE: block-ify each line so layout cannot move; wrap words as units
  for (const { words } of lines.reverse()) {
    const line = document.createElement("span");
    line.style.display = "block";
    line.dataset.line = el.querySelectorAll("[data-line]").length;
    words.at(-1).n.splitText(words.at(-1).end);   // cut text nodes at seams
    words.at(0).n.splitText(words.at(0).start);
    const frag = document.createRange();
    // wrap [start..end] of the (now isolated) nodes into `line`, in order
    // ... append line where the first word was; give it translate="no"
  }
  return [...el.querySelectorAll("[data-line]")];
}
```

The hard 20% the library owns: cloning inline ancestors per line, restating `::first-line`/`::first-letter`, hyphen and `<wbr>` handling, `Intl.Segmenter` graphemes, scale-aware measurement (rects measured at the ancestor's scale, units written unscaled; rotation/skew unsupported), WebKit's ~1 px rect error. Install kugiri when you hit two or more of those; hand-roll only the trivial case.

## The reveal patterns (examples, not shipped code)

WAAPI, matching the source's numbers:

```js
lines.forEach((line, i) =>
  line.animate(
    [{ transform: "translateY(100%)", opacity: 0 },
     { transform: "none",           opacity: 1 }],
    { duration: 1000, delay: i * 30,
      easing: "cubic-bezier(0.23, 1, 0.32, 1)", fill: "backwards" })
    .finished.then(() => masks.forEach(m => (m.style.clipPath = "none"))));
```

`fill: "backwards"` — hidden until its turn, at rest when done. CSS-only variant: split to words, set `target.dataset.revealed = ""`, then:

```css
[data-revealed] [data-word] {
  display: inline-block;
  animation: rise 0.8s cubic-bezier(0.23, 1, 0.32, 1) both;
  animation-delay: calc(var(--word) * 30ms);
}
@keyframes rise { from { translate: 0 0.6em; } }
```

Resize re-split: watch the target's inline size with a `ResizeObserver`; ignore height-only changes ("a taller viewport moves no wrap"); debounce ~150 ms (`cancelAnimationFrame`/`requestAnimationFrame` or `setTimeout`); `revert()` then re-split then re-reveal.

## When to use / When NOT to use

Use when: a heading, hero, or label needs a per-line/per-word reveal that must match the actual wrap; text animates inside `text-wrap: balance` / `pretty`, hyphenated, Japanese, RTL, or `pre-line` content; you need to translate or resize safely after splitting.
Skip when: the text doesn't animate — splitting adds thousands of nodes for nothing. Skip char splits unless the design demands per-glyph motion (kerning loss, `aria-label` on the target + `aria-hidden` on units required). Don't split before `document.fonts.ready`. Vs GSAP SplitText (3.15.0, 3.7 kB gzipped): kugiri wins on hyphens, overflow-broken words, Japanese, whitespace fidelity, and read-then-write batching; SplitText ships resize/font-load re-split, aria handling, and custom delimiters that kugiri deliberately leaves to you.

## How to apply

1. Ask first: does this text animate per unit? No → no split.
2. `await document.fonts.ready` before splitting.
3. Read all rects first (Range over untouched text nodes), group by rounded top ±1 px, only then write wrappers.
4. Batch: plan every target, then write — never split in a per-element loop.
5. Choose the coarsest unit that carries the design: lines > words > chars.
6. Masks: `clip-path: inset(0)` with `.25em` reach; clear to `none` on `finished`.
7. Stagger via `--word`/`--line` custom properties (30 ms/unit, `cubic-bezier(0.23,1,0.32,1)`, `fill: "backwards"`), not via per-element JS timers.
8. Wire re-split: ResizeObserver on inline size, ~150 ms debounce, revert → split → re-reveal.
9. On translated pages: revert before translating, re-split after; keep `translate="no"` on lines.
10. Char splits: `aria-label` the target, `aria-hidden` the units.
11. Never keep a split at rest that exists only for the animation — `revert()` when done if state matters.

## AI-slop warning

The masked per-line rise became a signature AI-hero cliché: every `<h1>` translateY(100%)-ing in on load, 30 ms apart, on marketing pages that animate once and never again. kugiri's own thesis is the antidote — it refuses to be an animation library. The other classic misapplication: splitting to chars by default (kerning destroyed, screen readers read letter soup, translators mangle it) and leaving masks clipping at rest so descenders and focus rings get cut. Also common: splitting before fonts load (wrong lines), re-splitting on height-only resizes (wasted work), and keeping dead split markup in static pages. Split only what moves; read the browser's breaks, don't invent them.

## Relations

- `transitions` — choreography layer this skill omits on purpose: sequencing, staggers, scroll-triggering.
- `easing` — the curve family behind `cubic-bezier(0.23,1,0.32,1)` and when to deviate from it.
- `you-dont-need-animations` — the restraint check: run it before splitting anything.
- `web-interface-guidelines` — the a11y baseline (aria-label/aria-hidden, focus rings that masks clip) that split text must still satisfy.
- `devouring-details` — same craft register: details that separate competent from copied work.
