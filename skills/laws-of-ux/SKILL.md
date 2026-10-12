---
name: laws-of-ux
description: Use when deciding interaction behavior — option counts, target sizes, response timing, ordering, emphasis, defaults. 30 cognitive laws, each mapped to the concrete UI decision it dictates.
source: https://lawsofux.com/
category: principle
---

# Laws of UX — cognitive heuristics that decide interface behavior

Source: https://lawsofux.com/ — Jon Yablonski. A collection of 30 cognitive-science findings (named laws, effects, and six supporting psychology concepts), one page each: statement → takeaways → origins → examples → related laws. Site content © Jon Yablonski; free poster downloads; expanded in his book *Laws of UX*.

## What it is / Why it exists

Every entry converts an experimental finding (with researcher, year, and numbers) into takeaways an interface builder can act on. Use it to settle behavior decisions — how many options, how big targets, how fast feedback, what goes first/last, what stands out — with evidence instead of taste. The site's own taxonomy has three tiers:

1. **Named laws and effects** (Doherty, Hick, Fitts, Miller, Jakob, Tesler, Postel, Pareto, Parkinson, Occam, Prägnanz, Proximity, Similarity, Common Region, Uniform Connectedness, Von Restorff, Serial Position, Peak-End, Goal-Gradient, Zeigarnik, Aesthetic-Usability, Paradox of the Active User, Choice Overload, Cognitive Bias, Flow).
2. **Six supporting concepts**, each explicitly flagged "closely related to" a parent law: Chunking → Miller, Cognitive Load → Miller, Working Memory → Cognitive Load, Mental Model → Jakob, Selective Attention → Von Restorff, Choice Overload → Hick.
3. **Origins metadata** on every page — the experimenter, year, and setup — so a number can always be traced (e.g. <400ms → Doherty & Thadani, IBM Systems Journal, 1982).

## The core ideas

Quick reference — situation → law → the value or action it dictates:

| Decision on the table | Law | Dictated answer |
| --- | --- | --- |
| How fast must feedback arrive | Doherty Threshold | <400ms, else show progress (presence > accuracy) |
| How many menu options | Hick's Law + Choice Overload | Reduce; spotlight one; add search/filter instead of listing all |
| Justify a count of 7 | Miller's Law | Banned by the source; chunk, don't cap |
| How big a touch/click target | Fitts's Law | Large + spaced + near attention; no px in source, use 44/48px floors |
| Where to put key nav items | Serial Position Effect | Far left and far right; bury sacrificable items mid-list |
| What should stand out | Von Restorff + Selective Attention | Exactly one distinctive element; never color-only; don't resemble an ad |
| How long a flow may take | Parkinson's Law | Cap at expected duration; autofill to beat it |
| Where help lives | Paradox of the Active User | Contextual tooltips on every path, never up-front docs |
| How to ship a redesign | Jakob's Law | Keep the old version reachable for a limited transition |
| What the last screen says | Peak-End Rule | Design it as a peak; negatives dominate memory |
| How strict inputs are | Postel's Law | Accept variants, translate internally, clear feedback |
| Who absorbs the complexity | Tesler's Law | The system, not the user |

### Timing: how fast, how long

- **Doherty Threshold** (Walter J. Doherty & Ahrvind J. Thadani, 1982, IBM Systems Journal): "Productivity soars when a computer and its users interact at a pace (<400ms) that ensures that neither has to wait on the other." Replaced the earlier 2,000ms standard; systems under 400ms felt "addicting." Decisions: give system feedback within 400ms; when work runs longer, show a progress indicator — accuracy of the estimate does not matter, only presence; use perceived performance (optimistic UI, motion during processing); deliberately slowing a moment can raise perceived value and trust.
- **Hick's Law** (William Hick & Ray Hyman, 1952): decision time increases with the number and complexity of choices. Decisions: cut options when response speed matters; split complex tasks into smaller steps (one decision per screen); spotlight a recommended option; use progressive onboarding — site example: Slack reveals only the messaging input first and introduces features gradually via bot practice. Hard limit from the site: don't oversimplify until the design becomes abstract.
- **Flow** (Mihály Csíkszentmihályi, 1975): immersion requires challenge balanced with skill — too hard → frustration, too easy → boredom. Decisions: confirm every completed action with feedback; remove unnecessary friction; keep content and features discoverable so users don't disengage.

### Memory: how much, in what order

- **Miller's Law** (George Miller, 1956): working memory holds 7±2 items; 4 bits = one choice among 16 equally likely alternatives. Site takeaway 1 is a ban: do NOT invoke the "magical number seven" to justify arbitrary design restrictions. Use chunking instead; capacity varies by person, prior knowledge, and context.
- **Chunking** (from Miller's 1956 paper): break information into pieces, regroup into a meaningful whole. Decisions: visually distinct modules, clear hierarchy, explicit separation rules between groups.
- **Working Memory** (concept; Miller/Galanter/Pribram coined the term, 1960s): 4–7 chunks at a time, each fading in 20–30 seconds. Decisions: recognition over recall — differentiate visited links, provide breadcrumbs; put the memory burden on the system — carry critical info screen to screen (e.g. comparison tables that persist).
- **Serial Position Effect** (Hermann Ebbinghaus): first and last items in a series are remembered best (primacy + recency). Decisions: put the least-important items in the middle of lists; place key actions at the far left and far right of navigation.
- **Zeigarnik Effect** (Bluma Zeigarnik, 1920s): uncompleted or interrupted tasks are remembered better than completed ones. Decisions: clear signifiers that more content exists; artificial progress toward a goal; visible progress indication.
- **Goal-Gradient Effect** (Clark Hull, 1932 hypothesis; 1934 rat-alley experiment): effort accelerates with proximity to the goal. Decisions: show progress clearly; give users an artificial head start (endowed progress) to raise completion odds.
- **Peak-End Rule** (Kahneman, Fredrickson, Schreiber, Redelmeier, 1993 — subjects preferred 60s at 14°C plus 30s at 15°C over 60s at 14°C alone): experiences are judged by their peak and their end, not the average. Decisions: find where the product is most valuable and design that peak deliberately; invest in the final screen of a flow; negative experiences are recalled more vividly than positive ones — fix the worst moment first.

### Perception and grouping

- **Law of Prägnanz** (Max Wertheimer, 1910, railroad-marquee lights): ambiguous/complex images are perceived as the simplest possible form — least cognitive effort; simple figures are processed and remembered better than complex ones. Decision: reduce complex shapes to single, unified, simple forms.
- **Law of Proximity**: near objects group together (Gestalt). Decision: spacing itself creates the grouping — site example: Google result spacing both aids scanning and clusters each result.
- **Law of Similarity**: color, shape, size, orientation, and movement signal shared meaning/function. Decision: links and navigation must be visually differentiated from body text; do not reuse one visual attribute across unrelated controls.
- **Law of Common Region**: elements sharing a bounded area group. Decisions: a border or a background is enough to create the group — cheapest structural tool for cards and form sections.
- **Law of Uniform Connectedness**: visually connected elements read as more related than unconnected ones. Decisions: connect related functions with color, lines, or frames; use tangible connectors (line, arrow) step-to-step in flows.
- **Von Restorff Effect / Isolation Effect** (Hedwig von Restorff, 1933): among similar objects, the one that differs is remembered. Decisions: make key information and primary actions visually distinctive; apply emphasis sparingly — competing emphases dilute each other and salient items get mistaken for ads; never communicate contrast by color alone (excludes color-vision deficiency and low vision); weigh motion sensitivity before using motion as the differentiator.
- **Selective Attention** (Broadbent filter 1958; Cherry cocktail-party 1953; Treisman attenuation 1960; Deutsch & Deutsch late selection 1963; Kahneman capacity 1973): attention filters to a goal-relevant subset. Decisions: never style real content to look like ads or place it in ad-typical slots (banner blindness); never trigger two competing changes at once — uncued changes go unseen (change blindness).

### Trust, familiarity, and input

- **Jakob's Law** (Jakob Nielsen): users spend most of their time on other sites and prefer yours to work the same way. Decisions: copy existing conventions (toggles, radios, buttons descend from physical controls); when redesigning, let users stay on the familiar version for a limited time — site example: YouTube's 2017 redesign offered preview, feedback, and revert.
- **Mental Model** (Kenneth Craik, 1943): users hold a compressed model of how a system works and apply it to similar systems. Decision: match the design to the users' model (e-commerce conventions: product cards, cart, checkout); closing the gap is a research task — interviews, personas, journey maps.
- **Aesthetic-Usability Effect** (Kurosu & Kashimura, Hitachi, 1995 — 252 participants rating 26 ATM UI variants): perceived ease of use correlated with aesthetics more than actual ease of use. Decisions: polish buys tolerance for minor flaws; and it masks real usability problems — never judge usability from attractiveness, including in testing.
- **Postel's Law / Robustness Principle** (Jon Postel, TCP): be liberal in what you accept, conservative in what you send. Decisions: accept variable user input and translate it internally; define input boundaries; return clear feedback for every rejection; the more anticipated, the more resilient the design.

### Effort allocation and structure

- **Fitts's Law** (Paul Fitts, 1954): time to acquire a target is a function of distance to and size of the target; rapid movement + small target = errors. Decisions: targets large enough to select accurately; ample spacing between targets; put targets in the areas users attend to, and keep the distance between task content and its button short — the site gives no pixel values, so fill with platform minimums (44px iOS HIG, 48px Material) rather than inventing one.
- **Tesler's Law / Conservation of Complexity** (Larry Tesler, Xerox PARC, mid-1980s): every system has irreducible complexity — the system or the user must absorb it. Tesler's trade: an engineer spends an extra week simplifying so millions of users don't each spend an extra minute. Counterpoint (Bruce Tognazzini): simplify the app and users simply attempt harder tasks. Decisions: absorb complexity in design/dev, not the UI; guidance must be contextual and path-agnostic; design for irrational real users, not an idealized rational one.
- **Occam's Razor** (William of Ockham, c. 1287–1347): among hypotheses that predict equally well, pick the fewest assumptions. Decision: remove elements until removal would compromise function — completion means nothing more can be removed.
- **Pareto Principle** (Vilfredo Pareto; 80% of Italy's land held by 20% of the population): roughly 80% of effects come from 20% of causes. Decision: spend design effort on the few elements that serve the most users.
- **Parkinson's Law** (C. Northcote Parkinson, Economist essay 1955, book 1958): a task inflates until all available time is spent. Decisions: cap task duration at what users expect; completing faster than expected improves the experience; autofill critical form data to prevent inflation.
- **Paradox of the Active User** (Mary Beth Rosson & John Carroll, 1987): users never read manuals; they start using the software immediately, errors and all. Decision: no up-front documentation — contextual help (tooltips) available on every path.
- **Choice Overload** (Alvin Toffler, *Future Shock*, 1970; paired with Hick's Law): too many options degrades deciding and the felt experience. Decisions: when comparison is necessary, make it side-by-side (pricing tiers); provide narrowing tools up front (search, filtering); feature one option.
- **Cognitive Load** (John Sweller, late 1980s; 1988 paper): intrinsic load = goal-relevant information users must carry; extraneous load = processing that doesn't aid understanding (distracting/unnecessary elements). Decision: delete extraneous elements; every pixel that isn't goal-relevant charges rent.
- **Cognitive Bias** (Tversky & Kahneman, 1972): heuristics make judgment fast and systematically wrong (e.g. confirmation bias). Decision: expect biased reading of your interface and biased reading of your own metrics — the law applies to the designer too.

### Mechanisms (plain CSS/JS)

Response budget — Doherty feedback under 400ms; indicator when over:

```js
const BUDGET = 400;
const t0 = performance.now();
showInstantUIFeedback();              // ack < 100ms: pressed/hover state, optimistic UI
await doWork();
const over = performance.now() - t0 > BUDGET;
if (over) showProgressBar();          // presence matters, estimate accuracy does not
```

One differentiator — Von Restorff with a single accent (never color alone):

```css
:root { --accent: oklch(0.62 0.19 35); }
.btn-primary { background: var(--accent); color: white; font-weight: 600; } /* the ONE solid, filled control */
.btn-secondary { background: transparent; border: 1px solid currentColor; } /* recede */
```

Ordering and targets — serial position + Fitts + proximity:

```css
.nav { display: flex; gap: 8px; }
.nav .nav-item { min-height: 44px; min-width: 44px; }   /* platform floor; bigger if fingered */
.nav .key-action { order: -1; }                          /* far left; secondary last = far right */
.form-section { border: 1px solid #ddd; padding: 16px; } /* common region per chunk */
a:visited { color: var(--visited); }                     /* recognition over recall */
```

Chunking + step-splitting — Hick's "divide complicated tasks" with a visible progress track (Goal-Gradient):

```html
<fieldset>                       <!-- common region = one chunk = one decision -->
  <legend>Billing</legend>       <!-- labels the chunk; hierarchy inside it -->
  ...
</fieldset>
<ol class="steps" aria-current="step">  <!-- progress: artificial head start welcome -->
  <li>Plan</li><li>Billing</li><li>Confirm</li>
</ol>
```

## When to use / When NOT to use

Use when deciding: menu/option counts and grouping (Hick, Miller, Chunking, Choice Overload), touch/click target size and placement (Fitts), loading/feedback timing and progress (Doherty), ordering of nav/list items (Serial Position), what element stands out (Von Restorff + Selective Attention), form tolerance and validation copy (Postel), onboarding and help placement (Paradox of the Active User, Tesler), redesign rollout (Jakob), flow endings and success states (Peak-End).

Do NOT use: as visual-style rules — these decide behavior, not aesthetics (pair with a taste skill for form); as rigid numeric laws — the site itself forbids the 7±2 justification and gives no pixel counts for targets; to replace user research — mental-model gaps close only via interviews/journeys/personas; to override an established platform convention in the name of a "law" — Jakob's Law wins over cleverness.

## How to apply

1. Any action feedback: ack immediately; full response or progress indicator within 400ms.
2. Choose option counts: if speed matters, reduce; highlight one recommended path; when comparison is required, go side-by-side, never long-form.
3. Never cap or justify a count with "7±2". Chunk instead: visually distinct groups, clear hierarchy, separation between groups.
4. Targets: at least 44×44px (platform floor), generous spacing, placed near the content that motivates the click; distance between a setting and its Save button stays short.
5. Ordering: key actions at the far left and far right of nav/toolbars; sacrificial items mid-list.
6. Emphasis: exactly one visually dominant element per view; contrast via weight/shape/fill plus color, never color alone.
7. Memory: visited-link states, breadcrumbs, persistent selection summaries, comparison tables — the system remembers, the user recognizes.
8. Progress: visible indication on any multi-step task; consider an endowed head start for long flows.
9. Input: accept variants, translate internally, validate with boundaries, and give clear feedback on every failure; autofill whatever you can.
10. Help: contextual (tooltips, inline hints) on every path; zero reliance on manuals or up-front docs.
11. Redesigns: keep the familiar version reachable for a limited transition; match existing mental models before inventing patterns.
12. Endings: design the final screen of every flow (success, confirmation) as a peak; audit for the worst moment first — negatives dominate memory.
13. Simplify by removal until function breaks (Occam), and put saved effort where most users are (Pareto 80/20).
14. Before shipping, check: nothing looks like an ad; no two simultaneous uncued changes; no decorative element that adds extraneous load.

## AI-slop warning

AI misapplies these laws in predictable ways: it hard-caps nav at 7 items citing Miller (explicitly banned by the source); quotes "<400ms" while shipping spinner-only waits (the fix is perceived performance, and presence of progress beats accuracy); invokes Hick's Law to bury features under nested progressive disclosure until they're undiscoverable (violates Flow's discoverability takeaway); applies Von Restorff by emphasizing everything — five accent colors, badge on every card — so nothing isolates; adds confetti endings to flows whose peak moment is still broken (Peak-End is peak AND end); treats Aesthetic-Usability as license to polish over real usability bugs it was supposed to reveal; inflates all buttons to hero size (Fitts is relative — distance and spacing co-decide); uses "reducing cognitive load" to justify empty pages with no hierarchy (Chunking requires structure, not absence). Any law citation without its number or origin is post-hoc rationalization — demand which law, which value, which decision it changes.

## Relations

- **ui-ux-canon** — the canon index; routes here whenever a behavior decision (timing, counts, sizing, emphasis) is on the table.
- **web-interface-guidelines** — supplies the concrete pixel/spacing/typography values these laws leave unspecified (Fitts sizing floors, proximity spacing rhythm).
- **transitions** — the motion mechanisms that implement Doherty's perceived-performance and Flow's action-feedback takeaways without becoming slop.
- **taste** — decides form where this skill decides behavior; Aesthetic-Usability is the documented interaction point: taste changes perceived usability even when actual usability is unchanged.
- **principles** — companion principle canon; pairs general design principles with these experiment-derived laws when justifying a decision.
