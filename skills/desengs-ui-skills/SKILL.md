---
name: desengs-ui-skills
description: Use when polishing or reviewing any agent-built UI surface — interactive states, empty states, form errors, density, motion performance, accessibility, or design-system consistency.
source: https://www.ui-skills.com/; https://github.com/ibelick/ui-skills
category: reference
---

# UI Skills (desengs) — a seven-skill routing system for polishing agent-built interfaces

Source: [ui-skills.com](https://www.ui-skills.com) / [ibelick/ui-skills](https://github.com/ibelick/ui-skills) by ibelick (Interface Office), MIT. Listed on desengs.com as "UI Skills — a set of skills to polish interfaces built by agents". The source ships 7 composable skills plus a "Playbook" of 46 distilled lessons. Its defaults are Tailwind + `motion/react` + `cn`; every mechanism below is ported to plain CSS/JS — use the project's existing design tokens and classes before introducing anything new, and CSS transitions/WAAPI instead of an animation library.

## What it is / Why it exists

Agents ship interfaces that work but feel unfinished: buttons with no pressed or focused state, errors rendered far from their field, spinners where a content-shaped skeleton belongs, animation nobody asked for. UI Skills turns "polish" into a routable, evidence-driven task: one routing skill, one anti-slop baseline, one read-only audit method, and four fixers (accessibility, motion performance, design-doc generation, metadata). The set exists so an agent loads the smallest useful subset instead of a monolithic style guide, and so every audit finding survives a proof gate before it becomes a change.

## The core ideas

### Skill 1 — `ui-skills-root` (routing layer)

The entry skill. It routes a UI task to the smallest useful context.

1. Decide if the task is UI-related; if not, stop ("no skill needed").
2. Identify the likely category (craft, visual, layout, motion, accessibility, systems).
3. Select the smallest useful skill set: prefer 1 skill, use 2 only for two clear angles, 3 only for broad review/redesign. **Never more than 3.**
4. Route by topic first, then stack, then specificity. Prefer specific over broad skills; prefer the most specific craft/layout skill for quick cleanups.
5. If the goal is unclear, ask **one short question**, then implement.

### Skill 2 — `baseline-ui` (the core anti-slop baseline)

An opinionated baseline to prevent "AI-generated interface slop".

Components & primitives:
- Use native elements (`button`, `a`, `input`, `select`, `details`) first; never hand-build keyboard/focus behavior.
- Every icon-only button MUST have an `aria-label`.
- Use a confirmation (`confirm()` or a dialog) for destructive or irreversible actions.
- Structural skeletons for loading states (not spinners when avoidable).
- `height: 100dvh` instead of `100vh`; respect `safe-area-inset` on fixed elements.
- Show errors next to where the action happens. Never block paste in inputs.

Animation:
- **Never add animation unless it is requested.** Animate only compositor props (`transform`, `opacity`).
- Never animate layout properties (`width`, `height`, `top`, `left`, `margin`, `padding`).
- `ease-out` on entrances; interaction feedback ≤ 200ms; no custom easing curves.
- Pause looping animations off-screen; respect `prefers-reduced-motion`.

Typography:
- `text-wrap: balance` on headings, `text-wrap: pretty` on paragraphs.
- `font-variant-numeric: tabular-nums` for data (dates, counts, durations).
- `text-overflow: ellipsis` or `-webkit-line-clamp` in dense UI.
- Never adjust `letter-spacing` unless explicitly requested.

Layout & performance:
- Fixed `z-index` scale via variables (no arbitrary values).
- Never animate large `blur()`/`backdrop-filter` surfaces; never keep `will-change` outside an active animation; never use `useEffect` for what is render logic.

Design:
- No gradients unless requested; no purple/multicolor gradients; no glow as a primary affordance.
- Empty states get **one clear next action**. One accent color per view. Reuse existing tokens before creating new ones.

### Skill 3 — `improve-ui` (evidence-driven audit, read-only)

Audit one product surface against the system that actually governs it. Core discipline:

- **Boundaries:** never modify product source during the audit; write findings/plans only (e.g. a `design-plans/` directory outside product source). No dependency installs, no commits.
- **Trace, don't grep:** start from routes/layouts and trace the rendered path (imports, props, resolved tokens, CSS inheritance). Shared names and visual similarity do not establish a connection.
- **Proof gate — a candidate is a finding only with all three proofs:**
  1. **Contract** — a binding design decision or a direct contradiction in user-facing presentation ("prefer", "generally", and mere repetition are not contracts).
  2. **Runtime** — the cited value actually reaches the surface through the traced path.
  3. **Correction** — exactly one change, named in terms of the existing system. If it requires inventing product intent, reject it.
- **Vet:** try to falsify each candidate before reporting; delete overlapping findings. Report **at most three**, ordered by confidence and user impact, then ask which to turn into a plan. "No supported findings" is a valid result.
- Write self-contained plans: the executor has zero context from the audit.

### Skill 4 — `fixing-accessibility`

Nine categories by priority; fix critical first, prefer minimal diffs, prefer native HTML before ARIA.

1. **Accessible names (critical):** every control has an accessible name; icon-only buttons get `aria-label`; inputs are labeled; meaningful link text; decorative icons `aria-hidden`.
2. **Keyboard access (critical):** nothing interactive is a `div` with `onClick`; everything reachable by Tab; visible focus; no `tabindex > 0`; Escape closes overlays.
3. **Focus & dialogs (critical):** trap focus in open modals, set initial focus inside, restore focus to the trigger on close.
4. **Semantics (high):** native elements over roles; no skipped heading levels; real `ul`/`ol`/`table` markup.
5. **Forms & errors (high):** errors linked via `aria-describedby`; `aria-invalid` on bad fields; helper text associated; **disabled submit actions must explain why**.
6. **Announcements:** `aria-live` for critical errors, `aria-busy`/status text for loading; toasts never the only channel; `aria-expanded`/`aria-controls` on expandables.
7. **Contrast & states:** sufficient contrast; hover-only interactions have keyboard equivalents; disabled never relies on color alone; never remove focus outlines without a visible replacement.
8. **Media & motion:** correct alt text; `prefers-reduced-motion` respected; no autoplaying sound.
9. **Tool boundaries (critical):** minimal changes; don't refactor unrelated code; don't migrate libraries.

```jsx
// Form error wiring (React)
<input
  id="email" aria-invalid={!!err} aria-describedby="email-err"
  value={email} onChange={(e) => setEmail(e.target.value)}
/>
{err && <p id="email-err" role="alert" className="field-error">{err}</p>}
```

### Skill 5 — `fixing-motion-performance`

Glossary: **composite** = `transform`, `opacity`; **paint** = color, borders, gradients, filters; **layout** = size, position, flow.

- **Never (critical):** interleave layout reads and writes in one frame; drive animation from `scroll` events/`scrollY`; run `requestAnimationFrame` loops without a stop condition; animate layout continuously on large surfaces.
- **Mechanism:** default to `transform`/`opacity`; JS-driven animation only when interaction requires it; one-shot effects are more acceptable than continuous motion; **prefer downgrading technique over removing motion**.
- **Measurement:** measure once, batch all reads before writes; use FLIP for layout-like transitions.
- **Scroll:** prefer CSS scroll/view timelines or `IntersectionObserver`; pause off-screen; scroll-linked motion must not trigger continuous layout/paint on large surfaces.
- **Paint/layers/blur:** paint animation only on small isolated elements; don't animate inherited CSS variables; `will-change` temporary and surgical; blur ≤ 8px, one-shot, never continuous, never large surfaces.
- **Boundaries:** apply within the existing stack; never partially migrate animation styles inside one component.

```css
/* Wrong: layout + slow. Right: compositor + fast */
.card { transition: border-color .12s ease-out, transform .12s ease-out; }
.card:active { transform: scale(.98); }
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: .01ms !important; transition-duration: .01ms !important; }
}
```

### Skill 6 — `create-design-md`

Document the design language that *governs* a codebase in a `DESIGN.md` — not every value that happens to exist.

- Evidence pipeline: `role → value → source → scope → recurrence → confidence`. Omit anything uncertain, local without a contract, or not implementation-relevant.
- **Do not convert repetition into intent**: a value used 5 times is not a token. Only named shared tokens/variants/governance sources become normative YAML; prose rules need explicit guidance or a shared owner used by ≥2 audited surfaces.
- Every sentence in the doc must change an implementation choice. No vague advice ("keep it polished"), no invented brand rationale.
- Validates structure before publishing; keep accepted decisions when updating.

### Skill 7 — `fixing-metadata`

Titles, canonical URLs, Open Graph/Twitter cards, favicons, JSON-LD. Priorities: no duplicate/competing tags (critical); title + description + canonical + `og:url` must agree; absolute OG image URLs; verify social cards on a real URL; `lang` attribute correct; minimal diffs. For local/internal tools only the basics apply: one `<title>`, a correct `lang` attribute, favicon, `theme-color`.

### The Playbook — 46 distilled lessons (grouped)

**Layout stability & structure:** `aspect-ratio` prevents jumps while media loads; inner radius = outer radius − padding; group with spacing before dividers; shadows show depth, borders show structure; fade scrollable edges with `mask-image`; preview 16–32px of the next item in scroll lists.
**Typography & copy:** `text-wrap: balance` headings / `pretty` body; `tabular-nums` for numbers; 60–75 characters per line; line-height ≈ 1.1 for short headings; tighter letter-spacing only at display sizes; `line-clamp` long titles; sentence case for labels (never ALL CAPS).
**Interaction & states:** ≥44px touch targets; `:active` scale ≈ 0.96 press feedback; visible `:focus-visible` rings; ~12px between nearby bordered controls; full-width buttons stay inside page margins; confirm destructive actions; show each form error below its field; visible labels, never placeholder-as-label; disabled states never color-only.
**Color:** one accent per view, secondary actions neutral; brand color reserved for links/actions; never color alone for status (add text/icon); neutral borders around images; avoid glow on primary buttons; muted text must keep contrast.
**Motion:** `ease-out` entrances; entrance starts near 95% scale, never from zero; ≤200ms feedback; interruptible CSS transitions; match enter/exit animations; stagger first-load hero only (~100ms); repeated actions (tab switches) stay instant; short fades for exits/menus; cross-fade changing icons; springs avoided for feedback (they wobble); tooltips open faster once one is already open; blur-soften label changes; animate popovers from their trigger.
**Loading & empties:** skeletons match the real content they replace (skip spinners); empty states give one clear action.

### Concrete patterns (plain CSS + framework-neutral markup)

Complete interactive-state recipe for a control (apply to every button variant — primary, ghost, card-like):

```css
button.primary {
  background: var(--primary); color: #fff; border: none;
  border-radius: 12px; padding: 12px 24px; cursor: pointer;
  transition: filter .12s ease-out, transform .08s ease-out;
}
button.primary:hover:not(:disabled) { filter: brightness(1.1); }
button.primary:active:not(:disabled) { transform: scale(.98); }   /* press feedback */
button.primary:focus-visible { outline: 2px solid var(--primary); outline-offset: 2px; }
button.primary:disabled { opacity: .45; cursor: not-allowed; }    /* + explain why in UI */
```

Empty state with one clear action (playbook rule):

```jsx
{items.length === 0 && (
  <div className="empty">
    <p>No campaigns yet.</p>
    <button className="primary" onClick={onCreateFirst}>Create your first campaign</button>
  </div>
)}
```

Layout-stable media + density:

```css
.media-grid img { aspect-ratio: 16 / 9; height: auto; }  /* no jump on load */
.timestamp { font-variant-numeric: tabular-nums; }
.panel h2 { line-height: 1.15; text-wrap: balance; }
.list-item strong { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
:root { --z-nav: 10; --z-overlay: 100; }                  /* fixed z-index scale */
```

Skeleton matched to content (not a spinner):

```css
.skeleton { border-radius: 10px; background: var(--surface-2, #e5e7eb); position: relative; overflow: hidden; }
.skeleton::after { content: ""; position: absolute; inset: 0; transform: translateX(-100%);
  background: linear-gradient(90deg, transparent, #ffffff12, transparent);
  animation: shimmer 1.2s ease-out infinite; }
@keyframes shimmer { to { transform: translateX(100%); } }
@media (prefers-reduced-motion: reduce) { .skeleton::after { animation: none; } }
```

### Anti-patterns

- Gradients, glows, or "AI purple" as primary affordances; adding unrequested animations.
- Animating `width`/`height`/`top`/`left`; scale-from-zero entrances; springs for simple feedback; >200ms interaction feedback; entrance animation on repeated actions like tab switches.
- Spinners where a content-shaped skeleton belongs; skeletons that don't match final layout.
- Color-only status; placeholder-as-label; hover-only affordances; removed focus outlines; disabled buttons that don't explain why; `div onClick` as a button.
- Errors rendered far from the field/action; toasts as the only error channel.
- `letter-spacing` tweaks, arbitrary `z-index`, new colors when shared tokens exist, `will-change` left on permanently, `useEffect` for render logic.
- Inventing design intent during audits (repetition ≠ contract); repository-wide inconsistency sweeps instead of tracing the rendered surface; reporting more than 3 findings.

## When to use / When NOT to use

Use:
- Any time a UI surface "works but feels off" — before calling any screen, component, or polish pass done.
- Adding a new interactive control, form, list, empty state, or loading state.
- Reviewing an existing surface read-only (`improve-ui`) or documenting its design language (`create-design-md`).

NOT:
- Not for greenfield information architecture or visual identity decisions — this set polishes and verifies, it does not design.
- Not all seven skills at once: the routing rule caps any task at 3.
- Not for non-web UIs (the numbers assume HTML/CSS in a browser; React shown where relevant).
- Never `improve-ui` as a license to refactor: audits produce findings and plans, not diffs.

## How to apply

1. **Route first** (`ui-skills-root`): confirm the task is UI; pick 1–3 skills (never more); if the goal is unclear, ask one short question, then implement.
2. **Targeted fix:** apply the matching rule list (baseline, a11y, motion, metadata) to the touched code only.
3. **Broad review / polish pass** — ordered by leverage; each step is a small targeted diff, never a rewrite:
   1. **Focus rings everywhere.** Don't stop at inputs — add `:focus-visible` outlines (2px accent, `outline-offset: 2px`) to every custom button, card, chip, tab, and disclosure control.
   2. **Press feedback.** Add `:active { transform: scale(.98) }` with `transition: transform .08s ease-out` to every clickable control. Never scale below ~0.96, no spring.
   3. **Explain disabled actions.** If a submit is disabled while required fields are empty or a job is running, add an inline hint next to it instead of a silently dead button.
   4. **Empty states with one CTA.** Text-only empties get one clear action button that navigates or actuates ("Create your first …").
   5. **Wire form errors properly.** Error elements get `role="alert"`, linked via `aria-describedby` + `aria-invalid` on the offending input, kept directly below the field/action (baseline: errors next to where the action happens). `aria-live` for async failures.
   6. **Layout stability + skeletons.** Give media and embeds a fixed `aspect-ratio`; while busy, render 2–3 skeleton blocks matching the real grid instead of text-only feedback.
   7. **Typography pass.** `text-wrap: balance` on headings, `pretty` on paragraphs, `tabular-nums` on dates/counts, `line-height: 1.15` on headings, `line-clamp` on long descriptions.
   8. **Hit areas & density.** Raise short controls (nav buttons, chips) to ≥40–44px height; keep ~12px gaps between bordered control groups.
   9. **Motion hygiene.** One global `prefers-reduced-motion` block; transitions only on `transform`/`opacity`/`border-color`/`filter` at 100–180ms `ease-out`; tab switches stay instant.
   10. **System coherence.** Introduce a `--z-*` scale before any overlay/toast work; nested radii follow inner = outer − padding (e.g. panel 16 → card 12 → input 8); one accent per view — keep the status accent reserved for status, the primary color for actions.
4. **During the pass:** for each violation — quote it, say why it matters in one sentence, propose the code-level fix.
5. **After:** verify against the anti-patterns list; prefer many small, targeted diffs over rewrites.
6. **Audits:** run the improve-ui proof gate (contract + runtime + correction); report at most 3 findings; write self-contained plans for the chosen ones.

## AI-slop warning

Typical AI misapplications of this set:
- Loading every skill and rewriting whole surfaces instead of routing to the smallest subset — the set's whole value is restraint.
- "Polishing" by adding unrequested animation, gradients, or glow — the baseline bans each.
- Fixing accessibility by sprinkling ARIA over `div`s instead of using native elements.
- In audits: converting repetition into intent, grepping class names instead of tracing the rendered path, or reporting 10 vague findings instead of ≤3 proven ones.
- In `DESIGN.md`: padding the doc with every value found in the codebase plus vague advice ("keep it polished") that changes no implementation choice.
- Spinners everywhere, and skeletons whose shape doesn't match the content they replace.

## Relations

- **desengs-web-interface-guidelines** — the deeper micro-craft catalog (typography, touch, perceived performance, selection states). Overlaps on focus rings, press feedback, and density with no numeric contradictions; use it for per-topic depth and this skill as the router plus audit discipline.
- **desengs-component-gallery** — visual reference for what "polished" looks like across real products; galleries show the target, this skill supplies the enforceable constraints and verification lists.
- **desengs-krehel-skills** — another agent-facing composable skill set; compare its routing and composition philosophy before writing new sub-skills of your own.
