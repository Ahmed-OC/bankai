---
name: desengs-component-gallery
description: Use when building or naming any UI component. The Component Gallery's 60-component taxonomy: standard anatomy, confusable boundaries (select vs dropdown vs combobox), states, and where real systems diverge.
source: https://component.gallery/; https://component.gallery/about; https://component.gallery/components
category: reference
---

# The Component Gallery (desengs) — how real design systems build every component

Source: https://component.gallery/ — Iain Bean. A catalogue of interface components as documented by real-world design systems (60 components, 95 systems, 2,671 examples; each page = definition, alternate names, curated examples, further reading). Free to browse; code in linked systems keeps its own license. Modeled on the 1977 architecture book *A Pattern Language*.

## What it is / Why it exists

A pattern book, not a component library: "unlike a component library, most of these components aren't ready to use off-the-shelf" — they exist to be studied and rebuilt. Two stated motivations:

1. "Some interface problems have already been solved" — before building from scratch, check how GOV.UK, Carbon, Polaris, Spectrum, Atlassian et al. solved it.
2. "Naming things is hard" — every component page shows what real systems actually call the thing (a Name-distribution chart), so you pick names from evidence.

Its editorial warning is the governing rule for using it: "Don't assume that an opinion or technique is correct, just because it's popular." Beware information cascades; "look for design systems that give reasons for decisions based on real research." "Definitely don't just copy what everyone else is doing."

## The core ideas

### 1. The taxonomy: a flat list of 60 components

Definition used: a component is "a single, reusable chunk of a user interface"; components nest (Atomic Design). The site keeps ONE flat alphabetical list — no categories — forcing disambiguation by definition, not by bucket. The 60, with real aliases and example counts (count = how universal the component is):

**Form inputs** — Checkbox (84), Color picker (18), Combobox (37; Autocomplete, Autosuggest), Date input (18; often split day/month/year fields), Datepicker (44; Calendar, Datetime picker), File upload (Dropzone, File input), Radio (Radio group), Rating, Rich text editor (RTE, wysiwyg), Search input (Search), Select (82; Dropdown, Select input), Slider (Range input), Stepper (Nudger, Quantity, Counter — numeric increment/decrement), Text input, Textarea (Textbox), Toggle (60; Switch, Lightswitch, Toggle button).
**Actions** — Button (118), Button group (35; Toolbar), Segmented control (Toggle button group — "a hybrid somewhere between a button group, radio buttons, and tabs").
**Overlays** — Modal (82; Dialog, Popup, Modal window), Drawer (38; Tray, Flyout, Sheet), Dropdown menu (49; Select menu), Popover, Tooltip (74; Toggletip).
**Feedback & status** — Alert (108; Notification, Message, Banner, Callout), Toast (41; Snackbar), Progress bar (continuous task), Progress indicator (discrete steps; Progress tracker, Stepper, Steps, Timeline, Meter), Skeleton (placeholder layout), Spinner (Loader), Empty state (16; usually offers an alternate action), Badge (123; Tag, Label, Chip).
**Navigation & structure** — Navigation (Nav, Menu), Header, Footer, Breadcrumbs (55; Breadcrumb trail), Pagination, Tabs (80; Tabbed interface), Tree view, Skip link (keyboard users), Link (Anchor, Hyperlink).
**Content containers** — Card (77; Tile), Hero (Jumbotron, Banner), Table (73; "Data Table" when it sorts/filters), Quote (Pull quote, Block quote), Carousel (22; Content slider), List (unordered / ordered / description), Heading, Image, Icon, Video player.
**Utilities** — Fieldset, Form, Input label (Form label), Separator (Divider, horizontal/vertical rule), Spacer (consistent margin), Visually hidden text (Screenreader only), File (Attachment, Download representation), Avatar (photo/illustration/initial).

Two taxonomy traps it makes explicit: "Stepper" names BOTH a progress indicator alias AND the numeric increment control; "Banner" is an alias of Alert, Hero, and a Toast variant in different systems. Never rely on a name alone — match the definition.

### 2. Confusable boundaries (decide which component you are actually building)

The site's own disambiguation rules, as decision gates:

- **Select vs Dropdown menu vs Combobox**: Select is "a form input used for selecting a value" (collapsed = current choice, expanded = scrollable option list). A Dropdown menu "shows actions or navigation options and is not a form input." A Combobox is "a select, with the addition of a free text input to filter options." Gate: does it set a value (select), trigger an action/nav (menu), or filter as you type (combobox)?
- **Tooltip vs Popover**: tooltip = "usually on hover, but can also be on click or tap"; a popover "is usually triggered via click instead of hover and can contain interactive elements." Gate: hover + non-interactive = tooltip; click + interactive content = popover.
- **Alert vs Toast**: a toast is "a type of alert which appears in a layer above other content, visually similar to a mobile or desktop push notification." Gate: needs a layer/stack and auto-position = toast; inline/prominent = alert.
- **Accordion vs Tabs**: both trade discoverability for space. Accordions "work well on smaller screens" and "need little horizontal space"; tabs need a horizontal strip. On narrow screens, horizontal tabs must stack or become an accordion.
- **Toggle vs Checkbox**: toggle = "switch between two states" with immediate effect; checkbox = selection — "when used alone, it gives a binary choice; in a group it allows the user to select multiple values." Gate: instant apply = toggle; part of a submitted choice = checkbox.
- **Progress bar vs Progress indicator**: bar = "updated continuously as the task progresses, instead of in discrete steps"; indicator/stepper = progress "through a series of discrete steps."
- **Table vs Data Table**: same component; it earns the "Data" prefix only when it adds sorting and/or filtering.

### 3. Standard anatomy + where systems diverge (major families)

**Accordion (101 examples).** Anatomy: a vertical stack of items, each = heading + collapsible content; two states, expanded/collapsed, exposed via `aria-expanded`. Two sanctioned mechanisms:

```html
<!-- A: heading wrapping a button (JS toggles aria-expanded; without JS, content stays visible) -->
<h2><button aria-expanded="false" aria-controls="sec1" id="acc1">Title
  <svg aria-hidden="true" focusable="false"><!-- chevron pointing down --></svg></button></h2>
<div id="sec1" role="region" aria-labelledby="acc1">…content…</div>
<!-- B: native, zero JS -->
<details open><summary>Title</summary>…content…</details>
```

```css
button[aria-expanded='true'] > svg { transform: rotate(180deg); } /* chevron flips up */
summary { cursor: pointer; }
details summary > * { display: inline; } /* block children sit beside the marker */
```

Divergence points real systems split on: chevron vs plus/minus icon (chevron rotates 180° when expanded); single-item-open vs multiple-open ("some users may wish to view the content from two items at the same time" — don't force single); JS button vs native `details`. Constant across systems: "you are hiding content from users — they therefore should not be used for essential information."

**Button (118 examples).** Three things get called "button": a `<button>` (types submit/reset/button), `<input type="submit|reset|button">`, and "any non-button element styled to look like one." Only the first is acceptable in new code. Non-negotiables from the page:

- Always set `type` — an invalid/missing type defaults to submit; submit/reset do nothing outside a `<form>`.
- `<a href="#">` + JS handlers is "a hack that breaks user expectations" (middle-click, Space activation). "Make buttons look like buttons (and links look like links)."
- Five distinct states required: "disabled, hover, focused, active/pressed and default."
- Touch floor: "a minimum of 10mm in both dimensions."
- Hierarchy: "primary actions should be visually more important-looking than secondary actions"; red communicates destructive.
- Labels: specific verbs ("Delete", "Place order"), never generic "OK"; icon-only buttons need visually-hidden text, `aria-label`, or `aria-labelledby`.
- Site's stance: no `cursor: pointer` on buttons — "cursor: pointer is for links."

```css
button { min-width: 10mm; min-height: 10mm; }
button:focus-visible { outline: 2px solid currentColor; outline-offset: 2px; }
button:disabled { opacity: 0.5; pointer-events: none; }
```

Divergence points: variant zoo is real and fine (IconButton, Split button, FAB, Toggle button, Copy button, Close button), but they are all `<button>` underneath.

**Tabs (80 examples).** Anatomy: tab list + tabs + panels; "only one panel of content is shown at any one time"; each panel is labelled by its tab. Mechanism per WAI-ARIA APG:

```html
<div role="tablist" aria-label="Reports">
  <button role="tab" id="t1" aria-controls="p1" aria-selected="true">Sales</button>
  <button role="tab" id="t2" aria-controls="p2" aria-selected="false" tabindex="-1">Traffic</button>
</div>
<div role="tabpanel" id="p1" aria-labelledby="t1">…</div>
<div role="tabpanel" id="p2" aria-labelledby="t2" hidden>…</div>
```

```css
[role='tab'][aria-selected='true'] { font-weight: 700; border-bottom: 2px solid currentColor; }
[role='tab']:focus-visible { outline: 2px solid currentColor; }
```

Keyboard: Tab focuses the active tab, Tab again leaves the list; arrows cycle tabs (horizontal lists use Left/Right, vertical lists Up/Down — set `aria-orientation="vertical"` on vertical lists); Space/Enter activates the focused tab when activation isn't automatic. Style the active tab via `[aria-selected='true']`, toggle panels with `display`/`hidden`, and give every tab a visible focus state. Divergence points: automatic vs manual activation on focus; top vs side placement; behavior on narrow screens (stack or swap to accordion). Warning that overrides all of it: "when you're using tabs, you're hiding content" — reduced discoverability for sighted and AT users; an accordion "may be more suited to your specific use case."

**Modal (82 examples).** Definition sets the contract: "appears over other content. It requires an interaction from the user before they can return to whatever is underneath." Naming splits almost evenly Modal vs Dialog, with Alert dialog, Prompt, and Confirm dialog as specialized variants. Prefer the native `<dialog>`/`popover` mechanisms before importing anything.

**Table (73 examples).** Rows and columns "for displaying large amounts of data"; aliases reveal scope creep: Datagrid, Structured List, Comparison Table. Underdocumented everywhere: only 1 of 73 examples addresses responsive behavior — treat responsive tables as your own unsolved problem, not a solved one.

**Alert (108 examples) — the second most catalogued component.** "A way of informing the user of important changes in a prominent way"; five alias families (Notification, Feedback, Message, Banner, Callout) because systems disagree on severity placement: inline banner, page-top callout, or region `role="alert"`. Choose by prominence the change deserves, then name by position (banner) or function (callout), not both.

**Loading feedback: Skeleton vs Spinner.** Skeleton = "placeholders for content yet to load," grey blocks matching final layout — use when layout is knowable, to prevent shift. Spinner = an animated indicator "in the place of, or alongside, content that is yet to load" — use when size/shape is unknowable or the wait is short. Never combine both for one region.

**Drawer (38 examples).** "A panel which slides out from the edge of the screen" — decide edge (left/right/top/bottom), whether it overlays or pushes content, and focus trapping. The aliases (Tray, Flyout, Sheet) are pure naming drift, not different components.

**Badge (123 examples — the most catalogued).** "A small label, generally appearing inside or in close proximity to another larger interface component," conveying status or metadata (Tag/Label/Chip). Position is part of the definition: if it stands alone in the layout, it's probably an Alert or a Card heading instead.

**Empty state (16 examples — rare, so usually forgotten).** "An indication to the user that there is no data to display in the current view, often with an alternate action." Ship it for every list/table view: message + the one action that fills the emptiness.

**Utility components count as components.** Skip link ("allows keyboard users to skip repetitive blocks of content", visually hidden until focused) and Visually hidden text ("hidden from the screen, but still read out by screen readers") ship as reusable primitives with a tested CSS clip pattern — not one-off hacks per page.

### 4. Naming from evidence, not taste

Every component page carries a Name-distribution chart. Observed pluralities: "Switch" beats "Toggle" (Ant Design, Spectrum, Radix, Polaris vs Atlassian, Carbon, Fluent); "Select" beats "Dropdown"; Modal/Dialog is a genuine 50/50 split; a toast is "Snackbar" in Material lineage, "Flag" at Visa, "Toaster" at Evergreen, "Floating notification" at Backpack; a tooltip is "Signpost" (Clarity), "Infotip" (eBay), "Hover Card" (Chakra/shadcn); a badge is Tag/Label/Chip depending on system; Carbon calls tables "Structured list"; Bootstrap's "Jumbotron" is everyone else's Hero. Rule: default to the plurality name; keep the alias list in docs and search; never coin a new name when two established ones exist.

### 5. What the catalogue's metadata proves

Feature tags across systems: usage guidelines appear in only ~50–60% of examples; accessibility documentation in ~25–30%; a visible minority (Ant Design, Quasar, Bulma, SubZero) ship flagged accessibility issues. Lesson: most systems' components are under-specified — matching "what systems do" is a floor, not a target. The systems worth copying are the ones that state reasons (GOV.UK, USWDS, NHS, Carbon, W3C patterns) — popularity is not evidence.

## When to use / When NOT to use

Use when: building any component from scratch; naming a component or its variants; deciding between two similar components (select/menu/combobox, tooltip/popover, alert/toast, toggle/checkbox, accordion/tabs); auditing whether a component has its full state set; writing component docs (definitions here are a proven model: one sentence + aliases + boundary vs neighbors).

Not for: copy-paste code (it deliberately ships none for most components — go to the linked systems); visual styling decisions (it prescribes no look beyond the button/accordion/tabs mechanics above); whole-page composition or design-token architecture; anything where "everyone does X" is your only justification — the site itself rejects that.

## How to apply (building any component)

1. Classify against the 60: find the component whose definition matches. If your name isn't an alias of one of them, you're building a compound — decompose it.
2. Run the boundary gates (section 2) before writing markup: value vs action vs filter; hover vs click; inline vs layer; immediate vs submitted; continuous vs discrete.
3. Start from the native mechanism: `details/summary` (accordion), `<button type>` (action), `<dialog>` (modal), `<a href>` (navigation), native form controls before ARIA rebuilds.
4. Implement the standard anatomy with correct ARIA wiring (`aria-expanded`/`aria-controls`, `role="tablist"/"tab"/"tabpanel"` + `aria-selected`, panel `aria-labelledby` back-references).
5. Ship every state: default, hover, focus-visible, active/pressed, disabled — plus checked/selected/expanded/readonly/error where the component admits them.
6. Decide the known divergence points deliberately, not by accident: accordion single- vs multi-open; icon chevron vs plus/minus; tabs automatic vs manual activation; primary/secondary/destructive button hierarchy; 10mm touch floor.
7. Name it by plurality (Switch, Select, Toast...) and record aliases; label icon-only controls; use specific verb labels, never "OK".
8. Apply the hiding-content test to anything collapsible or overlaying: if the information is essential to the task, don't put it behind a toggle.
9. Before adopting any system's pattern, check whether it documents reasons and accessibility; skip patterns whose only credential is popularity.

## AI-slop warning

Typical AI failures this taxonomy exposes: building a select where a dropdown menu belongs (or merging them into one "dropdown" component); clickable `<div>`s and `<a href="#">` buttons that lose Space/middle-click; missing `type` on buttons; inventing novel component names ("ContentRevealCard" for an accordion/Disclosure) that break team vocabulary and search; shipping only the default state (no focus-visible/disabled/checked/expanded); adding JS accordions where `details/summary` suffices; `cursor: pointer` on buttons; generic "OK/Cancel" labels; treating "most systems do it" as proof — the site's whole editorial stance is that popularity without reasons is an information cascade.

## Relations

- **desengs-ui-ux-master** — the canon index; routes component-building work here for taxonomy and anatomy, then to specialized siblings for polish.
- **desengs-web-interface-guidelines** — adds the cross-cutting interaction rules (timing, motion, focus behavior) that per-component anatomy here doesn't cover.
- **desengs-html-can-do-that** — extends the native-first mechanism: the `details/summary`, `<dialog>`, and popover-attribute primitives this catalogue's best examples reduce to.
- **desengs-ds-checklist** — system-level requirements (tokens, docs, governance, adoption) beyond a single component's anatomy.
- **desengs-design-systems-surf** — surveys the design systems themselves; use it to pick WHICH system's variant to study in depth from this catalogue's example lists.
