---
name: desengs-ui-land
description: Use when polishing web UI and deciding where delight, animation, and detail belong. Distills ui.land's interview canon — delight is speed, frequency taxes animation, every interface has an infinite polish inventory.
source: https://ui.land/
category: reference
---

# ui.land (desengs) — the design-engineer interview canon: delight is speed, detail is the product

Source: https://ui.land/ — "The Digital Library for Designers and Engineers." Made by Emil Kowalski (design engineer, later of animations.dev and Sonner). Six long-form interviews (Nanda, SJ Zhang, Sam Selikoff, Brotzky, Paco Coursey, Rauno Freiberg) plus a curated 33-item resources page (filters: reading / people / other / brand). The interviewees are the practitioners who defined interface polish at Vercel and Linear. No license stated; all quotes below are from the interviews, attributed.

## What it is / Why it exists

A tiny Next.js site whose value is not the design of the site but the doctrine that repeats across six independent practitioners of the same craft. ui.land exists because this cohort's knowledge lives in shipped software and scattered tweets, not essays: how polish is actually budgeted, why animation is a tax, what "delight" means measurably. Treat it as a consensus document: when five of six interviewees converge on a rule unprompted, that rule is the canon. The converged rules:

1. **Delight = speed.** Paco Coursey: "What we call a delightful user experience is just delivering a faster path to user goals" and "Poor design manifests as slowness." He dislikes slow software more than ugly software.
2. **Animation is taxed by frequency.** Nanda's pet peeve is "too many animations," quoting Rauno's interaction-design essay: for command menus "it's tempting to throw an opacity and scale fade on the overlay" — but at hundreds of uses per day that fade becomes cognitive burden. Nanda says only two companies do animation "really well": Apple and Family.
3. **Every interface has infinite polish headroom.** Paco: "Every single interface has infinite opportunity for polish and delight."
4. **Details exist only in implementation.** Rauno: static vectors miss nuances that appear when built; he prototypes "very close to production feel" within days and shares explorations immediately as tiny videos/demos.
5. **The best interface is not there.** Sam Selikoff: "The best interface is one that's not there because the desired outcome has already been anticipated" (his examples: a watch auto-detecting swim laps; SMS one-time codes autosuggested into the keyboard).

## The core ideas

### 1. The frequency budget for entrance motion

The site's most actionable and least-followed rule. Classify every surface by uses per day, then budget:

| Surface | Uses/day | Entrance animation |
|---|---|---|
| Onboarding, first-run, paywalls | ~1 | up to 160–200ms, fade+scale acceptable |
| Settings, dashboards, detail pages | 1–10 | ≤ 100ms, transform/opacity only |
| Command menus, quick switchers, toasts | 100+ | none or ≤ 60ms |

The mechanism, not the library:

```css
.cmdk[data-freq="high"]  { animation: none; }
.dialog[data-freq="rare"]{
  animation: enter 180ms cubic-bezier(0.22, 1, 0.36, 1);
}
@keyframes enter { from { opacity: 0; transform: scale(0.98) translateY(4px); } }
@media (prefers-reduced-motion: reduce) {
  [data-freq] { animation: none !important; }
}
```

Frequency is the one variable AI most often ignores: it animates the command palette like a hero section.

### 2. Paco's polish inventory (verbatim scope, 16 items)

When a UI "feels done," run this list — it is the site's own taxonomy of remaining work: animate icons; brand the scrollbar; polish the `:active` state; load a single typeface glyph to render the world's best ampersand; make it fast; make it accessible; add keyboard shortcuts and tooltips; animate the transition between two open tooltips; manually measure text to avoid line-wrapping widows; design favicons reflecting app state; convert internal URLs to rich previews; render a custom `<input />` caret animated better than any browser's; build a dedicated print stylesheet; build a dedicated mobile page; dynamically generate video thumbnails for a custom video player; optimize re-renders.

Do not ship all 16 at once. Pick the 2–3 with the highest uses-per-day multiplier; a custom caret on a search field beats a custom video player on a page nobody revisits. Two of the sixteen deserve emphasis because they are cheap and almost always skipped: `:active` state feedback (scale 0.97–0.98, 80–100ms) and widows (balance the last two lines of any heading or lede).

Single-glyph subsetting, the ampersand trick in mechanism form:

```css
@font-face {
  font-family: "Serif";
  src: url("/fonts/serif-amp.woff2"); /* subset containing only U+0026 */
  unicode-range: U+0026;
  font-display: swap;
}
h1 { font-family: "Serif", var(--sans); } /* ampersand only renders in the serif */
```

### 3. Basics beat decoration — the measured fundamentals

Brotzky's pet peeve is messing up alignment and typography: "So much of a website is text so if you're able to pick a font and place copy properly, you've already won." Sam Selikoff names the three fundamentals he was taught: softer text and background colors rather than pure black and white; typographic relationships between line height, letter spacing, and font size; effective white space. ui.land's own markup encodes these as exact numbers:

- **Optical tracking scale** — tracking tightens as size grows; the site's measured stops: 13px → -0.0032em, 14px → -0.0062em, 16px → -0.0110em, 48px → -0.0223em. Interpolate between stops; never loosen tracking below 14px; define the scale once as variables, never as one-off values.
- **Line-height compresses with size**: 1.55 at 14px body, 1.3 at 13px meta, 1.0 at 48px display.
- **Semantic grays on a 12-step ramp**: gray-9 for role labels/meta, gray-11 for body copy, gray-12 for headings and links — never pure `#000`/`#fff`, and the step gap (9 vs 11 vs 12) is what creates hierarchy without weight changes.

```css
:root {
  --track-13: -0.0032em; --track-14: -0.0062em;
  --track-16: -0.0110em; --track-48: -0.0223em;
}
.meta    { font-size: 13px; letter-spacing: var(--track-13); line-height: 1.3;
           color: var(--gray-9); }
.body    { font-size: 14px; letter-spacing: var(--track-14); line-height: 1.55;
           color: var(--gray-11); }
.heading { font-size: 16px; letter-spacing: var(--track-16); line-height: 1;
           color: var(--gray-12); font-weight: 600; }
```

### 4. Anticipate the outcome (design for zero interactions)

Selikoff's rule converts "delight" into an inference problem: for every user goal, list what the system already knows that would remove a step. Autofill the one-time code from the SMS just received; pre-select the last-used option; open the dialog the click implies instead of an intermediate page. The measure of success is interactions removed, not feedback added.

### 5. SJ Zhang's quality bar — an ordered gate, not a vibe

Compound ships against three questions in strict order: (1) could it go wrong and erode client trust; (2) shipped today, is it a net better experience than yesterday; (3) are we proud to tell people about it. Trust (correctness, latency, data safety) vetoes polish. "Net better than yesterday" beats "perfect someday" — ship the 60% improvement. His second rule: "fancy design will take longer engineering time" is a false trade-off; design the UX and the rough engineering timeline together, and longer thinking makes implementation faster.

### 6. How this cohort actually works (process canon)

- **Build in the final medium.** Rauno: details "come to life through actual implementation"; his design files are throwaway ("asdf"), prototypes approach production feel within days, and code quality is deliberately deferred. Nuances do not exist in static vectors.
- **Share tiny demos immediately.** Rauno ships explorations ASAP as short screen recordings to gauge interest and keep momentum — validation before investment.
- **Replay interactions.** Brotzky: great design engineers have "taste and obsession" and spend their time "playing, and replaying interactions just to understand how each piece behaves at each moment." Selikoff screen-records reference animations and matches them frame by frame.
- **Copy to learn, then build your own.** Paco: "Copy and re-implement admired work until you can proudly create your own," and "You'll never understand the challenges, tricks, and edge-cases of a note-taking app until you build a note-taking app." Brotzky learned by recreating favorite websites and reading MDN for 12 hours a day. Rauno's advice compressed to two words: "Build, build, build."
- **Taste is trained by dissection, off-screen.** Nanda: "Immerse yourself in things that people say are 'good design' and then dissect why that might be the case." All six cite non-web sources — book covers, furniture, architecture, fashion, type foundries — and Nanda warns that following web trends makes your site blend into the crowd.

### 7. The role this canon defines: the design engineer

The interviews double as a job description. Rauno describes the Vercel design-engineering team's two functions: give Design the engineering firepower to lead and ship projects end-to-end, and dip into projects needing high-impact polish (complex interactions, animations, comboboxes). Brotzky's version: a bridge that prevents details being "lost in translation" between design and implementation — consolidating messenger and recipient is "where the magic happens." For an AI building UI this maps to an ownership rule: someone (or some process) must own the seam between static design and shipped behavior, and that owner polishes by replaying, not by reviewing screenshots. SJ adds the speed argument: the polishing role is not a luxury step after engineering — designing the interaction and its implementation timeline together is what makes the polished version shippable at all, the way one assembles a decent outfit daily rather than pursuing the perfect one.

### 8. The site's own craft (steal these mechanisms)

- **No-flash theme resolution before paint** — inline, synchronous, in `<head>`:

```html
<script>
(function () {
  var d = document.documentElement, c = d.classList;
  var t = localStorage.getItem('theme');
  var dark = t === 'dark' || ((t === null || t === 'system') &&
            matchMedia('(prefers-color-scheme: dark)').matches);
  c.add(dark ? 'dark' : 'light');
  d.style.colorScheme = dark ? 'dark' : 'light'; /* native controls follow */
})();
</script>
```

- **Whole-card links**: each interview card is one `<a>` wrapping role, name, bio, and CTA — one hit target, no nested-link a11y traps.
- **Takeaways block**: every interview ends with 2–3 distilled decisions; the site itself practices compression.

## When to use / When NOT to use

Use when: building or reviewing any product UI where "make it feel better" is the brief; deciding animation budgets; running a final pre-ship polish pass; defining what "design engineer" output should look like; needing defensible reasons to reject decoration.

Not for: content sites where reading is the only interaction (most of the polish inventory is dead weight); brand-experience sites whose purpose is spectacle — frequency rules assume repeated use; replacing accessibility or performance work — in this canon those are items 5 and 6 of the inventory itself, not polish.

## How to apply

1. Classify each surface by expected uses/day (rare / daily / constant) and assign its entrance-motion budget before writing any animation (rare ≤ 180ms, daily ≤ 100ms, constant ≤ 60ms or none).
2. Run the speed audit: any "delightful" effect that adds perceived latency to goal completion is deleted, not tuned.
3. Zero-interaction pass: for each primary goal, list one thing the system can infer (autofill, preselection, sensible defaults) and remove a step.
4. Lock the basics first: softer text/background colors, the tracking scale, line-height pairs, 8px alignment, white space. Only then open Paco's inventory.
5. Pick at most 3 inventory items per release, ranked by uses-per-day of the surface they touch.
6. Prototype interactions in code at near-production fidelity; do not debate nuances from static mockups.
7. Record and replay: screen-capture the reference interaction and match it frame by frame; replay your own interaction 10+ times before shipping.
8. Gate every release through SJ's ordered bar: trust risk → net-better-than-yesterday → pride.
9. Choose dropdowns and custom select menus last (Selikoff, after Luke W: "dropdowns should be the UI of last resort").
10. Source references from outside the web (print, packaging, architecture, fashion) and write down why each works — that dissected "why" is taste compounding.

## AI-slop warning

AI misreads this canon in four predictable ways. It hears "delight" and adds entrance animations everywhere, including the high-frequency surfaces the canon explicitly exempts. It adopts the Vercel/Linear monochrome-gray look as a skin while shipping slow interactions — the look is the output of the speed discipline, not a theme. It executes the 16-item polish inventory as a blanket (branded scrollbar + custom caret + icon animations + tooltip transitions all at once) instead of ranking by frequency, producing noise that masks hierarchy. And it "replays" nothing: it ships animations it has never watched end-to-end, so timing curves, interrupted states, and reduced-motion paths are unverified. Nanda's warning cuts both ways: only a handful of companies animate really well — assume your first animation pass is over-animated and cut.

## Relations

- **desengs-emil-skills** — the site's author's own technique collection; the interviews are the doctrine, those skills are the applied layer.
- **desengs-rauno** — full portfolio deep-dive of the rauno-freiberg interviewee; where the "details emerge in implementation" practice is shown artifact by artifact.
- **desengs-taste** — operationalizes Nanda's "immerse and dissect" method for building taste; complements this canon's sourcing rules.
- **desengs-you-dont-need-animations** — the restraint essay that the frequency-budget rule here quantifies; read together before adding any motion.
- **desengs-lessons-design** — broader reference canon that situates these practitioner rules inside classic design lessons; use for vocabulary, this skill for numbers.
