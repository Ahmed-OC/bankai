---
name: desengs-rauno
description: Use when a UI or portfolio must feel crafted yet calm — monochrome restraint, spring motion, precise focus/copy states, and the discipline to cut anything that feels pompous.
source: https://rauno.me/; https://rauno.me/craft
category: portfolio
---

# Rauno Freiberg (desengs) — the craft portfolio as doctrine

Source: https://rauno.me/ — Rauno Freiberg, Estonian interaction designer working with Vercel and Devouring Details (author of interfaces.rauno.me, "Invisible Details of Interaction Design", cmdk, UI Playbook). Personal site doubling as a public working diary: `/craft` holds 70+ dated interaction studies (2021–2026), `/projects` a 9-item index, `/notes` field notes, plus frozen annual archives (2022.rauno.me, 2023.rauno.me). No open license; all techniques below were extracted from the site's shipped HTML/CSS/JS.

## What it is / Why it exists

- The site is the argument: instead of claiming craft, it demonstrates it in every default state.
- The hero is a seven-line manifesto, not a bio or a photo.
- The bio line ("is an Estonian interaction designer working with Vercel and Devouring Details") reveals itself line by line on load.
- Email copy is an animation with an accessible announcement; "Field Notes" is hand-drawn red SVG lettering; the footer is three links.
- Density is high (70+ dated entries, 10px metadata labels) but reads calm, because color, motion, and type are rationed.
- Treat this skill as the applied version of his own guidelines site (interfaces.rauno.me) — demonstrated by their author.

## The design signature (his exact system, from the shipped tokens)

- Monochrome-first: 12-step gray ramp plus alpha steps (`--gray1`…`--gray12`, `--grayA1`…`--grayA12`) in light and dark; **light is the default**.
- One accent per surface, never a palette — homepage frames each use exactly one of yellow / orange / red / blue.
- 8px spacing base: `--space-1:8px` through `--space-11:88px`, nothing between.
- Type ladder: 10/12/14/16/20/24/32/40/48px with matching px line-heights (12–56).
- Fonts: system sans body, JetBrains Mono mono, Georgia reserved for quote marks, custom `dd.woff2` preloaded.
- Radii: 4px, 8px, 16px, 9999px only.
- Shadows (low opacity, large blur): small `0 5px 10px rgba(0,0,0,0.12)`, medium `0 8px 30px rgba(0,0,0,0.12)`, large `0 30px 60px rgba(0,0,0,0.12)`, tooltip `0 4px 8px rgba(0,0,0,0.04), 0 1px 1px rgba(0,0,0,0.02)`.
- One named CSS curve: `--transitions-snappy: cubic-bezier(0.2, 0.8, 0.2, 1)`; springs everywhere else.
- Custom `::selection` (yellow background, black text) — never the browser default.
- Paper metaphor: surfaces carry a graph-paper texture via `--line-width:1px; --line-gap:9px; --line-color: var(--gray9)` on `data-sheet` containers.
- Hand-drawn red annotations (`#FF484C`, 7px round-cap SVG strokes) are the only decoration.
- Functional color chips when data requires them (essay step markers): blue `#369EFF`, orange `#FF9447`, green `#25D0AB`, red `#FF6369` — color as data, not decoration.

## Stated philosophy (his words, attributed)

- Homepage manifesto, verbatim: "Make it fast. Make it beautiful. Make it consistent. Make it carefully. Make it timeless. Make it soulful. Make it." Speed is line one; shipping is the last.
- 2023 archive tagline (self-summary): "Devouring details. Nourishing novelty. Deploying excellence."
- On novelty (craft essay, Feb 2026): "Novelty is the equivalent of an exclamation mark. Akin to seasoning, you don't want too much of it."
- His frequency–novelty hypothesis (same essay): the more commonly an action is performed, the less rewarding any novel visual or motion treatment of it becomes — semantic satiation applied to UI.
- Users "will definitely be feeling the answers" to novelty questions even when they never consciously ask them.
- On restraint (Vercel homepage essay, Dec 2023): goals were "performance, constraint in visual flair, and opportunity for bridging different pages aesthetically" — "an exercise in constraint and tranquil beauty."
- The kill rule (same essay): "if an animation or interaction didn't perform well, felt pompous, or out of rhythm relative to the page, we didn't build it."
- On invisible primitives: the universally experienced elements are "the page speed, legible typography, information honesty, layout stability and scannability, accessible focus states, auditory feedback, and sensible DOM ordering" — unglamorous because invisible, therefore traded away first.
- His self-check: "is having a slow website with immaculate attention to visual craft desirable?"
- On taste (Next.js essay, Apr 2023): the design had "no swanky mesh gradients, obnoxious artificial shines, or overuse of gimmicks. A pure masterclass in subtle craft where the intricate details almost fade into the background."
- On method (Invisible Details, Jul 2023): insight comes from "maniacally replaying hundreds of slow motion screen recordings", and from making something, then taking a "synthesising daydreaming walk".
- On authorship: essays end with "No artificial intelligence was used to generate content for this essay."
- Working in public: every experiment is dated and kept; nothing is deleted, just frozen per year (2022/2023 archives linked from the contact frame).

## Techniques worth stealing (mechanisms from the shipped code)

### 1. Staggered clip-reveal headline

- Each line sits in an `overflow:hidden` wrapper; the inner span starts at `translateY(100px)` and springs to 0 with `{stiffness:240, damping:32, mass:0.1}`.
- Delays start at 0.2s, +100ms per line; alternate lines get an indent variant — the reveal becomes rhythm.

```css
.line { display:block; overflow:hidden; }
.line > span { display:block; transform:translateY(100px);
  transition:transform .45s cubic-bezier(.2,.8,.2,1); }
.revealed .line > span { transform:translateY(0); }
.line:nth-child(2) > span { transition-delay:.30s; } /* +100ms per line */
```

### 2. Copy button with rolling label + live region

- Two labels ("Email" / "Copied") stacked, rolling vertically ±90px, spring `{stiffness:280, damping:32}`.
- State auto-resets after exactly 1000ms.
- A `role="region" aria-live="polite"` element announces "Copied email to clipboard".
- Steal the triple: animated confirmation + timed reset + programmatic announcement.

### 3. Dotted grid lines without `border: dotted` (technique he credits to Stripe)

- A tiled `linear-gradient` makes 5×1px dots; `mask-composite: exclude` fades the edges.
- Dot spacing, width, and fade are all controllable — `border: dotted` offers none of that.

```css
.gridLine { position:absolute; height:1px; left:50px; width:calc(100% - 100px);
  background:linear-gradient(to right, rgba(0,0,0,.5) 50%, transparent 0);
  background-size:5px 1px;
  -webkit-mask:linear-gradient(to left,#fff 90%,transparent),
    linear-gradient(to right,#fff 90%,transparent),linear-gradient(#000,#000);
  mask-composite:exclude; }
```

### 4. Glow without repaint (switchboard lights)

- Never animate `box-shadow` — it repaints every frame.
- Two pseudo-elements carry the shadows (medium: `#3291FF` at `0 0 2px 1px rgba(50,145,255,.25)`; high: white core plus blue halo) at `opacity:0`.
- Only `opacity` and `transform:scale(2)` transition, 250ms.
- State machine flips `data-state` among off/medium/high on a 1s interval; random 100–500ms pulse delays; pulses only escalate off→medium→high.
- Cherry-picked light indices spell "NEXT" on hover — ambient motion that carries a message.

### 5. Focus ring as double shadow (his rule, shipped on the Next.js site)

- `box-shadow: 0 0 0 2px var(--bg), 0 0 0 4px var(--focus)` — first ring creates padding, second draws the outline; follows `border-radius` in old Safari where `outline` didn't.
- Bare text links: `border-radius:2px; padding-left:2px; margin-left:-2px` — breathing room with zero layout shift.
- He cites Discord's web app as the reference for page-wide focus consistency.

### 6. Serif quote marks

- Render quotation marks in Georgia while body stays sans — "that little bit of finesse" (borrowed from Radix's site). One declaration, perceptible warmth.

### 7. Hover previews via video media fragments

- Link previews load muted mp4s as `video.mp4#t=0.01` — the fragment renders the first frame instantly as a poster; the same asset plays on hover. No image/video duplication.

### 8. Infinite-canvas homepage — structural signature; study it, deploy rarely

- Fixed 1200×720px frames laid out horizontally at `left: 1240*n` (40px gutters): manifesto, Devouring Details, Craft, History of Software Design, Projects, Field Notes, contact, closing frame.
- First scroll event locks the perpendicular axis (`body { overflow-x: hidden }` or y) — one gesture, one axis, ever.
- All scrolling feeds one virtual position driving pan *and* zoom; scale clamped `[0.6, fit]`, `fit = min(vw/1300, vh/1020)`.
- Frame contents slide with parallax springs `{stiffness:500, damping:40}`.
- Frame labels counter-scale (`scale: 1/scale`) so they stay legible at any zoom level.
- Keyboard focus on a frame springs the canvas to it (`{stiffness:600, damping:80}`) — that focus path is what keeps the canvas keyboard-accessible.
- Entry: frame scale-in `{stiffness:320, damping:60, mass:0.2}`; yellow circle `{stiffness:600, damping:80, delay:0.4}`; then the clip-reveal headline.
- `history.scrollRestoration = "manual"`; frames call `preventDefault()` on mousedown to kill text selection and drag.

### 9. Craft demo page mechanics

- Every `/craft/[id]` entry ships: title, month-year, a live component or a video, a per-entry theme (light or dark), collaborator credits, sequential next-entry navigation.
- Optional "Toggle Slow Motion" on demo videos — motion is meant to be studied frame by frame.
- Essays are entries too (`writing: true`): demos and prose live in one chronological stream, not separate "blog" and "work" silos.
- Entry taxonomy worth copying: live productions / interactive prototypes / essays / motion studies / SwiftUI re-implementations of native UI (Dock, radial menu, screenshot capture, video scrubber).

### 10. Ambient motion on a 2s cadence

- Logo carousel: first advance after 500ms, then every 2000ms; two layers stacked `grid-area:1/1` crossfade; dark mode is one `filter:invert(1)` on the container — a whole theme adaptation in one property.

### 11. Disambiguation by blur, separation by two springs

- Inline-definition toggles animate `filter:blur(4px)` + `opacity:0.3` over `0.35s easeInOut`, delay on exit only — surrounding content defocuses while you read, then refocuses.
- Minimap/waveform demo: cursor spring `{stiffness:100, damping:20}` (slow, trailing) against tick spring `{stiffness:500, damping:40}` (snappy) — two presets in one component to separate "pointer" from "content".

## Workflow and tooling signals

- Ship the static version first: "instead of dragging an already massive pull request out, we shipped the static version as soon as it was an improvement over what was already in production" — motion arrives as follow-up PRs.
- Study loop: record real UI, replay in slow motion, extract the mechanism, rebuild as a dated demo, write the essay when observations accumulate. Copy the loop, not the demos.
- Stack visible in output: React with spring animation, CSS custom properties as tokens, CSS-in-JS, Next.js, SwiftUI for native re-explorations — the platform is interchangeable; the motion values are the signature.
- Every idea gets a durable URL and stays alive: guidelines repo (interfaces.rauno.me, 2023), command-menu library (cmdk, 2022), pattern reference (UI Playbook, 2020), critique feed (uiwtf, 2021), utilities (bmrks, flow.rest, Vesper), book (Devouring Details, 2025), history archive (historyofsoftware.org, 2026).
- The projects page is nine links and years, zero prose — the work indexes itself.
- PWA polish: `mobile-web-app-capable`, apple-touch-icon, `black-translucent` status bar, manifest — the portfolio installs like an app.

## When to use / When NOT to use

Use when:
- Building a portfolio, product site, or marketing page where trust comes from demonstrated craft.
- You want a monochrome token system with disciplined accents.
- You need known-good spring presets, focus-ring and copy-state patterns.
- You are designing a showcase for interaction studies.

Do NOT use when:
- The product needs color to inform (data visualization, status-heavy operations, brand-driven commerce) — his monochrome stance is a personal aesthetic, not a universal rule.
- Users are task-repeaters on mid-range devices — scroll-hijacked canvases and continuous springs cost them.
- An app shell is required — the frames canvas is a portfolio statement, not an application layout.
- SEO/content marketing matters — absolutely-positioned frames and 10px labels are hostile to it.
- Do not inherit his one accessibility tradeoff: the homepage ships `maximum-scale=1, user-scalable=no` (blocks pinch-zoom). Keep zoom enabled.

## How to apply

1. Define a 12-step gray ramp (solid + alpha) before choosing any accent; allow exactly one accent per surface.
2. Lock spacing to the 8px scale; type to the 10–48px ladder; radii to 4/8/16/9999px.
3. Standardize one CSS curve — `cubic-bezier(.2,.8,.2,1)` — and 3 spring presets: enter `240/32`, feedback `500/40`, large surface `320/60`, mass 0.1–0.2.
4. Audit focus states page-wide: one double-box-shadow ring everywhere, the link padding/negative-margin trick for bare links, never the native default, never clipped by overflow.
5. Animate only `opacity` and `transform`; glow and shadow changes live on pseudo-element opacity.
6. Give every copy/async action an animated state change, an `aria-live` announcement, and a ~1s auto-reset.
7. Sequence text reveals in 100ms staggers inside `overflow:hidden` masks — never opacity fades.
8. Run the frequency test before any flourish: the more frequent the action, the more conservative its motion.
9. Kill anything that performs poorly, "feels pompous, or out of rhythm" with the page — his exact cut list.
10. Budget one ambient loop per page at ~2s; everything else reacts only to input.
11. Ship static first; treat motion as incremental follow-up PRs, never a blocker.
12. Date and keep every experiment in public — an archive is a credential.

## AI-slop warning

- The cliché "Rauno style": black/white plus one neon accent, springs on everything, staggered mask reveals on every heading, a ⌘K menu, a horizontal-scroll hijack. That combo is now the default craft-portfolio template and reads as slop because the motion carries no information.
- His actual differentiator is subtraction and correctness — performance budgets, consistent focus states, sensible DOM order, honest metadata. AI imitations copy the surface (springs, monochrome) and skip the primitives.
- Do not mistake his one-off demo interactions (wheel input, radial menus, gooey tooltips) for production patterns — they are published studies of native platforms.
- If everything on the page animates, the doctrine is inverted: "novelty is seasoning", and the seasoning has become the meal.

## Relations

- **desengs-web-interface-guidelines** — his own written standards (interfaces.rauno.me); this skill is those rules demonstrated. Where they conflict, follow the guidelines.
- **desengs-invisible-details** — his 2023 essay in full; source of the slow-motion study method and the deeper deconstruction behind the frequency–novelty hypothesis summarized here.
- **desengs-devouring-details** — his book/reference; the canonized, componentized continuation of these craft experiments.
- **desengs-interface-craft** — sibling craft-methodology skill; append his frequency–novelty question ("how often is this action performed?") as a gate before applying any of its effects.
- **desengs-easing** — the math behind the `240/32`, `500/40`, `320/60` spring families and the `(0.2, 0.8, 0.2, 1)` curve prescribed above.
