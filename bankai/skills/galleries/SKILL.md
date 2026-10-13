---
name: galleries
description: Use when deciding what great UI looks like or what to imitate. Distills three curated galleries (107 inspiration sites, 188 minimal sites, 72 designers) into two taste profiles plus a calibration protocol.
source: https://desengs.com/inspiration; https://desengs.com/minimum; https://desengs.com/dsgnrs/list
category: reference
---

# Galleries — what gets curated as great, and why

Source: the three self-published directories of https://desengs.com/ — `/inspiration` ("The Daily WebDesign Inspiration", 107 sites, browse filters: Serendipity / Portfolios / OG Images), `/minimum` ("The Directory of Super Minimal Websites", 188 sites by its own meta description; 192 listings once re-featured sites are counted), `/dsgnrs` ("DSGNRS: Exceptional Designers to Follow", 72 designers). Curated by Maze Heart (@remvze), refreshed monthly. These are link directories, so no license constrains distillation; everything below comes from the actual entry lists, their add-dates, and the pages' own framing copy.

## What it is / Why it exists

The curated galleries are the one place where the curator's taste is stated *extensionally* — as concrete lists of sites and people — rather than as rules. That makes them the canon's calibration reference: when an agent asks "what does great look like", the answer is a reference class with named members, not adjectives.

Structural facts that encode judgment (verified in the pages' own markup):

- **Curation cadence.** `/minimum` was seeded April 2025 with 110 sites in one drop, then refreshed monthly (19 in 2026-07, 24 in 2026-08, 12 in 2026-09, 8 in 2026-10). `/inspiration` launched December 2025 with 38 sites, then monthly drops (11 in 2026-02, 6 in 2026-03, 18 in 2026-07, 22 in 2026-08, 4 in 2026-09, 8 in 2026-10). These are 2025–2026 sites, not a 2019 award-show time capsule.
- **Two screenshot grammars.** Inspiration detail pages capture the full viewport at `aspect-ratio: 1920/1080` — a site qualifies if it composes as a single cinematic frame. Minimum detail pages crop to `aspect-ratio: 1/1` — a site qualifies if its typography survives being seen as a square specimen card.
- **The judge's own house.** The source site runs Geist (sans) + IBM Plex Mono + Instrument Serif (display) on near-black `#09090b` with `#fafafa` text, a modular type scale (×1.2 up, ÷1.125 down), a 600px text column, 1px hairline borders on screenshots, and exactly one motion: `transition: transform .2s` with `hover: scale(1.025)`. The site is a de facto member of its own minimum list.

## The core ideas

### 1. The Inspiration profile — the same taste with a full budget

The directory's own criteria, verbatim from its meta description: "exceptional **visual design, typography, interaction, and creative development**". Four axes — and note the fourth: code craft is explicitly judged, not just the rendered surface. Its browse filters are Serendipity / Portfolios / **OG Images** — share-card craft counts as part of the design.

Cluster census of the 107 entries:

- **Studios and agencies (~20; `.studio` is the #2 TLD at 9):** WØRKS, STAGECREW, Voku.Studio, VAP, Studio Linear, ATIO, New Genre, Posse Agency, NOUN, NoGood, Signal-A Studio, Brikken+Co, Adcker, Offsite, Unknown Untitled, giallo.studio, Double You Management, Twofold.
- **Individual portfolios (~16):** Tikhon Belousko, Hélène del Marmol, M.A. Baytaş, Pacôme Pertant, Ben Mingo, Davide Baratta, Tatsiana Shevarenkova, Daniel Herzog, Gio Pandone, Miller McCormick, T for Troels, seb-astian, Ofri Cohen, Jason Bergh, Luisa Ruzzenenti, Hugo Baron (nuageboi.fr).
- **A typography-led French cluster (~10; `.fr` ×5 plus French studios on `.com`):** trulytype.com, Lift Type, Claude Type, Habillage Graphique, Caractère Bois, DEADWATER, Caso Patrimoine, L'Étude, The Design Society. Editorial typography treated as the product itself.
- **AI / dev-tool products (~30; `.ai` ×7):** Dub, Neon, Langbase, Relace, Rig, Giga, Anima, Ploy, Cosmos, Moonbeam, Tars, Antimetal, Lightspark, Griffin, Portal, Melius, Maito, Daylight, Primora, Berd, Galaxy, Plnty, Humble, Interfere, Quo, Figma Weave.
- **Cultural institutions (3):** Museo Cappella Sansevero, NTGent, Studio Museum in Harlem.
- **Luxury / brand (3):** Le Mans Classic (Richard Mille), SSENSE XX, Infinite Machine.

What the clusters share, concretely: expressive display typography (serif/grotesk contrast, oversized scales), art-directed photography, scroll-driven or WebGL motion, custom transitions, and at least one signature interaction per site. The dominant genre is the **portfolio** — enough that "Portfolios" is its own filter. Generic SaaS landing pages are a minority and get in only when they behave editorially (Dub, Neon, Lightspark).

One exemplar per cluster, with the specific thing it is curated for:

| Site | What to study on it |
| --- | --- |
| jetset.nl (Experimental Jetset) | uppercase-only grotesk as an entire brand system; grid as visual identity |
| trulytype.com / Lift Type | the type-specimen site as product: scale contrast, specimen interactions |
| works.studio (WØRKS) | studio portfolio as editorial object; image choreography over scroll |
| dub.co | dev-tool marketing that stays typographic and fast instead of gradient-heavy |
| lemansclassic.richardmille.com | luxury craft translated to web: full-bleed imagery, restrained UI chrome |
| weave.figma.com | product microsite with a single signature motion idea carried throughout |

### 2. The Minimum profile — the same taste at zero budget

The directory's own criteria, verbatim: "**restrained typography, thoughtful layouts, and clear visual design**", under the headline "Super Minimal Websites". Three legs — type restraint, layout thought, clarity — minimalism defined as *craft of reduction*, not absence.

Census of the 188: overwhelmingly **single-person sites**. TLD spread: `.com` 81, then the indie long tail — `.dev` 11, `.co` 9, `.io` 7, `.design` 7, `.me` 6, `.studio` 5, `.xyz`/`.so`/`.in` 4 each, `.is`/`.cv` 3 each. Three named wings:

- **The open-source / design-engineer wing** (the Vercel-ecosystem canon): leerob.com (Lee Robinson), rauchg.com (Guillermo Rauch), shadcn.com, shud.in (Shu Ding), tr.af (Traf), laurendorman.io (Lauren Dorman), pqoqubbw.dev (dmytro), nutlope.com (Hassan El Mghari), twilson.net (Tim Wilson), reaper.is.
- **Independent designer portfolios:** paco.me (Paco Coursey), baytas.net (M.A. Baytaş), jakub.kr (Jakub Krehel), evilrabbit.com, shedsgns.me (Juliette), blackduke.com (Tin Kadoic), dqnamo.com, senyil.com (Muharrem Şenyıl), flohoeller.com (Florian Höller), felipe.design, loganliffick.com, jasonyuan.design, karrisaarinen.com (Karri Saarinen), jstn.net (Justin Ouellette), vitor.com (Vitor Lourenço), buditanrim.co, jetset.nl (Experimental Jetset — the historic anchor of this aesthetic).
- **Concept sites:** once.com, minimalism.com, mononym.com, margins.app, bmrks.com, wireframe.co, flowercomputer.com, instinct.co, internetlabs.co.

What "super minimal" means here, operationally: type is the only decoration (system-adjacent sans or a mono, near-monochrome palette, at most one accent), list- and link-first information architecture, no stock imagery, no hero section, static or near-static delivery. None of them are *bare* — the quality lives in spacing rhythm and typographic detail, which is exactly why the directory crops them to 1:1 specimens.

### 3. The two profiles side by side (pick one per project)

| Dimension | Inspiration (full budget) | Minimum (zero budget) |
| --- | --- | --- |
| Reference population | studios, portfolios, AI products, institutions | personal sites of design engineers and indie designers |
| Typography | display + text pairing, oversized scale, serif/grotesk contrast | one family (grotesk or mono), hierarchy by size/weight only |
| Color | art-directed but ≤3 active hues per view | near-monochrome, ≤1 accent |
| Imagery | real, art-directed photography | none, or one personal image |
| Motion | 1 signature scroll/WebGL interaction, custom transitions | ≤1 transition, ~200ms, transform/opacity only |
| Layout | editorial, asymmetric, image-choreographed | list/link-first, single column, ~600–700px measure |
| Delivery | heavy is tolerated if it earns it | static, self-hosted woff2, instant load |
| Pass test | composes as one 1920×1080 frame | type survives a 1:1 crop |

### 4. The near-disjointness theorem — one shared exemplar

Exactly one site appears in *both* directories: **baytas.net** (M.A. Baytaş). The lists are otherwise disjoint reference classes for one taste: full-budget expression versus zero-budget restraint. The single overlap is the thesis: minimal ≠ impoverished. Baytaş-style work is reduction executed with rich craft — deliberate choices about what survives the cut. Calibration rule: excellent work in either mode must hold up against the *other* mode's criteria too. An inspiration-grade site still needs minimum-grade typographic discipline; a minimum-grade site still needs one memorable, composition-grade frame.

### 5. The DSGNRS roster — who gets followed, and the canon loop

72 designers, browseable as a grid of avatars linking to X handles; framing copy: "product designers, visual designers, and design engineers worth following". Three wings:

- **Design-engineer minimalists** whose sites sit in `/minimum`: @pacocoursey, @raunofreiberg, @jakubkrehel, @shedsgns, @doctorbaytas, @evilrabbit_, @dqnamo, @senyil, @flohoeller, @felipedotdesign, @hamzaalabou, @joshmillgate, @heyimgustavo (gustavofior.com), @lochieaxon, @benjitaylor.
- **The motion/WebGL portfolio wing** — authors of `/inspiration` sites: @avstorm, @nuevo_tokyo, @Jakubantalik, @keviduk, @apostraphi, @dario_ferrando, @edo_lunardi, @s3ththompson, @ArjunGfx, @kindlaar, @mrblackstudio, @seb__design (seb-astian.com), @thomasauros.
- **AI-era design voices:** @FonsMans, @oliver_gareis, @alexgilev, @renedotwang.

Full roster for name-matching: @ArjunGfx, @prestonb_xyz, @hamzaalabou, @kosta4a, @nuevo_tokyo, @s3ththompson, @_joshrg, @thomasauros, @kaushik_murali, @alexvanderzon, @alexgilev, @mathurahravi, @joshmillgate, @emirayaz, @niclasernst, @lifeofmansoor, @edo_lunardi, @dario_ferrando, @willking, @micka_design, @iamdavidhill, @raul_dronca, @jbedln, @jmdsgn, @Ahmedcreatives, @MeganeJon, @renedotwang, @avstorm, @juli_fella, @aecyydesign, @imRazvanBadea, @gabriell_lab, @TyroneC__, @dqnamo, @kindlaar, @seb__design, @heyimgustavo, @apostraphi, @shihaabbbb, @keviduk, @artntek, @kairevicius, @hxmzaehsan, @scottymatt, @alyx_so, @its_sslvr, @ozzyxs1a, @AdityaSur11, @oliver_gareis, @FonsMans, @doctorbaytas, @mrblackstudio, @senyil, @pacocoursey, @raunofreiberg, @shedsgns, @keryilmaz, @olegcoada, @tranmautritam, @CharlesPattson, @jakubkrehel, @darylginn, @ayushsoni_io, @benjitaylor, @lochieaxon, @Jakubantalik, @evilrabbit_, @AnaArsonist, @driceroland, @sekachov, @flohoeller, @felipedotdesign.

The canon loop: roster members author the directory sites *and* supply the essays and tools the rest of the canon distills. Exact-name cross-references: @raunofreiberg → `invisible-details`; @jakubkrehel → `krehel-skills`; @shedsgns → `shedsgns-taste`; @lochieaxon → `torph`; @benjitaylor → `family-values`. When picking a reference for a task, check the roster first: someone on it has usually already solved the adjacent problem with a stated philosophy.

### 6. The meta-lesson — the aesthetic the curation endorses

Read across all ~295 curated sites and 72 people, the endorsed definition of excellent in 2026:

1. **Craft over decoration.** Every listed site does at least one thing unusually well (type, motion, layout, code) and nothing generically.
2. **Typography-first.** In the minimum list, typography carries entire sites; in the inspiration list, a whole French cluster treats type as the product. Type is the highest-leverage axis of quality.
3. **Restraint as a choice, not an absence.** "Super minimal" is curated *separately* from "well-designed" — reduction is honored as its own discipline with its own exemplars, equal in status to expressive work.
4. **Speed and static delivery as taste.** The curator ships a static site with self-hosted woff2 subsets (`font-display: swap`); the minimum canon is fast static personal sites. Heaviness reads as slop unless the inspiration bar justifies it.
5. **The personal site is the highest genre.** Most featured work across both lists is one person's site — the format where individual judgment is most legible. Agency-scale brand sites must clear a higher bar (Richard Mille, SSENSE XX, Studio Museum make it; most brands don't).
6. **Freshness matters.** Monthly drops keep the reference class current; "excellent" is dated 2025–2026, not timeless.

The judge's own CSS is the aesthetic in executable form — copy-pasteable as the baseline for any restraint-grade surface:

```css
:root {
  --font-sans: "Geist", sans-serif;          /* one workhorse sans */
  --font-mono: "IBM Plex Mono", monospace;   /* one mono for meta/labels */
  --font-display: "Instrument Serif", serif; /* display used sparingly */
  --font-pos-ratio: 1.2;  /* scale up: base ×1.2 per step */
  --font-neg-ratio: 1.125; /* scale down: base ÷1.125 per step */
  --bg: #09090b; --fg: #fafafa;              /* near-black, near-white; never #000/#fff */
}
body { max-width: 600px; margin-inline: auto; }        /* one text column */
img  { border: 1px solid #3f3f46; }                    /* hairline instead of shadow */
.card img { transition: transform .2s; }               /* exactly one motion */
.card:hover img { transform: scale(1.025); }           /* 2.5% — felt, not seen */
```

(For new projects in this canon, swap the display face — Instrument Serif is the curator's house style and, elsewhere, an AI tell; see `taste`.)

## When to use / When NOT to use

Use when:

- Starting a design and the brief lacks references — pick the reference class (Section 1 vs 2) and 3 named exemplars from it.
- Reviewing or critiquing UI and needing a defensible "what great looks like" instead of adjectives.
- Deciding how much decoration a project can bear (the restraint budget, Section 3 table).
- Choosing whose work to study for a specific problem (roster check, Section 5).
- Building a portfolio or personal site — the best-matched reference class in the canon.

Do NOT use when:

- The surface is a data-dense enterprise tool — both directories are communication-first (portfolio, brand, product marketing); dense UI needs the component canon (`ui-playbook`, `component-gallery`) instead.
- You need how-to rules — this skill defines the reference class; execution rules live in the principle skills it links to.
- Accessibility or WCAG numbers are the question — neither directory judges for that.

## How to apply

1. Classify the surface: expression-grade (portfolio, brand, launch, editorial) → inspiration profile; restraint-grade (personal site, docs, tool marketing, anything trust-first) → minimum profile.
2. Pick exactly 3 exemplars from the matching cluster and write one line per exemplar naming *the specific thing* it does at world-class level (e.g., "jetset.nl: uppercase-only grotesk as entire brand system").
3. Run the two screenshot tests the curator runs: does the page compose as a single 1920×1080 frame (inspiration bar)? Does the type survive a 1:1 crop (minimum bar)? If both fail, the design is neither expressive nor disciplined — rework before adding anything.
4. Set the restraint budget before styling, from the Section 3 table: palette, imagery count (minimum: none or 1; inspiration: real photography only), motion count (minimum: ≤1 transition; inspiration: 1 signature interaction, scroll-driven, honoring `prefers-reduced-motion`).
5. Check typography against the profile: minimum-mode = one family, hierarchy by size/weight only; inspiration-mode = display + text pairing with deliberate contrast, negative tracking on display sizes (see the French cluster).
6. Check the roster for a practitioner who already solved the adjacent problem; read their site with the specific question in hand before generating anything.
7. Verify the OG image — it is a browse filter in the inspiration directory; a great page with a default share card fails the profile.
8. Date-check yourself: if your mental reference set is pre-2024 award sites, replace it — this canon was seeded 2025-04 and refreshed monthly through 2026-10.

## AI-slop warning

The classic AI misuse of a gallery: **surface-copying one famous exemplar** (Dub's gradients, a Linear-style dark hero, dither textures, marquees, custom cursors) without the system underneath — the directories hold ~295 distinct sites precisely because the endorsed value is judgment, not a look. Second misuse: **treating "minimal" as "remove things"** — empty pages with default type are the opposite of the minimum list, which curates restrained typography and thoughtful layouts, i.e., reduction with craft; a stripped page that fails the 1:1 specimen test is just unfinished. Third: **quoting the same five famous names** (Linear, Vercel, Stripe, Apple) as a universal answer — none of them is in these directories; the curator's reference class is mostly independent designers and small studios, so answer with members of *these* lists. Fourth: applying inspiration-list spectacle (WebGL, scroll choreography, oversized display serif) to a working tool or trust-first surface — wrong reference class, instant slop. Fifth: quoting roster members as proof of quality without naming what they actually do — a reference is only calibration if it points at a specific, imitable decision.

## Relations

- **taste** — the execution doctrine this reference class validates: when a pick from these galleries conflicts with taste-skill rules (Instrument Serif is both the curator's display face and on the ban list for *new* projects), the ban list wins for generation; the galleries win for *seeing*.
- **invisible-details** — roster member @raunofreiberg's craft essay; the interaction-quality leg of the inspiration profile, stated as rules.
- **krehel-skills** — roster member @jakubkrehel's skill collection; the minimum profile rendered as concrete review rules (typography, color, layout, motion).
- **shedsgns-taste** — roster member @shedsgns's taste essay; the philosophy behind the minimum wing.
- **torph** — roster member @lochieaxon's library; an example of the roster loop: directory taste → tool → canon skill.
