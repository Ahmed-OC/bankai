---
name: design-engineers-map
description: Use when you need to name the canonical practitioner for a design-engineering craft area (interaction detail, tools, research prototypes, interactive education) or map the discipline's implied skill set.
source: https://maggieappleton.com/design-engineers
category: reference
---

# A Collection of Design Engineers — the people who defined the discipline

Source: https://maggieappleton.com/design-engineers — Maggie Appleton, published March 2024. A curated essay-collection of ten people working at the design/engineering intersection, written to triangulate what "design engineer" actually means. No license stated; public essay.

## What it is / Why it exists

- Appleton collects people she knows who "work at the intersection of design and engineering" because the title is fuzzy and company-dependent. Her method: **define the role by example, not by job description**.
- Selection criteria, explicitly stated: everyone listed **works in public** (you can study their output), and several do not hold the "design engineer" title — they fit the definition, not the label.
- Built-in caveats to carry forward:
  - The list is non-exhaustive; many excellent design engineers (e.g., inside Apple) will never be publicly visible.
  - Public work misrepresents daily reality — shared artifacts are shiny results, not messy process, stakeholder wrangling, or legacy-code cleanup.
  - The title sits in a pile of overlapping labels (product designer, UX engineer, creative developer, front-of-front-end) that Appleton admits she does not fully understand either.
- Her self-assessment closes the essay: she is at most a "hobbyist design engineer." The collection is her measuring stick.

## The definition, triangulated from four essays the page cites

The page anchors the role on four external definitions — use the right one for the right argument:

1. **David Hoang, "Design Engineering"** (https://www.proofofconcept.pub/p/design-engineering) — the design engineer is someone who **prototypes at all levels of fidelity**: paper sketches through production code.
2. **Natalya Shelburne et al., the InVision "Design Engineering Handbook"** (2020, free PDF: https://marketing.invisionapp-cdn.com/www-assets.invisionapp.com/epubs/InVision_DesignEngineeringHandbook.pdf) — the hybrid who runs a full design process and ships it; argues a designer who cannot code is underutilised.
3. **Jim Nielsen, "The Case for Design Engineers"** (https://blog.jim-nielsen.com/2022/the-case-for-design-engineers/) — someone who can do **both design and code**, collapsing the designer-to-engineer handoff into one person.
4. **Trys Mudford, "I think I'm a design engineer"** (https://www.trysmudford.com/blog/i-think-im-a-design-engineer/) — works **somewhere between design and code**: part of the design process, part of the coding process; design-systems and prototyping work is the tell.

Working synthesis: runs the design loop AND implements the result, cycling between exploration, research, and live code in one skull.

## The roster: who to point to, and for what

Each entry: what they are known for, their signature technique (the thing to study), and when to invoke them.

### 1. Rauno Freiberg — the detail noticer
- Staff Design Engineer at Vercel; bio: "Crafting delightful experiences at Vercel."
- Known for the canonical **collection of interface details in the wild** — spotted micro-interactions like map pointers that gently trace streets, cursors that follow with eased delay, and interface sound design (notification chimes).
- Point to when: justifying time on micro-interaction polish; building a "craft" collection of your own; arguing details compound into perceived quality.
- Has a dedicated sibling skill: `rauno`.

### 2. Paco Coursey — the radical minimalist
- Webmaster at Linear (paco.me); bio self-describes as "webmaster, essayist, minimalist."
- Known for essays on digital minimalism and **obsessive text-level detail**: caret behavior experiments ("Caret № 1 — Max Length"), dynamic link drag images that render the URL being dragged.
- Point to when: removing things; stripping a UI to essentials without losing warmth; text-caret, selection, and cursor edge cases.
- Signature move: the caret and selection region treated as first-class design surfaces.

### 3. Szymon Kaliski — the tools-for-thought researcher
- Design Engineer at Replit; previously Ink & Switch.
- Known for **research-grade prototypes**: a research browser with multi-pane browsing and tree-like history, and Protoboard, "a breadboard for coding."
- Point to when: exploring alternative interface models (spatial history, associative navigation) rather than polishing conventional ones.

### 4. Amelia Wattenberger — the applied-AI R&D designer
- R&D at GitHub; bio: "I make the internet and write about it."
- Known for spinning up **Copilot for Docs** and prototyping an AI writing buddy; writes publicly about data visualization and emerging interaction patterns.
- Point to when: designing novel AI-native interfaces fast, at low fidelity, inside a big-org R&D context.

### 5. Andy Allen — the small-tools craftsman
- Founder of Not Boring Software.
- Known for **wireframe tooling** and a moon-phase widget rendered from a 3D model rather than static icon assets — computing the visual instead of drawing it.
- Point to when: deriving visuals procedurally (dates, phases, charts) instead of shipping asset sets; building small tools with outsized polish.

### 6. Alex Obenauer — the OS-level researcher
- Independent researcher collaborating with Ink & Switch.
- Known for his **"OS of the future"** explorations: associated items and user-created item views — questioning files, folders, and windows as primitives.
- Point to when: the interaction model itself is the research question; everything below the chrome is on the table.

### 7. Bret Victor — the meta-level
- Of worrydream and Dynamicland; famously "Inventing on Principle," "The Future of Programming," "Learnable Programming."
- Known for work like sonifying the logistic map — immediate, tangible media for thinking. Appleton flags him as **"much more than a design engineer"**: he operates at a level above UI, critiquing the medium itself.
- Point to when: the discipline needs its ceiling checked — what "representations that respond" could mean beyond screens.

### 8. Emil Kowalski — the component-and-transition teacher
- Design Engineer at Vercel; teaches component craft publicly.
- Known for **open-source components** and **state-based interaction detail** — e.g., buttons whose color shifts with interaction state; transitions bound to state changes, not canned keyframes.
- Point to when: making component libraries feel alive; teaching/learning motion as a property of state.
- Has a dedicated sibling skill: `emil-skills`.

### 9. Steve Ruiz — the master of the arrows
- Founder of tldraw; ex-Framer. Appleton's label: **"Master of the arrows."**
- Known for **impressively fluid drawing-tool interactions** — canvas physics, arrows, handles, snap; building the tool he designs in.
- Point to when: high-difficulty direct-manipulation surfaces (canvas, drag, snapping) where libraries stop helping.

### 10. Bartosz Ciechanowski — the interactive explainer
- Author of interactive explanatory essays — "Airfoil," "Sound," and peers — that blend custom-engineered simulation with careful visual and interaction design. Per Appleton, not a design engineer by profession, but the purest model of engineering in service of understanding.
- Point to when: interactive explanation is the goal — scroll-driven, manipulable simulations that teach mechanisms.

## Quick-reference: craft area → practitioner

| Need | Point to | Signature move |
| --- | --- | --- |
| Justify micro-interaction polish | Rauno Freiberg | Details-in-the-wild collection (`rauno`) |
| Text/caret/selection edge cases | Paco Coursey | Caret experiments, "Caret № 1 — Max Length" |
| Component libraries that feel alive | Emil Kowalski | State-bound transitions (`emil-skills`) |
| Canvas, drag, snapping surfaces | Steve Ruiz | Fluid drawing-tool physics ("Master of the arrows") |
| Procedural visuals instead of assets | Andy Allen | Moon widget rendered from a 3D model |
| Alternative navigation/history models | Szymon Kaliski | Tree-like history, multi-pane research browser |
| Question files/folders/windows themselves | Alex Obenauer | "OS of the future," associated items |
| AI-native interface R&D | Amelia Wattenberger | Copilot for Docs, AI writing buddy |
| Interactive explanation / education | Bartosz Ciechanowski | "Airfoil," "Sound" simulation essays |
| Ceiling-check the medium | Bret Victor | Immediate, tangible media for thinking |

## The patterns across the collection

- **Employer concentration**: Vercel, Linear, The Browser Company, Replit repeatedly appear — companies that deliberately cultivate design-engineer hybrids by valuing interface detail. Three of ten listed are in the Vercel/Linear orbit.
- **Everyone works in public**: the discipline's medium is not just the product but the demo, essay, collection, and open-source component. Studying output beats reading job specs.
- **Five output archetypes** (use this as the lookup axis):
  1. Product polish (Freiberg, Coursey, Kowalski) — detail work inside a shipped product.
  2. Tool builders (Ruiz, Allen) — construct the instrument they design with.
  3. Research prototypers (Kaliski, Obenauer, Wattenberger) — new interaction models, low fidelity, fast iteration.
  4. Interactive educators (Ciechanowski) — engineered explanation.
  5. Meta-level vision (Victor) — critique of the medium itself.
- **Backgrounds recur**: self-taught hybrids, design-systems practitioners, ex-agency/creative-dev, research-lab adjacency (Ink & Switch appears twice). No credential pattern — the pattern is output.

## The implied curriculum

What the roster, read together, says a design engineer must be able to do:

1. **Micro-interaction literacy**: carets, cursors, drags, hover states, sounds — treat them as designed surfaces (Freiberg, Coursey).
2. **State-based motion**: animate between component states, driven by data, not bolted-on keyframes (Kowalski).
3. **Prototyping at all fidelities**: sketch → interactive mock → production code, alone, same day (Hoang's definition, visible in Wattenberger's practice).
4. **Systems thinking**: design tokens, component libraries, and consistency infrastructure are the role's home turf (Mudford; the Vercel/Linear cohort).
5. **Procedural visual generation**: compute visuals from models and data instead of authoring assets (Allen's moon widget; Ciechanowski's simulations).
6. **Hard interaction engineering**: canvas, direct manipulation, snapping, physics — where off-the-shelf components end (Ruiz).
7. **Exploratory interface research**: question navigation, files, and windows as primitives; prototype alternatives cheaply (Kaliski, Obenauer).
8. **Working in public**: collections, essays, open-source components, demos — the field's publication unit and how its reputation compounds.

## When to use / When NOT to use

Use when:
- Asked "who does X well" or "whose work should I study for Y technique" — resolve via the archetype axis, then the person.
- Defining, hiring for, or self-assessing against the design-engineer role (the four-essay triangulation is the argument kit).
- Building a learning plan or curriculum for interface craft — the eight-point curriculum above is the syllabus.
- Deciding whether a task (unusual interaction, tool, explorable explanation) warrants design-engineer treatment rather than standard component work.

Do NOT use when:
- You need visual specs — this source contains no measurements, tokens, or code; it is a map of people, not a pattern library.
- You want an exhaustive directory — ten names, explicitly non-exhaustive; absence from this list is not a judgment.
- You are choosing an aesthetic — ten people here have ten different signatures; there is no house style to copy.

## How to apply (numbered checklist)

1. Classify the task into one of the five archetypes (polish / tools / research / education / meta).
2. Look up the matching practitioner above and pull their signature technique as the concrete model.
3. If the person is Freiberg or Kowalski, load the dedicated sibling skill (`rauno`, `emil-skills`) for their distilled mechanics.
4. Convert their technique into a buildable mechanism (state machine, eased transform, procedural render) before writing any code — name the mechanism after the move you borrowed.
5. For role-definition debates, pick the essay (Hoang / Shelburne / Nielsen / Mudford) that matches the stakeholder's frame and cite it.
6. Copy the *practice*, not the *artifact*: ship the detail work in public (demo, screenshot, collection entry), because that is how this discipline demonstrates quality.

## AI-slop warning

- The classic AI misuse is **name-dropping as aesthetic justification** — saying "Rauno-style" or "Vercel-polished" while shipping generic output. Every person in this roster is defined by an *implemented mechanism* (caret behavior, state-bound transitions, procedural rendering), not a vibe. If you cannot name the mechanism, do not cite the name.
- Second misuse: imitating surface signatures piecemeal — Paco's minimalism without his detail work reads as empty; Ciechanowski's scroll-interaction pattern without a real simulation reads as gimmick. The patterns here are load-bearing: borrow them whole or not at all.
- Third misuse: treating "design engineer" as a title to sprinkle into copy. Appleton's whole essay is about how fuzzy the title is; only invoke it when the both-design-and-code capability is the point.

## Relations

- `rauno` — roster member #1's own distilled craft: the interface-detail collection turned into concrete mechanisms; load after pointing to Freiberg here.
- `emil-skills` — roster member #8's component and state-transition techniques in executable form; the applied counterpart to his entry above.
- `rise-of-de` — the historical/market narrative of the discipline's emergence; this map supplies the people, that skill supplies the timeline.
- `de-attributes` — a competency-by-competency attribute list for the role; pairs with this skill's eight-point implied curriculum.
- `ui-ux-canon` — the umbrella canon this map feeds; consult it to route from a person to the specific technique skills in the canon.
