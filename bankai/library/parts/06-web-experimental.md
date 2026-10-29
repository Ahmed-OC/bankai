# Web experimental & immersive — the frontier

The zone where the browser stops being a document viewer and becomes a real-time medium: WebGL/WebGPU scenes, scroll-driven cameras, simulations, and playable brand worlds. This is where mechanisms are invented first and trickle down to product sites years later. Every entry names the specific stealable mechanism — and the performance/graceful-degradation tricks are flagged explicitly, because that's what makes frontier work shippable in real products.

---

## Studios

### Active Theory — https://activetheory.net
Platform: Web · Type: studio
- **Mechanism**: In-house WebGL framework powering one experience codebase across iOS, Android, desktop, and VR; Dreamwave platform runs multiplayer virtual worlds at thousands of concurrent users. Latest portfolio is a WebGPU showcase — real-time particles, AI-driven navigation through 3D environments (Venice Beach-inspired), case studies as explorable spaces.
- **Steal for**: device-tiered rendering budgets and "one scene graph, many surfaces" architecture for immersive campaigns.

### Lusion — https://lusion.co
Platform: Web · Type: studio
- **Mechanism**: Portfolio as a "digital sculpture gallery" — full-screen 3D figures, scroll-synced WebGL with true native DOM scrolling (they open-sourced their WebGL+DOM synchronization solution), and famously disciplined frame-budget management that devs have reverse-engineered to study. Swept Awwwards Site of the Year, Dev Site of the Year, FWA Site of the Year, and a Cannes Silver Lion.
- **Steal for**: syncing WebGL to native scroll without hijacking or jank — the single most requested "how did they do that" technique.

### Resn — https://resn.co.nz
Platform: Web · Type: studio
- **Mechanism**: UI-as-toy doctrine: every project hides interactions (try resizing the browser on their portfolio), cursor-reactive WebGL scenes, and playful easter eggs as a core deliverable, not garnish. Cannes Lions, Webbys, One Show hardware across two decades.
- **Steal for**: treating hover/resize/pointer states as reward loops that make an experience feel alive.

### Hello Monday/DEPT — https://www.hellomonday.com
Platform: Web · Type: studio
- **Mechanism**: Brand-world construction with progressive enhancement — semantic HTML base with a 3D layer on top (Star Atlas won Awwwards Site of the Year 2021 Users' Choice; earlier SOTY for Greenpeace 2014 and multi-award Departures). Cinematic reveals built from game-grade assets re-lit for web.
- **Steal for**: shipping ambitious 3D brand sites that still work when WebGL doesn't.

### 14islands — https://www.14islands.com
Platform: Web · Type: studio
- **Mechanism**: "Progressive enhancement with WebGL and React" (their own journal article is the reference): WebGL canvas as an enhancement layer over normal HTML/CSS content, custom cubic-bezier easing systems, and shareable WebGL toys (Blobmixer). Stockholm/Reykjavík studio, repeated Awwwards SOTD.
- **Steal for**: the enhancement-layer architecture — content stays indexable/clickable while the canvas paints on top.

### Immersive Garden — https://immersive-g.com
Platform: Web · Type: studio
- **Mechanism**: Awwwards Studio of the Year 2024 and Agency of the Year 2025; luxury-grade cinematic scroll choreography (Cartier Watches & Wonders journeys) — product macro shots with shader materials, art-directed camera moves locked to scroll, typography that behaves like set design.
- **Steal for**: making product/luxury sites feel like film without video files.

### Abeto — https://abeto.co
Platform: Web · Type: studio
- **Mechanism**: Simulation-first creative development: Igloo Inc (Awwwards Site of the Year 2024) is built entirely in WebGL — procedurally grown ice crystals, shader-rendered UI text, interactive particle systems; also builds playable WebGL worlds like Messenger (cel-shaded miniature-planet courier game).
- **Steal for**: rendering UI itself in shaders when DOM overlay would break the illusion.

### Unseen Studio — https://unseen.co
Platform: Web · Type: studio
- **Mechanism**: Radical-restraint "anti-portfolio": near-black minimal pages carrying one strong interaction each — scroll-driven 3D type, fog, and light. Proves frontier craft can load fast instead of fighting the frame budget.
- **Steal for**: one memorable interaction per screen beats ten mediocre ones — and loads faster.

### Obys Agency — https://obys.agency
Platform: Web · Type: studio
- **Mechanism**: Experimental typography married to WebGL distortion — hover-triggered displacement on image planes, kinetic type as the primary visual, generative details around editorial layouts.
- **Steal for**: making type itself the hero of an experimental site.

### Bruno Simon — https://bruno-simon.com
Platform: Web · Type: studio
- **Mechanism**: The drivable-car portfolio: physics playground (ramps, bowling pins, respawns) exploring projects; keyboard + on-screen touch controls; progress-based "unlock" secrets and an easter-egg button. 2019 version used cheap matcap materials + low-poly world for stable 60fps; 2025 rebuild (open source at github.com/brunosimon/folio-2025) targets WebGPU with a WebGL fallback. Awwwards Site of the Month Nov 2019; Webby Technical Achievement 2026.
- **Steal for**: open-source reference implementation of a playful, performant, mobile-tolerant 3D portfolio.

---

## Campaigns & experiences

### Persepolis Reimagined (Getty Villa × Media.Monks) — https://persepolis.getty.edu
Platform: Web · Type: campaign
- **Mechanism**: Museum-grade real-time 3D reconstruction of ancient Persepolis — free-roam and guided path navigation through the citadel with art-directed lighting and chapter-based wayfinding. Awwwards Site of the Year 2022, FWA Site of the Year, dual Webby winner.
- **Steal for**: guided-vs-free camera duality — always give users both a curated path and wander mode.

### Igloo Inc — https://www.igloo.inc
Platform: Web · Type: campaign
- **Mechanism**: Scroll-linked camera descending through an ice world; procedurally grown crystals (crystal-growth algorithms, not modeled geometry), "re-freezing" scene transitions, shader-rendered text and particles. Awwwards Site of the Year + Developer Site of the Year 2024.
- **Steal for**: generative geometry instead of heavy assets — simulation replaces downloads.

### The GitHub Globe — https://github.blog/2022-09-22-how-we-built-the-github-globe/
Platform: Web · Type: campaign
- **Mechanism**: The best-documented perf case study in the field: Earth built from ~12,000 instanced circles (no textures, four lights), PR arcs as CubicBezierCurve3 tubes animated via setDrawRange(), timezone-based initial rotation, instant SVG placeholder crossfaded to canvas via Web Animations API. Graceful degradation: 4 quality tiers — FPS monitored continuously, and if it drops below 55.5fps over 50 frames the scene self-downgrades (pixel ratio, raycast frequency, PR count, circle density 12k→8k). Antialiasing disabled; a tilted halo shader hides the pixel edges.
- **Steal for**: the auto-degrading quality-tier system — copy it into any real-time hero.

### The Boat (SBS) — https://www.sbs.com.au/theboat/
Platform: Web · Type: campaign
- **Mechanism**: Scroll-driven interactive graphic novel (Matt Huynh's ink illustrations): parallax layering, panel transitions, and sound design all synced to scroll position, so pacing is authored but the reader holds the throttle. Awwwards SOTD; curriculum-adopted.
- **Steal for**: scroll as a narrative pacing device with audio reacting to position.

### Bear 71 (NFB) — https://bear71.nfb.ca
Platform: Web · Type: campaign
- **Mechanism**: Interactive documentary: a linear 20-minute film (text, video, maps) plus an explorable multi-user map where every other visitor appears as a moving cursor — you share the surveillance-grid world with live strangers. FWA Site of the Year 2012, Cannes Cyber Lion.
- **Steal for**: showing other users' cursors/avatars to make a solo browse feel inhabited.

### Species in Pieces — http://species-in-pieces.com
Platform: Web · Type: campaign
- **Mechanism**: 30 endangered species, each built from exactly 30 CSS `clip-path` triangles that morph between animals with pure CSS transitions — zero images, zero canvas. Still cited by Smashing Magazine as the clip-path benchmark.
- **Steal for**: clip-path polygon morphing as both art direction and a performance cheat (compositor-only animation).

### The Fallen of World War II — https://www.fallen.io/ww2/
Platform: Web · Type: campaign
- **Mechanism**: 15-minute animated data documentary: play/scrub controls over narration-synced animated charts; casualty figures visualized as growing blocks that reframe scale at each act break. The reference for "video that is actually data".
- **Steal for**: scrub-able timeline over data-driven animation — let users control a linear film.

### Star Atlas — https://staratlas.com
Platform: Web · Type: campaign
- **Mechanism**: Game-universe brand site by Hello Monday: cinematic WebGL space scenes built from actual game assets, atmospheric shaders and slow parallax drifty camera; Awwwards Site of the Year 2021 (Users' Choice).
- **Steal for**: reusing production game assets on the marketing site for a single continuous brand image.

### Chrome Music Lab — https://musiclab.chromeexperiments.com
Platform: Web · Type: campaign
- **Mechanism**: Instant-load micro-experiments (Song Maker, Kandinsky, Spectrogram) built on Web Audio + Tone.js; every creation is shareable as a URL; the whole codebase is open source. Song Maker took a Cannes Bronze Lion and a Webby.
- **Steal for**: URL-as-artifact sharing — user creations spread the campaign for you.

### 100,000 Stars — https://stars.chromeexperiments.com
Platform: Web · Type: campaign
- **Mechanism**: Google Data Arts Team's classic WebGL "powers of ten": a single camera-path zoom-out from the Sun through the stellar neighborhood to the Milky Way's arms, using real star-position data, CSS3D labels, and ambient Web Audio.
- **Steal for**: one continuous zoom-out camera as the entire site structure.

### The Wilderness Downtown — https://www.thewildernessdowntown.com
Platform: Web · Type: campaign
- **Mechanism**: Arcade Fire × Chris Milk's HTML5 landmark: multiple choreographed browser windows dancing in sync, Google Street View of the visitor's own childhood address composited behind HTML5 video. The archetype of personal data as emotional payload.
- **Steal for**: multi-window choreography and "the site already knows a place you love" personalization.

---

## Technique-reference demos & collections

### Codrops — https://tympanus.net/codrops/
Platform: Web · Type: technique-reference
- **Mechanism**: The field's pattern library: 500+ archived demos, each with a write-up and source — hover-distortion galleries, scroll-3D scenes, page transitions, text effects. When a Codrops demo ships, it becomes the default reference implementation for that pattern.
- **Steal for**: the archive is a ready-made catalog of frontier mechanisms with code attached.

### Codrops: Interactive Particles with Three.js — https://tympanus.net/codrops/2019/01/17/interactive-particles-with-three-js/
Platform: Web · Type: technique-reference
- **Mechanism**: The canonical "particles form a portrait" demo: GPGPU particles sampled from image pixels; the pointer pushes them away and they spring back via velocity damping. Mouse-reactive particle systems across the web descend from this article.
- **Steal for**: image → particle sampling with pointer repulsion and return-force.

### Codrops: 3D Particle Explorations — https://tympanus.net/Development/3d-particle-explorations/
Platform: Web · Type: technique-reference
- **Mechanism**: Studies in particle motion aesthetics: the same point cloud re-choreographed with different three.js + GSAP easings, timings, and groupings — proof that motion curves, not geometry, define the feel.
- **Steal for**: an easing/timing vocabulary for particle transitions.

### WebGL-Fluid-Simulation (PavelDoGreat) — https://paveldogreat.github.io/WebGL-Fluid-Simulation/
Platform: Web · Type: technique-reference
- **Mechanism**: Real-time Navier-Stokes fluid in raw WebGL: pointer velocity injects dye + velocity, splats bloom and dissipate; works with mouse and touch; MIT-licensed single-file drop-in. The base layer of countless hero backgrounds and Framer components.
- **Steal for**: a free, touch-ready fluid hero you can ship this afternoon.

### Three.js official examples — https://threejs.org/examples/
Platform: Web · Type: technique-reference
- **Mechanism**: The canonical library of working code: GPGPU flocking birds, ocean shader, instancing, skinning, CSS3D periodic table — each example with live demo and editable source inline. New renderer capabilities land here first.
- **Steal for**: verify any three.js technique against its reference implementation before building.

### The Book of Shaders — https://thebookofshaders.com
Platform: Web · Type: technique-reference
- **Mechanism**: Fragment-shader literacy course: every chapter is a live, editable shader (noise, fbm, fractals, shaping functions) with inline editing and a shared gallery.
- **Steal for**: the fastest path from "shader tourist" to writing your own hero effects.

### Shadertoy — https://www.shadertoy.com
Platform: Web · Type: technique-reference
- **Mechanism**: Community shader lab: hundreds of thousands of live-editable GLSL pieces — raymarching, SDFs, lighting, fluid — all remixable in the browser. Note: most are desktop-GPU showpieces; treat as reference math, not production code.
- **Steal for**: technique mining (SDFs, volumetrics) to port into performant web contexts.

### Awwwards WebGL collection — https://www.awwwards.com/websites/webgl/
Platform: Web · Type: technique-reference
- **Mechanism**: Continuously filtered gallery of awarded WebGL sites, plus per-technique inspiration tags (3D scroll, particle, distortion) — the scan list for what the frontier looks like this quarter.
- **Steal for**: monthly pattern-spotting without visiting thirty sites.

### Lenis — https://lenis.dev
Platform: Web · Type: technique-reference
- **Mechanism**: The smooth-scroll substrate under most award sites: lerp-eased scrolling that virtualizes wheel input while preserving native scrollbar, keyboard, and accessibility behavior (unlike hard scroll-hijacking); tiny, framework-agnostic, pairs with ScrollTrigger.
- **Steal for**: smooth scroll without the accessibility tax of scroll hijacking.

### Blobmixer — https://blobmixer.com
Platform: Web · Type: technique-reference
- **Mechanism**: 14islands' parametric 3D toy: sliders drive live vertex-shader deformation, material and lighting of a blob; every creation is encoded entirely in the URL for sharing. UGC configurator logic reduced to its purest form.
- **Steal for**: URL-encoded generative artifacts — the cheapest viral loop in WebGL.

### Three.js Journey — https://threejsjourney.com
Platform: Web · Type: technique-reference
- **Mechanism**: Bruno Simon's course is the training ground behind a visible share of the current Awwwards generation: shaders, physics, scroll-synced scenes, and an optimization module (draw calls, texture budgets, quality tiers) aimed at production, not demos.
- **Steal for**: a structured path from "can render a cube" to "can ship Igloo-class work".

---

## Study these first

1. **The GitHub Globe case study** — the only frontier build with its full performance/quality-tier playbook published; read it before writing any real-time hero.
2. **Igloo Inc** — the current bar (Awwwards SOTY 2024) for all-shader UI and procedural geometry.
3. **Bruno Simon's portfolio** — open-source, fully documented playful 3D with mobile tolerance and graceful fallbacks.
4. **Codrops demos archive** — the pattern library; find the mechanism you need with source code attached.
5. **Persepolis Reimagined** — immersive narrative at museum scale, with guided/free navigation done right.
