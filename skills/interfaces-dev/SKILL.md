---
name: interfaces-dev
description: Use when building a common UI piece (button, menu, dialog, form, tabs, gradient, entering content) and you need the proven pattern shape plus the exact values that make it feel finished.
source: https://interfaces.dev/; https://interfaces.dev/cheat-sheet
category: reference
---

# Interfaces — the modern component pattern reference

Source: https://interfaces.dev/ and https://interfaces.dev/cheat-sheet — Jakub Krehel (design engineer, Interfere; ex-OpenSea; author of oklch.fyi). A design-engineering magazine (paid issues) plus a free public cheat sheet that condenses it. Three issues are free: Understanding gradients, How I use shared layout animations, Details that make interfaces feel better. Content license: proprietary; the cheat sheet is published free. The source's demos are Tailwind-based; every mechanism below is ported to plain CSS.

## What it is / Why it exists

The site's thesis: you can feel the difference between good and great products, and it comes from "a lot of small things that add up." In the AI era "speed alone is no longer an advantage" — lasting interfaces are built with intent and extraordinary care. The site is not a component gallery; it is a magazine whose 18 issues each deep-dive one craft area (gradients, OKLCH, shared layout animations, will-change, drag gestures, details, typography, accessibility, transitions). The cheat sheet compresses the doctrine into seven checklists: User Interface, Animation, Typography, Colors, Accessibility, Layout, Writing. Its unit of guidance is the *detail with an exact value* — not the abstract principle.

The taxonomy of interface patterns this canon recognizes: nested surfaces, buttons, overlays/menus, entering content, exits, icon swaps, shared-element (tab indicator) motion, gradients, forms, numeric displays, text blocks, and empty states.

## The core ideas

### Doctrine (applies to every pattern)

1. Frequency dictates speed: frequent interactions must be instant or near-instant (hover color change = 0 perceptible delay); rare ones may be theatrical.
2. Motion must be interruptible. CSS transitions retarget toward the latest state; keyframes run a fixed timeline and cannot. Rule of thumb: transitions for interactions, keyframes only for one-shot sequences.
3. Exits are subtler than entrances — leave takes less distance and less time than arrive.
4. Every palette step, token, and animation must have a named job; delete anything nothing uses.

### User Interface (surface craft)

- Nested elements get **concentric radii**: `outer radius = inner radius + padding between them`. A 6px-radius avatar inside 4px padding needs 10px on the container.
- **Optical alignment beats geometric alignment.** A button with text + icon gets slightly smaller padding on the icon's side; the best fix lives inside the SVG (optical margins), the acceptable fix is margin/padding.
- Use a **layered box-shadow instead of borders** for depth. Light mode:
  ```css
  .surface {
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.06),
      0 1px 2px -1px rgba(0, 0, 0, 0.06),
      0 2px 4px 0 rgba(0, 0, 0, 0.04);
    transition-property: box-shadow; /* never transition: all */
  }
  .surface:hover {
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.08),
      0 1px 2px -1px rgba(0, 0, 0, 0.08),
      0 2px 4px 0 rgba(0, 0, 0, 0.06);
  }
  @media (prefers-color-scheme: dark) { /* or .dark */
    .surface { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.08); }
    .surface:hover { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.12); }
  }
  ```
  Transparent rings work over images/multicolor backgrounds; solid border colors fail on backgrounds they were not designed for.
- **Images get a 1px inset outline**: `outline: 1px solid rgba(0,0,0,0.08); outline-offset: -1px;` (light) / `rgba(255,255,255,0.08)` (dark). The issue demo uses 10% alpha — 8–10% is the range.
- An icon's **stroke weight matches the text beside it**.

### Animation (the pattern shapes)

- **Overlays/menus animate from the trigger**, not the center: set `transform-origin` from the trigger's position.
- **Frequently opened menus skip the opening animation**; animate close only.
- **Exit recipe**: shorter travel than entrance, fade `opacity`, add `filter: blur(4px)`. A full drawer exit slides `x` to `calc(-100% - 4px)` (width + padding) with spring duration 0.45, bounce 0; the subtle exit uses `x: -70%` and lets opacity + blur do the work.
- **Button press**: `scale` between `0.95` and `0.98`, `transition: scale 200ms ease-out`.
- **Icon swap** (crossfade): incoming icon animates `scale 0.25 → 1`, `opacity 0 → 1`, `blur 4px → 0px`; outgoing reverses the values.
- **Entering content**: split into small groups, stagger each. Base keyframe:
  ```css
  @keyframes enter {
    from { transform: translateY(8px); filter: blur(8px); opacity: 0; }
  }
  .animate-enter {
    animation: enter 800ms cubic-bezier(0.25, 0.46, 0.45, 0.94) both;
    animation-delay: calc(var(--delay, 0ms) * var(--stagger, 0));
  }
  ```
  Set `--stagger: 1, 2, 3…` per element; `--delay: 100ms` between sections; `--delay: 80ms` when the title is split into word-level spans. Description can stay one block; buttons animate individually.
- **Disable all transitions when switching light/dark theme** (apply a `.no-transitions` class for one frame).
- If an element jitters 1–2px mid-animation, add `will-change: transform` (especially iOS Safari).
- No elements animate on page load unless deliberate; do not animate one giant block.
- **Shared-element / tab indicator** (Motion `layoutId`, FLIP under the hood): render *different* components per state sharing one `layoutId`; never manipulate a single element. Multiple elements each need a unique `layoutId` per state — duplicates break it. Animate values that change between states (e.g. `border-radius`) through the animation API, not the class, so they interpolate. Keep `layoutId` components *outside* `AnimatePresence` — inside it, `initial`/`exit` fire mid-flight and look broken (worst with opacity). FLIP = First, Last, Invert, Play.
- **Gradients are GPU-accelerated**: animate position/angle/size cheaply as long as the gradient itself is not recalculated per frame.

### Gradients (the full pattern vocabulary)

- Three native types: `linear`, `radial`, `conic`. Stops define where colors start/end; two stops at one position make a hard edge (`blue 50%, red 50%`).
- Interpolation space is declared inline: `linear-gradient(in oklch, blue, red)`. `srgb` = straight line, muted midtones; `oklab` = straight line, even brightness, Display-P3; `oklch` = interpolates in a *circle* (hue is angular) — smoother, more vivid midtones, but may show colors you never defined. Pick deliberately.
- A **color hint** (`red, 40%, blue`) moves the blend midpoint without adding a color or moving endpoints — it changes the *rate* of interpolation.
- Layer gradients + blend modes for rich surfaces:
  ```css
  background:
    linear-gradient(in oklch 135deg, oklch(0.75 0.18 280), oklch(0.8 0.15 80), oklch(0.75 0.18 320)),
    conic-gradient(in oklch from 180deg, oklch(0.7 0.12 200 / 0.3), oklch(0.7 0.12 340 / 0.3), oklch(0.7 0.12 200 / 0.3));
  background-blend-mode: overlay, color-dodge;
  ```

### Typography

- Serve `.woff2` only — never `.ttf`/`.otf`.
- `font-variant-numeric: tabular-nums` on timers, counters, prices, tables (skip if already monospace; some fonts like Inter change numeral look).
- Long-text lines: **60–75 characters**.
- `text-wrap: balance` on headings, `text-wrap: pretty` on descriptions (prevents orphans); neither on long-form text.
- `overflow-wrap: break-word` for long words/links/IDs; `white-space: nowrap` so labels and badges never wrap.
- Root layout: `-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale` — macOS text renders heavier without it.
- Write with normal capitalization; `text-transform` only for display casing.
- Smart punctuation: curly quotes, en dash for ranges, em dash for asides, `…` not `...`.
- `text-underline-position: from-font; text-decoration-skip-ink: auto` so underlines skip g/y tails.
- Every truncation (`text-overflow: ellipsis`) needs a tooltip or expanded view carrying the full text.

### Colors

- Every palette step serves a purpose: page background, component hover, border, solid fill, body text. No orphan steps.
- Components use **semantic tokens** (`--color-text-secondary`), never primitives (`--blue-500`) — the primitive is the raw value, the token is how it is used. Name by purpose: `--color-accent-solid`, not `--color-blue-button`.
- Reserve `accent` for the brand color so `primary` never ambiguously means both brand and body text.
- Measure contrast against the background **directly behind** the element.
- Build a **separate dark palette**, do not invert the light one. Choose one theme mechanism (`prefers-color-scheme` or `.dark` class) and never mix.

### Accessibility (hard rules with numbers)

- Native elements: `<button>` for actions, `<a>` for navigation. `:focus-visible` over `:focus`; never remove outline without replacement. Only `tabindex="0"` / `"-1"` — positive values scramble order.
- Icon-only buttons need `aria-label`; never `aria-hidden="true"` on focusable elements.
- Every input: visible `<label>`, matching `type` and `inputmode`. Alt text explains purpose + content; decorative images get `alt=""`.
- **Never block paste.**
- **Form validation shape**: keep submit enabled until the request starts; validate on submit; mark `aria-invalid="true"`; wire errors via `aria-describedby`; move focus to the first invalid field. The site's own email form: on focus, border darkens + 3px ring at 35% alpha; invalid state switches border and ring to red (ring 20% alpha).
- Hit areas: **min 24×24px, aim 44×44px touch / 40×40px desktop**, never overlapping. `pointer-events: none` on decorative glows/gradients.
- Hover styles inside `@media (hover: hover)` — touch `:hover` sticks after tap and looks stuck-selected.
- Animations inside `@media (prefers-reduced-motion: no-preference)`.
- `role="status"` for routine announcements; `role="alert"` for urgent errors only.
- Never color alone for status — add icon, label, or underline. Skip-to-content link is the first Tab stop.

### Layout & spacing

- `scroll-margin-top` on anchor-target headings.
- **Between-group spacing ≥ 2× within-group spacing**: 8px within a group, 16px+ between groups.

### Writing (microcopy)

- Button labels start with a verb: "Save draft", "Delete project" — never "OK!" or bare "Yes". Confirmation states the consequence ("Delete project" / "Cancel").
- One advance label per flow: pick "Continue" or "Next", use it everywhere. Link text describes the destination.
- Sentence case everywhere ("Save changes") as the safe default.
- Toggle labels state the ON behavior: "Send read receipts", not "Disable read receipts".
- Empty states explain what belongs there + offer exactly one action. Address the reader as "you", not "the user".

## When to use / When NOT to use

Use when: building or reviewing any concrete UI piece — buttons, menus, dialogs, tabs, lists, forms, numeric readouts, gradients, theme systems, empty states — and when finishing a build (this canon is a pre-ship checklist of felt details).

Not for: information architecture, research methods, or brand-level visual identity — the site is silent there. Do not apply its animation recipes to pages that must not animate (kiosks, print views) or where `prefers-reduced-motion` gating cannot be honored. The press-scale and blur-exit vocabulary is small-surface motion; scaled to full-page transitions it reads as gimmick.

## How to apply

1. Identify the pattern shape you are building; jump to its recipe above before writing custom CSS.
2. Set typography base first: woff2, antialiased root, 60–75ch measure, balance/pretty rules.
3. Define the palette as purpose-named semantic tokens; verify each step has a consumer; build dark separately.
4. Replace borders with the layered box-shadow recipe; make nested radii concentric; outline images 1px/-1px.
5. Wire motion: transitions (not keyframes) for interactions; trigger-based `transform-origin`; staggered group entrances with the exact keyframe/timing above; exits shorter + blur 4px.
6. Run the a11y pass: native elements, `:focus-visible`, labels, hit areas ≥24px, `@media (hover: hover)`, reduced-motion gate.
7. Run the microcopy pass: verb-first buttons, consequence-stating confirms, positive toggle labels, one-action empty states.
8. Audit every animation for interruptibility and jitter (`will-change: transform`); audit every `transition` for enumerated properties (never `all`).

## AI-slop warning

AI misapplies this canon in three ways: (1) applying *all* the motion vocabulary at once — stagger + blur + press-scale + shared-element on a single page is noise; the site's own rule is frequency dictates speed, and most surfaces get zero animation; (2) copying the exact shadow/blur numbers without the hierarchy discipline they serve (exits subtler than entrances, every token with a job) — you get decorated slop, not craft; (3) skipping the unglamorous half (tabular-nums, woff2, break-word, `aria-describedby`, paste-unblocked) while shipping the visible half (gradients, springs). The cheat sheet is ordered cheap-to-fancy for a reason: the Typography and Accessibility sections change usability more than any gradient. Also: don't invert a light palette for dark mode and don't mix the two theme mechanisms — both are classic AI shortcuts the site explicitly bans.

## Relations

- **jakub-kr** — the same author's portfolio; see his work for these recipes applied end-to-end (the magazine is him documenting his own practice).
- **oklch** — goes deeper on the OKLCH color model this site leans on for gradient interpolation and dark palettes.
- **transitions** — complements the animation section with transition/exit choreography beyond the interruptibility rule stated here.
- **web-interface-guidelines** — an adjacent reference; where the two disagree, prefer this site's exact numbers (it is the more prescriptive of the two).
- **bankai** — the canon root; load this skill as its pattern-shape reference arm.
