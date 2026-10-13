---
name: ui-camera
description: Use when a screenshot or screen recording must become a marketing asset — staged 3D product photography of UI with exact tilt presets, depth of field, and camera-style capture controls.
source: https://ui.camera; https://ui.camera/showcase
category: reference
---

# UI Camera — product photography for software: stage screenshots and recordings like physical products

Source: https://ui.camera (the site IS the tool; Next.js app-shell, no docs). Maker: Alex Akten (HN `alexakten`, X showcase credit `@uidotcamera`), operated by Autogram AB, Sweden; launched Aug 10 2026 (Show HN 49242584). Commercial SaaS — free tier renders locally in-browser, paid tier adds cloud camera roll. UI typeface: OpenRunde. Theme `#000000`.

## What it is / Why it exists

A browser studio that treats software the way a photo studio treats a physical product: you bring a screenshot or screen recording, the tool stages it on a black set, tilts it in 3D, racks focus across it, and captures a PNG (PHOTO mode) or a keyframed move (VIDEO mode). Tagline: "Product photography for software." Value proposition: "Studio-quality photos and videos of software, right in the browser."

The gap it fills: marketing needed one of (a) flat, dead screenshots, (b) Figma/Photoshop mockup drudgery, or (c) 3D-suite work for a hero image. ui.camera collapses that to: upload → dial in angles → capture. On HN the maker framed the ambition explicitly: "I love what Paper are doing for design, this could do something similar for product photos & videos."

The pitch extends to motion: "Add a couple screens from your website/app, and get back a smooth product showcase animation" — multi-screen showcase videos generated from stills.

Three verified facts should calibrate how you judge the output:
- The demo project mixes media types in one composition — a Linear screenshot (5760×3600 AVIF) beside an ElevenLabs screen recording (3024×1890 MP4). Composites of still + video are a first-class use, not an edge case.
- Source resolutions are ~3–5.7K. The pipeline assumes print-grade inputs; a 1280×720 grab will fall apart under tilt + zoom + blur.
- The site's own chrome is a specimen of its aesthetic: `#000` stage, OpenRunde (Regular→Bold), thin white hairline borders, subdued grays, zero illustration. If you must build a capture/preview UI in this style, that is the palette.

## The core ideas

### 1. The camera metaphor is the entire interface
Every control borrows camera-body grammar, not design-tool grammar:
- `X` / `Y` / `Z` — three rotation dials (a gimbal), scrubbed vertically, with stepper arrows. Demo composition ships at X 35°, Y 30°, Z −15°.
- Rotation presets, shown as exact triples `X / Y / Z`: `+15 / −45 / 0`, `+30 / +45 / 0`, `+65 / 0 / −45`, `−20 / +45 / 0`. These are the tool's blessed looks — moderate yaw (±45), small roll or none, pitch varying. Note the constraint: |Z| is 0 or 45 in presets; roll is used sparingly.
- `AF` (autofocus — picks the focal point), `ƒ` (aperture — strength of depth-of-field blur), `1×` (zoom, steps like `1×` / `1.2×`), `16:9` (aspect ratio of the captured frame), plus `L` (frame size).
- Bottom bar reads like a viewfinder HUD; capture is a single yellow `Capture PNG` button. One `Reset`.

Design lesson to steal: wrap complex transforms (3D matrices, blur passes) in physical-camera vocabulary (`ƒ`, AF, zoom, aspect) and users guess every control without a manual.

### 2. Depth of field is the signature, not the tilt
The OG image confirms the house look: dark `#000` stage, screenshot floating tilted (~10° pitch, ~45° yaw), progressive blur increasing away from the focal region — shallow-focus bokeh, not uniform sharpness. The tilt says "object"; the DOF says "photographed with a real lens." Cheap clones do tilt only and read flat. If you reproduce one thing, reproduce the focus falloff.

Web mechanism (the screenshot is one flat plane, so DOF = distance-from-focal-point blur). Two-layer masked-blur version, copy-pasteable:

```css
.dof-stack { position: relative; }
.dof-stack .blurred {
  position: absolute; inset: 0;
  filter: blur(6px);              /* stands in for ƒ — 4–10px reads "portrait lens" */
  -webkit-mask-image: radial-gradient(ellipse 42% 36% at var(--fx,32%) var(--fy,40%),
                                     transparent 38%, #000 78%);
          mask-image: radial-gradient(ellipse 42% 36% at var(--fx,32%) var(--fy,40%),
                                     transparent 38%, #000 78%);
}
```
Sharper honesty check: real tilt-shift blurs in a plane, not a circle. For the plane look, replace the radial mask with `linear-gradient` bands perpendicular to the tilt axis (`to top right` for a Y-rotated shot), or slice the image into 6–8 `clip-path` bands with `blur(0 → 8px)` stepping away from the focus band. Keep text regions inside the transparent 38% zone or the UI becomes unreadable.

Band variant (closest to the tool's look — blur follows the tilted plane):
```css
.bands { display: grid; grid-template-rows: repeat(7, 1fr); }
.bands > img {
  grid-area: 1 / 1;                 /* all slices stacked in the same cell */
  width: 100%;
}
.bands > img:nth-child(1) { clip-path: inset(0 0 85.7% 0); filter: blur(8px); }
.bands > img:nth-child(2) { clip-path: inset(14.3% 0 71.4% 0); filter: blur(5px); }
.bands > img:nth-child(3) { clip-path: inset(28.6% 0 57.1% 0); filter: blur(2px); }
.bands > img:nth-child(4) { clip-path: inset(42.9% 0 42.9% 0); filter: none; } /* focus band */
.bands > img:nth-child(5) { clip-path: inset(57.1% 0 28.6% 0); filter: blur(3px); }
.bands > img:nth-child(6) { clip-path: inset(71.4% 0 14.3% 0); filter: blur(6px); }
.bands > img:nth-child(7) { clip-path: inset(85.7% 0 0 0);     filter: blur(9px); }
```
Move the `filter: none` band to wherever `AF` should sit; blur ramps asymmetrically around it (foreground falls off faster than background).

### 3. The staging mechanics, in plain CSS
```css
.stage {
  background: #000;                 /* ui.camera shoots on black, always */
  aspect-ratio: 16 / 9;             /* the capture frame; pick one ratio per asset set */
  perspective: 1600px;              /* lower = wider lens = more dramatic skew */
  display: grid; place-items: center;
}
.shot {
  transform: rotate3d(1, 0, 0, calc(var(--rx) * 1deg))
             rotate3d(0, 1, 0, calc(var(--ry) * 1deg))
             rotate3d(0, 0, 1, calc(var(--rz) * 1deg));
  transform-style: preserve-3d;
  /* start from a preset: --rx: 15; --ry: -45; --rz: 0  */
  box-shadow: 0 40px 80px rgba(0,0,0,.55);  /* float, not sit */
}
```
Floor reflection (the "studio" cue — optional, use on hero shots only):
```css
.reflection {
  transform: scaleY(-1) translateY(-2px);
  filter: blur(2px);
  -webkit-mask-image: linear-gradient(to top, transparent 58%, rgba(0,0,0,.3) 100%);
          mask-image: linear-gradient(to top, transparent 58%, rgba(0,0,0,.3) 100%);
}
```
Zoom = `scale()` on the shot (tool steps ~1.2×); exposure = `filter: brightness(1.05)`.

### 4. VIDEO mode = the same dials on a timeline
Privacy policy persists "timeline data" with projects; VIDEO mode keyframes the X/Y/Z (and presumably ƒ/zoom) values. The interesting artifacts are multi-screen: several screenshots composed into one animated showcase. Mechanism, plain CSS:

```css
@property --ry { syntax: '<number>'; inherits: false; initial-value: -45; }
.shot { animation: rack 2400ms cubic-bezier(0.22, 1, 0.36, 1) both; }
@keyframes rack { from { --ry: -45 } 60% { --ry: 10 } to { --ry: 15 } }
```
Rack one axis at a time; simultaneous XYZ + zoom + ƒ changes read as turbulence. One preset-to-preset move per 2–3s clip (showcase previews are short loops). The maker admitted the hard part is playback: "Trying to learn how to render smooth playbacks with animations was tricky!" — expect to render, not livestream, final captures.

Hand-rolled capture path when no tool is allowed: compose the stage in CSS, then record the element — `element.getAnimations()` + canvas rasterization for a frame-perfect PNG, or `MediaRecorder` on a `captureStream()` of that canvas for VIDEO mode output. Rule: capture at 2× the destination size (the tool's own outputs are 2400×1260 for its OG image). Loop discipline: first and last keyframe share angles and ƒ, so the loop seam is invisible.

### 4b. Mixed-media composites (from the demo project)
A screenshot and a playing recording can occupy one stage: the recording is the same `<video>` element in place of the `<img>`, tilted identically, blurred identically. Two staging patterns worth copying:
- **Stack**: recording in front (larger, sharper, focal point on it), screenshot behind at ~0.85 scale, pushed 40–80px deeper on Z (`translateZ(-80px)`), picking up +2px extra blur. Reads as "product family."
- **Sequence** (VIDEO mode): screens swap via opacity crossfade (~200ms) while the camera rack runs; never cut — the camera continuity is what makes stills feel filmed.

### 5. Capture pipeline: extension → stage → camera roll
- Chrome extension: captures/records the visible page only after an explicit click; framing processed locally; output goes to the Downloads folder, never uploaded. Optional macOS app receives recording commands and screen coordinates locally — no external server.
- Editor accepts PNG, JPG, WEBP, AVIF, GIF (images) and MP4, MOV, WEBM (video). Demo project proves both paths: an ElevenLabs screen recording (3024×1890 MP4) and a Linear screenshot (5760×3600 AVIF) sit in the same asset tray (multi-select via ⌘/Shift-click).
- Free tier: finished captures never leave the browser. Paid tier: camera roll stored per-project, syncs across devices. Auth: Supabase one-time email links or Google.
Operational lesson: keep capture local and permissioned; only the finished render goes anywhere.

### 6. The showcase defines what deserves a photo shoot
All entries credited "by @uidotcamera", each with a short looping preview MP4: loading.dev (loading states), Klar / klarlabs.ai, Phosphor Icons, GPS-01 (dmytro.fyi), Pop Site, Departure Mono (typeface), highlighte.rs, Best Free Fonts, Emil Kowalski (an X clip), ElevenLabs. Pattern: subjects are compact design objects — a loader, an icon set, a typeface specimen, one product surface — not sprawling dashboards. The medium is built for social loops and hero sections. If your subject can't survive being described in five words, a staged shot won't save it.

## When to use / When NOT to use

Use when: landing-page heroes, launch tweets/X clips, changelog and Product-Hunt gallery images, portfolio pieces, docs covers — anywhere a flat screenshot undersells the work.
Use the tool (not hand-rolled CSS) when: the source is a live page (the extension captures the visible page with one click, locally); the asset is a video that must play inside the tilted plane; you need real optical-style DOF rendering, a keyframe timeline UI, or batch output at consistent framing; or captures must sync across devices (paid camera roll). Manual CSS wins when: the shot ships inside the product itself (zero runtime dependency, degrade gracefully), the staging must respond to interaction (hover parallax on the hero), or you need pixel-control the tool's presets don't allow.
Do NOT use when: the screenshot must stay legible (tilt + blur destroys small text); the context is documentation, accessibility-sensitive, or enterprise-serious; the UI is dense and wide (yaw > 45° hides most of it); or the goal is honest UI review — staging flatters, it doesn't inform. One staged hero per page; a grid of tilted cards is a template, not a composition.

## How to apply (numbered checklist)

1. Capture at 2× resolution minimum (tool demos ship 2974×1842 to 5760×3600); downscale in the stage, never upscale.
2. Pick the capture frame first: 16:9 default; use the tool's ratio selector for the destination (social clip ≠ site hero). Match destination ratio before staging, not after.
3. Start from a blessed preset — `+15 / −45 / 0` or `+30 / +45 / 0` — then nudge at most ±10°. Never hand-roll angles from zero.
4. Set the focal point (`AF`) on the one region that must stay sharp; set ƒ so blur reaches 4–8px at the far edge. Check: smallest text in the sharp zone still legible at final size.
5. Zoom to crop dead margins (1× → 1.2× steps), not to enlarge detail.
6. PHOTO mode: `Capture PNG` equivalent — render at devicePixelRatio 2 on a `#000` stage. VIDEO mode: one axis rack, 2–3s, ease `cubic-bezier(0.22,1,0.36,1)`, loop-clean start/end angles.
7. Multi-screen showcase: stack the screens (pattern above), crossfade 200ms between them mid-rack; total 4–8s; end angles = start angles.
8. Export, then verify at destination size — tilt that looked elegant at 1400px is often illegible at 480px. Check the X-clip crop too (edge pixels bleed under tilt).
9. Ship one staged asset per context; pair it with flat screenshots elsewhere.
10. Provenance: stage real product pixels only. A mockup or AI-rendered screenshot under studio lighting reads as fraud the moment anyone looks twice.

## AI-slop warning

Tilted-screenshot-with-bokeh-on-black is rapidly becoming the default AI landing-page hero — every clone of this tool emits the same 45° yaw + blur + black stage. It already poisons: dev-tool sites (interchangeable), anything needing trust (banking, medical, gov), and galleries where every card is staged identically (composition dies). Typical AI failure modes: roll added because it "looks dynamic" (presets keep Z at 0 for a reason); blur applied uniformly instead of as focus falloff; over-rotation past ~40° yaw; staging used to disguise an unfinished UI; text left inside the blur zone. If the shot could be described as "screenshot, tilted, blurred" and nothing else, it carries no information — reshoot or go flat.

## Relations

- **easing** — supplies the exact interpolation curves for preset-to-preset racks in VIDEO mode; this skill fixes the endpoints, that one fixes the motion between them.
- **images-in-motion** — motion of imagery *inside* a UI; UI Camera is the inverse concern (camera moves around the UI). Use both when a showcase video needs inner and outer motion.
- **emil-skills** — Emil Kowalski's clip appears in the showcase; his pause/scrub annotation taste defines what a "recordable" interaction looks like before you stage it.
- **loading-dev** — loading.dev is showcase entry #1: loading states are the most photogenic micro-moment; shoot those first.
- **devouring-details** — the why behind macro shots: a staged close-up is how a 4px detail gets an audience; contradicts this skill's restraint rule only in degree.
