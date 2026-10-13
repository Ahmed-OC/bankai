---
name: de-tools
description: Use when a task names a specialized job — record a demo, pick an easing, animate numbers, compress glTF — and you need the right tool or a by-hand mechanism. Maps the design-engineer tool landscape by job.
source: https://designengineer.tools/
category: tool
---

# Design Engineer Tools — the tool landscape, mapped by job

Source: https://designengineer.tools/ — "A list of useful tools for web-focused design engineers", curated by James Warner (jmswrnr.com; "Engineering playful experiences for the modern web"). Plain link directory: 20 categories, ~140 tools, zero descriptions, © 2026. The value is the taxonomy itself — how a working design engineer partitions the craft. Live-updated, so verify a tool still exists before recommending it.

## What it is / Why it exists

- Not a review site — a link list. What it encodes is a **job map**: inspiration → interface → code → components → utilities → motion → capture → 3D → organization. Treat the category names as the canonical vocabulary for routing a task.
- Two structural signals: **AI Code is a top-tier category** (Cursor, Claude Code, v0, Bolt, Cline, Codex, Windsurf, Zed — coding agents are now a core instrument, not a novelty), and **Video & Capture is its own category** — recording demos and repros is part of the design-engineer job, not an afterthought.
- Web-first: every entry either runs in the browser or produces web-deliverable assets (glTF, Lottie, SVG, video).
- The directory is thin on purpose. This skill adds what it refuses to state: which tool wins per category, the open-source twin, and the by-hand mechanism when installing is unjustified.

## The category map — 20 categories collapse into 6 jobs

1. **SEE** — Inspiration (Mobbin, Godly, Awwwards, Minimal Gallery, Minimum, Saaspo, Game UI Database, HUDS+GUIS, loadmo.re, Rebrand, Design Spells, Supahero, SEESAW, SOOT SPIRAL, 60fps, Cosmos, Curated Design, Interface In Game, Layers, Same Energy, SearchSystem, Pinterest); Fonts (Fontshare, Free Faces, Best Free Fonts, UNCUT, Fonts In Use); Research (ChatGPT, Gemini, NotebookLM).
2. **DESIGN** — Interface (Figma, Penpot, Framer, Rive, Paper, Stitch); Whiteboard (Excalidraw, tldraw, FigJam, Miro, Muse); Visual (ShaderToy, cables, NodeToy, Nodes, Bitspace, TouchDesigner, Unicorn.studio); 3D (Spline, Blender, Bezi, Houdini, Womp); Volumetric (Polycam, Luma AI, KIRI Engine, RealityScan, SuperSplat, Depthkit); glTF (gltfpack, gltfjsx, Needle Viewer); Digital Fashion (CLO, Marvelous Designer, Style3D).
3. **BUILD** — AI Code (above); Components (shadcn/ui, Motion Primitives, React Bits, NumberFlow, Fancy Components, Cursify, 21st.dev, Component Gallery, Framer University).
4. **REFINE** — Web Utility (oklch.com, color.review, easings.net, animejs Easing Editor, Easing Gradients, SVGOMG, Ray.so, RegExr, ui.camera); Motion (Theatre.js, Rive, Lottielab, Lottie Creator, Jitter, Cavalry); Audio (ElevenLabs, FMOD, Splice).
5. **SHOW** — Video & Capture (Screen Studio, OBS, ShareX, LosslessCut, Recordly, Parsec, ShadowPlay, OpenCut, DaVinci Resolve).
6. **OPERATE** — Organization (Linear, Obsidian, Eagle, Are.na, AFFiNE, Trello); Desktop Utility (Raycast, Warp, Granola, LocalSend, Deskflow, Claude Cowork, Wispr Flow); Browser (Zen, Arc, Brave, Firefox); Emoji (MakeEmoji).

## Task → tool routing (the skill's core)

| Task sounds like | Category | Standout (why) | By-hand mechanism |
|---|---|---|---|
| "How do real apps do X?" | Inspiration | Mobbin (real app flows/screens), Saaspo (B2B SaaS), Godly/Awwwards (marketing-grade), Game UI Database + HUDS+GUIS (fictional HUDs), loadmo.re (loading states), Rebrand (before/after redesigns), Minimal Gallery/Minimum (restraint) | Screenshot morgue (Eagle/Obsidian); steal structure and states, never pixels |
| "Pick a color/easing" | Web Utility | oklch.com (perceptual picker), color.review (contrast + CVD), easings.net (curve cheat sheet), animejs Easing Editor (interactive cubic-bezier) | CSS vars below; contrast = compute WCAG ratio, 4.5:1 body text |
| "Gradient bands" | Web Utility | larsenwork Easing Gradients | double-position stops or `color-mix()` steps |
| "Clean up this SVG" | Web Utility | SVGOMG (GUI for svgo) | `npx svgo in.svg -o out.svg`; 2-decimal path precision, strip editor cruft |
| "Need a component" | Components | shadcn/ui (copy-paste, you own the code), Motion Primitives/React Bits (animated patterns), NumberFlow (tweened numbers), Cursify (custom cursors) | 20–60 lines plain CSS/JS (number tween below); install only if you'd write >150 lines |
| "Motion prototype it" | Motion | Theatre.js (OSS keyframe editor, live in the DOM), Rive (state machines + tiny runtime), Lottielab/Lottie (vector-art JSON), Jitter (browser AE-lite, exports Lottie), Cavalry (procedural 2D) | CSS keyframes/`transition` + WAAPI; Lottie only for illustrator-grade vector art |
| "Test this animation" (smoothness) | — gap — | no category covers it; use browser DevTools, not a tool | rAF logger below + DevTools Rendering → Frame Rendering Stats |
| "Record a demo / repro" | Video & Capture | Screen Studio (auto-zoom, polished demos), OBS (OSS, full control), ShareX (Windows capture), LosslessCut (lossless trim), Parsec (low-latency remote pairing) | 2× DPR capture, 16:9 crop, trim to ≤60s, highlight cursor with CSS |
| "Shader/WebGL effect" | Visual | ShaderToy (GLSL gallery, live), cables/NodeToy (node-based, export JS), Unicorn.studio (no-code, embed export), TouchDesigner (installations) | one `<canvas>` + raw WebGL2; cap to visible viewport, test on iGPU |
| "3D model in the page" | 3D + glTF | Spline (design + embed), Blender (OSS full DCC); then gltfpack (compress), gltfjsx (codegen), Needle Viewer (inspect) | `gltfpack -i in.glb -o out.glb -cc -tc`; budget <2MB first-load model |
| "Screenshot device frames" | Web Utility | ui.camera (mocks screenshots onto device frames) | CSS device bezels; use real 2× DPR captures, never upscale |
| "Pretty code image for docs/social" | Web Utility | Ray.so (styled code cards) | highlight.js/Prism + padding + brand background |
| "Scan a real object" | Volumetric | Polycam/Luma/KIRI/RealityScan (photogrammetry), SuperSplat (Gaussian splats), Depthkit (volumetric video) | ship as optimized glTF, not raw scan |
| "Voice/sound" | Audio | ElevenLabs (voice), FMOD (adaptive audio), Splice (samples) | WebAudio; UI sounds short, quiet, user-mutable |
| "Sketch/explain an idea" | Whiteboard | Excalidraw (OSS, embeds as a component), tldraw (canvas SDK), Muse (tablet) | Excalidraw embed keeps it in-repo, no account |
| "Pick a font" | Fonts | Fontshare/Free Faces (free, quality), Fonts In Use (real-world pairing evidence), UNCUT (indie) | max 2 families, test at 14/16px body before committing |
| "Track issues / notes / refs" | Organization | Linear (issues), Obsidian (local markdown), Eagle (visual library), Are.na (collections) | notes live next to code |
| "Generate UI from a prompt" | AI Code | v0 (UI from prompt), Bolt (full app), Cursor/Claude Code/Cline (in-editor agents) | agents amplify the system in the repo — tokens/easings must already exist |

## By-hand mechanisms (when installing is unjustified)

**1. Easing + duration tokens** — what easings.net/animejs editor produce, as copy-pasteable CSS:

```css
:root {
  --ease-out-quad: cubic-bezier(0.25, 1, 0.5, 1);
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-in-out-quad: cubic-bezier(0.45, 0, 0.55, 1);
  --dur-fast: 120ms;   /* hovers, presses */
  --dur-move: 200ms;   /* small transforms */
  --dur-slow: 300ms;   /* overlays, page-level */
}
/* springs without a library: CSS linear() with generated stops */
```

**2. "Test this animation"** — no tool in the directory does this; paste in console while it runs:

```js
let last = performance.now(), frames = [];
(function tick(now) {
  const dt = now - last; last = now; frames.push(dt);
  if (frames.length >= 300) {                    // ~5s @60fps
    const s = [...frames].sort((a, b) => a - b);
    const p95 = s[Math.floor(s.length * 0.95)];
    console.log(`median ${s[150].toFixed(1)}ms | p95 ${p95.toFixed(1)}ms`,
      p95 > 20 ? "FAIL — dips under 50fps" : "OK");
    return;
  }
  requestAnimationFrame(tick);
})(performance.now());
```
Also: DevTools → Rendering → Frame Rendering Stats; throttle CPU 4×; verify `prefers-reduced-motion` actually disables the animation. Budget: 16.7ms/frame at 60fps; animate only `transform`/`opacity`.

**3. Animated number** — the NumberFlow mechanism in 10 lines:

```js
function tweenNumber(el, from, to, dur = 500) {
  const fmt = new Intl.NumberFormat(), t0 = performance.now();
  (function frame(now) {
    const p = Math.min((now - t0) / dur, 1), e = 1 - (1 - p) ** 3; // ease-out cubic
    el.textContent = fmt.format(Math.round(from + (to - from) * e));
    if (p < 1) requestAnimationFrame(frame);
  })(t0);
}
```

**4. Smooth gradient** — the Easing Gradients mechanism with native syntax (double-position stops):

```css
background: linear-gradient(to bottom,
  oklch(0.98 0.02 260) 0%,  oklch(0.98 0.02 260) 30%,
  oklch(0.72 0.12 260) 62%, oklch(0.27 0.05 260) 100%);
```

**5. Visual regression** — a category gap; the OSS default is Playwright, not a paid service:

```js
await expect(page).toHaveScreenshot("hero.png", { maxDiffPixelRatio: 0.02 });
```

## Workflow gaps the directory does NOT cover (fill them by mechanism)

- **Tokens pipeline** — no Style Dictionary/Tokens Studio entry; only Penpot (OSS, token-aware design) touches it. By hand: one `tokens.css` with custom properties + `@property` for typed values; generate multi-platform outputs from JSON only when a second platform exists.
- **Handoff** — deliberately absent. The design-engineer answer to handoff is to collapse it: design and code are the same person/artifact; AI Code + Components replace the spec. When handoff is unavoidable, ship code (Storybook-ish live components), never static screenshots.
- **Visual regression / testing** — no category at all. Mechanism above; run on every PR, diff at 2× DPR.
- **Accessibility auditing** — absent. By hand: axe-core + manual keyboard pass + `prefers-reduced-motion` and contrast checks (4.5:1 body, 3:1 large text).
- Note the asymmetry: motion and capture get categories, testing does not — the curator's craft is making things, and the discipline of verifying them is assumed to live in your pipeline, not your toolbox.

## When to use / When NOT to use

- Use this skill when a task names a *job verb* ("record", "optimize", "compress", "prototype motion", "pick easing") — route to the category, then the standout, then fall back to the by-hand mechanism.
- NOT for anything CSS/HTML already does natively: transitions, scroll-driven animations, `linear()`, `oklch()`, popover/dialog, scroll snap. Check the native feature first; the directory predates several of these landing.
- NOT to justify an install: a tool must save >150 lines, or add real editing leverage (timeline, node graph, keyframes), or batch work (minify, compress, regression-diff). One-off → by hand.
- Prefer the OSS twin by default: Excalidraw over paid whiteboards, OBS over recorders, Blender over DCCs, Penpot over Figma when OSS matters, LosslessCut/ShareX over paid cutters, svgo over SVGOMG in CI, gltfpack for mesh compression.

## How to apply (numbered checklist)

1. Name the job verb in the request; find its category in the 6-job map above.
2. Check the native route first (CSS/HTML/JS feature that needs zero deps).
3. If a tool is needed, pick the standout for that *specific* job (Mobbin ≠ Awwwards ≠ ShaderToy references), and prefer the OSS twin.
4. Weigh install cost: bundle KB, runtime deps, a11y cost, reduced-motion support, license (Theatre.js Apache-2.0, Excalidraw/tldraw/OBS/Blender/Penpot OSS).
5. One-off or <150 lines of mechanism → do it by hand with the snippets above.
6. For capture deliverables: record at 2× DPR, trim lossless, ≤60s, show the cursor.
7. For 3D assets: always pass through gltfpack (`-cc -tc`) before shipping; inspect in a glTF viewer.
8. Re-verify the directory before recommending a paid tool — it changes; the mechanism never does.

## AI-slop warning

- The directory puts AI Code at the center; the predictable failure is **generated UI with no system behind it** — default easings, no token layer, the v0-landing-page sameness. Agents amplify whatever constraints exist in the repo; put `tokens.css` and easing vars there before generating.
- Cliché poisoning contexts: pasted ShaderToy hero shaders rendering at uncapped fps (fans spin, low-end laptops die); Screen Studio-style zoom demos with no narrative arc (zoom only when the target actually matters); 300KB Lottie files doing a job a 200ms CSS transition does better; installing a component library for one effect.
- Worst agent behavior with this skill: recommending a paid tool when a native equivalent exists, or installing a dependency where 30 lines of CSS would do. The directory is a map, not a shopping list.

## Relations

- **easing** — the actual curves behind the Easing rows; exact cubic-bezier values and when each applies.
- **oklch** — the oklch.com row: perceptual color mechanics beyond picking.
- **code-source-of-truth** — the essay explaining why this directory has no handoff category: code is the artifact.
- **fancy-components** — the Fancy Components row: recreate the effects without the dependency.
- **design-spells** — the Design Spells row: the microinteractions the Inspiration category points at.
