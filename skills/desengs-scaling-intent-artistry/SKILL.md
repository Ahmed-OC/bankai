---
name: desengs-scaling-intent-artistry
description: Use when AI builds UI fast and output drifts generic ("zombie UI"). Dill's 4-part playbook - encode intent, hold one quality bar, edit post-build, protect the strange.
source: https://www.youtube.com/watch?v=GLvFTMtw4Jk; https://usegavel.com/talks/katie-dill-ai-design-quality; https://hraness.com/reading/raise-the-ceiling-how-to-scale-intent-quality-and-artistry
category: essay
---

# Scaling Intent, Quality, and Artistry with AI (desengs) — zombie UI is the default output of the AI build boom; intent, editors, and strangeness are the countermeasures

Source: https://www.youtube.com/watch?v=GLvFTMtw4Jk — Katie Dill, Head of Design at Stripe (previously led experience design at Airbnb), keynote "Raise the ceiling: how to scale intent, quality, and artistry with AI," Lenny & Friends Summit, September 2026, ~21 minutes, published on Lenny's Podcast YouTube channel. Standard YouTube license.
> Note: full video transcript not directly retrievable; distilled from multiple independent detailed summaries of the talk (Gavel, hraness, BigGo). Quotes are as reported by those summaries.

## What it is / Why it exists

- A ~21-minute design-leadership keynote with an engineering consequence: AI collapsed the cost of building, which moves the bottleneck from execution to intent, quality judgment, and artistry.
- If those don't scale with output volume, the result is "zombie UI" — her term for interfaces that are "monotonous, vacant or uncared for": they look like software, echo generic patterns, and show no point of view.
- The controlling analogy: the post-WWII building boom copied the surface of 1920s modernism (Le Corbusier villas, Bauhaus geometry, bare surfaces) without its intent. The founders were intentional; the copiers were not.
- Result of that boom: "zombie buildings all over the place" — bland replacements for banks that once signaled "trust, reliability and security." Nothing differentiates them or shows care for users, context, or brand. AI-built software is that boom's second run.
- The two-sided verdict that frames everything after it:
  - "AI can help us raise the ceiling, not just the floor."
  - "Yes, AI can help us manufacture monotony, but it is also the greatest creative catalyst we've ever had."
- Same tool in both sentences. The variable is whether intent was supplied before generation.

## The core ideas

### The three watch points (why AI output degrades)

1. **Probabilistic sameness.**
   - Mechanism: "LLMs are really good at telling you the most probable answer" — what has already been popular, not what is right for this brand and these users.
   - Consequence: convergence. Every output drifts toward the current market average.
   - Her example: a Korean barbecue restaurant website so generic the audience guessed "software company."
2. **The temptation of done.**
   - Mechanism: output looks finished one prompt in. Her confession: her 90-second microwave burrito is nearly inedible, but its speed makes her overlook the flaws.
   - Consequence: shipping polished-looking work that solves nothing and differentiates nothing.
3. **Disposability.**
   - Mechanism: work is so quick to make that it "often feels disposable and, worse, is treated that way."
   - Consequence: ownership dissolves — nobody asks who maintains this or who is accountable for each pixel.

Combined output of the three: zombie UI. Since people spend half their waking lives on screens, software that feels cared for is the stake, not a nicety.

### The four-part playbook

**1. Have a point of view — before the model picks one for you.**
- "If you don't [have a point of view], AI will give it for you," and it will be the probable, generic one.
- A point of view = who the product is for + what they care about + what the brand stands for. That statement becomes the standard all output is judged against.
- Dill has long defined design as intent applied to who the thing is for; the POV is that definition made explicit before any build.
- This matters more now because building is distributed across people and agents. When everyone owns it, nobody does, and every unpinned decision drifts to the model's default.
- At Stripe: optimism, encoded concretely in colors, writing, and product choices for entrepreneurs — not a mood board, a decision filter.
- One quality bar regardless of provenance: "It doesn't matter to the users how it was made. It matters to them if it's good or not."
- The bar in practice: a partner asked what the quality standard should be for AI-made work; the crit that followed (on an AI-assisted ad) produced 17 fixes — softer edges, smaller bubbles. The team since internalized it as a verb: "Pepsi bubbling," meaning meticulous craft.
- Depth target: one level deeper than the customer can see. Stop there — perfection is not the goal.
- Taste is trainable: get good at noticing — needs beyond what users say, and what the world signals as good, great, or mediocre.

**2. Encode your standards into the machine.**
- Situation: screens now ship with no designer in the room; agents fix things overnight; generative UI renders in real time. The design system must make the calls a designer used to make.
- The shift: "the old system scaled consistency, but the new system needs to scale intent." The object of design is now the system itself.
- Her model is Gutenberg: beyond inventing the press, he cut ~290 unique sorts (versus a 52-letter alphabet) — ligatures, abbreviations, varied widths — so machine-set type still felt handmade and justification avoided "rivers and lakes of white space." An extensible system, opinionated enough to preserve craft while scaling it.
- What failed at Stripe: an MCP server over the design docs. Three people typed the same prompt and got three different results. Documents dumped into context are too unspecific and rot the context.
- What worked: a command-line tool built on the design system that
  - meets builders where they already work;
  - serves the right document at the right step (avoiding context rot);
  - carries full templates and flows, not just components, so the system knows how the product should behave.
- Result: the AI becomes "far more obedient."
- The limit, quoting Christopher Alexander: "a system can satisfy every rule and still be dead." Systems scale intent; they do not replace judgment.

**3. Refuse to confuse done with good.**
- Old world: 20 ideas, staff 1 — pruning ran throughout, before the build. Now 20 ideas can be built in a week.
- Building everything is great for reacting to real products, but it relocates the quality filter to post-build, "when it is a lot harder to say no."
- "We have to unlearn that built means done, and that done means good."
- Mechanism: a named editor. Someone who uses the product as a customer would, end to end, and asks not yes/no but "is this fully formed?"
- The editor's three questions: does it solve the problem, fit the user's mental model, cohere across the journey? The editor takes accountability for every pixel.
- Criteria from art (citing Nabil Qureshi): unexpected details, deeper meaning, unifying themes.
- Why slop offends, in one line: "The cup is green, but may as well have been blue" — a technically valid choice with no reason behind it.
- The iteration budget is real: the event's opening animation took 56 rounds with AI before it gained realism and perceptible care — complexity the maker might never have attempted by hand. It felt done at round 1; it was good at round 56.

**4. Unleash creativity and artistry — protect the strange.**
- Chat windows, charts, and command lines are not the epitome of interaction: "It is time to invent new interfaces. It is time to invent new aesthetics."
- Analogies: multi-touch enabled new interactions; the synthesizer created new sounds instead of a cheaper orchestra. Best practices are unwritten.
- Improve inputs: feed specific brand direction and standards material — never "a website for my Korean barbecue."
- Stress outputs: interrogate the first polished render; do not accept the burrito dilemma.
- Adversarial review: set rival agents to critique the output against the point of view.
- Human-machine split: Stripe's *Built to Grow* cover came from a human marbler's iterations, with AI fine-tuning colors and lines. AI scales human judgment; it does not replace the marbler.
- The cultural ask: leads give people room to explore. "Protect the strange." AI lowers the cost to create — spend some of that savings on making something truly special.
- Used only to speed up existing output, you miss the most interesting part.

### The closing contrast

- Against post-war modernism she sets Gothic architecture, citing John Ruskin (1850): no two columns alike, each showing the hand and mind of its maker. Anti-zombie by construction — variation from intent, not negligence.
- What actually impresses users: solved problems, clever anticipated details, brand character — not "a 30-minute Three.js/Blender animation."
- The choice she leaves the audience: avoid digital zombie buildings and "make this a creative renaissance."

## Encoding intent: mechanisms behind her rules (agent-side port)

These translate her rules into structures an agent can actually run. They are ports of her playbook, not her verbatim prescriptions.

- **The intent block.** A POV file consumed before any generation, answering exactly her three questions:
  ```
  intent:
    who: <specific audience, not "everyone">
    they_care: <2-3 outcomes in their words>
    stance: <what the brand believes; the filter for every choice>
    anti_patterns: <what this product must never resemble — name the generic look>
  ```
  If any field is empty, generation is blocked (playbook rule 1).
- **The same-prompt test.** Run one intent through the pipeline three times. Three visibly different results means the standards are documents, not encoding — the exact failure of Stripe's MCP-over-docs attempt. Fix by moving constraints from prose into the executable path.
- **Right doc at the right step.** Do not load the whole design system into context. Serve the layout rules when laying out, the motion rules when animating, the copy rules when writing. Context rot is a design bug.
- **Whole-flow templates.** Carry flows (empty state -> first run -> error -> success) in the system, not just components. A component library scales consistency; flows scale intent.
- **The green-cup audit.** Before declaring done, list every color, copy line, and motion decision with its reason tied to the intent block. Any decision whose reason is "default" or "looks fine" gets redone. "The cup is green, but may as well have been blue" is the failure signature.
- **The adversarial pass.** A second agent, given only the intent block, attacks the output: where does this look like the market average? where is it missing unexpected details? Ship only after it fails to find slop.

## When to use / When NOT to use

Use when:
- Building UI through AI agents, generators, or vibe-coding at any volume — the three watch points apply immediately.
- A design system is consumed by agents (docs-to-agent pipelines, MCP/CLI tooling, generative UI).
- Defining quality gates or review roles for AI-made work, or deciding whether to ship something that "feels done."
- Output has started converging with everything else in the market.
- Writing the brief/spec that precedes AI generation (the POV is the highest-leverage input).

Do NOT use as:
- A license for spectacle. Dill explicitly rules out technical showpieces (the 30-minute Three.js/Blender animation) as things that impress users.
- A perfectionism mandate. The bar is one level deeper than the customer can see — then stop; sweating every detail forever means never shipping.
- Human-out-of-loop dogma. Humans stay on judgment (point of view, editor), machines on production.
- A total ban on shipping early. Counterpoint she engaged: Jenny Wen (head of design at Claude) ships early under a research-preview label and fixes in public fast; Dill places the check before release. Both keep exactly one accountable person — that is the load-bearing part.

## How to apply (numbered checklist — for an AI agent building UI)

1. Before generating, demand a point of view: who is this for, what do they care about, what is the brand's stance. If absent, ask. Do not fill the gap with the statistically probable design.
2. Treat missing intent as a blocker, not a trigger for a default template. A Korean-BBQ-as-SaaS site is a failure state, not a starting point.
3. Consume the design system at the step where it applies — not as one dumped document (the MCP lesson: same prompt, three results = failed encoding).
4. Ship whole flows from templates the system carries, not isolated components. The system must know how the product behaves, not just what its buttons look like.
5. Hold one quality bar regardless of how the work was made. The user never learns it was AI-generated; run the same crit you would run on human work.
6. Go exactly one level deeper than the user can see — tighten alignment, focus states, easing, empty states — then stop. Perfection is not the goal.
7. Treat the first polished output as round 1 of editing, not the finish. Budget real iterations; a 4-second animation can legitimately take 50+ rounds (hers took 56).
8. Run an end-to-end editor pass before shipping: use the flow as a customer would. Ask "is this fully formed?" — problem solved, mental model fit, journey coherent.
9. Delete green-cup choices: every color, copy line, and motion decision needs a stated reason tied to the point of view. If the alternative would have been equally fine, redo the choice.
10. Keep exactly one strange thing: preserve a distinctive, brand-true oddity that an optimizer would delete. Strange means intentional, not random.
11. Feed generation with your own source material — brand references, prior work, standards docs — never a one-line generic prompt.
12. Spawn an adversarial agent to critique the output against the point of view before declaring it done.
13. Answer "who maintains this?" for every generated surface. Name the owner, or don't ship it. Disposability is the third watch point.

## AI-slop warning

- Misuse 1 — spectacle: agents cite "raise the ceiling" to justify 3D scenes, particles, long intro animations. Dill's own test: users are impressed by solved problems and anticipated details, not a 30-minute Three.js/Blender animation.
- Misuse 2 — random weirdness: "protect the strange" read as license for arbitrary quirks. The Gothic columns differ because each shows its maker's intent, not because of dice. Strange without a point of view is noise.
- Misuse 3 — consistency theater: shipping an MCP wrapper over docs and calling it intent encoded. If the same prompt yields three different results, you have scaled documents, not intent. Encode into an executable, opinionated path (CLI over the design system, whole-flow templates).
- Misuse 4 — iteration churn: 56 rounds worked because a named editor with a point of view judged each one. Rounds without an editor are motion, not quality.
- Misuse 5 — discounting AI work: lowering the bar because "the AI made it in five minutes" violates the provenance rule. Users grade the output, never the process.
- The reflexive trap: an agent that summarizes this talk into a sleek generic checklist, then builds the same probable UI as before, is the watch points operating as described. The talk only counts if it changes the next build decision.

## Relations

- `desengs-anatomy-ai-input` — this skill establishes *why* intent must precede generation; that one supplies the input structure (specs, examples, constraints) that carries it.
- `desengs-code-source-of-truth` — Dill's CLI-over-docs move is the intent-scaling version of the same argument: the system lives in code the agent executes, not in documents it reads.
- `desengs-agentation` — the overnight-agent world where screens ship with no designer in the room; that skill covers the mechanics, this one the failure mode (zombie UI) and the quality gates.
- `desengs-concept-of-taste` — extends Dill's "develop taste by getting good at noticing" with working definitions for judging output beyond personal preference.
- `desengs-taste` — complements the point-of-view rule: a stated POV is taste made explicit and transferable to a machine.
