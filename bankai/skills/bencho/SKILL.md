---
name: bencho
description: Use when picking an implementation route for a standard interactive component — native, hand-rolled, copied MIT block, or installed library — or when porting micro-interactions like slide-to-confirm or magnetic hover.
source: https://bencho.dev/
category: reference
---

# Bencho — live micro-interaction blocks and the build-vs-copy-vs-install verdict

Source: https://bencho.dev/ — Lorenzo Cabra, freelance designer, © 2026. A free library of 48 live React micro-interaction blocks ("everything is live, not mocked"), 82 browser-synthesized UI sounds, and a curated wall of ~129 credited interaction clips ("Finds"). The blocks and everything the Code pane hands you are MIT — ship, change, sell, no attribution on the interface; the site, the goat mark, and the photographs inside some blocks are not (swap your own photos, keep the MIT notice with substantial source copies).

> Format note: the name is *bench*, not benchmark. Bencho hosts no library face-offs — it is a workbench of takeable implementations. Its generalizable value is the route decision (build / copy / install) plus the gesture taxonomy that indexes every block.

## What it is / Why it exists

Four surfaces, one thesis: micro-interactions are too small to justify a dependency and too fiddly to hand-roll well cold.

- **Blocks** (48): Asset swap, Like, Eye tracker, Upload dropzone, One-time code, Todo tower, Action node, Assignees, Palette, Now playing, Pull to refresh, Create menu, Radial menu, Inline confirm, Magnifying dock, Progress ticks, Heat map, Signature pad, Dynamic island, Particles, Generate, Image accordion, Magnetic select, Checklist, Aspect ratio, Dragging ball, Escape button, Reorder list, Drag stepper, Wheel, Selection list, Range dial, Image compare, Voice note, Time scrubber, Label input, Step player, Glass bubble, Slide to confirm, Carousel, Tilt card, Search, Slosh slider, Canvas toolbar, Notify, Icon bar, Command bar, Liquid toggle.
- **Sounds** (82): synthesized in-browser, grouped in 8 categories — Actions, Feedback, Movement, Navigation, Notifications, Progress, Selection, System.
- **Finds** (~129): other people's interaction clips, credited, filterable by gesture *and* effect.
- **Bench**: an infinite canvas where kept blocks are arranged and tuned live — the tuning step is part of the product.

Why it exists: the distribution model is copy-paste, not install. You leave with code you own, not a dependency you maintain. That model is itself the lesson.

## The core ideas

### 1. Index components by gesture, not widget class

Every block carries one verb: **Press, Hover, Drag, Slide, Swipe, Scroll, Type, Select**. Finds adds effect tags: **Magnetic, Morph, Parallax, Elastic, Reveal, Refract**. Adopt this vocabulary when specifying work ("a Drag block with Elastic return") because the gesture determines the implementation contract:

| Gesture | Events you must handle | Non-pointer fallback |
|---|---|---|
| Press | `pointerdown/up`, `click` | native button, already free |
| Hover | `pointerenter/leave` | visible focus + same action on click |
| Drag | `pointerdown/move/up` + `setPointerCapture` | button/slider equivalent |
| Slide | pointer + velocity | arrow keys |
| Swipe | touch `touchstart/move` + scroll-snap | scroll + arrows |
| Type | `input`, `paste` | none needed |
| Select | `change`, `keydown` | native select/checkboxes |

Rule: a gesture verb names the *primary* input only. Every block still ships a keyboard/AT path — a slide-to-confirm is still a button underneath.

### 2. "Live, not mocked"

The gallery wall runs the real component, not a video. Corollary for agents: never treat a GIF or Loom of an interaction as an implementation reference — weights, thresholds, and spring constants cannot be read off a recording. When porting any block (Bencho's or a Find), port the *numbers*, not the look: travel distances, thresholds, easing, reset timeouts.

### 3. The route ladder — build vs copy vs install

Score any standard component on four axes before choosing: (a) bytes vendored vs dependency weight + supply chain, (b) input coverage (pointer/touch/keyboard/AT), (c) ownership — can you change the spring?, (d) uninstall cost. Then apply the ladder, stopping at the first route that passes:

1. **Native first.** If the platform does it, the platform wins: `details/summary`, `dialog`, `input[type=range]`, scroll-snap carousels, `popover`. Zero JS, a11y included.
2. **Hand-roll** when the component is a *feel*: under ~60 lines of pointer math, no focus-management surface, physics specific to your brand.
3. **Copy an MIT block** (the Bencho route) when it is a *known pattern* (like, slide-to-confirm, command bar chrome, slosh slider): vendor it into your components directory, strip demo data, retheme tokens. You keep the code.
4. **Install a library** only when the cost lives in edge cases — focus traps, typeahead, queuing, RTL, keyboard reorder. **Libraries win state machines; blocks and hand-rolled code win physics.** A library's visual layer is its cheapest part — never install one for the animation alone.

Verdicts per family (components above map here):

- **Carousel** → native `scroll-snap-type: x mandatory` + `scroll-padding: 80%`; install only for loop/RTL/free-scroll beyond snap. Copy a block only for the cards-lean-into-throw feel.
- **Command bar (⌘K)** → install or copy the *whole* block: typeahead + listbox focus is 80% of the work, the effect is nothing.
- **Toasts (Notify)** → queue with `aria-live="polite"`, stacking, dedupe; the slide-in is trivial, the lifecycle is not.
- **Slider (Slosh/Range dial)** → style the native `input[type=range]`; the slosh is a CSS layer on top (below).
- **Select** → native `<select>` when options are text and > ~8; magnetic/segmented variants only for few, iconic options.
- **Reorder list** → library: keyboard reorder + drop semantics are most of the cost.
- **One-time code** → hand-roll: one input + `autocomplete="one-time-code"` + paste split.
- **Like / favorite** → hand-roll: ~30 lines, `aria-pressed`.
- **Destructive confirm** → inline confirm (two-state button, ~2.5 s reset) over a modal: no route change, no context loss.
- **Slide-to-confirm** → copy the block: pointer math + spring return, with a plain button for AT.
- **Pull to refresh** → hand-roll, touch-scroll surfaces only (`overscroll-behavior: contain`); never on desktop.
- **Signature pad** → copy: pointer-events canvas, quadratic-midpoint smoothing is the only trick.
- **Image compare** → hand-roll: a range input over two images — semantics free.
- **Radial / create menu** → copy the block; you must add arrow-key navigation and Escape yourself.
- **Upload dropzone** → hand-roll on a real `input[type=file]` + `dragover`; progress from the upload stream.

### 4. The mechanisms (plain JS/CSS, no dependency)

**Slide-to-confirm** — one pointer capture, a 98% threshold, spring back:

```js
const max = () => track.clientWidth - knob.offsetWidth;
knob.onpointerdown = e => knob.setPointerCapture(e.pointerId);
knob.onpointermove = e => {
  if (!knob.hasPointerCapture(e.pointerId)) return;
  const x = clamp(e.clientX - track.getBoundingClientRect().left - knob.offsetWidth / 2,
                  0, max());
  knob.style.transform = `translateX(${x}px)`;
  if (x >= max() * 0.98) { fire(); release(); }   // past 98% of travel it commits
};
knob.onpointerup = () => spring(knob, 0);          // anything less snaps back
```

**Spring return** — critically damped, settles in ~200 ms, no library:

```js
function spring(el, to, prop = 'translateX') {
  let v = 0, x = current(el), last = performance.now();
  el.style.transition = 'none';
  (function tick(t) {
    const dt = Math.min((t - last) / 1000, 0.05); last = t;
    const k = 180, c = 24;                          // stiffness, damping
    v += (-k * (x - to) - c * v) * dt; x += v * dt;
    el.style.transform = `${prop}(${x}px)`;
    if (Math.abs(x - to) > 0.1 || Math.abs(v) > 1) requestAnimationFrame(tick);
  })(last);
}
```

**Magnetic hover** — translate toward the cursor, capped; a plain CSS transition does the return:

```js
const MAX = 6;                                     // px; past ~8 it stops being magnetism
onPointerMove: el.style.transform =
  `translate(${clamp(dx * 0.25, -MAX, MAX)}px, ${clamp(dy * 0.25, -MAX, MAX)}px)`;
onPointerLeave: el.style.transform = '';            /* transition: transform 200ms ease-out */
```

**Slosh slider** — corner radii oppose drag direction:

```css
.fill   { border-radius: 12px; transition: border-radius 120ms linear; }
.right  { border-radius: 4px 16px 16px 4px; }       /* dragging right: leading edge tightens */
.left   { border-radius: 16px 4px 4px 16px; }
```

**Eye tracker** — pupils via `atan2`, travel capped under 3 px:

```js
const a = Math.atan2(e.clientY - cy, e.clientX - cx);
pupil.style.transform = `translate(${Math.cos(a) * 2.5}px, ${Math.sin(a) * 2.5}px)`;
```

**Inline confirm** — state machine with reset: idle → armed (label swaps to "Sure?", ~2.5 s timeout back to idle) → done. Announce the state change with `aria-live="polite"`; never block on a modal for it.

### 5. Sound is a separate, opt-in layer

Bencho ships sounds apart from blocks — pairing is by category, matched to the gesture verb: Selection→tick/latch, Actions→tap/thump, Navigation→swoop/glide, Progress→settle/rise, Notifications→chime/pip, Feedback→sigh/buzz, Movement→drift/wisp, System→boot/hum. Rules that keep it from becoming noise: one sound per gesture (never per animation frame), ≤ 120 ms, quiet enough to miss at half volume, user toggle that persists, and `prefers-reduced-motion` kills sound with the motion.

## When to use / When NOT to use

Use when: building a standard interactive component and the question is route, not design; porting a micro-interaction from a clip; deciding whether a dependency is justified; adding feel (physics, sound) to otherwise correct components.

Do NOT use when: the component is a state machine you have not specced (focus order, roles, keyboard map) — no block fixes that; in accessibility-regulated products where a gesture (slide-to-confirm, signature, drag-reorder) cannot carry a documented non-pointer path; on tight performance budgets — Particles, Heat map, and Glass blocks are canvas/blur-heavy and meter mobile before shipping them.

## How to apply

1. Classify the component by gesture verb; write down its non-pointer fallback before writing any pointer code.
2. Run the ladder: native → hand-roll (< ~60 lines, no focus surface) → copy MIT block → install. State which axis decided it (bytes, inputs, ownership, uninstall).
3. If copying: vendor into your components directory, delete demo data and photographs, replace fonts/tokens with yours, add the keyboard path and `prefers-reduced-motion`, keep the MIT notice in a source comment.
4. If hand-rolling: start from the mechanism snippets; port thresholds and spring constants (98% commit, k≈180/c≈24, 6 px magnet cap, 2.5 s confirm reset), then tune live — the reason the Bench canvas exists.
5. Add sound last, if at all, paired by category under the rules above.
6. Verify four inputs before calling it done: mouse, touch, keyboard-only, screen-reader announcement.

## AI-slop warning

The failure mode is cargo-culting the bench: pasting liquid toggles, dynamic islands, and glass bubbles into one product until the UI is a portfolio of borrowed tics. Blocks are starting points to retheme, not a look. The second failure: copying the gesture and skipping the contract — no button under the slide-to-confirm, no `aria-pressed` on the like, sound on by default, no reduced-motion path. A copied block without its fallback input is worse than a plain native control. Enterprise forms and regulated products are poisoned contexts for gesture-only patterns entirely.

## Relations

- **cmdk** — the command-bar verdict expanded: why typeahead + listbox focus is the cost, not the animation.
- **sonner** — the toast queue done right: the lifecycle half of the Notify verdict.
- **transitions** — the easing and spring numbers the blocks above assume; tune from there, not from zero.
- **component-gallery** — the same curatorial eye as Finds, for choosing *what* to build before choosing the route.
- **web-interface-guidelines** — the non-pointer fallbacks and announcements every gesture block must keep to stay shippable.
