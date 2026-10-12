---
name: desengs-invisible-details
description: Use when building gesture or touch UIs, deciding when a swipe commits, when to animate versus stay still, or diagnosing why an interaction feels off. Rauno Freiberg's canonical craft essay distilled.
source: https://rauno.me/craft/interaction-design
category: essay
---

# Invisible Details of Interaction Design (desengs) — the canonical craft essay

Source: https://rauno.me/craft/interaction-design — Rauno Freiberg, long-form craft essay (2023). Not a tutorial or guideline list: a deconstruction of interactions "I use often but rarely think about". Its resources cite Apple HIG (1987), the "Designing Fluid Interfaces" talk (2018), and Fitts (1954). No license stated; distill, don't reproduce.

## What it is

The spiritual core of this canon: the best interfaces go unnoticed because hundreds of decisions were made "by someone obsessing over the tiniest margins so that when they work, no one has to think about" (Freiberg). The essay extracts the *why* behind interactions that feel right — gesture commit timing, momentum, spatial choreography, when NOT to animate, context as input. Two framing claims change how you work:

1. Insight does not come from recycled UX content ("personas, storyboards, and Venn diagrams"). It comes from making something, then "going for a synthesising daydreaming walk to stir the pot" — and from maniacally replaying slow-motion screen recordings of real systems.
2. "Interaction design is an artform to make experiences that fluidly respond to human intent." Form alone is not enough; people are trying to get stuff done. The satisfaction is in the balance of form AND function.

The companion checklist for point-and-cursor details (cursor scaling, hover intent, focus states, text selection, optical alignment) lives in the author's Web Interface Guidelines — see Relations. This essay is the gesture-physics and motion-restraint side.

## The core ideas

### Metaphors compound

- Most touch UIs are operable with two gestures: tapping and swiping. iOS explicitly teaches exactly one gesture (swipe up to unlock); everything else is inference: swiping down reveals layers of system functionality; the sliding motion teaches that the UI is stacked layers, "like a deck of cards".
- Horizontal swiping navigates pages because that is how books have worked for thousands of years. Reuse pre-digital metaphors instead of inventing gesture vocabulary.
- Real-world actions are interruptible; digital ones usually are not. "Imagine if [flipping a page in a book] were an animation that you had to wait for!" Every gesture you build must be interruptible mid-flight.
- Pinch = precision (like picking up tiny objects). The zoom anchor point is computed where the fingers are; starting pinched-together gives a deliberate, precise anchor, starting apart usually means zooming out where origin precision matters less.

### Kinetic physics: dismissals inherit the throw

- Dismissing an app into the Dynamic Island retains the momentum and angle of the flick. "It's never perfectly centered or consistent in timing."
- The dismissal behaves like a swiped playing card — which bounces *less* because it is "conceptually lighter". Perceived mass of the object sets the bounce, not a single global spring.

```js
// Release animation inherits velocity and angle from the gesture; never a canned centered shrink
function dismiss(el, { vx, vy }) {
  el.animate(
    [{ transform: 'translate(0,0) scale(1)' },
     { transform: `translate(${vx * 60}px, ${vy * 60}px) scale(0.1)` }],
    { duration: 300, easing: 'cubic-bezier(0.22,1,0.36,1)', fill: 'forwards' }
  );
}
```

### Swipe commit rules: lightweight vs destructive

This is the essay's most decision-changing rule. When does a swipe trigger the action?

- **Lightweight, reversible actions** (revealing overlays, MercuryOS-style unlock): trigger *during* the swipe, as soon as moving elements reach their logical final position — without waiting for finger release. Waiting "would make the interface feel broken and provide less affordance".
- **Destructive actions** (dismissing an app in the App Switcher): trigger *only on release*, regardless of distance, even if the view is already fully off-screen. Rationale: "I could potentially lose some important progress in an app!" Release is the explicit-intent signal; distance is not.
- Requiring release also enables cheap peeking: swipe far enough to preview another screen, snap it back by reversing direction mid-gesture, never committing.

```js
// Lightweight: commit as soon as the drawer's leading edge reaches its resting offset
onDrag({ dx }) { if (dx > drawerRestOffset()) openNow(); }
// Destructive: distance only prepares; release decides
onDragEnd({ dx }) { if (dx > width * 0.3) destroy(); else restore(); }
```

### Responsive gestures: 1:1 before the threshold

- A naive pinch implementation does nothing, then exponentially zooms after a threshold. It "gives zero affordance or confidence that the card is even pinchable" at low velocity.
- Correct mechanism: apply the gesture delta continuously and immediately (scale tracks fingers 1:1), and only *animate* (settle) once past the threshold. Response is felt from the first pixel of movement.
- Counter-example from iOS itself: Settings pushes a layer that tells you it can be swiped back, but a mistap cannot interrupt the push animation — "you have to wait for it to end". Responsiveness = every in-flight transition yields to new input.

```js
onPinch(delta) {
  card.style.scale = String(clamp(1 + delta, 1, 1.15)); // immediate, 1:1
  if (delta > 0.15) expand(card);                        // animation only past threshold
}
pane.addEventListener('pointerdown', () => {
  pane.getAnimations().forEach(a => a.cancel());         // gestures interrupt transitions
});
```

### Spatial consistency: motion encodes origin and stack position

- An app launched from a collapsed Island slides out from under it. If the Island is *expanded* (intent = more detail), the app instead launches from its home-screen icon — disambiguating which of several same-row apps is the audio source — or slides in from the right, communicating its position at the front of the App Switcher stack.
- Exception proves the rule: the Clock app always jumps out of the Island even when expanded, because no other app can occupy that Island module — there is nothing to disambiguate.
- Rule: entry/exit trajectories are information. Same origin + same destination = same path, every time; change the path only when the meaning changes.

### Fluid morphing: stretch, don't crop

- During swipe-to-home, the app morphs rectangle-to-square and the icon is intentionally *stretched from the bottom* to fill the frame (visible on non-standard icons like GitHub's).
- The technique assumes icons keep critical content out of the bottom safe zone. The Bluesky icon ignores it, so its "bottom ~10pt of the icon is cropped, duplicated, and stretched, resulting in this weird repeating image effect."
- Rule for any stretch-morph: keep the bottom ~10pt of a square icon free of meaningful content, or design the stretch explicitly.

### Frequency and novelty: when NOT to animate

The restraint doctrine — the essay's most cited section:

- Keyboard and mouse input have an inherent, mechanical disconnect from the screen; you can often skip animating them without feeling jarring.
- Command menus used "hundreds of times a day": an opacity/scale entrance becomes cognitive burden and feels sluggish regardless of actual speed. On bmrks.com, Freiberg removed motion from core keyboard interactions and "suddenly felt like I was moving much faster" — snappier motion did not fix it; removal did.
- macOS context menus appear with no motion; the selected item "briefly blinks the accent color" as success confirmation, then the menu fades out (exit-only grace). The App Switcher overlay never animates; and if the time delta between Command and Tab is low enough, focus switches instantly *without showing the menu at all*.
- Heuristic: frequency high + novelty low = no entrance animation; confirm with a blink, not a flourish. Reserve motion for rare, novel, or state-meaningful moments.

```css
.cmdk-overlay { animation: none; }              /* hundreds of uses/day */
.cmdk-overlay.leaving { transition: opacity 90ms; }
.item.chosen { animation: accent-blink 140ms steps(2, end); }
@keyframes accent-blink { 50% { background: var(--accent); color: var(--bg); } }
```
```js
// Cmd+Tab pattern: if inputs arrive within a short delta, skip the overlay entirely
if (t2 - t1 < 80) { switchFocus(); return; } else showOverlay();
```

### Fidgetability

- Repetitive play (AirPods case, the Apple Pencil's unscrewable tip with "satisfying friction") aids concentration — weak research support, but it is intentional design anyway.
- Build one fidgetable affordance into physical-adjacent UI: satisfying detents, friction, reversible toggles. It is garnish, never the meal.

### Scroll landmarks and scrollbar as a control

- macOS shake-to-find-the-pointer works because it taps the frustration of losing track. The mobile equivalent: losing your reading position when scrolling up to check something.
- Prototype worth stealing: double-tap the scrollbar to drop a landmark at the current scroll position; double-tap it again to return. Familiar because the scrollbar is already interactive — long-pressing it makes it draggable for fast scrolling.
- Games offer a bird's-eye minimap; a page-length HUD can do the same for long documents.

### Touch content visibility

- A finger obfuscates the screen, so render a temporary representation of what is underneath: iOS shows a magnifying loupe *above* the touch point while dragging the text caret — and the loupe disappears the moment the finger moves down and no longer covers the caret.
- Keyboard keys enlarge on press "which gives you confidence that the interface understood what you meant".
- Don't always mirror the occluded region: tiny sliders vanish under a thumb, so instead never cancel the drag when the pointer drifts off the element while still pressed. "There's an unintelligible level of discomfort apparent when interacting with an element that you can't see."

```js
thumb.addEventListener('pointerdown', e => {
  thumb.setPointerCapture(e.pointerId); // drag survives leaving the track
});
```

### Implicit input: context is the input

- "Isn't the mother of all inputs no input at all?" Apple Maps shows active navigation while locked; Wallet raises brightness when presenting a pass for scanning; Spotify adapts its layout for driving.
- Apps that blur their contents in the App Switcher are not optimizing performance — they conceal sensitive data (medical records, bank statements). Privacy choreography is an interaction detail.
- Rule: before asking the user for a state, check what the context already knows (lock state, sensors, activity, proximity).

### Fitts's Law: corners and radial symmetry

- Acquisition time depends on distance and target size. Screen corners have effectively infinite targets because the pointer cannot overshoot them — reaching any corner is "a quick flick of the mouse". This is why OS menus (Apple menu) live in corners; configurable hot corners exploit it.
- Radial menus spawn around the pointer, making size and distance identical for every action; with practice, muscle memory selects by distance and direction alone — eyes no longer required.

```css
.hot-corner { position: fixed; top: 0; left: 0; width: 2px; height: 2px; }
/* the corner cannot be overshot: the effective target is unbounded */
```

### Scrolling: never hijack, and let scroll manipulate

- Scrolling a window that is not focused feels great until a second window steals the scroll events (traditional mice like the MX Master 3 hijack; the Magic Mouse does not — scrolling is cancelled only by explicitly focusing another window).
- Pointing devices unlock direct manipulation: manipulate a slider by scrolling over it, "all with a single interaction".

```js
slider.addEventListener('wheel', e => {
  e.preventDefault();
  slider.valueAsNumber += e.deltaY * slider.step;
}, { passive: false });
```

## When to use

- Any touch or gesture interface: sheets, drawers, carousels, pinch-to-zoom, swipe-to-dismiss, app-shell navigation.
- Deciding commit semantics for a draggable action (mid-gesture vs on-release).
- Deciding whether a high-frequency overlay (command palette, context menu, switcher) gets an entrance animation.
- Choreographing launch/dismiss transitions so motion carries spatial meaning.
- Diagnosing "feels off" feedback: usually a dead-zone threshold, a locked transition, or a lost throw velocity.

## When NOT to use

- Rare, novel, celebratory moments (onboarding, launch, success) — motion and delight are appropriate there; restraint applies to frequency, not to everything.
- Data-dense, keyboard-driven tools where the bmrks lesson cuts the other way: motion in core loops is the bug, so applying "animate everything" here is exactly wrong.
- Marketing pages where a one-time flourish is the point.
- Do not ship gesture work unverified: these details are only confirmable by replaying screen recordings in slow motion (or frame-stepping a capture). If you cannot verify, ship the conservative variant.

## How to apply

1. Inventory every gesture; for each, classify the action as lightweight (reversible) or destructive. Lightweight commits mid-gesture at the element's logical final position; destructive commits only on release, regardless of distance.
2. Make every drag 1:1 responsive from the first pixel — no dead zones before a threshold; animate only the settle past the threshold.
3. Make every transition interruptible: on `pointerdown`, cancel running animations and hand control to the finger.
4. Inherit release velocity and angle in dismissal animations; never play a canned centered shrink. Match bounce to the object's conceptual weight.
5. For overlays used many times daily (command menus, context menus, switchers): remove entrance animation entirely; add an accent-color blink (~140ms) on selection and a short fade on exit; if two inputs arrive within a small time delta, skip showing the overlay at all.
6. Keep entry/exit trajectories spatially consistent with origin and stack position; break the rule only when the origin is unambiguous (single-owner modules).
7. For stretch morphs, keep the bottom ~10pt of square icons free of meaningful content.
8. On touch: render a proxy for occluded content (loupe above the finger, enlarged pressed key) or make the control forgiving (pointer capture, no cancel on drift). Remove the proxy the moment the finger no longer occludes.
9. Mine context before prompting: lock state, brightness needs, activity type, privacy (blur in task switchers).
10. Place high-frequency targets at screen edges/corners; consider radial layouts spawned at the pointer for equal-distance actions.
11. Never hijack scroll between windows; allow scroll-to-manipulate on sliders and steppers.
12. Verify by recording the interaction and frame-stepping it. Articulate, in writing, why each detail feels right — "it feels nice" is not an answer; a named spring curve, metaphor, or commit rule is.

## What changes for an AI building UI

- Default to *no* entrance animation on overlays; require an explicit frequency argument to add one. AI instinct (animate everything for polish) is the exact failure this essay documents.
- Never emit threshold-triggered animations (dead zone then tween). Always continuous response + settle. Never lock input during a transition.
- Pick commit timing by action reversibility, not by distance thresholds — a fixed 50%-distance rule is wrong for destructive actions.
- Add the invisible plumbing by default: pointer capture on drags, wheel manipulation on sliders, accent blink on selection, privacy blur in switcher/app-card previews, velocity inheritance on release.
- When critiquing UI, replace "add animation" with the essay's diagnostic questions: When does this trigger? Does it retain momentum? What if a finger covers the content? Can intent be inferred from context?

## AI-slop warning

How AI typically misapplies this essay:

- Applies cinematic motion to high-frequency interactions (scale+fade on every Cmd+K) — the canonical slop signal, directly contradicted by Frequency & Novelty.
- Builds gestures with dead zones and uninterruptible transitions because they are easier to generate than 1:1 tracking with settle.
- Uses one global spring/easing everywhere, ignoring conceptual weight (playing card vs app dismissal).
- Centers and symmetrizes every dismissal, discarding the user's throw angle and momentum — motion that carries no information.
- Treats this essay as the source of cursor/hover/focus/selection/timing rules — those are the Web Interface Guidelines; misattributing them produces checklist soup the author would not endorse.
- Adds fidget-style flourishes as ornament on imprecise underlying interactions; fidgetability only reads as craft when the functional layer is already exact.

## Relations

- **desengs-web-interface-guidelines** — the author's companion checklist for the point-and-cursor half (cursor scaling, hover intent, focus states, text selection, optical alignment, timings). Use it for desktop/web specifics and this essay for gesture physics and motion restraint.
- **desengs-devouring-details** — sibling craft essay on micro-detail execution; covers complementary web-side details where this one is OS/gesture-focused.
- **desengs-rauno** — the author's portfolio skill; his signature (kinetic responsiveness, restraint in motion, spatial choreography) is this essay in practice.
- **desengs-fluid-functionalism** — distills the "Designing Fluid Interfaces" talk the essay itself cites (Karunamuni et al., 2018); goes deeper on interruptibility and gesture physics; read together they form the physics layer of the canon.
