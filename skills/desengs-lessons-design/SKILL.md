---
name: desengs-lessons-design
description: Use when a UI decision calls for taste over rules — what to cut, when to break your own system, how to frame work. Distills Fabricio Teixeira's 7-chapter Lessons of Design into build-changing rules.
source: https://lessons.design/; https://uxdesign.cc/lessons-of-design-75cc0731534
category: principle
---

# Lessons of Design (desengs) — hard-won lessons from a working designer

Source: https://lessons.design/ — Fabricio Teixeira, UX designer (~20 years in digital products, co-founder of UX Collective). A single-scroll Readymag piece: prologue + 7 chapters, each anchored by a quote from a design master (Fukasawa, Grillo, Wheeler, Ruskin, Angelou, Hadid, Baldwin) and ~10 lettered lessons (≈76 total, lettered a–l per chapter). Same text self-published as "Lessons of Design", UX Collective, Apr 15 2023. No explicit license — quote sparingly, attribute. Site's own craft: 1360px artboard, Inter 104/-6 headings, Alex Brush "handwritten" lesson numbers, #F2AB3C hover accents — a homework-notebook aesthetic that proves the thesis (constraint + one human flourish > decoration).

## What it is / Why it exists

Not a spec, not a library — a practitioner's belief system after two decades, compressed into maxims and aimed at decisions that component docs can't settle: when subtraction beats addition, when breaking your own system is correct, how framing decides whether good work survives. The prologue sets the stance — "I thought I was just another designer of products. Turns out I am a product of design" — the maxims are environmental: absorbed inputs, distilled behavior. Treat it as a tie-breaker layer over hard standards: it tells you which way to lean when two valid implementations exist. Chapter titles are literal imperatives — "find your conceptual models", "simplicity is saying no", "framing is magic", "consistency compounds", "chaos is rarely a bad thing", "change is the only way", "joy is the real legacy" — and the whole arc moves from product (ch. 1–2) to craft (3–5) to career (6–7).

## The core ideas

### 1. find your conceptual models (anchor: Fukasawa — "Design dissolves in behavior")

- Before pixel one, write the model: what existing behavior does this feature plug into? If you can't name the behavior, you're decorating, not designing.
- Interrogate what the product asks people to do vs what they actually do (Fukasawa: designers should notice what "nobody asked for"). Mine observed behavior for feature ideas before inventing new ones.
- If it's meant for everyday use (like Fukasawa's wall-mounted CD player pulled strings of memory), optimize for the 1000th use, not the demo.
- Conceptual models aren't only utilitarian: emotions, traditions and social rules work too — a memory can anchor an interaction the way a mental model does.
- Designers and users share mental models: what's obvious to you because you designed it is not obvious to them. Test the model against someone who didn't build it.
- Whenever two ideas argue, find the third — the collision of your model and reality produces the better concept.
- You're never bad at something, just new to it: treat unfamiliar domains as model-building, not talent gaps. Assemble your own puzzle from every source you can find.

### 2. simplicity is saying no (anchor: Grillo — take away "anything foreign" to the design)

- Teixeira's rule: simplicity is repeatedly saying no to almost everything. Per feature, run the redundancy audit — list elements serving a similar purpose and either merge them, group them, or pull them apart. Never keep two without knowing why.
- "Try subtracting before adding" (Leslie Chilcott's motto, adopted). When something feels off, delete first; add only after deletion demonstrably fails.
- The "and/also" test: if a feature's one-line description contains "and" or "also", it's two features — split them, ship the smaller one first.
- Usable but not useful is failure: verify the thing is worth using before polishing its ease of use.
- A concept isn't simple until the extras are removed and the essentials are emphasized — removal and emphasis are one move, two halves.
- Progressive disclosure by context: reveal functions only when the context makes them relevant (Google Maps' search field = the whole UI at rest). Don't dump every requirement into one frame.
- Words are cheaper than pixels: getting the words right can make UI elements disappear. Cut headings, CTAs and helper text before cutting white space — space is "the pixels you don't use", the choreography.
- Say it with one thing: one element speaks louder than a combination of many.

### 3. framing is magic (anchor: Wheeler — "Design is intelligence made visible")

- Never present work as a "real estate tour" (where things are). Present frames: the story behind it, why it matters now, what problem it kills. Framing is a placebo — the same artifact lands differently depending on the frame.
- Keep a frame inventory and rotate: conceptual name (Fukasawa/Sony), one-sentence description, moodboard, story, video, poem, metaphor (Zaha's "flower"), drawing, framework (Jony Ive's 9-square grids), data point, quote, personal experience, song lyrics.
- Name things like Fukasawa named Muji products — a great name frames the object forever. Budget real time for naming screens, features, releases.
- For each stakeholder, find the motivation behind their words before responding to the words.
- Iterate frames like design iterations: each needs a concept, words, type, mood; treat each frame as its own design exercise. Test multiple framings of the same work the way you test layouts.
- Some of the best frames come from outside your immediate circle — users, strangers, previous eras; be open to the unexpected (people on a bus, an Apple keynote audience, a poem).
- Decide with data when measuring the past; with intuition when imagining the future (credit: Lina Bo Bardi's intuitionism). Never swap these two.

### 4. consistency compounds (anchor: Ruskin — "nothing is insignificant")

- Consistency is a designer's most important technical skill. Users feel it without naming it; its absence reads as carelessness everywhere.
- Proofread everything, twice. Teixeira's non-negotiable list: fonts and sizes, spacing, components, grammar, spelling, line heights, leading, margins, colors, assets. For a build pipeline this means lint tokens, not eyeballs.
- Consistency is what lets a product scale: each consistent piece compounds trust built by the previous one.
- Trust in a design (or a codebase) is cumulative — every element is either coherent with the previous ones or spends the balance.
- Flip side (lesson 4.i): consistency is not sameness — context wins. The same control may need different treatment in different contexts.
- Someone else's inconsistency: flag it in private, fix it without public shaming.
- When you can't fix others' inconsistency yourself, at least don't imitate it — hold your own baseline.

### 5. chaos is rarely a bad thing (anchor: Angelou — "You may not control all the events...")

- Breaking your own system is how work becomes memorable; untouched consistency trends toward interchangeability. Users remember experiences, not your design system.
- Chaos outside is fuel: a war, a rivalry, a constraint you didn't choose (Tehran's moles-to-Aleppo underground railway, built out of scarcity) — treat every constraint as a design brief.
- Flip questions when stuck: make the type 10x bigger, shorten content by 90%, invert the background, reverse the flow order. The bad answers expose the good one.
- Detach instances deliberately — never by accident. Every rule-break must carry a written rationale ("transgressions are a product of love", per Alejandro Gacía).
- To break a system effectively you must first understand it deeply: generalists break systems better (UX + copy + motion + visual broken together > one axis).
- "Just because you can, doesn't mean you should": rule-breaks are rationed, not sprinkled.

### 6. change is the only way (anchor: Hadid — "There are 360 degrees, so why stick to one?")

- If the change isn't meaningfully better, don't touch it — not even "a quick refresh".
- Design isn't done at the artboard: the road from final design to shipped product is long and full of sabotage. Keep the purest version of the idea and protect it through the pipeline (repeat the same presentation "95 times" with first-time passion).
- What you design is never exactly what ships: account for the delta, decide which compromises are survivable.
- The internet compresses great design into "the designer had a crazy idea" legends — in reality the change took time, patience and daily dedication (Century Regional in LA, 25 years). Plan accordingly.
- Figure it out: photo budget $0, timeline short, your favorite feature cut from the MVP — output constraints in, excuses out.
- Ideas are everywhere (Angelou: "you may not control all the events"), but ideas alone are worthless — production is a matter of discipline, not a spark.
- Growing = making new mistakes, never repeating old ones. Log what failed; don't re-fail it.

### 7. joy is the real legacy (anchor: Baldwin — "There is never a time in the future in which we will work out our past")

- Design is a team sport. Credit is a designer's currency — give it away even where not strictly due; generosity compounds.
- Criticize in private, praise in public. Applies to PR reviews and design critiques equally.
- Your peers' reputations are part of your toolkit: championing others' work is how good ideas get built at all.
- Silliness lowers walls: when the room gets too serious, the work gets worse.
- Design is a creative sport with deadlines — nobody will ask how you felt; embrace repetition ("success is 10% inspiration, 90% repetition").
- Legacy = impact on people, not artifacts. Optimize the work's effect on humans and collaborators, not the portfolio shot.

## The artifact itself (what to steal from the presentation)

- The site practices its own ch. 5: within a strict system (fixed 1360 artboard, one accent, one grid) it uses a second "handwritten" voice (Alex Brush lesson numbers, #F2AB3C accents, circled words) — one deliberate, consistent system break that carries the entire identity. That is the rationed transgression model in production.
- One long scroll, no navigation chrome, no arrows/page counter (all disabled in project opts): the constraint IS the design — the "Homework" notebook conceit decides every option. Pick one conceit per project and let it settle arguments.
- Icons of the craft are shown, not linked — Fukasawa's CD player, Bo Bardi's SESC Pompéia, Ando's Church of the Light: reference by artifact, never by adjective. In docs and reviews, link the exemplar.

## When to use / When NOT to use

Use when: choosing between two valid implementations (subtraction leans); deciding whether to detach from a design system; writing UI copy (words replace pixels); preparing a handoff/presentation (frames, not tours); reviewing work (proofread list as the pass criteria); deciding scope (and/also split); picking what to defend during implementation.
NOT for: hard accessibility/contrast/motion numbers — use measured standards siblings; component APIs or code — this source contains none; also do not apply chapter 5 as license for random visual noise, nor chapter 2 as license to strip affordances (a11y labels, error states are never "foreign to the design").

## How to apply

1. Write the one-sentence conceptual model of the feature (what behavior it plugs into) before any UI. No model, no UI.
2. List every element serving a similar purpose on the screen; merge/group/pull apart until each has exactly one job.
3. Run the "and/also" test on each feature description; split doubles; ship the smallest half first.
4. Before adding anything to fix a complaint, try deleting something; keep a note of what deletion fixed.
5. Write UI copy conversationally; then delete headings/helper text that copy made redundant.
6. Plan disclosure: define what each state reveals by context, so no frame carries every requirement.
7. Proofread pass, twice, over: fonts, sizes, spacing, components, grammar, spelling, line height, leading, margins, colors, assets. Automate what tokens can encode.
8. Allow at most one deliberate system break per screen/flow, with a one-line rationale in code comment or review note.
9. When stuck, run flip questions (10x type, 90% less content, inverted background, reversed order); discard the results, keep the insight.
10. Frame every artifact you hand off: name, story, problem killed, why now — never a tour of where things live.
11. If a proposed change isn't meaningfully better, close the ticket with that verdict.
12. Attribute borrowed moves (names, frames, patterns) to their authors in commits/notes — credit as currency.
13. Name every screen, flow and release like Fukasawa named products — a name is a frame that outlives the design; never ship "Untitled-3", "Step 2", "New modal".
14. Before responding to feedback, write the stakeholder's likely motivation in one line; respond to that, not to their exact words.
15. Keep a decision log of what was cut and why — "new mistakes, never repeated ones" requires knowing the old ones.

Frame template for every handoff (fill all four; a handoff missing any is a real-estate tour):

```
Name:      <the frame — one memorable name, not a feature ID>
Story:     <the behavior it plugs into / the memory it recreates>
Problem:   <what it kills, with the user's words if possible>
Why now:   <what changed that makes this the moment>
```

Mechanism sketch — a token-level proofread guard for the consistency pass:

```css
/* one source of truth per decision; proofreading becomes grep, not vibes */
:root {
  --step-0: 0.875rem; --step-1: 1rem; --step-2: 1.5rem; --step-3: 3rem;
  --space-1: 4px; --space-2: 8px; --space-3: 16px; --space-4: 32px;
}
/* any hardcoded 15px/9px/26px in review = flag it; it fragments the system */
```

```js
// "and/also" scope test — run on feature one-liners during planning
const needsSplit = /\b(and|also)\b/i.test(featureOneLiner);
// redundancy audit prompt: for each pair of elements with a similar job,
// force a verdict: merge | group | pull apart — "both, no reason" is banned
```

## AI-slop warning

Classic AI misapplications of this source: (1) epigraph-slop — bolting the Fukasawa/Ruskin quotes onto generic output as decoration while changing no decision; (2) minimal-washing — deleting visual richness and calling it "saying no" while functional redundancy stays (Grillo's rule targets what is foreign, not what is expressive); (3) consistency-as-uniformity — never detaching instances, producing interchangeable slop the source explicitly warns about (4.i, 5.c); (4) transgression without love — random gradients/glow/large-type "flips" shipped as the design, when flips are disposable probes; (5) skipping framing because agents don't present — the framing rules apply to PR descriptions, commit messages, and handoff notes exactly as to slides; (6) quoting "you are not your user" style maxims at people while shipping untested assumptions anyway. If a maxim changes nothing in the diff, it doesn't belong in the rationale.

## Relations

- desengs-web-interface-guidelines — supplies the hard numbers (contrast, targets, motion budgets) this source deliberately omits; run both, numbers first.
- desengs-taste — a theory of how taste forms; complements these maxims with the mechanism behind them.
- desengs-impeccable — operationalizes chapter 4's proofread list into a shipping-gate checklist.
- desengs-ui-ux-master — the umbrella canon; this skill is its judgment/tie-breaker layer.
- desengs-principles — principle-taxonomy sites for cross-checking; where they genericize, this source's chaptered imperatives and specific frames (third idea, 95 repetitions, 90% shortening) take precedence.
