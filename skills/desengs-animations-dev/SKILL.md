---
name: desengs-animations-dev
description: Use when animating any interface element and deciding how — Emil Kowalski's animations.dev doctrine on when to animate, easing, duration, springs, interruption, gestures, and exits.
source: https://animations.dev; https://emilkowal.ski/ui/7-practical-animation-tips; https://emilkowal.ski/ui/you-dont-need-animations
category: principle
---

# animations.dev (desengs) — Emil's animation doctrine, condensed

Source: https://animations.dev — "Animations" by Emil Kowalski (design engineer at Linear, ex-Vercel; creator of Sonner and Vaul, 90M+ weekly npm downloads). A paid interactive course (13,000+ students; enrollment reopens 2027, 10 days). **Paywall status:** lesson videos and 40+ exercises are paid. Publicly verifiable surface: the landing page (itself a demo of the doctrine), the changelog (which quotes the course's LLM rule file verbatim), two preview lessons via the waitlist email, and Emil's own essays at emilkowal.ski that restate the course doctrine ("You Don't Need Animations", "7 Practical Animation Tips", "The Magic of Clip Path", "Building a Drawer Component", "Train Your Judgement"). Every number below is attributed to one of those; nothing is invented from the paid lessons.

## What it is / Why it exists

- The course's pitch: "Coding great animations is hard" because tutorials follow the happy path — the code is the easy part; a bad easing or duration "can ruin an otherwise good animation" and leave you with "it just doesn't feel right and you can't tell why." The product is judgment, not snippets.
- Structure (verified from landing page + changelog): Module 1 **Animation Theory** (easing, springs, timing, purpose, taste, when *not* to animate, using AI) → Module 2 **CSS Animations** (transforms → transitions → keyframes → clip-path) → Module 3 **Motion/Framer Motion** (feedback popover, useSpring/useTransform, hold-to-delete) → Module 4 **Good vs Great** (transferring feelings, orchestration, accessibility, performance) → 4 walkthrough series (Family's iOS drawer, Dynamic Island, Navigation Menu, SVG hero illustration).
- Why the course exists now: AI writes animation code but "can't know what feels right" — it "produces motion that works, but feels mediocre," and if you can't tell the difference, you'll ship it (Emil, "Train Your Judgement", 2026). The course therefore ships 15 AI slash-command skills (`/animate`, `/review-animations`, `/debug-animation`, `/animation-accessibility`, …) that encode its rules for agents — the doctrine is meant to be machine-applied.

## The core ideas

### 1. Why animate at all — the proof-of-care argument

- Emil: "When done right, animations make an interface feel predictable, faster, and more enjoyable to use. They help you and your product stand out." Done poorly, users "lose trust in your product." Both halves are from "You Don't Need Animations".
- The course's guest lesson by Josh Puckett is literally titled **"Animations as Proof of Care"** — motion is how a product demonstrates uncommon care and differentiates. Attribute this framing to Puckett, not Emil.
- Emil's own framing: "I see animations on the web as a form of art, and care deeply about how they look, feel, and behave" — the goal is "a moment of joy." Craft, not decoration.

### 2. Purpose is step one — "Step one is making sure your animations have a purpose" (Emil)

Before building, name the purpose in one phrase. Sanctioned purposes from his examples: **feedback** (press scale makes UI "feel more alive and responsive"), **spatial consistency** (a toast enters and exits the same edge, which is what makes swipe-to-dismiss intuitive), **explanation** (Linear's AI page teaches the feature in the initial viewport), **avoiding a jarring change**, and **pure delight — valid only for rarely-seen elements**. If the answer is "it looks cool" on a daily-use element, delete it.

### 3. The frequency gate — often the answer is no

- Raycast, which Emil opens "hundreds of times a day," has **no open animation** — he calls that "the optimal experience." "How often users will see an animation is a key factor in deciding whether to animate or not."
- **Keyboard-initiated actions are a hard never**: "an animation would make them feel slow, delayed, and disconnected from the user's actions. You should never animate them." Arrow-key menu navigation must track instantly.
- Hover effects used "multiple times a day… would likely benefit the most from having no animation at all."
- Tooltips: keep the initial delay (prevents accidental activation), but once one tooltip in a group is open, the rest appear **instantly, no delay, no animation**. In Base UI/Radix: target the instant state and zero the duration.

### 4. Speed — the sub-300ms law and the duration bands

- Emil's rule of thumb, stated twice (essay + course LLM rules): **"UI animations should generally stay under 300ms"**; the LLM file version: "Animations should never be longer than 1s (unless it's illustrative), most of them should be around **0.2s to 0.3s**."
- Perceived performance is real: a 180ms select animation feels more responsive than a 400ms one at identical actual speed; a faster-spinning spinner "make[s] the app seem to load faster, even though the load time is the same."
- Bands consistent across his examples: press feedback ~100–160ms (`scale 0.97`), tooltips/popovers ~125ms (his tooltip demo: `transform 0.125s ease-out, opacity 0.125s ease-out`), dropdowns/selects ~180–300ms, drawers/sheets 500ms with a strong curve, marketing/illustrative motion exempt (his clip-path reveal: 1s).
- Unless you're on a marketing site, "your animations have to be fast."

### 5. Easing — "the most important part of any animation"

- Direct quote: "Easing is the most important part of any animation. It can make a bad animation feel great and a great animation feel bad."
- **Ease-out for anything entering or exiting** — fast start reads as responsive; his demo shows two 300ms dropdowns where the ease-in one *feels* slower. **Never ease-in on UI**: it accelerates at the exact moment the user is watching the arrival.
- Course LLM rules (changelog, July 2025): "Default to use `ease-out` for most animations" and "Don't use built-in CSS easings unless it's `ease` or `linear`" — the built-in curves are too weak; take custom curves from curated catalogs, never hand-roll.
- Curves he actually ships: `cubic-bezier(0.32, 0.72, 0, 1)` (Ionic-derived, iOS-like — Vaul's open/close) and `cubic-bezier(0.77, 0, 0.175, 1)` (ease-in-out for clip-path reveals/theme switch).

```css
:root {
  --ease-out-strong: cubic-bezier(0.32, 0.72, 0, 1);    /* drawer/sheet, iOS-like (Vaul) */
  --ease-in-out-strong: cubic-bezier(0.77, 0, 0.175, 1); /* reveals, large moves */
}
```

### 6. Performance — transform, opacity, and the sanctioned third

- Animate **`transform` and `opacity`**; they skip layout and paint. `clip-path` is his sanctioned addition — "hardware-accelerated interaction without additional DOM elements," no layout shift because the element already occupies space.
- Never animate `width`/`height`/`top`/`left` where a transform or clip can do the job (his image reveal exists precisely to avoid animating height).
- Real bug he documented (Vaul): driving a child's transform through an inherited CSS variable (`--swipe-amount` → `translateY`) recalculates styles for **every descendant** — drag lagged at ~20 list items. Fix: set `transform` on the element directly. Never funnel motion through inheritable custom properties.
- Tool ladder he endorses: CSS first; WAAPI (`element.animate()`) when JS control is needed — his scroll-reveal uses `useInView(ref, { once: true, margin: "-100px" })` plus a raw WAAPI call so the animation logic stays in one place; a library only if it's already in the project.

### 7. Physicality — nothing appears from nothing

- **Never enter from `scale(0)`** — it looks like the element appears "out of nowhere." Start at 0.93–0.95 plus opacity 0: "like a deflated balloon that still has visible shape" (his metaphor; he uses 0.93).
- **Origin-aware popovers**: popovers scale from their trigger corner, not center — `transform-origin: center` "is wrong in most cases." Radix/Base UI expose it as a CSS variable:

```css
.menu { transform-origin: var(--radix-dropdown-menu-content-transform-origin, var(--transform-origin)); }
```

- **Press feedback everywhere**: `:active { transform: scale(0.97) }` — the interface "feel[s] as if it's listening to the user." This is his #1 of 7 tips.
- **Exit the way it entered** — same edge, same path family; this spatial consistency is what teaches users they can swipe a toast away.

### 8. Interruption and flicker — design for the mid-flight retarget

- Course exercise list includes "Handling interruptions" (rapid open/close of menus) as a core judgment. Rule: an animation triggered repeatedly must **retarget from its current value**, not restart — CSS transitions do this; `@keyframes` restart from zero (flicker). Springs go further: they **carry velocity through the interruption** (from his skills repo: "Springs maintain velocity when interrupted — CSS animations and keyframes restart from zero").
- Rapid-fire components (toasts, toggles, menus): transitions, never keyframes.

### 9. Springs vs easing — when physics is earned

- Springs are for **gesture-driven and "alive" motion**: drag with momentum, elements that must absorb a flick. The Dynamic Island walkthrough (landing page) exists to teach springs specifically — Idle/Ring/Timer states tuned to feel "organic and natural."
- His working spring shape (from his skills repo): `{ type: "spring", duration: 0.5, bounce: 0.2 }` — bounce restrained (0.1–0.3), never cartoonish in product UI.
- Bezier curves remain correct for predetermined enter/exit where no interruption is expected. Springs are not a style; they are an interruption strategy.

### 10. Gesture-following motion — the drawer doctrine (Vaul essay)

- **1:1 tracking**: the element follows the pointer exactly; motion is never scripted over the user's hand.
- **Momentum dismiss**: a flick dismisses without reaching any distance threshold — dismiss on velocity, not position.
- **Damping past boundaries**: dragging past the limit moves the element less and less — "things in real life don't suddenly stop, they slow down first."
- Edge hygiene he ships: ignore extra fingers mid-drag (`if (isDragging) return`); only allow dragging when scrolled to top, with a **100ms lockout** after reaching top (fast scroll-backs otherwise dismiss accidentally); snap points resolve to the nearest on release, and a hard flick skips them.
- Sheet motion: 500ms, `cubic-bezier(0.32, 0.72, 0, 1)`; background scales and rounds with drag progress (40% drag = 60% of max radius) so the page reads as a stacked card.

### 11. Exits, removal, and orchestration

- "Removing elements" is its own judgment exercise: removal must be as smooth as arrival — animate the exit *before* unmounting (exit animations are a first-class concern, not an afterthought; this is why he built AnimatePresence-style exit handling into his components).
- Stagger and layered motion: only where it reads as intentional (his stagger exercise asks which hero entrance "feels more intentional"); stagger is a hierarchy statement, not a default.
- **The blur rescue** — his tip #7: when easing and duration tweaks can't fix an off-feeling crossfade, add `filter: blur(2px)` during the transition; it "bridges the visual gap" so the eye sees one morphing object instead of two states. The course's practical-tips lesson repeats it ("use blur-sm when an animation feels off").

### 12. Reduced motion and accessibility

- Accessibility is a Module 4 topic ("Good vs Great") with a dedicated AI skill (`/animation-accessibility`) — it ships with the animation, not after. Keep opacity/color comprehension aids, remove travel; never gate motion correctness on a later a11y pass.

### 13. Debugging and training judgment

- His method (practical-tips lesson + essay): record the screen and **play back frame by frame**; slow the animation down; compare bad-vs-good side by side and **write down why** one is better — articulation is "a skill that will be incredibly valuable in the AI era."

## When to use / When NOT to use

Use when: adding any transition, entrance, exit, popover, toast, drawer, drag interaction, or celebratory motion; picking a duration/easing/spring; diagnosing motion that "feels off"; deciding whether an interaction should animate at all; reviewing an AI-generated animation diff.

Do NOT use this doctrine to: justify motion on high-frequency actions (the gate vetoes it — that is the doctrine working); slow down a keyboard-driven interface; add marketing-style motion to a tool UI ("unless you are working on marketing sites, your animations have to be fast"); build ambient/background motion (different domain); or replace WCAG motion-safety requirements — reduced-motion handling is mandatory regardless.

## How to apply

1. **Gate first**: estimate uses/day. 100+/day or keyboard-driven → no animation. Tens/day → near-instant only. Occasional → full motion. Rare/first-run → delight budget.
2. **Name the purpose** (feedback / spatial consistency / explanation / avoid jarring change / delight). Unnameable = don't build.
3. **Pick the band**: press 100–160ms · tooltip/popover ~125ms · dropdown/select 180–300ms · drawer 500ms · reveal/marketing ≤1s. Default all UI motion to 0.2–0.3s.
4. **Pick the curve**: entering/exiting → strong ease-out (never ease-in); large on-screen moves → `cubic-bezier(0.77, 0, 0.175, 1)`; iOS-sheet feel → `cubic-bezier(0.32, 0.72, 0, 1)`. No built-in CSS easings except `ease`/`linear`.
5. **Pick the properties**: `transform`, `opacity`, `clip-path`. Set transforms directly on the element, never via inherited CSS variables.
6. **Physicality pass**: entrance from `scale(0.93–0.95)` + `opacity: 0`, never `scale(0)`; popover `transform-origin` at the trigger; `:active { scale(0.97) }` on every pressable; exits mirror entrances.
7. **Interruptibility pass**: rapidly-triggered motion uses transitions (or springs), never `@keyframes`; gesture motion uses a spring (`duration: 0.5, bounce: 0.2`) so velocity survives interruption.
8. **Gesture pass** (draggables): 1:1 tracking, momentum-based dismiss on velocity, damped overshoot, multi-touch guard, scroll-boundary lockout.
9. **Rescue pass**: if it still feels off → `blur(2px)` during the crossfade; verify frame-by-frame in a screen recording before shipping.
10. **Ship with** `@media (prefers-reduced-motion: reduce)`: keep opacity/color, drop travel.

```css
/* The doctrine in one block */
.button { transition: transform 150ms var(--ease-out-strong); }
.button:active { transform: scale(0.97); }

.popover {
  transform-origin: var(--transform-origin);           /* the trigger corner */
  opacity: 0; transform: scale(0.95);
  transition: opacity 125ms ease-out, transform 125ms ease-out;
}
.popover[data-open] { opacity: 1; transform: scale(1); }

@media (prefers-reduced-motion: reduce) {
  .popover { transition: opacity 150ms ease; transform: none; }
}
```

## AI-slop warning

Emil's whole 2025–2026 update cycle targets AI output: agents "produce motion that works, but feels mediocre." The specific failure modes his doctrine exists to catch: animating everything (ignoring the frequency gate — the most common agent error), `ease` or `ease-in` on entrances, `scale(0)` origins, `transform-origin: center` popovers, keyframes on rapidly-triggered elements (restart-flicker), 500ms+ durations on 8px movements, bounce-heavy springs on product UI, missing exits (elements popping out of existence), motion funneled through inherited CSS variables (the Vaul perf bug), and no reduced-motion variant. An agent applying this skill should expect to *delete* animations as often as it adds them — "sometimes the best animation is no animation" — and to review by flagging first, approving only what matches the bands and curves above.

## Relations

- **desengs-emil-skills** — his public `emilkowalski/skills` repo: the fuller rule set (purpose vocabulary, frequency table, Sonner/Vaul behavior specs) that the course's 15 AI skills grew from; load it for implementation-grade detail beyond this doctrine.
- **desengs-transitions** — ready-to-paste pure-CSS transitions whose durations/easings sit inside Emil's bands; use it when the decision is made and you need the artifact.
- **desengs-easing** — the curve catalog for Emil's "never hand-roll, never built-in" rule; note it is Vanderzon/Axon's site, not Emil's, though his course interviews Lochie Axon (Family).
- **desengs-you-dont-need-animations** — the full essay behind the frequency gate; the veto that runs before any of this skill's positive rules.
- **desengs-sonner** — the toast system where the purpose/spatial-consistency/exit rules are productionized.
