---
name: transitions
description: Use when a UI state change snaps with no motion — tab swaps, modals, panels, staggered lists, skeleton reveals, text swaps, error shakes, accordions. A pure-CSS catalog with exact durations and easings.
source: https://transitions.dev/
category: reference
---

# Transitions — the essential UI-state transitions, pure CSS, exact values

Source: https://transitions.dev/ — "Transitions" by Jakub Antalik. A catalog of 32
production-ready, pure-CSS transitions for web apps
as "Collection of the most essential transitions for web apps that you can just copy
and paste into any project." No license stated. This skill reimplements the essential
ones in plain CSS with the exact original durations and easings, on one shared token
scale.

## What it is / Why it exists

Most apps ship state changes that snap: a tab click hard-cuts, a modal pops in, a
loader is yanked out and replaced. The catalog exists because developers know motion
would help but default to `transition: all 0.3s ease` or skip motion entirely — no
shared scale, no separate exit clocks, no reduced-motion guards. This skill distills
that catalog into nine re-usable mechanisms (rise-in entrance, stagger, modal,
directional swap, panel, skeleton reveal, text swap, shake, accordion), each a few
lines of plain CSS driven by one token set, plus the rules for when to animate
nothing at all.

## The core ideas

1. **Transition = continuity, not decoration.** It must answer "where did this
   come from?" (spatial continuity) or "what did my action cause?" (hierarchical
   continuity). If it answers neither, delete it.
2. **Slow in, fast out.** Entrances run slower with an ease-out; exits ~60% of
   that. Arriving feels deliberate, leaving feels snappy — never the reverse.
3. **Small distances carry the motion:** 4–16px of travel suffices; a 2–3px
   cross-blur makes a short travel read as a full open.
4. **Animate the inner pieces, not the container** — the badge's dot, each page
   section, each staggered line.
5. **Enumerate transitioned properties** (never `transition: all`) and **keep
   every `prefers-reduced-motion: reduce` guard**.
6. **Replay rule:** remove class → force reflow (`void el.offsetWidth`) → re-add.
7. **Close-state cleanup:** swap open class for `is-closing`, remove it after the
   close duration — or the next open jumps from the closing state.

### Motion tokens (paste once in the global stylesheet)

```css
:root {
  --duration-stagger: 40ms;    --duration-micro: 80ms;
  --duration-quick: 150ms;     --duration-fast: 250ms; /* close/text swap; open/tabs/slide */
  --duration-medium: 350ms;  --duration-slow: 400ms; /* panel/toast close; panel open, skeleton */
  --duration-very-slow: 500ms; /* text reveal, badge, success check */
  --ease-smooth-out: cubic-bezier(0.22, 1, 0.36, 1);       /* opens, slides */
  --ease-in-out: ease-in-out;                              /* swaps, cross-fades */
  --ease-out: ease-out;  --ease-linear: linear;            /* tooltip; shimmer/pulse */
  --ease-bounce: cubic-bezier(0.34, 1.36, 0.64, 1);        /* badge pop */
  --ease-bounce-strong: cubic-bezier(0.34, 3.85, 0.64, 1); /* bouncy return */
  --distance-base: 8px;  --distance-medium: 12px;
  --scale-large: 0.96;  --scale-medium: 0.97;  --scale-small: 0.98;
  --blur-small: 2px;    --blur-medium: 3px;
}
```

## Catalog

### 1. Rise-in entrance / toast (fade + slide + blur + scale)

Workhorse for anything appearing in place: toasts, flashes, cards. Rise 16px,
fade, un-blur, scale 0.97 → 1; open 350ms, close 250ms.

```css
.t-toast {
  opacity: 0; transform: translateY(16px) scale(0.97); filter: blur(2px);
  transition: opacity 250ms var(--ease-smooth-out), transform 250ms var(--ease-smooth-out),
              filter 250ms var(--ease-smooth-out);
}
.t-toast.is-open { opacity: 1; transform: none; filter: blur(0);
  transition-duration: 350ms; /* slower open clock, same ease */ }
@media (prefers-reduced-motion: reduce) { .t-toast { transition: none !important; } }
```

### 2. Staggered list entrance

Items rise 12px with a 3px blur, 40ms apart, 500ms each. Exit is decoupled: one
quiet 200ms fade, no reverse stagger.

```css
.t-stagger-line {
  opacity: 0; transform: translateY(12px); filter: blur(3px);
  transition: opacity 500ms var(--ease-smooth-out), transform 500ms var(--ease-smooth-out),
              filter 500ms var(--ease-smooth-out);
}
.t-stagger-line:nth-child(2) { transition-delay: 40ms; }
.t-stagger-line:nth-child(3) { transition-delay: 80ms; }
.t-stagger.is-shown .t-stagger-line { opacity: 1; transform: none; filter: blur(0); }
.t-stagger.is-hiding .t-stagger-line { opacity: 0; transform: none; filter: blur(0);
  transition: opacity 200ms ease; transition-delay: 0s; }
@media (prefers-reduced-motion: reduce) { .t-stagger-line { transition: none !important; } }
```

### 3. Modal open / close

Scales 0.96 → 1 on open (250ms), dips back on close (150ms). Needs JS cleanup:
`is-open` ↔ `is-closing`, remove `is-closing` after 150ms.

```css
.t-modal {
  transform: scale(0.96); opacity: 0; pointer-events: none;
  transition: transform 250ms var(--ease-smooth-out), opacity 250ms var(--ease-smooth-out);
}
.t-modal.is-open { transform: scale(1); opacity: 1; pointer-events: auto; }
.t-modal.is-closing { transform: scale(0.96); opacity: 0; pointer-events: none;
  transition-duration: 150ms; }
@media (prefers-reduced-motion: reduce) { .t-modal { transition: none !important; } }
```

### 4. Tab / page swap (directional side-by-side)

Two screens side-by-side — list ↔ detail, step 1 ↔ step 2. Outgoing page exits
toward its side, incoming enters from its side: 8px, 3px blur, 250ms.

```css
.t-page { --from-x: 8px; }
.t-page[data-page-id="1"] { --from-x: -8px; } /* page 1 lives left */
.t-page {
  opacity: 0; pointer-events: none;
  transform: translateX(var(--from-x)); filter: blur(3px);
  transition: opacity 250ms var(--ease-smooth-out), transform 250ms var(--ease-smooth-out),
              filter 250ms var(--ease-smooth-out);
}
.t-page.is-active { opacity: 1; pointer-events: auto; transform: none; filter: blur(0); }
@media (prefers-reduced-motion: reduce) { .t-page { transition: none !important; } }
```

### 5. Panel reveal

Panel sliding into a page region: translateY + opacity + 2px cross-blur on one
clock (400ms open / 350ms close). Clip with a parent `overflow: hidden`.

```css
.t-panel {
  transform: translateY(100px); opacity: 0; filter: blur(2px); pointer-events: none;
  transition: transform 350ms var(--ease-smooth-out), opacity 350ms var(--ease-smooth-out),
              filter 350ms var(--ease-smooth-out);
}
.t-panel[data-open="true"] { transform: none; opacity: 1; filter: blur(0);
  pointer-events: auto; transition-duration: 400ms; }
@media (prefers-reduced-motion: reduce) { .t-panel { transition: none !important; } }
```

### 6. Skeleton loader → content reveal

Skeleton bars pulse (1000ms ease-in-out, opacity to 0.5, once), then both layers
cross-fade with a matching 2px cross-blur over 400ms ease-in-out — one motion.

```css
.t-skel { position: relative; }
.t-skel-skeleton, .t-skel-content { position: absolute; inset: 0; }
.t-skel-skeleton { z-index: 1; opacity: 1; filter: blur(0);
  transition: opacity 400ms ease-in-out, filter 400ms ease-in-out; }
.t-skel-content { z-index: 2; opacity: 0; filter: blur(2px);
  transition: opacity 400ms ease-in-out, filter 400ms ease-in-out; }
.t-skel.is-revealed .t-skel-skeleton { opacity: 0; filter: blur(2px); }
.t-skel.is-revealed .t-skel-content { opacity: 1; filter: blur(0); }
.t-skel-skeleton.is-pulsing > * { animation: t-skel-pulse 1000ms ease-in-out 1; }
@keyframes t-skel-pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
@media (prefers-reduced-motion: reduce) { .t-skel-skeleton, .t-skel-content { transition: none !important; }
  .t-skel-skeleton.is-pulsing > * { animation: none !important; } }
```

### 7. Text states swap ("Processing…" → "Done")

Old text exits up (4px, 2px blur, 150ms ease-in-out), new enters from below.
JS: `.is-exit` → after 150ms set text + `.is-enter-start` (no transition) → reflow → remove.

```css
.t-text-swap { display: inline-block;
  transition: transform 150ms ease-in-out, filter 150ms ease-in-out, opacity 150ms ease-in-out; }
.t-text-swap.is-exit { transform: translateY(-4px); filter: blur(2px); opacity: 0; }
.t-text-swap.is-enter-start { transform: translateY(4px); filter: blur(2px); opacity: 0; transition: none; }
@media (prefers-reduced-motion: reduce) { .t-text-swap { transition: none !important; } }
```

### 8. Error shake

Percussive shake with overshoot: legs 80+80+60+60 = 280ms, 6px swings, 4px
overshoot. Keep `.is-error` orthogonal to `.is-shaking` so replays don't flicker.

```css
.t-input.is-shaking { animation: t-input-shake 280ms linear; }
@keyframes t-input-shake {
  0%     { transform: translateX(0);    animation-timing-function: var(--ease-smooth-out); }
  28.57% { transform: translateX(6px);  animation-timing-function: var(--ease-smooth-out); }
  57.14% { transform: translateX(-6px); animation-timing-function: var(--ease-smooth-out); }
  78.57% { transform: translateX(4px);  animation-timing-function: var(--ease-smooth-out); }
  100%   { transform: translateX(0); }
}
@media (prefers-reduced-motion: reduce) { .t-input { animation: none !important; } }
```

### 9. Accordion / collapsible details

Height animates via `grid-template-rows: 0fr ↔ 1fr` — no JS measuring; the inner
element clips overflow and fades with a 2px blur; the chevron flips `scaleY(-1)`
(everywhere-compatible, unlike Chromium-only `d:` morphing). Padding: inner only.

```css
.t-acc-panel { display: grid; grid-template-rows: 0fr;
  transition: grid-template-rows 250ms var(--ease-smooth-out); }
.t-acc[data-open="true"] .t-acc-panel { grid-template-rows: 1fr; }
.t-acc-panel-inner { overflow: hidden; opacity: 0; filter: blur(2px);
  transition: opacity 250ms var(--ease-smooth-out), filter 250ms var(--ease-smooth-out); }
.t-acc[data-open="true"] .t-acc-panel-inner { opacity: 1; filter: blur(0); }
.t-acc-chevron { transform: scaleY(1); transform-origin: center;
  transition: transform 250ms var(--ease-smooth-out); }
.t-acc[data-open="true"] .t-acc-chevron { transform: scaleY(-1); }
@media (prefers-reduced-motion: reduce) {
  .t-acc-panel, .t-acc-panel-inner, .t-acc-chevron { transition: none !important; } }
```

Full reference — 32 transitions (also number pop-in, tab pill, icon swap,
tooltip, toggle, confetti, 3D tilt, streaming text, banner stacking): repo
`Jakubantalik/transitions.dev`, `skills/transitions-dev/01…32-*.md`.

## When to use / When NOT to use

### When to use

- A state change snaps with no transition: tab swap, panel open, list mount, content replacing a loader.
- Two states must read as *the same thing moving* (wizard step 1 → 2, list → detail).
- Quiet confirmation an action registered (saved, error) without a blocking dialog; or ad-hoc motion (random durations, `transition: all`) needing one consistent scale.

### When NOT to animate

- **Initial page load.** Nothing staggers in on first paint; motion on mount reads as noise and delays usability.
- **High-frequency updates.** A list re-rendered on every poll tick must not replay entrances — animate only genuine state changes.
- **Navigation already decided on, or text that must be read immediately** — don't delay the inevitable or the readable; the shake animates the input, error text appears at once.
- **Layout properties** (`top/left/width/height`) outside the grid-rows accordion trick — stick to `transform`, `opacity`, `filter`.
- **Decoration on a loop** unless a real wait exists; and never without a `prefers-reduced-motion` guard — then the transition is not done.

## How to apply

1. Paste the token `:root` block once into the global stylesheet. Namespace every
   snippet (`t-*`), reference tokens instead of re-hardcoding values, and keep
   every `prefers-reduced-motion` guard.
2. **Tab / segmented-content swap.** Wrap each pane in the side-by-side pattern
   (§4). Derive `--from-x` from the index delta in the tab setter — next tab
   enters from `+8px`, previous from `-8px` — not a fixed direction (250ms, 3px blur).
3. **Sequential steps (wizard).** Going forward, the next step enters from the
   right; going back, it enters from the left. Keep both steps mounted (or
   absolutely positioned) during the 250ms swap.
4. **Long-running work with pending states.** While work is queued or processing,
   show pulsing skeleton bars (§6); on completion add `.is-revealed` for the
   400ms cross-blur reveal. Status labels in rows use the text swap (§7);
   counters use the number pop-in (full reference). Never replay entrances on
   poll/refetch ticks.
5. **Auto-dismissed messages (toasts, flashes).** Rise-in/toast (§1): add
   `.is-open` on mount; on the auto-dismiss timer, swap to the closed state
   before unmounting so the exit animates (350ms in, 250ms out).
6. **Native `<details>` disclosure.** `<details>` cannot animate height: convert
   to the accordion pattern (§9) — `data-open` + grid-rows + `scaleY(-1)`
   chevron — or rise-in the inner content on toggle.
7. **Form validation errors.** Error shake (§8) on the invalid field, message
   revealed beneath it; keep shake and error classes orthogonal so it replays.
8. Replay any one-shot animation via the replay rule (idea 6); clean up close
   states per idea 7.

## AI-slop warning

- The default AI move is `transition: all 300ms ease` on everything interactive:
  it breaks idea 5 (enumerate properties), animates layout properties, and gives
  exits the same clock as entrances (violating slow-in/fast-out).
- AI staggers everything on mount — including first paint and list re-renders —
  producing a perpetual-floating page that delays usability.
- AI deletes the `prefers-reduced-motion` guards and the `is-closing` cleanup
  lines when "simplifying" CSS — exactly the two details that make transitions
  correct.
- AI invents per-component durations (300ms here, 200ms there, `ease` default)
  instead of the token scale, so nothing rhymes across the app.
- Cliché contexts this poisons: launch pages where every section bounces in on
  scroll, dashboards where panels wiggle on every poll. If the motion answers
  neither continuity question, it is slop regardless of polish.

## Relations

- **animations-dev** — Emil Kowalski's animation doctrine behind these
  numbers: when to animate at all, interruption, gestures, exit choreography.
  This skill fixes the tokens; that one supplies the theory.
- **easing** — the full easing.dev catalog (28 bezier curves, 10 springs
  with exact values). Use it when a transition here needs a different feel than
  the six token curves, or springs instead of durations.
- **emil-skills** — the emilkowalski/skills playbook and its strict
  review/audit bar (frequency gate, ease-out entrances, sub-300ms, transform/
  opacity only). Use it to review transitions built with this catalog.
- **you-dont-need-animations** — the restraint counter-argument: most
  interfaces don't need animations. It contradicts this catalog's default of
  animating state changes — pass its gate before applying any pattern here.
