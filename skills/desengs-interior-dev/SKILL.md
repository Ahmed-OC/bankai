---
name: desengs-interior-dev
description: Use when a button, tooltip, slider, or gesture must feel finished — no width jumps, no restarts, no lost async races. Encodes the "missing twenty percent" of micro-interaction polish as headless hooks and plain mechanisms.
source: https://www.interior.dev/; https://github.com/ddoemonn/interior
category: library
---

# interior.dev (desengs) — the missing twenty percent of every component, argued out to the frame

Source: https://www.interior.dev/ — 54 animated React micro-interaction components by Ozzy (@ozzyxs1a); repo `ddoemonn/interior`, MIT license, 824 stars. Distributed as shadcn-style registry source you copy and own (`npx shadcn@latest add https://www.interior.dev/r/<name>.json`), not an npm package. Sole dependency: `motion`. Files are Tailwind-styled; every mechanism below is ported to plain CSS/JS, as conventions require.

## What it is / Why it exists

The thesis, in the author's words: "Everybody builds these components. Almost nobody finishes them. The missing twenty percent is always the same three things: a jump, a restart, an animation that ignores the person watching it." Trust is "won in the half-second after a click, and lost in exactly the same place" — a button that resizes when its label changes, a list that jumps as it loads, a drag stuck because the tab lost focus. Nobody files these as bugs; everyone stops believing the interface.

The gap it fills: component libraries ship structure; animation libraries ship primitives. Neither ships the *finished behaviour* — the race guards, abandonment paths, width locks, and timing that make a loading button or hold-to-confirm feel native-grade. interior ships exactly that layer, and nothing else. Distribution follows the ownership model ("One file. Yours."): each file exports a **headless hook (`useX`)** that owns all behaviour and touches zero class names, plus a **styled component (`X`)** built on the hook as a replaceable example. Reskinning "costs nothing but classes."

## The core ideas

### 1. Doctrine (from the README — treat as law)

- "Nothing moves unless something happened." No idle ornament; motion is a consequence of a state change.
- "Motion that models a physical process obeys that process instead of taste" — a hold-to-confirm fill is linear while held and unwinds faster than it filled, because that is what reversal feels like.
- "Every state the component can reach has its space reserved before it arrives" — width locked before the label swap, readout sized to its widest value, skeleton matching final layout.
- "Every gesture knows all the ways it can be abandoned": window `blur`, `visibilitychange`, `pointercancel`, pointer drift past tolerance, Escape.
- "The keyboard is not a fallback but a second complete implementation" — Space/Enter *holds* the hold-to-confirm; Shift+Arrow jumps slider detent-to-detent.
- Under `prefers-reduced-motion` the information still arrives; "only the trip is skipped": `duration: 0` swaps, `jump()` instead of spring, but the checkmark, the swept fill, the announced status all land.

### 2. Width-lock via grid-stacked faces (the signature technique)

A state-changing control (loading button, copy button) renders **all** label faces stacked in one grid cell. The button's width is the max of every face, so no state change ever resizes it. Faces crossfade with a 3px rise and 3px blur — never a hard swap.

```html
<button class="btn" aria-live="polite">
  <span class="faces">
    <span class="face is-idle">Save</span>
    <span class="face is-pending"><svg class="spin"/>Saving…</span>
    <span class="face is-success">Done</span>
    <span class="face is-error">Try again</span>
  </span>
</button>
```

```css
.faces { display: grid; }                     /* one cell, all faces */
.face {
  grid-area: 1 / 1;                           /* stacked, not flowed */
  display: inline-flex; align-items: center; gap: 6px;
  white-space: nowrap;
  transition: opacity 300ms cubic-bezier(0.23,1,0.32,1),
              transform 300ms cubic-bezier(0.23,1,0.32,1),
              filter 300ms cubic-bezier(0.23,1,0.32,1);
}
.face[aria-hidden="true"] { opacity: 0; transform: translateY(3px); filter: blur(3px); }
.spin { animation: rot 0.85s linear infinite; }
@keyframes rot { to { transform: rotate(360deg); } }
@media (prefers-reduced-motion: reduce) {
  .face { transition-duration: 0ms; }         /* trip skipped, swap still lands */
}
```

The source uses spring `stiffness 260, damping 34, mass 0.8` for the crossfade and `520/34/0.45` for the press cell; in plain CSS a 300ms `cubic-bezier(0.23,1,0.32,1)` approximates the first, ~180ms the second. Apply the same stacking to any value readout: render an invisible widest-candidate string in the same grid cell (slider-detents does this so the numeric readout never shifts layout).

### 3. Race-guarded async state machine (the `useAsyncAction` core)

Every pending→settled→idle cycle is guarded so stale responses can't corrupt current state, unmount can't setState, and success reverts on a timer.

```js
let runId = 0, timer = null, alive = true;     // alive=false on unmount
function run(action) {
  if (phase === "pending") return;             // no double-submit
  clearTimeout(timer);
  const id = ++runId;                          // token for THIS attempt
  set("pending");
  Promise.resolve().then(action).then(
    ()  => settle(id, "success"),
    (e) => { onError?.(e); settle(id, "error"); });
}
function settle(id, next) {
  if (!alive || id !== runId) return;          // stale attempt: drop silently
  set(next);
  timer = setTimeout(() => { if (alive && id === runId) set("idle"); }, 1400);
}
```

`resetAfter = 1400ms` (copy-button: 2s). Expose `aria-busy` while pending, plus a visually-hidden `role="status" aria-live="polite"` announcer so screen readers hear "Done" — the visible crossfade is not enough.

### 4. Hold-to-confirm: a physical fill with full abandonment coverage

Defaults: `duration 1800ms`, `steps 20`, `releaseRate 2.5` (release unwinds 2.5x faster than fill), `moveTolerance 10px`, haptic `vibrate(14)` on commit. Driven by a rAF loop with delta clamped to 64ms so a backgrounded tab can't teleport the fill:

```js
const loop = (now) => {
  const dt = Math.min(64, now - last); last = now;
  elapsed += down ? dt : -dt * releaseRate;    // obey the physical process
  if (elapsed >= duration) return commit();    // vibrate(14), fire onConfirm
  if (elapsed <= 0) return reset();
  render(Math.floor(elapsed / duration * steps));
  raf = requestAnimationFrame(loop);
};
```

The fill is a `clip-path: inset(0 X% 0 0)` sweep over a duplicate inverted label layer. Abandonment wiring (copy verbatim into any gesture): `pointermove` beyond 10px from origin → release; `pointerup/pointercancel/pointerleave` → release; `window blur` and `document.visibilitychange→hidden` → release; Escape → reset; `keydown` Space/Enter (guard `e.repeat`) begins, `keyup` releases — so keyboard users literally hold the key. Releasing early is safe and *announced as such* ("Releasing early cancels and nothing happens" in the sr-only hint).

### 5. Tooltip groups: warm-state timing ("A little patience. Then no waiting.")

One store per group, defaults `openDelay 200ms`, `closeDelay 120ms`, `skipDelay 400ms`. The first tooltip waits 200ms; once any tooltip in the group has opened, the group is **warm** and subsequent tooltips open instantly. Warmth cools after 400ms idle. The 120ms close grace lets the pointer cross a neighbouring trigger without flicker. Implementation is three timers (`openTimer`, `closeTimer`, `coolTimer`) around an external store — no library needed; the pattern is the product. Release easing for departing tooltips: `cubic-bezier(0.4, 0, 1, 1)` (fast out, no bounce back).

### 6. Slider detents: magnetism with keyboard parity

Magnetic snap radius `grab = pull ?? (max - min) * 0.045` — inside 4.5% of range, the raw value snaps to the detent. `navigator.vibrate?.(6)` on detent crossing. Thumb 18px, travel = track width − thumb. Keyboard: Arrow = step; Shift+Arrow and PageUp/PageDown = jump detent-to-detent; Home/End = min/max. `window blur` releases an in-flight drag. Thumb motion is a spring (`520/34/0.45`); under reduced motion use `jump()` — instant, no slide.

### 7. Segmented control: the selection travels, nothing jumps

Equal tracks via `grid-template-columns: repeat(n, minmax(0, 1fr))`; the thumb translates `index * 100%` and the label mask translates `-index * 100%` from the same animated position value, so text glides opposite the thumb with zero layout change. Apply anywhere a selection indicator must move between equal slots (tabs, pagination, filter segments).

## Component inventory (54, exact file names)

Action feedback: copy-button, loading-button, hold-to-confirm, long-press, press-depth, ripple, like-burst, value-flash, inline-validation, password-strength, otp-input, floating-label, tag-input.
Overlays: tooltip-group, popover, dropdown, context-menu, modal, drawer, lightbox, command-palette, collapsible-banner.
Navigation/layout: tabs, segmented-control, pagination, accordion, tree-view, snap-carousel, swipe-deck, reorder-list, sortable-table, sticky-header, hide-on-scroll, scroll-spy, reading-progress, filter-grid, load-more, show-more.
Loading/data: skeleton-swap, progress-bar, task-steps, wizard-steps, poll-results, streaming-text, typing-indicator, live-activity, new-items-pill, presence-avatars, logo-marquee, blur-up-image.
Ambience/motion: text-reveal, icon-morph, expanding-search.

Featured taglines worth memorising as specs: Loading Button — "The label changes. The button stays put." Hold to Confirm — "A moment to change your mind." Tooltip Group — "A little patience. Then no waiting." Slider Detents — "Stops you can feel." Segmented Control — "The selection travels. Nothing jumps." Like Burst — "Even a second tap is considered" (un-liking animates too).

## When to use

- Any moment where the user acts and the UI must acknowledge: submit, copy, delete, save, send. Start from these mechanisms, not from a blank `<button>`.
- Destructive or committing actions → hold-to-confirm (1800ms) instead of a confirm dialog.
- Densely-tooltiped surfaces (toolbars, tables, editors) → group warm timing, not per-tooltip delays.
- Any async button → the race-guarded `useAsyncAction` shape, verbatim.
- Installing the real files is justified when: the project already uses React + motion, more than ~3 of these patterns are needed, and you intend to reskin rather than rewrite. Then `shadcn add` the file and delete what you don't use — you own the code.

## When NOT to use

- Static or content sites: one fade does not justify a JS animation dependency; use CSS transitions only.
- Native covers it: `<input type="range">` + CSS `accent-color` beats a custom detent slider when detents aren't real; `<dialog>` beats a custom modal unless the open/close choreography matters; `<details>` beats accordion JS without height animation needs.
- A11y- or budget-constrained embeds (email, third-party widgets): motion code is dead weight; ship states, not trips.
- Don't adopt the example skin (stone palette, 9px radii, inset highlight shadows, 13px text). It is one reskin of headless hooks — the entire point is that behaviour and style are separable.
- Marketing/scroll-driven storytelling: none of these components address it; wrong tool.

## How to apply

1. Before animating any control, enumerate its states (idle/pending/success/error, liked/unliked, open/closed) — if a state exists, it needs a face and a transition, including the "second tap".
2. Lock width: stack every face in one grid cell (`grid-area: 1/1`); size readouts to the widest candidate value rendered invisibly.
3. Wrap async handlers in the runId/alive/resetAfter machine (1400ms revert default; 2s for copy).
4. For each gesture, wire all exits: blur, visibilitychange, pointercancel, drift tolerance (10px), Escape. Test by switching tabs mid-drag.
5. Give timing a reason: 200ms first-open delay, instant when warm, 120ms close grace, 400ms cooldown; 1800ms hold with 2.5x unwind; 0.85s linear spinner; ~300ms crossfades.
6. Implement keyboard as a peer path, not a fallback (hold via keydown/keyup, detent jumps via Shift+Arrow/PageUp).
7. Respect `prefers-reduced-motion` by zeroing duration, never by deleting the state change; keep the sr-only `role="status"` announcer.
8. Keep springs in named constants (press 520/34/0.45, crossfade 260/34/0.8); reuse, don't hand-tune per instance.

## AI-slop warning

Three failure modes. (1) Copying the skin: agents clone the stone-palette example styling wholesale, producing a thousand identical grey 9px-radius buttons — the exact uniformity the hook/skin split exists to prevent. Keep behaviour, rewrite classes. (2) Spraying the patterns: hold-to-confirm on every button, detents on every slider, haptics on hover — these are commitment and precision tools; on casual actions they read as an interaction tax. A Save does not need 1800ms. (3) The blur(3px)+translateY(3px) crossfade becoming the default transition for *everything*, including text that simply appears — the move is for competing faces of one control, not a general fade-in idiom. And never add the motion dependency to ship one of these effects; the plain-CSS ports above cover the common cases.

## Relations

- `desengs-loading-dev` — galleries of loading patterns; interior is the finished subset (loading-button, skeleton-swap) with the race/width machinery those galleries omit.
- `desengs-transitions` — general spring/easing vocabulary; interior pins the exact constants (520/34/0.45, 260/34/0.8, 0.85s linear) and when each applies.
- `desengs-magic-ui` — also copy-in animated components, but effect-first (visual spectacle) where interior is behaviour-first (headless correctness); pick interior for app chrome, magic-ui for hero moments.
- `desengs-web-interface-guidelines` — the motion and a11y baseline (reduced-motion, focus, semantics) that interior implements at per-component depth; read both, guidelines first.
- `desengs-you-dont-need-animations` — the counterweight essay: before reaching for any of this, verify the animation carries information. Interior's own test — "nothing moves unless something happened" — agrees more than it contradicts.
