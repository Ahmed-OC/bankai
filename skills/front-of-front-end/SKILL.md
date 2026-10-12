---
name: front-of-front-end
description: Use when deciding which pass owns a UI task — look-and-feel (semantic HTML, CSS, presentational JS) vs functionality (state, APIs, build). Gives the canonical split, both skill lists, and the component-library handshake.
source: https://bradfrost.com/blog/post/front-of-the-front-end-and-back-of-the-front-end-web-development/
category: essay
---

# Front-of-the-Front-End — the discipline split that defines design engineering

Source: https://bradfrost.com/blog/post/front-of-the-front-end-and-back-of-the-front-end-web-development/ — Brad Frost, blog post, 16 February 2021. Frost coined the two terms offhand on the Shop Talk Show; this post is the canonical definitions. Free to read, no explicit license. It is Frost's entry in the "Great Divide" conversation (Chris Coyier's CSS-Tricks term for the widening gap between JavaScript-focused and HTML/CSS-focused web developers).

## What it is / Why it exists

- Thesis, quoted: "The Great Divide is real" — front-end development is now two disciplines, and pretending it is one ("full-stack") mis-hires, mis-teams, and mis-reviews.
- The one-line split, quoted: "a front-of-the-front-end developer determines the look and feel of a button, while a back-of-the-front-end developer determines what happens when that button is clicked."
- Why the old labels broke: front-end vs back-end was clear when front-end meant HTML/CSS/JS and back-end meant PHP/Python/ASP.NET. "Now that 'JavaScript dun got big'", application logic moved into JS, blurring both boundaries at once.
- Adoption signal: Frost's clients moved "away from a culture of 'we only hire full-stack developers'" and adopted these two labels "to better organize their teams and refine their hiring practices." The closing question — "Are you a frustrated 'full-stack' dev?" — names the pain the split resolves: one job title covering two deep crafts means one craft always gets discounted in practice (in the Great Divide context, the HTML/CSS side).
- Read retroactively, this post is the org-chart prefiguration of the design engineer: the front-of side is definitionally design-adjacent (Frost even slips the synonym in: "Front-end designers architect resilient CSS code…").

## The core ideas

### 1. The definitions (use these verbatim in role/task descriptions)

- Front-of-the-front-end: "a web developer who specializes in writing HTML, CSS, and presentational JavaScript code." Owns what the user sees and feels.
- Back-of-the-front-end: "a web developer who specializes in writing JavaScript code necessary to make a web application function properly." Owns what the app does.
- Presentational JavaScript = code that manipulates DOM objects: "making an accordion panel open or close when you click the accordion title, or closing a modal window." Everything beyond that (state, data, routing) is back-of.

### 2. Front-of skill list (the essay's bullets — this is the rigor UI work deserves)

1. Semantic HTML with "a strong focus on accessibility" — friendly to "browsers, assistive technologies, search engines, and other environments that can consume HTML."
2. CSS for "colors, typography, responsive layout, animation, and any other visual aspect" — architected "with a focus on modularity, flexibility, compatibility, and extensibility" (resilient, not page-scraped).
3. Presentational JS only (DOM manipulation; see the mechanism below).
4. Cross-browser and cross-device testing across "a never-ending stream" of devices — "and even anticipating ones that haven't been invented yet."
5. Front-end performance: "lightweight, fast-loading, snappy, jank-free experiences."
6. Designer collaboration: translate brand, design vision, UX best practices "into the browser, which, to remind you, is the actual place actual people will go to use the actual product."
7. Compatibility coordination with back-of devs on back-end code, services, APIs.
8. A presentational UI component library "authored in a templating language… packaged up to be consumed by other developers."
9. A documented, "robust, intuitive component API" per component.
10. Unit tests for that library.
11. Explicit flexibility decisions per component: "how open/composable or rigid/locked down each component should be."
12. Maintenance "as a product": versioning, deployment, governance, release notes.

### 3. Back-of skill list (know it so you can route to it, not to skip it)

1. Business logic: CRUD, application state, routing, cache, authentication.
2. Wiring/integrating/authoring data sources, services, APIs — retrieving and displaying CMS content, posting form data.
3. Consuming the front-of component library "to compose screens and connect real functionality data, and services."
4. JS performance: snappy fetching/posting.
5. End-to-end and integration tests.
6. JS infrastructure: Node frameworks, tools, services.
7. DevOps: bundlers, deployment tooling, CI/CD.
8. Ensuring the component library contains "all the components, variants, and API hooks necessary" for the app and all its states.
9. With the product team: "all product states are accurately represented in the living, breathing application."
10. With backend devs/IT: infrastructure and non-JS backend integration.

### 4. The boundary is fuzzy; the delineation still works

- Quoted: the line "can be fuzzy and varies greatly from developer to developer"; spanning both is possible "but… that's not super common."
- Yet "the general split between 'look and feel' and 'functionality' continues to be a decent delineation." Use the button test (see the checklist) — not file extensions or framework layers — to classify work.

### 5. The handshake: a directly-consumable UI component library

- Quoted: "A directly-consumable UI component library can serve as a healthy handshake between front-of-the-front-end developers and back-of-the-front-end developers as it creates a clear separation between different kinds of code."
- The contract that makes a component "directly consumable": data in via props/slots, DOM out, zero business logic inside. The consumer supplies data, routing, and state; the component guarantees look, feel, and a11y behavior.

```html
<!-- Presentational JS, the front-of mechanism: DOM manipulation only. -->
<button aria-expanded="false" aria-controls="faq-panel">Section title</button>
<div id="faq-panel" hidden>Panel content (slot).</div>
<script>
  document.querySelectorAll('[aria-controls]').forEach((btn) => {
    btn.addEventListener('click', () => {
      const open = btn.getAttribute('aria-expanded') === 'true';
      btn.setAttribute('aria-expanded', String(!open));
      document.getElementById(btn.getAttribute('aria-controls')).hidden = open;
    });
  });
</script>
```

```tsx
/* Library component (front-of): props in, DOM out, UI-local state only. */
type AccordionItem = { id: string; title: string; body: ReactNode };
function Accordion({ items, defaultOpen = -1 }: { items: AccordionItem[]; defaultOpen?: number }) {
  const [open, setOpen] = useState(defaultOpen); // UI state, not app state
  return items.map((item, i) => (
    <div key={item.id}>
      <button aria-expanded={open === i} aria-controls={`panel-${item.id}`}
              onClick={() => setOpen(open === i ? -1 : i)}>{item.title}</button>
      <div id={`panel-${item.id}`} role="region" hidden={open !== i}>{item.body}</div>
    </div>
  ));
}
/* API doc (part of the component, not an afterthought):
   <Accordion items={AccordionItem[]} defaultOpen={number} />
   Emits nothing; manages its own open state. a11y: aria-expanded/aria-controls wired. */
```

```tsx
/* App screen (back-of): data, routing, state — UI comes from the library. */
function FaqScreen() {
  const { data } = useFaqEntries(); // API layer lives here, not in Accordion
  return <Accordion items={data.map((f) => ({ id: f.id, title: f.q, body: f.a }))} />;
}
```

- The failure mode this prevents: a "component" that fetches its own data, hardcodes one variant, and can be consumed only by the screen it was born in. If a second screen can't lift it out unchanged, the handshake is broken.

### 6. Why the distinction matters beyond code

- Hiring: "we only hire full-stack developers" silently filters for one side (usually the JS side) and discounts the other; the two labels make both crafts legible to recruiters and managers.
- Collaboration: designers get a counterpart who owns translation into the browser; backend devs get a counterpart who owns integration; the component library is the artifact all three meet around.
- Respect for the UI craft: the front-of list is 12 items deep — semantics, a11y, cross-device, performance, component APIs, docs, tests, versioning. Reading it ends the "just make it pretty" framing: front-of work has the same operational weight (tests, releases, governance) as back-of work, applied to pixels and semantics instead of services.

### 7. What changes day-to-day for an AI building UI

- Task triage becomes explicit. Before writing code, classify each subtask as front-of (markup, styling, presentational behavior, a11y, UI perf) or back-of (data, state, routing, infra) — then apply that side's rigor, not a generic average of both.
- UI work gets engineering rigor, not vibes: unit tests on components, a documented props/slots/events API, a versioned library boundary — even when a single agent produces both sides.
- The two passes stay separable in the output: presentational files import no data layer; app files import the library. A reviewer (human or agent) can verify the split mechanically.

## When to use / When NOT to use

Use when:
- Building or refactoring any non-trivial UI — decide per task which side owns it.
- Creating or consuming a component library; defining its API and flexibility per component.
- Reviewing UI code: classify each defect (look/feel vs functionality) to pick the right fix and the right test.
- Decomposing work for multiple agents/contributors — the split is the cleanest seam for parallel front-of and back-of tracks.

Do NOT use when:
- The project is small enough that one pass genuinely spans both — the split is an organizational lens, not a wall; Frost: the line "can be fuzzy," spanning is possible.
- You want an excuse to never learn the other side — each side's list is a skill inventory to respect, not a reason to sneer at CSS or at state management.
- Choosing technologies: the split says nothing about which framework, styling approach, or meta-framework to pick. Apply it after that choice.

## How to apply

1. Run the button test on every task: does it change what the user sees/feels (front-of) or what happens when they act (back-of)? Ambiguous → split into two tasks.
2. Write presentational components to the contract: props/slots in, DOM out, UI-local state only. No fetch, no routing, no app stores inside.
3. Prefer the platform first: check semantic HTML/CSS (`<details>`, `hidden`, `dialog`, CSS animation) before writing presentational JS for behavior.
4. Wire a11y attributes as part of the component, not a later pass: `aria-expanded`/`aria-controls` pairs, `role="region"` panels, `hidden` for collapsed content.
5. Architect CSS for reuse: tokens for color/spacing/type, no fixed heights on text containers, layout that survives a 320px viewport and 200% zoom.
6. Test the front-of side explicitly: keyboard-only pass, screen-reader pass, smallest supported viewport, dark mode, reduced-motion.
7. Unit-test components (render + interaction) and reserve E2E tests for back-of app flows ("end-to-end, integration, and other tests").
8. Document every component's API next to its code: props, slots, state ownership, emitted events, a11y behavior.
9. Record the flexibility decision per component — open/composable or rigid/locked-down — and stick to it in review.
10. Maintain the library as a product: semantic versioning, changelog on every change, deprecation notices for breaking API changes.
11. Route missing variants/hooks as library tickets: back-of needs ("this modal can't be closed from outside") extend the component API; they never fork the component inline.
12. If one agent does both sides, still do two passes and two file sets — never mix data fetching and presentational markup in the same module.

## AI-slop warning

- The default AI failure is collapsing the split: a generated "component" that fetches data, holds app state, and styles itself inline — so neither side's rigor applies. No a11y/device pass happens (that's front-of), and no integration test happens (that's back-of). Slop signature: every component imports the data layer; no component has docs or tests.
- Second failure: treating front-of as trivial. AI skips semantic HTML, hardcodes pixel values, and omits the component API/docs/versioning because "it's just styling." Frost's 12-item list exists precisely to make that indefensible.
- Third failure, opposite direction: back-of habits leaking into front-of — 40 lines of JS state for what `:hover` or `<details>` already does, re-render on every keystroke instead of a CSS transition. If the code manipulates DOM objects, it belongs to the front-of contract and must meet its bar.
- Do not use the split as a status argument ("CSS is real engineering" / "logic is the hard part"). It is a routing tool; both lists are deep.

## Relations

- rise-of-de — names the role that later emerged from the front-of side fused with design sensibility; this skill is the prerequisite split that made "design engineer" a coherent job rather than a contradiction.
- de-attributes — the personal/habitual traits of design engineers; Frost's front-of list here is the hard-skill, responsibilities counterpart to those attributes.
- code-source-of-truth — argues code, not static mocks, is the artifact of record; Frost's "healthy handshake" component library is the concrete mechanism that makes shared code the source of truth across the divide.
- design-engineers-map — the broader landscape taxonomy of design-engineering roles; use it after this split to locate where a given team or agent sits on the front-of/back-of spectrum.
