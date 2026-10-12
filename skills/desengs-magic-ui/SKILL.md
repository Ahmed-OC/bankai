---
name: desengs-magic-ui
description: Use when adding signature animated effects (border beam, shimmer skeleton, dot pattern, number ticker, spotlight hover) to any web UI. Magic UI patterns ported to plain CSS, one meaningful moment per screen.
source: https://magicui.design/
category: library
---

# Magic UI (desengs) — animated component catalog, ported to plain CSS

Source: https://magicui.design/ — Magic UI (GitHub: `magicuidesign/magicui`, MIT). 150+ free open-source animated components for React, TypeScript, Tailwind CSS and Motion, positioned as "a perfect companion for shadcn/ui"; listed on desengs.com as "Beautiful UI components and templates to make your landing page look stunning".

## What it is / Why it exists

- 150+ open-source animated components built with **React, TypeScript, Tailwind CSS and Motion** (formerly Framer Motion), positioned as a companion to shadcn/ui. It exists because landing pages need "stunning" cheaply: copy a component, get a premium animated moment.
- Catalog grouped in: **Special Effects** (Border Beam, Animated Beam, Shine Border, Magic Card, Meteors, Confetti, Particles), **Text Animations** (Number Ticker, Animated Shiny Text, Blur Fade, Word Rotate…), **Backgrounds** (Dot Pattern, Grid Pattern, Flickering Grid, Ripple, Retro Grid, Noise…), **Buttons** (Shimmer, Ripple, Rainbow), **Community** (Neon Gradient Card, Animated Circular Progress…).
- Distribution model: copy-paste registry (`shadcn add @magicui/...`) — the components are small, local snippets, not a runtime dependency. This is exactly what makes them easy to port to **plain CSS**: each one is a 30–80 line mechanism.

## The core ideas

1. **One strong moment per screen.** A border beam on the finished result OR a spotlight on hover — never both fighting. Everything else stays quiet.
2. **Motion = meaning.** Shimmer says "pending", beam says "done, look here", ticker says "value just changed". If an effect carries no state information, it is decoration and must justify itself twice.
3. **Continuous loops are rare.** Reserve infinite animations for pending states (shimmer) and single-instance focus (one beam). Prefer *triggered* animations (ticker on value change, spotlight on hover) that stop by themselves.
4. **Cheap by construction.** Animate only `transform`, `opacity`, `background-position` or a registered CSS custom property (`@property`). No JS timers except the number ticker; no layout thrash; `pointer-events: none` on all overlay layers.
5. **Respect `prefers-reduced-motion`.** Every effect degrades to its static resting state: beam becomes a static gradient border, shimmer stops, ticker jumps to the final value.
6. **Port the mechanism, don't install.** If your project already standardizes on the Tailwind + Motion (shadcn/ui) stack, use the registry — it drops local snippets, not a dependency. Otherwise re-implement the mechanism in plain CSS + a tiny hook; importing Tailwind or Motion just to run one beam or one spring is never worth it.

## The five app-safe mechanisms (plain CSS / dependency-free ports)

### 1. Border Beam — light traveling around a card border

Magic UI's `BorderBeam` runs a gradient beam along the container border (`size`, `duration`, `colorFrom`, `colorTo`, `delay`, `reverse`). Mechanism: a **conic gradient rotated over time** (registered `@property` angle), masked so only the 1–2px border ring is painted.

```css
@property --beam-angle { syntax: "<angle>"; inherits: false; initial-value: 0deg; }

.beam-card { position: relative; border-radius: var(--radius, 14px); }
.beam-card::after {
  content: "";
  position: absolute; inset: -1px;
  border-radius: inherit; padding: 1.5px;
  background: conic-gradient(from var(--beam-angle),
    transparent 0deg 300deg,
    var(--beam-from, #ffaa40) 330deg,
    var(--beam-to, #9c40ff) 355deg, transparent 360deg);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
          mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
          mask-composite: exclude;
  animation: beam-spin var(--beam-duration, 6s) linear infinite;
  pointer-events: none;
}
@keyframes beam-spin { to { --beam-angle: 360deg; } }

@media (prefers-reduced-motion: reduce) {
  .beam-card::after { animation: none; --beam-angle: 45deg; } /* static accent border */
}
```

```tsx
<div className="beam-card">{/* result card content */}</div>
```

Notes: the double-mask (`content-box` XOR full box) is what paints only the ring. `@property` animation works in Chromium/modern browsers; the reduced-motion fallback doubles as the graceful degradation elsewhere.

### 2. Shimmer on Skeleton — the pending sweep

Magic UI's `AnimatedShinyText` sweeps a light band via `background-clip: text` + animated `background-position`. For **skeleton placeholders**, the same idea is better applied as a translating gradient overlay on the block (GPU-friendly `transform`):

```css
.skeleton {
  position: relative; overflow: hidden;
  background: var(--surface-3, #1c1c1f);
  border-radius: 8px; color: transparent;
}
.skeleton::after {
  content: ""; position: absolute; inset: 0;
  transform: translateX(-100%);
  background: linear-gradient(90deg, transparent,
    rgba(255, 255, 255, 0.06), transparent);
  animation: shimmer 1.8s ease-in-out infinite;
}
@keyframes shimmer { to { transform: translateX(100%); } }
@media (prefers-reduced-motion: reduce) { .skeleton::after { animation: none; } }
```

```tsx
{pending && <div className="skeleton" style={{ height: 56 }} aria-hidden />}
```

Keep the highlight subtle (5–8% white): a shimmer is a whisper of activity, not a strobe.

### 3. Dot Pattern — quiet background texture

Magic UI's `Dot Pattern` is an SVG `<pattern>` of circles (`width`/`height` tile, `cr` radius) faded with a radial `mask-image`. The CSS equivalent is a single `radial-gradient` tile — no SVG needed:

```css
.dot-bg {
  background-image: radial-gradient(circle,
    var(--dot-color, rgba(150, 150, 160, 0.22)) 1px, transparent 1.5px);
  background-size: 16px 16px;
  -webkit-mask-image: radial-gradient(420px circle at 50% 0%, #000 20%, transparent 75%);
          mask-image: radial-gradient(420px circle at 50% 0%, #000 20%, transparent 75%);
}
```

The mask fade is the whole trick: dots are dense near the focal point and dissolve outward, so the texture reads as atmosphere instead of wallpaper. It is static — do not animate it.

### 4. Number Ticker — animated number without Motion

Magic UI's `NumberTicker` counts to `value` with a Motion spring when it enters the viewport (`delay`, `decimalPlaces`, `startValue`, `direction`). Dependency-free port: one hook, `requestAnimationFrame`, cubic ease-out. Trigger it when the value *changes* (estimate recalculated, job finished), not on scroll.

```tsx
function useTicker(target: number, duration = 800) {
  const [shown, setShown] = React.useState(target);
  const fromRef = React.useRef(target);
  React.useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      setShown(target); return;
    }
    const from = fromRef.current; const t0 = performance.now();
    let raf = 0;
    const tick = (t: number) => {
      const p = Math.min(1, (t - t0) / duration);
      setShown(from + (target - from) * (1 - Math.pow(1 - p, 3)));
      if (p < 1) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    fromRef.current = target;
    return () => cancelAnimationFrame(raf);
  }, [target, duration]);
  return shown;
}
// Usage: <span>{new Intl.NumberFormat(locale,
//   { style: "currency", currency }).format(useTicker(cost))}</span>
```

Reserve it for numbers that **change**: a static price ticking on mount is noise.

### 5. Spotlight Hover (Magic Card) — cursor-tracked highlight

Magic UI's `MagicCard` tracks the cursor and renders a radial-gradient spotlight (`gradientSize` 200, `gradientColor`, plus a gradient border glow). Pure-CSS mechanism: write `--mx`/`--my` custom properties on `mousemove`, read them from two gradient layers.

```tsx
function trackSpotlight(e: React.MouseEvent<HTMLElement>) {
  const r = e.currentTarget.getBoundingClientRect();
  e.currentTarget.style.setProperty("--mx", `${e.clientX - r.left}px`);
  e.currentTarget.style.setProperty("--my", `${e.clientY - r.top}px`);
}
// <div className="spot-card" onMouseMove={trackSpotlight}>…</div>
```

```css
.spot-card { position: relative; }
.spot-card::before {           /* soft inner light */
  content: ""; position: absolute; inset: 0; border-radius: inherit;
  opacity: 0; transition: opacity 0.3s ease; pointer-events: none;
  background: radial-gradient(220px circle at var(--mx, 50%) var(--my, 50%),
    rgba(255, 255, 255, 0.06), transparent 70%);
}
.spot-card:hover::before { opacity: 1; }
```

Do not add JS listeners for anything but the two `setProperty` calls — no re-render, no state, no Motion.

**Considered and skipped for app UIs:** Meteors (decorative shower, landing-page vocabulary), Marquee (infinite loop competing with content), Aurora/Gradient Text (already busy heroes), Confetti (celebration should be rare — keep for a first-ever success maybe).

## When to use / When NOT to use

**Use when:**
- An application screen needs **one signature moment**: a background job completing, a pending state, an empty-state hero, a value that ticks.
- You want the *feel* of Magic UI (alive, premium, "the machine is working") without importing Tailwind, Motion, or any library.
- Status feedback: loading → done transitions, estimates updating, hover affordances on cards.

**Do NOT use when:**
- Marketing landing pages (marquees, meteors, globes, bento grids) are the target — this skill deliberately selects the app-safe subset, not the full catalog.
- Errors and destructive confirmations — motion there must be minimal and calm, not celebratory.
- Anything that animates more than ~3s continuously in a list of many items (see Anti-patterns).

## How to apply (numbered checklist)

1. Audit the screen for the one state worth signaling (job completed, pending, value changed). If none exists, add zero effects.
2. Map state → effect: **beam** on completion (add the class when the job state flips to done; set `--beam-from`/`--beam-to` to accent colors, `--beam-duration: 5s`; optionally remove the class after the user views the result once so "done" stays an event, not wallpaper).
3. **Shimmer** for pending list items: skeleton blocks (thumbnail, title line, status pill) with realistic height/width so layout doesn't jump on resolve.
4. **Dot pattern** for hero or empty-state headers, e.g. behind a composer or primary input, masked to fade downward from the top — keeps the empty state alive without a single loop.
5. **Ticker** for values that recompute (cost estimates, credits, counts): tick on change only, format with `Intl.NumberFormat` in the user's locale, no tick on first mount.
6. **Spotlight** as the hover affordance on gallery/result/history cards — a quiet complement that never runs while a beam is active on the same screen.
7. Enforce the budget: at most ONE always-running loop per screen (usually the shimmer of one pending job), ONE event-triggered moment (beam), plus hover-only garnish (spotlight).
8. Animate only `transform`/`opacity`/`background-position`/registered custom properties; `pointer-events: none` on every overlay layer.
9. Verify each effect under `prefers-reduced-motion: reduce`: static gradient border, flat skeleton, final number, spotlight off.

## Anti-patterns

- **Making everything sparkle.** Beam + shimmer + spotlight + ticker on one screen = carnival. Pick the moment that carries the state ("your render is ready") and mute the rest.
- **Infinite loops on static content.** A beam running forever on an idle card stops signifying "done". Tie it to a state (or stop it after first interaction).
- **Shimmering text everywhere.** `AnimatedShinyText` on headings, buttons and badges simultaneously dilutes it to kitsch. If at all, one status pill.
- **Meteors, marquees, globes in a tool UI.** They are landing-page energy; in a workspace they read as a demo, not a product.
- **Animating layout properties.** No `width`/`top`/`box-shadow` keyframes — transform/opacity/custom-property only.
- **Ignoring reduced motion.** Each effect must keep a meaningful static state (gradient border, flat skeleton, final number).
- **Porting Motion for one spring.** If a number ticker is the only use, 15 lines of rAF beat a 30 kB dependency.

## AI-slop warning

The beam + shimmer + meteors stack became the default AI-generated landing page circa 2024–2025: agents reach for `BorderBeam` on every card, shiny text on every heading, and dot-pattern heroes by reflex, producing pages that look like every other AI product demo. The tells: multiple infinite loops per screen, effects carrying no state, animation in error or destructive contexts, dense data tables with hovering spotlights. Magic UI's own marketing volume ("150+", "stunning") is for landing pages — in tools, editors and dashboards it poisons trust and reads as a template. Copy the mechanism only after naming the state it reports.

## Relations

- **desengs-fancy-components** — sibling copy-paste component library distillation; consult it for alternative signature components before committing to a Magic UI pattern, and for the same port-don't-install discipline applied elsewhere.
- **desengs-transitions** — supplies the timing and easing numbers (durations, cubic-bezier curves, spring vs ease-out) that these mechanisms must obey; Magic UI defines *what* moves, this defines *how it moves*.
- **desengs-taste** — the restraint doctrine behind "one moment per screen" and the anti-slop rules; directly contradicts Magic UI's landing-page abundance and is the arbiter when an effect feels like decoration.
