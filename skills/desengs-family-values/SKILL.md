---
name: desengs-family-values
description: Use when a complex product needs progressive disclosure, seamless navigation transitions, or a delight budget. Benji Taylor's simplicity-fluidity-delight principles and their exact tray and morph rules.
source: https://benji.org/family-values
category: essay
---

# Family Values (desengs) — Benji Taylor's working principles

Source: https://benji.org/family-values — Benji Taylor, "Family Values" (8 July 2024), long-form essay. Taylor is the design engineer who spent ~2 years on Family, a self-custody crypto wallet for iOS (later author of the liveline charting library — sibling `desengs-liveline`). Explicitly "not a technical post or tutorial": it documents the three working principles that made a maximally complex product feel welcoming, with screen recordings as evidence. No license; distill, don't reproduce. The web port of its text-morphing system is torph (sibling `desengs-torph`).

## What it is / Why it exists

Three principles, stated as one sentence (Benji Taylor): "Simplicity ensures accessibility, fluidity maintains continuity of experience, and delight fosters meaningful connections." Together they are respect for the user's time, intelligence, and experience.

Why the essay exists: complex products disorient. "Complex products exhibit every feature at once" and "this leads to disorientation" — nowhere worse than self-custody crypto, where the interface must serve newcomers without dumbing down for experts. The rejected alternatives: masking complexity "with marketing or by burying it within platitude." The chosen stance: values are guiding lights, not checklists — every decision trades off, and the team consciously chose "creating a world-class experience… over shipping at an expedited rate." Utility, performance, and security are *table stakes*, not values: design is what happens beyond them, because "great design creates a deeper bond between individuals and technology."

## The core ideas

### 1. Simplicity — fundamentals stay; everything else reveals in context

Keep the fundamentals immediately at hand; every other feature appears only when relevant. "Family has hundreds of potential paths, requiring intentional design to achieve simplicity." The goal is an interface "for newcomers and experts to co-exist" — progressive disclosure, not feature removal.

The implementation is **gradual revelation through trays**: condensed versions of the app that expand, contract, and adapt. The essay's exact rules:

- Trays are **user-initiated** — never auto-opened.
- Each subsequent tray **varies in height**, to "make it unmistakable that a change has occurred."
- Every tray carries a **title and icon** that double as dismissal / back-navigation.
- Each tray holds **one piece of content or one primary action**.
- The theme **adapts to the tray's content**.
- Trays suit **transient actions** and **preserve context** — a swap approval unfolds from the swap screen, not from a new page; an overwhelming backup flow "distill[s] into approachable steps."

The spatial model: users perceive the app like "interconnected rooms" — complexity stays "out of sight and out of mind until required." (The essay credits Craft's documents app with a similar system.)

Web port — one disclosure primitive, expanding in place from its trigger:

```css
.tray {
  position: fixed; inset: auto 0 0 0;              /* bottom sheet */
  transform: translateY(100%);
  transition: transform 320ms cubic-bezier(0.32, 0.72, 0, 1); /* port pick */
  transition-property: transform, height;
  overflow: hidden;
}
.tray[data-open] { transform: translateY(0); }
.tray[data-step="confirm"] { height: 300px; }      /* height varies per step: */
.tray[data-step="review"]   { height: 460px; }     /* change must be unmistakable */
```

```js
// Rule: open only on user action — never on load, never on a timer, never on hover.
trigger.addEventListener('click', () => tray.dataset.open = '');
// Rule: one primary action per step; title+icon is the back affordance.
```

### 2. Fluidity — "we fly instead of teleport"

Static transitions kill orientation: "A lifeless product feels like a dead product, and a dead product feels uncared for." Fluidity is "akin to moving through water — you float rather than walk through it." The whole app is treated as one space where "anything can transform into anything else" — *given strong rationale*. The thesis quote: "Animation is not merely a visual representation of transformation — a change in state. Instead, animation is the transformation."

The mechanisms:

- **Directional navigation.** Moving between tabs pushes and pops in travel direction — "we fly instead of teleport" — instead of an instant cut. Transitions must "preserve the user's hard work" and always be interruptible.
- **Morphing affordances.** Chevrons morph between back/forward forms rather than swapping.
- **Text transformation.** Labels evolve by "leverag[ing] shared letters — such as the 'Con' in both words" (Continue → Confirm); button number and text "adjust effortlessly." In amount inputs, commas "shift visually from place to place as the number is inputted." Full web port: `desengs-torph`.
- **Traveling assets.** The transaction spinner travels to the tab bar — the loading indicator moves to where the outcome will land, tying cause to effect.
- **Redundancy is banned.** Components that persist across a transition do not re-animate; only entering/exiting elements move. (The essay's footnote: an element like the wallet "B" that stays put "doesn't need to animate.")

The proof: the team built deliberately reduced-fluidity versions of the app. Without fluidity, "you quickly lose track of what happened" — the result is "disorientation and confusion," often "frustration." Fluidity "builds trust": it is "a commitment to comfort, clarity, and continuity," not decoration.

Web port — directional, shared-element navigation via View Transitions:

```js
function go(step, dir) { // dir: 1 forward, -1 back — never render a hard cut
  document.startViewTransition(() => render(step));
}
```

```css
::view-transition-old(root) { animation: slide-out 240ms ease-out; }
::view-transition-new(root) { animation: slide-in  240ms ease-out; }
@keyframes slide-in  { from { transform: translateX(var(--dir, 1) * 4%)  } }
@media (prefers-reduced-motion: reduce) { /* canon rule, not the essay's */
  ::view-transition-group(*), ::view-transition-old(root), ::view-transition-new(root)
    { animation: none !important; }
}
```

### 3. Delight — selective emphasis on the Delight-Impact Curve

"Delight is subjective" — what transfers is the deliberate effort itself, proof "that someone… cares." The controlling law: "Mastering delight is mastering selective emphasis." The **Delight-Impact Curve** holds "an inverse relationship between the frequency of a feature's use and its potential for delight" — the rarer the interaction, "more room to captivate the user," because even a 10-second animated onboarding is seen once and costs the user nothing.

The essay's inventory, mapped by frequency:

- Seen once: animated wallet-creation sequence (particles forming the logo, ~10s); confetti when backup completes.
- Rare: deleting a token — the trash can tumbles into it with sound; enabling stealth mode — a shimmer sweeps the interface.
- Occasional: scanning a QR code — ripple effect plus a sequins easter egg; the browser's empty state gets an animated arrow.
- Frequent: dragging to reorder tokens; charts use arrows to disambiguate ambiguous movement; and the send-amount commas shifting — "a 1 in a 100 may notice" but "it's noticeable," micro-craft on the hottest path.

The non-negotiable: polish must be everywhere, especially rare paths. Neglecting infrequent features is "like going to a fancy restaurant but finding it has a dirty bathroom" — one dirty corner retroacts on all the craft. Footnoted rationale (via Rauno Freiberg): entertainment value "has the potential to convert… infrequent visits into regular ones."

### 4. The values underneath

- Respect for the user's **time** (simplicity), **intelligence** (no masking, no dumbing down), and **experience** (fluidity, delight).
- Priorities in order: utility, performance, security — then the three values. "If we weren't able to make something people loved, the rest wouldn't matter."
- Conscious trade-off: world-class experience over launch speed. This is a decision, not an excuse for slowness.
- Ambition: "go above and beyond what someone might expect" — delight as empathy, forming "emotional connections" between person and software.

## When to use / When NOT to use

Use when:

- A feature-dense product (finance, dev tools, admin panels, settings-heavy apps) shows everything at once and disorients — build the fundamentals-plus-revelation split.
- Designing the disclosure architecture: wizards, approval flows, progressive forms — port the tray rules verbatim.
- Defining a navigation motion system: direction, shared elements, morphing labels, traveling loaders.
- Allocating a polish budget — the Delight-Impact Curve decides where craft money goes.
- Auditing feel: build the reduced-fluidity variant and check whether users "lose track of what happened."

Do NOT use when:

- Table stakes are unmet — fix utility, performance, security first; delight cannot rescue a broken core (the essay's own ordering).
- Shipping speed is the explicit constraint — the essay consciously traded launch speed for experience; a pre-product-market team may need the opposite trade, made consciously.
- The surface is pure data/utility (tables, terminals, forms) — continuity rules apply, but delight budget goes to ~0 and motion must stay near-instant.
- Multi-step heavy workflows needing deep links, search, or full-page history — trays are for *transient* actions; full pages serve durable ones.
- Delighting a hot path with anything perceptible — violates the curve; frequent-path craft must be sub-perceptual (the shifting commas, not the confetti).

## How to apply

1. Fix table stakes first: utility, performance, security. Nothing below this line compensates for their absence.
2. Inventory every feature; split fundamentals (permanent home, always visible) from contextual (revealed at the moment of relevance). Never remove the contextual features — rescope them.
3. Build ONE disclosure primitive (tray/sheet) obeying all six rules: user-initiated only; height varies per step; title+icon as back/dismiss; one piece of content or one primary action per step; theme adapts to content; expands in place from its trigger to preserve context.
4. Make every navigation directional: forward pushes, back pops; tab switches slide in travel direction. Ban hard cuts between sibling screens.
5. Persistent elements never re-animate; only entering and exiting elements carry the motion.
6. Morph significant label changes via shared letters (the "Con" in Continue→Confirm); animate separator shifts in formatted number inputs. Reserve morphs for state-significant transitions — see `desengs-torph`.
7. Make loading travel: the indicator moves to where the outcome will land (action button → destination tab), tying cause to effect.
8. Give every animation a stated rationale (what transforms, what context it preserves). No rationale, no animation.
9. Build the reduced-fluidity variant of each key flow and compare — motion is only justified if removing it costs orientation, comfort, or trust.
10. Plot each feature on the Delight-Impact Curve before crafting it: once-seen (onboarding, first backup) may take seconds of animation; rare actions get a signature moment (tumble, shimmer, confetti); frequent actions get only sub-perceptual micro-polish.
11. Audit the dirty bathrooms: empty states, error states, exports/backups, least-visited screens — these get craft *first*, because neglect there is most visible.
12. Add sound only where it confirms a physical metaphor (the trash tumble), and make it optional.
13. Ship `prefers-reduced-motion` fallbacks for every mechanism above (canon requirement; the iOS essay predates it).

## AI-slop warning

How AI misapplies this essay: it reads "delight" as confetti-on-every-action (violating the curve — hot paths must stay near-invisible) and "fluidity" as slow 400–600ms fades on everything (the mirror failure of the lifeless product: a sluggish product reads as equally uncared for — fluidity means continuity and rationale, not duration). Typical AI violations of the tray rules: sheets that auto-open after a timer, identical heights per step (change is ambiguous), three CTAs per step, no dismissal affordance, approval flows jumping to a new page instead of unfolding in place. AI also morphs *all* text instead of significant transitions, re-animates persistent chrome, and polishes the landing page while shipping default error/empty states — the exact "dirty bathroom." Finally, the cliché: copying the *skin* of a praised crypto wallet (glass cards, purple gradients, floating particles) without the three principles — the essay's product was praised for feel, not for styling, and the skin alone is the sloppiest possible tribute.

## Relations

- **desengs-torph** — the web port of this essay's shared-letter text morphing (Continue → Confirm, shifting commas), built by Lochie and named after this essay; read torph for the *how* (400ms, `cubic-bezier(0.19,1,0.22,1)`, grapheme diff), this skill for the *why*.
- **desengs-liveline** — same author (Benji Taylor); "fly instead of teleport" applied to streaming data: lerped values and ranges instead of jumps, and a loading→data morph — fluidity's continuity contract on canvas.
- **desengs-emil-skills** — Emil Kowalski's animation course is footnoted in this essay as where the team learned the mechanics; adds the concrete durations, easing choices, and interruptibility rules this essay leaves unnumbered.
- **desengs-invisible-details** — Rauno Freiberg's frequency/novelty concept is footnoted here as the root of the Delight-Impact Curve; adds the gesture-physics and when-not-to-animate side this essay doesn't cover.
- **desengs-you-dont-need-animations** — the restraint gate; this essay agrees via the rationale rule ("fly instead of teleport" is a bar to clear, not a license) — run that veto before implementing anything here.
