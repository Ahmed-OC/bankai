---
name: desengs-agentation
description: Use when a human reviews a running UI and feedback must reach a coding agent as structured, greppable context — selectors, source lines, severity, lifecycle — instead of prose like "the blue button in the sidebar".
source: https://www.agentation.com/; https://www.agentation.com/schema; https://www.agentation.com/features; https://www.agentation.com/mcp
category: tool
---

# Agentation (desengs) — visual UI feedback made machine-readable for coding agents

Source: https://www.agentation.com — npm `agentation` (React toolbar) + `agentation-mcp` (server), repo `benjitaylor/agentation`, by Benji Taylor, Dennis Jin, Alex Vanderzon. Free for individuals and internal company use; commercial license only when redistributed inside a product you sell. Note: despite the name, this is NOT a component library for agent chat UIs — it is the human-eyes → agent-codebase feedback channel, built on an open Annotation Format Schema (AFS 1.1).

## What it is / Why it exists

A human clicks an element in a running app, writes a note, and the tool emits a structured, machine-readable annotation — CSS selector, React component tree, source `file.tsx:42`, position, severity. The agent greps the codebase and fixes the exact element instead of guessing which button you meant.

Why it exists: existing agent protocols (MCP, A2A, ACP) transport tool calls and messages, but none defines a **UI feedback grammar** — the "human points at pixel, agent must find the code" problem. AFS 1.1 fills exactly that gap. Design goals, verbatim from the schema: agent-readable, framework-agnostic (React gets extra context), tool-agnostic (any emitter, any consumer), human-authored, minimal core.

The pipeline: toolbar (hover, click, annotate) → annotation object (JSON, AFS 1.1) → markdown copy-paste OR HTTP POST (default port 4747, loopback-bound) → MCP server → agent reads, acknowledges, fixes, resolves.

## The core ideas

### 1. Replace adjectives with addresses
"The blue button in the sidebar" → `.sidebar > button.primary`. Buttons and links are auto-named by their text content, so agents can grep for the label they see. The entire value of an annotation is whether the agent can locate the code in one grep.

### 2. The vocabulary — encode intent, severity, kind, status
- `intent`: `"fix" | "change" | "question" | "approve"` — approval is first-class data, not silence.
- `severity`: `"blocking" | "important" | "suggestion"` — three levels, no stars, no numbers.
- `kind`: `"feedback"` (default) | `"placement"` (request a component: carries `componentType`, `width`, `height`, `scrollY`, optional `text`) | `"rearrange"` (carries `selector`, `label`, `tagName`, `originalRect`, `currentRect`). The docs call layout results "spatial hints, not pixel-perfect" — treat them as intent, not a spec.
- Status lifecycle: `pending → acknowledged → resolved | dismissed`, with `resolvedAt` (ISO) and `resolvedBy: "human" | "agent"`.
- `thread`: an array of `{id, role, content, timestamp}` — clarifying questions attach to the annotation, not to a new chat message that loses the reference.

### 3. Minimal required core, optional everything
The JSON Schema (draft 2020-12) `required` array is exactly: `id`, `comment`, `elementPath`, `timestamp`, `x` (percent of viewport width, 0–100), `y` (px from document top; viewport px if `isFixed`), `element` (tag). Recommended: `url`, `boundingBox {x, y, width, height}`. Optional: `reactComponents`, `cssClasses`, `computedStyles`, `accessibility`, `nearbyText`, `selectedText`, `sourceFile` (`path:line:column`), `attributes`. Emit the 7 required fields always; add context only when it changes the fix.

### 4. Detail levels gate noise
- **Compact** — quick fixes, no React data.
- **Standard** — location + classes, user components only.
- **Detailed** — bounding boxes + nearby text, React tree smart-matched to CSS classes.
- **Forensic** — computed styles + every component including framework internals.
Pick per task: typo → Compact; layout bug → Forensic. Default to Standard.

### 5. Text beats screenshots
No screenshots, by design. Selectors, source paths, component trees and nearby text are searchable; pixels are not. Do not bolt a screenshot pipeline onto this pattern — if you need visuals, describe the delta.

### 6. Feedback is a conversation, not fire-and-forget
Nine MCP tools: `agentation_list_sessions`, `get_session`, `get_pending`, `get_all_pending`, `acknowledge`, `resolve` (with summary), `dismiss` (with reason), `reply` (thread message), `watch_annotations` (blocks until a batch arrives; `batchWindowSeconds` default 10/max 60, `timeoutSeconds` default 120/max 300). Events stream over SSE in an envelope (`annotation.created`, `thread.message`, `session.closed`) carrying a monotonic `sequence` for ordering and replay:

```json
{ "type": "annotation.created", "sessionId": "sess_01",
  "sequence": 42, "timestamp": "2026-10-09T10:00:00.000Z",
  "annotation": { "id": "ann_k8x2m", "status": "pending", "...": "..." } }
```

### 7. The overlay itself is a designed instrument
Numbered markers = single element or text selection; green markers = multi-select or area. Hover a marker to preview its target; click to edit; right-click always opens the editor. Toolbar is draggable; single-key shortcuts (L layout, P pause, H hide markers, C copy, S send, X clear) are active only while the toolbar is open and fully disabled while typing in inputs; only the global toggle (Cmd/Ctrl+Shift+F) and Esc work everywhere. Steal this discipline for any review overlay you build: reviewer mode must be enterable, escapable, and never hijack the page's own keys.

## Mechanisms in plain code

The replicable core — you can rebuild the whole value with a console snippet and a markdown block:

```js
// 1. Annotate: capture machine identity, not adjectives
function annotate(el, comment, meta = {}) {
  const r = el.getBoundingClientRect();
  return {
    id: 'ann_' + Math.random().toString(36).slice(2, 8),
    comment,                                    // the only human field
    element: el.tagName.toLowerCase(),
    elementPath: cssPath(el),
    x: +((r.x / innerWidth) * 100).toFixed(1),  // % of viewport width
    y: Math.round(r.y + scrollY),               // px from document top
    timestamp: Date.now(),
    intent: meta.intent ?? 'fix',
    severity: meta.severity ?? 'suggestion',
    status: 'pending',
  };
}

// 2. Selector: stable hooks first, never raw position
function cssPath(el) {
  if (el.id) return '#' + CSS.escape(el.id);
  const qa = el.getAttribute('data-qa');
  if (qa) return `${el.tagName.toLowerCase()}[data-qa="${qa}"]`;
  const cls = [...el.classList].join('.');
  return el.tagName.toLowerCase() + (cls ? '.' + cls : '');
  // nth-child chains are banned: they break on the first sibling edit
}
```

```js
// 3. React component tree via the fiber walk (React 18+)
function reactTree(el) {
  const key = Object.keys(el).find(k => k.startsWith('__reactFiber$'));
  const names = [];
  for (let f = el[key]; f; f = f.return) {
    const t = f.type;
    if (typeof t === 'function') names.push(t.displayName || t.name || 'Anonymous');
  }
  return names.reverse().join(' > '); // "App > Dashboard > SubmitButton"
}
```

Serialize to labeled one-per-line markdown — this block IS the product; paste it into any agent chat:

```markdown
## Annotation 1 — fix (blocking)
Element: button
Path: button.submit-btn
React: App > Dashboard > SubmitButton
Source: src/components/Button.tsx:42
Position: 62.5% from left, 1840px from top
Feedback: Button is cut off on mobile viewport
Severity: blocking
```

Agent-side loop (watch mode, the whole contract):

```js
for (;;) {
  const batch = await watchAnnotations();          // blocks, returns batch
  for (const a of batch) {
    acknowledge(a.id);                             // pending -> acknowledged
    // read a.thread; reply with questions instead of guessing
    await fix(a);                                  // grep elementPath/sourceFile, edit, verify in browser
    resolve(a.id, 'summary of what changed');      // resolvedBy: 'agent'
  }
}
```

## When to use

- Iterating on a running app with an agent that has codebase access (Claude Code, Codex, Gemini, Grok) — review passes with more than ~3 issues.
- Handing designer/QA feedback to an agent without translating to file paths by hand.
- Spatial asks: "put an 800×400 Hero here" → `kind: "placement"` with geometry, instead of a paragraph of layout description.
- Any loop where the fix must be verified then closed out — the pending/acknowledged/resolved lifecycle is the audit trail.
- Install the real thing when: React 18+, desktop browser, recurring human↔agent review, MCP available. It also reaches open shadow roots and same-origin iframes, and offers `portalContainer` for modals/popovers — hand-rolled selectors usually miss those.

## When NOT to use

- One one-shot fix: paste `src/components/Button.tsx:42` plus a sentence into the chat. Watch-mode infrastructure for a single note is agent theater.
- No codebase access (agent can't grep) or static marketing pages — nothing to address.
- You need visuals: the format is text-only by choice; reach for a screenshot-and-circle tool instead, and expect worse agent precision.
- Non-React stacks get only tag/class/geometry — if your classes are generated hashes, adopt stable `data-qa` attributes first or the selectors are noise.
- When installing is overkill, replicate by hand: DevTools → inspect element → copy selector → note the source file → write the labeled markdown block above. Five lines, zero dependencies, same agent outcome.

## How to apply

1. Authoring: one issue per annotation; be specific ("cut off below 768px", not "looks broken"); include viewport/context.
2. Use text-selection mode for copy changes — the quoted `selectedText` ends up in the output, so the agent greps the string.
3. Pause animations before annotating moving targets (P); the freeze stops most CSS/video, not all third-party libraries.
4. Reserve `blocking` for things that ship broken; spray it everywhere and severity stops filtering anything.
5. Give elements stable `data-qa` attributes; configure copy format to emit them (`copyFormat={{ attribute: "data-qa" }}`) so Copy returns grep-ready hooks.
6. Source detection: enable in dev mode; supported bundlers are Vite, Next.js, Webpack, Turbopack; the Source line (`file.tsx:42`) is the single highest-value field — prioritize emitting it.
7. Agent side: acknowledge before fixing, read the thread, `reply` with a clarifying question rather than guessing, `resolve` with a summary, `dismiss` with a reason. Never leave annotations pending forever.
8. Annotation markers inside iframes keep frame geometry in child coordinates so markers survive page scroll — copy this if you build markers.
9. Persistence is per-page localStorage, 7 days; use the MCP server as the shared store across pages and sessions.
10. In critique mode the agent flips the channel: headed browser, scrolls top-to-bottom, adds 5–8 design annotations itself. Self-driving mode has it critique and fix, resolving annotations as it goes.

## AI-slop warning

- **Annotation theater**: pipelines that emit rich metadata no agent ever reads, statuses nothing transitions, threads nobody opens. If the consumer loop (acknowledge → fix → resolve) isn't real, delete the pipeline.
- **Fake precision**: `div:nth-child(3) > span:nth-child(2)` looks machine-readable but is positional garbage after one edit. Never emit a selector you haven't derived from a stable hook (id, `data-qa`, semantic class).
- **Invented context**: fabricating React trees or computed styles to look thorough. Emit only what is actually in the DOM at capture time; a wrong component tree actively misdirects the grep.
- **Severity inflation** and **intent vagueness**: every note "blocking" and "fix" makes the vocabulary worthless — `question` and `approve` exist so the agent can rank and even skip.
- Over-engineering: building a custom toolbar/database/protocol when the labeled markdown block pasted into chat does the identical job for a solo workflow. Start with the markdown; add infrastructure only when the loop outgrows paste.
- Do not confuse this with agent-facing UI polish (thinking states, streaming text) — that is a different skill; bolting "watch mode" onto a one-shot request is the same cliché as a fake progress bar.

## Relations

- **desengs-beautiful-ui** — the other half of the loop: how the agent talks to humans (streaming text, thinking states, approval cards, tool chips). Agentation is human→agent; Beautiful UI is agent→human. A complete agent product needs both directions.
- **desengs-anatomy-ai-input** — the typed-input entry point for agent conversations; Agentation is the point-at-the-pixel complement when words like "the blue button" fail. Use the input box for intent, annotations for location.
- **desengs-thinking-orbs** — honest, verb-based progress states; its discipline (state must name what the agent is actually doing) is the antidote to the fake "acknowledged/resolved" theater this skill warns against.
- **desengs-loading-dev** — loading-state patterns for the waits this loop creates (watch mode blocks up to `timeoutSeconds` 120–300 while the human annotates).
