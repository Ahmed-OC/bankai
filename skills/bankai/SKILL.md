---
name: bankai
description: Use at the start of ANY UI/frontend work — new products, screens, restyling, design systems, components, motion, polish, or reviews. Master entry point of the 106-skill canon (a curated design-engineering reading list, distilled): product modes, variance dials, shared values with exact numbers, conflict rulings, routing to child skills, and the anti-slop delivery gate.
source: https://github.com/Ahmed-OC/bankai
category: reference
---

# bankai — the canon for interfaces that don't look generated

106 child skills sitting as SIBLING FOLDERS next to this skill's folder (i.e. in the same `skills/` directory: `skills/<name>/SKILL.md`), one per curated link (authors: Rauno Freiberg, Emil Kowalski, Jakub Krehel, Paco Coursey, Raphael Salaja, Josh Puckett, Maggie Appleton, Brad Frost, Butterick, and ~60 more), plus `spectacle`, `domain-fit`, `micro-craft`, `dynamism`, `3d-craft` (synthesized from research and eval cycles). This file is the only one you open by default; it carries the shared doctrine and routes you to a child only when a problem needs that child's depth. `_CONVENTIONS.md` (same skills directory) is the binding format for every child (read it before writing or updating one).

Why this exists: AI can now produce any interface instantly — which means undifferentiated interfaces. The canon's one job is **variance with intent**: pick a deliberate position (mode, dials, aesthetic family), execute it with the exact numbers the best practitioners converged on, and never ship the tells of generated work. The anti-slop ban list (§7) and the delivery gate (§8) are non-negotiable in every mode.

## 1. The Differentiation Engine — never build "the same app" twice

Before any code: run these four steps and write the result down. If you skip them, you will default to the mean of everything you've built — which is exactly what slop is.

**Step 1 — Product mode** (from Impeccable's mode system; details → `impeccable`):

| Mode | Product type | Scanability vs expression | Density | Motion budget | Expressiveness floor |
|---|---|---|---|---|---|
| **Operate** | tools, dashboards, IDEs, admin, email | scan wins | high (5-6) | near-zero; only state continuity | instrument calm; NO arrival theatrics, NO cursor replacement — depth goes to interaction richness (R9) |
| **Create** | editors, builders, studios | balanced | high, but generous whitespace around canvas | low-medium; physics-accurate | craft surfaces; signature confined to launch/empty/success moments |
| **Consume** | reading, media, feeds, commerce | comfort wins | medium | low; content is the motion | typographic atmosphere; motion serves legibility and pacing |
| **Entice** | landing pages, marketing, portfolios | expression wins | low | medium-high; signature moments allowed | **MANDATORY: one signature moment** (spectacle Signature Law) + arrival choreography; VARIANCE 3+ |
| **Play** | games, toys, experiments | expression IS the product | variable | high; effects justified | signature IS the product; push reactivity to the frame budget |

The expressiveness floor is a floor, not a ceiling — but it is checked at the gate (§8): an Entice build without a named, screenshot-worthy signature moment FAILS delivery no matter how clean it is. **Dials cannot vote the floor down**: the design record reports the mode's settings, it does not choose them — an Entice build that declares MOTION 2 / "continuity only" to excuse a missing signature fails the gate exactly as if the signature were absent (an eval pricing page did precisely this and shipped none).

**Step 2 — Set the dials explicitly** (from `taste`; settings are decisions, not accidents):
- **VARIANCE** 1-5 — distance from platform-default look. 1 = invisible-native; 5 = unmistakably yours. Marketing can afford 4-5; a database admin panel cannot.
- **MOTION** 0-5 — 0 = none (justified!), 1-2 = state continuity only, 3 = choreographed entrances, 4-5 = signature animation identity.
- **DENSITY** 2-8 — information per viewport. Tools 5-8, content 3-5, marketing 2-3.
- **ORNAMENT** 0-5 — decorative surface treatments (gradients, glass, grain, borders-as-identity). Most products: 0-2.
- **WARMTH** cool↔warm — gray-blue-neutral vs cream/amber casts (see `floguo` for warm-token craft, `rauno`/`jakub-kr` for monochrome restraint).

**Step 3 — Pick the aesthetic family** (§4.F) that matches your dial settings — and rotate: if your last three builds used the same family, this one must differ. The canon exists so you have 10+ credible positions, not one house style.

**Step 4 — Write a one-line design intent** before building (from `interface-craft`): "A ___ that feels ___ because ___." If you can't write it, you don't have a design yet. Everything downstream checks against this sentence.

**Step 5 — Anti-self-convergence** (mandatory — this canon has its own gravity; A/B evals showed repeated runs collapsing onto cream paper + warm ink + one vermilion accent, square black CTAs, mono micro-labels, the `cubic-bezier(0.22,1,0.36,1)` house curve, and the same hero metaphor):
- **Ban your first concept.** The first metaphor, pun, or hero idea that comes to mind is the one every other run also had. Name it, then ban it and pick the second or third. **Domain attractors are banned explicitly — the top TWO frames per domain, because banning #1 collapses runs onto #2**: money/finance → "ledger"/"well-kept books"/"vault" (taken head-on by 5 eval builds — sometimes verbatim in the intent sentence — while the ban named it); habits → "chain"/"streak" AND "tempo"/"rhythm" (3/3 eval runs banned the chain, then all shipped tempo); analytics → "clarity"/"telescope"; AI → "orbit"/"spark"; health → "pulse"/"heartbeat"; museum → "marble"/"black-and-white"; devtool → "matrix green"; commerce configurators → trust-blue. The domain's obvious metaphor is the slop; the second-obvious one now is too.
- **Rotate the token temperature.** If the last build was warm paper + dark ink + single warm accent, this build must change at least two of: paper/base (cream → cool gray, white, tinted dark), ink temperature, accent hue family (vermilion is this canon's own tell — treat it like AI-purple). At least 1 in 3 builds should be a dark or cool-chrome surface. **Documented accent-defaults of this canon, treat like AI-purple**: vermilion-on-cream, green-on-cool-paper (3/3 runs in one eval wave), amber-on-dark (3/3 in the next), royal-blue-on-light-gray — derive the accent from the domain's material world; if it lands unbidden in one of those families, shift hue angle or treatment.
- **Invent per-run scaffolding.** Section order, step-list treatment, testimonial formula, and heading strings are per-brief inventions — never carry a skeleton, a heading string, or an id-naming scheme across runs.
- **Vary the finishes.** Mono micro-labels, hairline rules, and the house easing are techniques, not identity — each run chooses finishes that serve ITS concept, and repeats of the last run's finish stack are a fail. Mono micro-labels are now the most-repeated canon finish (5 eval builds): reach for them only when the domain is natively mono (timecode, terminal, tabular data).
- **Rotate the conceptual axis too** (v2 eval finding: after the visual fix, three runs still converged on copy). (a) Framing: if the brief invites an opposition ("not X, Y"), at most one run takes it — others must frame positively or as pure utility. (b) Accent hue: green is a documented attractor — after any green-accented build, the next must leave the green family. (c) Testimonials: use a distinct archetype per run (outcome data / workflow moment / before-after / third-party praise) and never reuse narrative+month+name patterns. (d) Structural rhetoric (pricing headlines, step-1 framing, section headings): vary the rhetorical FORM, not just the words — "One price. No tiers." and "One plan. Everything in it." are the same sentence.
- **Never ship strings quoted in this canon.** Rule examples get regurgitated verbatim by independent runs ("One price. No tiers." shipped as real pricing copy in 2 eval builds). Every example sentence in this file is banned as literal copy — write your own rhetoric.
- **The house curve is numbers, not a name.** `cubic-bezier(0.22,1,0.36,1)` and its `(0.19,1,0.22,1)`-family variants are the tell even when the variable is renamed "Snappy Out" — renaming is laundering. And banning one curve breeds a monoculture on the substitute: after the ban, 3/3 independent runs shipped the identical out-quart `(0.25,1,.5,1)`/`(0.165,.84,.44,1)` family. Pick easing per build from the full space (expo-out, circ, back, spring, custom asymmetric) — if your curve choice is also the obvious legal default, it is a tell.
- **Proper nouns are model-prior attractors.** Independent runs converge on the same believable testimonial names and places from the model's own priors, not from this canon (observed: "Mara/Maren" in 2/3 independent builds, "Portland, Oregon" in 3/3 — none of these strings exist in any skill). Invent locally-anchored names and less-default places deliberately; a name you've already used in another build is another house tell.
- **Independent runs have no memory — replace rotation with derivation.** You cannot see your previous builds; "rotate from the last run" is structurally unenforceable alone. In independent runs, divergence comes from deriving temperature, accent, frame, and finishes from THIS brief's domain material world + the top-two ban above. In sequential runs (same session), ALSO rotate off your last build on ≥2 axes.

## 2. Shared values — the numbers the canon agrees on

These are the defaults when nothing else is specified; child skills refine, never silently contradict.

**Motion** (arbitrated in §3.R1; sources: `animations-dev`, `you-dont-need-animations`, `transitions`, `easing`)
- Micro feedback 100-200ms; standard UI transitions 200-300ms (300 is a hard ceiling for most UI); large surfaces/choreography 300-450ms. Exits one tier faster than entrances.
- Entrances ease-out (`cubic-bezier(0.22,1,0.36,1)` family); exits ease-in-ish; never `ease` default; springs for gestures (velocity-carrying, interruptible).
- Stagger 30-80ms between siblings, capped (~8 items). Animate transform/opacity/clip-path only — never width/height/top/left in hot paths.
- `prefers-reduced-motion: reduce` → collapse to opacity fades or nothing. Non-optional.
- **Dynamism targets by mode** (`dynamism` ladder): Operate L2-3 at rest / L5-6 while working; Entice **L5-6 sustained** (ambient life + reactive signature — measure at-rest AND peak; a signature at L6 over an L1 page fails); Consume L3-4; Play L6. Color-only hovers, dead numbers, teleporting lists, and missing exits are motion bugs, not style choices. **At-rest life is a mechanism, not a level claim**: an Entice/Consume surface ships ≥1 of — live clock/counter, ambient drift of the signature element, a marquee/ticker of real content, a breathing status indicator, animated grain-plus-motion — paused off-screen (IntersectionObserver/visibilitychange) and collapsed under reduced-motion. **At-rest life must be TRUE or LABELED** (eval: 4/4 canon builds fabricated it): local truths only (the actual clock, computed dates, the demo's own live state, the user's session) or simulations explicitly tagged illustrative — a ticking platform counter ("38,412 sessions this week", "2,431,907 fixes") or a fake device link ("KICKR CORE linked") with no backend is fabricated liveness, the newest canon-created tell. Session-local counters ship the ZERO (or "—") as their static fallback — a no-JS visitor reading "2 stitches sewn tonight" for actions they never took is the same lie in milder form (gold standard: an explicit "nothing here is live; these are set values" label). Idle/decorative motion must not wobble data readouts (display drifting while `aria-valuenow` stays fixed is a display/AT desync — sway the instrument, not the number). VARY the mechanism across runs: the live ticking counter is becoming the canon's own default (3/3 independent builds shipped one); clock, drift, marquee, and breathing are equally valid. CSS-driven ambient loops must ALSO pause off-screen (an IO-toggled class flipping `animation-play-state`, or `content-visibility`) — pausing only the JS loop while CSS animations run unseen is a half-pass (eval finding). Static-capture governs the FIRST frame and the no-JS render only; ambient life that starts after first paint violates nothing (eval: one build deleted its live tick "for static-capture" — a false conflict; it just lost the ladder points).

**Typography** (`practical-typography`, `calvez-typography`, `krehel-skills` §1)
- Body ≥16px (12px absolute floor for dense captions, know why). Line-height 1.5 body / 1.1-1.3 display. Measure 45-75 (max 90) characters.
- Smart quotes, real em/en dashes (— – not ---), no letterspaced lowercase, no fake small-caps, tabular-nums for data, `text-wrap: balance` on headings.
- One variable font family with a few weights beats five families. Inter is fine — and a tell of laziness if chosen by default; choose deliberately (`inter-alternatives`).
- **Character without webfonts** (eval: bare system-ui for BOTH display and body marked every build stuck below 9 — 11/24): body may be the platform sans ONLY IF the display voice is a named non-default stack chosen from the domain's culture (Georgia/Iowan/Charter/Palatino serif, a grotesk, or mono when natively mono). Character = display stack + scale ratio ≥2.5× display:body + deliberate tracking + at least one typographic device (drop cap, hairline rules, masked or justified headline, real small-caps via font-variant, guillemets/en-dash rhythm). The gate fails bare `system-ui` display+body pairs.

**Color** (`oklch`, `krehel-skills` §2)
- Build ramps in OKLCH (perceptually even lightness), map to semantic tokens, derive dark mode by lightness inversion, not inversion of everything. If hex is used instead, the ramp must still be perceptually even AND the 2-3 smallest-text contrast ratios annotated in a token comment — **write the annotations WITH the code, at authoring time** (eval: the build that annotated ratios in `:root` scored 91 — comments written with the code cannot decay; the ones carried in memory died within 10 minutes). Annotated at birth, verified by computation at the gate.
- Contrast 4.5:1 body text, 3:1 large text and UI boundaries (AA floor; test in the target rendering, not the picker).
- Gray ≠ gray #808080 on everything: tint neutrals toward the primary hue or temperature dial.

**Space & structure** (`krehel-skills` §3, `use-layouts`, `kugiri`)
- 4px-based scale; group → align → rhythm. Separate with space first, hairlines second, never both everywhere.
- Named layouts (sidebar, bento, split, holy-grail…) over invented box arrangements — `use-layouts` catalog.
- Radii as a system: concentric nesting `inner = max(0, outer − padding)` (`corner-radii`). Elevation as layered shadows with one light source (`shadowlab`), 3-4 levels max.

**Interaction floor** (`web-interface-guidelines`, `laws-of-ux`, `ui-skills`)
- Touch targets ≥44×44. The constrained floor (24px) is only legal with an EXPANDED hit area (`button{position:relative} button::after{position:absolute;inset:-6px}` on the control) — a 34-38px control with no expansion is the single most-failed law in evals (13/24 builds) because "space-constrained" became an alibi; dense is not small. `:focus-visible` ring 2px offset 2px on everything interactive — never remove outlines without replacement.
- Hover is enhancement, never the only path. Every action reachable by keyboard; Escape closes; focus trapped in dialogs and returned on close. **Focus never dies in a dismissed container**: when a toast/undo/panel hides while focus sits inside it, refocus the originating control (eval: undo buttons `display:none` with focus inside dumped keyboard users to `<body>`).
- Feedback within 100ms of any input; loading = communicate progress honestly (`loading-dev` wait-length table).

## 3. Conflict rulings — when children disagree, this decides

- **R1 "Should this animate?"** — `you-dont-need-animations` holds the veto: no purpose (continuity, causality, orientation) → no animation; high-frequency or keyboard-driven surfaces → zero-animation budget. Only when the veto passes does `animations-dev` define how. Default answer is no; motion is a budget you spend, not a feature you add.
- **R2 "Effect vs restraint"** — effect catalogs (`fancy-components`, `magic-ui`, `liquid-glass`…) are menus, not mandates. The budget: **one signature effect per view, one per product identity** — and the signature has a minimum bar (a scene with composition + motion + reactivity, not a hover garnish — see `spectacle` Signature Law). Scope: R2 meters *entrances and decoration only*. **Feedback is unmetered**: toasts, undo, count-ups, hover-scrub, price morphs, and every ≤300ms response to user action are craft obligations, never ornament to cut. If removing a decorative effect changes nothing, remove it; if removing a feedback state changes the user's confidence, it stays.
- **R3 "Native vs library vs port"** — check `html-can-do-that` first (native always wins). Then the `bencho` route ladder: hand-roll > copy MIT block > install. Installing is justified when the library encodes hard-won physics you'd get wrong (toast dismissal physics → `sonner`; digit odometer → `number-flow`; scrollbars, focus traps, fuzzy search in cmdk → `cmdk`). Port the mechanism for everything else — mechanisms are in every child skill precisely so you can.
- **R4 "Minimal vs rich"** — decided by the dials (§1), never by habit. Minimalism is a setting (VARIANCE 2-3, ORNAMENT 0-1, executed richly — see `galleries` "minimum" profile), not an absence of effort; dense warmth (`floguo`) is equally valid at other settings.
- **R5 "AI-native vs agent theater"** — AI-interface patterns (`beautiful-ui`, `anatomy-ai-input`) apply only when a model is actually in the loop with real latency and real state. Never wrap a one-shot call in streaming theatrics or fake thinking states. **Provenance must be true**: any UI that ASSERTS an effect happened (provenance rows, change-log citations, receipts, "moved 3 tasks to Sprint 15") must actually perform that mutation in the DOM — asserted-but-absent mutations are agent theater too (eval: a panel shipped provenance rows for board edits that never occurred).
- **R6 "Delight vs speed"** — delight = speed first (`ui-land` interviews consensus, `family-values`): nothing delightful is slow. Performance beats every aesthetic argument.
- **R7 "Evidence vs taste"** — where real experiment data exists (`abtest-design`), it outranks individual taste; where it doesn't, taste rules (`concept-of-taste`, `shedsgns-taste`) — and taste is trainable exposure + analysis, not opinion.
- **R8 "Briefs are floors, not ceilings"** — enumerate the brief's explicit requirements as a checklist; every one ships. Then the **unrequested-depth pass**: list 3 interactions a pro would add on this surface (undo for destructive actions, quick-fill/sample data, search or filter, keyboard grid navigation, commit actions for generated content, secondary export) and ship at least 2. On marketing surfaces the pro-pass ALSO includes persuasion proof elements (a stats band with real-feeling numbers, a second testimonial, client logos) — persuasion completeness is depth, not ornament. Never downgrade a required capability to a weaker form (a "contact" requirement is a working local form with validation and success state, not a `mailto:` link; a demo visual that could be interactive must be). If time is short, cut decoration (R2), never states, keyboard access, error handling, or depth.
- **R9 "Interaction floor"** — R1/R2 govern *motion and ornament*, never *interaction breadth*. Every surface — including zero-motion Operate tools — carries: feedback within 100ms for every action (toast, state swap, or inline result), an undo path for destructive actions, keyboard reachability for every control, and honest empty/loading/error states. A quiet tool that is rich to operate beats a beautiful tool that is inert. Undo restores prior state FULLY (sort position, page, focus). For AI surfaces, bind side-effecting actions (commit/undo/retry) to the context captured when the plan was made — never to whatever is currently selected. Eval evidence: canon builds lost points to unaided builds on toasts, undo, menus, toggles and demos — this ruling exists to flip that permanently.
- **R10 "Documentation economy"** — compliance is not the deliverable. Cap any in-file design-record comment at 6 lines. At the §8 gate: the **mechanical pass runs in full, always** (it is greps, not judgment); the 3 deep-verify boxes are ASSIGNED BY MODE — Entice/Play → signature quality + static-capture + at-rest dynamism; Operate → R9 breadth + hidden-state walk + hidden-collision; Consume → legibility/measure + content-motion pacing — never self-selected. Eval finding: "spot-check the rest" was read as permission to skip, and precisely the screenshot-invisible laws (touch, punctuation, tokens, init hardening, no-JS) were the ones skipped. Tokens not spent proving restraint are spent building depth (R8/R9) and the signature (§1).

## 4. Routing — which child to open for which problem

Open children on demand; depth lives there, not here. **Reading discipline** (R10): before building, read AT MOST the 3-5 children this brief actually routes to (plus `spectacle` when Entice/Play) — treat every other row as a menu to consult only when its specific problem appears. Reading is not progress; the deliverable is. Behavioral findings encoded here (transcript analysis of 24 builds):
- **Deliberate the concept BEFORE the child sweep.** Write the Differentiation Engine output — 3 candidate concepts, 2 rejected with reasons, derivation source in the domain's material world — immediately after reading this file, BEFORE opening any aesthetic-family child (§4.F). In evals, concepts committed after reading 8-16 family children converged onto the canon's own house phenotype, and the single most-divergent agent read only 3-4 children.
- **`domain-fit` is read before any §4.F family child, always** (it derives; family children decorate).
- **Two reading slots are reserved**: one color child (`oklch` or equivalent) and one interaction child (`ui-skills`/`web-interface-guidelines`) — a focused brief aspect (e.g. "fix the interactions") must not silently delete a different praised strength (eval: an interaction re-run shipped 26→0 oklch tokens with no conscious trade-off anywhere in its reasoning).
- **The design record names the mechanisms as build decisions**: visibility gate (`.is-hidden`), mutation-honesty plan, undo plan, init-hardening plan — restated in the last planning line before the first Write (eval: both 9.5/10 builds did this spontaneously; zero-decay window instead of a 14-minute-old read). In an Entice record, `spectacle` must appear (eval: an Entice build skipped the non-optional child and produced the wave's weakest output).

**A. Starting / strategy**
- New product or screen → this file §1, then `domain-fit` (MANDATORY: derive palette/type/density/motion/trust-furniture from the domain × mode × risk matrix — no house style applied to every domain), then `impeccable` (mode), `taste` (doctrine + AI-tell ban list)
- The build must impress (landing, portfolio, launch, Entice/Play) → `spectacle` FIRST (signature law, arrival choreography, scroll/cursor craft, balance laws) — non-optional for Entice/Play
- Design principles / north star → `principles`
- Design-system architecture → `design-systems-surf` (structure) + `ds-checklist` (gaps) + `tokens-generator` (token set)
- Calibrate "what great looks like" → `galleries`; literature → `design-books`
- Quality bar / how pros iterate → `interface-craft`, `ui-land`

**B. Foundations**
- Typography rules → `practical-typography`; 5-minute triage → `calvez-typography`; font selection → `inter-alternatives`; type+layout system → `krehel-skills`
- Color method → `oklch`; gradients → `gradientool`; gradient borders → `gradient-border`
- Layout patterns → `use-layouts`; separation/division → `kugiri`
- Radius → `corner-radii`; elevation → `shadowlab`
- Full token set generation → `tokens-generator`

**C. Primitives & components**
- Anatomy of any standard component → `component-gallery`; vocabulary/disambiguation (tooltip vs popover, toast vs alert) → `ui-wiki`; pattern doctrine → `interfaces-dev`
- Why a pattern works / its pitfalls → `ui-playbook`
- Before building or installing anything → `html-can-do-that` (native check) + `bencho` (build/copy/install ladder) + `shoogle` (find registry blocks)
- Specific primitives: command palette → `cmdk`; toasts → `sonner`; animated numbers → `number-flow`; text/label morphing → `torph` + `calligraph`; real-time charts → `liveline`; audio players → `audio-kit`; payment cards → `crd-ui`; generated avatars → `hashvatar`; live parameter tuning → `dialkit`; in-app feedback capture → `remediate`
- Complete states/a11y of primitives → `ui-skills`

**D. States & feedback**
- Loading/waiting (by duration) → `loading-dev`; AI thinking states → `thinking-orbs`
- Forms, validation, errors → `web-interface-guidelines` + `ui-playbook`

**E. Motion** (gate through R1 first)
- Doctrine → `animations-dev`, `emil-skills`, `family-values`; veto → `you-dont-need-animations`
- Connective-tissue motion (micro-hovers, rolling numbers, staggered lists, FLIP continuity, ambient breathing, symmetric exits) → `dynamism` (MANDATORY after the signature exists — no L5 islands in L1 seas)
- Easing/spring selection → `easing`; specific transitions (tab swap, modal, stagger, skeleton, shake, accordion) → `transitions`
- Morphing → `morphrig` (technique), `morphicons` (icon pack); SVG animation → `svg-guide`; image/scroll motion → `images-in-motion`
- Effect components (Entice/Play modes) → `fancy-components`, `magic-ui` — under R2 budget
- Real depth (product heroes, configurators, studio/Play signatures, data sculptures) → `3d-craft` (tiers, interaction contract, domain gates — 3D must be operable, never passive)

**F. Aesthetic families** (Step 3 destinations)
- Terminal/retro/brutalist → `dither-kit`, `dot-matrix`
- Organic/fluid → `fluid-functionalism`, `liquid-gooey`
- Glass/material (budgeted) → `liquid-glass`
- Warm editorial craft → `floguo`; minimal-with-warmth → `jakub-kr`; monochrome craft → `rauno`
- Micro-interaction-rich apps → `bencho`, `interior-dev`; full-screen reference examples → `devl`
- Delight catalog (celebrations, easter eggs, memory) → `design-spells`
- Showcasing the result (screenshots/video) → `ui-camera`

**G. AI-native interfaces**
- Components (thinking, streaming, approvals, tool chips) → `beautiful-ui`; AI-native CSS component patterns → `aicss`; prompt input anatomy → `anatomy-ai-input`; human→agent visual feedback → `agentation`
- How AI should design (workflow, taste filter, intent encoding) → `using-ai-as-de`, `how-i-design-with-ai`, `shedsgns-taste`, `scaling-intent-artistry`, `ai-design-engineer-twilson`, `become-ai-designer`, `rise-of-de`

**H. Senses** (budgeted like motion — opt-in, subtle, mute-able)
- UI sound → `cuelume` (synthesis), `soundcn` (sound library/data); haptics → `web-haptics`

**I. Accessibility & UX law**
- Rules → `web-interface-guidelines`; cognitive science → `laws-of-ux`; a11y practice → `ui-skills`; ten-principle audit → `rams`

**J. Polish & verification** (run before every delivery)
- Detail passes → `micro-craft` (MANDATORY last-5% formulas: optical corrections, state-layer math, dark-mode elevation, fluid type, finishing) then `details-feel-better` (feel checklist), `devouring-details` (Rauno's prototypes), `invisible-details` (the canonical essay)
- Restraint audit → `limit-details`; slop audit → `taste` ban list; full eval → `rams` + `impeccable` bounded verification
- Evidence → `abtest-design`

**K. The discipline / career** (when the work is about the role itself)
- Definition → `de-essay`, `de-101`, `front-of-front-end`; competency → `de-attributes`; mindset → `de-state-of-mind`, `family-values`; path → `becoming-de`, `design-for-engineers`; landscape → `design-engineers-map`, `de-jobs`, `de-tools`; workflow philosophy → `code-source-of-truth`; taste theory → `concept-of-taste`; restraint theory → `lessons-design`

## 5. Build order

1. **Intent** — mode, dials, aesthetic family, one-line design intent (§1). Write it down — as 3 candidate concepts with 2 banned and why (§4 reading discipline), BEFORE opening aesthetic-family children. Re-check the intent sentence against §1 Step 5 at step 9 (eval: attractor metaphors locked silently at minute 3 and were never revisited).
2. **Tokens** — color ramp (OKLCH), type scale, spacing, radius, elevation, motion values (`tokens-generator`, §2 numbers).
3. **Structure** — named layouts, real navigation, real information architecture; HTML-first semantics.
4. **Primitives with full states** — hover, focus-visible, active, disabled, loading, error, empty. Native check before every component (R3). Every JS-toggled visibility uses a class gate (`.is-hidden{display:none!important}`), never the `hidden` attribute on an element whose class sets `display`; every control class carries 44px OR an inset-expanded hit area (§2).
5. **Content pass** — real copy, real data shapes, smart punctuation, measure/line-height per §2.
6. **Motion pass** — gate each candidate through R1; spend the budget on continuity and causality only.
7. **Details pass** — `micro-craft` formula checklist (optical corrections, state layers, type finishing, ambient polish), then `details-feel-better`; one signature detail max (R2).
8. **Gates** — a11y (keyboard-only walk, contrast), performance (CLS < 0.1, no layout-thrashing animation), reduced-motion.
9. **Slop audit + verification** — §7 ban list, then `impeccable` bounded verification (the machine checks, not just your eyes). Init hardened per ban #15: each subsystem initializes in its own try/catch, `js`/feature classes appended only AFTER their subsystem's init succeeds, `getAttribute('data-x')` over `dataset.x` in engine-critical paths.
10. **Delivery checklist** — §8, all boxes. Re-read §7-§8 first, then run the mechanical pass with the literal commands; a grep-the-rule within seconds of the final Write is the pattern of every 9.5 eval build.

## 6. Stack posture (global)

- Framework-neutral by construction: patterns are expressed as mechanisms (HTML/CSS/JS or framework-agnostic markup). Tailwind, React, Svelte, vanilla — port, don't assume.
- Platform-first: check native capabilities (`html-can-do-that`) before any dependency; CSS is the design system's runtime (`code-source-of-truth` — code is the source of truth, mockups are sketches).
- When a source shows library-idiom code (all Tailwind-ish registries do), port the mechanism to tokens/CSS — every child skill already did this work; use their ports.

## 7. The anti-slop ban list — generated-work tells, always wrong

From `taste`'s AI-tell list, `shedsgns-taste` (slop = averaging), `scaling-intent-artistry` (probabilistic sameness):

1. Emoji as icons; hand-rolled SVG icon paths when an icon set exists; mixing icon styles/weights.
2. `alert()`/`confirm()`; dead buttons; interactive elements without cursor/hover/focus differentiation. **Upgrade rule**: every control either works locally (state change + undo where destructive) or is omitted — when local simulation is feasible, NEVER downgrade to `mailto:`/toast dead-ends (R8). Fictional external URLs and `#` anchors on primary CTAs count as dead buttons — wire them to a working local state (dialog, confirmation).
3. Purple-indigo gradient on white with Inter and rounded-2xl everything — the default generated look. If your dials say VARIANCE ≥3, this combination is banned — and so are its 2026 successors as DEFAULTS: green-on-cool-paper, amber-on-dark, royal-blue-on-light-gray (each converged 3/3 or appeared verbatim across independent eval runs). Derive from the domain instead (§1 Step 5).
4. Symmetric 3-card feature rows, icon-title-paragraph triplets, dashboard-with-4-stat-cards as the *default* layout. **Upgrade rule**: these shapes are allowed when non-default and deep (stat cards that drill down or update live; feature sections with asymmetric hierarchy and one expanded working demo) — banned only in their lazy form. This includes the **mid-page sag**: a bespoke, committed hero followed by a default card-grid middle is the documented pattern (strict visual jury: the one weakness shared by 3 of 5 builds — commitment must hold past the first screen).
5. Fake content: "Lorem", "John Doe", stock filler where real data shapes are knowable; fake thinking states on non-AI actions (R5).
6. Decorative gradients/borders/glass on elements that carry no identity burden (R2); glow on text; animated gradients behind body content.
7. Entrance animation on everything; stagger on static content lists; motion that can't be named as continuity or causality (R1).
8. Dumb quotes, hyphens-as-dashes, "..." as ellipsis char, title-case buttons in sentence-case products.
9. Density of ornament without density of information — detail spent where nothing earns it (`limit-details`).
10. Consistency errors: two grays for the same role, three radius values from different systems, mixed shadow directions, spacing off-grid.
11. "Good enough" first outputs shipped: the first generation is a draft; iterate at least once against §8 before delivery (`shedsgns-taste`).
12. **JS-gated visibility** — base-CSS `opacity:0`/`translate` on content that only an IntersectionObserver or JS class-add removes. Entrance animation must be CSS that completes to a visible state without JS (pre-baked final states, `animation` not transition-from-hidden, or the hidden state applied FROM JS only). A no-JS/print/crawler render must never be blank — this bug appeared in unaided outputs 4 times in one eval and once in a canon run.
13. **`[hidden]` vs class `display` collisions** — any CSS rule that sets `display:flex/grid` on an element defeats the `hidden` attribute (specificity + cascade), leaving phantom UI permanently visible ("0 selected" bars, dead buttons). Never rely on `hidden` for an element whose class sets `display`; use a `.is-hidden{display:none!important}` gate or compose states so the default is hidden.
15. **Init fragility** — one unguarded DOM/API call at boot (e.g. `dataset.x` named-property quirks in current engines) crashing the whole IIFE and killing every system registered after it: canvas engine, reveals, cart, nav. The `html.js` class must only be applied AFTER core init succeeds (or per-module), so any crash falls back to the complete no-JS render instead of a dead hybrid. Prefer `getAttribute('data-x')` over `dataset.x` in engine-critical paths; wrap each subsystem's init independently (one failing module never takes down the rest); every JS-rendered product stage ships a static fallback that renders regardless.
14. **The canon's own house tells** — cream-paper + warm-ink + single vermilion accent as a default palette, square black CTAs, mono micro-labels everywhere, the first hero metaphor you thought of, skeletons reused across runs (see §1 Step 5). Generated-work detection now includes "recognizably the same canon" — treat a recurring personal style exactly like AI-purple.

## 8. Delivery gate — floors AND peaks, every ship

**Positive gates (the peak — a build that passes every floor and fails these is still a fail):**
- [ ] **Photographable moment**: name it in one sentence. Would a design jury screenshot this page? If nothing claims that, increase commitment (scale, reactivity, choreography) — never effect count
- [ ] **Expressiveness floor met** for the mode (§1): Entice/Play builds carry a named signature + arrival choreography per `spectacle`; Operate builds carry interaction depth per R9 instead
- [ ] **Unrequested depth**: ≥2 pro interactions beyond the brief shipped (R8 pass) — the page does more than asked, generously
- [ ] **First 3 seconds**: arrival is choreographed (or deliberately instant and justified); the hero commits to a position instead of hedging; on Entice/Play the first paint is monumental (display scale or equivalent composition) and the first rendered frame is a complete final state (no live mutation before first interaction — static-capture law). **The hero must be legible in EVERY captured frame**: entrances move/scale/mask content that is already partly visible; above-fold text never starts at opacity 0 with a >150ms delay before first visibility (eval: two builds screenshot as near-empty heroes because their rise animations held text invisible for 300-400ms — data-complete is not the same as visibly-there)

**Mechanical pass (runs in FULL, every build — literal commands, run them, don't recall them; catches every systematic killer found in evals):**
First: RE-READ §7 and this section (30 lines) — in evals, zero agents re-opened the canon at gate time and every violation class traces to an 8-20-minute-old memory of it. Then run:
- [ ] Punctuation: `grep -nE "[A-Za-z]'[A-Za-z]" FILE` → 0 hits in copy (→ `’ ‘ “ ”`); no `---`/`--` in copy (— –). Regressed in the newest builds — run it LAST, after fatigue sets in.
- [ ] Tokens: defined-vs-used diff of `var(--…)` against the token block (eval: 2 undefined tokens silently killed a hero backdrop and a choreography).
- [ ] Visibility: `grep -n " hidden" FILE | grep -v is-hidden` → 0; every JS toggle uses `.is-hidden{display:none!important}`.
- [ ] Targets: `grep -nE "(min-)?height:\s*(2[0-9]|3[0-9]|4[0-3])px" FILE` — every hit is a control class that must carry an inset-expanded hit area or grow to 44px (§2).
- [ ] Init: `grep -n "dataset\." FILE` → 0 in engine paths; `js`/feature classes appended only after init success; each subsystem in its own try/catch (ban #15).
- [ ] At-rest: Entice/Consume — grep the mechanism you shipped (clock/ticker/drift/breathe class or function); Operate — R9 feedback on every action.
- [ ] Static fallbacks: every JS-rendered stage has content in the HTML.
- [ ] State truth for AT + no-JS paths: every `aria-expanded`/`aria-pressed` set in JS is reset/synced on close/change; form errors announce (`role="alert"` + `aria-invalid` + focus first bad field); the primary CTA path works without JS (native form/dialog, not a JS-only overlay); collapsible content (FAQ, panels) opens without JS (native `<details>` or visible default); no inert-but-focusable custom widgets left when JS is off (set `tabindex` from JS); contrast of smallest text INCLUDING disabled/future/decorated states (eval: 1.7-1.9:1 on future-day labels and filled-cell numerals).
- [ ] House tells: `grep -n "cubic-bezier(.22,1\|cubic-bezier(.19,1" FILE` → 0; no canon example sentence shipped as copy; no domain-attractor string (§1 Step 5) in the intent/copy; no fabricated-liveness counter or fake device claim un-labeled (§2).
**No narrated PASS**: a box is checked only with a cited line of command output — otherwise it is labeled UNVERIFIED. Every claim in the final summary ("no dead links") must itself be grep-backed (eval: an agent asserted "verified ✓" for checks that exist nowhere in its transcript, and another's "no dead links" was false).

**Floor gates:**
- [ ] Design intent sentence still true of the result; dials checked against it
- [ ] Keyboard-only walkthrough succeeds; focus-visible everywhere; Escape/focus-return on overlays; navigation reachable at EVERY breakpoint (no hidden-menuless small viewports)
- [ ] Contrast 4.5:1 body / 3:1 UI — computed on the SMALLEST text too (captions/legends are where builds cheat); touch targets ≥44px; text ≥16px body (floor justified if lower)
- [ ] All interactive states exist (hover/focus/active/disabled + contextual loading/error/empty); feedback ≤100ms on every action (R9)
- [ ] Reduced-motion honored; motion within §2 bands; no animation without R1 purpose; balance laws of `spectacle` if theatrical elements exist
- [ ] Dynamism floor met for the mode (`dynamism` ladder at-rest + peak; the 10 deadness patterns walked); any 3D passes the interaction contract (`3d-craft`: draggable + keyboard + RM hero pose)
- [ ] Real content in place; punctuation smart; tabular-nums on data; measure 45-75ch
- [ ] One signature effect maximum (R2) — entrances/decoration only; feedback states unmetered
- [ ] Loading states honest per wait-length (`loading-dev`); errors actionable near the point of failure
- [ ] Ban list (§7) walked item by item; detail audit run (`limit-details`)
- [ ] Verified in the real rendering engine, not assumed — screenshots or automated checks (`impeccable` bounded verification)
- [ ] Page fully readable with JS disabled (no JS-gated opacity on content); no `[hidden]`-vs-`display` phantom UI; every interactive state machine reaches and renders its hidden states
- [ ] Every `var(--…)` used is DEFINED (undefined custom properties fail silently — grep the token block against usage); interactive hero demos have a touch path (tap targets + fixed readout, not mouse-only)
- [ ] Init-fragility walk (ban #15): kill-scripts-JS-after-boot mental test — if any single init call threw, would the page still render complete? Each subsystem initializes independently; `html.js`/reveal-hiding applies only after init succeeds; no `dataset.x` in engine-critical paths; static fallbacks for JS-rendered stages
- [ ] Brief-requirement checklist (R8) enumerated, every item shipped, no capability downgraded
- [ ] §1 Step 5 anti-convergence walked: differs on ≥2 token-temperature axes, first concept banned, no cross-run skeleton reuse
- [ ] Dark mode (if shipped) derived by §2 method, checked at the same gate

Per R10: the mechanical pass always runs in full; the 3 deep-verify boxes are assigned by mode (always including one positive gate), never self-selected.

## 9. Maintaining the canon

- One link = one skill; folder name = `name` field; `_CONVENTIONS.md` is binding for any addition or edit.
- Children cross-reference by exact name; when you add a skill, add it to the relevant routing row in §4.
- Sources are re-verifiable: every child carries `source:`; if a claim can't be traced, it gets flagged or removed. Never invent.
