---
name: desengs-ai-design-engineer-twilson
description: Use when deciding which UI work to delegate to AI versus keep human-judged, or when output is functionally fine but not great. Tim Wilson's gap audit — lose the speed race, win on what not to build, novel ideas, visual craft.
source: https://twilson.net/writing/ai-design-engineer
category: essay
---

# Is AI Going to Steal My Job? (desengs) — twilson on the AI design engineer

Source: https://twilson.net/writing/ai-design-engineer — Tim Wilson ("twilson", @actualTimWilson), design engineer at Dub, published 22 August 2026 on twilson.net. A first-person essay on what AI has already absorbed from the design-engineering job and which parts still need a human. No license stated. All quotes below are Wilson's, verbatim.

## What it is / Why it exists

Wilson opens from the practitioner's seat: "There's a gap between what AI can do and what I do for a living. Every few months it gets a little smaller." He checked for a floor and found none — "no sign of it stopping yet."

He defines his role loosely on purpose: "an engineer with an eye for design", later "An engineer with design taste." Engineer first; design responsibility accreted onto that base. The role lives on the boundary between the two disciplines.

The essay's answer to the title question is neither denial nor panic. It is an audit: stop competing where AI has already won (speed, volume, tedious detail), and re-anchor the job on the three gaps where AI still struggles — killing bad ideas, originating novel ones, and the visual judgment that separates good from great. The skill distills that audit into operating rules for an AI agent doing UI work, so the agent occupies the automatable layer completely while defending the human-judgment gates instead of eroding them.

## The core ideas

### 1. The premise: the gap shrinks on a schedule, so no assignment is permanent

The load-bearing fact is the slope, not the gap: every few months the gap gets smaller, with "no sign of it stopping yet." Any division of labor between human and AI written today is a snapshot, not a constitution.

Decision consequences:

- Never build a workflow that assumes a task is permanently human or permanently automated. Tag every handoff as "for now."
- Run a gap audit on a cadence (Wilson's implicit cadence is months, not years): list what AI now does acceptably that it didn't last quarter, delegate it, and re-identify what still fails without a human.
- For an agent: assume your own ceiling is rising. Work that "needs a human" today is work you should be attempting under supervision, because in a few months it will be expected of you.

### 2. Delegate the tedious layer completely — that is the win, not the threat

Wilson is unconflicted about AI's value: scaffolding a modal, grinding through detail work. "AI can spend a lot of time pouring over" the small stuff, "the things I just don't want to spend time on." Delegation frees him for more meaningful work.

Decision consequences:

- The tedious layer is not a negotiation. Scaffold the modal, wire every state (default, hover, focus, active, disabled, loading, empty, error, overflow), enumerate the edge cases — completely, in the first pass. A half-done tedious layer forces the human back into it and destroys the entire benefit.
- Never gold-plate the tedious layer either — the point is to vacate it fast, not to linger in it. Utility styling, no signature moves.
- Capacity freed by delegation is meant to flow to judgment work (premise-checking, ideation width, visual craft). If it flows to more generation instead, the role hollows out.

The essay's division of labor, as an operating table:

| Task | Execute fully (agent) | Gate (human judgment) |
|---|---|---|
| Modal scaffolding | structure, states, a11y wiring | whether the modal should exist |
| State coverage | hover/focus/disabled/loading/empty/error | which states carry brand weight |
| Ideation | 2–3 structural candidates + trade-offs | the origin and the pick |
| Visual detail | variants, spacing/type/motion options | the good-vs-great call |
| Boilerplate, edge cases | enumerate and handle all of them | which edges matter to the business |
| Ship decision | never | always |

### 3. Gap one: knowing what not to build

The sharpest behavioral rule in the essay. "AI agents are often eager to give you exactly what you ask for", while a human "can push back" and say "that's a bad idea." Eagerness — building exactly what was asked, at speed — is the failure mode, not a service.

Decision consequences for an agent:

- Before fulfilling any build request, run a premise check: does this screen/component deserve to exist? What breaks or duplicates it? What is the cheaper version that solves the same problem?
- Push back once, with reasons, when the request looks wrong (duplicates an existing pattern, fights the design system, adds state nobody uses). Then comply or escalate — the rule licenses a challenge, not a stonewall.
- The default agent posture of "comply immediately, build generously" is exactly what Wilson flags as the gap. Scope discipline is a feature the human is paying for.

### 4. Gap two: originating novel ideas

"AI can assist in the brainstorming process, but it's generally not the source of novel ideas. It can help generate ideas, but generally not the source of them." Generation for width, humans for the point of origin.

Decision consequences:

- Treat the idea's source as a required input: a brief, a reference, a stated POV. Generate variants of a supplied intent; never present self-originated concepts as the answer.
- Offer 2–3 structurally different directions (different layout family, different information hierarchy — not three shades of the same screen) and label them candidates, not recommendations.
- When asked "what should we build?", enumerate options and trade-offs, then hand the decision back. Deciding is the human's contribution to the loop.

### 5. Gap three: crafting visual experiences

Complex visuals still need "a special touch"; for demanding visual work, AI currently cannot bridge "the difference between good and great." Wilson does not claim AI can't produce visuals — it can't be trusted with the judgment about them.

Decision consequences:

- First-pass visual output is a draft by definition. Route it through explicit criteria before it ships: reference screenshots, named taste rules, side-by-side comparison against the exemplar.
- When presenting visual options, state explicitly which is "good" and which is "great" and what separates them (spacing rhythm, easing curve, type detailing, state coverage). If you cannot articulate the difference, you have not found it.
- Never ship unreviewed visual craft on surfaces that carry the product's identity (marketing pages, flagship flows, empty/error states). Internal admin chrome is the place to auto-ship.
- Make the good-vs-great call cheap for the human: put the two versions side by side, name the deltas, and recommend with reasons. A gate that receives an undifferentiated wall of options is a gate that gets skipped.

The craft pass itself needs criteria, or "great" stays an adjective. Walk at minimum: state coverage (all eight interactive states present and intentional), motion timing (UI transitions 120–200ms, larger surfaces toward 200–300ms, ease-out on entrances `cubic-bezier(0.22,1,0.36,1)`, ease-in on exits), spacing rhythm (one scale, 4 or 8px base, no orphan values), focus visibility (visible ring, 3:1 against adjacent colors), and the empty/error/loading states designed rather than defaulted. These numbers are canon operating rules for executing Wilson's craft gap, not his quotes — the essay stays at the judgment level.

### 6. The economics: good-enough is cheap, craft is the moat

The tension Wilson names: "businesses may not want to pay extra for craft and polish when good-enough software is so easy to generate." His counter: "As code becomes more of a commodity, craft and polish will be what set apart the products that are worth using from the slop."

Decision consequences:

- Treat polish as differentiation, not decoration. The craft pass (motion timing, easing, focus states, empty and error states, loading choreography) is the phase that decides whether the product reads as worthwhile or as generated slop.
- Tie every polish investment to a differentiator a business can see: retention-critical flow, brand surface, demo-visible moment. Unattached polish is the first thing cut when "good-enough" pressure arrives.
- Speed without the craft pass produces commodity output — you won the race Wilson says not to enter, and lost the thing he says to defend.

### 7. The adaptation loop: keep finding the gaps

Wilson's closing posture is iterative, not defensive: "I'll keep finding the gaps that need a human touch", with his focus shifting to what can't be automated. The job is a moving frontier, re-walked on a cadence.

The audit as a repeatable procedure: (1) list every task you did this period; (2) for each, ask whether current AI output would pass review unaided — yes, with supervision, or no; (3) move the "yes" tasks to full delegation, the "with supervision" tasks to draft-plus-review; (4) whatever remains is the job — invest there. The failure mode is skipping the audit and defending last year's frontier.

### 8. The meta-move: unaided thinking is part of the job

The essay is its own test case: "I write to figure out what I think." He wrote it unaided, and believes AI could not have produced it "in quite the same way." The specification phase — deciding what is wanted and why — is the one place delegation is self-defeating.

Decision consequence for an agent: when the human is still forming intent, assist the thinking (questions, options, constraints) — do not collapse it into a finished artifact before intent exists. Premature polish of an undecided idea forecloses the human's best contribution.

## When to use / When NOT to use

Use when:

- Deciding what UI work to hand to AI versus keep behind a human-judgment gate.
- Setting an agent's responsibilities and push-back license (the anti-eagerness rule).
- Output is functionally correct but reads as good-enough slop and needs a craft justification.
- A team debates whether polish survives AI-era cost pressure — cite the commodity/moat argument.
- Writing an agent's role charter: what it executes autonomously, where it must push back, where it must return decisions.
- Auditing your own division of labor on the quarterly-ish cadence the shrinking gap demands.

Do NOT use when:

- You need a component or effect library — this is a role and judgment essay, not an inventory (see library siblings).
- You read it as permission to skip generation — Wilson delegates the tedious layer enthusiastically; the gaps are about judgment, not labor.
- You read it as "AI can't do visuals" — it can't be trusted with the good-vs-great call unsupervised; that is a review gate, not a refusal.
- You need concrete de-slop mechanics (constraints-first loop, reference stealing) — Wilson gives the strategy; the tactics live in the siblings below.

## How to apply

1. Sort the current task list into two buckets: tedious layer (scaffolding, state wiring, edge enumeration, boilerplate) and judgment layer (premise, ideas, visual craft, ship decisions). Delegate/execute the tedious bucket fully; gate the judgment bucket.
2. On every build request, run the premise check before writing code: should this exist, does it duplicate a pattern, what is the cheaper version? Push back once, with reasons, if it fails — then comply or escalate.
3. Generate in width: 2–3 structurally different candidates per design question, labeled as candidates with trade-offs, decision returned to the human. Never one self-originated "answer."
4. Execute tedious work completely in pass one: all states (default, hover, focus, active, disabled, loading, empty, error), overflow behavior, keyboard paths. No lingering, no signature styling on utility surfaces.
5. Run an explicit craft pass after functional completeness: spacing rhythm, easing and timing, focus visibility, empty/error state design. State which option is good, which is great, and what separates them; cite the reference.
6. Keep the human gates: premise decisions, idea origin, good-vs-great visual calls, ship decisions. Your job is to make those gates cheap to operate, not to remove them.
7. Re-run the gap audit quarterly: what did you get measurably better at, what moves from gated to supervised, what still fails without the human. Update the buckets.

## AI-slop warning

How an AI agent typically misapplies this essay:

- Reads "eager agents" as license to refuse work. The rule is one reasoned push-back, then comply or escalate — an agent that stonewalls has replaced Wilson's failure mode with a worse one.
- Reads "not the source of novel ideas" as "produce weird novelty." Novelty without a supplied POV is just another flavor of averaged slop; the origin must come from the brief.
- Reads "AI can't do great visuals" as an excuse to skip visual iteration. Wilson assigns the tedious part of visual work to AI; only the good-vs-great judgment is gated. Skipping iteration guarantees the floor.
- Quotes the moat argument to justify unbounded gold-plating. Craft is defended as differentiation — attach it to visible value or it gets (correctly) cut under good-enough pressure.
- Treats any gap as permanent. The essay's own premise is that the gaps close "every few months" — a rule hardened into policy is stale the moment it's written.

## Relations

- `desengs-shedsgns-taste` — same diagnosis from the taste side: generation abundant, the human filter scarce. Adds the harder rule that the first output is a draft and the filter "is the whole game"; complements Wilson's softer, audit-based version of the same gate.
- `desengs-using-ai-as-de` — Krehel's accelerate-never-replace workflow operationalizes Wilson's delegation split: rules files, scaffolding-then-polish, deslop passes, human taste filter at the end.
- `desengs-rise-of-de` — the origin story of the role Wilson is defending; explains why the engineer-with-taste hybrid emerged at all, which is the asset the gap audit is trying to protect.
- `desengs-how-i-design-with-ai` — the constraints-first, de-slop design loop; supplies the concrete tactics for Wilson's third gap (visual craft) that the essay leaves at strategy level.
- `desengs-front-of-front-end` — names the exact layer (the user-facing front of the front end) where Wilson's visual-craft gap lives; its checklist is what the craft pass in step 5 should walk.
