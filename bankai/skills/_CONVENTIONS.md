# _CONVENTIONS.md — binding rules for every * skill

Every skill in this folder distills ONE curated source into a self-contained, stack-neutral design-engineering skill. Together they form the canon referenced by `bankai`. Read this file fully before writing a skill.

## Hard rules

1. **Language**: English. Dense, direct, no filler, no marketing tone. **150–300 lines** (never below 120).
2. **Stack-neutral and global**: never mention any specific product or project. Assume a modern web stack (HTML/CSS, React when relevant) but prescribe *mechanisms*, not installs. No Tailwind-specific output unless the source itself is Tailwind-based — then port the mechanism to plain CSS and say so.
3. **Frontmatter** (exact keys):
   ```
   ---
   name: <slug>
   description: Use when <trigger condition>. <essence in one clause>.
   source: <URL>[; <URL2>]
   category: principle | library | tool | reference | essay | portfolio
   ---
   ```
   `name` MUST equal the folder name. `description` 120–220 chars, starts with "Use when".
4. **H1**: `<Name> — <one-line essence>`. Right after, a `Source:` line: URL, author, what the source is, license if any.
5. **Required sections** (adapt titles to the category, keep the order):
   - What it is / Why it exists
   - The core ideas (the meat — see rule 7)
   - When to use / When NOT to use
   - How to apply (numbered checklist)
   - AI-slop warning (see rule 8)
   - Relations (cross-reference siblings by exact name from the list below — 2–5 refs, say what each adds or contradicts)
6. **Every line must change a decision** — a value, a pattern choice, a ban. If a paragraph would not change the behavior of an AI agent building UI, delete it. Exact numbers over adjectives ("120–150ms", "4.5:1 contrast", "8px grid", "ease-out cubic-bezier(0.22,1,0.36,1)").
7. **Code snippets** show the underlying *mechanism* in plain CSS/JS or framework-neutral markup, copy-pasteable. For libraries: show how to recreate the effect without the dependency, and separately state when installing is actually justified.
8. **AI-slop warning** (every skill has one):
   - libraries: when this look became a cliché, which contexts it poisons
   - principles: how AI typically misapplies the principle
9. **Never invent facts.** If the source is unreachable after all fetch routes, distill from what you can verify via search and add at the top: `> Note: primary source unreachable — distilled from secondary sources.` If a site is thin, mine its linked docs/README/blog for depth rather than padding.
10. **Robustness rules** (enforced since the A/B eval): (a) never prescribe base-CSS hidden states (`opacity:0`, off-canvas) that only JS removes — entrances must complete without JS; (b) never rely on the `hidden` attribute on elements whose class sets `display` — specify a `.is-hidden{display:none!important}` gate instead; (c) example code must render its default state correctly with JS disabled.
11. **Anti-convergence rule**: when writing or updating a skill, do not hardcode one palette family, one easing, or one metaphor as THE recommendation — the canon's own house style (cream paper / warm ink / vermilion accent, `cubic-bezier(0.22,1,0.36,1)`) must stay a technique, not an identity. Prefer ranges, rotations, and decision tables over single default values.

## Fetch routes (in order, stop when you have enough)

1. WebFetch on the URL — then explore key sub-pages (docs, components, principles, blog).
2. `mcp__web_reader__webReader` with the URL if WebFetch is blocked.
3. `curl -sL <url> | head -c 30000` in Bash.
4. WebSearch `"<site> <topic>"`, GitHub README (`raw.githubusercontent.com`), npm page.
   For YouTube: fetch the watch page, then search `"<video title>" transcript OR summary`.

## Category-specific requirements

- **library** (component/effect library): (a) why it was designed / what gap it fills, (b) component or pattern inventory (names), (c) when to use, (d) when NOT (native/cheaper alternative, weight, a11y cost, slop risk), (e) the signature technique explained in plain CSS/JS.
- **tool** (generator/utility): what it produces, the methodology it encodes, how to replicate its output by hand, when the tool beats manual work.
- **principle / reference** (multi-principle site): distill the site's own framework — its taxonomy, its exact numbers, its vocabulary — do not produce a generic UX summary the site would not endorse.
- **essay** (single article/talk): thesis, every actionable rule with the author's exact numbers/quotes (attribute quotes), and what changes day-to-day for an AI building UI.
- **portfolio** (person/agency site): the person's design signature, their stated philosophy, recurring techniques visible in their work, what to steal and what is personal style not to copy.

## Sibling skills (for Relations sections)
- `mobile` — the native-app bridge (Expo/RN/iOS/Android): translates canon mechanisms to platform equivalents, platform laws override web wording on mobile targets

Existing: domain-fit, micro-craft, spectacle, dynamism, 3d-craft, aicss, beautiful-ui, dot-matrix, emil-skills, impeccable, krehel-skills, magic-ui, taste, thinking-orbs, transitions, ui-skills, web-interface-guidelines, bankai.

Reference canon: interfaces-dev, component-gallery, ui-playbook, ui-wiki, laws-of-ux, principles, lessons-design, practical-typography, ds-checklist, design-systems-surf, design-books.

Craft & philosophy: devouring-details, interface-craft, fluid-functionalism, design-spells, abtest-design, oklch, easing, svg-guide, rams, galleries.

Libraries & effects: spectacle, loading-dev, gradientool, use-layouts, corner-radii, tokens-generator, bencho, kugiri, images-in-motion, shoogle, cuelume, ui-camera, morphrig, morphicons, interior-dev, liquid-glass, liquid-gooey, crd-ui, dither-kit, agentation, number-flow, audio-kit, gradient-border, hashvatar, remediate, devl, ui-land, torph, shadowlab, fancy-components, dialkit, calligraph, floguo, cmdk, sonner, animations-dev, liveline, web-haptics, soundcn.

Essays: code-source-of-truth, limit-details, html-can-do-that, how-i-design-with-ai, inter-alternatives, anatomy-ai-input, calvez-typography, front-of-front-end, family-values, shedsgns-taste, invisible-details, you-dont-need-animations, details-feel-better, using-ai-as-de, concept-of-taste, scaling-intent-artistry, rise-of-de, ai-design-engineer-twilson, become-ai-designer, design-for-engineers, de-attributes, becoming-de, de-essay, de-state-of-mind, de-101, de-tools, de-jobs, design-engineers-map.

Portfolios: rauno, jakub-kr.
