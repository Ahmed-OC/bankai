---
name: soundcn
description: Use when adding sound to a web UI: gives measured duration and size budgets per event type (click 7–100ms, confirm ~490ms), a semantic sound taxonomy, and a zero-dependency WebAudio data-URI playback hook.
source: https://soundcn.xyz/; https://github.com/kapishdima/soundcn
category: reference
---

# soundcn — UI sound design, cataloged

Source: https://soundcn.xyz/ — browse/preview site for the open-source registry `kapishdima/soundcn` (installable via shadcn CLI as `@soundcn/<sound>`). 813 sound blocks: 703 CC0 samples by Kenney (kenney.nl) + 110 World of Warcraft sounds (Blizzard property, non-commercial/educational reference only). Each sound ships as a self-contained TypeScript module with an inline base64 MP3 data URI plus a zero-dependency `useSound` hook and WebAudio engine. Site and hook: MIT-adjacent open source; sounds: CC0 except the WoW set.

## What it is / Why it exists

A shadcn-style registry for interaction sound. The stated problem: adding sound to web UIs means hunting free samples, checking licenses, wiring audio loading, or pulling heavy libraries — "all for a simple button click sound." soundcn's answer:

- **Curated, not generated**: 813 short effects (median 0.64s, median 6KB) pre-cleared for license, named, categorized, described.
- **Copied, not depended on**: `npx shadcn add @soundcn/click-soft` copies one `.ts` file per sound (plus the hook/engine, once) into your codebase. No npm dependency, no runtime fetching, no CORS, no network waterfall — the audio is a base64 string in source.
- **Playable via WebAudio**: a `useSound` hook decodes the data URI to an `AudioBuffer` once, caches it, and plays through a `GainNode` with volume/playbackRate/interrupt controls.

Its reference value for a design engineer is not the install command — it is the **measured statistics of 813 curated UI sounds**: which events get sounds, how long they run, how big they are, and what timbre language the descriptions encode. Those numbers are the budgets below.

## The core ideas

### 1. The taxonomy: sound categories are event categories

The catalog derives a `primaryCategory` from each sound's name prefix, then maps it to an ordered `broadCategory`. The mapping is the site's vocabulary for *what deserves a sound*:

- **UI** — `click, close, open, toggle, switch, scroll, maximize, minimize, hover, select, back, drop`
- **Feedback** — `confirmation, error, notification, question, feedback, success`
- **Impact** — `impact, explosion, glass, metal, chop`
- **Game** — `arcade, battle, begin, championship, combo, winner, loser, round, power…`
- **Retro** — `glitch, computer, bong` · **Sci-Fi** — `laser, phaser, space, thruster, zap, engine, force, phase`
- **Cards & Board** — `card, cards, chip, chips, dice` · **Tones** — `tone, pluck, tick, low, high`
- Plus **Jingles, Voiceover, Voice, Footsteps, Items, Environment, Ambient** and the WoW subcategories (`ui, voice, combat, ambient, loot, crafting, fishing, quest`).

Top of the distribution by count: impact 110, voiceover 103, jingles 85 — but the *interface-relevant* set is UI + Feedback + Tones (~120 sounds). Everything else is game flavor. The 703 CC0 sounds break into: 64 sounds ≤0.15s, 298 ≤0.5s, 594 ≤1s, 70 >2s (loops/ambience). Max duration 8.97s, max size 71KB.

### 2. Measured budgets per event (from the registry metadata)

| Event | n | Duration | Median | Size |
|---|---|---|---|---|
| `click` | 7 | 7–97ms | 12ms | 1KB |
| `tick` (checkbox/increment) | — | ~45ms | 45ms | 1KB |
| `back`/undo | 4 | 61–94ms | 91ms | 1KB |
| `toggle` state change | 4 | 63–139ms | 136ms | 2KB |
| `drop` (drag-drop land) | 5 | 132–415ms | 188ms | 2KB |
| `error` (validation) | 8 | 104–533ms | 192ms | 2KB |
| `maximize`/`minimize` | 18 | 183–526ms | 258ms | 2KB |
| `open`/`close` (panel, dialog) | 8 | 148–323ms | 315ms | 3KB |
| `question` (needs answer) | 4 | 330–491ms | 333ms | 3KB |
| `confirmation` (saved, done) | 4 | 290–539ms | 490ms | 4KB |
| `notification` (toast, ping) | 1 | 539ms | 539ms | 5KB |
| `hover` (discreet tick) | 1 | 224ms | 224ms | 2KB |

Read it as tiers (derived from the table):

1. **Press feedback: 10–100ms, ~1KB.** The shortest sounds in the catalog are button presses. A click that outlasts the press is decoration.
2. **State change: 60–140ms, ~2KB.** Toggles get slightly more body than clicks — a snap, not a tick.
3. **Surface transitions: 150–350ms, 2–3KB.** Open/close/maximize. Duration tracks the animation, not the event.
4. **Outcome confirmation: 300–540ms, 3–5KB.** Confirmation and notification sounds are 4–40× longer than clicks. Attention owed ∝ consequence of the event.
5. **Errors: short and sharp (median 192ms)** — faster than confirmations. Fail fast, don't linger in the failure.
6. **Ambience/loops: 1s+** (scroll-style loops, 8KB) — only for sustained states, never for discrete events.

### 3. The timbre language in the descriptions

Every sound carries an intent description; the recurring rules across them:

- **Pitch contour mirrors spatial direction.** `maximize`: "quick, **rising** sound"; `open`: "very short, **upward-moving**"; `high-up`: "smoothly **ascends** in tone… element opening, new item appearing". Close/back/down = falling contour. Never invert this (a rising sound on close feels like the UI is opening).
- **Scale maps to stakes.** `click-soft` (7ms): "very subtle and gentle… minimal UI interactions where a **quiet confirmation** is desired". `confirmation-004` (490ms): "**warm, resonant**… major progress, or successful purchases". Same event family, different weight — pick by consequence, not taste.
- **Errors are "short, sharp"** — not scary. `error-001`: "immediate feedback on **minor input validation** failures".
- **Hover exists but is "very subtle, quick"** — one sound in 813, described as "discreet". The catalog itself treats hover sound as the exception, not a default.
- **Material words**: click = "high-pitched/light", toggle = "digital snap", drop = "small, light dropping", notification = "friendly, short popping". Positive outcomes get "warm/crisp/resonant"; failures get "sharp/muted".

### 4. Delivery mechanism: inline data URI, decode-once, cache

Each sound is one module — no audio files, no fetch, no CORS:

```ts
// sounds/click-soft.ts — the entire shipped artifact
import type { SoundAsset } from "@/lib/sound-types";
export const clickSoftSound: SoundAsset = {
  name: "click-soft",
  dataUri: "data:audio/mpeg;base64,SUQzBAAAAAAAIlRTU0UAAAAO…", // ~1KB for a click
  duration: 0.007,
  format: "mp3",
  license: "CC0",
  author: "Kenney",
};
```

The engine (registry copy is plain WebAudio, zero dependencies):

```ts
// lib/sound-engine.ts — condensed from the shipped source
let audioContext: AudioContext | null = null;
const bufferCache = new Map<string, AudioBuffer>();

function getAudioContext(): AudioContext {
  audioContext ??= new AudioContext();
  return audioContext;
}

async function decodeAudioData(dataUri: string): Promise<AudioBuffer> {
  const cached = bufferCache.get(dataUri);
  if (cached) return cached;                       // decode once per sound
  const ctx = getAudioContext();
  const bin = atob(dataUri.split(",")[1]);         // base64 -> bytes
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  const buffer = await ctx.decodeAudioData(bytes.buffer.slice(0));
  bufferCache.set(dataUri, buffer);
  return buffer;
}

export async function playSound(dataUri: string, opts: { volume?: number; playbackRate?: number } = {}) {
  const ctx = getAudioContext();
  if (ctx.state === "suspended") await ctx.resume();   // autoplay policy: unlock on gesture
  const source = ctx.createBufferSource();
  const gain = ctx.createGain();
  source.buffer = await decodeAudioData(dataUri);
  source.playbackRate.value = opts.playbackRate ?? 1;  // pitch variety for free
  gain.gain.value = opts.volume ?? 1;
  source.connect(gain).connect(ctx.destination);
  source.start(0);
  return { stop: () => { try { source.stop(); } catch {} } };
}
```

The React hook wraps this with: pre-decode on mount (`useEffect` on `sound.dataUri`), `interrupt: true` to stop the previous instance before replaying (rapid toggles), `stopOnUnmount`, and live volume updates through the `GainNode`:

```tsx
const [play, { stop, isPlaying, duration }] = useSound(clickSoftSound, {
  volume: 0.6,          // per-sound level; global mute wins
  playbackRate: 0.9 + Math.random() * 0.2, // vary every press, avoid machine-gun sameness
  interrupt: true,      // retrigger cuts the tail instead of stacking
});
```

Global settings pattern from the site: `{ muted, volume }` persisted to `localStorage` with debounced (250ms) writes and a `pagehide` flush, applied as `gain.gain.value = muted ? 0 : volume * settings.volume`.

### 5. Autoplay/permission reality (why the engine looks like this)

- An `AudioContext` starts **suspended** until a user gesture; the engine's `resume()` inside `play()` means sounds must be triggered by (or after) a user action. Sound on page load is swallowed — that is correct behavior, not a bug to hack around.
- `new AudioContext()` is created lazily on first play, never at module scope (module scope breaks SSR and burns the gesture).
- No permission prompt exists for WebAudio — but OS/browser autoplay policies can still gate it, and users expect a visible mute. Ship one; honor it across sessions via storage.
- WCAG 1.4.2: any audio that starts automatically and lasts >3s needs a pause/stop control. Keep UI sounds user-triggered and <1s and you stay outside that regime — the catalog's 594-of-703 sounds ≤1s is the safe zone.

## When to use / When NOT to use

Use sound when:

- The event is **user-initiated and discrete**: press, toggle, drag-drop landing, delete.
- The event is an **outcome the user is waiting for**: form saved, purchase confirmed, export finished (confirmation tier, 300–540ms).
- The event **demands attention** away from the cursor: toast, incoming message, blocking question (notification/question tier).
- **Ambient/game contexts**: loops, stingers, impacts are cataloged for a reason — 703 CC0 sounds cover game UIs fully.

Do NOT add sound when:

- The visual channel already confirms the event in <150ms (a button's active state is its own click sound).
- The event is **not user-initiated** (page load, route prefetch, background sync) — hostile and often blocked.
- Hover on every element: the catalog itself contains exactly one hover sound, labeled "discreet". If you ship hover sound at all: one quiet tick, never on touch devices.
- Rapid repeated events without `interrupt: true` and `playbackRate` jitter — identical stacked samples read as a bug.
- The user muted once and you re-play anyway — mute persists in storage, not memory.
- You cannot source CC0/licensed audio: the 110 WoW sounds are Blizzard property — reference and education only, never production.

Prefer synthesis (no assets, live pitch/duration control) over samples when you need <5 cues: see Relations. soundcn's sample approach wins when you want authored, physical timbres (real clicks, pops, snaps) at 1–5KB each.

## How to apply

1. Decide **which events get sound** from the taxonomy: press → toggle/drag → open/close → confirm/error → notify. Default to the fewest; most products need 3–5 (click, toggle, confirm, error, notify).
2. Assign **duration budgets** from the table: press ≤100ms, state 60–140ms, transition 150–350ms, confirm 300–540ms, error ~200ms, notify ~550ms.
3. Assign **contour by direction**: opening/appearing/maximizing = rising pitch; closing/back/minimizing = falling.
4. Pick timbre by stakes: quiet/gentle for minor, warm/resonant for major, sharp/short for errors.
5. Implement the delivery: one TS module per sound with inline base64 (≤5KB for UI tier), lazy `AudioContext`, decode-once `Map` cache, `BufferSource → GainNode → destination`.
6. Call `play()` only inside user-event handlers; `resume()` the context if suspended; never construct the context at module scope.
7. Add `interrupt: true` for retriggerable sounds and ±10% `playbackRate` jitter for anything pressed repeatedly.
8. Ship a global `{muted, volume}` control, persisted to `localStorage`, applied multiplicatively (`muted ? 0 : volume * global`) at the `GainNode`.
9. Stop sounds on unmount (`stopOnUnmount`) so route changes don't bleed audio.
10. Verify licensing per sound: CC0 (Kenney) is production-safe; anything trademarked is not.

## AI-slop warning

Typical AI misapplications of this source:

- **Sound on everything** — a hover chirp, a keystroke, a scroll whoosh, a click on top of a toggle on top of a confirmation. Three sounds for one save flow. The catalog's own distribution (1 hover sound in 813) is the correction.
- **Delight inflation**: 500ms chimes with reverb tails on every minor action. Confirmation-length sound is for outcomes the user waited for, not for closing a dropdown.
- **Ignoring the autoplay policy**: playing sound on mount/render and reporting "audio doesn't work". The context must be resumed inside a gesture; first sound after unlock.
- **Stacking samples**: retriggers without `interrupt`, so double-clicks produce flanging doubles.
- **Shipping wrong licenses**: grabbing the Warcraft set (or arbitrary game rips) into a commercial product because "it's on the registry".
- **Bloat**: 71KB ambient loops for a 12ms click job; base64 grows ~33% over the MP3 — budget bytes per event, not per page.
- **Cliché context**: game-category stingers (fanfares, "flawless victory") in productivity tools — the taxonomy separates Game from UI for a reason; crossing it reads as parody.

## Relations

- **cuelume** — the synthesized counterpart: 14 semantic cues, one per interface job, generated at play time (no assets, ~6.4KB total). Use it when you need few sounds and live control; use soundcn's sample model when you want authored physical timbres. Cuelume's job→cue mapping validates soundcn's taxonomy (tap/select/toggle/open/close/success/error map 1:1 onto the UI/Feedback categories).
- **audio-kit** — declarative WebAudio synthesis (JSON layer definitions, ADSR envelopes, filter sweeps) with its own hard gain/duration/frequency budgets. The code-side path to the same humane-sound rules; its oscillator recipes can recreate click/confirm/error cues in <1KB of code instead of 1–5KB of base64.
- **web-haptics** — the non-auditory twin: identical event taxonomy (tap/toggle/confirm), different channel. Prefer haptics on mobile where sound is socially hostile; combine only for high-stakes confirmations.
- **transitions** — the motion budgets (150–350ms open/close) that the corresponding sound durations must match; pitch-contour-mirrors-direction is the audio face of the same easing rule.
