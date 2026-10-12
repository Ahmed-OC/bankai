---
name: desengs-de-101
description: Use when you need the design-engineering primer — the definition ("engineer with design skills"), why it emerged now (hardware, tools, economics), and the four jobs: marketing, product, R&D, founding.
source: https://www.designdisciplin.com/p/design-engineering-101
category: essay
---

# Design Engineering 101 (desengs) — the primer: the role, why now, and the four jobs

Source: https://www.designdisciplin.com/p/design-engineering-101 — "Design Engineering 101: Practical guide to the jobs and skills of the design engineer in tech," byline Baytaş (M.A. Baytaş: PhD in interaction design, design engineer for startups, ~decade in R&D), 17 Sep 2024, on Design Disciplin, an "independent design research" Substack. Free to read, no license stated. One of "more than 10" industry essays on design engineering released in 2024; this one is the practitioner's field guide — definition, causes, jobs, skills, learning path.

## What it is / Why it exists

- Thesis, quoted: "A design engineer is an engineer with design skills. While this equation may seem simple, it has powerful implications."
- Term history: for decades "design engineering" meant the intersection of industrial product design and mechanical engineering. In tech it now means the union of visual design and software development.
- The 2024 moment: "more than 10 industry thought leaders released essays and educational material" on the topic in a single year. The essay's own further-reading wave: Trys Mudford, Jim Nielsen, David Luhr, Emil Widlund, Vercel, Maggie Appleton, David Hoang, Ryn Gonzalez (2021–2024). Baytaş's primer is the response to that noise — sorting what the role IS from what it's called.
- Acknowledged reviewers of the piece: Dmytro Kondakov, Mert Düzgün, Emil Kowalski, Mariana Castilho — i.e., the primer was sanity-checked by practitioners the canon elsewhere treats as authorities.

Why the role emerged NOW — three developments (the economics of the equation):

1. Hardware: "Today's average computer can achieve impressive visuals and motion." Visual effects once reserved for high-end machines run on commodity laptops.
2. Developer tools: "Figma, React, Tailwind CSS, Vercel, and Framer Motion" have been "advancing in leaps and bounds in recent years," allowing "design-focused developers to achieve far more than before."
3. Economics: software has become a commodity, so design is the differentiator — quoted: "Since anyone can build software, the design that goes into it will determine the winners."

## The core ideas

### 1. The definition unpacked — five implications of "engineer with design skills"

1. An engineer with design skills doesn't need designers to design what to build: "they can take the inputs designers take and deliver the outputs engineers deliver" — they can deliver value single-handedly.
2. They don't need engineers to build what they design — they are engineers.
3. They "can communicate efficiently with designers and contribute to design work."
4. They can "build with production-grade materials (code), for design decisions that can only be experienced in a medium such as interaction design." This is the medium argument: some design decisions (motion feel, interaction timing, responsive behavior) do not exist in static mockups; they can only be decided in the final medium, by someone who builds in it.
5. They can build tools that make designing easier, "enabling designs that were not possible before."

Order matters: engineer is the base class, design is the second class. A "designer who codes a little" is a different (adjacent) profile. Every skill list below assumes production-grade building as the floor.

### 2. Dual-classing — how practitioners actually learn

- Most working design engineers learned by "separately studying design and engineering, or 'dual-classing'" — almost no program teaches the union directly.
- Baytaş predicts dedicated educational resources will emerge and calls the current gap "a unique opportunity for creative self-learners": the discipline is young enough that self-directed people shape it.

### 3. The four jobs — where design engineers work

#### Job 1: Marketing — the wow surface

- Building "impressive, large-scale websites that marketing needs" — beyond what site builders like Framer or Webflow suit (the essay's scale example: Stripe's site).
- Sub-genre "creative development": "animations, 3D, game-like experiences" (example studio cited: Unseen Studio), "pushing the envelope of immersive interactivity, usually at the expense of conventional accessibility." Note the author's own caveat — the a11y cost is named, not endorsed.
- Skills: design + deep front-end (HTML/CSS/JS) + motion + 3D.

#### Job 2: Product — the polish surface

- "Improving the design of an existing product, adding polish through motion design and interactivity, and building and maintaining design systems."
- The most collaborative flavor: works "on multiple parts of a product" with designers, product managers, and engineers.
- Evidence, quoted from a GitHub job listing: "product design, design systems, design ops, front-end development, and illustration" — "Needless to say, the design engineer speaks all those languages."
- Skills: deep CSS, motion design, design systems, design tools.

#### Job 3: R&D — the prototype surface

- Prototyping new products and product-finding. Rare at "large, stable companies with money to spare" (named: Ivan Poupyrev at Google, Jordan Singer at Figma).
- Structurally vulnerable, quoted: "At the first signs of distress, R&D is the first to get canceled" (example: IKEA's Space10 closing). Most R&D design engineers actually work at small studios and agencies — "a client wants to wow a trade-show audience" with installations and interactive pieces.
- Skills: 3D (Unity, Unreal, Blender), physical computing (Arduino, Raspberry Pi), plus whatever the prototype demands. The author's decade in R&D spanned "Python, Lua, C#, MATLAB, Unity, JavaScript, Arduino, Processing, electronics, robotics, and fabrication."
- Operating rule, quoted: "It's the Wild West — you have to draw quickly." Speed of iteration beats quality of code — inside R&D only.

#### Job 4: Founding — the everything surface

- "Where the mindsets of both sides are needed the most is founding," because product lifecycles are short and one person must cover UX, growth, brand identity, and building.
- Ideal for solopreneurs (named: Pieter Levels, Danny Postma, Marc Louvion). The author has been "selling this skillset to early-stage founders" since 2023.
- Trade-offs: founders want one person spanning multiple disciplines (pro), but the work carries "economic uncertainty" and demands "master of many trades" breadth (con).

### 4. The four jobs at a glance (decide with this table)

| Job | Deliverable | Core skills | Quality bar | Named risk |
| --- | --- | --- | --- | --- |
| Marketing | Impressive large-scale sites, creative dev | Design, HTML/CSS/JS, motion, 3D | Wow per dollar; a11y explicitly traded | Accessibility loss ("at the expense of conventional accessibility") |
| Product | Polish + design systems inside an app | Deep CSS, motion, design systems, design tools | Production system quality; collaborate across roles | Scope sprawl — one person "speaks all those languages" |
| R&D | Fast prototypes, installations | 3D (Unity/Unreal/Blender), Arduino/RPi, polyglot scripting | Iteration speed over code quality ("draw quickly") | "First to get canceled" when money tightens |
| Founding | Whole product: UX, growth, brand, build | All of the above, shallower | Shipping breadth over depth | Economic uncertainty; "master of many trades" burnout |

The row you are in decides your constraints. Misfile a surface and every downstream choice (motion budget, a11y bar, code-review bar) is wrong.

### 5. The learning stack (author-curated, 2024)

For designers learning engineering:

- Harvard CS50 — "most popular."
- The Odin Project — "most comprehensive."
- freeCodeCamp — "most practice."
- UI Engineering 101 for Designers (Mariana Castilho & Derek Briggs) — "made for designers."
- Scrimba — interactive.

For developers learning design:

- Refactoring UI — "most popular."
- Thinking with Type (Ellen Lupton) — "about systems."
- Awwwards Academy — "taught by true masters."
- Animations on the Web (Emil Kowalski) — paid; the author subscribes.

Where the jobs are: designengineer.io — the dedicated design-engineer job board.

## When to use / When NOT to use

Use when:

- Classifying what KIND of design-engineering work a surface is — marketing, product, R&D, or founding. The classification sets the motion budget, the accessibility bar, and the code-quality bar before any pixel is drawn.
- Deciding whether a design decision needs real code: if the decision "can only be experienced in a medium" (interaction, motion, state), it must be decided in production-grade materials, not in a static comp.
- Scoping or self-positioning the role: what inputs a DE takes, what outputs they deliver, and which of the four jobs a posting actually describes.

NOT use when:

- The task is backend, data, or infrastructure — "engineer with design skills" still means the design-facing surface is the job.
- You're tempted to apply marketing-mode spectacle (3D, scroll-driven wow) to product surfaces: the essay's own words tie that mode to accessibility loss.
- R&D norms leak into shipping code: "draw quickly" is a prototyping license, not a production standard.

## How to apply (numbered checklist)

1. Classify the job before writing markup: marketing (conversion via wow), product (polish + design systems), R&D (speed), founding (breadth). State the classification; it determines everything below.
2. Product-mode default (most app UI): motion as feedback — 120–300ms, ease-out — built from design-system components; every animation must answer "what state changed?"
3. Marketing-mode budget: heavy motion, 3D, and scroll experiences only on surfaces where conversion beats convention — and ship a functional, accessible fallback (the essay's caveat, operationalized).
4. R&D-mode: timebox and throw away. Never let "It's the Wild West" code reach a repo with users.
5. Take designer inputs directly (user goals, brand, content) and deliver engineer outputs; skip the intermediate static-mockup pass when the open questions are experiential — prototype in the final medium.
6. When a design is unreachable by hand (complex states, generated art, data-driven visuals), build the tool that makes it possible — implication 5 is a mandate for leverage, not just polish.
7. Self-teaching plan: pick ONE designer-track and ONE developer-track resource from the stacks above; "dual-class" deliberately rather than sampling a generic full-stack curriculum.
8. Before writing a role profile or prepping for a DE interview, calibrate against live postings on designengineer.io.
9. Founding-mode (solo/small-team building): the remit is UX, growth, brand identity, and building at once — sequence them so each shipped surface feeds the next (site → core flows → growth loops); don't gold-plate one discipline while the product has no loop.

Mechanism for rule 2 (product-mode polish, reduced-motion safe):

```css
/* feedback motion: communicates a state change, 150–250ms, ease-out */
.menu { transition: opacity 180ms cubic-bezier(0.22, 1, 0.36, 1); }
.menu[data-open="false"] { opacity: 0; pointer-events: none; }

@media (prefers-reduced-motion: reduce) {
  .menu { transition: none; } /* state change stays, spectacle goes */
}
```

## AI-slop warning (how AI misapplies this primer)

- AI collapses the four jobs into one aesthetic: it applies marketing-mode spectacle (orbs, gooey gradients, scroll-jacking) to product surfaces where the essay asks for polish and design systems. If the job wasn't classified as marketing, strip the spectacle.
- AI reads "engineer with design skills" as "engineer who makes things look nice" and ships motion everywhere; the essay's product job is targeted polish ("adding polish through motion design and interactivity") plus maintaining systems — motion must communicate, not decorate.
- AI cites this essay to justify skipping design collaboration. The definition says a DE doesn't NEED designers to design — implication 3 still values communicating with and contributing to design work. Solo capability is not anti-collaboration.
- AI quotes the R&D skill list (Unity, Arduino, Processing) as web-stack advice. It describes a different job whose throwaway-quality norms must never touch production code.

## Relations

- desengs-de-essay — the designengineer.xyz definitional essay; same question answered institutionally. Use it for the design↔engineering bridge framing; use de-101 for the four-job taxonomy and the curated learning stack.
- desengs-becoming-de — the how-to-become-one path in depth; de-101 only names resources (CS50, Refactoring UI, etc.) and the "dual-classing" strategy — consult it before planning an actual curriculum.
- desengs-de-jobs — the market floor under this taxonomy: what companies post and pay for on designengineer.io, the very board Baytaş points to. Where de-101 describes four jobs, de-jobs shows which one employers actually name.
- desengs-front-of-the-front-end — Brad Frost's split of front-end work; his front-of skill list is the engineering half of Baytaş's equation. de-101 supplies the "with design skills" half and the medium argument for why that hybrid ships better UI.
