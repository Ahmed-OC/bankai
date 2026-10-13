---
name: web-interface-guidelines
description: Use when building or auditing any web UI surface and applying micro-craft rules — touch targets, cursors, focus, forms, motion, keyboard, typography, performance — that make interfaces feel crafted, not generic.
source: https://interfaces.rauno.me/
category: principle
---

# Web Interface Guidelines — the concrete micro-craft rules that make an interface feel good

Source: https://interfaces.rauno.me/ (repo: github.com/raunofreiberg/interfaces) — Rauno Freiberg, "Web Interface Guidelines": a non-exhaustive, living list of the details that make a good web interface. Treat WAI-ARIA as the canonical accessibility reference. Every rule below is a concrete check + fix in plain CSS/JS (React where relevant) — mechanisms, not installs.

## What it is / Why it exists

Interfaces rarely fail at layout; they fail at the last 10% — dead touches, shifting text, spinners where an instant update belongs. This skill is that last 10% as verifiable checks: typography, layout, interaction feedback, accessibility, perceived performance, touch behavior.

- **Building** a new surface: apply each section as you write it. Craft is not a "polish pass" appended at the end.
- **Auditing** an existing screen: run the "How to apply" checklist, then fix everything in one batch.
- These are defaults, not laws — a deviation should be a deliberate choice, never an unexamined one.

## The core ideas

### 1. Typography & Content

**1.1 Antialiased font smoothing + legibility.** Check: `body` lacks `-webkit-font-smoothing`. Fix:

```css
body { -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; }
```

**1.2 Stop iOS landscape text inflation.** Without this, rotating the phone scales text up unpredictably.

```css
html { -webkit-text-size-adjust: 100%; }
```

**1.3 Never shift font weight on hover/selected states.** Check: any `:hover`/`.active` rule sets `font-weight`. It re-layouts text and shifts surrounding content. Fix: change `color`, `background`, or `border` instead — keep the weight constant.

```css
/* bad:  nav button:hover { font-weight: 700; } */
nav button:hover { color: var(--text); background: var(--panel); } /* weight unchanged */
```

**1.4 No font weights below 400.** Light weights (300 and under) render thin and shaky at small sizes, especially on dark backgrounds.

**1.5 Medium headings.** Headings read best at weights 500–600. Reserve 700+ for small emphasis (badges, status pills), not titles.

**1.6 Fluid sizes with `clamp()`.** Check: heading sizes are fixed `px` and jump at breakpoints. Fix:

```css
h1 { font-size: clamp(28px, 5vw, 48px); } /* min, fluid, max */
```

**1.7 Tabular numerals.** Shifting digits look broken in tables, timers, dates, counters. Fix:

```css
.timestamp, .meta, .counter { font-variant-numeric: tabular-nums; }
```

**1.8 Subset fonts** to the languages actually served (e.g. `latin` + `latin-ext`). A full Unicode font wastes hundreds of KB for glyphs never rendered.

**1.9 Style text selection.** The default blue selection clashes with a custom palette, and gradient text must drop its gradient inside `::selection` (re-apply a solid color) or selected letters become unreadable:

```css
::selection { background: #3b4fd8; color: var(--text); }
```

### 2. Layout, Spacing & Touch Targets

**2.1 Hit area ≥ 44×44 px.** Touch targets below ~44 px fail on touchscreens. Grow the interactive area (padding, or a `::after` overlay), not the visual glyph: a 20 px icon button carries transparent padding out to 44 px, and adjacent targets keep separation.

**2.2 Cursor matches semantics.** `cursor: pointer` on interactive elements (buttons, links, clickable rows); `default` on plain surfaces; `text` only over selectable text; `grab`/`grabbing` on drag handles. A click target showing the text cursor — or text showing the pointer — is a bug.

**2.3 Kill gaps in lists; enlarge padding instead.** Gaps between list rows break the hover/selection surface and visual continuity (card grids are exempt — this rule targets continuous lists). Check: a vertical list uses `gap` between interactive rows. Fix:

```css
/* bad: .item + .item { margin-top: 14px; } */
.list { gap: 0; }
.item { padding: 14px 0; border-bottom: 1px solid var(--border); }
```

**2.4 Input decorations overlay the field.** Icons belong absolutely positioned inside the input with padding, not flexed beside it — and clicking them must focus the field.

```css
.field { position: relative; }
.field > svg { position: absolute; left: 12px; top: 50%; translate: 0 -50%; pointer-events: none; }
.field input { padding-left: 36px; }
```

**2.5 Smooth anchor scrolling with offset.** Check: in-page links jump instantly and targets hide under the header.

```css
html { scroll-behavior: smooth; } section { scroll-margin-top: 80px; }
```

### 3. Forms & Interaction Feedback

**3.1 Labels focus their input.** Check: clicking the visible label does nothing. Fix: associate or wrap.

```jsx
<label>Quantity <input type="number" /></label>
```

**3.2 Wrap inputs in a `<form>`** so Enter submits, and use correct `type` attributes (`email`, `password`, `url`) plus native validation via `required`.

```jsx
<form onSubmit={submit}><input type="url" name="website" required placeholder="https://…" /></form>
```

**3.3 Turn `spellcheck` and `autocomplete` off most of the time** — IDs, color codes, slugs, tokens. Keep them for prose fields (briefs, prompts).

```jsx
<input spellCheck={false} autoComplete="off" />
```

**3.4 Toggles apply instantly.** Switches and checkboxes commit on tap — never behind an "Apply"/"Confirm" step.

**3.5 Disable the submit button after submission** to prevent duplicate network requests.

```jsx
<button disabled={pending}>{pending ? "Generating…" : "Generate"}</button>
```

**3.6 Disable `user-select` inside interactive elements** — dragging across buttons/chips/cards should not start a text selection.

```css
button, .chip, .card, .badge { user-select: none; }
```

**3.7 Decorative visuals never intercept clicks.** Glows, gradients, blurred blobs sit `pointer-events: none` or they swallow taps meant for content beneath.

```css
.glow, .decor { pointer-events: none; }
```

**3.8 Open dropdowns on `mousedown`** (or `pointerdown`), not `click` — the menu appears the instant the press registers, not after release.

**3.9 Optimistic updates with rollback.** Update the UI immediately; on server error, roll back and explain. Never leave the user watching a spinner for a rename or delete.

```jsx
const snapshot = items;
setItems(items.filter(i => i.id !== id));   // optimistic
try { await api.remove(id); } catch { setItems(snapshot); setError("Delete failed."); }
```

**3.10 Feedback lives next to its trigger.** A copy action shows a brief inline checkmark (`{copied ? "✓ Copied" : "Copy"}`) instead of a global toast; form errors highlight the offending inputs themselves (`input.invalid { border-color: var(--error); }`).

**3.11 Empty states invite creation.** An empty list should pair one line of copy with a direct "create" action (optionally templates/presets), not dead text.

**3.12 Keyboard on sequential lists.** ↑/↓ moves selection through list items; ⌘/Ctrl+Backspace deletes the selected item; custom widgets follow the corresponding WAI-ARIA pattern.

**3.13 Motion: short and proportional.** Interaction animations stay at 200 ms or less so they feel instant. Animate to values proportional to the trigger's size — dialogs fade + scale from ~0.8 (never from 0); buttons press to ~0.96, not 0.8.

```css
button { transition: transform 150ms ease, background-color 150ms ease; }
button:active { transform: scale(0.97); }
```

**3.14 Frequent, unexciting actions skip animation.** Context menus, list add/remove, trivial hovers: no entrance animation (macOS menus animate outward only — learn from that).

**3.15 Theme switches must not re-fire hover transitions.** A dark/light swap that lets every transition replay looks haunted — add a class that disables transitions, swap tokens, remove it after one frame:

```css
.theme-switching, .theme-switching * { transition: none !important; }
```

**3.16 Hover states only for real pointers.** Touch devices flash `:hover` styles on press. Check: raw `:hover` rules. Fix:

```css
@media (hover: hover) { nav button:hover { background: var(--panel); } }
```

### 4. Accessibility & Focus

**4.1 No tooltips on disabled buttons.** Disabled buttons leave the tab order, so keyboard users never hear the explanation. Fix: keep the button enabled and explain on click, or use `aria-disabled` with the tooltip on a wrapper.

**4.2 Focus rings that respect radius.** Prefer box-shadow over `outline` so the ring follows rounded corners (older Safari ignores radius on outlines).

```css
:focus-visible { outline: none; box-shadow: 0 0 0 2px var(--bg), 0 0 0 4px var(--primary); }
```

**4.3 `aria-label` on every icon-only control.** An SVG with no text is silent for screen readers.

```jsx
<button aria-label="Download video"><svg … /></button>
```

**4.4 Tooltips must not contain interactive elements.** No links or buttons inside a hover tooltip — hover cannot reach them reliably.

**4.5 Render images with `<img>`.** CSS backgrounds are invisible to screen readers and can't be right-click-copied. Content imagery is `<img src alt />` with a meaningful `alt`.

**4.6 Label HTML-built illustrations.** A diagram assembled from divs needs `role="img"` + `aria-label`, or the raw DOM gets read aloud.

**4.7 Prediction cone for nested menus.** Keep the parent menu open while the pointer travels diagonally toward a child item — a naive `mouseleave` closes it mid-path.

**4.8 16 px minimum input font size.** iOS Safari zooms into any field under 16 px on focus, shifting the whole layout.

```css
input, select, textarea { font-size: 16px; }
```

**4.9 No autofocus on touch devices.** Focusing a field on load pops the on-screen keyboard and covers the screen.

### 5. Perceived Performance

**5.1 Big blurs are expensive — and band when scaled.** Large `blur()` values on `filter`/`backdrop-filter` jank on modest GPUs, and blur + scale on filled rectangles produces visible banding streaks. Fix for both: a pre-baked radial gradient.

```css
.glow { background: radial-gradient(closest-side, rgba(99, 102, 241, 0.25), transparent 70%); }
```

**5.2 GPU hints are targeted; `will-change` is a last resort.** `transform: translateZ(0)` fixes one specific janky animation, never a global sprinkle; enable `will-change` only during scroll animations that are actually unperformant, and remove it after — preemptive use backfires by exhausting memory.

**5.3 Pause what is off-screen.** Looping CSS animations and `<video>` elements should pause or unmount when scrolled away. Too many autoplaying videos choke iOS.

**5.4 iOS autoplay requires `muted` + `playsinline`** or the video won't play inline:

```jsx
<video src={url} muted playsInline autoPlay loop />
```

**5.5 Bypass the framework for real-time values.** Wheel deltas, drag positions, scroll progress: keep them in a ref and write straight to the DOM instead of re-rendering on every event.

```jsx
const bar = useRef(null);
onScroll={e => { bar.current.style.transform = `scaleX(${e.currentTarget.scrollTop / 500})`; }}
```

**5.6 Adapt to hardware and network** (device Memory, save-data, connection type) — degrade blur/animation tiers on weak conditions instead of shipping one worst-case experience.

**5.7 Custom pan/zoom components must set `touch-action`** (`none` or axis-specific) to override native scroll/zoom stealing the gesture.

### 6. Touch & Misc

**6.1 Remove the iOS tap highlight — but replace the feedback.** Silently deleting it leaves touches feeling dead; your own `:active` state must take over.

```css
* { -webkit-tap-highlight-color: rgba(0, 0, 0, 0); }
button:active { transform: scale(0.97); }
```

**6.2 Ship an SVG favicon that follows the color scheme** — an embedded `<style>` reacts to `prefers-color-scheme`:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
  <style>path { fill: #111; } @media (prefers-color-scheme: dark) { path { fill: #f6f6f6; } }</style>
  <path d="…" />
</svg>
```

**6.3 Handle auth redirects server-side.** Redirect before the client loads — client-side redirects flicker the URL bar and flash protected content.

## When to use / When NOT to use

Use when:
- Building or reviewing any user-facing web surface — forms, lists, buttons, menus, motion, touch behavior.
- An interface "works" but feels generic, and the gap is micro-craft, not layout.
- Establishing baseline checks before shipping a screen or running a UI audit.

Not when:
- Platform-native (non-web) UI — several rules are web-specific (`-webkit-` quirks, iOS Safari zoom, `touch-action`).
- Throwaway prototypes where iteration speed outranks polish.
- A brand or design system deliberately deviates — these are defaults, not laws; deviations must be conscious and documented.

## How to apply

1. [ ] Critical input flows are real `<form onSubmit>` (Enter submits) with `required` on critical fields.
2. [ ] Every input has a correct `type` (`url` for links, `number` + `inputmode` for counts); `spellCheck={false}` on slugs, codes, IDs.
3. [ ] `input, select, textarea` font-size ≥ 16 px — no iOS focus zoom.
4. [ ] `-webkit-font-smoothing: antialiased` on `body`; `-webkit-text-size-adjust: 100%` on `html`.
5. [ ] Focus ring uses radius-following box-shadow on `:focus-visible`, not a flat `outline`.
6. [ ] No `font-weight` inside any `:hover`/`.active`/selected rule — states change color/background only.
7. [ ] All `:hover` rules are wrapped in `@media (hover: hover)`.
8. [ ] Buttons and cards have a ≤200 ms transition plus a pressed state (`scale(0.97)` on `:active`); dialogs/popovers animate fade + scale from ~0.8, never 0.
9. [ ] `user-select: none` on buttons, chips, cards; `pointer-events: none` on every decorative layer; hit areas ≥ 44×44 px.
10. [ ] `font-variant-numeric: tabular-nums` on dates, durations, and counters.
11. [ ] Content imagery renders as `<img>` with descriptive `alt`, not CSS backgrounds; downloads are real `<a>` elements.
12. [ ] Autoplaying videos carry `muted` + `playsinline`, and pause when scrolled off-screen.
13. [ ] The primary action is disabled while its request is in flight — no double submits; the label reflects the state.
14. [ ] Form errors highlight the offending input (border + `aria-describedby` → message), not a detached global message.
15. [ ] Empty states pair one line of copy with a direct create action.
16. [ ] Copy/download confirms inline next to the trigger (✓ ~1.5 s) instead of a global toast.
17. [ ] Delete/cancel updates the list optimistically and rolls back with feedback on failure.
18. [ ] `::selection` is styled to the palette; gradient text drops its gradient when selected.
19. [ ] Every icon-only button has `aria-label`; DOM-built illustrations have `role="img"` + `aria-label`; no tooltips on disabled buttons.
20. [ ] Sequential lists/pickers support ↑/↓ + Enter keyboard navigation; glows are radial gradients, not giant `blur()` filters.

## AI-slop warning

- **Sprinkling the perf rules globally.** AI adds `will-change`, `translateZ(0)`, or blur everywhere "for performance" — the source marks each as a targeted, last-resort fix; preemptive use causes the jank it exists to cure.
- **Animating everything.** AI gives every element an entrance animation; the source says frequent, unexciting actions (menus, list mutations) get none.
- **Over-broad selectors.** `* { user-select: none }` kills copy/paste site-wide (rule 3.6 targets interactive controls only); `cursor: pointer` on everything ignores semantics (rule 2.2).
- **Polish-pass / cargo-cult mindset.** AI defers all of this to a final pass and copies rules wholesale; these rules change what you write as you write it, and deviation is allowed but must be deliberate.

## Relations

- **rauno** — the author's portfolio; shows these rules embodied in shipped work and where the taste behind the checklist comes from.
- **invisible-details** — the same micro-detail philosophy from the observational side; extends this list with details the checklist does not cover.
- **laws-of-ux** — the cognitive psychology behind these mechanics (habit, recognition over recall); explains why they work.
- **html-can-do-that** — the native-HTML capability inventory that makes rules 3.1–3.5 automatic: reach for the platform before JS.
