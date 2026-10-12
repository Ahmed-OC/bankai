---
name: shedsgns-taste
description: Use when AI-generated UI works but feels impersonal, ships too early, or averages toward slop. Juliette's shedsgns essay: AI makes output abundant; taste — the human filter — decides what survives.
source: https://shedsgns.me/taste
category: essay
---

# On AI, Systems, Taste and the Human Filter — the taste essay for the AI era

Source: https://shedsgns.me/taste — Juliette, "On AI, systems, taste and the human filter", published 25 May 2026 on shedsgns.me. A personal essay on what AI does to creativity and where taste sits in the new pipeline. No license stated. It is the canon's justification for existing: if the human filter is the whole game, the filter must be written down as rules an agent can run.

## What it is / Why it exists

The essay starts from a new fact: one person can now turn a thought into writing, a visual, an interface, a prototype, a profitable product — work that recently needed a team and months. The cost side of that abundance: "in the process, creativity is getting polluted" (Juliette). Much of what ships functions correctly yet feels unfinished, because it "doesn't feel like a person made it."

Her diagnosis: generation is solved, filtering is not. Execution keeps getting easier, "but the eye is still rare." The scarce resource is no longer production capacity — it is the human filter, the ability to "think, choose, and see clearly." Hence the essay's closing law: "The human filter is the whole game."

For anyone building UI with AI, this inverts the workflow: the generator is cheap and infinite, so all value concentrates in the gate. An agent that only generates is the pollution; an agent that generates AND filters is the pipeline this canon encodes.

## The core ideas

### 1. The thesis: output is abundant, the filter is the bottleneck

AI amplifies whatever is already there. With curiosity and judgment you go further; without them, work only gets faster, not better. "AI doesn't give you depth or care or a point of view." Decision consequence: never ask AI for the point of view — supply the point of view (brief, references, constraints) and let AI give "shape to ideas that only exist in your head." Input without a POV converges to the mean; input with one gets executed at machine speed.

### 2. Speed is a trap: "Good enough is never good enough"

Change now outruns understanding — tools that were experimental six months ago are default workflows today. Speed empowers people with something to say (a Notes-app idea can become a working prototype in hours). It also invites stopping too early: shipping the first output of a coding agent before deciding whether it is what you actually wanted. Juliette's rule is verbatim: "Good enough is never good enough."

Two speeds, two outcomes:

- Something to say + speed = ideas that would have died in the gap between vision and execution now exist.
- Nothing to say + speed = averages shipped faster, "finished" work that was never actually decided.

Decision consequence: the first generated version is a draft by definition. It must pass a deliberate filter pass before it ships — no exceptions for deadlines, because speed is exactly what makes the exception dangerous.

### 3. Two ways to use AI: avoid thinking vs. think wider

The essay splits AI users into two camps:

- **Avoiders**: use AI to skip the uncomfortable parts of thinking — doubting less, researching less, skipping the phase where original ideas form. Output: faster averages.
- **Wideners**: use AI to think wider — test more directions, find connections, question assumptions. Output: more surface area for judgment to act on.

The difference is not tool choice; both camps prompt the same models. The difference is whether the uncomfortable phase (doubt, research, idea formation) is skipped or protected. Decision consequence for an agent: use generation for *width* (multiple structurally different directions, edge-case sweeps, alternative layouts), never as a substitute for *depth* (positioning, hierarchy of meaning, what the product is). Depth asks "why this and not that"; AI cannot answer it, only enumerate candidates for it.

Practical split for UI work:

| Task | Generator (AI) | Filter (human/taste rules) |
|---|---|---|
| Layout candidates | 3+ structural directions | pick + mutate the one with a POV |
| Copy | variants per voice | does it sound like a person made it |
| Motion | easing/timing options | which transition communicates the state change |
| Visual language | palette/type explorations | one atmosphere, end-to-end |
| Ship decision | never | always |

### 4. Systems and averaging: exactly how slop is made

Most people are trained to check what is safe and acceptable before acting. AI accelerates that averaging habit: follow the obvious reference, copy the average, apply no real filter. Juliette's one-line slop theory: "That's how AI slop is made." Slop is not a technology problem; it is an averaging behavior — choosing what is likely before what is right. Decision consequence: at least one deliberate divergence from the obvious/default reference per screen (layout family, type scale, motion signature). A screen that could belong to any product has failed the filter even if it is pixel-clean.

### 5. Taste defined: the ability to notice quality

Taste is not preference ("I like purple") but "the ability to notice quality", built over years through making, close looking, iteration, and care. In interfaces it lives in the details nobody explicitly asks for: "rhythm, hierarchy, atmosphere, restraint, clarity." Those five words are a working review checklist — each is checkable on any screen:

- **Rhythm**: spacing and repetition form a beat, not random gaps (consistent scale, e.g. an 8px-based step). Check: do vertical gaps between sibling elements follow one multiplier?
- **Hierarchy**: one dominant element per view; the eye lands where intended within seconds. Check: squint at the screen — does exactly one thing dominate?
- **Atmosphere**: color, texture and motion carry one mood end-to-end, not three moods per section. Check: name the mood in three words; does every section satisfy them?
- **Restraint**: everything that could be removed without loss was removed; ornament is not motivation. Check: delete one effect — did anything meaningful break? If not, it was decoration.
- **Clarity**: a first-time user can name what the screen does and what to do next. Check: is the primary action identifiable without reading paragraphs?

Execution is commoditizing; the eye behind these five checks is not. "But the eye is still rare."

### 6. Division of labor: LLMs as extensions of thinking, decisions stay human

The designers who win, per the essay, build their own products, treat LLMs "as extensions of their thinking," and keep judgment for themselves — the tools speed you up, "but the decisions still have to be yours." The shrinking distance between idea and product (no team, no budget, no permission needed) "changes responsibility": when anyone can ship, being able to choose well is the whole competitive position. The goal state for any piece of work: hold and shape it until only its maker could have made it. Creativity is not disappearing — it is simply easier to see who is genuinely choosing it, and lasting work comes from those who do.

## What changes day-to-day for an AI building UI

The essay's filter is human, but an agent must operationalize it or it defaults to the averaging behavior in idea 4:

1. The agent is the generator in this model, never the taste-holder. It encodes taste as explicit, checkable rules (this canon) and runs them as a gate.
2. First output is never the deliverable. The agent presents candidates plus its own filter verdicts, and marks what it rejected.
3. Generation targets width: structurally different directions, not variations of one default.
4. Every human rejection is converted into a rule and added to the filter file — that loop is "keeping the human filter alive" (Juliette) in practice. The rejection log IS the taste system, compounding each cycle.
5. The shrinking distance between idea and product changes responsibility for the agent too: when shipping is nearly free, the only quality control left is the gate. An agent without a written gate is, by the essay's definition, a slop machine with good manners.

## When to use / When NOT to use

Use when:
- Reviewing or gating any AI-generated screen before ship (the filter pass).
- Output "works" but feels generic, averaged, or interchangeable with any other product.
- Deciding how to split work between agent and human on a UI task.
- Setting up or extending an agent's rules file with a quality gate.
- A team debates "should we use AI for this?" — this essay reframes it as "what is our filter?"

Not for:
- Choosing product strategy or what to build (the essay governs how to filter execution, not what deserves to exist).
- Deep accessibility or performance audits — use the dedicated canon skills; this gate is about authored quality.
- Blanket AI avoidance: the author uses AI daily. The enemy is outsourced thinking, not the tool.

## How to apply (numbered checklist)

1. Before generating, write one line of intent: the POV only this product has (audience, mood, the one thing it must feel like). No POV → do not generate yet; derive it from the brief or brand, or ask.
2. Generate width: at least 3 directions that differ structurally (different layout family, density, type treatment) — not 3 reskins of the same default.
3. Tag output v1 as draft. Nothing ships without a filter pass; "good enough is never good enough."
4. Run the five checks — rhythm, hierarchy, atmosphere, restraint, clarity — one verdict line each. Any unresolved "?" means iterate, not ship.
5. Run the average check: name a product this screen could NOT belong to. If you cannot name one, mutate layout, type, or motion until you can.
6. Run the ownership test: point to the detail only this maker could have made. No such detail = the screen is interchangeable = iterate.
7. Log every rejection with its reason; promote recurring rejections into permanent rules in the filter file. The filter must grow, or it decays into the average.
8. Timebox the loop, not the filter. If velocity pressure lands anywhere, it lands on generating more candidates — never on skipping the gate.

## The mechanism: a written filter gate

The essay's human filter, made executable as a gate file an agent must pass before marking any screen done (plain markdown, stack-neutral):

```markdown
# human-filter.md — run before marking any generated screen done

intent: <one line — the POV only this product has>
first-output rule: v1 is a draft; ship only after this gate passes

five checks (one verdict line each: pass | fail | why):
- rhythm:      spacing follows one scale; repetition reads as a beat
- hierarchy:   one dominant element; eye lands where intended
- atmosphere:  color/motion/mood consistent end-to-end
- restraint:   nothing removable survives; every effect earns its place
- clarity:     a first-time user can say what this does and what's next

average check: name a product this screen could NOT belong to.
  if you cannot, mutate layout/type/motion and re-run
ownership: the detail only we could have made: <name it>

rejected: <what was killed and why>  -> promote repeats to this file
```

Copy this gate next to the code rules; the rules decide what gets generated, this gate decides what survives.

## AI-slop warning

How AI typically misapplies this essay:

- **Vocabulary instead of filtering.** An agent reads "taste matters" and starts writing "refined", "elevated", "crafted" into PR descriptions while shipping the unchanged default layout. Taste here is a gate with verdicts, not adjectives. If the five checks produce no verdict lines, the gate did not run.
- **Width faked by cloning.** Presenting three near-identical variants of the default as "options." Width means structural difference (layout family, density, motion), or it is the average wearing a costume.
- **First-output shipping.** The most common failure the essay names: the first agent output ships because it functions. Functioning is the entry condition, not the exit condition.
- **Using the essay to ban AI.** The author's position is daily use with the thinking kept in-house. Banning the tool misses the point; the filter, not the abstinence, is the defense.

## Relations

- **taste** — the executable layer this essay justifies. The essay supplies the why (the human filter is the bottleneck); taste supplies the what: banned AI-default patterns, the variance/motion/density dials, the pre-flight check. Where this essay is qualitative, taste fixes the numbers.
- **concept-of-taste** — the theory of the same faculty. Salaja argues taste is trainable pattern discrimination, not instinct; Juliette adds the AI-era frame: the faculty now gates machine output, not just your own. Together: trainable (Salaja) and now load-bearing for AI pipelines (Juliette).
- **using-ai-as-de** — the operational workflow for this essay's division of labor. Krehel's "accelerate, never replace" and "the user is in charge" are the same law as "the decisions still have to be yours," with concrete mechanics: rules files before prompting, disposable concept prototypes, deslop passes. Read this essay for the philosophy, that one for the daily practice.
