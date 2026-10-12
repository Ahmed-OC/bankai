---
name: calligraph
description: Use when displayed text or numbers change in place — labels, prices, counters, step names — and must transition fluidly: shared characters slide, new ones enter, old ones exit, digits roll.
source: https://calligraph.raphaelsalaja.com; https://github.com/raphaelsalaja/calligraph
category: library
---

# Calligraph — fluid text transitions: shared characters slide, changed ones enter and exit

Source: https://calligraph.raphaelsalaja.com — docs site, lab playground, and compare page by Raphael Salaja (author of ui.wiki; also behind audio-kit). GitHub monorepo `raphaelsalaja/calligraph`, npm `calligraph` v1.4.1, MIT, ~9 KB unpacked, zero runtime dependencies (peers: React >= 18, Motion >= 11). Despite the name, it is NOT handwriting/stroke-drawing animation — it animates text *changes*.

## What it is / Why it exists

A single React component, `<Calligraph>`, that animates the transition when a string or number changes. The gap it fills: React re-renders changed text as an instant swap (or a naive crossfade) because every character is a new DOM node with a new key. Calligraph instead gives characters *persistent identity across renders*, so:

- characters common to old and new string physically slide to their new positions (`layout` animation);
- newly added characters enter (fade + blur + scale from an offset);
- removed characters exit (mirror of enter);
- digits optionally roll odometer-style, respecting whether the value went up or down.

Inspired by Torph, NumberFlow (barvian), NumericText, and Family.co; spring presets copied from SwiftUI. Motivation (author's changelog): make small edits subtle (a single changed digit barely moves) while full rewrites spread dramatically — motion proportional to semantic change.

## The core ideas

1. **Grapheme-safe splitting.** Text is split with `Intl.Segmenter(undefined, { granularity: "grapheme" })`, never `split("")` — emoji, combining marks, and CJK stay whole. Any char-diff animation you write must do the same or you will animate half a surrogate pair.

2. **LCS key reconciliation (the signature trick).** On each change, compute the longest common subsequence between old and new grapheme arrays (O(n²) DP; fine for labels, poison for paragraphs). Matched graphemes inherit the previous grapheme's React key → React/Motion treats them as the *same* element and slides them via `layout="position"` under `AnimatePresence mode="popLayout"`. Unmatched graphemes get fresh keys → enter/exit animations fire. Animation identity comes from *diffing*, not from animating the string wholesale.

3. **Change ratio scales the drama.** `changeRatio = (added + removed) / max(oldLen, newLen)`. Drift offsets and trend offsets are multiplied by it: "3:59 → 4:00" nudges; "Hello → Goodbye" spreads. Steal this: motion amplitude proportional to edit distance reads as intentional, not decorative.

4. **Enter/exit recipe (text variant), exact values.** Enter: `opacity 0 → 1`, `filter blur(4px) → blur(0)`, `scale 0.85 → 1`, plus a drift offset `x = (i/(n-1) - 0.5) * driftX * changeRatio` (default `driftX = 15px`, `driftY = 0`). Exit mirrors it. Characters are `display: inline-block; white-space: pre` spans (so spaces keep width). `trend: 1 | -1 | 0` adds `±8px * changeRatio` vertical bias — enter from below on upticks, from above on downticks.

5. **Animation presets (from source, use these numbers):**
   - `default` (text): duration `0.38s`, ease `cubic-bezier(0.19, 1, 0.22, 1)`
   - `smooth`: spring, duration `0.4`, bounce `0`
   - `snappy` (number default): spring, duration `0.35`, bounce `0.15`
   - `bouncy`: spring, duration `0.5`, bounce `0.3`
   - Stagger: `0.02s` per character by position.

6. **Number variant — rolling digits without a reel.** Leading non-digits (`$`, `-`, `€`) are matched positionally and never animate (stable keys, layout-slide only — fixed in v1.1.2). Digits are right-aligned and matched positionally, so only digits whose value changed re-key. Changed digits enter from `y = ±8px` where the sign is `Math.sign(newValue - oldValue)`, with `blur(2px)`, `scale 0.5 → 1`. Column keys are right-anchored (`col-<index from right>`), so growing "$9 → $10" adds a column on the left without re-keying existing ones.

7. **Slots variant — a true odometer.** Each column renders all 10 digits absolutely stacked; a single cumulative motion value per column (monotonic, never resets) drives each digit's `y` via a mod-10 shortest-path offset clamped to ±1 cell (`-100%`/`0`/`+100%`). Result: continuous roll in the correct direction, no per-digit mount/unmount. Column width comes from a hidden `0` placeholder. Edges fade via a container mask: `linear-gradient(to bottom, transparent 0%, black 0.25em, black calc(100% - 0.25em), transparent 100%)`. Stagger runs right-to-left across columns; exiting columns roll out by `max(digit, 1)` steps.

8. **Auto-size width animation.** A `ResizeObserver` measures the content (`Math.ceil(contentRect.width)`) and the wrapper animates its `width` with the same transition — surrounding text doesn't reflow in one jump when a value grows from "$9" to "$10". Default on.

9. **Prop applicability is per variant — do not cargo-cult.** `drift` and `trend` only affect `variant="text"`; `stagger` affects all (text: per grapheme by position; number: per digit; slots: per column, applied right-to-left). `animation` defaults to `default` for text, `snappy` for number and slots. Wrapper is `display: inline-flex; position: relative`, element type overridable via `as`.

## When to use

- Values that change in place and deserve continuity: prices, totals, countdowns, scores, portfolio/asset values (number/slots).
- Short labels whose swap reads as a hard cut: stepper/step names, segmented-control labels, tab titles, form step headers, quiz answers, rotating headline word (text).
- Personalized or celebratory moments: name in an empty state, reward/confetti-adjacent counters.
- Anywhere you already ship Motion and want ~3 KB of reconcile logic you'd otherwise hand-write badly.

## When NOT to use

- Body text, paragraphs, long strings: O(n²) LCS plus one `motion.span` per grapheme — a 200-char paragraph is 200 layout-animated nodes. Cap at headline/label lengths (< ~40 chars).
- Static text or text that changes once per pageview — the cost buys nothing; plain text wins.
- Repeated decorative titles across a page (the slop case, below).
- You don't already use Motion: the peer dep is the real weight; a WAAPI/FLIP implementation (below) is dependency-free.
- Live tickers updating faster than ~1 change/400ms — springs never settle; you stack mid-flight animations. Throttle to the animation duration.
- A11y-sensitive numeric reads: every animated character is `aria-hidden` and the wrapper carries no accessible name — you must add `aria-label` yourself or screen readers announce little (number variant: only the `$`). No built-in `prefers-reduced-motion` gate; wrap in `<MotionConfig reducedMotion="user">` or conditionally render static text.

## How to apply (mechanism first, then checklist)

Recreate the text variant in plain JS + CSS (FLIP). This is the whole idea in ~40 lines:

```html
<span id="swap" aria-label="Goodbye">Hello</span>
<style>
  .ch { display: inline-block; white-space: pre; }
  .ch.enter { animation: ch-in .38s cubic-bezier(.19,1,.22,1) backwards; }
  .ch.exit  { animation: ch-out .25s cubic-bezier(.19,1,.22,1) forwards; position: absolute; }
  @keyframes ch-in  { from { opacity: 0; filter: blur(4px); transform: scale(.85) translateX(var(--dx)); } }
  @keyframes ch-out { to   { opacity: 0; filter: blur(4px); transform: scale(.85) translateX(var(--dx)); } }
  @media (prefers-reduced-motion: reduce) { .ch.enter, .ch.exit { animation: none; } }
</style>
<script type="module">
const seg = new Intl.Segmenter(undefined, { granularity: "grapheme" });
const split = (s) => [...seg.segment(s)].map((x) => x.segment);

function lcsPairs(a, b) { // [oldIdx, newIdx] of common subsequence
  const dp = Array.from({ length: a.length + 1 }, () => new Uint16Array(b.length + 1));
  for (let i = a.length - 1; i >= 0; i--) for (let j = b.length - 1; j >= 0; j--)
    dp[i][j] = a[i] === b[j] ? dp[i + 1][ j + 1] + 1 : Math.max(dp[i + 1][j], dp[i][j + 1]);
  const pairs = []; let i = 0, j = 0;
  while (i < a.length && j < b.length) {
    if (a[i] === b[j]) pairs.push([i++, j++]);
    else dp[i + 1][j] >= dp[i][j + 1] ? i++ : j++;
  }
  return pairs;
}

const host = document.getElementById("swap");
let chars = split(host.textContent).map((c, i) => ({ c, id: i })); // persistent ids

function transition(text) {
  const next = split(text);
  const map = new Map(lcsPairs(chars.map((x) => x.c), next).map(([o, n]) => [n, chars[o].id]));
  const changed = (next.length + chars.length - 2 * map.size) / Math.max(next.length, chars.length, 1);

  // measure old positions (First), swap DOM (Last), invert, play
  const oldRects = new Map([...host.children].map((el) => [el.dataset.id, el.getBoundingClientRect()]));
  host.innerHTML = "";
  next.forEach((c, i) => {
    const el = document.createElement("span");
    el.className = "ch"; el.textContent = c; el.dataset.id = map.get(i) ?? `n${i}-${Date.now()}`;
    const kept = map.has(i);
    if (!kept) {
      el.classList.add("enter");
      el.style.setProperty("--dx", `${(i / Math.max(next.length - 1, 1) - 0.5) * 15 * changed}px`);
      el.style.animationDelay = `${i * 0.02}s`;
    }
    host.append(el);
    const prev = oldRects.get(el.dataset.id);
    if (prev) { // Invert + Play shared characters
      const dx = prev.left - el.getBoundingClientRect().left;
      el.animate([{ transform: `translateX(${dx}px)` }, { transform: "none" }],
        { duration: 380, easing: "cubic-bezier(.19,1,.22,1)", delay: i * 20 });
    }
  });
  chars = next.map((c, i) => ({ c, id: map.get(i) ?? -1 - i }));
}
</script>
```

For rolling digits (number or slots variant) in plain code, one strip per digit column plus a cumulative counter — the counter never resets, so wrap-around and direction come free:

```html
<span class="reel" aria-label="35.99"><span class="strip">0123456789</span></span>
<style>
  .reel { display: inline-block; height: 1em; overflow: hidden;
          mask: linear-gradient(to bottom, transparent 0, #000 .25em, #000 calc(100% - .25em), transparent); }
  .strip { display: block; transition: transform .35s cubic-bezier(.19,1,.22,1); }
  .strip span { display: block; height: 1em; line-height: 1; }
</style>
<script type="module">
const strip = document.querySelector(".strip");
const mod10 = (n) => ((n % 10) + 10) % 10;
let cum = 3; // cumulative counter per column: 9 -> 0 counts UP (9 -> 10 -> ...), never back
function roll(digit, direction) { // direction = sign(newValue - oldValue)
  if (direction > 0) cum += ((digit - mod10(cum)) + 10) % 10 || 10;
  else cum -= ((mod10(cum) - digit) + 10) % 10 || 10;
  strip.style.transform = `translateY(${-cum}em)`; // digits stacked 1em apart
}
</script>
```

Right-align the columns and key them from the right (`col-0` is the units column) so a digit-count change inserts a column on the left without disturbing the others.

Installing the real package is justified when: you're on React >= 18 + Motion >= 11 already, you need grapheme safety + LCS + right-anchored digit columns + auto-size handled and tested, and you'd rather configure than debug. API surface to use it well: `variant` (`"text" | "number" | "slots"`), `animation` (`"default" | "smooth" | "snappy" | "bouncy"`), `drift { x, y }`, `trend` (`1 | -1 | 0`), `stagger` (s), `initial` (animate on first mount; default `false` — keep it off for above-the-fold text), `autoSize`, `onComplete` (fires when the last character settles), `as` (wrapper element).

Decision checklist when asked to animate changing text or numbers:

1. Will the user *see* the change (same element, in-place update)? No → plain text, stop.
2. Is it <= ~40 characters? No → animate only the summary line, not the body.
3. Pick variant: words/labels → `text`; prices/counters → `number`; celebratory or game-like values → `slots` (highest cost, highest charm — use at most once per view).
4. Pick motion: `default` (0.38s ease) for UI chrome; `snappy` spring for numbers; reserve `bouncy` for rewards.
5. Set direction semantics: `trend` (or digit direction) must follow the sign of the value change — up enters from below. Getting this backwards reads as a bug.
6. Add the accessible name: `aria-label` with the final string on the wrapper; every animated glyph is `aria-hidden`.
7. Gate motion: `<MotionConfig reducedMotion="user">` at the app root, or a `matchMedia('(prefers-reduced-motion: reduce)')` branch that renders static text.
8. Throttle updates to >= 1 per 400ms per element so springs settle between changes.
9. Keep `initial` false for first paint; enable only for a deliberate one-time entrance.
10. Verify layout around the value: growing strings must animate width (auto-size or measured FLIP), or neighbors jump.

## AI-slop warning

This look became a cliché the moment every AI-generated dashboard shipped a slot-machine odometer for every stat card and a blur-staggered letter cascade for every hero word. It poisons: dashboards where numbers roll on every poll (motion noise → users stop reading values), nav/labels that dance on each route change, mount-animation of long strings (jank + layout thrash), and — worst — `aria-hidden` characters with no `aria-label`, deleting the value from assistive tech. Defaults exist to be boring: keep `drift` at 15px, `stagger` at 20ms, one animated element per viewport region, `initial={false}` on first paint, and never animate text the user hasn't seen change.

## Relations

- **number-flow** — the mature React counter (formatting, `Intl.NumberFormat`, trend, transform timing); choose it over Calligraph's number/slots variants when formatting depth matters, Calligraph when you want the text variant and one tiny API for both.
- **torph** — Calligraph's direct inspiration for text transitions; compare mechanisms before picking either.
- **easing** — supplies the why behind the preset numbers used here (0.38s, `cubic-bezier(0.19,1,0.22,1)`, bounce 0/0.15/0.3) and when springs beat duration-based curves.
- **ui-wiki** — same author's rule collection; this library is those motion rules codified.
