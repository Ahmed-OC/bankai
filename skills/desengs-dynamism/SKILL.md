---
name: desengs-dynamism
description: Use on EVERY build after the signature exists — the connective-tissue motion system that keeps every part alive (micro-hovers, rolling numbers, staggered lists, ambient breathing, symmetric exits, FLIP continuity) so the page never reads as static between interactions.
source: synthesized from the motion-audit of 5 eval builds + Codrops/Material/NN/g motion literature (attributions inline)
category: principle
---

# Dynamism (desengs) — no L5 islands in L1 seas

Source: motion audit finding — every audited build spent its entire motion budget on one signature (a dial, a console, an orb system) plus a 120ms color layer, and starved the connective tissue. The client reads the starved 80% as "there is no animation". This skill is the antidote: per-part micro-motion with exact specs.

## The Dynamism Ladder (know your target per mode)

- **L0 static** → **L1 states-only** (color swaps) → **L2 micro-feedback** (scale/rotate/press, 100-200ms causality) → **L3 entrance choreography** (curtains, masked lines, staggers) → **L4 scroll-linked** (parallax, scrub, progress-tied instruments) → **L5 ambient life** (idle breathing, drift, shimmer) → **L6 reactive continuous** (springs, momentum, pointer fields, streaming — a physical conversation).

**Mode targets**: Operate: L2-3 at rest, L5-6 only while the machine works (orbs, spinners, streams). Create: L2-3, L5 on canvas moments. Consume: L3-4, motion for pacing. Entice: **L5-6 sustained** — idle life plus reactive signature. Play: L6.
Gate check: measure the level at rest AND at peak; a signature at L6 above an L1 page FAILS the Entice floor.

## The 10 deadness patterns (banned)

1. Hover = color/border swap only (no lift/translate/scale/shadow step anywhere).
2. Icons never animate (no draw-on, rotate-on-action, morph; sort arrows display-swap; send↔stop innerHTML swap).
3. Numbers never roll (stats, counts, totals, money — instant textContent swaps; numbers are the SUBJECT of most products).
4. Lists teleport on state change (innerHTML wipe, no FLIP, no stagger, no crossfade — 30 rows sort = quantum jump). FLIP must be COMPLETE: survivors invert-and-play, and filtered-out rows get an exit (fade + collapse), not instant `display:none`.
5. Below-the-hero motion desert (no entrances, no scroll-link; one audited landing had literally zero IO).
6. Nothing breathes at idle (page dies between interactions; status dots frozen; suns frozen).
7. Overlays half-animate (dialog animates in, never out; menus display-snap; asymmetric choreography reads broken, not calm).
8. Content state swaps are instant cuts (form success panels, dialog prev/next, error→resolved, empty states).
9. Exits missing everywhere (100-150ms ease-in exits are as mandatory as entrances).
10. Data responds without physics (forecast redraws per keystroke with zero damping — raster, not physical).

## Per-part micro-motion specs (the finesse kit)

**Nav/links**: shared 2px indicator bar, `translateX+scaleX` 300ms to active item; link underline `scaleX(0→1)` origin left 200ms; hover lift `translateY(-1px)` on nav items where tasteful.
**Buttons/CTAs**: bg/border 120-180ms + active `scale(.97)`; primary hover adds one shadow step (not color-only); icon buttons rotate/morph their glyph on state change (180ms crossfade + 90° rotate for send↔stop, menu↔close).
**Rows/cards**: hover `translateY(-2px)` or accent-bar `scaleY` origin top 140-220ms; title `translateX(4-8px)` 200ms; selection inset bar `scaleY(0→1)` 140ms origin top.
**Lists**: entrance/re-render stagger `--i * 40-70ms` capped ≤600ms total; **FLIP on sort/filter/paginate** (record rects → re-render → invert → play 200ms `cubic-bezier(.22,1,.36,1)`, 4ms/row stagger capped 120ms) so rows travel instead of teleporting.
**Numbers**: tween 220-400ms cubic-out, `tabular-nums`; jump to final under reduced-motion. Stats count up once on first IO view (static-capture safe: final state = painted state).
**Dialogs/menus/toasts**: entry scale(.96-.985)+opacity+translateY(8px) 160-200ms ease-out; **exit 100-150ms ease-in** — use `@starting-style` + `display/overlay: allow-discrete` for native both-ways; prev/next content crossfades 200ms.
**Expansion panels** (receipts, glossaries, quotes): `grid-template-rows: 0fr→1fr` 220ms ease-out — never `is-hidden` snap.
**Charts/data**: crosshair/tooltip 60-120ms; cells flash 200ms on change; input-driven redraws tween (critically damped lerp ~150ms settling in rAF) — never raw attribute writes per event.
**Idle/ambient**: ≤2 concurrent loops per viewport, transform/opacity only, small composited area — breathing rings (`::after` scale 1→1.6-1.9 + fade, 2.4-4s ease-in-out infinite), needle/star drift (`sin(t/6000)*small`, in the existing shared rAF), grain `steps(6)` jitter. Never animate box-shadow per frame.
**Checkboxes/strikes**: underline via `background-size 0→100%` 250ms; tombstones slide in 200ms; count badges pop `scale 1.15→1` 150ms on change.

## Ambient & scroll laws (RM-safe, compositor-cheap)

- Every loop gated by `prefers-reduced-motion` (CSS block + JS matchMedia kill), paused on `document.hidden`, IO-gated to on-screen elements, paused while a modal owns focus.
- One shared rAF loop per page, dirty-flagged — and the BUS ITSELF must idle: systems that only update on events unregister (or flag) when clean; never do per-frame layout reads (`offsetTop/Height`) inside the bus — cache rects, re-measure on resize AND after any data mutation that changes document height (a filtered list with stale measurements drifts).
- Drag-driven scrolling: compute velocity from the gesture's actual axis, and force `behavior:'instant'` on programmatic scrolls during drag (`html{scroll-behavior:smooth}` otherwise queues an eased scroll per pointermove — reads as lag).
- Stagger via `animation-delay`/`transition-delay` custom properties — never setTimeout chains.
- Deterministic/static-capture builds: the line is **"once on reveal" vs "forever"** — one-shot entrances and count-ups are capture-safe; continuous clocks are not. Do not over-apply determinism to ban entrances.

## How to apply

1. After the signature exists, run the 10-pattern audit against your build; every hit is a bug.
2. Walk every part (nav, buttons, rows, lists, numbers, overlays, panels, charts, footer) against the spec kit; ship the applicable spec for each.
3. Check the ladder: at-rest level AND peak level meet the mode target.
4. Verify all motion is transform/opacity in hot paths, one voice (one easing family + tiers 120/180/300/450-650ms), exits exist.

## AI-slop warning

Over-correction is the new risk: everything moving (stagger on every list, marquees near body text, hover-lift on table rows in a fintech tool, ambient loops in Operate at rest). Connective-tissue motion must stay below the signature's register — quiet, fast, consistent — so the ONE big moment stays big. In Operate at rest: L2-3 means micro-feedback and FLIP continuity, NOT ambient animation.

## Relations

`desengs-spectacle` (arrival + signature — this skill is everything around it), `desengs-transitions` + `desengs-easing` (the catalogs), `desengs-animations-dev` + `desengs-you-dont-need-animations` (R1 gate still rules — this skill budgets the CONNECTIVE tissue, not new spectacle), `desengs-3d-craft` (the reactive-continuous tier), `desengs-number-flow` (rolling numbers done right), `desengs-micro-craft` (the static polish this moves).
