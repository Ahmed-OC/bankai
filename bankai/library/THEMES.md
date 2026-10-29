# bankai theme index — pick a direction

A taxonomy of 33 themes distilled from the 256-entry inspiration library (`parts/01`–`07`). A theme is a coherent identity a whole product can wear — aesthetic + interaction direction in one move. Modes use the canon's vocabulary: Operate / Consume / Entice / Play. Surface flags: **web-only**, **mobile-first** (the library's priority zone), or both.

## How to use

1. Match the brief against each theme's **Fits** line (domain × mode × surface) and the quick-match table at the bottom.
2. Propose 3–5 candidate themes, each with a one-line rationale tying it to something specific in the brief.
3. When a human is present, let THEM choose from the candidates; when unattended, pick by fit + anti-convergence — never reuse your previous build's theme.
4. Derive the concept's mechanisms from the chosen themes' mechanism palettes, and cite the exemplars (Name — part number) in the design record.

**Visual layer (local, generated):** run `python library/picker.py` once — it screenshots the exemplars into `library/shots/` (gitignored; ~85% succeed — bot-protected/WebGL-heavy sites fall back to text cards) and builds `library/PICKER.html`, the visual picker grid. When proposing themes to a caller, READ the candidate themes' exemplar images (`shots/<slug>.png`) so your proposal is grounded in what the references actually look like, and open PICKER.html in their browser so they CHOOSE with their eyes. The images are for local design research only — never republished.

---

## Family A — Editorial & Print
*Print grammar as interface: type does the work decoration would otherwise do.*

### 1. Quiet-Luxury Editorial
**Identity**: oversized serif, film grain, restraint carried by motion quality — the glossy magazine where elegance beats spectacle.
**Fits**: studio/brand portfolios, luxury and lifestyle e-commerce, investing/finance that reads like a glossy (Wealthsimple); Entice + Consume; web (shop surfaces adapt to mobile).
**Exemplars**: Exo Ape — 01; Wealthsimple — 03; Dior — 07; Folch Studio — 05; Synchronized Studio — 01; MA — 01.
**Mechanisms**: cinematic hover (work rows expand full-bleed with inertia); lookbook spreads replacing product grids; magazine embedded inside the product as retention surface; sticky annotations pacing full-screen spreads; multi-layer parallax on cover-shoot pages; tight tracking + grain as the polish layer.
**Pairs**: Heritage Material (the atelier flagship) · One-Scene Journey (cinematic luxury launch).

### 2. Brutalist Anti-Portfolio
**Identity**: text-only lists, wireframe grids, slogans as microcopy — confidence through typography alone, the page so quiet the product carries it.
**Fits**: personal/studio portfolios, fashion and tech brands flexing restraint, dev-facing brands; Entice; web-only.
**Exemplars**: Balenciaga — 07; B14 — 05; Tobias van Schneider — 05; Unseen Studio — 06; AIM — 01.
**Mechanisms**: bare typographic project list with zero imagery; one strong interaction per screen; campaign slogans as interface copy ("No blabla"); near-black pages + huge self-set type; constructivist rules and big numerals as a functioning grid; generative canvas type posters as hover states.
**Pairs**: Ink & Hairline Subtraction (the brutal ledger) · Kinetic Constructivist (brutalism that moves).

### 3. Kinetic Constructivist
**Identity**: poster-scale numerals, rotated rules, type that reacts to scroll velocity — the printed poster set in motion.
**Fits**: athlete/celebrity brands, high-energy launches, music and sports; Entice; web-only.
**Exemplars**: Lando Norris — 01; SHIFTBRAIN — 05; Obys — 01; Locomotive — 01; AIM — 01.
**Mechanisms**: scroll-velocity-reactive skew on display numerals; kinetic type as the primary visual; rotated rules / red-black constructivist grids; grid-breaking layouts that stay legible; marquee tickers of real content; concept-per-redesign identity system.
**Pairs**: Telemetry HUD (the broadcast poster) · Festival Poster Energy (kinetic type at festival volume).

### 4. Data Story-Deck
**Identity**: one giant metric per full-screen card, pre-formatted for sharing — analytics as a narrative deck, not a dashboard grid.
**Fits**: year-in-review features, onboarding recaps, shareable stats, learning/fitness summaries; Consume + Play; mobile-first (H5 and stories both native here).
**Exemplars**: Spotify Wrapped — 04; NetEase Cloud Music annual report — 05; AnyDistance — 02; Slopes — 02; The Fallen of World War II — 06.
**Mechanisms**: one-metric-per-card vertical story deck; giant typographic numbers + persona labels; every card screenshot-ready; seasonal scene-based color palettes; ego-safe non-judgmental copy so sharing is safe; scrub-able timeline over data-driven animation.
**Pairs**: Share Artifact (the deck as the artifact) · Mascot & Tone (a host for the numbers).

---

## Family B — Instrument & Desk
*Calm, glanceable, credible tools: scan wins, motion stays near-zero, trust is visible.*

### 5. Calm Instrument
**Identity**: typography-led cards, spring physics, every stress managed — the tool that feels like a well-balanced instrument in the hand.
**Fits**: productivity, travel/utility, status/tracking, critical info surfaces; Operate; mobile-first (web app shells inherit it).
**Exemplars**: Flighty — 02; Things 3 — 02; Watch Duty — 02; Elk — 02; Linear — 01.
**Mechanisms**: calm white-card typography under stress (flying, fire); spring-physics drag-to-target capture; stroke-drawn checkmark + bounce-away completion; thumb-scroller pickers with shortcut rows; interactive edge-swipe peek transition; trust made visible (verified sources credited per update).
**Pairs**: Glance OS (the instrument beyond the app) · Ledger-Craft (the instrument for money).

### 6. Ink & Hairline Subtraction
**Identity**: one near-black ink on white, 1px borders, mono numerals — the design system as an exercise in subtraction.
**Fits**: dev tools, infra products, API/fintech landing pages, minimal design systems; Operate + Entice (dev-flavored); web.
**Exemplars**: Vercel — 01; Linear — 01; Stripe — 01; Unseen Studio — 06; Raycast — 07.
**Mechanisms**: single ink carrying headings, CTAs and 1px borders; mono numerals for data; real-UI hero (actual product footage, zero stock); changelog/release-notes as site structure; syntax-highlighted working code samples as the pitch; 150–200ms ease-out motion budget.
**Pairs**: Pro Terminal (subtraction with a command line) · Brutalist Anti-Portfolio (subtraction as identity).

### 7. Telemetry HUD
**Identity**: tickers, sector lines, readouts framing content — the interface as broadcast graphic, pretending to be in-world.
**Fits**: sports/gaming/esports, automotive, fintech trading, sci-fi tech brands; Entice (marketing) + Operate (second screens); both surfaces.
**Exemplars**: Lando Norris — 01; F1 Live Timing — 07; Star Atlas — 01; Igloo Inc — 01; Binance — 03.
**Mechanisms**: HUD tickers and speed/gear readouts framing every block; split-flap departure-board status states; live leaderboard + driver map synced to broadcast; depth meter doubling as scroll progress; speculative in-world UI for all lore content; spatial audio that muffles as you descend.
**Pairs**: Kinetic Constructivist (the poster version) · Pro Terminal (the desk version).

### 8. Pro Terminal
**Identity**: dense dark layout, keyboard-first, one app two skill levels — the trading desk compressed legibly onto any screen.
**Fits**: trading/proficiency tools, dev tools, AI editors, admin consoles; Operate; web + desktop + mobile (Binance proves phone-density).
**Exemplars**: Binance — 03; Raycast — 07; Linear — 07; Arc — 07; Cursor — 07.
**Mechanisms**: candlestick + order book legible on one phone screen; beginner bottom-sheet hiding pro mechanics (Convert mode); Cmd/Ctrl+K command palette everywhere; ghost-text next-edit prediction; AI changes as reviewable diffs; preview-per-branch with comments on the live artifact.
**Pairs**: Ink & Hairline Subtraction (terminal minimalism) · Telemetry HUD (terminal as broadcast).

### 9. Ledger-Craft
**Identity**: the activity feed as a recognizable story — logos, map pins, pots, plain language — money (or any event log) made human.
**Fits**: banking/fintech, billing, notifications inbox, any activity feed; Operate + Consume; mobile-first (Monzo feed is the benchmark), web dashboards inherit.
**Exemplars**: Monzo — 03; Starling Bank — 03; N26 — 03; YNAB — 03; Copilot Money — 03.
**Mechanisms**: transaction rows with merchant logos, purchase-location map, user emoji notes; Pots/Spaces visual sub-accounts with covers; assign-every-dollar inbox as the core loop; category-colored stacked bars with tap-to-drill (no legend); insights aggregated at named-merchant level; plain-language monthly summaries replacing tables.
**Pairs**: Calm Instrument (the calm ledger) · Mascot & Tone (the witty ledger).

### 10. One-Number Calm-Data
**Identity**: a single headline metric that prescribes behavior, color as status — dense signals compressed to three readable depths.
**Fits**: health/fitness, budgeting, analytics home screens; Operate; mobile-first (watch included).
**Exemplars**: Whoop — 07; Oura — 07; Gentler Streak — 02; Lumy — 02; Hopper — 03.
**Mechanisms**: one 0–100 score converted into today's effort prescription; score → contributing metrics → raw signal drilldown; body-state color system for instant reads; readiness band visualizing exertion vs recovery; color-painted date calendar (forecast as color, not chart); plain-language "buy now / wait" advisories with confidence.
**Pairs**: Calm Ritual (the forgiving coach) · Data Story-Deck (the annual version).

### 11. Glance OS
**Identity**: the product lives on lock screen, wrist and widget — answers arrive before the ask, opening the app is the exception.
**Fits**: tracking/status/utility apps, travel day-of, ambient info; Operate; mobile-first by definition (iOS surfaces).
**Exemplars**: Flighty — 02; Lumy — 02; Widgetsmith — 02; Tiimo — 02; Trainline — 07.
**Mechanisms**: Live Activity / Dynamic Island as split-flap departure board; push answers before you ask (gate changes, delays); widget as designed artifact with time-based scheduling; watch-first glance answering one question; sun/moon arcs as ambient home-screen data; day blocks that shrink as time passes.
**Pairs**: One-Number Calm-Data (what the glance shows) · Calm Instrument (the full app beneath).

---

## Family C — Craft & Care
*Material, warmth and forgiveness: the human hand visible, the pacing gentle.*

### 12. Heritage Material
**Identity**: macro photography of woven thread, patina narrated over years — one material image carries the whole site.
**Fits**: heritage/craft brands, luxury maisons, museums, premium B2B wanting gravity; Entice + Consume; web-only.
**Exemplars**: HOSOO — 05; KAIKADO — 05; Immersive Garden — 06; Dior — 07.
**Mechanisms**: extreme macro material texture as full-bleed art direction; patina/aging as the product story; one-object minimal hero; shader-material product macros with art-directed camera moves locked to scroll; quiet bilingual typography; collection microsites treated like magazine issues.
**Pairs**: Quiet-Luxury Editorial (the maison lookbook) · Product Turntable (the material in hand).

### 13. Warm Humanist
**Identity**: house illustration, rounded forms, warm haptics — trust-critical products that feel made by people.
**Fits**: health, banking, family/kids, food delivery, civic services; Consume + Care flows; both (KakaoBank proves mobile).
**Exemplars**: Hello Monday — 05; Headspace — 07; KakaoBank — 03; Bears Gratitude — 02; Wolt — 07.
**Mechanisms**: mascot illustration doing the emotional work before content starts; systematized house illustration + adaptive rounded motion; warm haptics tuned as reassurance; hand-drawn companion reacting to your input; craft capabilities named like product lines; breathing-paced motion as therapy.
**Pairs**: Mascot & Tone (the humanist with a voice) · Calm Ritual (the humanist at bedtime).

### 14. Calm Ritual
**Identity**: no scores, no streaks, no urgency — pacing itself is the feature, the site that lowers your heart rate.
**Fits**: sleep/wellbeing, meditation, journaling, wind-down content, anti-marketing brand experiences; Consume + Play (gentle); mobile-first apps + cozy web worlds.
**Exemplars**: Loóna — 02; Messenger — 01; iA Writer — 02; Headspace — 07; Bears Gratitude — 02.
**Mechanisms**: guided moodscapes fusing coloring, ambient sound, slow narration; low-stakes cozy objectives (exploring is the reward); everything dims except the sentence being edited; one gentle question per day, never a blank page; deliberate gentleness engineered into every interaction; custom typeface tuned for long-form reading.
**Pairs**: One-Number Calm-Data (calm that still measures) · Warm Humanist (calm with a face).

### 15. Accessible Strength
**Identity**: time made visible, haptics as language, one giant button — strength designed for the edges becomes better for everyone.
**Fits**: planning/accessibility tools, health, step-through instructions, help flows; Operate + Consume; mobile-first.
**Exemplars**: Tiimo — 02; Oko — 02; Be My Eyes — 02; StaffPad — 02; Crouton — 02.
**Mechanisms**: day as color-coded blocks that literally shrink as time passes; distinct haptic patterns translating signals (crosswalk state); entire UI as one giant call button; handwriting converting to engraved structured output; camera-blink hands-free step advance; full-screen color focus timer + icon-first scheduling.
**Pairs**: Calm Ritual (strength at rest) · Glance OS (strength at a glance).

---

## Family D — Play & Festival
*Physics, toys, mascots and posters: delight as the retention strategy.*

### 16. Toy-Box Physics
**Identity**: squishy tiles, spring-back cards, zingy haptics — a boring utility category made tactile and alive.
**Fits**: habits, lists, local services, kids/family brands, high-stakes flows needing delight; Play + Operate; mobile-first (haptics are the medium).
**Exemplars**: Things 3 — 02; (Not Boring) Habits — 02; Resn — 01; Rainbow — 03; Don't Board Me — 01.
**Mechanisms**: draggable FAB blooming drop targets; squishy physics tiles with celebration particles; loader as physics mini-game with 0–100% counter; playable homepage with no dead pixels; spring-back card stack with tilt stamps as feed-forward; delight injected into terrifying confirmation flows (send/swap).
**Pairs**: Playable Instrument (the toy that works) · Mascot & Tone (the toy with a face).

### 17. Playable World
**Identity**: the site is a game — drivable, cozy, or one embedded minigame — dwell time is the metric.
**Fits**: creative-dev portfolios, brand experiences, education/tourism, anti-marketing marketing; Entice + Play; web-only (mobile-tolerant variants documented).
**Exemplars**: Bruno Simon Portfolio — 01; Messenger — 01; Viens-là — 05; Chrome Music Lab — 06; Blobmixer — 06.
**Mechanisms**: drivable physics playground as CV with easter-egg retention; cozy 3D courier game as website (calm as constraint); two-color world + one embedded darts game woven into navigation; instant-load shareable micro-experiments; every creation encoded entirely in the URL.
**Pairs**: Toy-Box Physics (the world's tactile layer) · All-Shader Simulation (the world's engine).

### 18. Playable Instrument
**Identity**: skeuomorphic decks, spinning reels, faders with real physics — pro power that reads instantly because it's playable.
**Fits**: creative tools (music, photo, video, drawing), prosumer utilities; Operate + Play; mobile-first (iPad is the ceiling).
**Exemplars**: djay — 02; Looom — 02; Procreate Dreams — 02; Tinder — 04; Elk — 02.
**Mechanisms**: turntable metaphor with real scratch physics; animation layers as spinning reels (mixer metaphor, draw while it plays); direct-manipulation timeline that keeps playing while you edit; swipe-scaled amounts (table replaces keypad); advanced DSP collapsed into a slider gesture; radial gesture palette + press-and-hold to reassign.
**Pairs**: Toy-Box Physics (the instrument's fun side) · Telemetry HUD (the instrument's readouts).

### 19. Mascot & Tone
**Identity**: a character delivers the data and the tone is a setting — personality as the interface, copy as the design medium.
**Fits**: weather/learning/finance apps, notifications, campaign mascots, settings-with-a-voice; Consume + Play; mobile-first.
**Exemplars**: CARROT Weather — 02; Duolingo — 02; Cleo — 03; monobank — 03; KakaoBank — 03.
**Mechanisms**: snarky AI character delivering forecasts with secret scenes; explicit tone toggle (Roast / Hype mode); reactive mascot that watches, sulks, nags; push receipts witty enough to screenshot and share; characters across serious banking flows without losing clarity; single linear path + guide characters removing choice paralysis.
**Pairs**: Warm Humanist (the mascot's soft voice) · Data Story-Deck (the mascot's annual show).

### 20. Festival Poster Energy
**Identity**: slogan typography, lineup-as-poster, ticket-first IA — the campaign site that feels like merch.
**Fits**: events/festivals, launches, Gen-Z CPG, invites, PSAs; Entice + Play; web + mobile (Korean festival canon).
**Exemplars**: WATERBOMB Festival — 05; Incheon Pentaport Rock Festival — 05; Mana Yerba Mate — 01; Partiful — 03; Dumb Ways to Die — 01.
**Mechanisms**: slogan type as hero ("SEOUL GETS WET AGAIN"); lineup pages as posters; ticket-first information architecture; franchise microsites sharing one system; genre-matched texture (grunge for rock, kawaii for pop); oversized condensed type + marquee tickers; invites as personal zines, not forms.
**Pairs**: Kinetic Constructivist (the poster in motion) · Share Artifact (the poster in your feed).

---

## Family E — Immersive & Realtime
*Scroll cameras, shaders, simulation: the browser as a real-time medium.*

### 21. One-Scene Journey
**Identity**: one persistent 3D world, scroll is the camera — sections are stops on a descent, never separate pages.
**Fits**: tech/Web3 launches, deep-tech explainers, sports venues, heritage journeys; Entice; web-only (the flagship pattern).
**Exemplars**: Igloo Inc — 01; KPR — 01; Orano — 01; Prometheus Fuels — 01; Kode Sports Club — 01; 100,000 Stars — 06.
**Mechanisms**: scroll-linked camera dolly through one scene; content docking at each depth/stop; particle streams carrying the narrative; refraction shaders + spatial audio that muffles on descent; camera gates (doorways opening vistas) as pacing; one continuous zoom-out as the whole site structure.
**Pairs**: All-Shader Simulation (its rendering discipline) · Cinematic Documentary (its narrative discipline).

### 22. Product Turntable
**Identity**: the product is the interface — scroll-choreographed turntable, macro callouts, every option visual, never a checkbox.
**Fits**: consumer hardware, automotive configurators, CPG/packaging-led brands, single-SKU launches; Entice + Consume (configurator); web-only.
**Exemplars**: Opal Tadpole — 01; Porsche Car Configurator — 07; Rimac Configurator — 07; Simply Chocolate — 01; Polestar — 07.
**Mechanisms**: scroll-choreographed turntable with callouts pinned to hardware details; billions of combos all visually represented; real-time material swap instead of baked image layers; openable doors / 360 mode + AR companion; page re-skinning to each product's palette; scale contrast (display type vs micro photography).
**Pairs**: All-Shader Simulation (the render pipeline) · Heritage Material (the material close-up).

### 23. All-Shader Simulation
**Identity**: procedural geometry, shader-rendered UI, self-downgrading quality tiers — simulation replaces downloads.
**Fits**: tech-brand flagships, studio portfolios, data-visualization worlds, any real-time hero; Entice; web-only, engineering-heavy.
**Exemplars**: Igloo Inc — 06; The GitHub Globe — 06; Lusion — 06; Active Theory — 06; Abeto — 06.
**Mechanisms**: crystal-growth algorithms instead of modeled assets; UI text rendered in shaders; FPS watchdog auto-downgrading quality tiers (12k→8k, pixel ratio); WebGL synced to native scroll without hijack; one scene graph across devices; instanced primitives (no textures) + SVG placeholder crossfade.
**Pairs**: Product Turntable (the shoppable version) · Playable World (the playable version).

### 24. Cinematic Documentary
**Identity**: film grammar on the web — letterboxing, ink drawings, dual perspectives — scroll authors the pacing, the reader holds the throttle.
**Fits**: journalism, museums/heritage, awareness campaigns, year-in-review, documentary brands; Entice + Consume; web-only.
**Exemplars**: The Boat — 01; Persepolis Reimagined — 01; The Other Side of Truth — 01; Nomadic Tribe — 01; Cher Ami — 05.
**Mechanisms**: ink drawings animated via sprite sequences synced to scroll; scrollbar as the only control, storm intensity tied to scroll speed; dual-perspective mirrored scenes flipping mid-scroll; letterboxing + sound-reactive ambience doing the emotional work; guided path vs free-wander duality; pre-rendered engine footage stitched into one continuous journey.
**Pairs**: One-Scene Journey (the 3D version) · Living Illustration (the drawn version).

### 25. Living Illustration
**Identity**: hand-drawn frames that breathe — physics inside illustrations, panels as navigation — craft and creative code merged.
**Fits**: editorial campaigns, illustrated brand worlds, tourism, playful education; Entice; web-only.
**Exemplars**: Ponpon Mania — 01; Nomadic Tribe — 01; Umami Land — 01; Species in Pieces — 06; The Boat — 06.
**Mechanisms**: physics-based mouse interaction inside hand-drawn frames; the page IS the storyboard (panel-to-panel nav + chapter select); WebGL displacement masks morphing portraits; pixel-art RPG world map with towns as pages; kawaii micro-interactions + full sound kit; clip-path polygon morphing (30 triangles, zero images, compositor-only).
**Pairs**: Cinematic Documentary (illustration with narration) · Warm Humanist (illustration with warmth).

---

## Family F — Flow & Convert
*Interaction identities for funnels: the flow pattern itself becomes the product's character.*

### 26. Three-Tap Radical
**Identity**: the decades-old flow collapsed to three taps — a working demo before signup, value in the first ten seconds.
**Fits**: fintech/actions, onboarding, settings flows, anything "always been that long"; Operate + Convert; mobile-first.
**Exemplars**: Toss — 03; Wise — 04; Coinbase — 03; Nubank — 03; SoundCloud — 04.
**Mechanisms**: three-step bank transfer replacing a security-card maze; real-rate calculator live pre-signup; instant virtual card issued mid-onboarding; skip sign-up, land straight in the product; complexity hidden behind one "Advanced" layer; contextual permission asks at first relevant use.
**Pairs**: Keypad-First Numeric (the input side) · Calm Instrument (the texture around the flow).

### 27. Keypad-First Numeric
**Identity**: the amount screen IS a purpose-built pad — giant readout, no wrong characters, one-thumb everything.
**Fits**: payments/trading/quantities, checkout, conversion flows; Convert + Operate; mobile-first.
**Exemplars**: Cash App — 04; Venmo — 03; Robinhood — 03; Coinbase — 03; Elk — 02.
**Mechanisms**: custom numeric pad bypassing the OS keyboard (app handles the decimal); segmented Buy/Sell ticket with fractional percentages; swipe-to-scale amounts in multiples, tap for precision; live preview of outcome before commit; per-tap categorized push with merchant logo; success states engineered for usually-terrifying flows.
**Pairs**: Three-Tap Radical (the flow around the pad) · Milestone Theater (what happens on confirm).

### 28. Milestone Theater
**Identity**: progress as theater — staged trackers, named crew, confetti ethics — waiting states designed as the product.
**Fits**: order tracking, goal funding, onboarding milestones, mission-driven brands; Convert + Consume; mobile-first.
**Exemplars**: Robinhood — 03; Domino's Pizza Tracker — 07; Wolt — 07; bunq — 03; Acorns — 03; YNAB — 03.
**Mechanisms**: staged progress (placed → making → delivering) with named store crew; confetti on first trade — celebrate milestones, not risk-taking; delivery timer hiding mini-games; mission counters (lifetime trees planted); round-ups animated accumulating into the portfolio; goal-funded celebration moment.
**Pairs**: Share Artifact (the milestone worth sharing) · Mascot & Tone (a host for the ritual).

### 29. Share Artifact
**Identity**: the result is a poster — routes as gradient art, stats as keepsake cards, creations as URLs — the share IS the reward loop.
**Fits**: fitness/social, year-in-review, generative toys, portfolio proof, referral loops; Play + Consume; both surfaces.
**Exemplars**: AnyDistance — 02; Flighty — 02; Spotify Wrapped — 04; Blobmixer — 06; Chrome Music Lab — 06; NetEase Cloud Music annual report — 05.
**Mechanisms**: runs rendered as shareable posters (custom type, route gradients, elevation art); flight history as custom-artwork Passport stats; every creation encoded in the URL; red "share to friend" CTA as the final beat; ego-safe non-judgmental content engineered for forwarding.
**Pairs**: Data Story-Deck (the artifact as a deck) · Festival Poster Energy (the artifact as merch).

### 30. Scarcity & Drop
**Identity**: one film a day, raffle draws, surprise bags — inventory scarcity turned into appointment, event and treasure hunt.
**Fits**: commerce drops, marketplaces, booking/waitlists, media programming; Convert + Play; mobile-first.
**Exemplars**: MUBI — 07; Nike SNKRS — 07; Too Good To Go — 03; Resy — 07; Robinhood — 04.
**Mechanisms**: film-of-the-day slot making the service an appointment; draws + Exclusive Access tiers choreographing launch day; mystery "surprise bag" inventory with pickup windows; table-watch waitlist notifications instead of dead ends; referral waitlist (skip ~1,000 places per friend); price-freeze holding uncertainty as a product.
**Pairs**: Festival Poster Energy (the drop as an event) · Milestone Theater (winning the drop).

### 31. Browse-First Discovery
**Identity**: categories over query — vibe shelves, mood quizzes, map+sheet browsing — for people who don't know the query yet.
**Fits**: travel, marketplaces, media catalogs, recruiting/inspiration; Consume; mobile-first (bottom-sheet canon).
**Exemplars**: Airbnb — 03; momondo — 03; Houzz — 03; Spotify — 04; Umami Land — 01.
**Mechanisms**: ~56 curated vibe Categories as shelves above the search box; mood-based visual trip quiz (vibe/budget/temperature); browse with no destination or date; recent searches as artwork cards + per-item dismiss; wishlist/moodboard collections turning browsing into curating; split-view map + bottom-sheet filters.
**Pairs**: Scarcity & Drop (discovery with stakes) · Quiet-Luxury Editorial (discovery as a magazine).

### 32. Parse, Don't Fields
**Identity**: type a sentence, watch it become structure — live token highlighting, tags as folders, chat as the query surface.
**Fits**: creation forms, notes/tagging, AI answer surfaces, capture tools; Operate + Consume; mobile-first.
**Exemplars**: Fantastical — 02; Bear — 02; Arc Search — 02; Mela — 02; Cleo — 03.
**Mechanisms**: natural-language input with live inline parse coloring (date/time/place tokens); nested hashtags as the whole filing system; one query → cited answer page with sources as layout; URL/photo mess normalized into structured data; conversational interface replacing dashboard navigation; swipe between library/editor/preview.
**Pairs**: Three-Tap Radical (capture at speed) · Pro Terminal (the keyboard-native desk).

### 33. Composable Surface
**Identity**: the user composes the dashboard — drag-to-reorder cards, full theming, scheduled layouts — personalization as the visible payoff.
**Fits**: dashboards, media apps, utility/personalization surfaces; Operate + Consume; mobile-first (Material You ecosystem).
**Exemplars**: CARROT Weather — 02; Telegram — 04; Pocket Casts — 03; Widgetsmith — 02.
**Mechanisms**: drag-to-reorder, tap-to-hide card system + Smart Layout auto-reordering by conditions; theming platform (accent, wallpaper, bubble palette) with community AMOLED themes; dynamic color + true-black OLED variant + per-user accent; per-widget style/font/tint/photo customization with live preview; time-based scheduling (morning/afternoon/evening layouts).
**Pairs**: Glance OS (the composed surface at a glance) · Mascot & Tone (the composable personality).

---

## Quick-match table

| Brief | Three suggested themes |
| --- | --- |
| Landing / product launch (Entice) | One-Scene Journey · Kinetic Constructivist · Product Turntable |
| Dashboard / internal tool (Operate) | Calm Instrument · Ledger-Craft · Ink & Hairline Subtraction |
| Fintech app | Ledger-Craft · One-Number Calm-Data · Mascot & Tone |
| Checkout / conversion flow | Keypad-First Numeric · Three-Tap Radical · Milestone Theater |
| Configurator / commerce | Product Turntable · All-Shader Simulation · Composable Surface |
| Onboarding funnel | Three-Tap Radical · Mascot & Tone · Data Story-Deck |
| Portfolio (studio / personal) | Playable World · Brutalist Anti-Portfolio · Quiet-Luxury Editorial |
| Editorial / content site (Consume) | Quiet-Luxury Editorial · Data Story-Deck · Living Illustration |
| Mobile tool (Operate, mobile-first) | Calm Instrument · Glance OS · Toy-Box Physics |
| Health / calm (Care) | Calm Ritual · One-Number Calm-Data · Accessible Strength |
| Dev-tool / AI product | Ink & Hairline Subtraction · Pro Terminal · Parse, Don't Fields |
| Festival / campaign / launch event | Festival Poster Energy · Share Artifact · Cinematic Documentary |

*Every exemplar cited above exists as a named entry in `parts/01`–`07`; cite them as `Name — part` in the design record.*
