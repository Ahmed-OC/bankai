---
name: web-haptics
description: Use when adding tactile feedback to mobile web UIs (taps, confirmations, pickers, destructive actions). Encodes the iOS haptic vocabulary — impact, notification, selection — over navigator.vibrate with PWM intensity.
source: https://haptics.lochie.me; https://github.com/lochie/web-haptics
category: library
---

# WebHaptics — haptic feedback patterns for the web

Source: https://haptics.lochie.me (demo) and https://github.com/lochie/web-haptics — by Lochie (@lochieaxon, author of easing.dev and Torph; site design assist by Alex Vanderzon). Zero-dependency MIT library wrapping the W3C Vibration API (`navigator.vibrate`). Demo site pairs each pattern with emoji particle bursts (success → ✅🎉🤝💚👍) — the visual channel haptics must always ship with.

## What it is / Why it exists

Native iOS apps have a rich haptic vocabulary — `UIImpactFeedbackGenerator` (light/medium/heavy/soft/rigid), `UINotificationFeedbackGenerator` (success/warning/error), `UISelectionFeedbackGenerator` (tick). The mobile web has had `navigator.vibrate()` since ~2015 and almost nobody uses it, because the raw API is binary (motor on or off, no intensity) and pattern authoring from scratch is guesswork. WebHaptics fills the gap by:

1. Porting the iOS vocabulary to named presets with tuned durations and intensities (feel free to skip the library and copy the numbers — they are the value).
2. Simulating intensity the API doesn't have, via pulse-width modulation.
3. Providing an iOS Safari fallback (no `navigator.vibrate` there, ever) that triggers the OS's native switch haptic by clicking a hidden `<input type="checkbox" switch>`.
4. Shipping a debug mode that renders haptics as audible clicks so you can tune patterns on desktop.

Not a vibration for every tap — a semantic layer: haptics are the third feedback channel (visual, audio, tactile) reserved for moments the thumb should feel.

## The core ideas

### 1. The pattern inventory (exact values)

Three categories mirrored from Apple's generators, plus customs. Format: duration in ms @ intensity 0–1, `→ +N` = delay of N ms before the next pulse.

**Impact** — physical collisions, single pulse:
| Preset | Pulse | Use |
|---|---|---|
| `rigid` | 10ms @ 1.0 | hard, crisp, precise (snap-to-grid) |
| `light` | 15ms @ 0.4 | small toggle, subtle tap |
| `medium` | 25ms @ 0.7 | button press, drag-drop snap — also the default when calling `trigger()` bare |
| `heavy` | 35ms @ 1.0 | long-press, major state change |
| `soft` | 40ms @ 0.5 | cushioned, rounded landing |

**Selection** — discrete stepping:
| Preset | Pulse | Use |
|---|---|---|
| `selection` | 8ms @ 0.3 | picker wheel, stepper, slider detent, segment switch |

**Notification** — task outcomes, multi-pulse:
| Preset | Sequence | Shape |
|---|---|---|
| `success` | 30ms @ 0.5 → +60 → 40ms @ 1.0 | ascending double-tap (weak then strong) |
| `warning` | 40ms @ 0.8 → +100 → 40ms @ 0.6 | two taps with hesitation |
| `error` | 40ms @ 0.7 → +40 → 40ms @ 0.7 → +40 → 40ms @ 0.9 → +40 → 50ms @ 0.6 | rapid harsh burst, rising then dying |
| `nudge` | 80ms @ 0.8 → +80 → 50ms @ 0.3 | strong tap, pause, soft tap (reminder) |
| `buzz` | 1000ms @ 1.0 | continuous alarm — the only long pattern; 1000ms is the hard per-phase cap the library enforces |

Discipline behind the numbers: single pulses 8–40ms, gaps 40–100ms, everything ≤ 1000ms, intensities 0.3–1.0. Web haptics are transient taps, never long shakes.

### 2. Intensity via PWM (the signature technique)

`navigator.vibrate()` accepts only alternating on/off durations — no amplitude. WebHaptics fakes intensity with a 20ms duty cycle: at intensity 0.5, vibrate 10ms / pause 10ms, repeated; at ≥ 1.0, solid on; at ≤ 0, silence. Perceptually this reads as weaker/stronger buzz on Android motors.

```js
// intensity -> flat on/off segments, 20ms period
function pulse(duration, intensity, cycle = 20) {
  if (intensity >= 1) return [duration];
  if (intensity <= 0) return [];
  const on = Math.max(1, Math.round(cycle * intensity));
  const out = [];
  let left = duration;
  while (left >= cycle) { out.push(on, cycle - on); left -= cycle; }
  if (left > 0) {
    const remOn = Math.max(1, Math.round(left * intensity));
    out.push(remOn);
    if (left - remOn > 0) out.push(left - remOn);
  }
  return out;
}
```

Patterns normalize to one flat array; a delay merges into the trailing pause by parity (array indices alternate vibrate/pause starting at vibrate):

```js
// presets: [duration, intensity, delayBefore]
const PRESETS = {
  selection: [[8, 0.3, 0]],
  light:     [[15, 0.4, 0]],
  medium:    [[25, 0.7, 0]],
  heavy:     [[35, 1, 0]],
  success:   [[30, 0.5, 0], [40, 1.0, 60]],
  warning:   [[40, 0.8, 0], [40, 0.6, 100]],
  error:     [[40, 0.7, 0], [40, 0.7, 40], [40, 0.9, 40], [50, 0.6, 40]],
  nudge:     [[80, 0.8, 0], [50, 0.3, 80]],
};

function trigger(name) {
  const segs = [];
  for (const [dur, inten, delay] of PRESETS[name]) {
    if (delay > 0) {
      if (segs.length % 2 === 0) segs[segs.length - 1] += delay; // extend pause
      else segs.push(0, delay);                                  // start with pause
    }
    segs.push(...pulse(Math.min(dur, 1000), inten)); // 1000ms per-phase cap
  }
  navigator.vibrate?.(segs);
}
```

### 3. The iOS fallback: click a hidden switch

iOS Safari has never implemented `navigator.vibrate` (static `WebHaptics.isSupported === false`). The library's trick: iOS synthesizes a native haptic when the user's tap flips a switch control — so it appends an invisible `<label>` + `<input type="checkbox" switch>` and programmatically `.click()`s it inside the user-gesture context. For longer patterns a `requestAnimationFrame` loop re-clicks the switch at an interval mapped from intensity: every 16ms at intensity 1.0 up to 200ms at intensity 0. The label doubles as an opt-out toggle (`showSwitch: true` renders it). Fallback path is inert on desktop — clicking a hidden checkbox does nothing users notice.

```js
const l = document.createElement("label");
const c = document.createElement("input");
c.type = "checkbox"; c.setAttribute("switch", "");
l.style.display = "none";
l.append(c); document.body.append(l);
c.click(); // native switch haptic on iOS, silent no-op elsewhere
```

### 4. Debug audio (desktop testing)

With `debug: true`, every pulse also plays a synthesized click via Web Audio: 4ms white-noise buffer with exponential decay (`(rand*2-1)*e^(-i/25)`), bandpass filter Q=8 at 2000–4000Hz scaled by intensity (±15% jitter), gain 0.5 × intensity. Higher pitch = stronger pulse — enough to tune patterns without a phone.

## When to use / When NOT to use

Use when:
- Mobile-primary UI: button presses (`medium`), toggles (`light`), pickers/sliders/segmented controls (`selection` on every detent), long-press (`heavy`), drag-snap (`medium`).
- Outcome moments: form saved / payment confirmed (`success`), validation or network failure (`error`), pre-destruction warning (`warning`), threshold crossed while dragging (`light`).
- Async results: fire when the result arrives, synced with the visual state change — `try { await submit(); trigger("success") } catch { trigger("error") }`.

Do NOT:
- Desktop-only UIs — no vibration hardware; the code is a silent no-op (dead weight unless the debug/audio channel matters).
- Page load, passive scroll, hover, or auto-playing carousels — unprompted vibration is invasive.
- Every tap — if everything vibrates, nothing feels significant. Fewer trigger sites than interactive elements.
- Vibrating without a simultaneous visual change — many devices can't vibrate (all desktops, OS-level vibration off); haptics supplement, never replace.
- Continuous shakes > 1000ms — the platform caps phases; long buzzes drain goodwill and battery.
- `error`/`warning` for non-errors — the vocabulary only works if semantics hold.
- Working around OS settings — Android suppresses `vibrate()` in silent/vibrate-off modes and ignores calls with no prior user activation; that's correct behavior, don't fight it.

## How to apply

1. Decide the 3–6 interaction moments worth feeling; default to zero haptics, add by exception.
2. Map each moment to a preset by semantics first (outcome → notification; collision → impact; stepping → selection), intensity second.
3. Trigger inside the event handler that also commits the visual change — same tick, not after a `setTimeout`.
4. Guard with `WebHaptics.isSupported` (or `navigator.vibrate?.()`) — but never branch the visual feedback on it.
5. On iOS traffic you care about, adopt the hidden-switch fallback; otherwise accept silence there.
6. Cap custom pulses at 40ms, gaps at 40–100ms, any phase at 1000ms; intensity 0.3–1.0.
7. Tune on desktop with the debug-audio technique (bandpass noise clicks), verify on a real Android device.
8. Ship an opt-out control if haptics are frequent (the library's labeled switch pattern).

Installing `web-haptics` (MIT, zero deps, React/Vue/Svelte/vanilla entry points) is justified when you want the rAF-driven iOS fallback, debug audio, the toggle UI, and SSR safety prebuilt. For Android-only or preset-only needs, the ~40 lines above are the whole mechanism — copy them instead.

## AI-slop warning

The cliché this library enables: an AI wires `trigger("heavy")` onto every `onClick`, adds haptics to a desktop dashboard that cannot vibrate, fires `success` on page load "for delight", or invents patterns with random 300–700ms durations that feel like a hardware fault. Tell-tale: more `trigger()` calls than visual state changes, notification presets on hover/scroll, or vibration as the only confirmation of an action. Haptics with no visual twin is not a feature on most of the web's traffic — it's dead code posing as polish.

## Relations

- `easing` — same author (easing.dev); supplies the timing curves for the visual half of each haptic-paired interaction; both insist exact ms values, not "smooth".
- `torph` — same author's dependency-free animated text component; same ethos this skill ports: read the mechanism, ship it in plain JS, install only when the wrapper surface earns it.
- `audio-kit` — the audio feedback channel; WebHaptics's debug click (4ms bandpass noise burst) is a minimal audio-kit pattern — combine channels for multi-modal confirmation moments.
- `transitions` — the timing contract: a haptic must fire at the exact frame the transition begins; use these presets as the tactile track of a transition.
- `devouring-details` — haptics are the extreme case of an invisible detail: users feel it, never see it, and miss it when gone.
