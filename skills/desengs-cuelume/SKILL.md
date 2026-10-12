---
name: desengs-cuelume
description: Use when adding interaction audio to a web UI — picking semantic cue sounds, synthesizing them with Web Audio, or deciding whether sound feedback is warranted and at what cost.
source: https://cuelume.dev; https://github.com/danielwh2/cuelume
category: library
---

# Cuelume (desengs) — fourteen live-synthesized UI sounds, one per interface job

Source: https://cuelume.dev (docs: `/docs`, machine reference: `/agents.md`) · https://github.com/danielwh2/cuelume — Daniel White. An MIT-licensed, ESM-only Web Audio library (npm `cuelume`, v0.3 catalog) that synthesizes every cue at play time: ~6.4 kB min+gzip, zero runtime deps, no audio files, safe no-op under SSR.

## What it is / Why it exists

Interaction-sound library built on one thesis: **sound should be chosen by job, not by taste**. It ships a fixed catalog of 14 cues — one per interface job — and everything else (attributes, themes, emphasis, adaptive playback) maps UI events onto that catalog. The gap it fills vs. sample packs and bespoke audio code:

- **No samples**: every cue is synthesized via Web Audio at play time — no downloads, no base64 blobs, no latency on first cue.
- **Meaning is fixed**: the same job always gets the same cue; themes change timbre, never meaning, so users learn one vocabulary.
- **Zero-config wiring**: HTML attributes + one `bind()` call; delegated listeners survive framework re-renders and route swaps.
- **Materials encode event type before identity**: mallets = outcomes, glass = presence, air = motion, wood/keys = input. Users parse the category before they parse the specific cue.

## The core ideas

### The 14-cue catalog (the contract)

| Cue | Job | Character |
|---|---|---|
| `tap` | Buttons, links, activation | Small glassy tap |
| `type` | Text entry | Keystroke, varies every stroke |
| `select` | Menus, lists, tabs, radios | Crisp woody detent |
| `toggle` | Switches, checkboxes, likes | Snap with a knock of body |
| `open` | Menus, drawers, dialogs | Air drawing up over a light mallet |
| `close` | Dismissing, destructive confirm | Air falling shut, low damped note |
| `navigate` | Routes, pages, carousels | Rising whoosh; falls going back |
| `success` | Confirmed completion | Soft mallet chord, C–G–E, spread wide |
| `warning` | Done, but needs a look | Mallet fifth, A and E |
| `error` | Recoverable failure | Muted low chord, short |
| `loading` | Slow work started | Low note that swells and fades |
| `ready` | A result exists (unconfirmed) | Warm glass note in a small room |
| `attention` | Blocked until user answers | High glass bell, longest ring |
| `count` | Number animating | Breath rising/falling with the count |

Key distinction: `success` = confirmed completion; `ready` = result exists but unconfirmed; `attention` = the app is blocked *on the user*. Pick by that state machine, not by which sound you like.

### Declarative bindings (interface chrome)

Seven attributes, one `bind(root?)` call (defaults to whole document; idempotent; handles elements added later):

| Attribute | Fires on | Default cue |
|---|---|---|
| `data-cuelume-tap` | `click` | `tap` |
| `data-cuelume-type` | `keydown` that edits text | `type` |
| `data-cuelume-select` | `change` on native controls, else `click` | `select` |
| `data-cuelume-toggle` | `click` | `toggle` |
| `data-cuelume-open` | `click` | `open` |
| `data-cuelume-close` | `click` | `close` |
| `data-cuelume-navigate` | `click` | `navigate` |

Leave the value empty for the default cue, or set any catalog name. Nested marked elements: innermost wins → exactly one cue per action. Click bindings follow native activation, so Enter and Space play too. Modifiers `data-cuelume-emphasis="subtle"|"strong"` and `data-cuelume-theme` work on the element or any ancestor.

```html
<button data-cuelume-tap>Save</button>
<button data-cuelume-close data-cuelume-emphasis="strong">Delete</button>
<input data-cuelume-type placeholder="Search">
```

### Imperative `play()` for outcomes and progress

DOM events cover chrome; non-DOM moments use `play(name, options)`. Per-play options: `volume` (0–1), `emphasis` (`subtle|normal|strong`), `theme`, `direction` (`forward|back` — reverses `navigate`/`toggle`/`count`, shapes `select`), `key` (`printable|space|delete|enter` — shapes `type`), `input` (`mouse|touch|pen|keyboard` — shapes `tap`), `duration` (ms, `count` only, clamped 300–2000, default 800). Unknown values are ignored, never thrown.

```js
import { play } from "cuelume";
play("loading");
const { warnings } = await deploy();
play(warnings.length ? "warning" : "success", { emphasis: "strong" });
play("navigate", { direction: "back" });
play("count", { duration: 900 }); // match the number animation's length
```

Other exports: `bind()`, `setEnabled(bool)` (mutes future playback; ringing cues finish naturally), `setVolume(n)` (clamped 0–1), `setTheme(name)`, `sounds` (catalog array for building a picker). None persist anything — the app owns settings.

### Emphasis is arrangement, not volume

Three levels per cue — `subtle` strips ornament, `strong` adds an exclusive layer — yielding 42 distinct sounds. `subtle` for frequent/secondary actions (ghost buttons, toasts, field validation); `strong` for rare, important ones (destructive confirms, publish, payment, drop). Explicitly not a volume knob.

### Themes change material, not meaning

`default` (glass, wood, air, soft mallets), `mech` (dry machined parts), `bubble` (knocks, drips, corks, gulps), `press` (crisp click over a warm swelling note). All four are level-matched: switching changes timbre, not loudness. `default` and `mech` suit all-day use; `bubble` is for playful products or one moment (e.g. `play("select", { theme: "bubble" })` in a model picker).

### The engine (signature technique, plain Web Audio)

The synthesis model is "struck, not played back": tones modeled on real bars — each overtone dies faster the higher it is; a brief mallet contact starts the note; frequent cues vary strike hardness per play (harder = louder AND brighter, so no two sound identical) while outcome cues are identical every play. One shared output stage with native compression for overlapping cues, and every cue rings faintly into one shared short stereo room ~22 dB down (external placement, not in-head).

```js
let ctx, bus, roomSend;
function engine() {
  if (ctx) { if (ctx.state === "suspended") ctx.resume(); return; }
  ctx = new AudioContext();                       // lazy: created on first use, never on import
  const master = ctx.createGain(); master.connect(ctx.destination);
  const comp = ctx.createDynamicsCompressor();    // overlapping cues never clip
  comp.connect(master); bus = comp;
  const n = Math.floor(ctx.sampleRate * 0.08);    // shared room: 80 ms decaying-noise IR
  const ir = ctx.createBuffer(2, n, ctx.sampleRate);
  for (const ch of [0, 1]) for (let i = 0; i < n; i++)
    ir.getChannelData(ch)[i] = (Math.random() * 2 - 1) * (1 - i / n) ** 3;
  roomSend = ctx.createConvolver(); roomSend.buffer = ir;
  const wet = ctx.createGain(); wet.gain.value = 10 ** (-22 / 20);  // -22 dB
  roomSend.connect(wet).connect(master);
}

function strike({ base = 523, partials = [1, 2.76, 5.4], dur = 0.4, vel = 0.8 }) {
  engine();
  const t = ctx.currentTime;
  const v = vel * (0.85 + Math.random() * 0.3);   // strike variance for frequent cues
  partials.forEach((p, i) => {
    const osc = ctx.createOscillator();
    osc.frequency.value = base * p * (1 + (Math.random() - 0.5) * 0.004);
    const g = ctx.createGain();
    const amp = (v / (i + 1)) ** 1.2;             // higher partials quieter...
    const decay = dur / (1 + i * 1.6);            // ...and die faster — the bar model
    g.gain.setValueAtTime(amp, t);
    g.gain.exponentialRampToValueAtTime(1e-4, t + decay);
    osc.connect(g); g.connect(bus); g.connect(roomSend);
    osc.start(t); osc.stop(t + decay);
  });
  const nb = ctx.createBuffer(1, ctx.sampleRate * 0.004, ctx.sampleRate); // 4 ms mallet contact
  const nd = nb.getChannelData(0);
  for (let i = 0; i < nd.length; i++) nd[i] = (Math.random() * 2 - 1) * (1 - i / nd.length);
  const src = ctx.createBufferSource(); src.buffer = nb;
  const bp = ctx.createBiquadFilter(); bp.type = "bandpass"; bp.frequency.value = base * 2;
  const ng = ctx.createGain(); ng.gain.value = v * 0.25;
  src.connect(bp).connect(ng).connect(bus); src.start(t);
}
strike({ base: 261.6 });  // success ≈ C–G–E: strike C, then G at +60 ms, E at +120 ms
```

The `bind()` mechanism is plain delegation — replicate it in ~10 lines: one listener per event type on the root, `e.target.closest("[data-cuelume-*]")` (innermost wins), skip `disabled` elements. Typing realism rules: only text-editing keys fire; never in password fields; modifiers/arrows/shortcuts/IME composition ignored; throttled to at most one cue per 40 ms; Enter only in textareas/contenteditable; held Backspace stops when nothing remains.

## When sensory feedback is warranted — and its costs

Sound earns its place when the user's eyes are elsewhere or the event is invisible:

- **Eyes-elsewhere**: long jobs finishing while away (`ready` strong), reminders (`attention`), drag pickup/drop, route changes during keyboard navigation.
- **Invisible state change**: save/sync confirmed (`success` subtle), upload progress transitions, background export done (`ready`).
- **Blocked on the user**: permission prompts, validation failures that gate submission.

Costs to price in before adding any cue:

- **Autoplay policy**: browsers block audio until the first user gesture. Never plan sound on load; `navigate` on client-side navigation only after that first interaction. A suspended `AudioContext` must be resumed silently, never error.
- **Never the sole channel**: every audible state must also be visible (or haptic). Deaf/HoH users and muted machines get nothing otherwise; screen readers already announce many of the same events — double-announcing `error` is noise.
- **Compounding annoyance**: cues at 40 ms typing throttle are fine for minutes, maddening for hours. Reserve `strong` for rare events; default themes for all-day tools.
- **Social context**: shared offices, screen recordings, late-night use. Ship a Sound toggle wired to `setEnabled(false)`, add `setVolume()` when loudness matters, and persist both in your own store — the library deliberately never persists anything. It also deliberately ignores `prefers-reduced-motion` (a motion setting, not a sound one); offer your own reduced-sound preference instead.

## When to use / When NOT to use

Use cuelume (or this catalog) when: you want semantic UI audio without designing a sound vocabulary; bundle budget is tight (6.4 kB vs. any sample pack); the UI runs in React/Astro/plain HTML with dynamic DOM (delegation handles it).

Do NOT use, and do NOT play anything, when:

- **Constantly-updating live numbers** (price feeds, viewer counts) → nothing, ever.
- **AI streams**: never one cue per streamed token, per tool call, or on hover — one cue when the run ends. (Correct AI mapping: prompt sent → `tap` subtle; generation started → `loading` subtle; stopped → `close`; streaming finished → `ready` subtle; approval needed → `attention`; done → `success`; failed → `error`.)
- **Animated numbers**: one `count` whose `duration` matches the animation — never per digit.
- **Command palettes** firing constantly: `open` subtle or nothing.
- **Sound as the only feedback channel**, or where no mute toggle can ship.
- **CommonJS**: ESM-only; `require()` unsupported. Invalid names/blocked Web Audio degrade to silent no-op, so it fails safe everywhere else.

## How to apply

1. Map every sound-worthy event to a job first (activation, selection, toggle, open/close, navigate, outcome, presence, count) — then take that cue from the table. Never choose by timbre.
2. Wire chrome declaratively: add the seven `data-cuelume-*` attributes in markup, call `bind()` once (React: top-level `useEffect` with empty deps; Astro: client script).
3. Wire outcomes imperatively with `play()` at state transitions: `loading` on start, `success|warning|error` on end, `ready` when a result awaits the user, `attention` only when blocked.
4. Set emphasis by frequency: default for normal actions, `subtle` for anything that fires often, `strong` only for rare high-stakes moments.
5. Pick one theme for the whole product (`default`/`mech` for all-day tools; `bubble` only for playful products or a single moment). Do not mix themes per-component.
6. Ship a Sound toggle → `setEnabled()`, and a volume control → `setVolume()` when loudness matters; persist both yourself (e.g. `localStorage`).
7. Gate `navigate` (and any non-gesture cue) behind the first user interaction; resume suspended contexts silently.
8. Verify the muted path: every audible cue must have a visible equivalent. Test with audio off before shipping.
9. Audit cadence: no cue per token/digit/hover; one cue per action; typing throttled at 40 ms max.

## AI-slop warning

The 2024–26 AI-generated-app pattern is sound-everything: a blip per streamed token, a pop per list item, hover sounds, a cheerful `bubble` theme on a billing dashboard. This is the audio equivalent of gradient-glow cards — instantly recognizable, instantly annoying. Specific traps: (1) adding audio because a library exists, without a mute toggle — ships broken; (2) per-event cues on high-frequency events (tokens, ticks, keyframes) — turns a 6.4 kB library into a torture device; (3) `bubble`/playful themes in serious contexts (fintech, medical, enterprise) — poisons trust; (4) double-announcing states a screen reader already covers; (5) sound that is the only signal of success/error. If a cue would play more often than roughly once per few seconds in normal use, delete it or make it `subtle`.

## Relations

- **desengs-soundcn** — sibling sound library; compare catalogs and pick one vocabulary — never mix two sound systems in one product.
- **desengs-web-haptics** — the tactile channel solves the same problem (confirming invisible state); use haptics where audio is antisocial (mobile, shared spaces); `toggle`/`drop` moments map 1:1.
- **desengs-transitions** — the `navigate` whoosh and `open`/`close` air cues only work when timed to actual route/overlay transitions (~200–300 ms); sound must never lead or trail the motion.
- **desengs-number-flow** — animating numbers are the `count` cue's trigger; set `duration` to the exact animation length (300–2000 ms clamp) so breath and digits land together.
- **desengs-you-dont-need-animations** — the restraint argument applies verbatim to audio: default to silence, add a cue only when it carries information (state change, completion, blockage) that silence would hide.
