---
name: desengs-code-source-of-truth
description: Use when deciding where design truth lives (mockups vs code) or setting up a design-to-ship workflow. Code is the canonical artifact; design files become sketches that import from it.
source: https://www.tonyward.dev/articles/code-as-the-source-of-truth
category: essay
---

# Code as the Source of Truth (desengs) — design in the medium that ships

Source: https://www.tonyward.dev/articles/code-as-the-source-of-truth — Tony Ward, personal design-engineering blog, published 2026-09-15. Short essay (~600 words) arguing that AI tooling settles the old "Figma or code?" debate in favor of code. No license stated; site marks all content human-written.

## What it is / Why it exists

Thesis: code — not a design file — is the source of truth for product UI, and AI tooling is what finally makes that operable for a combined design + engineering team.
In the author's words: "code being the source of truth makes it easier than ever for design and engineering to be a REAL, single team."

Why the old model broke — each failure is a decision to avoid repeating:

- The debate was settled politically, not technically: "One side would 'win' the debate, then waterfall everything to the other skillset."
  Whichever artifact won, work still crossed a handoff wall. The wall, not the tool choice, was the defect.
- Artifacts drift: "features and components would get out of date, because design and engineering weren't talking as much
  as they should have been, people got busy, work wasn't properly tracked". Exactly one representation of the UI is
  guaranteed current — the one that ships. Everything else rots by default.
- Late feedback is wasted delivery time: designs of new components would be "inaccessible during the handoff stage, or
  have other technical challenges that weren't brought up until engineering got a look, and now you've wasted precious
  delivery time". A static mockup cannot be keyboard-navigated, audited by a screen reader, or reflowed at 375px; code can.
  Problems that only exist in the build medium are only found in the build medium — so review must happen there.
- The author confesses the wrong direction himself: "in previous work, I was syncing variables from Figma into code" —
  design tool as master, code as mirror. The fix is to flip the arrow: code emits tokens, design tools consume them. Never two-way sync.

The cultural frame: the goal is not designers-become-engineers or a tool takeover, but "people who ship things" — one team, one artifact, expert review at every step.

## The core ideas

1. **Code is the only artifact that *is* the product.**
   - Frames, mockups, and specs are commentary on it. Commentary imports from the thing; the thing never imports from commentary.
   - Practical ban: never hand-copy a hex, spacing step, radius, or easing curve out of a mockup — read it from the token layer in the repo.

2. **The fidelity gap is structural, not effort-based.**
   - Mockups fake layout at one viewport, fake text at one string length, and fake states (hover/focus/loading/error/empty) by omission.
   - Code is the only medium where the real constraints — wrap, overflow, zoom, 200% text size, `prefers-reduced-motion`, input method — are enforceable rather than approximated.
   - Deciding fidelity questions anywhere other than code means deciding them twice: once in the mockup, again when reality disagrees.

3. **Handoff is the waste, not the ritual around it.**
   - The serial model "doesn't make sense anymore... It's ridiculously inefficient."
   - Replace it with bidirectional bridging: the designer prototypes "with real, coded components" and hands off to the engineering SME "to make them production-ready";
     the engineer "push[es] things into Figma directly, where they may not have a lot of experience", and the design SME "tweak[s] things to their high standards".
   - Same artifact chain, no wall — feedback arrives at the moment of cheapest change.

4. **The enabler is AI tooling, used to bridge — not replace.**
   - Hybrid actors are emerging: "design engineers" ("design technologists", or simply "builders") — "people leveraging AI tooling to bridge their skillset to ship".
   - The essay's explicit boundary: teams "bridge their skills — not replace each other. Lift each other up. Complement each other's skillsets and allow for growth opportunities."
   - Any workflow where AI output replaces expert judgment rather than extending it is out of bounds.

5. **The guardrail is a subject-matter expert at every step.**
   - "You always have a subject-matter expert in the loop at every step of the way, verifying the output and reasoning about whether it's 'good'. Just like reviewing peers' work."
   - The reviewer's veto is part of the loop: "Part of that is saying 'no' or deciding not to ship anything at all when an idea doesn't make sense."
   - Shipping nothing is a valid outcome; it keeps the standard intact.

6. **The anti-slop standard is authorship-agnostic.**
   - "You don't ship slop — you ship code and designs you'd stand behind, no matter who the author was."
   - AI authorship changes nothing about the bar; it raises output volume, which makes the verification gate more necessary, not less.
   - The essay opens by preempting the objection — "aren't you shipping slop then?" — and answers "No." *under these conditions*.

7. **Iteration speed compounds in the shipping medium.**
   - Every cycle spent adjusting a mockup must be re-spent translating it; a change made in code is finished when it's made.
   - AI widens this gap: prompting against real components produces reviewable, runnable candidates; prompting against mockups produces more commentary to drift.

8. **The endgame is dissolving the titles.**
   - "Engineers, teach your designers coding patterns and practices. Designers, teach your engineers design and Figma practices."
   - Over time "the 'title lines' begin to blur. Then the team becomes people who ship things."
   - Optimize the workflow for shipping, not for role hygiene.

### What this means for an AI agent building UI

An agent's source of truth is inherently code — it cannot run a design file, and it can only interpret pixels, not inherit them. Make that a feature:

- Treat any attached screenshot or frame as a *sketch with stated intent*, never as pixel law.
- Extract the intent (hierarchy, rhythm, mood, density), then implement with canonical tokens. Re-open the mockup for reference, never for values.
- Ground every visual decision in the running artifact: computed styles, DOM structure, real viewport widths — not descriptions of them.
- The SME-in-the-loop rule applies to you: your output is the "peer's work" awaiting expert review.
- Surface what you could not verify (motion feel, brand fit, copy tone, cultural register) instead of silently deciding it.
- When a request contradicts the token layer, flag it and change the token centrally — do not hardcode an exception, which reintroduces the drift this model exists to kill.
- Never present "an expert will review it later" as a reason to defer all judgment; bring a defensible draft, and expect "change" or "don't ship" as legitimate review outcomes.

## When to use / When NOT to use

Use when:
- Building or evolving product UI that ships as code: web apps, design systems, marketing sites, internal tools.
- Mockup-to-reality drift, late accessibility findings, or handoff rework are measurably costing delivery (the essay's exact failure symptoms).
- Designers and engineers — human or AI — collaborate through AI tooling and need one artifact to converge on.
- Maintaining a design system where tokens, components, and docs must stay mutually consistent.
- Onboarding a new contributor (human or agent): the codebase is the specification; there is no second document to contradict it.

Do NOT use when:
- The deliverable is not code: brand marks, print, illustration, video. The shipping medium there *is* the design tool; invert the rule.
- Early divergent exploration where sketching twenty throwaway frames beats booting a component. The essay keeps the design tool as
  valid scratch space — "let an engineer push things into Figma directly" — it demotes the tool from master to instrument ("design tool as sketch"), it does not ban it.
- No expert review is available. Code-as-truth without the SME gate is exactly the "aren't you shipping slop then?" failure — in that situation, do not ship.
- Compliance regimes demand a frozen, signed-off specification before implementation. Code stays the truth of record for rendering;
  the spec becomes an additional audit artifact, not a competing master.

## How to apply

1. Declare code canonical in writing (README / contributing guide): the repo's token layer and components *are* the design system; design files are views of it. State the sync direction: code → design tool, one-way.
2. Define tokens once, in code, consumed everywhere:

   ```css
   /* tokens.css — the canonical design source.
      Export direction is one-way: code → tokens.json → design-tool library.
      Never sync design-tool variables back into code. */
   :root {
     --color-text-primary: oklch(0.25 0.02 260);
     --color-surface: oklch(0.99 0.005 260);
     --space-1: 4px;  --space-2: 8px;  --space-3: 16px;
     --radius-md: 8px;
     --ease-out-expo: cubic-bezier(0.22, 1, 0.36, 1);
   }
   ```

   Raw hex/px/radius values in component code, where a token exists, are lint errors — drift prevention must be mechanical, not memetic.
3. Prototype new UI as real components in the real stack from day one: props, data states (loading/error/empty/long strings),
   interactive states (hover/focus/disabled), responsive behavior at 375 / 768 / 1440. Never produce a static mock of anything that will ship.
4. Bridge in both directions:
   - Designer → engineer: working coded prototype in, production-hardening out (error boundaries, loading semantics, markup semantics).
   - Engineer → designer: structural draft in the design tool in, refined visual standard out.
   - No artifact crosses a wall without a person on the other side who can change it.
5. Do visual review in the medium: staging or a running build, real browsers, real data, plus a keyboard-only pass, a screen-reader pass, and `prefers-reduced-motion` enabled. Verify the running UI consumes canonical tokens rather than hardcodes:

   ```js
   // run in the console against the deployed page
   const cs = getComputedStyle(document.body);
   console.log(cs.getPropertyValue('--space-2'), cs.getPropertyValue('--radius-md'));
   // unexpected empties or literal values ⇒ token drift; fix at the source, not per-component
   ```

6. Automate every check code can express — contrast (4.5:1 body text, 3:1 large text and UI boundaries), visible focus, tap-target size,
   token lint, motion-safety — so drift is caught by the pipeline at PR time, not by memory at QA time. This is the mechanical translation of "verifying the output".
7. Enforce the SME gate on every AI-assisted artifact before merge, exactly like peer review:
   - Allowed outcomes: "approve", "change", "don't ship".
   - "No author was available for review" is not an outcome; it is a blocked PR.
   - The gate applies per step (prototype, harden, refine), not once at the end — "at every step of the way".
8. Pair and teach continuously: engineers teach coding patterns and practices, designers teach design critique and tooling.
   Review capacity is the bottleneck of the whole model — invest in it deliberately ("Lift each other up").
9. Measure the model by its symptoms going away: handoff rework hours, accessibility findings discovered after build,
   count of stale components, mockup-vs-production visual diffs. If those aren't falling, the workflow is theater.

## AI-slop warning

How AI typically misapplies this principle:

- Reading "code is the source of truth" as "skip design; prompt-generate UI and ship". That is the slop question the essay answers
  with "No." — and the No is conditional on the SME-in-the-loop gate. Velocity without verification ships slop with extra steps,
  and "code-first" becomes its alibi.
- Pixel-cloning an attached mockup, hardcoded literals and all. This rebuilds the drift the essay kills — the mockup becomes
  truth-by-proxy and the token layer rots underneath it.
- Regenerating code from updated mockups each cycle — two-way sync by other means. One direction only: code → design tool.
- Using "an expert will review it later" to defer every judgment (spacing rhythm, easing, copy tone). The reviewer verifies
  "whether it's 'good'" — review presupposes a defensible draft, not a lottery ticket.
- Smoothing over the veto: treating "no" or "don't ship" as friction to be optimized away. The right to block bad work is the
  mechanism that keeps AI acceleration from becoming slop acceleration.
- Hard rule: if nothing expert has reviewed the artifact, it does not ship — "you ship code and designs you'd stand behind, no matter who the author was."

## Relations

- **desengs-front-of-front-end** — names the role that lives at exactly this seam (between design intent and built UI); this essay defines the artifact (code) that role owns and defends, and the SME review that role performs.
- **desengs-using-ai-as-de** — the tooling premise: how AI lets one person bridge design and engineering skills. This skill adds what the bridge should carry (token-grounded code, both directions) and where the veto sits.
- **desengs-tokens-generator** — the concrete mechanism for the "single source": generating the canonical token layer in code that design tools then import; implements the flipped arrow this essay prescribes against "syncing variables from Figma into code".
- **desengs-ds-checklist** — supplies the verification gates (a11y, states, tokens) the SME-in-the-loop reviewer runs against the running build; operationalizes "verifying the output" beyond opinion.
