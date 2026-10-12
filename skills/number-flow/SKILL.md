---
name: number-flow
description: Use when a displayed number, price, total, or timer changes at runtime and should transition instead of popping. Digit-column odometer physics, FLIP width morphing, and screen-reader-safe values.
source: https://number-flow.barvian.me/
category: library
---

# NumberFlow — animated numbers that respect content

Source: https://number-flow.barvian.me/ (docs at `/vanilla`; repo github.com/barvian/number-flow). By Maxwell Barvian, MIT. "An animated number component. Dependency-free. Accessible. Customizable." Heavily inspired by the Family app; digit-looping technique from Sam Selikoff, mask technique from Artur Bień. Ships as one custom element (`<number-flow>`, shadow DOM) with thin React/Vue/Svelte wrappers.

## What it is / Why it exists

When a value changes, UI convention animates the change — but numbers are usually just swapped, an audible "pop" in an otherwise fluid interface. NumberFlow's premise: a changing number is a *layout and content transition like any other*, so it deserves the same physics: digits roll the short way, commas and symbols fade in/out, the whole number stretches to its new width, and the screen reader still gets the final value instantly. It is an odometer, not a counter tween — it never shows intermediate fake values (unless you ask via the `continuous` plugin).

## The core ideas

### 1. Each digit is a full vertical column, not a tween

Every digit position renders all its possible glyphs stacked (0–9 by default, `length = max + 1`). Only the current glyph is non-`inert`. "Spinning" a digit means translating the column so a different glyph lands in place — real odometer physics: 9→0 passes through the wrap, neighbors are visible entering/leaving via edge masks.

### 2. One animatable custom property drives each column; CSS does the math

Register the property (so it can animate), then let CSS `mod()` pick each glyph's offset. JS animates exactly one variable per digit with the Web Animations API and `composite: 'accumulate'` (so interruptions compose instead of jumping):

```css
@property --d { syntax: '<number>'; inherits: true; initial-value: 0; }

.digit { --c: calc(var(--current) + var(--d)); }
.digit__num {
  --offset-raw: mod(var(--length) + var(--n) - mod(var(--c), var(--length)), var(--length));
  --offset: calc(var(--offset-raw) - var(--length) * round(down, var(--offset-raw) / (var(--length) / 2), 1));
  --y: clamp(-100%, var(--offset) * 100%, 100%);
  transform: translateY(var(--y));
}
```

```js
// delta computed so digits always roll the SHORT way around the loop:
// trend < 0 && value > prev  → delta = value - length - prev   (wrap down)
// trend > 0 && value < prev  → delta = length - prev + value   (wrap up)
digit.animate({ '--d': [-delta, 0] }, { duration: 900, easing: 'linear(...)', composite: 'accumulate' })
```

Feature-detect before using: needs CSS `mod()`, `linear()` easing, and `CSS.registerProperty` — NumberFlow calls this `canAnimate` and renders statically otherwise.

### 3. Odometer direction is a design decision: `trend`

Default `(old, val) => Math.sign(val - old)`. `+1` = digits always roll up (monotone counters, uptime). `-1` = always down (countdowns, stock tickers). `0` = each digit takes its own shortest direction — use when the change must NOT read as "went up" or "went down" (e.g. reshuffled IDs). Direction is semantics, not decoration.

### 4. Width changes morph; glyphs never distort

A number gaining a digit or comma changes width. FLIP it: measure width + left edge before the DOM update, again after, then animate `--dx` and a width delta on the container while the *inner* element runs the exact inverse transform:

```css
.number       { transform: translateX(var(--dx)) scaleX(calc(1 + var(--d-width) / var(--width))); }
.number__inner{ transform: scaleX(calc(1 / var(--scale-x))) translateX(calc(-1 * var(--dx))); }
```

Net effect: only the *spacing* between characters stretches; glyphs stay crisp. Measure positions (sections at their justified edge, digits at their center) before mutating, animate `translateX(dx → 0)` after — classic FLIP, all with the same `composite: 'accumulate'` so rapid successive updates stack instead of thrashing.

### 5. Entering/exiting characters: presence fade + `inert`

Removed characters get `inert` (drops them from the a11y tree and hit-testing), are pinned `position: absolute; z-index: -1` at their measured spot, and fade out via an animated opacity delta (`.animate-presence { opacity: calc(1 + var(--d-opacity)) }`, animated `-0.9999 → 0`); the DOM node is removed on `animationsfinish`. Symbols like `+`↔`-` crossfade with `mix-blend-mode: plus-lighter` for smoother overlaps.

### 6. Edge masks make the drum readable

Gradient masks fade glyphs at the top/bottom (`--number-flow-mask-height`, default `.25em`) and left/right (`--number-flow-mask-width`, default `.5em`, also the padding), plus four corner radial gradients. `line-height: 1` controls roll spacing (NumberFlow's own site uses `0.85` for tighter drums).

### 7. Timings: three channels, springs as `linear()` curves

- `transformTiming` — all layout/FLIP transforms. Default 900ms with a hand-tuned 100-point `linear(...)` curve approximating a spring (springs can't be WAAPI easings, so bake them to `linear()` — generate at kvin.me/css-springs or easing.dev).
- `spinTiming` — digit rolls; falls back to `transformTiming`.
- `opacityTiming` — presence fades. Default 450ms `ease-out`.

### 8. A11y: one value, announced once, motion optional

The animated widget is `role="img"` with `ariaLabel` = the formatted final value (via `ElementInternals`) — screen readers hear "9,432", never a stream of rolling digits; do NOT put `aria-live` on it. `prefers-reduced-motion: reduce` skips all animation by default (`respectMotionPreference`). Animation is also skipped when the element is offscreen or the tab is hidden — and the measurement pass (a forced reflow) is skipped whenever animation can't run. `will-change` is opt-in (`data-will-change`), not default, because it costs memory.

### 9. SSR without a flash

`renderInnerHTML(value, { locales, format, prefix, suffix, nonce })` emits declarative shadow DOM; the first `update(sameValue)` hydrates — pass the identical value or it counts as a change. Inline styles take a CSP `nonce`, or hash the exported `styles` strings. `::part()` styles can flash in browsers without DSD support — gate them behind a `data-supports-dsd` attribute set via `HTMLTemplateElement.prototype.hasOwnProperty('shadowRootMode')`.

## Inventory (what the library actually provides)

`value` + `format` (`Intl.NumberFormatOptions`) + `locales`; `prefix`/`suffix` (vanilla: `numberPrefix`/`numberSuffix`); `trend`; `transformTiming`/`spinTiming`/`opacityTiming`; `animated` (false finishes in-flight animations); `isolate` (decouple from sibling layout changes); `digits` (`Record<position, { max }>` — makes 59→00 roll correctly on countdowns; per-position column length); `plugins: [continuous]` (rolls through in-between numbers; no effect at `trend: 0`); `willChange`; `nonce`; events `animationsstart`/`animationsfinish`; `<NumberFlowGroup>`/`<number-flow-group>` (syncs transitions of numbers whose positions depend on each other; renders nothing); `useCanAnimate()`/`canAnimate`; `renderInnerHTML`; `prefersReducedMotion`. Styling via `::part(prefix|suffix|number|integer|fraction|digit|symbol)` + the two mask variables. Known limits: no scientific/engineering notation, no non-Latin digits or RTL, backgrounds/borders on the number won't scale with it, and digit `font-size` is hard to change.

## When to use

- Values the user just caused or is watching: cart totals, checkout prices, tip calculators, amount inputs.
- Live-but-slow streams (≥ ~1 change per few seconds): dashboards KPIs, crypto/fx tickers, subscriber/viewer counts, vote tallies.
- Timers where rolling matters: countdowns (with `digits` so 59→00 wraps), stopwatches, auction clocks.
- Numeric deltas in marketing pages ("9,432 teams") revealed on scroll — one tasteful roll, once.

## When NOT to use

- Static numbers, or values that change once per session — animation must mark *change*, or it's noise.
- High-frequency updates (< ~300ms): rolls interrupt constantly and never settle; use a plain crossfade or nothing.
- Privacy-sensitive counts the animation makes conspicuous (profile view counts, small-group sizes).
- Fonts without tabular figures you can't switch — digits will shift sideways mid-roll.
- Locale needs outside `Intl` Latin digits, RTL, or scientific notation — unsupported.
- When you need the number's background/border to animate too — use a general layout-animation library instead.
- If you only need one animated number and already ship a layout/animation runtime (Motion, GSAP), don't add a web component for it — hand-roll the pattern below.

## How to apply

1. Set `font-variant-numeric: tabular-nums` and `line-height: 1` (tighten to ~0.85 for denser drums) on any animated number.
2. Format via `Intl.NumberFormat` options (`{ style: 'currency', currency: 'USD', trailingZeroDisplay: 'stripIfInteger' }`), not string concatenation — the formatter is what makes parts enter/exit correctly.
3. Choose `trend` deliberately: ±1 to assert direction, 0 when direction must stay neutral.
4. Timers/countdowns: set `digits` per position (e.g. tens-of-seconds `{ max: 5 }`) so wraps roll instead of pop.
5. Keep default 900ms transform / 450ms opacity; only generate custom spring `linear()` curves when the surrounding UI already uses that spring.
6. Numbers whose positions affect each other (price + "was" price) go in one group so FLIP measurements happen pre-change together.
7. Expose the final value to AT (role="img" + aria-label), respect reduced motion, and skip animation when offscreen or the tab is hidden.
8. SSR: render the same markup server-side and hydrate with the same value; nonce or hash the styles under CSP.
9. For change-signaling beyond the roll, pulse color with WAAPI on the host — `{ color: ['unset', '#34d399', 'unset'] }`, 300ms ease (green up / red down) — or pair with an arrow icon driven by the same sign you feed `trend`.
10. Opt into `will-change` only for numbers guaranteed to change frequently.

## Build a minimal version by hand

```html
<span class="nf" role="img" aria-label="9432"></span>
<style>
  .nf { display: inline-block; font-variant-numeric: tabular-nums; line-height: 1;
        -webkit-mask-image: linear-gradient(to bottom, transparent 0, #000 .25em,
          #000 calc(100% - .25em), transparent); }
  .nf .digit { display: inline-block; position: relative; width: 1ch; }
  .nf .digit span { position: absolute; inset: 0; } /* stacked 0..9 */
  /* mod() offset math from idea #2 goes here */
</style>
<script type="module">
  const host = document.querySelector('.nf')
  host.attachShadow({ mode: 'open' })
  const fmt = new Intl.NumberFormat('en-US')
  function render(value) {
    // split formatted string into keyed parts: digits keyed by position,
    // symbols (, $ %) keyed by value — reuse keys across renders.
  }
  function updateDigits(oldV, newV, trend = Math.sign(newV - oldV)) {
    host.shadowRoot.querySelectorAll('.digit').forEach((el, i) => {
      const prev = +el.dataset.v, next = +newV[i], len = 10
      let d = next - prev
      if (trend < 0 && next > prev) d = next - len - prev
      if (trend > 0 && next < prev) d = len - prev + next
      el.dataset.v = next
      el.animate({ '--d': [-d, 0] },
        { duration: 900, easing: 'linear(...)', composite: 'accumulate' })
    })
  }
</script>
```

That is the real shape of the library minus: FLIP width morphing, presence fades, grouping, SSR, and plugin hooks. If you need those *correctly* (interruption composition, DSD, CSP), install the library — it is dependency-free, ~7.7k-star battle-tested, and reimplementing the edge cases is the expensive part, not the roll.

## AI-slop warning

The slop move is applying this to *every* number because it looks alive: hero stats that roll on load, dashboard tiles that spin on every poll, five counters animating in the same viewport. Constant motion destroys the signal — a roll means "this just changed because of something", and when everything changes, nothing did. Second slop: shipping it without `tabular-nums` (sideways digit jitter), with `aria-live="polite"` on the host (screen-reader machine-gun), or at 2s durations so values are unreadable mid-read. Third: faking it with a JS tween that interpolates 100→1,234 and renders every intermediate value — that is a different (and usually wrong) semantic: it lies about the values passed through. If a number changes less than once per interaction, don't animate it.

## Relations

- `easing` — why the 900ms default is a spring baked to `linear()` and how to generate those curves; the timing channel split (transform/spin/opacity) applies to any multi-part transition.
- `transitions` — the FLIP measure-mutate-measure-animate pattern here is a specialization; read for the general rules of interruption-safe layout animation.
- `emil-skills` — Barvian explicitly credits Emil Kowalski's Animations on the Web course; the presence/exit patterns and timing taste are the same school.
- `you-dont-need-animations` — the counterweight for the slop case: when a number pop is more honest than a roll.
