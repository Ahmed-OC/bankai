---
name: floguo
description: Use when building a personal site or portfolio that should feel hand-made — warm-tinted tokens, restrained motion, a dictionary voice, and content engineered as data.
source: https://www.floguo.com/; https://www.floguo.com/notes/design-engineering
category: portfolio
---

# floguo — a design engineer's site as a masterclass

Source: https://www.floguo.com/ (+ /notes/design-engineering, /changelog, /tools/sidebar-playground), Flora Guo ("flo") — design engineer (Vercel DE team → founding design engineer at Paradigm → design at Ramp). A Next.js personal site, versioned in the open (v3.8.0) with a public changelog. No license stated; treat as study material.

## What it is

A personal site that behaves like a crafted desktop app: a three-panel "library" (nav / list / reader, all resizable), 40+ notes, a bookshelf with filters and cover scans, a writing section, a playground of tunable animation demos, AI-made study notes ("Artifacts"), and floGPT — an AI chat about the author. The author's stated path is itself the design-engineering arc: v0.dev sparked personal projects → Vercel's Design Engineering team → founding design engineer at Paradigm. Two things make the site a masterclass:

1. Every technique is documented — the changelog states the mechanism and often the reason ("replace grey hover colors with subtle brown tones", "fix navigation flicker by using shared layout", "reduce non-title heading sizes in prose").
2. The restraint: warm near-neutrals, three easing tokens, one entrance pattern reused everywhere. Motion lives in drawers and lists, not in decoration.

The site is versioned like software (v2.0 → v3.8.0 in a year) and ships structural, not just visual, iterations: monorepo (pnpm), content AST refactor, Base UI primitives replacing custom selects, shared `ListItemButton` extracted after list views drifted. That cadence — refactor the pattern once it repeats — is as much the craft as the pixels.

## The design signature

**Typography — three families, strict roles:**
- Sans (UI, list items, nav): Zalando Sans, variable 200–900 with italics. Substitute any humanist variable sans.
- Serif (titles, prose body): STIX Two Text, 400–700 with italics.
- Mono (labels, dates, eyebrows, code): JetBrains Mono 100–800.
- Handwriting (Caveat) only for marginalia — rare accent, never body.
- Headings get *tighter* letter-spacing (`-0.01em` to `-0.02em`, a deliberate v2.8 change); prose keeps tracking normal. Non-title headings in prose were deliberately shrunk (v3.7) so content, not chrome, dominates.
- Eyebrow-meta pattern everywhere: `MONO UPPERCASE text-xs tracking-widest` above a serif title, date in muted mono below — never a divider line (dividers were removed from list pages on purpose; spacing does the grouping).

**Color — warm paper, zero pure grays:**
- Light: bg `#f9f8f8` (warm off-white), fg `#11090b`, borders `#e6e4e4` at 60% alpha, muted fg `#4f4949`, hover `#f0f0f0`.
- Dark: bg `#0a0a0a`, fg `#fafafa`, borders `#1f1913` (brown-black), hover `#291f18` (brown), code bg tinted with `#461901` at ~30% alpha.
- Shadows are warm-tinted too: `--shadow-md: 0 1px 3px #1d140d0a, 0 4px 12px #1d140d12, 0 8px 24px #1d140d1a` — brown-black, never `#000`.
- One accent used once: the 404 cursor is `oklch(0.55 0.22 27)` (warm red-orange). Everything else is the neutral ramp.

**Voice — the dictionary entry as a reusable content pattern.** The homepage defines the author like a lexeme: `/ˈfloʊ.ɡwoʊ/` → `noun` → numbered definitions ("digital gardener; admirer of quiet beauty") → `see also:` links. The 404 does the same for itself. The pattern is portable: eyebrow (mono, IPA or slug), part of speech, 2–4 numbered definitions that are *specific* ("a page that wandered off the shelf and forgot to leave a note"), then pointers onward. It works because every field is filled with observed truth, not adjectives.

**Media details.** Bookshelf entries carry cover images, genre tags, and filter/sort controls that stick to the top of the panel with a divider; photos use a polaroid frame component with a WebP optimization pass in the build; scrollbars are styled to match the warm neutrals. These are the "execution with care" layer — none individually noticeable, all missing on generic sites.

**Motion — three tokens, two speeds of intent:**
```css
:root {
  --motion-ease-standard: cubic-bezier(.4, 0, .2, 1);    /* chrome: fades, opacity */
  --motion-ease-smooth-out: cubic-bezier(.22, 1, .36, 1); /* entrances */
  --motion-ease-spring: cubic-bezier(.34, 1.56, .64, 1);  /* playful overshoot */
}
```
Doctrine: overlays and panel chrome fade at 300ms `ease-in-out`; entrances use fade-up-blur; springs are reserved for things that physically drop in (drawers, ribbons). Typography, motion, shadows, and z-index all live as tokens (v3.4) — animation values are never inline literals except in demos.

## Notable techniques, with mechanisms

**1. The entrance reveal (site-wide pattern).** Exact source values:
```css
@keyframes fade-up-blur {
  from { opacity: 0; transform: translateY(12px); filter: blur(8px); }
  to   { opacity: 1; transform: none;             filter: blur(0); }
}
/* easeOutCubic; four groups, delays 0.05 / 0.18 / 1.00 / 1.18s */
.reveal-on .r1 { animation: fade-up-blur .5s  cubic-bezier(.33,1,.68,1) .05s both; }
.reveal-on .r2 { animation: fade-up-blur .65s cubic-bezier(.33,1,.68,1) .18s both; }
.reveal-on .r3 { animation: fade-up-blur .5s  cubic-bezier(.33,1,.68,1) 1s   both; }
@media (prefers-reduced-motion: reduce) {
  .reveal { opacity: 1; }
  .reveal-on [class^=r] { animation: none; }
}
```
Blur entrance is 8px → 0 (bigger blur reads as smudge). The gap between r2 and r3 (~0.8s) is intentional pacing, not a mistake. Reduced-motion restores `opacity: 1` — never leave content at `opacity: 0`.

**2. Drawer/nav choreography (playground-verified numbers).** Mobile nav, before → after:
- Overlay: no transition → `transition: opacity 300ms ease-in-out` (fade, don't slide scrim).
- Nav items: spring `stiffness: 400, damping: 28`, `staggerChildren: 0.04s`, `delayChildren: 0.18s`, blur `4px → 0` per item.
- The ribbon (site identity mark) gets a *delayed* spring at `0.45s` — it drops in only after the drawer settles. Sequencing chrome → content → identity is the whole lesson.
Framework-neutral port: stagger with `transition-delay: calc(var(--i) * 40ms)` on children; spring via the token above.

**3. Typed 404 with the house voice.** "four·oh·four" types in (blinking caret: 2px × 1em, `blink 1.1s step-end infinite`), then the page defines itself as a dictionary entry — IPA pronunciation, `noun`, numbered definitions ("a page that wandered off the shelf and forgot to leave a note"), `see also: lost, gone astray`, and a link "← back to the library". The 404 keeps the site's structure (eyebrow/title/mono meta) instead of inventing a new layout.

**4. Layout persistence without flash.** Panel widths are saved to localStorage; an inline `<head>` script restores them as CSS custom properties *before first paint*:
```html
<script>
  ['notes-list-width','content-panel-width'/* … */].forEach(k => {
    const v = localStorage.getItem(k);
    if (v && !isNaN(parseFloat(v)))
      document.documentElement.style.setProperty('--' + k, v + 'px');
  });
</script>
```
Persisted UI state must be applied pre-paint or it flashes. Double-clicking a resize handle restores the default width.

**5. Keyboard as first-class.** Shift + arrows traverse tabs and adjacent panels; a Shift+Up/Down easter egg cycles content. Search is a lightbox with arrow-key navigation, opens the first result on entering a section.

**6. Search that respects text.** Literal (not fuzzy) matching, Unicode-aware case folding, visible match boundaries, and snippets cropped on *grapheme boundaries* so emoji and combined characters survive highlighting. Cheap version: `str.normalize().toLocaleLowerCase()` + `Intl.Segmenter` for cropping.

**7. Content as data, not HTML.** v3.0 refactored content from HTML strings to structured AST nodes — this fixed SSR hydration (no DOMParser at runtime), made rendering type-safe, and made content inspectable. Notes can embed live CSS (`@keyframes` shown *and running*). Draft notes are filtered from production builds. If your markdown pipeline fights hydration, move parsing to build time and ship nodes.

**8. Reading ergonomics at scale.** Long essays get a table of contents with scroll spy; images get zoomable previews; one resizable shell is shared by every list panel so drag handles stay aligned; writing preview panels collapse. Small-screen fallback collapses the three panels into drawer + stacked reader with the choreography from (2).

**9. Progressive enhancement for embeds.** Tweets are snapshotted at build time with media cached locally, validated before rendering, with retries bounded — zero client-side fetches, no layout shift, no dead embeds. Dynamic OG images per note. RSS as a real feed. Inline favicons preloaded for every external link in a note.

**10. floGPT — an about page you can talk to.** Slide-in right drawer (resizable), first-person persona from a system prompt (background, writing, origin, cities lived in), small fast model (Haiku-class) because scope is narrow, streamed markdown rendered with the site's own typography (a dedicated `.chat-markdown` class, not inherited prose styles), Lottie spiral loader while generating, voice input with a recording waveform, custom caret, chat font sizes tokenized (`--text-chat-body`, `--text-chat-user`). Footer prompts ("What are you working on? Where are you from? What are you reading?") seed conversations. Key scoping rule: *not a general assistant* — it refuses breadth to stay accurate. The pattern is reproducible: narrow persona-prompt + small fast model + site-native typography + entry prompts where users already are.

## The design-engineering notes (actual lessons)

From /notes/design-engineering — her three theses:
1. **"Material understanding beats tool proficiency."** Knowing Figma + React is not the job; the final medium — where code and pixels are one malleable material — is. Build in the medium users touch.
2. **Internalize the translation layer.** Design engineering "internalizes the translation layer, rather than externalizing it into handoffs" — time collapses between idea and validation.
3. **"Prototyping is central but not the whole story."** The durable value is foundations: design systems, component libraries, patterns that elevate whole teams.

From surrounding notes:
- **Craft Is Execution:** "craft doesn't always mean visual. i think of craft as execution with care." Visual fluency is one path into design, not its definition.
- **Interface Design is Pattern Recognition:** discernment of which form to apply and when; "sometimes (rarely) pattern creation". Most interface problems are already solved — stewarding canonical, cohesive interfaces is the harder skill.
- **Effective Information Architecture** (an AI-made artifact): good IA answers what exists / where am I / what's nearby / where next / how back; strong labels create "information scent" ("Billing" strong, "Services" weak); bad IA "feels like Backrooms"; structure grows from a few clear concepts (projects contain documents; people share and discuss them).
- **Sidebar Animation:** the meta-practice — every animation fix ships with a before/after demo and a playground (tunable stiffness/damping/stagger/blur, live code that updates as you drag). Turn polish into a teachable artifact.
- **Agents in April (for AI builders):** beware "tool-shaped objects" (Will Manidis's term) — setups that feel like progress and keep you busy; LLMs are the most sophisticated version because their fluency creates the *sensation* of thinking. An agent worth building needs personality, context, goals, doubt protocols (self-questioning for known failure modes), a self-model, scheduled brain tasks, and memory — and writing its `soul.md` is a forcing function: you must decide what it pushes back on.
- **The learning canon she endorses** (from the design-engineering note): Vercel's design guidelines, Rauno's interfaces, Emil Kowlalski's resources and animations.dev, Josh Comeau-era craft courses, interfacecraft, ui-skills — plus pattern libraries (Mobbin, aiverse, shapeof.ai) as the corpus behind "pattern recognition".

## When to use / When NOT to use

Use when: building a personal site, portfolio, docs site, or content-heavy product where craft is the message; you want warm-minimal, editor-quality typography; you need a motion system small enough to hold in your head.

Do NOT use when: the product needs pure neutral grays for data-dense UI (the brown tint muddies charts); a marketing site needs loud motion — this system caps at 300ms fades and one overshoot curve; the audience expects conventional patterns only — the dictionary voice and library conceit require an audience that reads.

## How to apply

1. Pick 3 fonts, lock roles: sans = UI, serif = titles/body, mono = meta/code. Add italics axes; you will use them.
2. Define the neutral ramp warm: derive darks from a brown-black (e.g. `#1f1913`), tint hovers and shadows the same direction (`#1d140d` at 4–12% alpha for shadows).
3. Ship exactly 3 easing tokens (standard / smooth-out / spring) and 2 durations (300ms chrome, 500–650ms entrances). Springs only for elements with physical placement.
4. One entrance pattern everywhere: fade-up-blur 12px/8px, easeOutCubic, ≤4 stagger groups, delays under 1.2s. Wrap in `prefers-reduced-motion` that restores final state.
5. For drawers: fade scrim 300ms, stagger children 0.04s after 0.18s, per-item blur 4px→0, identity element lands last (+0.45s).
6. Apply any persisted layout from localStorage via a pre-paint inline script setting CSS variables — never post-hydration.
7. Keep the error/404 page in the same structure and voice as the rest of the site; give it real navigation back.
8. Treat content as structured data (build-time parsed AST), drafts excluded from prod; snapshot third-party embeds at build time.
9. Support the keyboard loop: arrows move within and across panels/lists; search opens with a key and navigates with arrows.
10. Keep a public changelog of mechanism-level entries — it forces intent ("replaced grey hovers with subtle brown tones") and becomes your own design-decision record.
11. Group list content by spacing alone: mono date + title + one-line meta, no divider rules; tighten only the heading letter-spacing, never the body.
12. When a third-party embed matters, snapshot it at build (validate, cache media, bound retries); never let someone else's script own your render path.
13. Ship one shared shell for resizable panels instead of per-page implementations — handles stay aligned, persistence keys stay consistent, double-click resets width.
14. If you add an AI persona to the site (chat, copilot), scope it to first-person facts about the site's subject, render its output in your typography, and offer 2–3 concrete starter prompts in place — never present it as a general assistant.

## AI-slop warning

The failure mode is cloning the skin: serif + mono + warm-beige + dictionary-definition hero is already becoming a recognizable "taste signal" template. An AI asked for "a site like floguo's" produces the costume (IPA pronunciations, ASCII trees, "noun. 1. …" blocks) with none of the substance (tokenized motion, pre-paint state, grapheme-safe search, changelog discipline). The conceit works because the entire site — 40 notes, a bookshelf, tunable playgrounds — earns it; on a five-page site it reads as affectation. Also beware over-animating: this site uses springs in exactly two places; an AI that sprinkles `cubic-bezier(.34,1.56,.64,1)` on every hover has misread the restraint. Second trap: the personal content (poetry, family letters, faith notes) is what makes the voice feel inhabited — an AI generating faux-personal fragments to "capture the vibe" manufactures hollow intimacy instead. Copy the token counts and the discipline, not the personality.

## Relations

- **rauno** — the other canonical DE portfolio; Rauno optimizes for density and tactile detail, floguo for warmth and editorial voice. Compare their opposite solutions to the same "personal site as proof of craft" brief.
- **jakub-kr** — details-that-feel-better school; floguo's drawer choreography numbers (0.04s stagger, 4px blur) are a concrete instance of that philosophy.
- **easing** — the token trio here (`.22,1,.36,1` / `.34,1.56,.64,1`) is a production deployment of that easing canon; use it for the curves' rationale.
- **interface-craft** — supplies the systematic checklist floguo's changelog implies; pair when auditing your own site at this level of care.
- **emil-skills** — floguo's notes cite the same resource canon (Emil's resources, animations.dev, interfacecraft); use for the component-level animation patterns this skill deliberately stays silent on.
