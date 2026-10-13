---
name: liveline
description: Use when rendering live streaming data (WebSocket, polling) as smooth 60fps charts. Encodes monotone splines, frame-rate-independent lerp, animated Y-range, and loading-to-data morph choreography.
source: https://github.com/benjitaylor/liveline; https://benji.org/liveline
category: library
---

# Liveline — live-streaming charts that animate by lerping everything through one shared clock

Source: https://github.com/benjitaylor/liveline (plus launch post https://benji.org/liveline) — Benji Taylor, design engineer. Open-source React component (~967 stars), MIT, © 2026. Canvas-rendered real-time charts: line, multi-series, candlestick, orderbook depth. Zero dependencies beyond React 18, zero CSS imports.

## What it is / Why it exists

Liveline renders data that never stops moving — WebSocket ticks, price feeds, sensor streams — as one `<canvas>` driven by one `requestAnimationFrame` loop. The author's stated gap: existing charting libraries were "either too heavy for a simple live feed, or too rigid to feel alive." Heavyweight chart libs (axes, legends, tooltips, plugins) snap to each new data point; Liveline instead treats the *entire chart* — value, Y-range, badge pill, colors, window width — as animated state that glides toward new data. Core API is "Two props. That's it" (`data`, `value`); everything else (momentum arrows, candlesticks, particles, time windows) is opt-in.

The design thesis worth stealing: new data should never cause a visual jump. Data arrives in discrete, irregular bursts; the chart converts that into continuous motion, so it "feels like one thing breathing rather than a bunch of parts updating independently."

## The core ideas

### 1. Frame-rate-independent exponential lerp — the only easing primitive

Nothing uses CSS transitions or keyframes. Every animated quantity eases via the same exponential lerp, so all parts move on one clock. Base speed 0.08 (8% closer per 60fps frame), dt clamped to 50ms max so a backgrounded tab can't cause a teleport:

```js
function lerp(current, target, speed, dt = 16.67) {
  // speed = fraction approached per 16.67ms frame; larger dt approaches more per frame
  const factor = 1 - Math.pow(1 - speed, dt / 16.67)
  return current + (target - current) * factor
}
```

Adaptive variant used for value and Y-range: small ticks settle fast, big jumps glide — `speed + (1 - gap/range) * 0.2` (boost capped at 0.2). Snap when close: value snaps under 0.001 of range; Y-range snaps when within 0.5px-equivalent — this stops sub-pixel shimmer, the classic lerp artifact. Reduced-motion users get `speed = 1` (instant snap, no motion).

### 2. Fritsch–Carlson monotone cubic spline — smooth, never overshoots

The exact algorithm behind Chart.js "monotone" and d3 `curveMonotoneX`, in ~40 lines of plain JS. A live feed hits local extremes constantly; a natural cubic spline would overshoot them and read as fake data. Monotone tangents guarantee the curve stays within local min/max:

```js
function drawSpline(ctx, pts) { // pts: [x, y][] sorted by x
  const n = pts.length
  if (n < 3) { if (n === 2) ctx.lineTo(pts[1][0], pts[1][1]); return }
  const h = [], d = [], m = new Array(n)
  for (let i = 0; i < n - 1; i++) {
    h[i] = pts[i + 1][0] - pts[i][0]
    d[i] = h[i] === 0 ? 0 : (pts[i + 1][1] - pts[i][1]) / h[i] // secant slopes
  }
  m[0] = d[0]; m[n - 1] = d[n - 2]
  for (let i = 1; i < n - 1; i++)
    m[i] = d[i - 1] * d[i] <= 0 ? 0 : (d[i - 1] + d[i]) / 2 // flat tangent at extremes
  for (let i = 0; i < n - 1; i++) {          // Fritsch–Carlson: alpha^2 + beta^2 <= 9
    if (d[i] === 0) { m[i] = 0; m[i + 1] = 0 }
    else {
      const a = m[i] / d[i], b = m[i + 1] / d[i], s2 = a * a + b * b
      if (s2 > 9) { const s = 3 / Math.sqrt(s2); m[i] = s * a * d[i]; m[i + 1] = s * b * d[i] }
    }
  }
  ctx.moveTo(pts[0][0], pts[0][1])
  for (let i = 0; i < n - 1; i++) {          // tangents -> bezier control points at h/3
    ctx.bezierCurveTo(
      pts[i][0] + h[i] / 3,     pts[i][1] + m[i] * h[i] / 3,
      pts[i + 1][0] - h[i] / 3, pts[i + 1][1] - m[i + 1] * h[i] / 3,
      pts[i + 1][0],            pts[i + 1][1])
  }
}
```

### 3. The Y-axis range is animated state, not a recompute

`computeRange` gives target min/max over visible points + current value: margin 12% of raw range (pad top/bottom), floor of 10% raw range when data is flat so a dead feed doesn't divide by zero. `exaggerate` mode tightens to margin 1%, floor 2% — small moves fill the chart (deliberate drama for price feeds). The displayed range lerps toward the target at 0.15 adaptive; but it *snaps outward instantly* when new data exceeds it — the line must never clip, while shrinking stays smooth. During time-window changes the range interpolates between pre-computed from/to ranges instead of recomputing per frame.

### 4. Momentum is semantic, never accent-colored

Direction detection reads the last 5 points' delta against the last-20-point range: threshold is 12% of that range, below which it's "flat". Up/down colors are always fixed green `#22c55e` / red `#ef4444` regardless of the accent color — momentum is meaning, not decoration. The accent color drives only identity surfaces (line, fill, badge at rest). Color transitions themselves lerp (0.12) channel-wise through RGB, so an up-to-down flip fades through amber instead of popping.

### 4b. Scrub lookup is binary search, not scan

Hovering N thousand points per frame must cost log N. The same helper serves candle hover (`candleAtX` binary-searches the time bucket):

```js
function interpolateAtTime(points, time) { // points sorted by time
  if (time <= points[0].time) return points[0].value
  if (time >= points[points.length - 1].time) return points[points.length - 1].value
  let lo = 0, hi = points.length - 1
  while (hi - lo > 1) {
    const mid = (lo + hi) >> 1
    if (points[mid].time <= time) lo = mid; else hi = mid
  }
  const p1 = points[lo], p2 = points[hi]
  const t = (time - p1.time) / (p2.time - p1.time)
  return p1.value + (p2.value - p1.value) * t
}
```

Scrub styling rule from source: the portion *right* of the cursor is re-stroked at reduced alpha (down to 40% at full scrub) instead of hiding it — users keep context while inspecting.

### 5. Loading → data is one morph, not a swap

The breathing "waiting for data" line and the chart's reveal-start shape are *the same function* (one shared module), guaranteeing a seamless morph. The squiggle: three summed sines (frequencies 9.4/15.7/4.2, amplitudes 0.55/0.3/0.15) at 7% of chart height, scrolling slowly; alpha breathes 0.22 ± 0.08 on a 1200ms period. On data arrival, reveal progresses center-out (center resolves first, edges last) at speed 0.09 forward / 0.14 for reverse, while line color blends grey→accent by reveal×3 and fill fades in proportionally. Empty state ("No data") is the same line, motionless. Pause freezes scrolling smoothly (progress lerp 0.12, catch-up 0.08 fast 0.22) and snapshots visible data so it doesn't erode.

### 6. Time-window transitions ease in log space

Switching 30s→5m windows: 750ms duration, cosine ease `(1 - cos(πt)) / 2`, and the window width interpolates in *log space* (`exp(lerp(log(from), log(to)))`) so multiplicative zoom feels linear. The right edge holds a 5% future buffer (1.5% without badge) so the live dot never touches the edge.

### 6b. Candle and series transitions carry their own tuned constants

Candle bodies lerp at 0.25 (faster than the line's 0.08 — bars read as data, the line as atmosphere); the candle→line morph runs 500ms with bodies collapsing to close price while the morph line extends center-out under a coordinated alpha crossfade; candle width changes 300ms; line density (tick↔bar resolution) crossfades 350ms. Series toggle fades at 0.10, and the Y-range recomputes to the surviving series. These are the numbers that make mode switches feel choreographed rather than instant-swap.

### 7. DOM is touched directly, outside React, only where text is sharper than canvas

The whole chart is canvas, but three things are DOM updated per-frame via refs, never via re-render: the value overlay (`textContent` at 60fps, zero React renders), the badge pill (an SVG path re-sized per frame; text width measured on canvas with every digit replaced by `8` — widest glyph — then *lerped* at 0.15 so numbers don't jitter horizontally), positioned with `translate3d`. Badge geometry is fixed: 10px horizontal / 3px vertical padding, 16px line height, 5px tail with 2.5px spread; the pill is a path (right semicircle + bezier tail), not a border-radius hack, so the tail can curve toward the line tip. Badge Y tracks the line at 0.35 (0.5 during window transitions — chrome catches up faster when the world zooms). The line's last point uses the smoothed value for Y but keeps its true data time for X — stable history, animated tip; per the source comment, per-frame X drift "is what killed jitter".

### 8. The perf contract

- rAF loop exits when `document.hidden`; a `visibilitychange` listener restarts it — no work for hidden tabs.
- dt clamped to 50ms (MAX_DELTA_MS).
- DPR clamped to 3; canvas backing store resized only when dimensions actually change.
- `ResizeObserver` for container size; zero per-frame layout reads (`getBoundingClientRect` only in layout effects on state change).
- Badge/overlay DOM elements are created once and appended; per frame only `transform`, width, and text change.
- Clipping keeps big lerping jumps tidy: the line is clipped to the chart rect while the range catches up; the live dot clamps to 10px inside the canvas so its glow is never cut.

The whole loop skeleton, recreated framework-free:

```js
let rafId = 0, lastFrame = 0
function frame(nowMs) {
  if (document.hidden) { rafId = 0; return }      // visibilitychange restarts
  const dt = lastFrame ? Math.min(nowMs - lastFrame, 50) : 16.67
  lastFrame = nowMs
  sizeCanvasIfNeeded()                             // DPR <= 3, only on change
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0); ctx.clearRect(0, 0, w, h)
  state.value = lerp(state.value, target.value, reducedMotion ? 1 : 0.08, dt)
  state.range  = lerpRange(state.range, target.range, dt)  // snap outward if exceeded
  drawSpline(ctx, project(data, state))            // + fill, dot, badge...
  rafId = requestAnimationFrame(frame)
}
document.addEventListener('visibilitychange', () => {
  if (!document.hidden && !rafId) rafId = requestAnimationFrame(frame)
})
```

## Pattern inventory

Line (with gradient fill at 12%/8% alpha fading to 0), badge pill (default accent / minimal white, optional tail) tracking the line tip, momentum arrows + dot glow, `exaggerate` tight axis, `showValue` overlay, `scrub` crosshair, candlestick mode with live candle + candle→line morph (500ms, bodies collapse to close, center-out line, coordinated alpha crossfade), multi-series (2+ shows toggle chips; badge/fill/momentum auto-disabled; last visible series cannot be hidden), orderbook depth, `degen` mode (burst particles + chart shake on momentum swings), loading/empty/paused states, time-window buttons (default/rounded/text styles with a sliding indicator at 250ms `cubic-bezier(0.4,0,0.2,1)`), reference line, theme derived entirely from one accent (grid at 6% alpha, labels at 40%, labels always in mono: `11px "SF Mono", Menlo, monospace`).

## When to use / When NOT to use

Use when: data streams in continuously (≥ ~1 update/sec); the chart is the interface's heartbeat (trading, monitoring, prediction markets, live telemetry); you want one visual system where every state change is legible motion. Installing is justified when you need candlesticks/orderbook/multi-series out of the box — recreating the full morph choreography is weeks of work.

Do NOT use when:
- Data is static or updates rarely — render an SVG path once; a lerp engine is dead weight and a canvas kills accessibility for nothing.
- Charts must be accessible/SEO-relevant: canvas content is invisible to screen readers and scrapers — if required, ship SVG with `<title>`/data table, or add an offscreen fallback Liveline doesn't provide.
- Users need to read exact values or export/print — canvas rasterizes; DOM/SVG text stays crisp and selectable.
- You need axes, legends, annotations, zoom/pan tooling — Liveline has none by design; use a full charting library.
- A cheap recreate suffices: line + fill + smoothed tip is ~100 lines with the snippets above.
- `degen` (particles + shake) and `exaggerate` are for playful high-velocity feeds only — see slop warning.

## How to apply

1. Render to a single canvas sized via `ResizeObserver`, DPR-clamped to 3; never create DOM per data point.
2. Drive all motion from one rAF loop; convert every discrete update into a lerp target (base 0.08/frame), using the dt-corrected formula above so 120Hz and 30Hz displays behave identically.
3. Stop the loop on `document.hidden`; clamp dt to 50ms; honor `prefers-reduced-motion` with speed = 1.
4. Smooth the line through Fritsch–Carlson tangents — never natural splines on live data (overshoot fabricates values).
5. Animate the Y-range (0.15 adaptive) but snap it outward instantly when exceeded; snap all lerps near their target (0.5px / 0.001) to kill shimmer.
6. Keep history stable, animate only the tip: last point Y = smoothed value, X = true data time.
7. Make loading, empty, and data one continuous shape — same base geometry, center-out reveal at ~0.09, color blending in late (×3), fill proportional.
8. Interpolate time-window zoom in log space over 750ms with cosine ease; keep a 5% future buffer on the right edge.
9. Reserve fixed semantic colors for direction (green `#22c55e` up / red `#ef4444` down); accent color only for identity. Lerp color changes (0.12), never pop.
10. Measure text once (digits-as-`8` template), lerp the container width (0.15), position with `translate3d` — monospace numerals plus lerped width equals zero horizontal jitter.
11. Update live text overlays via direct DOM writes through refs, not React state — 60fps text with zero re-renders.
12. Test with hostile data: spikes, reversals, irregular arrival, tab-hidden gaps. "A chart that only looks good on calm data isn't much use."

## AI-slop warning

The crypto-dashboard look is the failure mode: orange `#f7931a` accent + `exaggerate` + `degen` particles + shake pasted onto any dashboard instantly reads as a Polymarket/Binance clone, and `exaggerate` on near-flat data fabricates drama (1% margins amplify noise into fake volatility — actively misleading for anything analytical). Green/red momentum arrows on non-financial charts import trading connotations where they don't exist (a status chart that flashes red on noise reads as failure). Common AI misimplementations of the *mechanism*: CSS-transitioning the whole chart (breaks the one-clock coherence), natural-cubic splines (overshoot), un-snapped lerps (eternal sub-pixel shimmer), per-frame `getBoundingClientRect` (layout thrash), re-rendering React per tick to move the value (the exact thing the 60fps DOM-write pattern exists to avoid). A live chart in an enterprise or content context — with particles and shake — poisons credibility; the breathing-lerp core is the transferable part, `degen` is not.

## Relations

- **easing** — supplies the easing vocabulary this library's exponential lerp replaces; use its curves for one-shot transitions, the dt-corrected lerp for continuous streams.
- **number-flow** — same problem (discrete numbers → continuous display) isolated to a single value; Liveline's `showValue` overlay is number-flow logic hand-rolled on canvas-adjacent DOM.
- **loading-dev** — loading-state doctrine; Liveline's contribution is that loading must share geometry with the loaded state so the handoff is a morph, not a swap.
- **transitions** — general transition choreography; Liveline adds the streaming-specific rule: animate the *range and chrome*, not just the entering data.
- **web-interface-guidelines** — baseline perf/a11y rules (reduced motion, contrast) that the canvas approach satisfies for motion but cannot satisfy for screen readers — apply its a11y fallbacks when adopting this pattern.
