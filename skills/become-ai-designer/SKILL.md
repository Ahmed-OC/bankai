---
name: become-ai-designer
description: Use when design output must keep pace with engineering or when moving design from mock files into shipped code. Brennan's 6-step map: vibecode prototypes, prod as source of truth, own the frontend.
source: https://uxdesign.cc/how-to-become-an-ai-designer-ff8ee8aed205
category: essay
---

# How to Become an AI Designer — the AI-era skill map

Source: https://uxdesign.cc/how-to-become-an-ai-designer-ff8ee8aed205 — Maya Brennan, "How to become an AI Designer", UX Collective (Medium), Aug 2026. First-person account of a product designer who joined a 0–1 team (an agent observability/evals product), had never shipped a PR, and within months owned the team's frontend. Essay + FAQ; no component inventory.

## What it is / Why it exists

- Thesis, in the author's words: "AI-native design is at its core the ability to ship your own designs and make them great."
- The pressure that forces the change: engineers shipping brand-new features multiple times a day. Pixel-perfect mock files cannot keep up; even rough wireframes are too slow for ever-evolving workflows. Design risks becoming the bottleneck.
- Quoting Jenny Wen (Anthropic): the traditional discovery → mock → iterate loop was designed for a world where building was slow and expensive. That world is gone, so the loop's centerpiece (the mock file) stops being the deliverable.
- The article is a career/workflow map (6 steps) plus an FAQ of concrete operating rules with exact numbers. Its value here is pattern knowledge: what fidelity to build at, where designs live, and how to stop wasting effort when agents make changes cheap.

### The skill map the title actually points at
The "AI designer" the essay defines is not a prompt wizard; it is a designer who can:
1. Ship their own designs as real code (the core competency everything else serves).
2. Prompt agents for batched explorations (3–5 component variants) and lo-fi click-through prototypes at the right fidelity.
3. Review and author frontend PRs — and know the frontend/backend boundary well enough to decide what to hand off.
4. Encode design knowledge as reusable skill files for agents and teammates, updated on every repeated failure.
5. Maintain design-system foundations so agent-generated UI converges instead of diverging.
6. Communicate design rationale inline (PRs, tickets) to survive role-blurred teams.
Everything below is the 6-step path for acquiring that map, plus the FAQ's operating rules.

## The core ideas

### 1. Close Figma for a week
- The opening move: abandon the old routine entirely, even as an experiment. The author no longer uses a mock tool for product design work at all.
- Rationale: on a 0–1 team with no existing files and daily feature ships, there is no way static screens stay current. The question is not "how do I design faster" but "how do I influence product direction in real time".

### 2. Vibecode interactive prototypes — the 90% rule
- Replace screen-building with quick click-through HTML prototypes generated in chat. Share with the team daily, get feedback, iterate, re-share before end of day.
- The loop is the deliverable: a prototype's only job is to provoke a same-day decision, then be deleted. Anything worth keeping moves into prod, not into an archive of mockups.
- For small UX details, do not build a full screen: ask for 3–5 component explorations instead.
- Two hard constraints on prototypes: keep them (a) as simple as possible and (b) visually unrelated to the real design system. Exact quote: "Getting a wireframe ninety percent of the way there is exponentially easier than trying to get the last ten percent right." Perfecting visual detail is explicitly not the agent's strong suit; weigh whether the last 10% is worth hours of frustration.
- Hi-fi only when the feedback needed is visual — and only in a design-capable canvas with design-system preferences pre-configured, so multiple iterations of the same screen sit side-by-side on one canvas (the comparison view plain chat mocking lacked). Hi-fi HTML "product shots" double as marketing visuals.
- Lo-fi mechanism, plain CSS — the deliberate anti-design-system:

```html
<!-- Exploration prototype: grayscale, system font, no brand tokens.
     Feedback lands on flow and hierarchy, never on pixels. -->
<style>
  * { font: 13px/1.5 system-ui; color: #222; box-sizing: border-box; }
  body { max-width: 720px; margin: 24px auto; }
  .box { border: 1px solid #999; border-radius: 4px; padding: 12px; margin: 8px 0; }
  .btn { background: #ddd; border: 1px solid #777; padding: 4px 10px; cursor: pointer; }
  .placeholder { /* content stub: obviously fake, so nobody critiques it */
    background: repeating-linear-gradient(45deg, #eee 0 6px, #f6f6f6 6px 12px);
    min-height: 40px; }
</style>
```

### 3. The product is the Source of Truth
- Every artifact between chat and prod fails the same way: Figma-screenshot hybrids and exported HTML are either too lo-fi to be final designs or too hi-fi to keep updated while the live product diverges daily.
- Wen's pivot, adopted as the author's rule: "Prod was the Source of Truth."
- Consequence: if you want the source of truth *designed*, you must ship real code. Design decisions stop living in a mock file and start living in PRs.

### 4. Get codebase access — efficient output vs better output
- Using AI to speed up the old deliverables is *efficient* design output. Editing the real codebase is *better* design output. The difference is where quality lives: "Truly great interface design lives in the details", and even perfectly annotated mockups get desecrated at handoff.
- Direct code access buys: fixing the smallest visual nits and tiniest interactions (invisible individually, decisive in aggregate), plus adding interactivity, responsiveness, and delight that static design cannot specify.
- Org playbook for access (in order):
  1. Share real examples of designers shipping code — advocacy runs on proof, not proposals.
  2. Sell the benefit to engineering — designers absorb frontend chores, "No more pings to update colors or reduce a gap from 24px to 16px!" — and commit to starting small.
  3. Find one engineering champion willing to spend a few hours on setup; one ally unblocks more than org-wide agreement.
  4. If org-wide pushback: start with a coding-agent bot in the messaging workspace — zero setup, no repos or dev environments, pings make real changes; naturally scopes to copy fixes and color tweaks.
  5. If the company never moves: do it yourself (easy-entry generators first, code-editor agents later) and build a builder's portfolio.

### 5. Own frontend decisions, not the frontend
- "Owning" = lead on frontend decisions: review all frontend PRs, co-drive UX overhauls with engineers, implement a large portion of UI polish yourself. It does not mean building the whole interface.
- Learn the frontend/backend boundary; know what is worth your time and what to hand off. Start with tiny UI changes, then go bigger.
- Communicate reasoning behind every design update "even if you feel like the reasoning is obvious". Roles are blurring (engineers take customer calls, PMs make wireframes, designers vibecode), which breeds challenged decisions; a few seconds of stated rationale converts to trust.
- Trust compounds: the author notes it "is built over time" — each explained PR widens what the designer is allowed to touch; each unexplained change that gets reverted narrows it back.
- Level up by making everyone's code better: encode design knowledge as skills/instructions agents use, and update them every time a repeated problem appears. Cited study paths: agent-teaching design skills (Vercel), interface detail work (Krehel), animation practice (Kowalski).

### 6. The honest cost — "Embracing the chaos"
- The endpoint is ambivalent, and the essay says so plainly: the workflow is "optimized enough that I cannot go backwards, but not rewarding enough for me to stay where I'm at". Tab-jumping, prompt-switching, and PR-babysitting are mentally exhausting; cheap changes start to feel transient and meaningless; craft detachment replaces flow states.
- Cites Wattenberger ("Our Interfaces Have Lost Their Senses"): removing friction from experiences removes satisfaction — a warning the author applies to her own making process, not just shipped UI.
- FAQ verdict on "10x design thinking": "you cannot speed up creativity. You cannot simulate Taste. You cannot use an LLM to replace what time and experience and art bring to the table." You can 10x output, iterations, prototypes, and refinement — not judgment.
- Prescribed counterweight: other designers — check in with colleagues and go to design events. Community is the craft anchor.

### Operating rules from the FAQ (exact numbers)
- The 3-prompt rule: if you have tried to get the agent to fix the same issue with more than 3 prompts, pause — switch to another PR and return later (models have bad days), or hand it to an engineer.
- Escalation rule: if you are fixing the same issue across multiple PRs, the fix is to update your skill/instruction file — not to keep re-fixing per screen.
- Feature-sized changes: build a prototype you are happy with first, then hand it to the coding agent as the reference for changing prod. Never attempt many incremental changes directly on the live UI.
- Task-to-tool separation (generalizable mechanism, ignore the brand names): general chat for research, diagram mockups, small UI explorations, debugging; a language-tuned chat for in-product copy and naming; a design canvas for multi-iteration visual prototypes and exportable HTML product shots; a code editor agent for prod changes; ticket tracking for design work; doc/call-transcript summarization.
- Nit-flood control: improve design-system foundations with the DS team (speeds all future vibe-designing); maintain skills and get engineers using them too; run a monthly Polish Week with daily bug bashes and UI-nit tickets assigned across the whole team — so the designer does not become the team's cleanup person.

## What transfers to an AI agent building AI-product UI

- Fidelity budget: 90% lo-fi by default. Do not spend prompts on the last 10% of visual polish unless the question being answered is itself visual.
- Explore in batches: 3–5 variants of a single component, never one full screen per question. Present iterations side-by-side so comparison is possible.
- Build in the real medium: shipped code is the designed artifact; every intermediate artifact is disposable reference. Never let a mock outlive the code it describes.
- Apply the 3-prompt rule to yourself: three failed attempts at one visual nit means the battleground is wrong — fix the design system, write a skill, or hand off.
- Repeated fix = missing abstraction: same nit in 2+ places is a skill-file update, not another prompt.
- Prototype-as-spec: for large UI changes, generate the reference prototype first, then edit prod against it — more effective than incremental live tweaks.
- Rationale travels with the change: PR descriptions and comments state what and why; in blurred-role teams unexplained decisions get reverted.
- Keep friction where it buys judgment: Wattenberger's point applies to the UI you ship too — an agent-product flow stripped of all confirmation and edit friction loses user satisfaction, not just safety. Design that friction deliberately.
- Durable over transient: when changes are cheap they feel disposable; anchor what matters (tokens, components, motion rules) in the design system and skill files, which persist across throwaway screens.
- Output is not taste: more iterations never substitute for selection. When generating stops improving the result, stop and choose.

## When to use / When NOT to use

Use when:
- design process must keep pace with multi-deploy-per-day engineering;
- deciding where designs live (mock file vs repo) — this essay is the argument for repo;
- standing up designer-ships-code workflows: champions, chat bots, polish cadences, skill files;
- choosing prototype fidelity (lo-fi flow checks vs hi-fi visual checks);
- building AI-product UI itself — the author's product was an agent observability/evals platform, and her workflow rules (batched explorations, reference prototypes, nit budgets) were learned on exactly that surface.

Not:
- as a component or visual pattern reference — there is none here;
- to justify shipping unreviewed vibecoded UI — the premise is that all frontend PRs get design review, ideally by the designer;
- for final polish via prompting — the essay's own rule: the last 10% by prompt is wasted hours; use code access and design-system fixes instead;
- as a prescription for every designer — Step 6 documents real craft costs; adopt the mechanics, weigh the trade;
- on a team that ships weekly with stable surface area — the mock-file loop it replaces only breaks when engineering velocity is daily and the product is still moving.

## How to apply (numbered checklist)

1. Pick the next flow question and skip the mock file: generate a click-through HTML prototype, grayscale and system-font, zero brand tokens.
2. Share it same day; iterate and re-share before EOD — daily loop, not weekly.
3. For component-level questions, generate 3–5 explorations of the component only.
4. Stop at 90%: if remaining work is visual detail and the open question is not visual, move on.
5. Treat the repo as the source of truth: route every design change through a PR you author or review; point stakeholders at prod, never at a stale mock.
6. Enforce the 3-prompt rule: third failed fix attempt on one issue = pause, switch tasks, or hand off.
7. Log repeated nits; same fix in 2+ PRs = write or extend a skill file, then reuse it.
8. Before any large UI change, build the reference prototype first and give it to the coding agent as spec.
9. Write the what and why into every PR description — obvious-to-you rationale still gets stated.
10. Budget polish institutionally: monthly Polish Week, daily bug bashes, nit tickets spread across the team, design-system fixes over per-screen fixes.
11. Audit monthly: if output rose and craft connection fell, rebalance deliberately (Wattenberger's friction argument applies to makers too).

## AI-slop warning

How AI misapplies this essay:
- Reads "vibecode prototypes" as a license to ship unpolished generated UI. The rule is the inverse: prototypes stay deliberately lo-fi *because* prod is where quality lands — and prod changes go through design review.
- Applies the 90% rule to shipped product. 90% is for throwaway explorations; the entire point of Steps 4–5 is fixing the last 10% in real code.
- Confuses velocity with quality: the FAQ's explicit limit — "you cannot speed up creativity. You cannot simulate Taste" — means endless iteration without selection is the slop signature, not the workflow.
- Burns dozens of prompts perfecting pixels of an artifact nobody will ship — the exact wasted-hours anti-pattern the essay names.
- Deletes the human steps (rationale in PRs, polish weeks, design community) as overhead; those are the checks that keep agent-generated UI from drifting into vibecoded slop.

## Relations

- code-source-of-truth — the same pivot (mocks → repo as design truth) argued from the mechanism side; this essay adds the career path and org playbook around it.
- anatomy-ai-input — complements the prompting half this essay assumes: how to structure agent inputs so 3–5 exploration batches and 90% wireframes actually land.
- how-i-design-with-ai — a second practitioner's AI design workflow; compare tool splits, fidelity choices, and where each draws the craft line.
- details-feel-better — the author's cited reading (Krehel) for what is worth shipping code to fix once you have access: the small details that aggregate into felt quality.
- agentation — pattern vocabulary for agent-product UI (runs, state, evals surfaces — the product class the author designed); use it for the UI itself, this skill for the workflow that produces it.
