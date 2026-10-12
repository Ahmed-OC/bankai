# _CONVENTIONS.md — binding rules for every desengs-* skill

Every skill in this folder distills ONE source listed on https://desengs.com/ into a self-contained, stack-neutral design-engineering skill. Together they form the canon referenced by `desengs-ui-ux-master`. Read this file fully before writing a skill.

## Hard rules

1. **Language**: English. Dense, direct, no filler, no marketing tone. **150–300 lines** (never below 120).
2. **Stack-neutral and global**: never mention any specific product or project. Assume a modern web stack (HTML/CSS, React when relevant) but prescribe *mechanisms*, not installs. No Tailwind-specific output unless the source itself is Tailwind-based — then port the mechanism to plain CSS and say so.
3. **Frontmatter** (exact keys):
   ```
   ---
   name: desengs-<slug>
   description: Use when <trigger condition>. <essence in one clause>.
   source: <URL>[; <URL2>]
   category: principle | library | tool | reference | essay | portfolio
   ---
   ```
   `name` MUST equal the folder name. `description` 120–220 chars, starts with "Use when".
4. **H1**: `<Name> (desengs) — <one-line essence>`. Right after, a `Source:` line: URL, author, what the source is, license if any.
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

Existing: desengs-domain-fit, desengs-micro-craft, desengs-spectacle, desengs-dynamism, desengs-3d-craft, desengs-aicss, desengs-beautiful-ui, desengs-dot-matrix, desengs-emil-skills, desengs-impeccable, desengs-krehel-skills, desengs-magic-ui, desengs-taste, desengs-thinking-orbs, desengs-transitions, desengs-ui-skills, desengs-web-interface-guidelines, desengs-ui-ux-master.

Reference canon: desengs-interfaces-dev, desengs-component-gallery, desengs-ui-playbook, desengs-ui-wiki, desengs-laws-of-ux, desengs-principles, desengs-lessons-design, desengs-practical-typography, desengs-ds-checklist, desengs-design-systems-surf, desengs-design-books.

Craft & philosophy: desengs-devouring-details, desengs-interface-craft, desengs-fluid-functionalism, desengs-design-spells, desengs-abtest-design, desengs-oklch, desengs-easing, desengs-svg-guide, desengs-rams, desengs-galleries.

Libraries & effects: desengs-spectacle, desengs-loading-dev, desengs-gradientool, desengs-use-layouts, desengs-corner-radii, desengs-tokens-generator, desengs-bencho, desengs-kugiri, desengs-images-in-motion, desengs-shoogle, desengs-cuelume, desengs-ui-camera, desengs-morphrig, desengs-morphicons, desengs-interior-dev, desengs-liquid-glass, desengs-liquid-gooey, desengs-crd-ui, desengs-dither-kit, desengs-agentation, desengs-number-flow, desengs-audio-kit, desengs-gradient-border, desengs-hashvatar, desengs-remediate, desengs-devl, desengs-ui-land, desengs-torph, desengs-shadowlab, desengs-fancy-components, desengs-dialkit, desengs-calligraph, desengs-floguo, desengs-cmdk, desengs-sonner, desengs-animations-dev, desengs-liveline, desengs-web-haptics, desengs-soundcn.

Essays: desengs-code-source-of-truth, desengs-limit-details, desengs-html-can-do-that, desengs-how-i-design-with-ai, desengs-inter-alternatives, desengs-anatomy-ai-input, desengs-calvez-typography, desengs-front-of-front-end, desengs-family-values, desengs-shedsgns-taste, desengs-invisible-details, desengs-you-dont-need-animations, desengs-details-feel-better, desengs-using-ai-as-de, desengs-concept-of-taste, desengs-scaling-intent-artistry, desengs-rise-of-de, desengs-ai-design-engineer-twilson, desengs-become-ai-designer, desengs-design-for-engineers, desengs-de-attributes, desengs-becoming-de, desengs-de-essay, desengs-de-state-of-mind, desengs-de-101, desengs-de-tools, desengs-de-jobs, desengs-design-engineers-map.

Portfolios: desengs-rauno, desengs-jakub-kr.
