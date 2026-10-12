---
name: desengs-emil-skills
description: Use when adding, reviewing, or auditing UI animations, micro-interactions, or toasts — durations, easing curves, springs, interruptibility, and whether something should animate at all.
source: https://github.com/emilkowalski/skills
category: principle
---

# Emil Kowalski's Skills (desengs) — whether, how, and how long to animate

Source: https://github.com/emilkowalski/skills — "Skills for Designers and Engineers", a repo of agent skills by Emil Kowalski (design engineer; years at Vercel and Linear; creator of Sonner and Vaul). No license stated in the repo.

## What it is / Why it exists

Thesis: agents don't have great taste — they pick `ease-in` for entrances, `scale(0)` origins, and keyframes for toasts. Small mistakes compound into interfaces that feel "off". These rules are the shortcut to interfaces that feel right.

The repo contains 12 skills: `emil-design-eng` (main philosophy), `animate` (build motion from scratch), `review-animations` + `STANDARDS.md` (strict review bar), `improve-animations` + `AUDIT.md` (codebase audit → prioritized plans), `find-animation-opportunities` (where motion helps, and where it doesn't), `animation-vocabulary` (naming motion effects), `apple-design` (WWDC fluid-interface principles for the web), `ask-sonner` + `API.md` (toast design and Sonner usage), `pick-ui-library` (curated library picks), `prototype` (build divergent UI variants behind a picker), `animate-expo` (React Native), `write-swift` (Swift).

## The core ideas

### Philosophy

- **Taste is trained, not innate.** Study why the best interfaces feel right; reverse-engineer animations.
- **Unseen details compound.** Users never notice individual correctness — they feel the aggregate.
- **Beauty is leverage.** Good defaults and motion are real differentiators in a sea of slop.
- **Restraint.** Sometimes the best animation is no animation. A short list of high-conviction motion beats an over-animated UI.

### 1. Should this animate at all? (the frequency gate)

Gate everything through this first. Keyboard-initiated actions are a **disqualifier, not a judgment call** (Raycast has no open/close animation — that is correct).

| Frequency | Decision |
| --- | --- |
| 100+ times/day (shortcuts, command palette toggle) | **No animation. Ever.** |
| Tens of times/day (hover, list navigation) | Near-imperceptible only, or nothing |
| Occasional (modals, drawers, toasts) | Standard animation |
| Rare / first-time (onboarding, success, celebration) | The delight budget lives here |

### 2. Purpose — name it before building it

Every animation must answer "why does this animate?" in one of these words:

- **Feedback** — confirming the interface heard the user (press scale)
- **Spatial consistency** — showing where something came from / went (toast enters and exits the same edge)
- **State indication** — making a state change legible (morphing button, accordion)
- **Preventing a jarring change** — bridging content that would teleport
- **Explanation** — demonstrating how something works (marketing/onboarding only)
- **Delight** — allowed *only* at the rare/first-time tier

Can't name it? Don't build it. "It looks cool" on a frequently-seen element is a reason to stop. Data the user is **reading** (a functional chart) must not move for style — decoration belongs on marketing pages.

### 3. Easing

Decision order: entering/exiting → **ease-out**; moving on screen → **ease-in-out**; hover/color → `ease`; constant motion (progress, marquee) → `linear`; default → ease-out.

**Never `ease-in` on UI.** It starts slow, delaying the exact moment the user watches most. `ease-out` at 200ms *feels* faster than `ease-in` at 200ms.

Built-in CSS easings are too weak. Use strong curves as tokens:

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);     /* strong ease-out for UI */
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1); /* on-screen movement */
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);  /* iOS-like drawer curve */
```

Need another curve? Take it from a curve catalog (easing.dev, easings.co). Never hand-roll one.

### 4. Duration and perceived performance

**UI animations stay under 300ms.** A 180ms dropdown feels more responsive than a 400ms one; a fast-spinning spinner makes the same load feel faster.

| Element | Duration |
| --- | --- |
| Button press feedback | 100–160ms |
| Tooltips, small popovers | 125–200ms |
| Dropdowns, selects | 150–250ms |
| Modals, drawers | 200–500ms |
| Marketing / explanatory | Can be longer |

Perceived-speed tricks: instant tooltips after the first one is open (skip delay *and* animation); asymmetric timing — slow where the user is deciding (hold-to-confirm: 2s linear), snappy where the system responds (release: 200ms ease-out).

### 5. Physicality

- **Never `scale(0)`.** Nothing in the real world appears from nothing. Start from `scale(0.95)` + `opacity: 0`.
- **Origin-aware popovers.** Dropdowns, menus, tooltips scale from their **trigger**, not center: `transform-origin: var(--transform-origin)`. **Modals are exempt** — they stay centered.
- **`translateY(100%)`** is relative to the element's own height — how Sonner and Vaul position things. Prefer percentages over hardcoded pixels.
- **`scale()` scales children too** — that's why a press scale reads as physical.
- **`clip-path: inset(t r b l)`** is a first-class animation tool: reveals, hold-to-confirm fills, seamless tab color transitions (duplicate the tab list, clip the active copy), comparison sliders.
- **Springs** (when a lib is justified) for drag with momentum, "alive" elements, interruptible gestures: `{ type: "spring", duration: 0.5, bounce: 0.2 }`. Bounce stays 0.1–0.3 and only for drag-to-dismiss / playful moments.

### 6. Interruptibility

- **CSS transitions, not `@keyframes`, for anything triggered rapidly** (toasts, toggles). Transitions retarget from the current value; keyframes restart from zero.
- **Springs for gestures** — they carry velocity through an interruption.
- **Exit the way it entered.** A toast sliding in from the bottom leaves through the bottom; symmetric paths make swipe-to-dismiss obvious.
- Gesture hygiene: pointer capture, multi-touch protection (`if (isDragging) return`), damping past boundaries (rubber-band, not a wall), dismiss on **velocity** (`|distance|/elapsedMs > ~0.11`), not just distance.
- A jarring crossfade that shows two overlapping states can be masked with `filter: blur(2px)` during the transition (keep under 20px — expensive in Safari).

### 7. Performance

- **Animate `transform` and `opacity` only** (`clip-path` is the sanctioned fourth; `height` tolerated for accordions only). `width`/`height`/`margin`/`top`/`left` trigger layout + paint.
- **Never `transition: all`** — name the exact properties.
- **Don't drive a child's transform from a CSS variable on the parent** — it recalcs styles for every child. Set `transform` on the element directly.
- **CSS animations run off the main thread** and stay smooth under load; rAF-based JS animation drops frames while the browser loads/paints. CSS for predetermined motion, JS for dynamic/interruptible. **WAAPI** (`element.animate()`) = JS control with CSS performance, no dependency.
- Cheapest tool that works: CSS transition → `@starting-style` → CSS animation → WAAPI → motion library. Don't install a library for a fade.

### 8. Accessibility — ships with the animation, not as a follow-up

```css
@media (prefers-reduced-motion: reduce) {
  .el { animation: fade 0.2s ease; } /* keep opacity/color, drop movement */
}
@media (hover: hover) and (pointer: fine) {
  .el:hover { transform: scale(1.05); } /* touch fires false hovers on tap */
}
```

Reduced motion = **fewer and gentler, not zero** — keep comprehension-aiding opacity/color, remove movement. In React: `const closedX = reduce ? 0 : '-100%'`.

### 9. Toasts (the Sonner principles)

Emil built Sonner (13M+ weekly downloads); `ask-sonner` is as much a design doc as an API reference.

**When/what to toast:** confirm completed background or async work (success/error), surface results of actions whose outcome the user may miss, progress on long tasks (`loading` → success/error, same toast **id** so it morphs instead of stacking). Never toast what the user can already see happen inline.

**Behavior rules:**

- One `<Toaster />` mounted at the root, once. `toast()` is a plain function — no hooks, no context, no provider. **DX is key: the less friction, the more it gets used.**
- **Good defaults matter more than options.** Excellent default easing, timing, and visuals; most users never customize.
- Position by convention: `bottom-right` desktop (32px offset), 16px on mobile. Stack max ~3 visible, 14px gap.
- Default `duration: 4000ms`; `Infinity` only for critical items. Errors get `toast.error`, successes `toast.success` (rich colors, clear icons).
- **Handle edge cases invisibly:** pause timers when the tab is hidden; keep hover state across stacked gaps with pseudo-elements; capture pointer during swipe; dismiss on flick (velocity), not just distance.
- **Transitions, not keyframes** — toasts fire rapidly and must retarget mid-flight.
- **Cohesion:** Sonner's motion is slightly slower than generic UI and uses `ease` rather than `ease-out` — tuned to the component's *personality*, not a generic budget. Match motion to mood: playful can bounce; a dashboard stays crisp.
- Unstyled/edge-case ladder: defaults → inline `toastOptions` styles → per-part classes → headless (`toast.custom`) keeping positioning/stacking/swipe.

### 10. The rest of the repo

- **apple-design:** fluid interfaces for the web — respond on pointer-down, 1:1 drag tracking, interruptibility as the #1 principle, velocity handoff into springs, momentum projection (flick → projected landing point), rubber-banding, translucent materials (`backdrop-filter`) for hierarchy, size-specific typography tracking, Apple's eight design principles (purpose, agency, familiarity, simplicity-not-minimalism, craft, delight…).
- **pick-ui-library:** curated picks — base-ui (unstyled primitives), Sonner (toasts), cmdk (⌘K), motion (springs/layout/exit), recharts, dnd kit, Virtuoso, zustand, clsx/cva. Catch: hand-rolled toasts, `<div>` dropdowns without focus management.
- **prototype:** build 3+ genuinely divergent variants (named axes, not "Option A/B") behind a live picker; the variant swap itself gets **no animation** (100+/session rule).
- **animation-vocabulary:** precise names for effects (origin-aware animation, stagger, rubber-banding, shared element transition, shimmer, number ticker…) so you can ask for exactly what you mean.
- **improve-animations / review-animations:** audit workflow — recon (stack, tokens, frequency map) → 8-category audit (purpose/frequency, easing/duration, physicality, interruptibility, performance, a11y, cohesion/tokens, missed opportunities) → findings table `Before | After | Why` → severity-ranked, self-contained plans with exact values. Debug by slow motion (2–5× duration), frame-by-frame DevTools, real devices, and fresh eyes the next day.
- **animate-expo / write-swift:** same taste bar for React Native (keep motion off the JS thread, tab switches never slide) and Swift — out of scope for web work, noted for completeness.

## When to use / When NOT to use

Use when:

- Building any enter/exit transition, hover/press effect, loading state, or list entrance.
- Deciding **whether** something should animate (the answer is often "no" — that's a success).
- Building or redesigning a toast/notification system.
- Reviewing existing motion: flag, don't approve — approval is earned.
- Sweeping an app for missed motion opportunities and over-animated hot paths.

Do NOT use when:

- The action runs at keyboard speed or 100+/day — the gate already answered "no animation".
- The element only changes color or content with no spatial meaning — a plain swap is correct.
- The motion is for a data-reading surface (charts, tables the user scans) — decoration belongs on marketing pages.

## Concrete patterns (React + hand-written CSS, no libraries)

```css
/* Motion tokens — extend these, never fork */
:root {
  --ease-out: cubic-bezier(0.23, 1, 0.32, 1);
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
}
```

**Button press** (any pressable element, feedback tier):

```css
.button { transition: transform 160ms var(--ease-out); }
.button:active { transform: scale(0.97); }
```

**Toast enter/exit** — `@starting-style` for mount, transitions for interruptibility, same edge in and out:

```css
.toast {
  position: fixed;
  opacity: 1;
  transform: translateY(0);
  transition: opacity 400ms ease, transform 400ms ease;
}
.toast[data-leaving] { opacity: 0; transform: translateY(100%); }
@starting-style { opacity: 0; transform: translateY(100%); }

@media (prefers-reduced-motion: reduce) {
  .toast { transform: none; transition: opacity 200ms ease; }
}
```

Legacy fallback when `@starting-style` is unsupported — the mount-flag pattern:

```tsx
function Toast({ children }: { children: React.ReactNode }) {
  const [mounted, setMounted] = useState(false);
  const [leaving, setLeaving] = useState(false);
  useEffect(() => { const id = requestAnimationFrame(() => setMounted(true)); return () => cancelAnimationFrame(id); }, []);
  return <div className="toast" data-mounted={mounted} data-leaving={leaving} role="alert">{children}</div>;
}
```

**Popover from its trigger** (modals stay `center`):

```css
.popover {
  transform-origin: top right; /* the trigger's corner */
  transition: opacity 200ms var(--ease-out), transform 200ms var(--ease-out);
}
.popover[data-closed] { opacity: 0; transform: scale(0.95); }
```

**Stagger** (occasional lists only; 30–80ms; never blocks interaction):

```css
.item { opacity: 0; transform: translateY(8px); animation: fade-in 300ms var(--ease-out) forwards; }
.item:nth-child(2) { animation-delay: 50ms; }
.item:nth-child(3) { animation-delay: 100ms; }
@keyframes fade-in { to { opacity: 1; transform: translateY(0); } }
```

**Hold-to-confirm** (destructive actions — asymmetric timing, `linear` because it's a progress indicator):

```css
.overlay { clip-path: inset(0 100% 0 0); transition: clip-path 200ms var(--ease-out); }
.button:active .overlay { clip-path: inset(0 0 0 0); transition: clip-path 2s linear; }
```

**WAAPI when JS control is needed without a dependency:**

```js
el.animate(
  [{ clipPath: 'inset(0 0 100% 0)' }, { clipPath: 'inset(0 0 0 0)' }],
  { duration: 600, fill: 'forwards', easing: 'cubic-bezier(0.77, 0, 0.175, 1)' }
);
```

## Anti-patterns (never ship)

| Never | Instead |
| --- | --- |
| `transition: all` | Name the exact properties |
| `transform: scale(0)` entrance | `scale(0.95)` + `opacity: 0` |
| `ease-in` on any UI element | `ease-out` / `cubic-bezier(0.23, 1, 0.32, 1)` |
| Animation on keyboard/100+/day actions | No animation |
| UI duration over 300ms without reason | 150–250ms |
| `transform-origin: center` on trigger-anchored popover | Origin at the trigger (modals exempt) |
| Keyframes on toasts/toggles (rapidly triggered) | CSS transitions (interruptible) |
| Animating `width`/`height`/`margin`/`top`/`left` | `transform` / `opacity` |
| Ungated `:hover` motion | `@media (hover: hover) and (pointer: fine)` |
| Missing `prefers-reduced-motion` | Gentler variant, not zero |
| Everything entering at once | 30–80ms stagger |
| Symmetric timing on press-and-release | Slow deliberate phase, snappy response |
| Toasting what's already visible inline | Toast async outcomes and background results |
| Hand-rolling toast stacking/swipe/focus | A proven implementation with good defaults |

## How to apply

1. **Add motion tokens first**: `--ease-out`, `--ease-in-out`, `--ease-drawer` in `:root` exactly as above. Everything else extends them.
2. **Rebuild any ad-hoc notification as a real toast stack** — fixed position (bottom-right, 16–32px offset, max 3, gap 14px), a module-level `toast()` store + one `<Toaster />` at the root, `role="alert"`, auto-dismiss ~4s, success/error variants, enter/exit via the `.toast` pattern above (`@starting-style` + `data-leaving`, 400ms `ease`, same edge in and out). Transitions, not keyframes.
3. **Replace inline banners and busy text with toasts**: inline success/error messages become toasts; a "working…" status becomes a loading toast (fast spinner — perceived performance) updated by id on completion, never duplicated.
4. **Press feedback on every button** (nav tabs, submits, cards): `:active { transform: scale(0.97) }`, `transition: transform 160ms var(--ease-out)` — the single highest-leverage "feels alive" fix.
5. **Tab/panel switches are tens-per-day**: near-imperceptible only — 150–200ms `opacity` + `translateY(4px)` entrance on the incoming panel (mount-flag or `@starting-style`), no exit animation, nothing on the tab buttons themselves beyond press scale.
6. **Grid/list entrances**: 30–80ms stagger on lists that load as a new view (occasional tier — eligible); decorative only, never blocks interaction.
7. **Focus and hover transitions**: `transition: border-color 150ms ease, background-color 150ms ease` on inputs/selects; card hovers get `translateY(-1px)` or border-color shifts gated behind `@media (hover: hover)`.
8. **Accessibility pass in the same PR**: one global `prefers-reduced-motion` block that strips transforms and keeps opacity; hover gating per rule 8 above.
9. **Never introduce**: `transition: all`, `ease-in`, `scale(0)`, keyframe-based toasts, >300ms UI durations. When reviewing a diff, use the Anti-Patterns table and output `Before | After | Why`.
10. **Feel-check before shipping**: play transitions at 2–5× duration in DevTools, recheck the next day — a toast's opacity-vs-stacking-height balance has no formula; adjust until it feels right.

## AI-slop warning

This is exactly the failure mode the repo exists to fix. AI typically: animates keyboard-triggered actions (command palettes, shortcuts) that must be instant; picks `ease-in` for entrances and `scale(0)` origins; uses `@keyframes` for rapidly-triggered toasts and toggles so they restart on spam; writes `transition: all`; animates `width`/`height`/`top`/`left`; puts `transform-origin: center` on trigger-anchored popovers; ships 400ms+ durations on micro-interactions; adds bounce springs to everything until nothing reads as urgent; forgets `prefers-reduced-motion` and hover gating entirely; and toasts events the user just watched happen inline. The other failure is over-animation: stagger on every list, delight on hot paths. Run the frequency gate and the purpose vocabulary before writing a single line of motion CSS — "no animation" is a frequent and correct output.

## Relations

- **desengs-sonner** — the toast library this skill's §9 rationalizes; that skill carries the implementation math (stacking geometry, swipe physics, exact timing) in full.
- **desengs-animations-dev** — Kowalski's animation course; the deeper curriculum behind the `animate` skill, for building motion from first principles.
- **desengs-easing** — the bezier/spring catalog supplying exact curve values for the easing tokens here (note: easing.dev is Vanderzon/Axon, not Kowalski).
- **desengs-you-dont-need-animations** — the essay-length veto; this skill's frequency gate is its operational form.
- **desengs-transitions** — which property pairs to transition and when; pairs with the duration/easing tables in §3–4.
