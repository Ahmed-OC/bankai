---
name: thinking-orbs
description: Use when designing or building AI/agent waiting or "thinking" indicators — dotted thought-orb states that name the cognition stage instead of generic spinners; monochrome, GPU-cheap, a11y-safe.
source: https://orbs.jakubantalik.com
category: library
---

# Thinking Orbs — dotted thought-orb indicators that show AI reasoning, not busy-ness

Source: https://orbs.jakubantalik.com — "Thinking Orbs" by Jakub Antalik (code: github.com/Jakubantalik/thinking-orbs), a small canvas library of dotted thought-orb loading indicators built for AI and agent UIs. described as "Dotted thought-orb loading indicators for AI and agent UIs".

## What it is / Why it exists

A library of loading indicators made of strictly monochrome dots arranged on orbital rings, bands, meridians and strands around a spherical form. It exists because every AI product eventually needs to say "the model is working on it", and the standard vocabulary — spinners, progress bars, skeletons — says "the machine is busy", which gives the user no hint of *which cognitive stage* they are waiting on. The gap it fills: a wait indicator whose motion is a verb — searching, solving, composing — so the animation matches the cognitive stage the user is waiting on.

## The core ideas

### Visual grammar

- Strictly monochrome dots: light ink on dark surfaces, dark ink on light — never colored, never glowing.
- Two purpose-tuned sizes shipped as *separate designs*, not a scale factor: ~64 px for chat-avatar-level waits, ~20 px for inline-text waits. Dot count, dot size and speed are retuned per size.

### The nine states (pattern inventory)

Each state is a **verb the agent is doing** — never `idle`/`loading`:

1. `working` — particles travel on tilted orbits
2. `searching` — a scan meridian sweeps across a dotted globe
3. `solving` — bands scramble, then snap into a solved configuration
4. `listening` — a waveform travels through the rings
5. `connecting` — a constellation links itself up node by node
6. `weaving` — three strands braid around the sphere
7. `composing` — a multi-band sash undulates
8. `breathing` — a ring slowly morphs its shape
9. `shaping` — a dotted outline morphs circle → triangle → square

### Engineering facts (how the library is built)

- Plain 2D canvas, no WebGL.
- One shared clock: all orb instances resume in phase, never drift.
- `speed` multiplier and `paused` prop for orchestration.
- Offscreen instances pause via IntersectionObserver — no wasted frames.
- Under `prefers-reduced-motion`: one static representative frame.
- `role="img"` + `aria-label` on the container — the motion is decorative, the label carries the meaning.

### Philosophy

A spinner says "the machine is busy". A thought-orb says **"the intelligence is reasoning"**. Rotation, stagger and pulsation read as deliberation — gathering, weighing, deciding — not as a mechanical loop. Motion is quiet and monochrome so it feels like thought, not spectacle. Restraint reads as intelligence.

## When to use

- Any wait caused by a **model**: text generation, vision/scene analysis, prompt enrichment, transcription, summarization, agent tool loops.
- While an "AI action" button is disabled with its request in flight.
- As a panel-level placeholder when a long AI step (10 s+) replaces a list or a report.
- Inline in a sentence, next to streaming or staged status text.

## When NOT to use

- Pure network or disk waits (fetching a URL, saving a form) — use a plain spinner or skeleton; an indicator that "thinks" during a download is a lie.
- Deterministic progress with a known percentage — use a progress bar.
- Decorative idle animation when nothing is processing.
- Native/cheaper alternative: a 3-dot pulsing loader (a few CSS lines) carries no stage semantics — fine for sub-second waits where the stage is imperceptible anyway.
- A11y cost: any animated indicator needs a reduced-motion fallback and a programmatic label; if you cannot afford both, show a text status alone.
- Weight: the full library is canvas + nine variants. If you need one quiet loader, ~25 lines of CSS (below) recreate the core effect. Install the library only when you actually use multiple semantic states and want the hand-tuned motion.

## Core principles

1. **Thinking state, not loading state.** The orb expresses cognition. Copy uses cognitive verbs — thinking, analyzing, drafting, examining — never "Loading…" for AI steps.
2. **Semantic motion.** Match the orb variant to the actual stage (scan = inspection, breathe = composition, work = generation). One orb vocabulary per app.
3. **Monochrome and quiet.** Dots use the app's text/muted ink tokens, at most one accent moment. No rainbow, no glow spam.
4. **Two tuned sizes, never scaled.** ~16–20 px inline in buttons/sentences; ~48–64 px for panel placeholders. Retune dot count and speed per size.
5. **Cheap and deterministic.** Animate only `transform` and `opacity` (GPU-composited), `linear` rotation, staggered `animation-delay` with negative values so all instances start in phase.
6. **Motion + words.** Never leave motion alone beyond ~10 s: pair the orb with a status line (`aria-live="polite"`) that names the stage.
7. **Respect `prefers-reduced-motion`.** Render one static dotted frame instead of the animation.
8. **Always resolve.** An orb is a promise: end in a result, an error, or an explicit cancel — never an infinite orb.

## How to apply (checklist)

1. List every wait in the surface you are building; keep only the ones caused by a model or agent.
2. For each, name the cognitive verb (searching? composing? working?) and pick the matching variant — do not default to one generic state.
3. Pick the size class: ~16–20 px inline, ~48–64 px panel placeholder. Retune dot count/dot size/speed for that size; never scale one design into the other.
4. Ink the dots with the app's text color token (or muted); forbid gradients, glow and color.
5. Animate only `transform`/`opacity`; use a `linear` infinite rotation and negative `animation-delay` staggering so instances stay in phase.
6. Add `role="img"` + `aria-label` naming the stage, and pair with an `aria-live="polite"` status line.
7. For waits past ~8–10 s, rotate staged labels (~every 8 s) so time feels like progress: each label is one more "thought" the orb has finished.
8. Add a `prefers-reduced-motion: reduce` branch that shows one static dotted frame.
9. Guarantee resolution: success state, error state, or cancel — the orb must never spin forever.
10. One orb per waiting surface; three spinning orbs on one screen read as noise, not thought.

## Recreate the effect without the dependency

One shared component plus ~25 lines of plain CSS give the core mechanism (React shown; the CSS is framework-neutral). Three variants cover most needs.

### Component

```tsx
import type { CSSProperties } from "react";

export type OrbState = "working" | "scanning" | "breathing";
const DOTS: Record<OrbState, number> = { working: 8, scanning: 12, breathing: 10 };

export function ThinkingOrb({ state = "working", size = 20, label = "Thinking…" }: {
  state?: OrbState; size?: number; label?: string;
}) {
  const n = DOTS[state];
  return (
    <span className={`orb orb-${state}`} style={{ "--orb-size": `${size}px` } as CSSProperties}
          role="img" aria-label={label}>
      <span className="orb-spin">
        {Array.from({ length: n }, (_, i) => (
          <span key={i} className="orb-dot" style={{ "--i": i, "--n": n } as CSSProperties} />
        ))}
      </span>
    </span>
  );
}
```

### CSS (drop into the global stylesheet)

```css
.orb { position: relative; display: inline-block; width: var(--orb-size, 20px); height: var(--orb-size, 20px); vertical-align: -0.15em; }
.orb-spin { position: absolute; inset: 0; animation: orb-rotate var(--orb-speed, 1.8s) linear infinite; }
.orb-dot {
  position: absolute; top: 0; left: 50%;
  width: calc(var(--orb-size) / 7); height: calc(var(--orb-size) / 7);
  margin-left: calc(var(--orb-size) / -14);
  border-radius: 50%; background: var(--orb-ink, currentColor);
  transform-origin: 50% calc(var(--orb-size) / 2); /* pivot = orb center */
  transform: rotate(calc(var(--i) * 360deg / var(--n))); /* dots spread evenly on a circle */
}
@keyframes orb-rotate { to { transform: rotate(1turn); } }

/* working — dots on a tilted orbit, alternating weights (generation, enrichment) */
.orb-working { transform: rotate(-18deg) scaleY(0.72); }
.orb-working .orb-dot:nth-child(odd) { opacity: 0.55; width: calc(var(--orb-size) / 9); height: calc(var(--orb-size) / 9); }

/* scanning — fast rotation + opacity wave sweeping the dots (analysis, vision QA) */
.orb-scanning .orb-spin { animation-duration: 1.1s; }
.orb-scanning .orb-dot { width: calc(var(--orb-size) / 9); height: calc(var(--orb-size) / 9); animation: orb-scan 1.1s linear infinite; animation-delay: calc(var(--i) / var(--n) * -1.1s); }
@keyframes orb-scan { 0% { opacity: 0.12; } 15% { opacity: 1; } 50% { opacity: 0.25; } 100% { opacity: 0.12; } }

/* breathing — slow rotation + soft pulse (reflection, long composition, drafting) */
.orb-breathing { transform: rotate(-14deg) scaleY(0.8); }
.orb-breathing .orb-spin { animation-duration: 9s; }
.orb-breathing .orb-dot { animation: orb-breathe 2.6s ease-in-out infinite; animation-delay: calc(var(--i) / var(--n) * -2.6s); }
@keyframes orb-breathe { 0%, 100% { opacity: 0.18; transform-origin: 50% calc(var(--orb-size) / 2); } 50% { opacity: 1; } }

@media (prefers-reduced-motion: reduce) {
  .orb-spin { animation: none; }
  .orb-dot { animation: none !important; opacity: 0.85; }
}
```

**How the orbit works:** each dot sits at 12 o'clock and is pre-rotated by `rotate(i × 360°/n)` around the container's center (via `transform-origin` on the dot); the wrapper `.orb-spin` then rotates 360° linearly, so every dot travels the circle while staying evenly spaced. A static tilt (`rotate` + `scaleY` on `.orb-working` / `.orb-breathing`) gives the elliptical "sphere" read of the original. Variants change only speed, dot size and staggered opacity — never layout properties.

### Usage patterns

```tsx
{/* inline in an AI action button */}
<button disabled={busy !== null} onClick={runAnalysis}>
  {busy !== null ? <ThinkingOrb state="scanning" size={16} label="Analyzing…" /> : "Analyze"}
</button>

{/* panel placeholder with staged copy */}
<div className="orb-row">
  <ThinkingOrb state="breathing" size={56} label="Generating the scene plan" />
  <p className="hint" aria-live="polite">{stageLabel}</p>
</div>
```

Generic surface map:

| Surface | Variant | Size | Label pattern |
|---|---|---|---|
| AI action button (disabled while request in flight) | `scanning` | 16 px, inline before text | "Analyzing…" |
| Panel-level placeholder for a 10 s+ AI step | `breathing` | 48–64 px + staged copy | "Thinking…" → "Outlining…" → "Drafting…" |
| Pipeline/status row (voice, visuals, render jobs) | `working` | 14–20 px | "Generating visuals…" |
| Vision/inspection pass over frames or documents | `scanning` | 20 px | "Reading frames…" |

**Label rules:** use cognitive verbs — "Thinking…", "Analyzing…", "Drafting…", "Examining the frames…". Reserve "Loading…" for local fetches only. For long waits, rotate staged labels every ~8 s so time feels like progress: each label is one more "thought" the orb has finished.

## Anti-patterns

- **One generic spinner for every stage** — kills the semantics that make the pattern work.
- **Colored or glowing dots** — breaks the "quiet thought" read; stay monochrome.
- **Scaling one design to another size** (a 64 px design squeezed to 16 px) — retune dot count/size/speed per size.
- **Using it for non-AI waits** — a download spinner that "thinks" is a lie.
- **Motion without words past ~10 s** — always pair with a named-stage status line.
- **Infinite orb on failure** — every AI call must land on result/error feedback.
- **Animating `top/left/width`** — jank; only `transform` + `opacity`.
- **Ignoring `prefers-reduced-motion`** — show the static dotted frame.
- **Orbs everywhere** — one orb per waiting surface; three spinning orbs on screen read as noise, not thought.

## AI-slop warning

Once a pattern like this gets popular, it becomes the new spinner: generated clones paste a "breathing orb" onto every wait — including non-AI ones — with rainbow gradients, glow, three orbs per screen and no label. That version poisons exactly the contexts where the pattern works: a calm AI surface starts reading as circus. Typical AI misapplications: one default state everywhere (defeats semantic motion), scaled instead of retuned sizes, colored "to match the brand", infinite orbs on failed requests, and motion left alone past 10 s with no words. If the wait is not a model thinking, use a plain loader; if you cannot name the verb, you do not have a thinking state.

## Relations

- **loading-dev** — the broader loading-state vocabulary (skeletons, progress bars, spinners, staged loaders). This skill covers only the model-wait subset; route network/disk waits and known-percentage progress there.
- **liquid-gooey** — same author (Jakub Antalik), opposite motion language: liquid/blob spectacle vs quiet monochrome thought. Useful contrast when deciding whether a surface wants spectacle or deliberation; both ship hand-tuned variants rather than one generic loop.
- **beautiful-ui** — general beauty craft; orbs deliberately trade ornament for restraint, which is itself the aesthetic move. Consult it for the surrounding typography/spacing that keeps an orb-bearing surface calm.
