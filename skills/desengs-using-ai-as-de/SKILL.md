---
name: desengs-using-ai-as-de
description: Use when collaborating with AI on UI work or setting up agent rules. Distills Jakub Krehel's accelerate-never-replace workflow: rules files, scaffolding-then-polish, deslop passes, and the human taste filter.
source: https://jakub.kr/work/using-ai-as-a-design-engineer
category: essay
---

# Using AI as a Design Engineer (desengs) — the AI workflow that keeps taste

Source: https://jakub.kr/work/using-ai-as-a-design-engineer — Jakub Krehel, design engineer at Interfere (jakub.kr); first-person essay on his daily AI workflow. No license stated. Tool names below are his reported choices; every prescription is ported to a stack-neutral mechanism.

## What it is / Why it exists

Krehel's role is "all about craft, thoughtfulness and creativity" — and "by definition AI is not particularly great at those things, at least for now." Yet AI transformed his daily work, because he aims it at the one bottleneck craft actually has: iteration speed. Design engineering is trial and error; he "often spend[s] hours trying to find the 'this feels right' moment." AI compresses that loop — "instead of spending hours on a concept that I'm unsure of, I try that concept out in a matter of minutes, and throw it away if it doesn't feel right."

The thesis in his words: "I don't use AI to come up with ideas or to replace my own thinking. I use it to *accelerate* my workflow." This skill is the canon's model for how an AI agent should collaborate on UI work: fast execution, zero creative authority, output always passes through a human taste filter.

## The core ideas

### Division of labor — the whole skill in one table

| Task | Owner | His reason |
|---|---|---|
| Ideas, creative direction | Human | AI is bad at craft/creativity "at least for now" |
| Concept prototypes | AI executes, human judges feel | hours → minutes, disposable |
| UI scaffolding from design specs | AI | mechanical translation when rules are set up well |
| Tweaking, polish, animation | Human | the "this feels right" pass is the product |
| Rules authorship | Human | copy rules only after understanding them |
| Tedious migrations, dedup | AI | "~5000 fewer lines of code but the same functionality" |
| Understanding every diff | Human | "Don't just blindly follow whatever the agent gives you" |
| Code review (extra layer) | AI | "not crucial by any means, but... always nice" |

Non-negotiable frame: "AI works best if the user is in charge and not the other way around."

### Rules files come before any prompting

The first thing he does on a project is write a set of rules for the codebase — before asking the agent for anything. Mechanism (port to whatever format your agent reads):

```markdown
# animation-performance.md — one concern per file, short, references other files

- Animate only `transform` and `opacity`; never animate layout properties.
- `will-change` only on elements currently animating; remove afterwards.
- Easings/durations come from `tokens.md`. No ad-hoc cubic-beziers.
- Anything beyond simple transitions: read `motion.md` first.
```

- His actual rule set for his own site: animation performance, React Compiler constraints, "using the `cn` util instead of template literals", and design-system usage. Different projects get different rule sets.
- Keep rules "short and to the point, often referencing other files too" — a rule the agent can't scan in seconds is a rule it won't follow.
- They pay for themselves because "I don't have to describe these things every time I talk to an agent" — the rules ARE the context, injected every session.
- Copying rules blindly is a known failure: "If you're going to copy rules, I'd recommend trying to understand what they actually do first."
- His external rule sources map to canon skills: ui-skills (→ desengs-ui-skills) and the Vercel Web Interface Guidelines; motion and Tailwind rule sets exist behind paid plans — treat those as the same mechanism, different vendors.

### Assume zero context, every conversation

"Humans can remember a lot of context across many different conversations. When talking to AI we sometimes assume it thinks the same way, but it doesn't." So: "when I start a conversation with an agent, I always assume it has *no context*, and that tends to lead to the best results." Practically: restate the feature, the files, the rules-file names in the first prompt. Never rely on yesterday's chat.

### Commands: deslop and rule-checked review

He runs `/deslop` (shared by Eric Zakariasson of Cursor) — a pass that removes AI slop from the current branch's diff against main:

```text
Check the diff against main, and remove all AI generated slop introduced in
this branch. This includes:
- Extra comments that a human wouldn't add or is inconsistent with the file
- Extra defensive checks or try/catch blocks abnormal for that area
  (especially on trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file
Report at the end with only a 1-3 sentence summary of what you changed.
```

That checklist is the canonical slop marker list — it defines "generic AI output" as: comments a human wouldn't write, defensive code where none is warranted, `any`-casts, style drift from the file. His team also has a custom `/review` command that "compares the PR against specific rules that we follow in the codebase" — review against your own rules, not generic linting.

### Plan first for big features; prompts in small pieces

- Plan-then-execute for anything sizable: "the difference between using the plan mode and not using it is pretty significant." Review the plan before a line is written.
- Prompt granularity: "Structuring your prompt into multiple smaller ones makes the output much better and is also way easier to follow." His literal cadence is a sequence of small asks:

```text
1. "Build the settings screen scaffolding from the Figma frame; use <Form> from ui/"
2. "Wire the toggle to the persisted notifications preference."
3. "Footer gap should be 24px, not 12."
4. "The toast doesn't dismiss on route change. Fix."
```

One mega-prompt produces worse output and an unreviewable diff. Small prompts keep every step checkable.

### Design-to-code: scaffolding then human polish

He was long hesitant about AI-built UI — he wanted full control and assumed "build with AI then polish" would be slower than hand-building. Figma's design-tool MCP changed his mind: with a good rules setup, "building out the scaffolding for complex screens with a lot of components is way faster." The loop:

1. Prompt the agent with the design frame (his prompts are deliberately *non-technical* — "this has generally worked pretty well for me... partially because the codebase rules are set up well"; weak rules force technical babysitting instead).
2. AI produces structure: layout, components, wiring, tokens from the design system.
3. He then does "tweaking, polishing and animating" himself — the taste pass is never delegated.
4. Output is "not perfect by any means" — scaffolding, not shippable UI.

Understanding gate: "I can't stress enough how important it is to actually understand what the agent is doing. If you don't understand, ask the agent to explain" (his editor's Ask mode; any agent's explain-your-diff works).

### Live docs over stale training data

Library APIs drift; the model's training data lags. He runs one docs MCP (context7) that "fetches the most-up-to-date documentation for the libraries and frameworks I work with." Rule: for any dependency API newer than the model's cutoff, ground the answer in live docs, don't recall from memory.

### Write less code — the favorite AI task

The goal is not "AI writes code so I type less" but *less code existing* for the same functionality: "AI is great at finding [duplications] and extracting them into shared components/utilities." His example: hand-defined icons existed as manual files; an npm package made them obsolete. The migration (replace imports, delete files) was too tedious to ever do by hand, so he delegated it — "it needed a bit of help here and there but it did pretty well. Now my codebase has ~5000 fewer lines of code but the same functionality. These are the kind of tasks I like using AI for the most." Delegate mechanical mass-edits and dedup extraction; keep the API design of the extracted shared thing.

### Review as an extra layer, CLI for big tasks

- Automated review on every PR (he uses a second vendor's reviewer; also a deploy-platform agent "for bigger PRs"). Value: redundancy, not authority — it never replaces his own read of the diff.
- Terminal-resident agents beat IDE agents for large tasks: "I find CLIs to be much better at bigger tasks than IDEs or their web counterparts." (He compared four: Claude Code — his favorite — Codex, Cursor CLI, OpenCode; he mix-and-matches CLI and IDE.)
- Model choice is load-bearing but perishable: at time of writing he ran one model (Claude Opus 4.5) as daily driver for speed + quality. Pick one strong default, re-evaluate often; don't encode a model name into your process.
- Non-code use is fair game: every image in the essay was model-generated — acceleration applies to assets too, with the same human filter.

### What this means for you, the AI agent

- Expect to be treated as context-free and rule-governed: the human will restate context and point at rules files — follow those rules over your defaults, including in conflicts with your training priors.
- Your UI output is scaffolding by definition. Structure, wiring, tokens: yes. Final spacing/typography/motion calls: flag, don't finalize.
- When asked to explain your diff, explain it precisely; an unexplained diff is an unshippable diff.
- Run the deslop checklist against your own output before reporting done: no stray comments, no unneeded defensive code, no `any`-casts, style consistent with the touched files.
- Propose dedup when you see it (same snippet ≥3 times → shared component/utility), but let the human approve the API.
- Don't offer creative direction unprompted; when the human says a concept "doesn't feel right," discard it without advocacy — disposable speed is the entire point.

## When to use / When NOT to use

Use when:
- Starting a codebase or joining a project — write the rules files first, prompt second.
- A design spec exists and structure must be scaffolded from it fast.
- A concept needs a cheap, throwaway prototype before committing hours.
- A mechanical migration or dedup pass would otherwise never happen.
- Your own AI-generated branch needs a slop pass before review.

Do NOT use when:
- The task IS the idea, the direction, or the taste call — delegating those is "outsourcing your thinking," which "can hurt you in the long run."
- The polish/animation pass — that is the human half of the loop by design.
- You can't explain what the agent produced — stop and make it explain, or redo it.
- You'd paste rules you don't understand — an unexplained rule degrades every future generation.
- The API in question postdates the model's training data and no live docs are wired in.

## How to apply

1. Before first prompt: write 2–5 short rules files (one concern each: animation performance, design-system usage, class composition, framework constraints), each referencing detail files.
2. Open every session assuming the agent knows nothing; first prompt restates the task, the relevant files, and the rules to load.
3. For a sizable feature, force a plan step; do not let code generation start before the human approves the plan.
4. Break work into the smallest sequential prompts (one intent each); verify each diff before the next.
5. Scaffold UI from the design spec with non-technical prompts; then hand off for human tweak/polish/animate — do not present scaffolding as finished.
6. After generation, run the deslop checklist against the branch diff; end with a 1–3 sentence summary of what changed.
7. Ask the agent to explain anything in the diff you can't reproduce yourself.
8. Periodically task the agent with dedup: find repeated patterns, extract shared components/utilities, aim for fewer lines at identical functionality.
9. Ground dependency APIs in live documentation, not memory, when versions are recent.
10. Put an automated reviewer on every PR as a second layer — your own read of the diff stays the first.
11. Re-evaluate tools/models quarterly; treat any specific pick (his or yours) as dated the day it's written.

## AI-slop warning

How AI misapplies this very skill: it reads "accelerate" as "replace" — ships scaffolding as final UI, offers taste opinions, defends a concept the human rejected. It copies rules files it can't justify line-by-line, then enforces them wrongly. It skips the deslop pass, so the slop markers it was built to remove (redundant comments, defensive try/catch on trusted paths, `any`-casts, file-inconsistent style) land in the branch anyway. It assumes session memory exists, hallucinates library APIs instead of pulling live docs, and answers with one mega-diff nobody can review. Krehel's close is the countermeasure and the stakes: "there is also more slop than ever," and as entry barriers fall, "quality and craftsmanship will be more important than ever. Design and user experience will become the product." The human filter is not overhead on this workflow — it is the workflow.

## Relations

- `desengs-jakub-kr` — the author's portfolio; shows what the human half of this loop (his typography, motion, craft baseline) actually looks like in shipped work.
- `desengs-shedsgns-taste` — supplies the judgment this skill's loop depends on: what the taste filter is selecting for and how it is developed, not just that it must stay human.
- `desengs-how-i-design-with-ai` — a parallel first-person AI design workflow; compare where each author draws the delegate/keep line.
- `desengs-ui-skills` — one of the rule sources Krehel loads into his agents; concrete content for the rules files this skill prescribes writing first.
