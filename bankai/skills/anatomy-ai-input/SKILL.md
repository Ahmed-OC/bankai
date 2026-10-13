---
name: anatomy-ai-input
description: Use when building or reviewing an AI chat prompt input (composer). Layer-by-layer anatomy—field, context bar, tool triggers, attachments, assist layer, controls, states, edge cases—with exact rules.
source: https://ibelick.com/anatomy-ai-input
category: essay
---

# Anatomy of an AI Input — the prompt input as a first-class component

Source: https://ibelick.com/anatomy-ai-input — Julien Thibeaut (@ibelick), design engineer and maintainer of prompt-kit (a component library for AI apps). Single essay, prose design guidance, no license stated. No code in the source; code below implements the essay's rules as plain mechanisms.

## What it is / Why it exists

The author has built AI inputs for months (the `prompt-input` component of prompt-kit) and distills the prompt composer into **8 layers**: Input Field, Context Bar, Tool Triggers, Attachment Zone, Assist Layer, Message Controls, State Layer, Edge Cases.

Thesis: when ChatGPT launched (November 2022) the input was "just a textbox and a button to send" — three years later it does much more. A good AI input *looks* simple but hides many details, and **every layer matters**. The default failure mode as a product grows is overload: "If something can live elsewhere move it, if you can group functionality behind a trigger, do it."

The input is also a place to invest in experience: "people remember great experiences, in a crowded AI market, that can make the difference" (e.g., a shader background for onboarding, a refined animation on first send).

## The core ideas

### 1. Input Field
- Multi-line growth with a **clear defined max height**; growth must not push the rest of the layout or jump the scroll.
- Keyboard contract: **Enter sends, Shift+Enter inserts a newline** — make it configurable in settings if needed.
- Placeholder is a guidance surface: use it to surface context, commands, or hidden features. Small details count — e.g., customize the **caret color to match the brand color**.
- Mobile: font-size **at least 16px to avoid Safari zoom** (or a proper viewport meta tag to stop auto-zoom). Typing must be stable: **no shifting lines, no auto-capitalization on mobile, no cursor jumps** (caret stays where the user expects).

### 2. Context Bar
- A group of controls that change how the model answers: model selector, mode (code, search, tools), memory, context.
- Sometimes you need none — "don't add it just for the sake of it. Try not to overload the input."
- Placement: **below the input field**, and visually **more discreet than the field itself**.
- Only frequent actions live here; everything else goes in a menu or settings.
- Every action keyboard-accessible; shortcuts optional. On tight mobile layouts, **labels+icons reduce to icons only**.
- Renders as chips (author's examples: `Research` + `ChatGPT 5.1` — an action chip plus a model chip).

### 3. Tool Triggers
- The escape valve when the context bar is too crowded. Placements: in the context bar, inside the input, as a dropdown, or as a **slash command**.
- Choose the pattern by **how many tools you expose and how often users need them**. "Don't add too much. Keep it simple."
- Triggers are **keyboard-first and appear fast** — the author makes slash commands *instant*. Never cause layout jumps (input moving or growing when a trigger opens).

### 4. Attachment Zone
- Files, images, videos, audio. "A fragile part because many things can go wrong." Usually a button in the context bar.
- Must cover four basics: **uploading, uploaded, failed upload, removing a file** — plus constraints: **size limits, file types, number of files**.
- Drag-and-drop: **clear highlight when a file enters the input**; preview above the input field or directly in the chat; **stack** multiple files; input must not jump.
- Errors: show them **near the input**, "avoid toast notifications."
- Speed: **optimistic updates** — show the file instantly with a preview, then sync in the background or on send.

### 5. Assist Layer
- Forms: **ghost text inside the field**, **inline suggestions while typing** (author cites Cursor's file-path suggestions), or **prompt suggestions/presets** above or below the input.
- Contract: "help and guide the user but not take over the input" — fast, non-intrusive, easy to ignore, keyboard-usable when needed.
- Easy to overlook, big product lift when done right. "Suggest when it makes sense… but don't over-suggest." (Author's preset chips: Learn / Analyze / Explain / Research.)

### 6. Message Controls
- **"Don't disable the controls."** Even when multiple concurrent messages aren't allowed, the user must still be able to type, correct something, or stop the response.
- Voice mode: show the voice button first and swap to send when typing starts, or keep both visible.
- **Send button turns into a stop button** while a response streams, so users can interrupt. All actions keyboard-accessible.

### 7. State Layer
- Five states: **idle, loading, streaming, error, success**.
- In loading/streaming, **don't lock the input** — user can still type or stop the response.
- Errors: input stays neutral and usable. **"Errors belong to the generation, not the typing"** — keep them out of the input (chat container, tool, etc.), no toasts, and always provide a way to **retry** (e.g., a retry button in the chat container).
- Simple rule: "keep the input usable in almost every state" — responses are long, so let users use the product while they wait.

### 8. Edge Cases
- Edge cases vary per product; the input rules don't: **predictable and keyboard-first**.
- **"Typing must stay instant"** — no lag, no jumps, no layout shifts when the field grows or shrinks.
- Input stays usable when the model is slow, the network is slow, or the product is still loading. **Never read-only while streaming. Don't steal focus when a response starts or ends.** On mobile, handle the OS keyboard covering the field.
- **Optimistic updates for most actions**; don't overdo animations; **clear the input right after sending**; **switch to the stop button without delay**.

## When to use / When NOT to use

Use when:
- Building any chat/prompt composer: chat apps, agents, copilots, AI search, inline AI assistants.
- Reviewing or auditing an existing AI input — check it against the 8 layers and the state rules (never read-only while streaming, errors out of the input).

Skip or trim when:
- The input is a single-purpose one-shot field (e.g., a search box with optional AI) — no context bar or tool triggers needed; "don't add it just for the sake of it."
- Users send one short line and never attach files — the attachment zone and multi-line growth add fragility with no payoff.

## How to apply

1. Start with a `<textarea>` (never `<input>`) that auto-grows to a max height without shifting layout; compute height from scrollHeight.
2. Wire keyboard: Enter → submit, Shift+Enter → newline; disable auto-capitalize on mobile; font-size ≥ 16px.
3. Add placeholder text that names the hidden capabilities (commands, context, "@"-mentions).
4. Place a context bar *below* the field, visually quieter than the field; only frequent controls; model/mode chips; icons-only on narrow viewports.
5. Move rare tools behind a slash command or dropdown; make the command list instant and keyboard-navigable.
6. Build the attachment lifecycle: uploading / uploaded / failed / removed states, file constraints surfaced up front, drag-over highlight, stacked previews, optimistic display, errors inline near the input (never toasts).
7. Keep message controls enabled in every state; swap send → stop the moment a message is submitted; clear the field immediately after send.
8. Model the composer as idle | loading | streaming | error | success; in all of them typing stays enabled; errors render in the chat container with a retry action.
9. Add an assist layer last (ghost text, inline suggestions, or presets) — ignorable, fast, keyboard-dismissable.
10. Stress-test edge cases: slow network, streaming in progress, mobile keyboard covering the field, focus theft on response start/end.

### Mechanism: auto-grow to a max height without layout jumps

```css
.prompt-input {
  width: 100%;
  resize: none;
  overflow-y: auto;          /* scrollbar only past max-height */
  min-height: 2.5rem;        /* ~1 line              */
  max-height: 12.5rem;       /* ~5 lines: the essay's "clear defined max height" */
  field-sizing: content;     /* modern browsers: auto-grow natively */
}
```

```js
// Fallback for browsers without field-sizing: content
function autoGrow(el) {
  el.style.height = 'auto';               // reset so scrollHeight measures content
  el.style.height = Math.min(el.scrollHeight, MAX_PX) + 'px';
  // container has fixed min-height matching 1 line so wrapping lines
  // push nothing below (e.g. the composer sits in a sticky footer).
}
textarea.addEventListener('input', () => autoGrow(textarea));
```

### Mechanism: Enter/Shift+Enter contract

```js
textarea.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' && !e.shiftKey && !e.isComposing) { // isComposing: IME safety
    e.preventDefault();
    if (canSubmit()) submit();
  } // Shift+Enter falls through: default newline behavior
});
```

### Mechanism: submit lifecycle (send → stop, optimistic clear)

```js
let controller = null;

async function submit() {
  const value = textarea.value.trim();
  if (!value || controller) return;   // disabled until content; no double-submit
  textarea.value = '';                // clear right after sending
  autoGrow(textarea);
  controller = new AbortController(); // send button -> stop button, no delay
  setSendButtonMode('stop');
  try {
    await streamCompletion({ value, signal: controller.signal }); // input stays editable
  } catch (err) {
    if (err.name !== 'AbortError') showErrorInChatContainer(err); // retry lives there
  } finally {
    controller = null;                // stop -> send, restore focus only if user had it
    setSendButtonMode('send');
  }
}

stopButton.onclick = () => controller?.abort(); // interrupt the stream
```

### Mechanism: drag-over highlight without layout shift

```css
.composer { position: relative; }
.composer::after {              /* overlay ring: adds no height, nothing jumps */
  content: '';
  position: absolute; inset: -2px;
  border: 2px dashed currentColor; border-radius: inherit;
  opacity: 0; pointer-events: none;
}
.composer[data-dragover='true']::after { opacity: 1; }
```

```js
composer.addEventListener('dragover', (e) => { e.preventDefault(); composer.dataset.dragover = 'true'; });
composer.addEventListener('dragleave', () => composer.dataset.dragover = 'false');
composer.addEventListener('drop', (e) => {
  e.preventDefault(); composer.dataset.dragover = 'false';
  for (const f of e.dataTransfer.files) addAttachmentOptimistic(f); // preview now, sync later
});
```

## AI-slop warning

AI-generated chat UIs reliably violate this essay in four ways:
1. **Disabling the textarea while streaming** (`disabled={isLoading}`) — the essay's hardest rule is the opposite: never read-only while the model works; keep send→stop, never a dead field.
2. **Toasts for upload and generation errors** — errors belong near the input (attachments) or in the chat container with retry (generation), never floating over the UI.
3. **Layout jumps**: fixed-height textareas that scroll internally from line 1, menus that grow the composer when opened, borders added on dragover that shift the input by 1–2px. All banned — use overlays and a reserved-height container.
4. **Everything crammed into the composer**: five dropdowns, model picker, tone picker, tool toggles visible at once. Move rare controls into menus or slash commands; if a context bar isn't needed, ship without one.
Also common: swapping send/stop with a slow cross-fade (the essay: switch "without delay"), and focus-stealing when streaming starts.

## Relations

- **beautiful-ui** — prompt bar / hero input styling patterns from the same canon; pairs with this skill's structural rules for the visual treatment of the composer.
- **agentation** — agentic UX patterns (tool runs, interrupts, streaming surfaces) that this input's state layer and stop button must support.
- **cmdk** — the command-menu mechanics behind the "tool triggers" layer: instant, keyboard-first slash/dropdown lists that open without layout shifts.
- **web-interface-guidelines** — general keyboard, focus, and input rules (16px mobile font, focus rings, no focus theft) that this essay specializes for AI composers.
