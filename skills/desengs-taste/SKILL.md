---
name: desengs-taste
description: Use when writing, editing, or reviewing frontend UI code so it reads authored, not AI-generated. Enforces the anti-slop doctrine: design read, three tuning dials, concrete craft rules, and the AI-tell ban list.
source: https://www.tasteskill.dev/ ; https://github.com/Leonxlnx/taste-skill
category: principle
---

# Taste (desengs) — the anti-slop frontend doctrine: read the brief, tune three dials, ship authored UI

Source: https://www.tasteskill.dev/ ; https://github.com/Leonxlnx/taste-skill - the open-source "Taste Skill" for AI coding agents, by Leon Lin and blueemi (MIT). Distills mainly the v2 `design-taste-frontend` skill, plus the v1, soft, minimalist, redesign, and output skills. Original rules target Tailwind; here they are ported to plain CSS with the mechanism preserved.

> Every rule is contextual. First read the brief, then apply what fits. This doctrine covers marketing pages AND tool UI; dense data views follow the same taste rules but favor restraint over spectacle.

## What it is / Why it exists

A rulebook that stops LLM-generated frontends from looking LLM-generated. Models emit recognizable defaults when nothing pushes against them (AI-purple gradients, centered hero over dark mesh, three equal feature cards, Inter on slate). The skill supplies the push: a reading step that infers what the surface should be, three dials that set how far from default to go, concrete craft rules for typography, color, spacing, depth, states, motion, content, and imagery, and a mechanical ban list of the tells that mark output as machine-made. It exists because "looks fine" generated UI quietly erodes trust; the goal is UI that reads as authored by a person with taste.

## The core ideas

### The doctrine

1. **Read the room before generating.** Most bad AI output comes from jumping to a default aesthetic instead of inferring page kind, audience, vibe, and constraints. State a one-line design read first.
2. **Anti-default discipline.** The LLM defaults (AI-purple gradients, centered hero over dark mesh, three equal feature cards, glassmorphism everywhere, infinite-loop animations, Inter + slate-900) must be reached past deliberately, not fallen into.
3. **The three dials.** Every design is tuned on three declared dials (below). Declare the values, then let them drive every decision.
4. **One design language per project.** One accent color, one gray family, one radius system, one font pairing, one theme. Consistency locks beat local prettiness.
5. **Honesty over borrowed skin.** Use real systems when the brief names one; when following an aesthetic, say so in comments. Never ship a component library in its default state.
6. **Motion must be motivated.** Every animation answers "what does this communicate?" (hierarchy, storytelling, feedback, state transition). If you cannot justify it in one sentence, delete it.
7. **Real over fake.** Real images, real logos, real data shapes, complete states. Div-based fake screenshots and hand-rolled icon paths are the number-one tells.
8. **Complete work only.** No placeholder comments, no skipped sections, no half-finished screens. A partial output is a broken output.

### The three dials

- `DESIGN_VARIANCE`: 1 symmetric/safe, 10 chaotic/experimental.
- `MOTION_INTENSITY`: 1 static, 10 cinematic.
- `VISUAL_DENSITY`: 1 airy, 10 packed.

Baselines by surface type (examples, not constants): a marketing landing page runs about 8/6/4; a working tool UI is honest around 4-5 / 2-4 / 5-6, because familiarity and density are features in a tool. Derive the values from the brief, declare them, justify them in one line, then let them settle every disputed decision.

### The design read

Before any code, declare: "Reading this as: <surface> for <audience>, with a <vibe> language, leaning toward <aesthetic family>."

Signals to read: page kind (tool, landing, portfolio), vibe words the user used, references, audience, existing brand assets (for redesigns these are starting material, not optional), and quiet constraints (accessibility, trust-first) which override aesthetic preference. If genuinely ambiguous, ask exactly one question; otherwise infer and proceed.

### Concrete rules

#### Typography

- Display headlines: large, tight, confident. In CSS:

```css
.display {
  font-size: clamp(2.25rem, 5vw, 3.75rem); /* text-4xl md:text-6xl equivalent */
  letter-spacing: -0.03em;                 /* tracking-tighter */
  line-height: 1.05;
  font-weight: 600;                        /* hierarchy via weight + color, not raw scale */
}
.body-copy { max-width: 65ch; line-height: 1.6; }
```

- **Inter is not the default.** Pick a sans with character: Geist, Satoshi, Cabinet Grotesk, Outfit, or a brand-appropriate choice. Inter only if the brief explicitly wants neutral/Linear feel.
- **Serif discipline:** serif is NOT the default for "creative = serif" reasons. Only when the brand names one or the aesthetic is genuinely editorial/luxury/heritage - and never Fraunces or Instrument Serif (the two LLM-favorite display serifs).
- **Emphasis rule:** to emphasize a word in a headline, use italic or bold of the SAME font. Never inject a foreign serif word into a sans headline.
- **Italic descender clearance:** italic display words containing `y g j p q` clip at `line-height: 1`. Use `line-height: 1.1` minimum and reserve space below:

```css
.display em { font-style: italic; line-height: 1.1; padding-bottom: 0.125rem; }
```

- Use Medium (500) and SemiBold (600), not just 400/700. Use `text-wrap: balance` on headlines to kill orphans. Negative tracking on large sizes, positive tracking on small caps labels. Numbers in data: monospace or `font-variant-numeric: tabular-nums`.

#### Color

- **Max 1 accent color, saturation below 80%.** Neutral base (zinc/slate/stone or warm near-black) plus one high-contrast accent (emerald, electric blue, deep rose, burnt orange).
- **The LILA rule:** the AI-purple/indigo-glow aesthetic is banned as a default. No purple button glows, no neon gradients, no decorative gradient blobs. (If a brand is genuinely purple, keep it and execute with restraint.)
- **Color Consistency Lock:** the accent chosen for a page is used identically everywhere. A warm-gray site does not get a blue CTA in section 7.
- One gray family per project: never mix warm and cool grays.
- **No pure `#000000`, no pure `#ffffff`.** Use off-black (`#0f1014`) and off-white; pure values kill depth.

```css
:root {
  --bg: #101014; --surface: #17171c; --surface-2: #1d1d23;
  --text: #f2f2f0; --text-muted: #9a9aa3; /* must pass 4.5:1 on --bg */
  --accent: #34d399;                       /* ONE accent, locked */
  --accent-ink: #052e1c;                   /* readable text on accent */
}
```

- **Premium-craft palette ban:** for artisan/luxury/wellness briefs, the default "warm cream + brass/clay/oxblood + espresso" palette is banned (it erases the brand). Rotate instead: cold luxury (silver/chrome/smoke), forest + bone + amber, black and tan, cobalt + cream, monochrome + one saturated pop.
- **Page Theme Lock:** one theme per page. Sections do not flip light/dark mid-scroll. Tints within the same family are fine; inversions are not.
- **Dark mode:** design both modes from the start (or commit to one deliberately for a tool). Hierarchy that works in light must work in dark; brand color stays recognizable; WCAG AA minimum (AAA target for body).

#### Spacing & Layout

- Contain the page: `max-width: 1200-1400px; margin-inline: auto` - content never stretches edge to edge.
- Full-height sections use `min-height: 100dvh`, never `100vh` (iOS Safari address-bar jump).
- **Grid over flex-math:** never `width: calc(33.33% - 1rem)`. Use CSS Grid.

```css
.features { display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 24px; }
@media (max-width: 768px) { .features { grid-template-columns: 1fr; } }
```

- **Anti-center bias:** when VARIANCE > 4, centered heroes are avoided. Force split-screen, left text / right asset, or asymmetric whitespace. (Centered is OK for manifesto/launch pages.)
- **Hero discipline:** headline max 2 lines desktop, subtext max 20 words, CTA visible without scroll, top padding capped (~6rem). Max 4 text elements in the hero: eyebrow OR brand strip, headline, subtext, CTAs. No tagline below CTAs, no trust strip, no feature bullets inside the hero - those live in sections below.
- **Navigation:** one line at desktop, 64-80px tall.
- **Section-Layout-Repetition Ban:** a layout family (3-column cards, full-width quote, split text/image) appears at most once per page. 8 sections need at least 4 different families.
- **Zigzag cap:** max 2 consecutive sections with the image+text split pattern; break with a full-width, stack, bento, or different family.
- **Eyebrow restraint (the most-violated rule):** max 1 uppercase wide-tracking micro-label per 3 sections. Count them mechanically: if `uppercase + letter-spacing` labels exceed `ceil(sections / 3)`, fail. Mostly, just drop them - the headline is enough.
- **Split-header ban:** no "big headline left, small explainer paragraph floating top-right". Stack headline then body (max 65ch), unless the right column carries a real visual.
- **Bento rules:** exactly as many cells as content items (no empty cells); rhythm not repetition; at least 2-3 cells have real visual variation (image, tinted background, pattern) - never all white-on-white text cards.
- Spacing is generous but optical: symmetric padding is suspicious; bottom padding often needs a bit more. Align shared elements (titles, prices, buttons) across side-by-side cards. Buttons bottom-aligned in card groups.
- Declare the mobile collapse per component: high-variance layouts fall back to a strict single column below 768px.

#### Depth & Materiality

- **Anti-card overuse:** use cards ONLY when elevation communicates real hierarchy. Otherwise group with `border-top`, hairlines, or negative space. A page where everything is a bordered panel is visual noise.
- **Tinted shadows only:** no pure-black drop shadows on light backgrounds; the shadow carries the background hue.

```css
/* on a dark blue-gray base */
.elevated { box-shadow: 0 16px 40px rgba(8, 10, 20, 0.45); }
```

- **Shape Consistency Lock:** one radius system per page - all-sharp (0), all-soft (12-16px), or pill-for-interactive - possibly with a documented mixed rule ("inputs 8px, panels 16px, chips pill"). Round buttons in a square layout is broken design.
- **Double-bezel for premium surfaces:** a container never sits flat; it sits in a machined shell (outer wrapper with hairline border + small padding + large radius; inner core with its own surface, inner highlight, slightly smaller concentric radius):

```css
.bezel { background: rgb(255 255 255 / 0.04); border: 1px solid rgb(255 255 255 / 0.08);
         border-radius: 20px; padding: 6px; }
.bezel-core { background: var(--surface); border-radius: 14px;
              box-shadow: inset 0 1px 0 rgb(255 255 255 / 0.08); }
```

- Glassmorphism only when the vibe calls for it (never dashboards/trust-first), and always beyond `backdrop-filter: blur`: add a 1px inner border and subtle inset highlight; provide a solid fallback under `prefers-reduced-transparency`.
- Flat sterile sections get subtle depth: a low-opacity radial light, grain on a `position: fixed; pointer-events: none` layer, or a real image - never decoration lines drawn just to "feel designed".

#### States & Interaction

LLMs generate the static success state only. Always implement full cycles:

- **Loading:** skeleton loaders matching the final layout shape; never a generic circular spinner.
- **Empty states:** composed and instructive ("no assets yet - generate your first set"), never blank.
- **Error states:** clear, inline (forms), contextual toasts only for transient events. Never `alert()`, no "Oops!".
- **Tactile feedback:** on `:active`, a physical push:

```css
button { transition: background-color 0.2s, transform 0.15s cubic-bezier(0.16, 1, 0.3, 1); }
button:active:not(:disabled) { transform: translateY(1px) scale(0.98); }
:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
```

- **Button Contrast Check:** every CTA label readable on its background, WCAG AA (4.5:1). White-on-white, transparent-on-photo without scrim: banned.
- **CTA wrap ban:** button text fits on one line at desktop. Shorten the label (1-3 words) or widen the button.
- **No duplicate CTA intent:** one label per intent per page. "Get in touch" + "Contact us" + "Let's talk" on the same page = fail; pick one.
- **Forms:** label ABOVE input, helper text in markup, error BELOW input, `gap: 8px` blocks. Placeholder is never the label. Inputs, placeholders, focus rings, helper and error text all pass AA contrast on their section background.

#### Motion

- Animate ONLY `transform` and `opacity`. Never `top/left/width/height`. `will-change: transform` sparingly.
- `window.addEventListener("scroll")` is a hard ban. Use IntersectionObserver, CSS scroll-driven animations (`animation-timeline: view()`), or a motion library's scroll utilities. Never rAF loops writing component state; never `useState` (or equivalent) for continuous values (pointer, scroll, magnetic hover).
- Never mix animation systems (GSAP vs. a component motion lib) in the same tree.
- Spring/curved easing, no linear: `cubic-bezier(0.16, 1, 0.3, 1)` for CSS; `type: "spring", stiffness: 100, damping: 20` in Motion.
- Stagger reveals with a cascade, never mount everything at once:

```css
@media (prefers-reduced-motion: no-preference) {
  .reveal { animation: rise 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
            animation-delay: calc(var(--index) * 80ms); }
  @keyframes rise { from { opacity: 0; transform: translateY(12px); } }
}
```

- **Reduced motion is non-negotiable:** everything above intensity 3 collapses to static under `prefers-reduced-motion`.
- "Motion claimed = motion shown": a page declaring intensity > 4 must actually move (entry transitions, hover physics); otherwise drop the dial and ship clean static.
- Marquee: at most ONE per page. Perpetual loops (pulse, float, shimmer): only where motion communicates (live status, feeds) - not every card.
- Grain/noise/blur: fixed, `pointer-events: none` layers only; never on scrolling containers (mobile FPS death).

#### Content Discipline

- Default per section: headline (max 8 words) + sub-copy (max 25 words) + one visual or CTA. Cut ruthlessly; landing pages live on first impression.
- **Long lists need a different component, not a longer list:** > 5 items -> 2-column grouped split, card grid, tabs, scroll-snap pills, or a "top 5 + view all" link. A 10-row table with a hairline under every row is the laziest layout; group into clusters or use spec cards.
- Quotes: max 3 lines, attribution with name + role, real typographic quotes or none.
- **No fake-precise numbers** (`92%`, `4.1x`, `5.8 mm`) unless real or explicitly marked as mock.
- **Copy self-audit before shipping:** re-read every visible string; rewrite anything grammatically broken, with unclear referents, or that "sounds like an LLM trying to sound thoughtful". Plain functional copy beats cute copy.
- One copy register per page.

#### Imagery & Icons

- Real images, even for minimalist pages (a pure-text page is incomplete, not minimal). Hero needs a real visual: text + gradient blob is a placeholder.
- Icon libraries (Phosphor, Radix, Tabler; one family per project, standardized stroke width). **Never hand-roll SVG icon paths**, no emojis in code or UI. Lucide only on explicit request (it is the default AI choice - avoid).
- **Div-based fake screenshots are banned** (fake terminal, fake dashboard from styled divs = the #1 tell). Use a real component preview, a real screenshot, or skip it.
- Logo walls: real SVG logos (Simple Icons) or a designed SVG monogram for fictional brands - never plain styled text; and logo only, no category labels under each logo.
- No broken stock links; use seeded placeholder photo services with descriptive seeds.

### The AI-tell ban list

**Visual/CSS:** neon or outer glows; pure `#000`/`#fff`; oversaturated accents; gradient text on large headers; custom mouse cursors; generic 1px gray borders everywhere; harsh default `box-shadow`; uniform `linear` 45-degree gradients.

**Typography:** Inter as default; oversized screaming H1s; serif-as-default (and specifically Fraunces / Instrument Serif); Title Case On Every Header (use sentence case); all-caps subheaders everywhere.

**Layout:** three equal feature cards in a row (the single most generic AI layout); everything centered and symmetrical; `100vh` heroes; flex calc-math grids; no max-width container; equal-height cards forced by flexbox; one dark section dropped mid-light-page; sidebar-always dashboards; missing whitespace.

**Content ("Jane Doe" effect):** John Doe / Sarah Chan; "Acme", "Nexus", "SmartFlow", "Cloudly"; fake-perfect numbers (`99.99%`, `50%`, `1234567`); egg-avatar icons; filler verbs ("Elevate", "Seamless", "Unleash", "Next-Gen", "Revolutionize", "Delve"); Lorem Ipsum; exclamation marks in success messages; identical blog dates; rocket = launch, shield = security cliche icons.

**Production-test tells (banned by default):** version labels in heroes (`V0.6`, `BETA`, `EARLY ACCESS`); section-number eyebrows (`00 / INDEX`, `001 - Capabilities`); `01 / 4` pagination stamps on images; middle-dot separator spam (max 1 per metadata line); decorative colored status dots on nav items and list rows (only for real semantic state, sparingly); `<br>`-broken italicized headlines; vertical rotated text; decorative crosshair/grid hairlines; fake version footers (`v1.4.2 - last sync 4s ago`); "Quietly trusted by"; poetic labels ("Field notes", "On our desks", "Loose plates"); weather/locale/time strips; micro-meta sentences under eyebrows; generic step labels ("Stage 1 / Stage 2" - use the verb: "Install", "Configure", "Ship"); pills/labels overlaid on photos; fake photo-credit captions; scoring bars with filled background tracks; scroll cues ("Scroll to explore"); decoration text strips at hero bottom (`BRAND. MOTION. SPATIAL.`); tiny explainer paragraphs floating top-right in section headers.

**The em-dash ban (non-negotiable, the #1 tell):** em-dashes and en-dashes used as separators are COMPLETELY banned in all visible output: headlines, labels, body copy, quotes, attributions, captions, buttons, alt text - in every language. Restructure with a period, comma, colon, or parentheses. Ranges use a plain hyphen (`2024-2026`). The only permitted dashes: hyphen `-` and minus in math. Zero tolerance.

**Code tells:** import hallucinations (never assume a library exists - check the manifest/`package.json` first); arbitrary z-index (`9999`) instead of a documented scale; div soup instead of semantic HTML; hardcoded pixel widths; commented-out dead code; missing alt text; missing focus states.

## When to use / When NOT to use

Use when:

- Building or restyling any screen, page, panel, or component for the web (marketing surfaces and tool UI alike).
- Redesigning existing UI: run the redesign audit below first, then apply the modernisation levers.
- Reviewing generated frontend code before it ships: run the Pre-Flight Check.

NOT for: choosing product strategy, backend code, or API design. Also not a decoration license: when the brief is a quiet data tool, the dials go low and the same rules pull toward restraint, not spectacle.

## How to apply

1. Declare the design read (surface, audience, vibe, aesthetic family) in one line before any code.
2. Declare the three dials with a one-line justification; from then on they settle every disputed decision.
3. Lock the design language as tokens before building components: one accent, one gray family, one radius scale, one font pairing, one theme, one documented z-index scale.
4. Build sections against the concrete rules above, varying layout families per the anti-repetition bans.
5. Implement the full state cycle (loading, empty, error, success) with tactile feedback and AA contrast on every control.
6. Add only motivated motion, on transform/opacity, staggered, behind `prefers-reduced-motion` guards.
7. Audit content and imagery: real assets, real copy, no fake-precise numbers, none of the AI-tell vocabulary.
8. Run the Pre-Flight Check. If any box fails, the work is not done: fix it, do not ship it.

**Pre-Flight Check (run before shipping any UI)**

- [ ] Design read declared; dials explicit and justified.
- [ ] Zero em-dashes / en-dash separators anywhere visible.
- [ ] One accent, locked everywhere; one gray family; saturation < 80%; no pure black/white.
- [ ] One radius system; one icon family; one font pairing; one theme.
- [ ] Hero fits viewport (headline max 2 lines, subtext max 20 words, CTA visible, top padding capped, max 4 text elements).
- [ ] Eyebrow count <= ceil(sections / 3). No split-headers, no zigzag runs of 3+, no repeated layout families.
- [ ] Every CTA: AA contrast, one line, one label per intent.
- [ ] Loading, empty, and error states present; `:active` tactile feedback; focus-visible rings.
- [ ] Motion motivated, transform/opacity only, no scroll listeners, `prefers-reduced-motion` honored.
- [ ] No AI tells from the ban list (scan the list explicitly).
- [ ] Real images (no fake div screenshots); no hand-rolled icons; copy self-audit done.
- [ ] Mobile collapse explicit below 768px; `min-height: 100dvh`; grid over calc-math.

**Redesign audit (when restyling an existing stylesheet), in priority order:**

1. **Swap the font.** Self-host a characterful sans via `@font-face` + `font-display: swap`; add a monospace partner for IDs, sizes, durations, and all numbers (`tabular-nums`). Drop a default neutral sans unless the brief demands one.
2. **Recalibrate color.** Replace indigo/AI-purple-adjacent accents with one desaturated high-contrast accent on the existing base; make amber/emerald/red strictly semantic (warning/success/error); kill gradient logo marks (solid accent or typographic mark); lock one accent across every screen.
3. **Shape Consistency Lock.** Define radius tokens (e.g. `--radius-sm: 8px` inputs/buttons, `--radius-md: 12px` panels, pill only for status chips) and replace every hardcoded radius.
4. **Build a real type scale.** If every heading sits within a few pixels of body size, add clamp-based display sizes with negative tracking, weight hierarchy (500/600/700), `text-wrap: balance`, body capped at 65ch / 1.6. Hierarchy via weight + color, not screaming size.
5. **De-card the UI.** Keep panels where elevation is functional (forms, results); elsewhere group with hairlines (`border-top: 1px solid var(--border)`), spacing, and separators. Delete panel-in-panel nesting in favor of one bezel level.
6. **Vary the grids.** Break `repeat(3, 1fr)` card rows into asymmetric grids (`2fr 1fr 1fr`, `1.5fr 1fr`); cap zigzag runs; never two identical layout families on adjacent screens.
7. **Complete the state cycle.** `:hover` background shifts on all buttons/cards, `:active { transform: translateY(1px) scale(0.98) }`, visible `:focus-visible` rings, skeleton loaders shaped like the real rows, a composed empty state for every list, inline field errors instead of color-only.
8. **Add a motivated motion layer.** 150-250ms `cubic-bezier(0.16, 1, 0.3, 1)` transitions on transform/opacity, staggered card entry via the `--index` cascade, a "breathing" status dot only on genuinely live states - all inside `@media (prefers-reduced-motion: no-preference)`. No scroll listeners, no decorative loops.
9. **Ration the uppercase labels.** `uppercase + letter-spacing` eyebrows: max 1 per 3 sections; prefer sentence-case labels. Status chips may stay pills (semantic state) but without uppercase tracking spam.
10. **Contrast audit.** Verify muted text on every surface it appears on, chip text on chip fills, and button labels all pass WCAG AA (4.5:1); replace pure `#000` media backdrops with near-black (`#0a0a0c`).
11. **Copy pass.** Apply the em-dash ban and the copy self-audit to every visible string, in whatever language the UI uses: concrete verb labels for actions (not "Stage 1: ..."), real status text, no fake-precise specs in metadata.
12. **Keep the theme locked.** Commit to one theme per surface, document the z-index scale (topbar, modal, toast, grain), and make the audit the reference for every new screen.

## AI-slop warning

How AI typically misapplies this doctrine:

- **Rule maximalism.** Applying every rule at full strictness regardless of context. The rules are contextual and dial-driven; a quiet internal tool at variance 3 must not get landing-page spectacle rules.
- **Over-correction into new clichés.** Fighting defaults with aggressive asymmetry everywhere, oversized tight type on every screen, or forced eccentric layouts produces the next recognizable AI look.
- **Ceremonial compliance.** Declaring the design read and dial values but never letting them change a decision. If the declared dials do not alter output, the declaration is slop.
- **Copying the example dial values** (8/6/4, or the tool baseline) as constants instead of deriving values from the brief.
- **Treating the ban list as the whole skill.** It is the floor. The design read plus the consistency locks are what make output read as authored; negation alone produces bland, not tasteful.

## Relations

- **desengs-concept-of-taste**: the theory of what taste is and why authored beats generated; this skill is the operational rulebook, that one is the why behind it.
- **desengs-shedsgns-taste**: a practitioner's account of taste built by shipping real products; complements this ban list with portfolio-level judgment on when rules bend.
- **desengs-galleries**: reference galleries for browsing real aesthetics; use them to pick the "aesthetic family" named in the design read instead of defaulting to the banned looks.
