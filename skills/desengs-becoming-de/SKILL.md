---
name: desengs-becoming-de
description: Use when mapping a designer-to-design-engineer transition, deciding whether to prototype in canvas vs code, or sequencing what to learn (CSS depth, React, motion) on that path.
source: https://marcel.io/posts/becoming-a-design-engineer
category: essay
---

# Becoming a Design Engineer (desengs) — the path, mapped

Source: https://marcel.io/posts/becoming-a-design-engineer — Marcel Wichmann, personal blog, February 2024. A public career-commitment essay: a product designer declaring he will become a design engineer, stating the bug in his old workflow, the argument that convinced him (Jim Nielsen), his honest skill inventory, and his training plan. No license stated; public post.

## What it is / Why it exists

- Not a tutorial or syllabus — a **commitment post**: "So here it is: I'm committing to making the leap and becoming a design engineer." (Wichmann). Its value is the diagnosis and the inventory, not a curriculum.
- The trigger: after roughly two years of part-time coding, his design tooling started to feel wrong, and Jim Nielsen's "Design Engineer" essays named what he was experiencing.
- The structural bug the essay documents: **every handoff from designer to developer loses fidelity**, and the designer had no lever but complaint. The fix is not better specs — it is collapsing the two roles into one person.
- Scope caveat (do not over-read): the essay covers motivation, definition, and starting inventory. It contains no milestones, no portfolio playbook, no job-market data.

## The core ideas

### 1. Thesis: intent survives only if the designer can implement it

- His belief, stated as the essay's justification: "I strongly believe that the future of computing requires designers to code." (Wichmann)
- The old workflow, in his words: "whenever I handed off my designs, the results never turned out the way I imagined them." Deviations — "Even the smallest deviation from my design would upset me. A Lot." — and he "had no option but to accept it… accepting that a big part of my ideas would die during the implementation process."
- Dependency shape of the old role: he needed developers "not only willing to implement my ideas but also to deal with me constantly poking around, demanding fixes on a pixel level." Pixel-level intent is unenforceable across a handoff; it is only enforceable by the person holding the intent.
- Transferable rule: **treat fidelity loss at the design→code seam as a process defect**, not as normal tolerance. If you cannot fix the deviation yourself, you don't own the design.

### 2. The crutch signal — when to abandon the canvas

- The sentence that opens the essay: "After roughly two years of coding, moving rectangles on a canvas started to feel like a crutch." He often already knew what the final product should look and feel like; designing it anyway meant "creating a chore out of something that's supposed to be a lot of fun."
- His replacement practice: skipping the design file and building **throwaway SwiftUI prototypes** of the idea instead.
- The specific, quotable preference: "It always feels more satisfying to create a real empty-data state in code instead of duplicating frames in a design file." Real edge states (empty, loading, error) are *lived* in code; in a canvas they are copy-pasted frames that drift from reality.
- Transferable rule: **the artifact chain (wireframe → mockup → prototype) is only justified while the outcome is unknown.** Once you can describe the result, extra artifact steps are cost. The signal is emotional — the tool feels like a chore — and it means: open the editor, not the canvas.

### 3. The argument he adopts (Nielsen, verbatim)

> "By having an understanding of the constraints of the medium they're working in, a design engineer can skip a lot of otherwise necessary steps in the design process. They don't need to produce innumerable artifacts (wireframes, mockups, prototypes) because they can imagine how the design will flex and flow at different sizes and in different contexts. They can prototype directly in the medium itself." — Jim Nielsen, as quoted by Wichmann.

- The evidence Nielsen gives (as relayed by Wichmann): an idea for a UI — "a prototype directly built with web technologies" — later shipped "as part of the footer of his blog" as "the real thing." Idea → medium-native prototype → shipped feature, one person, no artifact chain.
- Note the enabling condition: skipping artifacts is earned by **knowing the medium's constraints**, not by skipping the thinking.
- Wichmann's honest gap, the pivot of the whole essay: "While I truly believe I have a pretty good understanding of the technical limitations, I don't have the skills to translate my ideas into code." **Understanding constraints ≠ ability to build.** The transition exists precisely to close that gap — he could evaluate implementations but not produce them.
- Why the gap mattered so much: because he could *evaluate*, every implementation shortfall was visible to him and unfixable by him. That asymmetry — full standards, no means — is the emotional engine of the essay.

### 4. The foundation inventory — what to learn, in his own tiers

| Area | His exact level | His stated plan |
| --- | --- | --- |
| Swift / SwiftUI | "quite solid" | keep as toolbox: "Apple's framework of the future. For now, I'm not exactly sure where this journey will take me" |
| HTML / CSS | "serviceable" | "There's definitely a lot to learn especially when it comes to CSS, which apparently has a lot more depth to it than most people think" |
| React + Framer Motion | "some React experience and really enjoy working with Framer Motion" | "a library I'd love to master one day" |

- The plan in one sentence, his: "Getting the reps in when it comes to web development is what this is all about." **Reps in the shipping medium** — not more courses in the medium he already masters (SwiftUI).
- Derive the ordering honestly from the inventory: (1) target the medium you will ship in but are weakest in (web/CSS), (2) let an enjoyment hook (Framer Motion) pull you through the reps, (3) keep the already-solid skill (SwiftUI) as an asset, not the focus.
- Anti-pattern implied: he does NOT plan to deepen Figma or add another design tool — the learning budget goes entirely to code.

### 5. The motivation structure — immediate satisfaction plus a terminal goal

- Near-term driver: the preceding months of building things himself felt "a lot more satisfying" than the canvas workflow.
- Terminal goal, his close: "Ideally, there's a project that could catapult me into indie development, and I can't imagine better training for it than becoming a design engineer. A win-win situation." The DE path doubles as **training for shipping your own product** — daily reps that compound into indie capability.
- The only visibility move in the essay is the essay itself: committing in public. (Full community/portfolio tactics are out of scope here — see Relations.)

### 6. The path, mapped — four stages from the narrative

| Stage | What it looks like (his words) | The practice change |
| --- | --- | --- |
| 0. Designer with handoffs | depended on developers "willing to implement my ideas"; results "never turned out the way I imagined" | intent dies at the seam; pixel-level demands are a tax on others |
| 1. Side-coding designer | "roughly two years of coding" alongside design work; throwaway SwiftUI prototypes | code as a private thinking tool, not yet the primary medium |
| 2. Crutch threshold | "moving rectangles on a canvas started to feel like a crutch"; canvas work became "a chore" | when outcome is known, artifact steps are pure cost — switch media |
| 3. Commitment | "getting the reps in when it comes to web development" | all learning budget moves to the shipping medium; terminal goal (indie dev) anchors the reps |

- Read the stages as a diagnostic: stage 2 is the transition trigger, and it is *reached through side practice at stage 1* — the crutch feeling is earned by roughly two years of code exposure, not arrived at by reasoning alone. For a team or an agent: you cannot skip to "prototype in code" without first building the constraint model that makes it safe.

### Canvas vs code — the decision this essay actually encodes

| Situation | Choose | Why |
| --- | --- | --- |
| Outcome already known ("I know what this should look and feel like") | code, immediately | canvas here is "creating a chore out of something that's supposed to be a lot of fun" |
| Edge states needed (empty/loading/error) | code | real states are "more satisfying… in code instead of duplicating frames" |
| Outcome genuinely unknown, exploring directions | canvas/sketch | artifact steps are only justified while the answer is undecided |
| Motion and state interaction to evaluate | code (medium-native) | flex/flow across sizes and contexts is only testable in the medium (Nielsen) |
| Idea that may ship to a real surface | throwaway prototype in the shipping stack | Nielsen's pattern: web prototype → footer feature, "the real thing" |

### What changes day-to-day for an AI building UI

An agent is already a design engineer in one skull — the essay's rules apply as build mechanics:

1. **Skip artifact simulation.** When the request is clear, produce runnable code directly. Do not emit wireframe-then-mockup-then-spec chains when one working prototype answers the question.
2. **Build the real edge states, not frames.** Empty, loading, and error states exist as live components, never as duplicated static mockups. Mechanism:

```tsx
function List({ items, status }) {
  // One component owns every state the data can be in.
  // In the canvas workflow each of these was a duplicated frame.
  if (status === "loading") return <Skeleton rows={3} />;
  if (items.length === 0)
    return <EmptyState title="No projects yet" hint="Create your first project." action={<Button>New project</Button>} />;
  return <ul>{items.map((i) => <Row key={i.id} item={i} />)}</ul>;
}
```

3. **Own intent through implementation.** There is no handoff in which details may die: a deviation between stated design intent and shipped code is a defect to fix, not taste to accept.
4. **Motion as state-bound reps, not canned keyframes.** Framer Motion's mechanism (his chosen hook) is motion values bound to state changes with spring physics; port to plain CSS when the dependency isn't justified:

```tsx
<motion.div
  animate={{ scale: active ? 1.04 : 1 }}
  transition={{ type: "spring", stiffness: 400, damping: 30 }}
/>
```

```css
/* Plain-CSS port: transition on the state that changes, not a keyframe list */
.card { transition: transform 160ms cubic-bezier(0.22, 1, 0.36, 1); }
.card.is-active { transform: scale(1.04); }
```

## When to use / When NOT to use

Use when:
- Deciding whether a given design task should happen in canvas/mockups or directly in code — apply the crutch test (is the outcome already known?).
- Planning or advising a designer→design-engineer transition and sequencing what to learn (reps in the shipping medium, CSS depth, motion as the enjoyment hook).
- Arguing for prototype-in-the-medium — the Nielsen quote is the citation for skipping artifacts.
- Building data states (empty/loading/error) — implement them as real code paths, first-class.
- Diagnosing handoff fidelity loss as a structural problem (collapse the roles) rather than a communication problem (write longer specs).

Do NOT use when:
- You need a full DE curriculum, competency model, or hiring rubric — this is one person's commitment post (see Relations for the syllabus skills).
- The design work is genuinely exploratory — when the outcome is unknown, sketching and canvas iteration remain legitimate; the crutch rule fires only when you already know the result.
- You need job-market or comp data for the role — absent here.
- You want portfolio or community-building tactics — the essay's only visibility act is the public commitment itself.

## How to apply (numbered checklist)

1. Run the crutch test on the task: can you describe the final look and feel before opening a design file? If yes, skip the file; prototype in the shipping medium.
2. Replace the artifact chain with one throwaway coded prototype; discard it freely — its job is to answer the question, not to be maintained.
3. Implement every data state in the final medium: empty, loading, error — real components with real copy, never duplicated frames.
4. Audit your (or the project's) stack in his three tiers — solid / serviceable / some-experience-plus-enjoyment — and put all learning reps into the shipping medium where the gap is, not into tools already mastered.
5. Budget for CSS depth specifically: treat it as a deep discipline ("a lot more depth to it than most people think"), not a solved afterthought.
6. Pick one enjoyment hook in the weak medium (his: Framer Motion) and route early reps through it.
7. Anchor the transition to a terminal project (his: indie development) so daily reps compound toward something shippable.
8. As an agent: when design intent is known, emit runnable code immediately and iterate in code; never hand off a description of something you could have prototyped.

## AI-slop warning

- Classic misreading: "skip artifacts" becomes **"skip design thinking."** Nielsen's skip is *earned* by knowing the medium's constraints — an AI that jumps straight to code without the constraint model (layout, state, performance, a11y) produces faster garbage, not faster design. Wichmann's whole point is that he *understood* constraints but couldn't build; inverting it (building without understanding) is the failure mode.
- Second misuse: adopting "design engineer" as a label while output still shows handoff decay — unhandled empty/loading states, motion that ignores state, intent drifting between spec and code. The essay's bug is fidelity death at the seam; if the seam is you and details still die, the lesson wasn't learned.
- Third misuse: cargo-culting his specifics (SwiftUI prototypes, Framer Motion) — his medium choices follow from *his* shipping targets and existing skills. The transferable mechanism is reps-in-your-shipping-medium; the specific stack is personal.

## Relations

- `desengs-de-101` — the role's definition and landscape; this essay supplies one practitioner's first-person rationale for entering it, complementing the top-down view.
- `desengs-de-attributes` — the competency-by-competency attribute list; use it to convert Wichmann's "getting the reps in" into measurable skills (his inventory maps directly onto the attribute axes).
- `desengs-design-engineers-map` — the practitioner roster and implied eight-point curriculum; Wichmann's foundation inventory is one concrete instance of that curriculum, and the map carries the Jim Nielsen definition lineage this essay leans on.
- `desengs-code-source-of-truth` — the code-first design-workflow doctrine; this essay's "crutch" moment is the phenomenological argument for it.
- `desengs-front-of-front-end` — the HTML/CSS-depth half of his reps plan; his "CSS has a lot more depth to it than most people think" is that skill's premise stated from the learner's side.
