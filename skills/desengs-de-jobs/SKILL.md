---
name: desengs-de-jobs
description: Use when defining, scoping, or self-calibrating against the "design engineer" role — the skill profile, comp bands, and role flavors distilled from what companies actually hire for.
source: https://designengineer.io/
category: reference
---

# Design Engineer (desengs) — the role, defined by what companies hire for

Source: https://designengineer.io/ — a dedicated job board for design engineers, run by This With That ($225 per post, 45 open roles at time of distillation, 16 visible). Listing evidence quoted from the Paper, CrowdVolt, Autumn, and Fiddle postings linked from the board. No license stated.

## What it is / Why it exists

The board exists because the role had demand but no canonical name or home. Its own words: design engineers "span the boundary between the design and engineering teams," and the board aggregates roles "that are explicitly design engineering and also adjacent (for instance design role where all the existing designers on the team code)."

The market signal: 45 companies paying $225 to reach exactly this hybrid. Adjacent listings on the board — a Tech Lead Web Platform at Fingerprint ($178–205K), a Senior Visual Designer at Xata — prove the boundary is porous in both directions: engineers with taste and designers who ship.

The board's endorsement quote, from Guillermo Rauch (CEO, Vercel): "Design Engineering is the embodiment of Steve's 'Design is how it works.' principle. I believe it's going to be one of the most important roles and differentiators in the next generation of software companies."

Why an agent needs this: "design engineer" is a precise hire with a measurable skill profile, not a vibes title. Everything below is what companies attach dollars to.

## The core ideas

### 1. The site's two official flavors

The board splits the discipline in two, verbatim:

- **Product design engineers** — "often work with the design system which requires a multidisciplinary mindset." In practice (see listings): components, tokens, interaction patterns, shipped product UI.
- **Marketing-centric design engineers** — "focus on the marketing website or public facing projects often using advanced CSS and WebGL techniques."

### 2. The finer split the listings reveal

Scanning the postings, the product flavor subdivides by weight (derived from listing evidence, not the site's text):

- **Systems-heavy**: Confido's role is titled "Design Engineer, Design Systems" outright ($170–250K + 0.06–0.1%). CrowdVolt: "Own and evolve our design system across components, tokens, and interaction patterns and keeping Figma and code in lockstep."
- **Motion-heavy**: CrowdVolt wants "a strong feel for motion/animation (Framer Motion, GSAP, or similar)"; Autumn demands deep care for "typography, hierarchy, composition, imagery, interaction"; Paper wants "unmatched attention to detail and fine interactions." The marketing flavor (WebGL, advanced CSS) lives here too.
- **Product-heavy / end-to-end**: Autumn: own work "from problem definition and user research" through visual design, front-end implementation, and iteration. Paper: "design and implement complex UI features from scratch."
- **AI-native (emerging fourth flavor)**: CrowdVolt expects an "AI-native workflow" — "delegating work to models, writing code with AI, building agents." Autumn designs UX where users "delegate work, review outputs, maintain control, and recover when systems fail." Fiddle experiments "using Claude or Codex to get ideas in front of people fast."

Flavor → stack → proof-of-work mapping (use it to route a task to the right profile):

| Flavor | Core stack signals | Proof companies ask for |
|---|---|---|
| Systems-heavy | React, TS, tokens, Storybook (Fiddle bonus: "shipping react components and working with storybook") | Component library + Figma-code lockstep |
| Motion-heavy | Framer Motion / GSAP, advanced CSS, WebGL (site's marketing flavor) | Shipped interaction detail, "fine interactions" |
| Product-heavy | React, TS, data/API reading (Autumn: "read APIs and data models") | Features shipped end-to-end, iteration on user data |
| AI-native | Claude/Codex-class tools, agent building | Delegate-review-control-recover UX patterns |

### 3. The skill profile companies pay for (cross-listing evidence)

Ranked by how many distinct listings demand it:

1. **React + TypeScript at production depth.** CrowdVolt: "Fluent in React, TypeScript, Tailwind, and modern CSS." Autumn: "Production-quality HTML, CSS, React, and TypeScript." Paper goes deeper than frameworks: "Deep understanding of the DOM and browsers beyond framework-level abstractions."
2. **Taste as a stated requirement.** CrowdVolt: "Obsessed with craft and taste... fanatical about polish, down to the pixel," with named dimensions: "typography, motion, empty states, and pixel-level detail." Autumn names its own list: "typography, hierarchy, composition, imagery, interaction."
3. **Design systems fluency.** Tokens, components, interaction patterns; Autumn extends systems across "product UI, websites, and email." The unit of proof is Figma-code parity: "keeping Figma and code in lockstep" (CrowdVolt).
4. **Motion as a first-class skill.** Framer Motion or GSAP named explicitly; not decoration but interaction quality ("fine interactions," Paper).
5. **Prototyping speed.** CrowdVolt: "can go from a sketch to a working, interactive prototype in hours." Fiddle's team "Made 45 prototypes in 3 months to test every wedge into the market." Speed of iteration is a hiring criterion, not a workflow detail.
6. **Figma + code duality.** Every posting assumes both tools in one head; none splits them across people.
7. **Performance literacy.** Paper: "Skilled at UI performance, helping us hit our 120 fps target." Also: "Comfortable working with very few third-party libraries" — dependency minimalism is the senior signal.
8. **End-to-end ownership.** Not a handoff role: research → design → implementation → ship → iterate on "direct user feedback and data analysis" (CrowdVolt, Autumn).
9. **Soft profile, consistent across listings:** "High agency," "low ego," "debate ideas intensely and never take feedback personally" (Fiddle), "high velocity: we ship to production many times per week" (Paper).

### 4. Salary and level signals (from the board's visible listings)

| Company | Title / flavor | Location | Comp |
|---|---|---|---|
| Browser Company | Design Engineer | Remote (NA) | $225–310K |
| Paper | Design Engineer (principal) | Remote | $200–250K + equity |
| Confido | DE, Design Systems | NYC | $170–250K + 0.06–0.1% |
| Virio | Founding DE | SF | $150–250K + $25–50K bonus |
| Fingerprint | Tech Lead, Web Platform (adjacent) | Remote | $178–205K |
| Ambrook | Design Engineer | NYC/Denver/Remote/SF | $140–210K |
| Givebutter | Design Engineer | Remote/Austin/Denver | $150–170K |
| CrowdVolt | Founding DE | NYC | $120–180K + 0.1–0.5% |
| Finta | Founding DE | SF | $120–180K |
| Infisical | Design Engineer | Remote (Americas) | $100–180K |

Readings an agent can use:

- Band: roughly $100–310K US; the floor is a seed-stage remote hire, the ceiling ($225–310K) is a well-funded product company paying staff-engineer money for craft.
- "Founding Design Engineer" is a real level: earliest technical design hire, 0.06–0.5% equity, expects founding-level agency (CrowdVolt's YC posting classifies it "Engineering, Full stack," "Any (new grads ok)" — portfolio beats years).
- Principal tier requires external validation: Paper expects "an extensive body of work and recognition in the industry."
- Companies pay the top of the band for the combination, not either half: a $250K+ DE is fluent in React internals *and* can defend a type scale.

The level ladder the titles encode (lowest to highest):

1. **Founding DE** (CrowdVolt, Virio, Finta, Autumn) — first design-technical hire; equity 0.06–0.5%; judged on portfolio and agency, "new grads ok"; expects you to also do brand, marketing site, and email (Autumn lists all three).
2. **Design Engineer** (Paper, Ambrook, Givebutter, Infisical) — mid-to-senic individual contributor inside an existing product team; $140–250K.
3. **Senior DE** (Spear AI, Buildkite) — same profile plus mentoring; the board's Spear listing titles it "Design Engineer (Senior)".
4. **Tech Lead, Web Platform** (Fingerprint, $178–205K) — the engineering-side ceiling: platform ownership with a craft mandate.
5. **Principal DE** (Paper) — "extensive body of work and recognition in the industry is expected"; industry-visible output is a hard requirement, not a nice-to-have.

What the market disqualifies (inverse signals, consistent across listings):

- Handoff-only history — no evidence of shipping what you designed.
- Framework-only depth — "beyond framework-level abstractions" (Paper) screens out React devs who have never touched raw DOM/browser behavior.
- Decorative portfolio — visual work with no interaction or systems dimension; conversely, code with no named craft dimensions.
- Unattributed work — anything the candidate cannot personally claim as designed AND built (Autumn's explicit screen).

### 5. How the role is evaluated (hiring process signals)

- **Paid trials over whiteboard loops.** Paper's final stage is "a 1–2 week paid trial project" shipping "a complete feature" while working in Slack/GitHub "like a regular member."
- **Portfolio is the resume.** Paper asks for "short bullet points of best work." Autumn requires the portfolio to "clarify what you personally designed, built, and shipped" — provenance matters; team artifacts don't count.
- **No formal credentials required** (Autumn, explicitly). Shipped work is the only currency.

### 6. The discourse — why the title is contested

The board itself frames formalization as "contentious" and argues both sides:

- Against: "Living on the margins has its benefits. Making, creating, building without any formal requirements is what makes the web so much fun. Corporatizing the playfulness feels like a step back. Having a concrete role definition places observable edges on a generalist philosophy."
- For: "design engineering (UX engineering, creative development, prototyping) work often happens without getting noticed or paid. The title isnt perfect, but it helps. It gives young tech creatives a clear career path beyond having to specialize."

Operational takeaway: the umbrella aliases are UX engineering, creative development, and prototyping. When scanning or writing role descriptions, treat all four as the same hire.

## When to use / When NOT to use

Use this skill when:

- Asked "what is a design engineer," writing a DE job spec, or calibrating a candidate/agent against the market profile.
- Deciding which flavor of DE a project needs (systems vs motion vs product vs AI-native) before staffing or scoping.
- Estimating comp or level for this role (use the table above as the 2024–2026 US baseline).
- Judging whether a piece of UI work meets the bar companies attach $200K+ to (run the checklist below).

Do NOT use it when:

- The task is a pure visual-design deliverable with no implementation (that is the Xata-listing adjacent role, not a DE).
- The task is backend/platform ownership with no craft dimension (the Fingerprint Tech Lead listing is the adjacent engineering side).
- You need the deeper technique of one flavor — that lives in the sibling skills (see Relations), not in this role definition.

## How to apply (numbered checklist)

Self-calibration against the market profile — score any DE candidate, agent, or your own output:

1. **Implementation**: Can it ship production React + TypeScript from scratch, with DOM-level understanding below the framework? (Paper test.)
2. **Craft audit**: Does the work sweat "typography, motion, empty states, and pixel-level detail" — all four, by name? (CrowdVolt test.)
3. **System thinking**: Are tokens, components, and interaction patterns owned coherently, with Figma and code in lockstep?
4. **Motion intent**: Is animation designed (Framer Motion/GSAP-class control: duration, easing, choreography), not sprinkled?
5. **Prototyping speed**: Sketch → interactive prototype in hours, not weeks. If the loop exceeds a day, fail.
6. **Performance**: Is there a measurable budget (Paper's is 120 fps) and are third-party dependencies minimal?
7. **Ownership**: Did the same hands do research, design, implementation, and iteration on shipped feedback?
8. **AI leverage**: Is the workflow AI-native (delegate to models, agents) while keeping human review, control, and recovery paths in the UX?
9. **Portfolio provenance**: Can every artifact be attributed to its maker's personal design AND build work?

When writing a DE job spec, mirror the listings' structure: two-sentence mission, "what you will do" (own system + ship features end-to-end), "you are a good fit if" (fluency stack + craft obsession), and state the comp band.

## AI-slop warning

- The classic AI failure on this role is **buzzword inflation**: generating a profile or spec that lists React, WebGL, GSAP, design tokens, and "passion for detail" without a single verifiable artifact. Every listing above screens for the opposite — portfolios where you must "clarify what you personally designed, built, and shipped." Never claim or imply shipped work that does not exist.
- Second failure: **flattening the role to "designer who codes."** The listings pay principal-engineer money because the role makes product decisions ("drive product and design decisions through direct user feedback and data analysis") and owns performance ("120 fps"). A DE spec with no decision rights or no perf budget is slop.
- Third failure: **motion stuffing.** "Fanatical about polish" is not "animate everything" — the craft signal is empty states and pixel-level detail, i.e., the unglamorous 90%. Do not equate the role with adding transitions.
- The board itself warns against over-formalizing: a rigid checklist with "observable edges" kills the generalist philosophy. Use the profile as calibration, not as a cage.

## Relations

- **desengs-de-attributes** — Ryn Gonzales' DoorDash breakdown (linked as Further Reading on this board): the attribute-level anatomy behind the hiring profile summarized here.
- **desengs-rise-of-de** — David Hoang's "emerging role in software" essay (also Further Reading here): the industry-trend framing behind why this board exists.
- **desengs-front-of-front-end** — the engineering-side definition of the same boundary this board monetizes; use it for the code-depth half of the profile.
- **desengs-taste** — supplies the training program for the "craft and taste" requirement every listing above demands; this skill only defines the bar.
- **desengs-ui-ux-master** — the umbrella canon; consult it for the technique skills (motion, systems, typography) itemized in the profile above.
