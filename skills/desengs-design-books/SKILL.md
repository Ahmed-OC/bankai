---
name: desengs-design-books
description: Use when a design decision or critique needs canonical grounding. The 100-book design canon (Tufte, Norman, Bringhurst, Kholmatova, Rams) mapped by theme, each with the one steal-able idea.
source: https://designbooks.org/
category: reference
---

# Design Books (desengs) — the canon of design reading, mapped

Source: https://designbooks.org/ (301 → https://design-books.com/) — curated by Bridger Tower (bridger.to / wipdes.com). 100 books, filterable by 19 topics (Brand Identity, Color, Content Design, Creative Practice, Design History, Design Research, Design Systems, Design Theory, Graphic Design, Inclusive Design, Information Design, Product Design, Professional Practice, Service Design, Systems Thinking, Typography, Usability and UX, Visual Perception). One page per book: one-line summary, publisher · year · pages · ISBN, topic tags, "Why it matters", "Best for", "What you'll learn", related books. No license stated. The canon below adds each book's steal-able core idea to the site's own summaries and metadata.

## What it is / Why it exists

A curated reading list for "product, interaction, and visual designers studying usability, systems, typography, research, and the craft of making useful things." It exists to compress the design literature into a defensible shelf: every recurring design argument traces to a book here. Use this skill to (a) pick the right canonical citation for a decision, (b) apply the book's core mechanism without reading it, (c) know which sources carry weight with designers. Scoping note: this canon overlaps but is not identical to older engineering canons — Mullet/Schafer's *Designing Visual Interfaces* and Lidwell's *Universal Principles of Design* are NOT on the list; Tidwell's *Designing Interfaces* and Pereyra's *Universal Principles of UX* fill those slots.

Reading priority for interface work: Usability/interaction > Systems > Information > Typography > Perception > Color > Words > Research > Inclusion > Service; practice and history books inform judgment, not markup.

## The core ideas — the canon mapped (100 books)

Entry format: **Book** — Author (year, pages): the one idea to steal.

### Usability and interaction behavior (13)

- **The Design of Everyday Things** — Don Norman (2013, 368p): errors are design failures — "design for error"; every control needs a visible signifier, immediate feedback, and natural mapping (layout mirrors effect). Users act in seven stages; the gulfs of execution and evaluation are what you must bridge.
- **Don't Make Me Think** — Steve Krug (2014, 216p): every screen must be self-evident in the first glance; users scan, satisfice, and never read. Testing one user beats zero; 3–5 users per round, one morning a month, catches most friction.
- **About Face** — Cooper, Reimann, Cronin, Noessel (2014, 720p): goal-directed design — design for enduring user goals, not feature requests; a persona is a stand-in for researched behavior. If a dialog asks a question the system could answer itself, answer it.
- **The Humane Interface** — Jef Raskin (2000, 256p): modes are the root of interaction error — eliminate them or make the current mode impossible to miss; design for habituation (users automate, so consistency beats novelty); you can only manage the user's single "locus of attention".
- **Emotional Design** — Don Norman (2004, 272p): three processing levels — visceral (instant look), behavioral (use), reflective (memory, identity, story). Design and test each layer separately; beauty at the visceral layer buys forgiveness at the behavioral one.
- **Living with Complexity** — Don Norman (2010, 312p): confusion, not complexity, is the enemy — don't strip capability, supply a clearer conceptual model plus consistent structure and signifiers to make the complex comprehensible.
- **Laws of UX** — Jon Yablonski (2020, 152p): cognitive laws with numbers — feedback under 400ms (Doherty), fewer options (Hick), bigger nearer targets (Fitts), match familiar patterns (Jakob). Cite the law AND the value it dictates.
- **Universal Principles of UX** — Irene Pereyra (2022, 224p): treat every interface pattern as a hypothesis about psychology — pair the pattern with the principle that predicts it works; spans research, psychology, and interface patterns in one index.
- **User Friendly** — Cliff Kuang & Robert Fabricant (2019, 416p): "user-friendly" was invented under wartime human-factors pressure — every convention encodes a past failure; breaking a convention needs evidence equivalent to the accident data that created it.
- **Designing Interfaces** — Tidwell, Brewer, Valencia (2020, 602p): before inventing an interaction, name the known pattern (navigation, input, feedback, layout); patterns are half-finished solutions you complete in context, not recipes to paste.
- **Shikake** — Naohiro Matsumura (2020, 168p): shape behavior with the object and its context (defaults, placement, affordance) before adding copy or instruction; the best trigger invites action without explaining itself.
- **Sketching User Experiences** — Bill Buxton (2007, 448p): sketches are quick, cheap, disposable, plentiful, and deliberately ambiguous; prototypes resolve questions, sketches multiply them. Explore breadth-first; high fidelity signals commitment you don't yet have.
- **The Laws of Simplicity** — John Maeda (2006, 128p): "the simplest way to achieve simplicity is through thoughtful reduction" — reduce first; then organize (grouping); when you can't remove, hide (progressive disclosure) and embody (make remaining complexity feel like quality: SHE).

### Systems, grids, and structure (10)

- **Grid Systems in Graphic Design** — Josef Müller-Brockmann (1981, 176p): the grid is an ordering service to the reader — invisible but felt; decide column/field count from the content's variety (more partitions = more flexibility, less order); every element snaps to the grid.
- **Atomic Design** — Brad Frost (2016, 154p): compose UI from five nested levels — atoms → molecules → organisms → templates → pages; design the system by composing parts, and let only the final "pages" level carry real content, never lorem ipsum.
- **Design Systems** — Alla Kholmatova (2017, 288p): a design system is interconnected patterns + shared practices, built from the product's purpose; distinguish functional patterns (what users do) from perceptual patterns (how it looks, sounds, feels); define pattern boundaries from team need, not completeness.
- **Designing Programmes** — Karl Gerstner (2007/1964, 120p): don't design instances, design the program — the rules (grid, type scale, combinatorial variants) that generate instances. The 1964 ancestor of design tokens and parameterized components.
- **A Pattern Language** — Alexander, Ishikawa, Silverstein (1977, 1171p): 253 named patterns, each problem + context + solution, each linking to larger and smaller patterns. The origin of UI "design patterns": capture solutions as named, cross-referenced, multi-scale patterns.
- **Notes on the Synthesis of Form** — Christopher Alexander (1964, 216p): design = achieving fit between form and context; enumerate the "misfits" (where the design fails its context) and decompose them into independent sub-problems instead of intuiting one monolithic solution.
- **Thinking in Systems** — Donella Meadows (2008, 240p): stocks, flows, feedback loops, delays; 12 leverage points ranked — parameters are weakest, information flows, rules, and goals are strongest. Intervene at the loop, not the pixel.
- **A Philosophy of Software Design** — John Ousterhout (2021, 196p): complexity is anything making software hard to change (dependencies + obscurity); prefer few deep modules — small interface, much behavior — over many shallow ones; hide implementation behind narrow public surfaces.
- **Passenger Information System (Swiss Railways manual)** — Josef Müller-Brockmann (2026 ed., 220p): a nation-scale public interface run on one grid, few type sizes, and pictograms; signage legibility is a function of viewing distance and reading speed — size type in modules tied to where the reader stands.
- **IBM: Graphic Design Guide 1969–1987** — Paul Rand (2018, 288p): rules are part of the identity — clear space, minimum sizes, do/don't usage made the system durable across media for two decades. A logo without usage rules is not a system.

### Information and data display (6)

- **The Visual Display of Quantitative Information** — Edward Tufte (2001, 197p): maximize data-ink (erase non-data ink within reason), delete chartjunk, keep the lie factor ≈ 1 (size of effect shown / size of effect in data); tables often beat charts for small datasets.
- **Envisioning Information** — Edward Tufte (1990, 126p): escape flatland by layering — and remember 1+1=3: two elements create a third perceived thing, the space between; separate with subtle contrast, not heavy boxes; micro/macro: dense detail read at two scales.
- **Beautiful Evidence** — Edward Tufte (2006, 214p): sparklines — data at the size of a word, inline with running text; every graphic must map to a claim; evidence quality is a design property (comparison, causality, documentation).
- **Information Visualization: Perception for Design** — Colin Ware (2019, 560p): encode the key comparison as a preattentive pop-out — one hue, orientation, or size change is detected in ~200ms, before conscious attention; design "visual queries" the eye can answer instantly.
- **The Functional Art** — Alberto Cairo (2012, 256p): a visualization must answer a stated reader question — form follows function; the "functional art" tension: beauty serves comprehension, never replaces it.
- **How to Make Sense of Any Mess** — Abby Covert (2014, 176p): most "layout problems" are language problems — agree the ontology (what things mean) before the taxonomy (how they group) before any arrangement; name stuff consistently.

### Typography (4)

- **The Elements of Typographic Style** — Robert Bringhurst (2012, 398p): "typography exists to honor content" — set for continuous reading first: measure 45–75 characters per line, even word spacing, vertical rhythm derived from the type's own proportions; the reference for every typographic value.
- **The New Typography** — Jan Tschichold (2006/1928, 288p): "the essence of the New Typography is clarity" — asymmetric layout as functional movement (vs. static centered axis), sans-serif for utility, every choice justified by communication, zero ornament.
- **Typography: A Manual of Design** — Emil Ruder (1967, 274p): contrast (size, weight, direction, space) is the root of typographic expression; design the white — counters, margins, and interline are material, not absence.
- **Thinking with Type** — Ellen Lupton (2010, 224p): "type is what language looks like" — three practical jobs: letters (choose a family), text (spacing: never letter-space body text), grid (align everything); the most beginner-applicable manual.

### Visual perception and form (11)

- **Art and Visual Perception** — Rudolf Arnheim (1974, 508p): perceiving IS thinking; every composition exerts perceptual forces (weight, direction) — balance is psychological, not geometric; nothing on a page is neutral.
- **Visual Thinking** — Rudolf Arnheim (1969, 352p): reasoning happens in images; abstraction is perception's core operation — the screen is the user's thinking substrate, and a concrete depiction can be more abstractly graspable than prose.
- **A Primer of Visual Literacy** — Donis A. Dondis (1973, 194p): the visual alphabet — dot, line, shape, direction, tone, color, texture, dimension, scale, movement — and three representational modes (representational, abstract, symbolic); choose the mode deliberately per element.
- **Principles of Form and Design** — Wucius Wong (1993, 352p): systematic relational operations — repetition, similarity, gradation, radiation, anomaly, concentration; build an ordered field, then break it exactly once (anomaly only registers against order).
- **Visual Grammar** — Christian Leborg (2006, 96p): a compact syntax of objects, structures, relations, and activities — name which you are manipulating, and critique becomes precise ("that's a proximity relation, not shape similarity").
- **Graphic Design Manual** — Armin Hofmann (1965, 180p): composition trained as contrast pairs (point/line/plane, big/small, light/dark); economy of means — fewest elements, maximum contrast, nothing decorative.
- **Graphic Design: The New Basics** — Lupton & Cole Phillips (2015, 264p): the contemporary fundamentals include screen-native moves — layers, transparency, modularity, and time/motion as basic design elements, not print afterthoughts.
- **The Vignelli Canon** — Massimo Vignelli (2010, 112p): "if you can design one thing, you can design everything" — semantic correctness, syntactic consistency, pragmatic comprehensibility; a lifetime's work on a handful of typefaces; discipline as elegance.
- **Thoughts on Design** — Paul Rand (2014/1947, 96p): the symbol is the memorable unit; wit — one visual idea carrying both form and meaning — is what makes design stick; graphics must integrate with total design, not decorate it.
- **Design as Art** — Bruno Munari (2008/1966, 224p): design serves everyday life — useful things made beautiful without becoming precious art objects; playfulness (Munari's "extras") is a legitimate design method.
- **Designing Design** — Kenya Hara (2007, 472p): emptiness is not absence but potential — a vessel's power comes from its emptiness; design the empty state, the pause, and the container that awaits the user's content, not just the filled one.

### Color (5)

- **Interaction of Color** — Josef Albers (2013/1963, 208p): "in visual perception a color is almost never seen as it really is" — color is relational; never pick in isolation, test in situ; when colors must be distinguishable, vary lightness, not just hue.
- **A Dictionary of Color Combinations Vol. 1** — Sanzo Wada (2010/1930s, 352p): 348 researched combinations — proven pairings beat wheel-generated ones; lift complete harmonized palettes (with print values) instead of inventing.
- **A Dictionary of Color Combinations Vol. 2** — Sanzo Wada (2020, 336p): the sequel's seasonal palettes drawn from fashion, interiors, and graphics — the same steal, oriented to seasonal/mood variation.
- **Color Problems** — Emily Noyes Vanderpoel (2018/1903, 396p): extract palettes by gridding a subject and abstracting its color proportions — color systems from observation, 80 years before "data-driven palettes".
- **The Designer's Dictionary of Color** — Sean Adams (2017, 256p): each hue with associations, history, and working palettes — choose color with intent: check connotations and proven pairings before settling.

### Research (4)

- **Just Enough Research** — Erika Hall (2013, 154p): replace the opinion fight with the smallest study that answers the question; research is for knowing, not proving; separate observation from interpretation.
- **Interviewing Users** — Steve Portigal (2023, 176p): ask about past behavior, never opinions or hypotheticals ("would you use X?" is worthless); silence is an instrument — ask, then wait.
- **Mental Models** — Indi Young (2008, 299p): diagram interview data into task-space towers, then align product features next to them — the gaps between the user's model and the product's surface are your defect roadmap.
- **The User Experience Team of One** — Leah Buley (2013, 246p): solo methods that scale — guerrilla usability (3–5 users, paper), rapid sketching, and show-don't-tell artifacts to win buy-in.

### Words are UI (3)

- **Writing Is Designing** — Michael J. Metts & Andy Welfle (2020, 200p): words are design material — draft the interface copy (buttons, errors, empty states) BEFORE layout; the words define the screen; voice consistency is design consistency.
- **Strategic Writing for UX** — Torrey Podmajersky (2025, 280p): one concept = one word everywhere (lock terminology); write from the pattern library so each component has one voice; measure copy by comprehension, not preference.
- **Content Design** — Sarah Winters & Rachel Edwards (2024, 176p): publish only what answers a stated user need, then cut until the need is met with the fewest words; research-driven content over stakeholder prose.

### Inclusion and ethics (6)

- **Mismatch** — Kat Holmes (2018, 176p): exclusion is a mismatch between person and design; use the permanent → temporary → situational spectrum (one arm: amputation, injury, holding a baby) — solving edge mismatches improves the mainstream (captions).
- **Inclusive Design for a Digital World** — Reginé M. Gilbert (2025, 564p): bake the numeric criteria into the design system itself (4.5:1 text contrast, target sizes, semantic markup expectations) instead of remediating screens later.
- **Design Meets Disability** — Graham Pullin (2011, 368p): eyeglasses became fashion — assistive products deserve consumer-grade ambition; there is no "medical beige" exemption from good design, and disability design feeds mainstream taste.
- **The Politics of Design** — Ruben Pater (2016, 192p): design is never neutral — audit defaults for cultural encoding: hand gestures, "flesh" tones, map projections, iconography that excludes.
- **Design Justice** — Sasha Costanza-Chock (2020, 360p): design allocates power; involve the people affected as co-designers ("nothing about us without us"), not as test subjects — ask who is harmed by the default.
- **Design for the Real World** — Victor Papanek (2019/1971, 416p): design's first duty is to human needs and ecological limits — the founding text for asking what deserves to be built at all.

### Service and orchestration (4)

- **Good Services** — Lou Downe (2019, 224p): fifteen principles for services that work — services are judged end-to-end by outcome achieved, not by screens; name the service in the user's language and test the whole journey, including the steps you don't own.
- **Mapping Experiences** — James Kalbach (2020, 440p): alignment diagrams put the customer journey and the organization on one artifact — the front-stage/back-stage gaps are exactly where experience breaks.
- **Orchestrating Experiences** — Chris Risdon & Patrick Quattlebaum (2018, 336p): inventory every touchpoint across channels before optimizing any single screen; orchestrate the hand-offs between them.
- **This Is Service Design Doing** — Stickdorn, Hormess, Lawrence, Schneider (2018, 568p): the standard canvases (stakeholder map, journey, blueprint, persona) as facilitation artifacts — the value is the shared artifact a team aligns on.

### Craft and creative practice (6)

- **The Shape of Design** — Frank Chimero (2012, 131p): design is a conversation — "how it feels over time" beats "how it looks at first sight"; work generously (give more than the brief asked); the process's shape determines the output's.
- **Creative Confidence** — Tom Kelley & David Kelley (2013, 304p): creativity is practiced, not innate — run small experiments (not big bets) to build creative confidence in yourself and stakeholders.
- **The Creative Act: A Way of Being** — Rick Rubin (2023, 432p): attention is the raw material — reduce inputs, increase noticing; ship work as an offering, not a verdict; the result is a byproduct of practice.
- **The War of Art** — Steven Pressfield (2012, 190p): Resistance (fear dressed as procrastination) is beaten by turning pro — show up daily at a fixed time; finishing is the skill.
- **It's Not How Good You Are, It's How Good You Want to Be** — Paul Arden (2003, 128p): "do not seek praise, seek criticism"; ambition and energy sell ideas more than polish does.
- **Design Is a Job** — Mike Monteiro (2012, 135p): the craft includes the contract — scope, money, presenting, and the professional duty to say no are design tools, not overhead.

### Rams (2)

- **Less and More: The Design Ethos of Dieter Rams** — Rams, Klemp, Ueki-Polet (2015, 808p): "Weniger, aber besser" — less, but better; the ten principles ("good design is as little design as possible"); restraint is the visible surface of ruthless engineering discipline.
- **Dieter Rams: The Complete Works** — Klaus Klemp (2020, 344p): the archive behind the ethos — systems thinking in physical products (one shelving system fitting every home = components with a fixed interface, decades before design systems).

### Identity, history, archives, and adjacent crafts (26 — compressed)

- **1,000 Marks** — Pentagram (2024, 1008p): a mark is reduction to memory — judge logos by silhouette alone.
- **Architectural Logos** — Counter-Print (2019, 108p): structural forms as identity vocabulary.
- **Logo Beginnings** — Jens Mueller (2022, 432p): how identity marks formed through industry — provenance beats novelty.
- **Logo Modernism** — Jens Müller & R. R. Remington (2015, 432p): the modernist mark grammar — geometry, reduction, grid.
- **Logo Design Love** — David Airey (2014, 240p): identity is process — research → concept → present → durable mark.
- **Identity Designed: The Process** — David Airey (2024, 240p): strategy connects to refinement; present rationales, not just images.
- **A *New* Program for Graphic Design** — David Reinfurt (2019, 256p): fundamentals taught as generative exercises, not style history.
- **Meggs' History of Graphic Design** — Meggs, Purvis, Maxa, Sanders (2025, 704p): the survey — where your conventions come from.
- **Swiss Graphic Design** — Richard Hollis (2006, 272p): objectivity, grid, sans-serif as a house style — the origin story of most UI defaults.
- **Japanese Graphic Design** — Wang Shaoqiang (2023, 272p): an alternate modernity — restraint from a different tradition.
- **Ways of Seeing** — John Berger (1990/1972, 176p): "seeing comes before words" — images are constructed; reproduction changes meaning; audit what your imagery assumes.
- **The Art of Looking Sideways** — Alan Fletcher (2001, 1064p): a fragment collection — raw material for ideas is gathered constantly, not summoned.
- **The Design Book** — Phaidon (2013, 544p): influential objects survey — longevity is a design metric.
- **The Language of Graphic Design** — Richard Poulin (2011, 288p): principle vocabulary for clearer critique.
- **Design for Communication** — Elizabeth Resnick (2003, 264p): hierarchy, layout, symbol — message before expression.
- **Massive Change** — Bruce Mau (2004, 240p): design now operates at systems scale — economies, cities, culture — not objects.
- **Donald Judd: Artworks 1970–1994** — Donald Judd (2022, 284p): proportion, repetition, material — the arithmetic of space you can feel.
- **The Measure of Man and Woman** — Alvin R. Tilley / Henry Dreyfuss Associates (2001, 104p): anthropometric percentiles — design for the 5th–95th, not the average (which fits nobody).
- **The Fashion Design Reference & Specification Book** — Calderin & Volpintesta (2013, 288p): process/materials vocabulary from an adjacent craft.
- **The Industrial Design Reference & Specification Book** — Cuffaro & Zaksenberg (2013, 272p): manufacturing and ergonomics constraints — form follows process.
- **Abloh-isms** — Abloh & Warsh (2021, 142p): quotation-style thinking — design as remix, in the author's words.
- **Virgil Abloh. Icons** — Virgil Abloh (2021, 352p): the "3% rule" — modify a classic minimally (about 3%) and it reads as both familiar and new.
- **Virgil Abloh: Figures of Speech** — Darling & Abloh (2022, 496p): cross-disciplinary authorship — signage, fashion, and brand systems as one practice.
- **Make It Ours** — Robin Givhan (2025, 336p): who gets to be an author — access, taste, and the systems around design.
- **Know Your Onions: Graphic Design** — Drew de Soto (2013, 192p): studio working habits — layout, type, production discipline.
- **Work for Money, Design for Love** — David Airey (2012, 288p): career mechanics — clients, positioning, saying no.

## When to use / When NOT to use

Use when: justifying a design decision with a canonical source; naming the pattern or principle behind a proposed interface; writing design critique or documentation that cites the literature; building a reading path for a team; deciding which book's method to apply (e.g. misfit decomposition vs. journey mapping vs. pattern language); checking whether a claimed "classic" is actually in the canon.

Do NOT use: as a substitute for the sibling skills that operationalize a single source (laws, typography, guidelines carry the exact values); as decoration in commit messages or PRs — cite only when the citation changes a decision; for pixel-level values the books don't give (Bringhurst gives measures, not CSS); to settle matters the canon contradicts itself on (Rams' as-little-design-as-possible vs. Munari's playful richness — pick per context, don't cherry-pick authority).

## How to apply

1. Before citing: confirm the book is on the list above; if it isn't, either drop the citation or mark it "outside the canon" (Mullet/Schafer and Lidwell are outside it).
2. Match decision → source: behavior/timing/option counts → Norman, Krug, Raskin, Yablonski; data display → Tufte, Ware; system structure → Gerstner, Alexander, Frost, Kholmatova, Ousterhout; typography → Bringhurst, Ruder, Tschichold, Lupton; color → Albers + Wada + WCAG numbers; copy → Metts/Welfle, Podmajersky, Winters; inclusion → Holmes, Gilbert, Pater; research gaps → Hall, Portigal, Young.
3. Cite as: book — author — the one idea — the decision it justifies now. Never cite a book for an idea it doesn't contain.
4. Steal the mechanism, not the mention: convert each idea into a rule with a number where the book gives one (45–75ch measure; lie factor ≈ 1; ~200ms pop-out; 348 palettes; 5th–95th percentile; feedback <400ms per Yablonski on this same list).
5. Building a system: Gerstner (write the program) → Alexander (name the patterns) → Frost (compose five levels) → Kholmatova (purpose + functional/perceptual split) → Rand/IBM (usage rules make it durable).
6. Designing a flow: write the copy first (Metts/Welfle), sketch many cheap variants (Buxton), pick by goal fit (Cooper), eliminate modes (Raskin), then test the whole journey (Downe, Kalbach).
7. Critiquing data display: check data-ink, lie factor, chartjunk, and whether the key comparison is preattentive (Tufte + Ware) before checking aesthetics.
8. Choosing color: test relations in situ (Albers), prefer proven combinations (Wada), verify lightness separation and 4.5:1 text contrast (Gilbert/WCAG).
9. Auditing inclusion: run the permanent/temporary/situational spectrum (Holmes), audit cultural defaults (Pater), involve affected users as co-designers (Costanza-Chock).
10. When stuck, decompose: enumerate misfits and split into independent sub-problems (Alexander, Notes) — before adding any new element (Maeda: reduce first).

## AI-slop warning

Typical AI misuse of this canon: name-dropping without applying — "as Tufte says" next to a 3D gradient pie chart (chartjunk, lie factor > 1); citing Norman while blaming "user error" (the book's thesis is the opposite); invoking Rams' minimalism to strip affordances and hierarchy ("as little design as possible" refers to decoration, never to legibility); quoting Maeda's "thoughtful reduction" while hiding core features three menus deep (that's hiding without embodying); citing "7±2" as a nav-item cap — banned by the Laws of UX entry itself and absent from this canon; citing Mullet/Schafer or Lidwell as canon (not on the list); padding reviews with Rubin/Pressfield quotes in engineering contexts where they change no decision; summarizing a book's topic instead of stealing its rule — "the one idea to steal" means a mechanism with a number or a ban, not a book-report sentence. Any citation that does not change a concrete value, pattern choice, or deletion should be cut.

## Relations

- **desengs-laws-of-ux** — Yablonski's *Laws of UX* is itself entry #47 of this canon; the sibling skill carries the full per-law detail (numbers, origins) behind the book.
- **desengs-practical-typography** — operationalizes Bringhurst, Ruder, and Lupton for the web with exact CSS-grade values (measure, leading 120–145%), which the books state in print terms.
- **desengs-principles** — the principles canon pairs with Pereyra's *Universal Principles of UX* entry; use it for the principle taxonomy, this skill for the source and author.
- **desengs-rams** — the ten principles behind the *Less and More* / *Complete Works* entries, expanded into interface terms.
- **desengs-ui-ux-master** — the canon index; routes here whenever a decision needs a citable authority rather than a mechanism.
