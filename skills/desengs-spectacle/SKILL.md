---
name: desengs-spectacle
description: Use when a surface must land as extraordinary — Entice/Play builds (landings, portfolios, studio sites, launch moments) that need arrival choreography, a signature hero moment, scroll craft, cursor craft, or atmosphere, without sacrificing the canon's usability floors.
source: https://www.awwwards.com/websites/sites_of_the_year/; field research on Lusion, Active Theory, Obys, Locomotive, Exo Ape, basement.studio, Linear, Vercel
category: principle
---

# Spectacle (desengs) — the arrival layer: award-grade wow that never breaks the contract

Source: distilled from Awwwards Site-of-the-Year dissections (Lusion 2023, Igloo Inc 2024, Lando Norris 2025 — note: built on Webflow, proving arrival-feel is art direction, not engine), studio practices (Active Theory, Obys, Locomotive, Exo Ape, basement.studio, darkroom.engineering), product-side excellence (Linear, Vercel/Rauno Freiberg), and Codrops/CSS-Tricks/web.dev technique literature.

Why this skill exists: the canon converts slop into competence (states, a11y, restraint — flawless) but its veto architecture (R1/R2/ban list) is one-way: it punishes excess, never demands brilliance. Eval evidence: 8/8 canon builds passed every gate while none dazzled — signatures shrank to hover-garnish, no build ever claimed MOTION 4-5 or VARIANCE 5 on Entice briefs. This child is the positive mandate layer.

The jury math (why 8.5 ≠ 10): Awwwards scores **Design 40 / UX-UI 30 / Creativity 20 / Content 10**; SOTD ≈ 8.0+ weighted. Design+UX = 70% — spectacle without usability loses, usability without spectacle caps at "very good". You need both axes maxed.

## The Signature Law (the core rule)

Every Entice or Play build ships **exactly one signature moment** — a scene a jury member would screenshot — executed past obsession:

**Monumental first paint** (jury evidence: the one axis where unaided builds still beat canon builds): the hero must OWN the first viewport through scale — display type at h1 ≥ 80-100px at 1440px (clamp it), or an equivalent monumental composition (giant numeral, full-bleed reactive canvas with type integrated). A "quiet, well-set" hero is a Design-axis failure on Entice/Play no matter how coherent.

**Static-capture law**: the FIRST painted frame must be a complete, final-looking state. Live data ticks, morphs, and auto-animations may only start after first user interaction (or must leave a complete deterministic initial frame) — link previews, crawlers, and jury screenshots catch your first frame; a mid-morph blank console reads as broken.

- The signature is a *scene* (composition + motion + interactivity working together), never a garnish (a hover shine, a one-shot draw-in line).
- It earns its budget: everything else on the page stays quiet SO THAT this moment is expensive. Restraint is the funding mechanism for spectacle, not its opposite (Rauno: high-frequency surfaces get zero animation so the hero moment stays costly).
- It responds to the user (cursor, scroll, drag) — a passive video-like hero reads as decoration; a reactive one reads as *alive, now, for me* (Lusion's real-time presence).
- Minimum bar: kinetic or oversized type + one reactive system (canvas field, repulsion grid, parallax stack, physics drag) + entrance choreography. Below this bar = not a signature, try again.

**Effect-zoo test**: list every animated/decorative element on the page. If more than one *family* of effect exists without a shared easing/motion voice, you have a zoo — cut to the signature. Unification is what reads as "one idea".

## Arrival choreography (the first 2.5 seconds)

The loader is choreography, not a tollbooth — it rehearses the site's motion language:

1. **Counter → curtain reveal** (the SOTD formula): oversized 0–100% counter bottom-left, wordmark center; progress advances via rAF easing but *snaps to real load* (`window.load` sets 100 — never fake-block on trivial assets); then a full-viewport panel wipes up (`transform: translateY(-101%)`, `transition: transform 1s cubic-bezier(.76,0,.24,1)`) exposing content already staged beneath. Total ≤2.5s. Defense in depth: JS also removes the loader from the DOM on `animationend` (harnesses that freeze compositor animations must never trap the page behind a curtain), and the delay stays ≤1.5s. Reduced-motion: skip straight to content.
2. **Masked line reveal**: headline lines rise from `overflow:hidden` wraps — inner spans `translateY(110%) rotate(4deg)` → 0, 80ms stagger (`transition-delay: calc(var(--i)*80ms)`). Motion as hierarchy: gaze follows the unmasking order.
3. **Stagger-in grid**: post-curtain, cards/thumbnails fade-rise on diagonal delays (`--i + --row`), one class toggle fires all.
4. **Counter-synced brand morph**: the % number also drives a scale/rotation on the wordmark (`scale(1 + p/100)` in the counter loop) — two coupled systems read as a living machine.

## Hero moment engineering (pick ONE, execute past obsession)

- **Kinetic variable type**: massive headline whose `wght`/`wdth` axis breathes on a loop or tracks cursor-x via lerped `font-variation-settings`. Type is the interface; animating it proves the medium is alive. (2025-26 dominant hero trend.)
- **Canvas 2D flow field**: ~1500 particle-strokes following a Perlin-noise vector field behind the type; fading trails via translucent `fillRect` overlay. Pause when offscreen/tab-hidden. The honest WebGL-substitute — organic, non-repeating, reads as generative art, not animation.
- **Reactive type grid**: headline split to spans; per-frame repulsion from cursor `translate = dir * max(0, 1 - dist/r)²`. The page "flinches" — users immediately test the boundary, which is engagement (Igloo Inc energy).
- **Layered parallax stack**: fore/mid/background layers at different rates on scroll or lerped mousemove (`data-depth` scaled `translate3d`). Strongest monocular depth cue — 3D without WebGL.
- **CSS 3D scene**: `perspective:1000px` + `preserve-3d`, planes tilting with pointer clamped to ±8°, blurred duplicate planes as depth-of-field.
- **Reactive marquee**: infinite text band bisecting the hero (`translateX(-50%)` loop on a duplicated track), velocity modulated by scroll delta. Peripheral motion implies ongoing activity.

## Scroll craft (vanilla, no hijacking)

1. **Pinned scrub scene** — the most awarded pattern: outer section `height:300vh`, child `position:sticky; top:0; height:100vh`; rAF computes `p = clamp((scrollY-top)/(height-vh), 0, 1)`; all transforms derive from `p`. The user becomes the animator — causality is felt, not watched.
2. **Native scroll-driven CSS** (zero JS): `animation: reveal both; animation-timeline: view(); animation-range: entry 0% entry 60%` — ~87% support; wrap in `@supports` with an IO fallback.
3. **Horizontal gallery in vertical scroll**: same sticky pattern, `track.style.transform = translateX(-p*(trackWidth-vw))`. Axis violation is memorable and portfolio-efficient.
4. **Scrub-locked type scale**: pinned headline `scale(1 + p*7)` + fade — a cinematic camera push handing off to the next section.
5. **Progress indicator**: fixed `01→06` section counter or hairline top bar from `scrollY/(docHeight-vh)` — orientation + reward that sustains scrolling.

Never hijack native scroll (surprise-jacking is an anti-pattern); pin and derive instead.

## Interaction richness (the reward layer)

- **Lerp cursor with states**: dot (0.15 lerp) + trailing ring (0.08), `mix-blend-mode: difference` so it survives any background; `[data-cursor]` targets swap inner label ("VIEW", "DRAG"). Hide native cursor only on `(pointer:fine)`; restore immediately on touch.
- **Magnetic elements**: `translate((mx-cx)*.3, (my-cy)*.3)` inside the parent rect, spring-back transition on leave. Gravity = tactile.
- **Text scramble/decode**: headings resolve through `"!<>-_\\/[]{}—=+*^?#?"` left-to-right (Windle's algorithm) — completion compulsion; use ONCE (nav hover or first heading), never everywhere.
- **Image trail**: accumulate pointer distance; every ~120px spawn a pooled `img` with random rotation, scale-in/fade via CSS, remove on `animationend`. Converts navigation into play.
- **Physics drag**: pointer-tracked cards with velocity carry (`v *= .95` per frame on release) and rubber-band edges (`translate + (edge-pos)*.2`). Momentum feels expensive.

## Transitions & continuity

- **Curtain wipe** between contexts: fixed layered panels, staggered `translateX`, content swapped at midpoint — occlusion hides layout thrash and creates cause-effect.
- **View Transitions API**: `document.startViewTransition(() => swap())` + `::view-transition-old/new` keyframes; shared elements via matching `view-transition-name`. Gate on `@supports` + reduced-motion skip. The native morph is 2026's continuity flex.
- **Sticky handoff**: pinned hero stays while the next section slides over it — pure `position:sticky` + z-index.

## Texture & atmosphere (unify everything)

- **Film grain**: inline SVG `feTurbulence fractalNoise baseFrequency=0.65 numOctaves=3` on a fixed `pointer-events:none` layer, `mix-blend-mode:overlay; opacity:.06`, animated via 8-step `background-position` keyframes (cheaper than re-filtering). Kills gradient banding; adds "analog premium".
- **Gradients as light**: radial "light sources" + noise + `filter: contrast(170%) brightness(1000%)` inside `isolation:isolate` — lighting, not decoration. One ink, one accent, light (Vercel: one tone carries every heading, CTA, and 1px border).
- **Duotone imagery**: `grayscale(1) contrast(1.1)` + colored overlay in `screen/multiply` pair — enforced palette reads as art direction; hover can restore color.
- **Generative field**: subtle noise-displaced dot grid or contour lines drifting beneath content at low opacity — the page breathes between interactions.

## The 10 commandments (condensed)

1. Loader = choreography, never tollbooth. 2. One signature idea, executed past obsession. 3. Type is the interface. 4. Motion has physics: weight, momentum, interruptibility — nothing on linear rails. 5. Budget restraint: high-frequency actions get nothing so the signature stays expensive. 6. Palette economy: one ink, one accent, light + grain. 7. The cursor is a character. 8. Usability is 30% of the score — real nav, semantics, reduced-motion paths. 9. Drama amplifies content, never replaces it. 10. Ship one coherent system, not ten rented effects.

## The 5 anti-patterns (attempted-award tells)

1. **Loader-as-gate** (blocking on trivial assets). 2. **Effect zoo** (scramble + marquee + cursor + transitions with no unified voice). 3. **The legibility tax** (gray-on-gray, video-under-text, art-directed unreadability). 4. **Surprise-jacking** (scroll hijack; cursors that delete affordance without replacing it). 5. **Content-free drama** (a canvas hero that communicates nothing — "the rare site that earns its canvas").

## The balance laws (non-negotiable, all scored under UX)

1. **Loading**: ≤2.5s, tied to real load, content staged beneath the curtain so no-JS still shows everything. The loader unlock must NEVER depend solely on rAF/timers — if rAF stalls (throttled renderers, crawlers, previews), the page must still resolve (CSS keyframe max-duration fallback, or content visible beneath from the start). A loader that gates everything behind rAF is the #1 unaided-build failure.
2. **Navigation at every breakpoint**: a full menu (native `<details>` pattern or dialog) must exist below the collapse width — hiding nav links entirely on small viewports is an automatic UX-axis fail.
3. **Reduced-motion**: every effect has a `prefers-reduced-motion` path — CSS skips AND `matchMedia` JS kill-switch for canvas/lerp/scrub loops; static compositions must stand alone. Never solve reduced-motion by reloading the page.
4. **Content-first**: motion reveals content, never replaces it; no hijack.
5. **Performance**: transform/opacity only in hot paths, ONE shared rAF loop, canvases paused offscreen/hidden, passive listeners, `will-change` sparingly.
6. **Degrade gracefully**: `@supports` gates for View Transitions/scroll-driven CSS; `(pointer:fine)` gates for cursor craft; touch gets tap-equivalent feedback.

## When to use / When NOT

Use: Entice and Play surfaces; Create-mode launch/empty states; portfolio/marketing moments; anywhere a brief says "impress". NOT: Operate surfaces (arrival theatrics, cursor replacement, scrub scenes are banned there — instrument calm wins); content-reading surfaces (grain ≤ .04, no marquee near body text); anything where the signature would fight the data. The signature budget (master R2) still applies — this skill defines what ONE effect may be, not a license for ten.

## How to apply

1. Before building: name the signature in one sentence ("a flow-field of schedule strokes that part around the cursor"). If you can't name it, you don't have it.
2. Choose arrival choreography appropriate to load reality; stage content beneath; write the reduced-motion path first.
3. Build the signature with real interactivity; verify it responds to input within one frame budget.
4. Quiet everything else: audit every other animated element — does it share the signature's motion voice? Cut what doesn't.
5. Run the effect-zoo test and the 5 anti-patterns; then the balance laws as a checklist.
6. Screenshot test: capture the signature moment — is it screenshot-worthy? If not, increase commitment (scale, reactivity, choreography), not effect count.

## AI-slop warning

Cargo-cult Awwwards is 2026's fastest-growing tell: scramble text + marquee + custom cursor + grain sprinkled identically on every page; gradient-mesh hero + glassmorphism card + "scroll to explore"; a canvas particle field that ignores the cursor. Each technique here is a tool for ONE named signature — the moment your page has two signatures or a decorative canvas, it has none. Also banned by association: pink-purple mesh gradients, oversized "©2026 STUDIO™" pseudo-branding, `MOTION` `DESIGN` `CODE` chip rows.

## Relations

- **desengs-transitions** (the transition catalog this draws from), **desengs-easing** (unified motion voice), **desengs-animations-dev** + **desengs-you-dont-need-animations** (the R1 gate still applies to everything EXCEPT the one signature), **desengs-design-spells** (delight vocabulary for smaller moments), **desengs-images-in-motion** (imagery-specific craft), **desengs-taste** (the ban list still rules), **desengs-ui-land** (practitioner consensus: delight = speed first).
