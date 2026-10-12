---
name: aicss
description: Use when any UI must show what an AI agent or pipeline is doing — thinking blocks, streaming text, tool-call step lists, image placeholders, approval cards — as named states in plain CSS, no component library.
source: https://aicss.dev
category: library
---

# AICSS — copy-paste, plain-CSS UI states for AI agent conversations

Source: https://www.aicss.dev — Kevin (@kvnkld); repo https://github.com/kvnkld/aicss (MIT, Beta V1.2). A library of "beautifully designed, copy-paste UI components for AI agent conversations: thinking states, tool calls, streaming text, citations, tables and more", shipped for **React, Vue and Svelte** — "with plain CSS and no Tailwind".

## What it is / Why it exists

14 components in 5 categories:

| Category | Components |
|---|---|
| Thinking & Reasoning | Thinking State (shimmering label), Thinking + Reasoning (collapsible reasoning block), Orbs (compact activity indicators) |
| Tool & Action States | Web Search (sources resolving one by one), File Diff (+/- lines), Image Generation (shimmering canvas placeholder with dimensions + prompt) |
| Text Outputs | Text Response, Streaming Text (typewriter + blinking caret), Inline Citations (superscripts + source footer), Code Block (filename tab + copy) |
| Structured Outputs | To-do List (agent-maintained checklist with count + progress pie), Data Table, Comparison Table |
| Rich & Interactive | AI Agent Input (attachments, model menu, slash-command pills, prompt "enhance" state machine), Approval Card (questions, options, progress "1/3", Skip/Continue) |

**The gap it fills**: AI features had converged on a bare spinner over a JSON dump for states the user genuinely needs to read — what the agent is thinking, which tools it is calling, which inputs it is using, what it produced, and where it needs human consent. AICSS applies the shadcn-style copy-paste distribution model to exactly these agent-specific states, per framework, with zero UI dependencies.

**Distribution**: npm (`@aicss/react`), shadcn registry JSON (`npx shadcn@latest add https://www.aicss.dev/r/thinking-state.json`), or CLI (`npx @aicss/cli add thinking-state`; Pro components need a token). Each component is a small `.tsx`/`.vue`/`.svelte` file plus a CSS module — fully self-contained.

**Copy vs install**: intended consumption is copy-paste-then-own. Installing `@aicss/react` is only justified when adopting many components at once inside an existing shadcn/registry setup; otherwise lift the mechanisms below into your own components and global stylesheet.

## The core ideas (faithful to AICSS)

1. **Every AI behavior gets a named UI state.** There is no generic "loading" in AICSS: thinking, searching, generating
   an image, editing a file each have a dedicated component with its own anatomy and copy. If the pipeline does something
   the user can name ("synthesizing speech", "generating scene 3"), the UI names it too.
2. **Model explicit phases, not booleans.** Components are small state machines: `thinking → reasoning → done`,
   `idle → enhancing → enhanced`, `pending → active → done`. AICSS's AI Agent Input exposes a single `Phase` type and an
   integration seam (`onEnhance(prompt, signal)`) honoring `AbortSignal`; failures restore the previous state.
3. **Design the "after" as carefully as the "during".** Live activity collapses into a persistent, re-openable artifact:
   the reasoning block folds into "Thought for Ns"; pending dashed circles resolve into checks; the source header's globe
   morphs into a check mark. Nothing vanishes when it finishes — it becomes inspectable history.
4. **Honest waiting.** Shimmer/skeletons describe the work in progress: the Image Generation card shows the resolution
   and the actual prompt text while the canvas shimmers. The user sees the *inputs* of the AI's work, not a blind spinner.
5. **Progressive reveal at a human cadence.** Reasoning appears sentence by sentence; web sources tick from "searching"
   to "resolved" one by one. Never dump a finished wall of text after silence.
6. **Progress you can read.** Counts ("To-dos 0/5"), rolling digits, a determinate pie drawn with `conic-gradient`,
   and a clear done state (filled check + strikethrough). When the total is known, progress is determinate.
7. **Consent is a component.** The Approval Card makes human-in-the-loop a first-class UI moment: a question, options,
   a progress marker ("1 / 3"), Skip/Continue. Expensive or hard-to-reverse AI actions wait for an explicit yes.
8. **Plain, craft-conscious CSS.** CSS custom properties as tokens, CSS modules, theme-aware via `[data-theme]` +
   `prefers-color-scheme`, all animation guarded by `prefers-reduced-motion`, proper a11y (`aria-expanded`, `aria-live`,
   menu/listbox roles). Short durations (140–400 ms), soft easing (`cubic-bezier(0.4, 0, 0.2, 1)`), staggered entrances
   via `transition-delay: calc(var(--i) * 50ms)`.

## The signature techniques (React or vanilla + plain CSS)

Shared tokens — declare once in your global stylesheet / design-token layer (prefix to avoid collisions):

```css
:root {
  --aicss-text: var(--color-text, #1a1a1a);
  --aicss-muted: var(--color-text-muted, #6b7280);
  --aicss-surface: var(--color-surface, #ffffff);
  --aicss-border: var(--color-border, #e5e7eb);
  --aicss-accent: var(--color-accent, #4f46e5);
  --aicss-ease: cubic-bezier(0.4, 0, 0.2, 1);
}
.aicss-shimmer {
  background: linear-gradient(90deg, var(--aicss-muted) 0%, var(--aicss-text) 50%, var(--aicss-muted) 100%);
  background-size: 200% 100%;
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  animation: aicss-shimmer 2s linear infinite;
}
@keyframes aicss-shimmer { to { background-position: -200% 0; } }
@media (prefers-reduced-motion: reduce) {
  .aicss-shimmer { animation: none; color: var(--aicss-muted); }
}
```

### Pattern 1 — Thinking + Reasoning (collapsible reasoning block)

Phases: `thinking` (shimmering label) → `reasoning` (sentences appear as they stream) → `done` (collapses into a
"Thought for Ns" summary the user can re-open). This is AICSS's signature "transience → persistence" move.

```tsx
type Phase = "thinking" | "reasoning" | "done";
function Reasoning({ phase, sentences, seconds }: { phase: Phase; sentences: string[]; seconds?: number }) {
  const [open, setOpen] = useState(true);
  if (phase === "thinking") return <p className="reasoning-label aicss-shimmer">Thinking…</p>;
  const done = phase === "done";
  return (
    <section className="reasoning" data-state={done ? "done" : "live"}>
      <button className="reasoning-toggle" aria-expanded={open || !done} onClick={() => setOpen(o => !o)}>
        {done ? `Thought for ${seconds}s` : <span className="aicss-shimmer">Drafting the storyboard…</span>}
        <ChevronIcon className={done && !open ? "chevron" : "chevron chevron-open"} />
      </button>
      {(open || !done) && (
        <div className="reasoning-body" aria-live="polite">
          {sentences.map((s, i) => (
            <p key={i} className="reasoning-sentence" style={{ "--i": i } as React.CSSProperties}>{s}</p>
          ))}
        </div>
      )}
    </section>
  );
}
```

```css
.reasoning { border: 1px solid var(--aicss-border); border-radius: 12px; background: var(--aicss-surface); }
.reasoning-toggle { display: flex; gap: 8px; align-items: center; width: 100%; padding: 10px 14px;
  border: 0; background: none; color: var(--aicss-muted); font-size: 13px; cursor: pointer; }
.reasoning-body { padding: 0 14px 12px; }
.reasoning-sentence { margin: 6px 0; color: var(--aicss-text); font-size: 14px; line-height: 1.55;
  animation: sentence-in 240ms var(--aicss-ease) both; animation-delay: calc(var(--i) * 50ms); }
@keyframes sentence-in { from { opacity: 0; transform: translateY(4px); } to { opacity: 1; transform: none; } }
@media (prefers-reduced-motion: reduce) { .reasoning-sentence { animation: none; } }
```

### Pattern 2 — Pipeline stages as a tool-call task list

AICSS's To-do List pattern (Cursor-style): a collapsible header with a rolling count and a `conic-gradient` pie,
items moving `pending` (dashed circle) → `active` (arrow + shimmering label) → `done` (check + strikethrough).
The right shape for any multi-stage AI pipeline (text generation → storyboard → image generation → speech synthesis →
video rendering → automated QA).

```tsx
const STEPS = [
  { id: "script", label: "Script generation" },
  { id: "storyboard", label: "Storyboard" },
  { id: "images", label: "Image generation" },
  { id: "voice", label: "Speech synthesis" },
  { id: "render", label: "Video render" },
  { id: "qa", label: "Quality check" },
] as const;
type StepState = "pending" | "active" | "done" | "error";

function Pipeline({ states }: { states: Record<string, StepState> }) {
  const doneCount = STEPS.filter(s => states[s.id] === "done").length;
  const total = STEPS.length;
  return (
    <section className="pipeline" aria-label="Pipeline progress">
      <header className="pipeline-header">
        <span className="pipeline-pie" style={{ "--done": doneCount / total } as React.CSSProperties} aria-hidden />
        <span className="pipeline-count">{doneCount}/{total}</span>
        <h2>Generation</h2>
      </header>
      <ol>
        {STEPS.map((s, i) => (
          <li key={s.id} className="step" data-state={states[s.id]} style={{ "--i": i } as React.CSSProperties}>
            <span className="step-icon" aria-hidden />
            <span className={states[s.id] === "active" ? "step-label aicss-shimmer" : "step-label"}>{s.label}</span>
          </li>
        ))}
      </ol>
    </section>
  );
}
```

```css
.pipeline { border: 1px solid var(--aicss-border); border-radius: 12px; background: var(--aicss-surface); }
.pipeline-header { display: flex; align-items: center; gap: 8px; padding: 10px 14px; }
.pipeline-pie { width: 14px; height: 14px; border-radius: 50%;
  background: conic-gradient(var(--aicss-accent) calc(var(--done) * 360deg), var(--aicss-border) 0); }
.pipeline-count { font-variant-numeric: tabular-nums; font-size: 12px; color: var(--aicss-muted); }
.step { display: flex; gap: 10px; align-items: center; padding: 8px 14px;
  animation: sentence-in 240ms var(--aicss-ease) both; animation-delay: calc(var(--i) * 50ms); }
.step-icon { width: 14px; height: 14px; flex: none; }
.step[data-state="pending"] .step-icon { border: 1.5px dashed var(--aicss-border); border-radius: 50%; }
.step[data-state="active"]  .step-icon { border: 1.5px solid var(--aicss-accent); border-radius: 50%; }
.step[data-state="done"]    .step-icon { background: var(--aicss-accent); border-radius: 50%;
  /* check via mask or inline SVG */ }
.step[data-state="error"]   .step-icon { background: #dc2626; border-radius: 50%; }
.step[data-state="done"] .step-label { color: var(--aicss-muted); text-decoration: line-through; }
```

### Pattern 3 — Image generation placeholder

AICSS's Image Generation card: a shimmering canvas that states what is being generated (dimensions + the real prompt),
crossfading to the image when done — honest waiting with visible inputs.

```tsx
function ImageCard({ prompt, width, height, url }: { prompt: string; width: number; height: number; url?: string }) {
  return (
    <figure className="imgcard" style={{ aspectRatio: `${width} / ${height}` }}>
      {url
        ? <img src={url} alt={prompt} className="imgcard-result" />
        : <div className="imgcard-placeholder" role="status">
            <p className="imgcard-status aicss-shimmer">Generating {width}×{height}…</p>
            <p className="imgcard-prompt">"{prompt}"</p>
          </div>}
    </figure>
  );
}
```

```css
.imgcard { position: relative; margin: 0; border-radius: 12px; overflow: hidden;
  border: 1px solid var(--aicss-border); background: var(--aicss-surface); }
.imgcard-placeholder { position: absolute; inset: 0; display: grid; place-content: center; gap: 6px;
  padding: 16px; text-align: center;
  background: linear-gradient(110deg, var(--aicss-surface) 40%, var(--aicss-border) 50%, var(--aicss-surface) 60%);
  background-size: 200% 100%; animation: placeholder-sweep 1.6s linear infinite; }
@keyframes placeholder-sweep { to { background-position: -200% 0; } }
.imgcard-prompt { font-size: 12px; color: var(--aicss-muted);
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.imgcard-result { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover;
  animation: sentence-in 300ms var(--aicss-ease) both; }
@media (prefers-reduced-motion: reduce) { .imgcard-placeholder { animation: none; } }
```

## When to use / When NOT to use

**Use when:**

- Building any "pipeline activity" surface: the user launched a generation or agent run and must understand what the AI is doing right now.
- Showing long waits (LLM planning, text generation, image generation, speech synthesis, video rendering, automated QA) without a bare spinner.
- Streaming LLM output (planning, narration, chat) sentence by sentence.
- Rendering per-asset progress (N images out of M, N scenes out of M).
- Asking the user to approve or correct an AI decision before an expensive step (render, regeneration, spend).
- Styling these states from your global stylesheet / design tokens in a modern React or vanilla stack — copy-paste, plain CSS, never an imported component system.

**Do NOT use when:**

- Feedback is sub-second and local (button press, trivial fetch): a named AI state is overhead; use native feedback or none.
- You cannot truthfully name what the agent is doing: fake stage names are worse than one honest indeterminate state.
- A native, cheaper alternative suffices: a plain `<progress>`, a list, or `aria-live` status text already covers simple cases.
- Weight or a11y budget matters more than polish: shimmer gradient text can fail contrast, and every animation needs a `prefers-reduced-motion` fallback.
- The surface is not agent-driven at all — bolting agent chrome onto standard CRUD is slop.

### Anti-patterns

- **The anonymous spinner.** A single indeterminate spinner for a 5-stage, minutes-long pipeline. AICSS's whole premise is that each AI action gets a named, described state.
- **No terminal state.** Leaving an "active" shimmer running after the step finished. Every phase machine needs its `done` (and `error`) rendering — the check mark, the strikethrough, the collapsed "Thought for Ns".
- **Silence then dump.** Waiting for the full LLM response and inserting it at once. Stream it sentence by sentence, then collapse it instead of deleting it.
- **Indeterminate progress where the total is known.** If there are 8 scenes, show "3/8" and a pie — not a bar of unknown length.
- **Hiding the inputs.** Generating an image without showing which prompt is being used. Transparency of AI actions is the point.
- **Blocking the whole UI.** A modal overlay that freezes the app during a long render. Activity states live inline, next to the asset they concern; the user stays able to look around.
- **Silent failures.** An error collapsed into console logs or a frozen shimmer. Show an `error` state with a retry, and restore the previous UI state (AICSS's enhance flow reverts the prompt on failure).
- **Importing a styling system instead of copying.** No Tailwind, no shadcn, no `@aicss/react` npm dependency for one shimmer — reproduce the patterns with your own tokens and CSS modules.
- **Motion without an escape hatch.** Shimmer, sweeps and staggered entrances must all sit behind `prefers-reduced-motion`.

## How to apply (numbered checklist)

1. **Enumerate the pipeline's real stages** (text generation, image generation, speech synthesis, video rendering, automated QA…) and render them as a tool-call task list (Pattern 2): a collapsible "Generation 2/5" card with pending dashed circles, a shimmering active label, and done checks + strikethrough.
2. **Stream the reasoning** (Pattern 1): shimmering "Thinking…" while the model works, sentences revealed as they arrive, collapse into "Thought for 12s" — re-openable, never deleted. Keep a `Phase` state machine and an `AbortSignal` seam like AICSS's `onEnhance`.
3. **One Image Generation card per generated asset** (Pattern 3): shimmering placeholder showing `1280×720` and the actual prompt, crossfade to the finished image; on failure, an inline error with "Regenerate" instead of a broken tile.
4. **Deterministic per-asset progress**: "Images 3/8" with a `conic-gradient` pie and tabular-nums rolling count — when the job count is known, progress must be determinate.
5. **Verification results as a structured table** (Data Table / Web Search pattern): each check (readability, captions, framing, artifacts) resolves live from "Analyzing…" to pass/fail one by one, like AICSS's sources ticking to "resolved"; failures link to the exact asset/frame.
6. **Approval Card before the expensive step**: before a costly render or regeneration, show a summary question, options ("Start the render", "Edit inputs", "Cancel"), and progress like "1 / 2" when several confirmations are needed.
7. **Short steps as named micro-states, not silence**: a compact Orbs-style inline indicator + "Synthesizing voice…" that resolves to "Voice ready · 0:34" — named work, visible input, persistent result.
8. **Error and abort as first-class phases**: every stage gets `error`/`cancelled` renderings; aborting a run (or unmounting) cancels in-flight fetches via `AbortController` and restores the previous UI state.
9. **Terse microcopy for every state**, matching AICSS's voice: "Thinking…", "Generating 1280×720…", "Done in 8s", "Analyzing…" — short, present tense, with durations once done.
10. **Add the shared token block once** to your global stylesheet — shimmer, stagger, easing, reduced-motion guard — reusing your existing color variables, then build each pattern as a small self-contained component + CSS module.

## AI-slop warning

The shimmering "Thinking…" label and the tool-call checklist are becoming the default AI-product aesthetic; treat them as a vocabulary, not decoration. Typical failure modes:

- **Agent chrome on nothing**: shimmers, reasoning blocks and "1/3" approval cards pasted onto features with no real streaming, no real phases, no real consent decision — theater that erodes trust the first time the UI lies.
- **Simulated streaming**: revealing non-streaming output with a `setTimeout` typewriter to look busy. Only stream what actually streams; otherwise show the finished result with a short entrance.
- **Checklist compliance**: step lists whose stages always succeed in order, hiding the retries and branches the user needs to see.
- **Over-collapsing**: folding everything into "Thought for Ns" so no inspectable history remains — the collapse must be re-openable and summaries must state durations.
- **Dependency slop**: installing `@aicss/react` (or re-issuing Tailwind-ified clones) instead of copying the small self-contained files and owning them, and forgetting `prefers-reduced-motion` guards on every animation.
- Contexts it poisons: enterprise tools that need dense, glanceable status over conversational chrome; marketing pages; any non-AI surface where agent vocabulary reads as costume.

## Relations

- **loading-dev** — the broader loading/skeleton vocabulary; AICSS narrows it to named agent phases. Use loading-dev for generic data-fetching states, this skill when the "loader" is an AI action with inputs and artifacts.
- **transitions** — supplies the motion grammar behind the durations and easings used here (140–400 ms, `cubic-bezier(0.4, 0, 0.2, 1)`, staggered `transition-delay`); consult it before inventing new timings.
- **agentation** — sibling agent-UI library; overlaps on agent conversation surfaces and streaming input. Compare inventories before building; prefer the component you can own and trim.
- **ui-ux-canon** — the canon index that routes to this skill; re-read it when combining several canon skills on one surface.
