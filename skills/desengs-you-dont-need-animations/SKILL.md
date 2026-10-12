---
name: desengs-you-dont-need-animations
description: Use when deciding whether an element should animate at all or when UI motion feels slow or gratuitous. Emil Kowalski's essay: most interfaces don't need animations — gate by purpose, frequency, and sub-300ms speed.
source: https://emilkowal.ski/ui/you-dont-need-animations
category: essay
---

# You Don't Need Animations (desengs) — the restraint counter-argument

Source: https://emilkowal.ski/ui/you-dont-need-animations — "You Don't Need Animations. Why you are animating more often than you should." Free essay by Emil Kowalski (design engineer at Linear, ex-Vercel; creator of Sonner and Vaul), one of his `emilkowal.ski/ui` essays. No license stated. The author also sells the animations.dev course — this essay is not the opposite of that course, it is the gate that runs before it: the same author who is famous for motion spends an essay defending the null option.

## What it is / Why it exists

The essay's claim, from its own description: you are animating **more often than you should**. Motion is bidirectional — "When done right, animations make an interface feel predictable, faster, and more enjoyable to use. They help you and your product stand out." But "when done poorly, they have the opposite effect: the interface feels unpredictable, slow, and sometimes even annoying. Users can lose trust in your product."

It exists because animation is the default reflex of eager builders (and now AI agents): every mount, hover, and state change gets a transition. The essay restores "no animation" as a first-class, often-optimal answer — "sometimes the best animation is no animation."

This skill is the canon's counterweight: within a canon full of motion techniques, this is the veto. Load it *before* any animation skill.

## The core ideas

### 1. Argument structure — three gates, in order

The essay is not a list of tips; it is a funnel. An animation must pass all three gates or be deleted:

1. **Purpose** — "Step one is making sure your animations have a purpose."
2. **Frequency** — "How often users will see an animation is a key factor in deciding whether to animate or not."
3. **Speed** — "Unless you are working on marketing sites, your animations have to be fast."

Most candidates die at gate 1 or 2. The survivors are constrained at gate 3.

### 2. Gate 1 — Purpose: what animation genuinely adds

The essay's sanctioned purposes, with its own examples:

- **Explanation (marketing)**: Linear's Product Intelligence page uses an animated explainer instead of a static asset because it "helps users grasp the product right within the initial viewport." Marketing is the one context where motion may be slow, long, and delightful.
- **Feedback (causality)**: a subtle scale-down on button press makes the interface "feel more alive and responsive" — the animation proves *your action caused this*.
- **Spatial consistency (continuity)**: Sonner's toast enter animation does two jobs — it keeps the toast from abruptly appearing, and because the toast enters and exits in the **same direction**, it teaches the spatial model that makes swipe-to-dismiss intuitive.
- **Delight — valid only at low frequency**: a morphing feedback component (thumbs-up morph) makes the experience unique and memorable *because it is rarely seen*. Decay law, in his words: "If you used this feature every day, the initial delight would fade and the animation would slow you down."

Anything that names no purpose — "it looks cool" on a frequently-seen element — is decoration. Delete it.

### 3. Gate 2 — Frequency: the strongest gate in the essay

- Raycast, which he opens "hundreds of times a day", has **zero open animation** — and he calls that "the optimal experience." When the user has a clear goal and repeats the action constantly, they need friction-free speed, not delight.
- The essay ships an interactive demo of an animated vs. non-animated command menu; the non-animated one feels faster — the animation adds only latency.
- **Hover effects** used many times a day "would likely benefit the most from having no animation at all."
- **Keyboard-initiated actions are a hard never**: for actions repeated hundreds of times daily, "an animation would make them feel slow, delayed, and disconnected from the user's actions. You should never animate them." Arrow-key menu navigation must track 1:1 with zero transition.

### 4. Gate 3 — Speed: motion taxes perceived performance

Perceived speed is real and cuts both ways:

- A faster-spinning spinner "make[s] the app seem to load faster, even though the load time is the same." Motion speed, not load speed, sets the perception — the wait is fixed, so tune the *apparent* rate of progress, not just the real one.
- A 180ms dropdown animation feels more responsive than a 400ms one at identical real speed.
- The rule of thumb, stated verbatim: **"UI animations should generally stay under 300ms."**
- The marketing exemption is explicit: "Unless you are working on marketing sites, your animations have to be fast." First-impression, seen-once contexts may run long; tool UIs may not.
- **Tooltip exception**: tooltips keep an initial delay (prevents accidental activation on pass-through), but once one tooltip in a group is open, hovering to the others must open them **instantly — no delay, no animation**. The delay guards against accidents, not against understanding — once the intent is proven, it has no job left.

### 5. The essay's own evidence — the command-menu demo

The essay includes an interactive A/B: the same command menu, one with an entrance animation, one without. The lesson from toggling it: the animated version makes the palette *later* — every open pays the animation's duration before the list is usable, hundreds of times a day, in exchange for a flourish nobody asked for. When the user's goal is already formed (they opened the palette to type a command), motion can only add friction. Delight belongs where goals are unformed — browsing a marketing page — not where they are fixed.

### 6. The cost accounting (what the essay makes you pay for)

Every animation is charged against four budgets, and the essay implies all four:

- **Time**: duration sits between intent and result. On repeated actions it compounds — "slow, delayed, and disconnected."
- **Attention/trust**: purposeless motion makes the interface "unpredictable"; done poorly, "users can lose trust in your product."
- **Perceived performance**: slow-feeling motion reads as a slow app even when metrics are identical (the spinner and the 180ms-vs-400ms dropdown).
- **Delight decay**: delight is a depleting resource — spend it where frequency is low enough that it never depletes.

### 7. The decision rule — an animation budget

Operationalizing the essay: **animate only what proves causality (feedback), continuity (spatial consistency), or explanation (marketing/onboarding) — plus a small delight budget reserved for rare paths.** High-frequency surfaces have a budget of exactly zero.

| Est. uses/day | Decision | Examples |
| --- | --- | --- |
| 100+/day, or keyboard-driven | **No animation. Ever.** | Command palette open, arrow-key selection, hover color |
| Tens/day | None, or near-imperceptible | Tab underline, list row highlight |
| Occasional | Fast animation, ≤300ms (0.2–0.3s default) | Modal, drawer, toast, dropdown |
| Rare / first-run | Delight budget — the only place it lives | Success morph, celebration, marketing explainer |

### 8. The mechanisms (plain CSS/JS)

```css
/* 1. The optimal command menu: nothing. Instant mount, instant highlight. */
/* Keyboard-driven selection must NEVER animate — it tracks the keys 1:1. */
.cmd-item[aria-selected='true'] { background: var(--selected-bg); }
/* no transition declared, on purpose */

/* 2. High-frequency hover: instant state change, no transition */
.tab:hover { color: var(--fg); background: var(--hover-bg); }
/* a 200ms fade on a hover you trigger 50x/day is 200ms of fog, 50 times */

/* 3. Sanctioned: press feedback (causality), fast */
.button { transition: transform 120ms cubic-bezier(0.22, 1, 0.36, 1); }
.button:active { transform: scale(0.97); }

/* 4. Sanctioned: toast enters and exits the SAME edge (continuity) */
.toast { transform: translateY(100%); opacity: 0;
  transition: transform 250ms var(--ease-out-strong), opacity 250ms var(--ease-out-strong); }
.toast[data-open] { transform: translateY(0); opacity: 1; }
.toast[data-closing] { transform: translateY(100%); opacity: 0;
  transition-duration: 200ms; } /* exit mirrors entrance, faster */

/* 5. Sub-300ms law: 180ms reads responsive; 400ms reads slow at equal real speed */
.dropdown { transition: opacity 180ms var(--ease-out-strong),
  transform 180ms var(--ease-out-strong); }

/* 6. Spinner: if a wait must exist, a faster cycle reads as a faster app */
.spinner { animation: spin 0.6s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
/* 0.6s cycle vs 1.2s: identical load time, different perceived speed */
```

```js
// 5. Tooltip group rule: initial delay ONCE, then instant within the group
let tooltipOpen = false;
function onEnter(target) {
  if (tooltipOpen) return openInstant(target);        // no delay, no animation
  const t = setTimeout(() => { tooltipOpen = true; openAnimated(target); }, DELAY);
  onLeave.cancel = () => clearTimeout(t);
}
```

### 9. The closing frame — the goal is not animation

The essay ends where it started, widening the lens: the goal is not to animate or to refrain from animating — it is "building great interfaces that users will happily use every day." Knowing when to animate is one skill among many, subordinate to that goal. The title is the takeaway: the default answer to "should this animate?" is no, and the burden of proof sits on the animation, never on its absence.

## When to use / When NOT to use

Use when: adding any animation and asking *whether* first; auditing an over-animated tool UI; a request like "make it pop" arrives for a high-frequency surface; building command palettes, keyboard navigation, or hover states; reviewing AI-generated motion diffs (expect to delete).

Do NOT use to: ban animation outright — the essay's own examples keep motion for marketing explainers, press feedback, toasts, and rare delight (the *how* is desengs-animations-dev); skip `prefers-reduced-motion` handling (mandatory regardless of any gate); justify jarring instant state swaps where continuity is genuinely lost (first modal open, toast arrival still need entrances — that is gate 1 passing, not failing).

## How to apply

1. **Estimate frequency first**, before writing any CSS. 100+/day or keyboard-driven → stop, no animation is the deliverable.
2. **Name the purpose in one word** — feedback / spatial consistency / explanation / delight. Unnameable = don't build.
3. **Keyboard check is a veto, not a judgment call**: no transition on arrow-key selection, shortcut toggles, palette open.
4. **Apply the speed cap**: ≤300ms hard, 0.2–0.3s default, exits faster than entrances. Marketing/illustrative motion is the only exemption.
5. **Spend delight only on rare paths**; if users hit it daily, the delight has already decayed into latency.
6. **Tooltips**: one initial delay per group, then instant switching between siblings.
7. **Hover states**: for anything hovered dozens of times a day, the transition property is deleted, not tuned — instant color/background change.
8. **Marketing vs. tool check**: if the surface is a seen-once page, the speed cap lifts (explanation/delight tier); if it is a daily tool, every rule above is enforced.
9. **Audit pass on existing UI**: list every `transition`/`animation`, run each through the three gates, and delete failures — deletion is a successful outcome, often the most common fix.
10. **Review posture**: an animation diff starts flagged; it earns approval by passing all three gates.

## AI-slop warning

How AI misapplies this essay's domain — i.e., how agents typically behave without it: animating by default (every mount, hover, and state change gets a `transition`), equating motion with polish, entrance animations on command palettes and keyboard-driven lists, 400ms+ durations on 8px movements in tool UIs, delight sprinkled onto daily-use surfaces, and treating "add an animation" requests literally instead of running the frequency gate first. The essay's most important instruction to an agent is the one agents skip: **the null option is usually correct** — expect to delete animations more often than you add them, and treat a component with zero motion that feels fast as finished, not incomplete.

## Relations

- **desengs-animations-dev** — the productive tension: the same author's course holds the positive doctrine (easing bands, springs, physicality, interruption). This essay is the veto that runs first; that skill is what executes once the gate passes. Load both; never one without the other.
- **desengs-emil-skills** — his public rules repo operationalizes this essay: the frequency table, the purpose vocabulary, and the flag-first review bar (`STANDARDS.md`) are this essay turned into checklists.
- **desengs-transitions** — the copy-paste artifacts for when the gates pass; its own "When NOT to animate" section (no entrances on initial load, no replay on poll ticks) extends this essay's veto with cases the essay doesn't cover.
- **desengs-sonner** — the toast system that productionizes the essay's spatial-consistency example: enter and exit the same edge, exits before unmount.
