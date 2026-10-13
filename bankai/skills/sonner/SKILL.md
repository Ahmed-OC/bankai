---
name: sonner
description: Use when adding toast notifications to an app or recreating Sonner's feel by hand — stacking math, swipe physics, exact timing defaults, and when a toast is the wrong pattern.
source: https://sonner.emilkowal.ski/; https://emilkowal.ski/ui/building-a-toast-component
category: library
---

# Sonner — the opinionated toast that gets the details right

Source: https://sonner.emilkowal.ski/ — Emil Kowalski (github.com/emilkowalski/sonner, MIT). Design essay: "Building a toast component" (emilkowal.ski/ui/building-a-toast-component). 40M+ weekly npm downloads; used by Cursor, X, OpenAI.

## Why it exists

Sonner (French *sonner*, "to ring") entered a crowded toast market in 2023 with no feature gap to fill. Its two stated differentiators:

1. **Developer experience**: one `<Toaster />` mounted anywhere; `toast()` is a plain function callable from any module — no provider, no hook, no context. Observer pattern, not React Context.
2. **Opinionated beauty**: it looks and feels premium with zero configuration. Kowalski: "Beauty is generally underutilized in software so you can use it as leverage to stand out." The signature feature — **toasts that stack into a pile and expand on hover, with a swipe-to-dismiss that has real physics** — had been built inside companies but never open-sourced.

The lesson for any component: pick defaults so good that configuration is the exception, and spend your effort on the details nobody asks for (the Paul Graham "unseen details" argument — barely audible voices singing in tune).

## Anatomy and inventory

- **Call types**: `toast(message)`, `.success`, `.error`, `.info`, `.warning`, `.loading`, `.message`, `.promise(p, {loading, success, error})`, `toast.custom(jsx)`. Calling `toast()` again with the same `id` updates the toast in place — this is how promise states morph.
- **Toast content**: icon (16px) + title (13px, weight 500) + optional description (13px/1.4, muted) + one action button and/or cancel button (24px tall, 12px font). Never two stacked paragraphs.
- **Positions** (6): `top-left|center|right`, `bottom-left|center|right`. Default `bottom-right`. Swipe-out directions derive from position: bottom toasts swipe *down*, top toasts swipe *up*; left/right column toasts also swipe sideways.
- **Dismissible everywhere**: swipe (touch and mouse), close button, action button, hotkey `Alt+T` to expand + focus the list, `Escape` to collapse. `dismissible: false` disables all of them.
- **Styling modes**: default (light/dark/auto), `invert`, `richColors` (tinted per type), `unstyled`/headless.

## Exact defaults (from source constants)

| Value | Default |
|---|---|
| Auto-dismiss duration | 4000ms (`Infinity` = persist) |
| Visible toasts in stack | 3 (rest stay mounted, `opacity: 0`) |
| Gap between toasts | 14px |
| Toast width | 356px |
| Viewport offset | 24px desktop, 16px mobile (≤600px) |
| Transform/opacity/height transition | 400ms |
| Swipe dismiss threshold | 45px distance OR velocity > 0.11 px/ms |
| Swipe-out exit animation | 200ms ease-out; unmount after 200ms |
| Collapsed toast z-order | `toasts.length - index` (front on top) |

## The core mechanisms

### 1. Transitions, not keyframes

Keyframe animations cannot be interrupted; quickly adding toasts made them "jump into place." CSS transitions retarget mid-flight. Sonner drives *all* movement through one `--y` transform variable flipped by data attributes:

```css
[data-sonner-toast] {
  position: absolute;                 /* inside a fixed-width <ol> */
  opacity: 0;
  --y: translateY(100%);              /* start: off-screen past bottom edge; top: translateY(-100%) */
  --lift: -1;                         /* bottom position; top uses 1 — stacks grow away from the edge */
  transform: var(--y);
  transition: transform 400ms, opacity 400ms, height 400ms, box-shadow 200ms;
}
[data-sonner-toast][data-mounted='true'] { --y: translateY(0); opacity: 1; }  /* enter */
```

Enter animation runs by setting `data-mounted` in a `useEffect` after first paint. Pure-CSS modern equivalent: `@starting-style`.

### 2. Stacking and hover expansion

Collapsed (default): toasts pile behind the front one. Toast `i` sits `gap × i` toward the screen edge, scaled `1 − 0.05 × i` for depth (index 1: `Y(14px) scale(.95)`; index 2: `Y(28px) scale(.9)`), clamped to the front toast's height so uneven content heights don't tear the stack edge. Children get `opacity: 0` — a collapsed toast is a silhouette.

```css
[data-sonner-toast][data-expanded='false'][data-front='false'] {
  --y: translateY(calc(var(--lift-amount) * var(--toasts-before)))
       scale(calc(1 - var(--toasts-before) * 0.05));
  height: var(--front-toast-height);
}
```

Expanded (hover anywhere on the stack, or `expand` prop): each toast offsets by the *real summed heights* of the toasts before it plus `gap × index` — `offset = Σ heights_before + heightIndex × gap`. Heights are measured on mount and on every content change (`useLayoutEffect`, `height: auto` probe, restore). The `<ol>` gets `mouseenter/mousemove → expanded`, `mouseleave → collapsed` (suppressed while the user is mid-swipe). Stack auto-collapses when ≤1 toast remains. An `::after` pseudo-element (`height: calc(gap + 1px); bottom: 100%`) bridges each gap so the pointer traveling between toasts never leaves the hover target.

### 3. Swipe-to-dismiss physics

Pointer events, not drag libraries. On `pointerdown`: `setPointerCapture` (drag survives the cursor leaving the toast), record start point + time. Axis locks to x or y once movement exceeds 1px. Movement *away* from the allowed direction is damped, not blocked: `damped = delta / (1.5 + |delta| / 20)` — the toast resists like friction, no dead stop. The live offset is a CSS variable, so dragging is 1:1 with the finger:

```css
[data-sonner-toast][data-swiping='true'] {
  transform: var(--y) translateX(var(--swipe-amount-x, 0px)) translateY(var(--swipe-amount-y, 0px));
  transition: none;                   /* finger-tracked, not eased */
  user-select: none;
}
```

On release: `velocity = |swipeDistance| / elapsedMs`. Dismiss if `distance ≥ 45px || velocity > 0.11` (a fast flick beats distance); the 0.11 came from trial and error. Dismiss runs a 200ms ease-out keyframe from the *current* swipe offset to ±100%; a sub-threshold release zeroes the variables and the 400ms transition springs the toast back. While swiping, a `::before` pseudo-element 3× wide and 3× tall keeps the pointer over the toast on fast diagonal moves, and active text selection cancels the drag.

### 4. The auto-dismiss timer

No interval: one `setTimeout(remainingTime)`, paused and resumed without drift — on pause, `remaining -= now − startedAt`; on resume, restart the timeout with what's left. Pauses whenever: the stack is expanded (hover), a pointer is down on a toast (`interacting`), or `document.hidden` (background tab). `duration: Infinity` skips the timeout entirely — `setTimeout(fn, Infinity)` behaves like delay 0 and would close instantly (a JS quirk Sonner guards against). New toasts push in at the *front*; the front toast is the interactive one. Exit animations: front toast slides `±100%` toward its edge and fades; a collapsed non-front toast sinks `translateY(40%)` with `transform 500ms, opacity 200ms`; unmount waits 200ms (`TIME_BEFORE_UNMOUNT`) to match the exit duration.

### 5. Promise lifecycle

```js
notify.promise(save(), {
  loading: 'Saving…',
  success: (data) => `${data.name} saved`,   // string | fn(data) | ReactNode | {message, description}
  error: 'Could not save',
});
```

One id morphs through states: `loading` (spinner, no close button, timer disabled) → `success`/`error` (timer restarts at 4s). A resolved `fetch` Response with `!ok` routes to `error` automatically. The spinner and the result icon occupy the same 16px slot and crossfade (`opacity/scale 200ms`), which reads as one icon transforming rather than two swapping. Inspired by react-hot-toast's promise API (credited).

### 6. Rich colors per type

Opt-in (`richColors`), because tinted toasts are louder and most confirmations don't merit it. Light mode = near-white tinted bg (~L 96–97%), stronger border (L 84–94%), dark readable text (L 27–45%); dark mode = very dark tinted bg (L 6–10%), light text (L 65–81%). Exact seeds: success `hsl(143 85% 96%)` / text `hsl(140 100% 27%)`; error `hsl(359 100% 97%)` / text `hsl(360 100% 45%)` (light). The close button inherits the same trio. Default toast stays neutral: `#fff` bg, 1px gray4 border, `0 4px 12px rgba(0,0,0,.1)` shadow, 8px radius, 16px padding — shadows and borders do the hierarchy, not color.

### 7. Accessibility

Container: `aria-live="polite"`, `aria-relevant="additions text"`, `aria-label="Notifications (alt+T)"`. The live region is *not* in tab order (`tabIndex: -1`) — toasts must never steal focus; it becomes reachable only via the hotkey, which expands the stack and focuses it; `Escape` collapses; focus restores to the previously focused element on blur. Each toast is `tabIndex=0` with a `focus-visible` ring. `prefers-reduced-motion` kills every transition and animation. History capped at 100 dismissed toasts so long-running apps don't leak JSX.

## Toast vs inline message vs dialog (alert fatigue)

- **Toast**: consequence of an action the user just took ("Saved"), or async completion of a background job. Transient, non-blocking, dismissible, does not move focus. If the message still matters in 10 seconds, it is not a toast.
- **Inline message**: state bound to a page location — form validation, empty states, connection status. Must persist and sit where the user is looking; a toast that vanishes before scroll-back loses the information.
- **Dialog / alert**: decisions, destructive confirmations, errors requiring choice. Blocking on purpose; never auto-dismiss.
- Never report failure of something the user must react to in a 4s toast; never toast success for routine, expected actions ("Page loaded") — that is how users learn to ignore the corner of the screen. Dedupe repeated events by passing the same `id` (updates in place instead of stacking).

## When NOT to use this pattern

- One static confirmation that appears rarely: an inline element or a small fixed div is cheaper than a toast system.
- Full-bleed marketing pages where a bottom-right stack collides with chat widgets/cookie banners — check offsets.
- Heavy interactive content inside toasts (forms, navigation): toasts are announcements, not surfaces. Use a popover or dialog.
- Critical errors in `richColors` red that auto-dismiss after 4s — either persist (`Infinity`) or use a different surface.

## How to apply

1. Mount one fixed, `aria-live="polite"` region per app; notify via a module-level function (observer), not context.
2. Default position `bottom-right`; offset 24px (16px mobile); width 356px; never center-screen.
3. Default duration 4000ms; pause on hover, pointer interaction, and hidden tab; `Infinity` for toasts requiring a decision.
4. Show max 3 stacked; collapsed toasts are scaled (−0.05/index) silhouettes behind the front toast; expand on hover with real measured heights and gap bridging.
5. Make every toast dismissible by swipe (45px or velocity 0.11, damped wrong-axis) *and* close button *and* action button; derive swipe direction from position.
6. Use `toast.promise` for async actions; let one id morph loading → success/error with a crossfading icon.
7. Keep neutral styling by default; tint only for success/error/info/warning and only when opted in.
8. Re-measure toast height whenever content changes; the collapsed stack uses the front toast's height.
9. Respect `prefers-reduced-motion`: drop all transitions, keep the state changes.
10. Choose the surface first (inline > toast > dialog) — see the fatigue rules above.

## A minimal hand-built version

HTML: `<ol class="toaster" role="region" aria-live="polite"><li class="toast" style="--i:0">…</li></ol>`

```css
.toaster { position: fixed; bottom: 24px; right: 24px; width: 356px; list-style: none;
           margin: 0; padding: 0; z-index: 999999999; --gap: 14px; }
.toast { position: absolute; bottom: 0; width: 100%; box-sizing: border-box;
         padding: 16px; border-radius: 8px; background: #fff;
         border: 1px solid hsl(0 0% 93%); box-shadow: 0 4px 12px rgba(0,0,0,.1);
         font-size: 13px; display: flex; align-items: center; gap: 6px;
         --y: translateY(100%); transform: var(--y); opacity: 0;
         transition: transform 400ms, opacity 400ms, height 400ms; touch-action: none; }
.toast[data-mounted] { --y: translateY(0); opacity: 1; }
.toast[data-collapsed]:not([data-front]) {
  --y: translateY(calc(var(--gap) * var(--i))) scale(calc(1 - var(--i) * 0.05));
  height: var(--front-h, 56px); }
.toast[data-collapsed]:not([data-front]) > * { opacity: 0; }
.toast[data-expanded] { --y: translateY(calc(-1 * var(--off))); height: var(--h); }
.toast[data-expanded]::after { content:''; position:absolute; left:0; bottom:100%;
  width:100%; height:calc(var(--gap) + 1px); }
.toast[data-swiping] { transform: var(--y) translateX(var(--swipe-x,0px)) translateY(var(--swipe-y,0px));
                       transition: none; }
.toast[data-removed] { --y: translateY(-100%); opacity: 0; }
.toast[data-removed]:not([data-front]):not([data-expanded]) {
  --y: translateY(40%); opacity: 0; transition: transform 500ms, opacity 200ms; }
@media (prefers-reduced-motion: reduce) { .toast, .toast > * { transition: none !important; } }
```

```js
// Swipe: on pointerdown capture + record start/time; lock axis after 1px; on move:
//   allowed axis -> raw delta; other axis -> delta / (1.5 + Math.abs(delta)/20)  (damped)
//   el.style.setProperty('--swipe-x', x + 'px')  (and --swipe-y)
// on pointerup: const v = Math.abs(delta) / (Date.now() - t0);
//   if (Math.abs(delta) >= 45 || v > 0.11) remove(el);   // animate out, unmount after 200ms
//   else { el.style.setProperty('--swipe-x','0px'); /* 400ms transition springs back */ }
// Timer: remaining = 4000; pause() { remaining -= Date.now() - startedAt }
//        resume() { startedAt = Date.now(); setTimeout(remove, remaining) }
//        pause when hovered / pointer down / document.hidden; skip if remaining === Infinity
```

## When installing is justified

Install Sonner (or equivalent) when you need the full matrix on day one: multi-position, per-toast overrides, theming, RTL, `richColors`, promise API, a11y wiring, and the battle-tested edge cases (StrictMode re-subscribes, `setTimeout(Infinity)`, text-selection drags, pointer capture). The hand-built version above covers one position and default styling in ~80 lines; each additional behavior costs disproportionate testing. In a React app needing toasts, the dependency (~15kb) is almost always cheaper than the bugs.

## AI-slop warning

The bottom-right Sonner stack is now the default AI-generated feedback UI, and it is applied where it actively harms: toasting on page load, on hover, for every successful GET; success toasts for actions the user can see happen on screen; red `error` toasts that auto-dismiss before being read; stacking five toasts instead of deduping by id; centering toasts because the layout generator didn't know where to put them. The slop tell is *quantity* — a UI that toasts more than roughly once per user action is using toasts as a debugging console. Copy Sonner's restraint (neutral styling by default, one line of text, silence for expected outcomes), not just its look.

## Relations

- **emil-skills** — the author's broader craft catalog; Sonner is the flagship application of his "details compound into stunning" doctrine.
- **transitions** — the interruptibility argument (transitions over keyframes) that this library's stacking depends on; read for the general principle behind mechanism 1.
- **loading-dev** — async feedback patterns; pairs with the promise lifecycle and spinner crossfade defined here.
- **web-interface-guidelines** — timing and perceived-performance rules that justify the 400ms movement budget and hover-paused timers.
