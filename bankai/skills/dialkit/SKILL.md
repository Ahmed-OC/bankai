---
name: dialkit
description: Use when tuning live UI values (spacing, color, springs, curves) needs in-app panels, versioned presets, or key-driven scrubbing instead of edit-reload loops.
source: https://joshpuckett.me/dialkit/; https://github.com/joshpuckett/dialkit
category: library
---

# DialKit — every running value gets a dial: live control panels for tuning interfaces

Source: https://joshpuckett.me/dialkit/ — Josh Puckett (author of Interface Craft; see interface-craft). MIT licensed. Depth lives in the GitHub README and `docs/reference.md`. This skill distills both.

## What it is / Why it exists

Despite the name, DialKit ships no rotary knobs. It is a floating parameter panel in the dat.GUI/Leva lineage: declare values in code, get sliders/toggles/pickers in a draggable panel over the running app, tune live, save versions, copy results back into config. "Dial" is the abstraction: any running value becomes scrubbable — via pointer, wheel, or a held key — without touching code.

Why designed: visual values (radii, shadows, springs, easings) tuned through edit-save-reload loops kill iteration flow, and animation timing is worst-hit because you must re-trigger the animation every reload. DialKit wires a persistent editor into the live render so tuning a spring is a 10-second drag instead of a 10-reload session. The copy-back step is treated as a first-class feature: **Copy** puts the current values plus a config-update instruction on the clipboard, closing the loop from panel to source.

Adapters with one API surface: React 18+ (`useDialKit` from `dialkit`), Solid 1.6+ (`dialkit/solid`), Svelte 5.8+ (`dialkit/svelte`), Vue 3.3+ (`dialkit/vue`), and vanilla JS (`dialkit/vanilla`, zero runtime dependencies, works without a bundler via `dist/vanilla/browser.global.js`).

## The core ideas

### 1. Config is the UI — control type inference

A plain object becomes the panel; keys become labels (camelCase → words). No per-control JSX:

| Config value | Control |
|---|---|
| `[default, min, max, step?]` | Slider with explicit range |
| bare number (`scale: 1.2`) | Slider, range inferred |
| boolean | Toggle |
| hex / RGB / HSL / OKLCH / Display P3 string | Color picker |
| other string | Text input |
| `{ type: "select" \| "text" \| "color" \| "image" \| "pad" \| "spring" \| "easing" \| "action" }` | Explicit control |
| nested object | Folder (`_collapsed: true` starts it closed; metadata omitted from values) |

Inference table for bare numbers (memorize — it is the library's opinion about "sensible ranges"):

| Starting value | Min | Max | Step |
|---|---|---|---|
| 0–1 | 0 | 1 | 0.01 |
| >1 to 10 | 0 | value × 3 | 0.1 |
| >10 to 100 | 0 | value × 3 | 1 |
| >100 | 0 | value × 3 | 10 |
| negative | value × 3 | −value × 3 | 1 |

Explicit tuples without a step use `0.01` for ranges ≤1, `0.1` ≤10, `1` ≤100, `10` above. Values are clamped and snapped to step.

### 2. Scrub-first input model — the actual "dial"

Every slider is reachable three ways without aiming at its track: hold its assigned key and **scroll**, **drag** horizontally anywhere, or **move** the pointer (`interaction: "scroll" | "drag" | "move" | "scroll-only"`). `scroll-only` needs no key. Toggles flip on key press. Arrow keys also adjust while the key is held.

Precision is a first-class dimension (`mode`): `fine` = 1% of range per tick, `normal` = the slider's step, `coarse` = 10%. This is the knob-heritage detail: coarse to traverse, fine to land, no mode-switch UI needed.

Shortcuts are declared per dot-path (`"shadow.blur": { key: "b", modifier: "alt", interaction: "drag", mode: "fine" }`), shown as pill badges that highlight when held, and auto-disabled while any input, button, or keyboard-operated control has focus — so typing "b" in a text field never scrubs.

### 3. Keyboard parity (the real slider a11y pattern)

Every control is fully operable by keyboard, shortcut or not: Tab to a slider; arrows adjust one step; Shift+Arrow or PageUp/Down adjusts ten; Home/End hits bounds; Enter opens a numeric editor (Enter commits, Escape cancels, Tab commits and advances). XY pads: Shift locks an axis while dragging, Home or double-click restores defaults, Escape cancels an active drag. Menus return focus to their trigger on select or Escape. Bézier handles move 0.01 per arrow, 0.1 with Shift.

### 4. Versions, not one-off values

The panel's version menu is always available: **+** saves and selects a version; edits update the selected version; **Version 1** is the editable base; versions are deletable. **Copy** emits current values plus an instruction for applying them to your config. This makes A/B comparison ("which radius was better?") part of the primitive, not an afterthought. Persistence: `persist: true` → `localStorage` under `dialkit:${id}` (values, presets, active preset; open state stays in memory); object form allows `key`, `storage: "sessionStorage"`, `presets: false`. A stable `id` shares values across mounts and remounts.

### 5. Motion editors that return a usable type

Spring and easing controls open one shared editor with three modes — Easing (duration + 4 Bézier coordinates, draggable or keyboard-edited handles), Time (`visualDuration`, `bounce`), Physics (`stiffness`, `damping`, `mass`) — and return a `TransitionConfig` (union of spring/easing configs) that drops straight into a transition prop. Mode switches restore each mode's previous edits while mounted. Motion timing is treated as tunable data, not frozen constants.

### 6. Timeline dock

`useDialTimeline(name, clips)` declares animation clips (at, duration, from/to keyframes, transition) in code; the dock scrubs, moves, and resizes them; `play()/pause()/replay()/seek(seconds)` control playback. Bind `clip.current` in your render so the UI follows the playhead; the dock runs independently of `DialRoot`. Before removing it, replace sampled `current` bindings — hiding the dock alone leaves them running.

### 7. Production discipline

Framework roots are hidden in production builds unless `productionEnabled: true`; vanilla roots are enabled by default (set `productionEnabled: false`). The setting gates the editor UI only, never the code consuming its values. Root props: `position` (`top-right` default), `theme` (`system`), `mode` (`popover` floating and draggable, or `inline` filling a container).

## When to use / When NOT to use

Use when:
- Tuning visual tokens (radius, spacing, shadow blur, opacity) against live rendering — anything where seeing the change beats predicting it.
- Tuning motion: spring/easing curves, durations, staggered timelines.
- Comparing candidate values (versioned presets) and exporting chosen ones back to config.
- Building demos, design QA harnesses, or letting an AI coding agent converge on values by adjusting a panel instead of rewriting CSS repeatedly.

NOT when:
- Building end-user settings UI. DialKit is a developer instrument: ship-invisible by default, no i18n, panel-first layout. Use native form controls.
- The panel would be permanent product UI — that is what design-system components are for; a tuning panel is scaffolding.
- One or two values need adjusting once — hard-code them; a panel dependency (plus `motion` for framework adapters) is not justified below ~4–5 live values.
- Users need precise numeric entry as the primary path — DialKit's Enter-to-edit exists, but a number input is the honest primitive there.

## How to apply

1. Declare values as plain config; prefer inference only for throwaway ranges — production tuning wants explicit `[default, min, max, step]` tuples so Copy-back is unambiguous.
2. Mount one root as a **sibling** of the app (not a wrapper): `<DialRoot />` beside `{children}`; import `dialkit/styles.css` (Svelte injects styles itself).
3. Group related values into nested folders; `_collapsed: true` on secondary folders; dot-paths (`shadow.blur`) address nested controls everywhere (shortcuts, `setValue`).
4. Assign shortcuts to the 2–4 values you adjust most: one modifier-free key each, `mode: "fine"` for values you land precisely, `interaction: "drag"` for wide-traversal values.
5. Give panels a stable `id`; add `persist: true` only where reloads would otherwise destroy a tuning session.
6. Save a version before exploring; keep Version 1 as the shippable base; use Copy to write results back into source config.
7. Keep `productionEnabled` unset in framework builds; verify the panel is absent from production bundles.
8. When done, either remove the panel code or gate it behind a dev flag — never leave dead tuning panels registered.

## Recreate the mechanism (plain JS)

The two signature mechanisms — range inference and precision scrubbing — are ~40 lines:

```js
// DialKit's bare-number range inference (docs/reference.md)
function inferRange(v) {
  if (v >= 0 && v <= 1) return { min: 0, max: 1, step: 0.01 };
  if (v > 1 && v <= 10) return { min: 0, max: v * 3, step: 0.1 };
  if (v > 10 && v <= 100) return { min: 0, max: v * 3, step: 1 };
  if (v > 100) return { min: 0, max: v * 3, step: 10 };
  return { min: v * 3, max: -v * 3, step: 1 }; // negatives
}
```

```js
// Key-held wheel scrubbing with DialKit's precision modes
const STEP = { fine: r => r / 100, normal: (_r, s) => s, coarse: r => r / 10 };

function scrub(el, { min, max, step, mode = "normal" }, onChange) {
  let value = (min + max) / 2;
  el.addEventListener("wheel", e => {
    e.preventDefault();
    const delta = STEP[mode](max - min, step);
    value = Math.min(max, Math.max(min, value - Math.sign(e.deltaY) * delta));
    onChange(value); // round to step before display
  }, { passive: false });
}
```

```js
// Keyboard parity: the pattern behind DialKit's slider keys
// role="slider", aria-valuemin/max/now maintained; arrows = 1 step,
// Shift+Arrow = 10 steps, Home/End = bounds, Enter = numeric editor.
function onKey(e, api) { // api: { step, min, max, get, set, edit() }
  const big = e.shiftKey ? 10 : 1;
  switch (e.key) {
    case "ArrowUp": case "ArrowRight": api.set(api.get() + api.step * big); break;
    case "ArrowDown": case "ArrowLeft": api.set(api.get() - api.step * big); break;
    case "Home": api.set(api.min); break;
    case "End": api.set(api.max); break;
    case "Enter": api.edit(); break; // commit on Enter, cancel on Escape
    default: return;
  }
  e.preventDefault();
}
```

The version system is equally simple underneath: an array of value snapshots plus an active index; Copy serializes the active snapshot into a config patch.

## When installing is justified

Install when you are tuning continuously across sessions (persistence + versions repay the dependency immediately), need the spring/easing editors or timeline dock (hard to rebuild well), or want a uniform panel across React/Solid/Svelte/Vue/vanilla. Skip it for one-off values, for end-user settings, or when a `data-` attribute + dev-tools edit suffices.

## AI-slop warning

The floating-dev-panel aesthetic became a cliché: dashboards and "pro tool" landing pages sprouting Leva-style panels as decoration, or demos that ship the tuning UI to production as fake "customization". DialKit panels are instruments — dev-only, hidden in production by default; keep them there. The second misapplication is inference worship: letting bare-number inference decide production ranges (`value × 3` max is a starting guess, not a design decision — always replace with explicit tuples before Copy-back). Third: registering a panel per component until the screen is 40% panel — one root, folders inside, `_collapsed: true` on the rest.

## Relations

- **interface-craft** — same author (Josh Puckett); his interface-engineering principles are the "why" behind DialKit's copy-back loop and keyboard completeness. Read for the philosophy this tool encodes.
- **easing** — the curve literacy needed to use the easing/Bézier editor well; DialKit gives you the handles, this gives you the targets.
- **devouring-details** — the iteration cadence (tune, compare, commit) this panel exists to serve; complements its detail checklist.
- **aicss** — adjacent strategy for AI-driven style iteration; DialKit is the in-app harness version of the same loop, with versions instead of prompts.
