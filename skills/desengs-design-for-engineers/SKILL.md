---
name: desengs-design-for-engineers
description: Use when a code-native builder needs the visual-design fundamentals crash course — hierarchy, whitespace, alignment, color, contrast, typography — plus the practice loop that builds taste.
source: https://didoesdigital.com/project/design-for-engineers/
category: reference
---

# Design for Engineers (desengs) — teaching visual design to builders

Source: https://didoesdigital.com/project/design-for-engineers/ — Diana MacDonald (Di Does Digital, didoesdigital.com). A curated, topic-ordered learning guide ("a living project") routing software engineers to the canonical resources for learning digital design. No explicit content license stated; annotations and four tips are the author's own words.

## What it is / Why it exists

- Premise, in the author's words: "What's the point of building something no one wants? Instead, you can use design to solve problems, communicate, and delight people."
- Audience: "software engineers (or anyone already building products who wants to learn design) rather than designers." It assumes you can ship; it fills the missing half — making what you ship usable and desirable.
- Format: one skim-first page ("I suggest you skim the whole page before diving into specific links") organized as a strict sequence: fundamentals → typography → alignment → color → contrast → UX → methods → patterns → product/research/accessibility/testing → performance → animation → data → content/microcopy → design systems → practice → four practical tips. Companion page: Code for Designers (the reverse direction).
- The pedagogy embedded in the format: sequence (fundamentals before tools), small-dose practice (it routes practice to 5-minute games and copywork, not tomes), and iteration ("Iterate" is a literal tip). Treat this skill as that crash course distilled: the fundamentals as framed for engineers, with mechanisms you can apply to code today.

## The core ideas

### 0. The learning path (the guide's own taxonomy, in order)

1. Careers for engineers that design — design engineering, prototyping, front-end design, UX engineering, design technologist, design ops. Design skill is a career multiplier for builders, not a hobby add-on.
2. Fundamentals of web design — start here if never designed: fast pass ("Web design in 4 minutes"), visual rules (Erik Kennedy's "7 Rules for Creating Gorgeous UI"), then depth (Learn UI Design, "The Principles of Beautiful Web Design").
3. Typography, Alignment, Color, Contrast — four dedicated fundamentals sections; the visual core (see 2–5 below).
4. UX — Laws of UX; interface qualities to optimize: learnable, efficient, forgiving, satisfying; interaction and UI patterns; information architecture; product thinking.
5. Design methods, patterns, product design, research, accessibility, user testing, performance, animation, data visualization, content, microcopy — the product layer beyond visuals.
6. Design systems — the largest section in the guide (intro → tokens → growing/maintaining). For teams, fundamentals converge into a system.
7. Practice design + practical tips — perception training (games, copywork) then the four operating rules.

### 1. The four operating rules (the author's own distillation)

Stated verbatim on the page; expanded here into mechanisms:

- **"Less is more"** — every element must earn its place. Ban list first: decorative borders, gradients, icons for text-only actions, more than 2 font families, more than 1 accent color. If removing an element changes nothing, remove it.
- **"Add whitespace"** — whitespace is the cheapest visual upgrade. Mechanism: a 4px-base spacing scale (`--space-1: 4px` … `--space-8: 32px`) and one rule — gaps *between* groups (16–32px+) must be clearly larger than gaps *inside* groups (4–8px). When a layout feels cramped, double the outer gaps before touching anything else.
- **"Align everything with something"** — no free-floating elements. Every element's edge aligns with another element's edge; enforce with a grid, not by eye. Misalignment of even 1–2px reads as sloppiness.
- **"Iterate"** — design in passes, not one-shot: pass 1 structure/hierarchy, pass 2 spacing, pass 3 color/contrast, pass 4 type detail. Revisiting beats agonizing over pass 1.

### 2. Typography (routes: Practical Typography, Better Web Type, Typekit Practice)

- Line length 45–90 characters per line (Practical Typography's range); ~66 is the classic target. Enforce: `max-width: 70ch`.
- Line height 120–145% of font size for body (≈1.4–1.5 unitless in CSS); tighter (1.1–1.2) only for large headings.
- Body text ≥16px; don't go below 12px anywhere, ever.
- 2 font families max (one for headings, one for body); 3 weights cover almost everything (regular, medium/semibold, bold).
- Fonts carry cultural connotations (Fonts in Use is linked for this) — pick type by the product's voice, not novelty.
- "The Equilateral Triangle of a Perfect Paragraph" (linked practice game): font size, line height, and line length must balance together — changing one requires re-tuning the other two.

### 3. Alignment is optical, not geometric (routes: Shestopalov's optical effects, "The PLAY button is not optical alignment", Kennedy's alignment tips)

- Optical center sits above geometric center: to look vertically centered, nudge content up ~2–4% of the container height.
- Triangles and asymmetric icons inside circles/buttons cannot be geometrically centered — offset them until they *look* centered. A play triangle's visual weight is its flat back edge, not its bounding box.
- Circular shapes need slight size overshoot (~2%) next to squares of the same nominal dimensions to appear equal.
- Prefer edge alignment to center alignment when elements share a boundary (Kennedy's pro tips route).

### 4. Color in HSB, not hex roulette (routes: Kennedy's HSB primer and practical color framework, Drasner's color guide)

- Think in HSB/HSL, not raw hex: hold hue constant and vary saturation + brightness to derive states (hover = brightness ±5–10%; disabled = saturation → ~0–10%, brightness raised toward the background).
- Tint your grays: pure neutral gray (`#808080`) is dead on screen; give neutrals a few degrees of the page hue. Backgrounds: don't use pure `#FFFFFF` or `#000000` for large surfaces — soften (`#FAFAFA`, `#0A0A0A`-style near-black).
- One accent color, used sparingly, on the single most important action per view. Everything else stays neutral. The accent is a decision-maker, not decoration.
- Data visualizations need color-blind-safe sets chosen deliberately (Kennedy's dataviz color article is the route), not rainbow defaults.

### 5. Contrast is a number, not a vibe (routes: Color & Contrast on contrast sensitivity, high-contrast and increase-contrast modes; 24a11y contrast ratios)

- WCAG AA: 4.5:1 for body text, 3:1 for large text (≥24px or ≥18.66px bold) and for meaningful UI parts/icons. Test mechanically — compute the ratio, don't eyeball it.
- Contrast sensitivity declines with age and varies with vision conditions; design for the sensitive tail, not your own eyes on a good monitor.
- Stress-test palettes in OS high-contrast / increased-contrast modes — a UI that survives them wasn't built from color alone (never encode state by color only; add icon, label, or underline).

### 6. Hierarchy: the meta-fundamental

- The guide's fundamentals route ("Web design in 4 minutes") teaches hierarchy first: before color, before decoration, decide what the user reads first, second, third.
- Mechanism: exactly 3 text levels per view (primary, secondary, tertiary) distinguished by 2+ channels — size (steps ≥1.25×), weight, and spacing. If everything is bold, nothing is.
- Size steps should be a scale (e.g., 12 / 14 / 16 / 20 / 24 / 32), not arbitrary values.

### 7. UX beyond the visuals

- Optimize for four interface qualities (the guide's UX route): learnable, efficient, forgiving, satisfying. Forgiving = undo/confirm for destructive actions; efficient = fewest steps to value.
- Follow established interaction and UI patterns (ui-patterns, ARIA Authoring Practices Guide are the routes) — novelty in pattern design is a cost users pay, not a gift.

### 8. Words are UI (microcopy section — includes the author's own rules)

- The author's rule of thumb: use "your" not "my" in UI copy — except buttons ("My Settings" label in nav vs "Add to My Library" as a button action). Ask "who else is in the room?": copy is read by people other than the account owner (support, admins, auditors).
- Link text must be salient, descriptive, and start with the keyword (NN/g route) — "Write Better User Interfaces by Asking 'Who Else is in the Room?'" beats "click here". Never mystery-meat links/icons.
- Every input has a visible label (the guide's form-labels route); placeholders are not labels.
- The $300 Million Button case (linked): forcing registration where a guest checkout would do destroyed value — question every form field's existence.

### 9. Test with humans, cheaply (user-testing section, with the guide's own annotations)

- "Run 3 user tests with 5 participants each" (Nielsen, annotated on the page) — 5 users surface most usability problems; iterate between rounds.
- "Spend two hours every six weeks with users" (Spool's exposure hours, annotated on the page) — sustained contact builds the judgment no checklist replaces.
- Five-second test: show a screen for 5 seconds, ask what it communicates and what you recall — measures hierarchy and clarity, not preference.
- Heuristic evaluation (expert review against heuristics) as the zero-user fallback.

### 10. Motion, data, and speed are design too

- Animation (routes: Val Head's "Designing Interface Animation", the UX in Motion Manifesto): motion exists to explain — sequencing (what came from where), relationships (what is connected), and feedback (what my tap did). If an animation explains nothing, cut it. The guide treats animation as a UX discipline, not garnish.
- Data visualization (routes: FT Visual Vocabulary, Data Visualization Style Guidelines, the author's own "Sharpen your design eye" dataviz game): pick chart forms from a vocabulary of proven patterns (the FT vocabulary pairs questions with chart types); follow a style guide for axis labels, gridlines, and color. Default bar charts over creativity.
- Performance (route: page-load impact article): slow pages are a design failure, not just an engineering metric — the guide files performance under design. Budget motion and assets like any other visual decision.

### 11. Design systems as the destination

The guide's largest section. Trajectory: fundamentals (this skill) → patterns (ARIA APG, pattern libraries) → systems (Atomic Design, Kholmatova) → tokens → governance (releasing, sizing, measuring impact, content strategy).
- Tokens: name colors/spacing/type by role and scale step (`--color-action`, `--space-3`), never by value (`--blue-500`) — values change, roles don't.
- A system without content strategy and documentation is a component dump (the guide links both explicitly).

### 12. The practice loop: small doses beat binges

The guide's "Practice design" section routes to short-session perception training, not reading marathons:
- Games (5–15 min each): Can't Unsee (spot the better-designed version), Method of Action (shape/color/typography drills), Better Web Type's font-memory and paragraph-triangle games, and the author's own dataviz game "Sharpen your design eye" (with Yan Holtz).
- Copywork (Kennedy route): pixel-by-pixel recreation of excellent UIs — the fastest skill builder; you discover the invisible decisions (spacing, optical nudges, weight choices).
- Regular exposure to tune taste: weekly UX newsletter, design galleries/layers, featured practitioners.
- Why it works: perception is trained, not told. Ten minutes daily of comparing good vs. bad builds the detector you need before production work; reading rules without the comparison loop produces rule-quoting, not taste.

## When to use / When NOT to use

Use when:
- An engineer, founder, or AI is building/shipping UI without a designer, and it needs to look intentional, not just function.
- A UI "works but looks off" and you need a diagnostic order: hierarchy → whitespace → alignment → contrast → color → type detail.
- Onboarding a code-native builder (or an agent) to design from zero — this is the sequenced on-ramp before specialized skills.

Do NOT use when:
- The question is interaction behavior, states, latency, or forms plumbing — use desengs-web-interface-guidelines.
- You need deep typographic craft (optical sizes, pairing, variable fonts) — desengs-practical-typography / desengs-krehel-skills.
- The task is motion or a specific effect — this source predates and excludes that scope.
- You want a style to copy: this is a fundamentals syllabus, not a visual identity. It names no product-specific conventions.

## How to apply (numbered pre-ship pass)

Run in this order on any UI (this is "Iterate" mechanized):

1. Hierarchy: list the 3 things the user must read in order; assign exactly 3 text levels via a size scale; make the primary action the only accent-colored element.
2. Whitespace: group related elements; set intra-group gaps 4–8px, inter-group gaps 16–32px+; if cramped, double outer gaps first.
3. Alignment: every element shares an edge with another; put x/y on a 4px grid; optically nudge icons/triangles 1–2px off "correct" to *look* right.
4. Contrast: compute ratios — 4.5:1 body, 3:1 large text and icons; fix before anything cosmetic; check state is never color-only.
5. Color: one accent; tint all neutrals toward the page hue; derive hover/disabled via HSB brightness/saturation steps, not new hues.
6. Typography: 2 families, ≤3 weights; body ≥16px; line-height 1.4–1.5; `max-width: 70ch`; heading line-height 1.1–1.2.
7. Words: "your" not "my" (buttons excepted); link text leads with the keyword; every input has a visible label; delete fields without a purpose.
8. Verify forgiveness: destructive actions confirmable/undoable; errors state what happened and the next step.
9. Iterate: repeat steps 1–8 as passes; each pass changes one layer (structure → space → color → type detail), never all at once.
10. For learning (human or agent): skim the whole path before deep-diving any topic; add 10 minutes/day of comparison games or copywork; expose yourself to good work weekly.

## AI-slop warning

Typical AI misapplications of this skill:
- Treating it as a decoration pass: applying gradients, shadows, and glass effects while hierarchy and alignment are still broken. The source's order is explicit — fundamentals before flourish; "Less is more" is rule #1.
- Centering everything geometrically: AI centers icons in buttons by bounding box, producing visibly off-center play buttons and checkmarks. The source dedicates its alignment section to *optical* correction — nudge, don't just compute.
- Equal spacing everywhere: uniform margins around all elements kill grouping. Whitespace must be asymmetric — tight inside groups, loose between them.
- One-off hex values per component: color picked per element instead of one accent + HSB-derived states on tinted neutrals. This produces rainbow mush the source's color section exists to prevent.
- Gray-on-gray "subtle" text that fails 4.5:1, or success conveyed by a green tint alone.
- Padding the output with the resource list itself: cite the mechanisms, not the bibliography. The value is the sequenced fundamentals and the four rules, not link-count.
- Skipping the practice loop: an agent that never compares candidate variants ("which of these two is better?") quotes rules without taste — run the comparison, it is the games' mechanism ported to agent work.

## Relations

- desengs-krehel-skills — the specialization layer: full typography, color, and layout skill sets. This skill is the on-ramp that says what matters and in what order; krehel supplies depth per topic.
- desengs-web-interface-guidelines — interaction-level rules (states, forms, latency, behavior) that sit on top of these static visual fundamentals; use both on any real screen.
- desengs-practical-typography — full distillation of Practical Typography, the guide's flagship typography route; go there for the rules summarized in section 2.
- desengs-laws-of-ux — full distillation of Laws of UX, the first link in this guide's UX section; supplies the perceptual science behind the hierarchy and proximity habits taught here.
