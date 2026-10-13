---
name: devouring-details
description: Use when doing a final polish pass on interactive UI and deciding which micro-details (hit areas, state transitions, motion timing, scroll fades, drag snapping) to add, each with its exact implementation.
source: https://devouringdetails.com/
category: reference
---

# Devouring Details — the craft details that separate good from great

Source: https://devouringdetails.com/ — Rauno Freiberg (Staff Design Engineer at Vercel: platform, design system, Next.js Dev Tools; previously The Browser Company on Arc; author of `cmdk`). A paid ($249) interactive reference manual for "interaction-curious designers": 23 chapters, 23 downloadable React components, Awwwards Honorable Mention (Jul 2025). All rights reserved; two chapters are free ("Next.js Dev Tools", "Behind scenes").

> Note: 21 of 23 chapters are paywalled. This skill distills the two free chapters verbatim, the public landing (full structure and taxonomy), and the author's free essays. Chapter names and quoted techniques are verified; nothing else about paid chapters is invented.

## What it is / Why it exists

- Not a linear course: "You won't solve code challenges, answer quizzes, or follow step-by-step tutorials. Instead, you'll interact with prototypes on a custom platform and be exposed to details that I pay attention to." A reference manual the author himself revisits mid-design.
- Its learning model, quoted: you learn "by trying to build an idea and realising it sucks in practice. With enough iterations and sometimes by accident I'll get to a place where it feels really good and I'll suddenly be able to reason why it sucked." The manual is "your shortcut to those learning moments."
- Title as definition: "to devour details means to be fanatically obsessed with imbuing every aspect of your work with care."
- Structure (3 units, the site's own taxonomy):
  - **Principles** (8): Inferring intent, Interaction metaphors, Ergonomic interactions, Simulating physics, Motion choreography, Responsive interfaces, Contained gestures, Drawing inspiration.
  - **Prototypes** (10, each a deep dive into one component with source): Line Minimap, Scroll Strip, Radial Timeline, Morph Surface, Line Graph, Next.js Dev Tools (free), Logos Carousel, Motion React, Blur Reveal, Time Machine.
  - **Resources** (8): Behind scenes (free), Code snippets, Design workflow, Component library, Public bookmarks, Frequent questions, Design philosophies, React handbook.
- The hook question that opens the site: "Have you ever noticed that some animation sequences can be improved with just a touch of delay? Or that some interactions just feel better without any motion at all?" Polish = knowing when to add, delay, or delete motion — not adding more of it.

## The core ideas

### 1. Motion carries information, and peripheral vision is the channel
- "Motion is a great way to draw attention to an element that offers new, useful information if the element was previously on the screen in another state."
- "Humans are sensitive to subtle changes in peripheral vision so it's important to communicate only useful, not cosmetic changes unrelated to their primary intent." Animate state changes a user acted on or that the system owes them; never animate decoration.
- Corollary (author's essay "Invisible Details of Interaction Design"): frequently-used surfaces lose motion entirely — macOS context menus appear with no motion, and command menus opened "hundreds of times a day" should drop entrance animation; his bmrks.com animations "felt good for a couple of days" before feeling sluggish.

### 2. State transitions respond to input — never to first paint
- "Often state transitions accidentally play out when the page loads, but this makes the application feel poorly built. State transitions are best reserved for responding to input or changes in the system."
- If the state was already true before render (e.g., a build error exists on mount), render the final state immediately. Mechanism: gate transitions on mount.

```jsx
const [mounted, setMounted] = useState(false);
useEffect(() => { const r = requestAnimationFrame(() => setMounted(true)); return () => cancelAnimationFrame(r); }, []);
<div style={{ width: measured ?? "auto" }} className={mounted ? "transition-[width] duration-200 ease-out" : undefined} />
```

- Size animation needs measured pixel values: "use measured values when available, otherwise assume intrinsic size with `auto`. For async content rendered immediately, defer measured values until dimensions stabilize" — i.e., keep `auto` until content settles, then capture px and only then allow width transitions.

### 3. Replaying CSS keyframes without an animation library
- The issue-count in Next.js Dev Tools animates on every update with zero JS animation deps: change a React `key` to force a re-mount, which replays the CSS animation. Same mechanism as his Logos Carousel prototype.

```jsx
<span key={count} className="count-in">{count}</span>
```

```css
@keyframes count-in { from { transform: translateY(100%); opacity: 0; } }
.count-in { animation: count-in 200ms ease-out; }
```

### 4. Reduced responsiveness: updates can outpace animation
- Real data arrives in bursts — the error count re-rendered 2–3 times within one animation. Fix: "in the animation callback, measure time since each update and cancel animations to reduce responsiveness." Snap to the latest value instead of restarting a transition per event.

```js
let lastUpdate = 0;
function onCountUpdate(value) {
  const now = performance.now();
  if (now - lastUpdate < 200) { el.getAnimations().forEach(a => a.cancel()); setText(value); }
  else { setText(value); } // transition plays
  lastUpdate = now;
}
```

### 5. Ergonomics: concentric hit areas, sibling buttons, dual focus rings
- Concentric (shared-center) interactive areas "look appealing and maximize use of space for pointer ergonomics."
- Never nest interactive elements: a `<button>` inside a `<button>` is invalid HTML. Place them as siblings and visually enlarge targets with CSS (absolute positioning over the same visual circle).

```html
<div class="badge">
  <button class="target trigger">3 issues</button>
  <button class="target action" aria-label="Toggle issue list"></button>
</div>
```

```css
.badge { position: relative; display: inline-grid; place-items: center; }
.target { cursor: pointer; }
.action { position: absolute; inset: -6px; } /* oversized, concentric */
```

- Focus rings are state-dependent: default state gets the brand-colored outset ring; the error state (red surface) gets an inset white ring for contrast.

```css
.trigger:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; }
.badge[data-error] .trigger:focus-visible { outline: 2px solid #fff; outline-offset: -2px; }
```

### 6. Sand the edge cases; interactions must tolerate spamming
- Verbatim: "Interactions should feel robust, interruptible, and in the worst case—tolerate spamming without breaking." And "the only way to sand all edge cases is to just click around a lot until you stop finding broken states" (after Jim Nielsen's "sanding UI" woodworking metaphor).
- Mechanism from the chapter: a debug tool with keyboard shortcuts bound to every state — `I` increments the issue count, `X` collapses, `R` resets. Ship it behind a flag and hammer it.

```js
window.addEventListener("keydown", (e) => {
  if (!debugMode) return;
  if (e.key === "i") setCount((c) => c + 1);
  if (e.key === "x") setCollapsed((c) => !c);
  if (e.key === "r") reset();
});
```

### 7. Custom shapes: glue an SVG to a resizing HTML box
- A cut-off "notch" container with a curved tail is "practically impossible" via CSS paths: render the curve as an SVG exported from the design tool, absolutely position it at the box edge so the illusion of one continuous curve holds, and let the HTML contents grow without breaking the effect.

```html
<div class="panel">
  <div class="panel-contents"><!-- any height --></div>
  <svg class="tail" viewBox="0 0 24 12" preserveAspectRatio="none" aria-hidden="true"><path d="M0 0 C 12 0, 12 12, 24 12 L 24 12 0 12 Z" fill="inherit"/></svg>
</div>
```

```css
.panel { position: relative; }
.tail { position: absolute; top: 100%; left: 0; width: 100%; height: 12px; }
```

### 8. Soften scroll-clipped content with a sticky fade
- A sticky header clips content under it. Fix: a fade element positioned `sticky` directly below the header, with opacity interpolated from the container's scroll position: `opacity = min(1, scrollTop / 15)`. "The 15 is an arbitrary value… depending on how fast you want the fader to become visible" — tune the divisor to the fade-in speed, always clamp at 1.

```jsx
<div className="fader" style={{ opacity: Math.min(1, scrollTop / 15) }} />
```

```css
.fader { position: sticky; top: var(--header-height); height: 24px; pointer-events: none;
         background: linear-gradient(transparent, var(--bg)); }
```

### 9. Drag gestures: projection and velocity-based snapping
- The Dev Tools badge drags to any of the four screen corners. No drag library — a custom `useDrag()` hook. On release, compute the projected position: where the element would land if it kept moving at its current velocity, then snap to the nearest corner of the projection. "Projection enhances drag gestures to swipe gestures, enabling short flicks to move the element." (Credited to Nathan de Vries, WWDC 2018 session, 43:00.)

```js
const FACTOR = 0.15; // tune: projected distance per px/s of velocity
function project(x, y, vx, vy) { return { x: x + vx * FACTOR * 1000 / 60, y: y + vy * FACTOR * 1000 / 60 }; }
// on drag end: snap to nearestCorner(project(…)) instead of nearestCorner(centroid)
```

### 10. Visual and media details from "Behind scenes"
- Video with zero layout shift: generate width/height metadata at build time, set `aspect-ratio` CSS on the player, and show a blurred poster (`filter: blur()` + slight `scale`) until the video loads.
- Bespoke icon system (by Glenn Hitchcock): 16×16 grid at 1.5pt stroke; bump to 18×18 at 1.75pt stroke when inlined with a 20pt font so optical weights match. Theme-aware variants: filled in dark mode, stroked in light.
- Error pages get the same craft as landing pages — every state is a designed surface, not a fallback.
- Long-form ergonomics: footnotes get a back button that returns to the exact previous scroll position; ←/→ arrow keys navigate between paragraphs; at the end of a chapter, focus transfers to the next pagination link so keyboard flow never dies; the autoplay-video preference persists (stored in the cloud, not just localStorage).
- Two-column layouts (text + live prototype) "offer better navigation through long-form content" — prototypes beat videos for communicating detail because the reader can touch them.

### 11. The principles unit, anchored to what the free chapters exercise
- **Ergonomic interactions** ← linked from the chapter's "pointer ergonomics" (concentric targets, sibling buttons, dual rings).
- **Responsive interfaces** ← linked from "reduce responsiveness" (input outpacing animation).
- **Inferring intent / Simulating physics / Contained gestures / Motion choreography** expand the author's free essay: commit lightweight actions mid-gesture at the element's "logical, final position", commit destructive actions only on gesture end "regardless of distance"; retain a gesture's momentum and angle through a morph (Dynamic Island); apply scale delta immediately during pinch instead of animating past a threshold; delete motion where frequency is highest.

## When to use / When NOT to use

- Use when: a surface is functionally done and you are running a polish pass; a component changes state in place (badges, dev tools, menus, toasts) and deserves width-morph + count animations; you are building draggable, scrubbable, or scroll-linked elements; you need the last 5% that makes work feel authored.
- Use its reading order as a QA rubric: ergonomics → state transitions → update frequency → shapes → scroll treatment → gesture physics → error/empty/debug states.
- NOT when: information architecture or copy is still unsettled — polish on a wrong structure is waste; when the page is static content where any motion is cosmetic (the source's own ban); when "detail" would mean decorative layering (glow, grain, gradients) — this source's details are behavioral, not cosmetic.
- NOT as a license to add animation: the source's opening claim is that some sequences improve "with just a touch of delay" and some interactions "feel better without any motion at all."

## How to apply (the polish pass)

1. List every element that changes state in place; give each a measured-width morph (`px` when measured, `auto` fallback) and gate all transitions behind first mount.
2. Give every count/number an update animation via the React `key`-replay trick; no animation dependency.
3. Find every nested interactive element; refactor to siblings with concentric absolutely-positioned targets. Minimum target = the whole visual group.
4. Define focus rings per surface state: outset brand ring on neutral backgrounds, inset white ring on saturated/error surfaces.
5. Trace every async update path; if events can burst faster than ~200ms, measure time-since-update and cancel/restart animations — snap instead.
6. Bind every component state to a debug keyboard shortcut (dev flag only) and spam each one for 30 seconds; fix anything that breaks, doubles, or flickers.
7. Audit motion for information content: delete entrance animations on frequently-used surfaces (menus, command palettes); keep motion only where a prior on-screen state changed.
8. Replace hard clipping under sticky headers with a sticky gradient fader, `opacity = min(1, scrollTop / 15)`, divisor tuned to fade speed.
9. For any non-rectangular container, export the curve as SVG and glue it to the HTML box (`preserveAspectRatio="none"`, absolute at the edge) so content can grow.
10. For drags: record velocity, compute projected position on release, snap to the nearest anchor of the projection — flicks become swipes.
11. Media: build-time dimensions → `aspect-ratio` + blurred poster until load; zero layout shift.
12. Icons: one grid (16×16 @1.5pt stroke; 18×18 @1.75pt beside 20pt text), two theme variants (filled dark / stroked light).
13. Design the error, empty, and 404 states with the same effort as the happy path; add navigation ergonomics (footnote return-to-scroll, arrow-key paragraph nav, focus hand-off at the end of flows).

## AI-slop warning

- AI's default is the source's exact anti-patterns: entrance transitions that play on page load, staggered fade-ins on arbitrary data, and animation added to look "polished" rather than to report state. If a motion removal test (pause animations) loses no information, delete the motion.
- AI nests buttons to make one control hover with another; that is invalid HTML — siblings with concentric hit areas.
- AI reaches for animation libraries to re-mount/replay effects; the `key` trick is dependency-free and deterministic.
- AI writes fixed-width transitions (`width: 300px` hardcoded) that jank on content change — measured-px-else-`auto` is the mechanism, with transitions disabled until measurement stabilizes.
- AI treats debug tooling as throwaway; here it is the primary QA instrument. Ship the shortcut harness, spam every state, and treat "it survives spamming" as the acceptance bar.

## Relations

- **invisible-details** — the author's free 2023 essay; the intellectual predecessor whose themes (inferring intent, gesture commit timing, when to remove motion) the paid Principles unit expands. Read it for the argument; use this skill for the implementations.
- **web-interface-guidelines** — Rauno's free checklist (cursor styles, `user-select`, focus, contrast); covers the static/hygiene details this source assumes as baseline before the polish pass.
- **transitions** — motion choreography vocabulary and easing values; pairs with this skill's rule that motion must carry state information to earn its duration.
- **cmdk** — the author's own command-menu library; the concrete artifact of "remove animation from high-frequency surfaces".
- **rauno** — the author's portfolio; his production work (Arc, Vercel platform) is where these details ship.
