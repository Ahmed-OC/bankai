---
name: desengs-audio-kit
description: Use when adding UI feedback sounds or synthesized audio effects without shipping audio assets. Encodes declarative Web Audio synthesis with exact gain, duration, and frequency budgets plus per-event recipes.
source: https://audio.raphaelsalaja.com/; https://github.com/raphaelsalaja/audio
category: library
---

# @web-kits/audio (desengs) — declarative UI sound synthesis: JSON in, audio out

Source: https://audio.raphaelsalaja.com/ — docs site for `@web-kits/audio` (npm, v0.2.0) by Raphael Salaja (same author as calligraph and the ui-wiki rules; github.com/raphaelsalaja/audio). MIT license, ~11 kB gzipped, tree-shakeable, vanilla JS + React bindings + a CLI. Despite the "audio kit" name, this is **not** a player/waveform/scrubber library — it synthesizes short UI sounds (clicks, toggles, success chimes, swooshes) from plain object definitions, zero audio files.

## What it is / Why it exists

A declarative layer over the Web Audio API. You describe a sound as a plain object — source, envelope, gain, filter — and `defineSound` returns a function that plays it. The docs' pitch: "No imperative node wiring. No class hierarchies. Just JSON in, audio out."

The gaps it fills:

1. **UI sound usually means shipping assets.** A `.mp3` per click costs a request, a decode, and a fixed rendering — you cannot change pitch, volume, or pan at play time, and you cannot express the sound in code review or diffs.
2. **Raw Web Audio is imperative graph surgery.** `createOscillator` → `connect` → `schedule` for every blip; nobody writes that for a toggle sound. The declarative shape makes sounds data — serializable, shareable, validatable.
3. **Sounds should be a palette, not one-offs.** The patch system (JSON files of named definitions + JSON Schema validation + a CLI registry) treats a product's sound set like a design system.
4. **Agents can generate sounds from rules.** The repo ships its own agent skill (`skills/create-sound/`, 48 markdown rules) mapping event words → tuned definitions with hard validation budgets. Those rules are the most valuable artifact here and are distilled below.

## The core ideas

### The definition model

A sound is a `Layer` or a `MultiLayerSound`:

```
Layer:          { source, filter?, envelope?, gain?, pan?, panner?, lfo?, effects?, delay? }
MultiLayerSound: { layers: Layer[], effects? }
```

Signal flow per layer: source → filter → envelope → per-layer effects → (gain-weighted) mix → global effects → pan/panner. A top-level `source` implicitly defines one layer; the docs state "a single layer is enough for most UI sounds."

- **Sources**: oscillator (`sine|triangle|square|sawtooth`, `frequency` as number or `{start, end}` sweep, `detune` in cents, `fm: {ratio, depth}`); noise (`white` default, `pink`, `brown`); wavetable (`harmonics: [1, 0.5, 0.25, ...]`); sample (`url` or pre-decoded `buffer`, `playbackRate`, `loop`, `loopStart/End`); stream (live MediaStream); constant (modulation offset).
- **Envelope (ADSR)**: only `decay` is required; `attack` default 0 ramps linearly, `decay` curves exponentially toward `sustain` (default 0), `release` default 0 fades after `stop()`.
- **Filters**: all 8 biquad types + IIR with custom coefficients; chains as arrays; a filter envelope `{attack, peak, decay}` sweeps the cutoff (this is how swooshes are made).
- **LFO**: `{type, frequency (Hz), depth, target}` — targets: `frequency`, `detune`, `gain`, `pan`, `filter.frequency`, `filter.detune`, `filter.Q`, `filter.gain`, `playbackRate`. Auto-cleaned when the voice ends.
- **Effects**: reverb (decay/preDelay/damping/roomSize/mix), convolver (IR file), delay (feedback + `feedbackFilter` in the loop), distortion, chorus, flanger, phaser (stages), tremolo, vibrato, bitcrusher (bits/sampleRateReduction), compressor (threshold/knee/ratio/attack/release), multi-band eq, gain, pan. Most carry a `mix` dry/wet.
- **Spatial**: per-layer `panner` (HRTF or equalpower, `distanceModel: linear|inverse|exponential`, `refDistance` 1, `maxDistance` 10000, `rolloffFactor` 1, cone angles default 360°) + `setListener({positionX/Y/Z, forward, up})` — default listener forward is `(0,0,-1)`, ear height 1.6 m.

### Playback, play-time overrides, and jitter

Calling the returned function yields a `VoiceHandle` (`stop()` = short default fade, `stop(0.5)` = 500 ms fade). `PlayOptions` override per trigger without touching the definition: `volume`, `pan` (−1..1), `detune` (cents), `playbackRate`, `velocity` (0–1), and `jitter` — per-voice randomization so "the same sound never plays exactly the same way twice":

```js
const click = defineSound({
  source: { type: "sine", frequency: 1800 },
  envelope: { decay: 0.06 },
  gain: 0.3,
});
<button onClick={() => click({ jitter: { detune: 60 } })}>Click</button>
```

`defineSequence(steps, {loop, duration})` schedules sounds with `at` (absolute seconds) or `wait` (relative) via "a lookahead scheduler for sample-accurate timing, even in background tabs." `ensureReady()` resumes the AudioContext after the first user gesture — sounds are silent before any gesture, full stop.

React: `useSound(definition)` returns a **stable** play fn that returns `undefined` when disabled; `SoundProvider` is deliberately controlled (`enabled`/`volume` props you own — "avoids dual sources of truth") and **auto-disables when `prefers-reduced-motion: reduce`** unless overridden. `createMasterAnalyser({fftSize: 2048, smoothingTimeConstant: 0.8, minDecibels: -100, maxDecibels: -30})` exposes `getFrequencyData()` / `getTimeDomainData()` (Uint8Array 0–255) for real visualizers. `renderToBuffer(def, {duration, sampleRate: 44100, channels: 2})` renders via OfflineAudioContext faster than real time — for previews and WAV export.

### Patches: sounds as a managed palette

A patch is JSON — `{name, author?, version?, sounds: {name: definition}}` — plus `$schema` (served at `unpkg.com/@web-kits/audio/schemas/patch.schema.json`) for editor autocomplete and validation. The CLI installs patches as **typed TS modules** into `.web-kits/` with a barrel `index.ts`: `npx @web-kits/audio add` (registry multiselect) | `add user/repo` (GitHub Tree API) | `add <url|path>`; plus `find`, `list`, `remove`, `check`, `update`, `init`.

### The sound-design rules (from the library's own agent skill — the real canon)

**Hard budgets** (the `validate-*` rules):

- **Gain**: engine clips above ~0.7. Single layer 0.04–0.3. Ticks/scroll-snaps 0.04–0.10; mid-importance (click, tap, hover) 0.12–0.20; high-importance (success, notification) 0.16–0.25. Sum of all layer gains ≤ 0.6; if over, scale all layers proportionally. Heavy reverb (`mix > 0.15`) or distortion → cut the budget 20%.
- **Duration**: click/tap/tick/hover/focus ≤ 0.1 s; toggle/copy/sync ≤ 0.2 s; modal/drawer/dropdown ≤ 0.3 s; whoosh/page transition ≤ 0.5 s; success/notification ≤ 0.8 s. Hard ceiling 3 s — "anything longer should not be a UI sound." A sound that overruns its own animation feels laggy.
- **Frequency**: hard bounds 20 Hz–20 kHz. Recommended: tonal sources 80–8000 Hz; high transients ≤ 5 kHz; sub layers 60–200 Hz. Above 8 kHz is inaudible on phone speakers; below 60 Hz inaudible on laptops.
- **Envelope sanity**: `decay > 0` always (min 0.005 — zero decay makes a click artifact); `sustain > 0` requires `release > 0` or the voice rings forever. Attack: 0 percussive, 0.003–0.05 sustained tones, up to 0.1 ambient. `decay + release ≤ 2 s` for any UI sound — beyond that "you're writing music, not interface feedback."

**Layer-count defaults per event class**: click/tap/tick/hover/swoosh → 1 layer; toggle/copy/send/sync → 2 layers (paired pitches, 20–50 ms `delay` apart); success/complete → 3+ layers (chord with cascading delay); error/delete → 2 layers (sawtooth + square).

**Direction semantics**: ascending pitch = open, on, enable, confirm, appear; descending = close, off, dismiss, cancel. Non-negotiable consistency across the palette.

**Recipes with exact numbers** (frequencies in Hz, times in seconds):

| Event | Shape |
|---|---|
| Click | sine sweep 200→700, `fm {ratio: 0.5, depth: 80}`, attack 0, decay 0.06, release 0.02, gain 0.25 |
| Tap / keypress | static sine 1300, `fm {ratio: 0.5, depth: 100}`, decay 0.015, release 0.005, gain 0.2 |
| Tick / focus | sine 1500 + `fm` depth 60, decay 0.01, gain 0.15 (scroll-snap 0.08; focus/blur 0.04–0.06) |
| Toggle on/off | two sines C7 2093 + G7 3136, 25 ms apart; on = low→high, off = high→low; copy = 1200→1400, 40 ms |
| Success | three sines C5/E5/G5 (523/659/784), 0.07 s cascade, top note sweeps 784→880, gains 0.16+0.14+0.15 = 0.45 |
| Complete | same triad + C6 on top, 15 ms increments so notes blur into one gesture |
| Error | saw 320→140 lowpassed 1200 + square 180→80 lowpassed 800 (delay 0.03); never unfiltered — raw sawtooth "sounds like a buzzer" |
| Modal open | sine sweep 430→1400, decay 0.08, gain 0.1; close = inverse, narrower range, lower gain (dismiss is less assertive than entrance) |
| Swoosh | white noise through bandpass sweeping 300→4000; invert the sweep for downward; pink noise for slide-down |
| Whoosh | stretched swoosh, filter attack 4× (0.04 vs 0.01) so the gesture starts gently |
| Notification | two FM bells a fifth apart, 100 ms apart; ding = one layer, `fm.ratio: 3.5`, reverb decay 0.8 |
| FM bell | `fm {ratio: 2.5–3.5, depth: 150–400}`, decay ≥ 0.3 so it rings; ratio 2.76 = inharmonic "badge" clang |

**Moods are mutations on a base recipe**, applied in order (source adjectives → envelope adjectives → effect adjectives; later conflicting token wins): warm = lowpass ~2500 Hz + optional reverb (decay 0.4, mix 0.1), downgrade saw/square to triangle; glassy = sine + `fm {3.5, 200–300}` + reverb (0.7, damping 0.5, mix 0.15) + decay ≥ 0.3; lofi = bitcrusher. Prompt refinements: "warmer" → lowpass 2500; "punchier" → clamp decay ≤ 0.06, attack → 0.

**Round-trip validation** when generating from audio: render the WAV, re-analyze, and accept only ±5% fundamental, ±2 ms attack, ±10% decay, ±20% spectral centroid drift.

## When to use / When NOT to use

Use when: adding feedback sound to interactions (toggle, success, error, transitions); building a product-wide sound palette as versioned data; needing play-time variation (`velocity` from drag speed, `pan` from pointer x, `jitter` everywhere) that sampled assets cannot do; driving real visualizers from the master analyser; 3D/spatial cue placement.

Do NOT use when: the job is a media player — playback, scrubbing, playlists, seek UI are untouched by this library; the sound is music or a long bed (>3 s — render it as a file and use an `<audio>` element); only 2–3 canned samples are ever needed and nobody will tune them (a declarative engine is a sound-design vocabulary commitment); the context must stay silent (kiosks, screen-reader-heavy flows) — sound is enhancement, never information.

## How to apply

1. Define the palette as one patch JSON with `$schema`; every sound named after its event (`toggleOn`, not `sound3`).
2. `await ensureReady()` on the first user gesture; before that, `play()` is silent by design — do not fight the autoplay policy.
3. Wire `SoundProvider` with owned `enabled`/`volume` state persisted in settings; ship a visible mute toggle. Reduced-motion users get silence automatically.
4. Start every sound from the recipe table, then tune: check gain budget (sum ≤ 0.6), duration cap (≤ 0.1 s for transients), and frequency range (80–8000 Hz tonal).
5. Add `jitter: {detune: 50–60}` to any sound a user hears repeatedly — identical repeats read as machine error.
6. Match sound length to animation length (0.1 s click on a 150 ms transition; 0.3 s modal chime on a 300 ms spring) — the sound must end with the motion.
7. Keep definitions referentially stable (module-level constants) — inline literals recreate sounds per render.
8. Verify by rendering: `renderToBuffer`/`renderToWav` offline, then listen or run the round-trip tolerances.

## The mechanism in plain code (no dependency)

Everything above reduces to one Web Audio pattern — schedule a source and a gain envelope at trigger time:

```js
let ctx;                                   // one context for the whole app
const ensureReady = async () =>
  (ctx ??= new AudioContext()) && ctx.resume();

function defineSound(def) {
  return (opts = {}) => {                  // returns a play function
    const t0 = ctx.currentTime;
    const osc = ctx.createOscillator();
    osc.type = def.source.type;
    const f = def.source.frequency;
    const jitter = opts.jitter?.detune ?? 0;
    if (typeof f === "number") {
      osc.frequency.setValueAtTime(f, t0);
      if (jitter) osc.detune.setValueAtTime(
        (Math.random() * 2 - 1) * jitter, t0);
    } else {                               // {start, end} sweep
      osc.frequency.setValueAtTime(f.start, t0);
      osc.frequency.exponentialRampToValueAtTime(f.end,
        t0 + def.envelope.decay);
    }
    const g = ctx.createGain();            // ADSR on one gain node
    const { attack = 0, decay, sustain = 0, release = 0 } = def.envelope;
    const peak = def.gain * (opts.volume ?? 1);
    g.gain.setValueAtTime(0.0001, t0);
    g.gain.linearRampToValueAtTime(peak, t0 + attack);
    g.gain.exponentialRampToValueAtTime(Math.max(peak * sustain, 0.0001),
      t0 + attack + decay);
    osc.connect(g).connect(ctx.destination);
    osc.start(t0);
    osc.stop(t0 + attack + decay + release + 0.05);
    return { stop: (fade = 0.1) => {       // VoiceHandle
      const t = ctx.currentTime;
      g.gain.cancelScheduledValues(t);
      g.gain.setValueAtTime(g.gain.value, t);
      g.gain.linearRampToValueAtTime(0.0001, t + fade);
      osc.stop(t + fade + 0.02);
    }};
  };
}
const click = defineSound({
  source: { type: "sine", frequency: { start: 200, end: 700 } },
  envelope: { attack: 0, decay: 0.06, release: 0.02 },
  gain: 0.25,
});
```

The master analyser is two lines of raw Web Audio (`ctx.createAnalyser()` with `fftSize: 2048`, `smoothingTimeConstant: 0.8`, polled via `requestAnimationFrame`); OfflineAudioContext gives free faster-than-real-time rendering. **Installing the library is justified when** you need its graph features you will not hand-roll correctly: multi-layer mixing with per-layer effects, the 14-effect rack, LFO routing, spatialization, the lookahead sequencer, patch JSON Schema validation, the CLI registry, and the React hooks. That is most of a sound engine — at ~11 kB gzip, hand-rolling loses.

## AI-slop warning

- **Sound on everything.** The most common AI failure is attaching chimes to every hover and keystroke. The rules themselves budget ticks at gain 0.04–0.06 precisely because frequent sounds must be near-subliminal; if an interaction fires more than once per second, its sound should barely exist — or not exist.
- **Sound outlasting the animation.** A 0.8 s "success" arpeggio under a 200 ms checkmark feels broken. Duration is a budget, not a vibe: ≤ 0.1 s transients, ceiling 3 s.
- **Unfiltered buzzers.** Raw sawtooth/square error sounds are the giveaway of generated audio; the error recipe mandates lowpass filters (1200/800 Hz) on every harmonically rich layer.
- **Fake analysers.** Rendering a waveform visualizer from `Math.random()` or a sine of `Date.now()` while audio plays is decoration lying about data. Use a real analyser node or no visualizer.
- **No escape hatch.** Shipping sounds with no mute control and no `prefers-reduced-motion` respect (the library handles this via SoundProvider — keep it) makes the product unusable in offices and for assistive-tech users.
- **Asset reflex.** Generating 200 kB of mp3 files for three clicks when 20 lines of synthesis produce smaller, tunable, per-trigger-variable sound is the asset-era habit to drop.

## Relations

- **desengs-soundcn** — the sibling sound-effect library canon; compare inventories and budgets before choosing a synthesis-vs-samples approach.
- **desengs-calligraph** — same author (Raphael Salaja); shares the design-engineering signature of small, declarative, asset-free primitives with agent-friendly docs (llms.txt, shipped rules).
- **desengs-ui-wiki** — same author's rule canon; audio feedback rules extend its interaction-feedback entries with the exact numbers here.
- **desengs-transitions** — motion durations are the other half of the sound-duration contract; pair every cap in this skill with the matching animation length.
- **desengs-loading-dev** — the visual channel of the same feedback problem; loading states and wait sounds must agree on rhythm and duration.
