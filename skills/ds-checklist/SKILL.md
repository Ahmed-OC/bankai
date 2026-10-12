---
name: ds-checklist
description: Use when building or auditing a design system or component library. Runs the source's 232-question taxonomy across design language, foundations, 29 core components, and maintenance to expose gaps.
source: https://www.designsystemchecklist.com/
category: reference
---

# Design System Checklist — what every complete design system must answer

Source: https://www.designsystemchecklist.com/ — Ardak Karacizmeli (with Dmitry BLV), the team behind the Reshaped design system. An open-source interactive checklist ("plan, build and grow your design system"), available in 6 languages; content lives in the repo `ardakaracizmeli/design-system-checklist` (no explicit license file).

## What it is / Why it exists

A completeness audit, not a tutorial. 232 yes/no questions organized into 4 categories — **Design language** (10), **Foundations** (26), **Core components** (168, covering 29 components), **Maintenance** (28). Every question is answerable "yes we have it / no we don't", which makes it a gap detector: run it against a design system, component library, or token set, and every "no" is a shipped task. The checklist only admits content that is "a standard for at least multiple well-known design systems" and links a reference for each item — it encodes consensus, not one team's taste.

The intended workflow is sequential: language → foundations → components → maintenance, because each layer consumes the one above it (components consume tokens; maintenance governs both).

## The core ideas

### The taxonomy (4 categories, in dependency order)

1. **Design language** — how the product communicates: brand and guidelines *before* any pixel or token. Sections: Brand (vision, design principles, tone of voice, terminology, brand assets) and Guidelines (accessibility approach, writing, microcopy for components, terminology, internationalisation incl. bi-directionality).
2. **Foundations** — "design assets and tokens that store values for the base layer… used in components, so changes on this level resonate throughout the whole system." Sections: Color, Layout, Typography, Elevation, Motion, Iconography. This is the token layer.
3. **Core components** — "main building blocks… Core components can't be broken down into granular pieces without losing their meaning." 29 components: Accordion, Alert, Avatar, Badge, Button, Breadcrumbs, Calendar, Card, Carousel, Checkbox, Divider, Dropdown, Icon, Image, Link, List, Loading indicator, Modal, Pagination, Progress bar, Input radio, Select, Skeleton, Switch, Tabs, Text area, Text field, Toast, Tooltip.
4. **Maintenance** — the governance layer most systems skip: Documentation, Local libraries, Team processes, Community support, Contribution. A system without these decays regardless of component quality.

### Foundations: the exact numbers the checklist demands

- **Layout/Units**: "the most granular building blocks" — a 4-point system with values like 4, 8, 12, 16. Grid defined separately for mobile/tablet/desktop with columns, gutters, margins. Breakpoints predefined. Spacing methods independent of the grid.
- **Elevation**: 3–4 shadow levels for the whole product; each shadow value paired with a background color (shadows carry elevation in light mode, background colors carry it in dark mode); a defined z-index scale.
- **Motion**: three easing functions — standard, accelerated, decelerated — reused across all component transitions; multiple duration values; reduced-motion support (lessen or remove animation).
- **Typography**: viewport-adaptive scale; font sizes and leading matched to the grid (e.g. text pairing with icon bounding boxes); tuned tracking/leading/line-length; font fallbacks and load performance (system fonts as the zero-cost answer).
- **Color**: AA contrast for background/text pairs; semantic variables beyond brand colors (disabled states, backgrounds, actions, high-contrast text); a prepared dark-mode palette; usage guidelines including how NOT to use each color.
- **Iconography**: one style (outlined OR filled, never mixed); names by communicative purpose ("play", not "triangle") plus discoverability keywords; bounding boxes that match the grid; accessible names (e.g. `aria-label`) for meaningful icons, none for decorative; *reserved* icons (navigation, add, delete) banned from other contexts.

### Components: 8 recurring question archetypes

The 168 component questions are a cross-product of the 29 components against archetypes. Memorize the archetypes and you can audit any component, including ones not in the inventory:

1. **Colors/roles** — a predefined color per role; WCAG AA contrast between text/icon and background (Badge, Button, Avatar, Alert…).
2. **Variants & sizes** — primary vs secondary, muted vs prominent; 2–3 sizes minimum (Avatar), small size for dense areas, large for marketing.
3. **States** — hover, active/pressed, checked, selected, error, disabled, loading, indeterminate, empty, collapsed. Buttons need hover + active + loading + disabled; loading spinners must not change button width/height.
4. **Labeling** — every form field: linked label (clicking it triggers/focuses the field), helper text, placeholder that is never a label substitute, visible or `aria-label` fallback.
5. **Composition** — content areas accept arbitrary content including other components (Accordion, Card, Modal, Toast, Tabs, Dropdown).
6. **Responsive behavior** — full-width on mobile (Alert, Card), dynamic positioning when the viewport clips (Dropdown, Tooltip), aspect-ratio-based sizing (Image).
7. **Keyboard & focus** — native elements where possible ("using native elements should provide this automatically"); arrow-key navigation for Calendar, Tabs (plus Home/End); focus trapping + return-to-trigger for Modal and Dropdown; Esc closes modals; toasts pause their timeout while focused.
8. **Announcement** — correct ARIA role per component (`button` vs `link`, resolved from props); state changes announced (selected date, selected page); lists announce item count; icons announce names; skeleton/toast/loading honor reduced motion.

### The 29 components: distinctive checks beyond the archetypes

Archetypes cover the common matrix; these are the per-component checks that catch auditors off guard:

- **Accordion** — trigger icon visually distinct between expanded/collapsed; toggle transition animates; focusing the content area announces the trigger's context.
- **Alert** — role-differentiated colors with contrast verified against content; title support for long messages; icon doubles the role for colorblind users; actions must relate to the message.
- **Avatar** — masks arbitrary image sizes from unknown sources; fallback = alternate image, icon, or text initials; 2–3 sizes minimum including small; square/circle shapes; stacks into groups; a11y label when non-decorative.
- **Badge** — muted variant (faded background) for low prominence; icon must stay recognizable at small size; dismissible when used for selected values; empty state keeps its shape; positionable relative to a parent (notification dot).
- **Button** — primary vs secondary differentiation; icon-only usage requires an accessible label; loading spinner must not change the button's width or height; announces `button` vs `link` role resolved from props; visible focus indicator.
- **Breadcrumbs** — icons on all items or none; per-item disabled; collapses to only the relevant items on overflow; separator style varies by context.
- **Calendar** — multi-month and vertical display modes; ranges show the between-dates; month switching; short weekday labels; localized date formats and weekday order; arrow-key navigation switches month when leaving a row/column; selected dates announced on focus.
- **Card** — media section full-width on top or at one side; actions at the bottom or the whole card tappable; full-width on mobile.
- **Carousel** — navigation controls for mouse users; touch via a natively scrollable area; on mobile, peek part of the next item to signal scrollability; keyboard navigation without touching the controls.
- **Checkbox** — label click toggles; indeterminate state for partially selected children; error = text + color, never color alone; disabled value excluded from the submitted form.
- **Divider** — horizontal and vertical directions; announces its role only when non-decorative.
- **Dropdown** — hover opens, and the same on trigger focus for keyboard users; dynamic positioning keeps content on screen; mobile adaptation; focus moves inside on open and returns to the trigger on close; closable by close action or tab-out.
- **Icon** (wrapper) — token colors; inherits color from the parent element; sizes pair with typography sizes so icons align with text; interactivity belongs to Button/Link — never to the icon itself.
- **Image** — width/height plus aspect-ratio sizing; fallback for broken/missing URLs; multiple asset densities served per screen; alt text when non-decorative.
- **Link** — no icon without a text label; inherits parent color and typography; multiline inside paragraphs without breaking flow; disabled state; `button` vs `link` role resolved from props.
- **List** — bulleted/numbered ordering; flexible item content; announces role + item count.
- **Loading indicator** — follows the host element's color scheme; multiple sizes; indeterminate mode vs time-remaining mode; slows its animation under reduced motion; standalone instances need an a11y label naming what is loading.
- **Modal** — bottom action area; explicit close (button or one of the actions); centered or side-sheet positioning; size driven by content; focus moves to the first focusable element and stays trapped; Esc closes; labeled by title/subtitle or an a11y label.
- **Pagination** — selected page highlighted and non-interactive; page ranges rendered around the selection; items-per-page selector; a different display mode when the page total is unknown; dynamic full labels ("page 3 of 12"), not bare numbers; state announced on focus.
- **Progress bar** — visible label; determinate vs indeterminate duration modes; a11y label when no visible label fits.
- **Input radio** — always a group (a lone radio locks the selection); label click toggles; error = text + color; disabled excluded from submit; native elements provide keyboard support automatically.
- **Select** — label click opens the dropdown; placeholder doubles as reset-to-default; error gets an icon for accessibility; helper text; start icon; prefix slot for contextual content (e.g. country flags); sizes.
- **Skeleton** — matches the sizes AND shapes of real components to avoid layout shift on load; composed from simple parts rather than 1:1 mapping the interface; reduced motion removes the pulse.
- **Switch** — label click toggles; unlike a checkbox it applies its effect immediately on check; disabled; keyboard; a11y label fallback.
- **Tabs** — variant per context (pills on the page, underlined inside cards); exactly one trigger always selected; per-trigger disabled; icons; equal-width stretching when filling the parent; arrow keys plus Home/End.
- **Text area** — label click focuses; placeholder never substitutes for the label; helper text; large size for marketing forms; a11y label fallback.
- **Text field** — everything Text area has, plus a start icon slot and prefix/suffix areas for contextual content (e.g. card provider mark on a card-number field).
- **Toast** — per-role colors; start icon; timeout long enough to read the message, otherwise a close button; stacking; contextual actions (undo a delete); focus inside pauses the timeout; reduced motion.
- **Tooltip** — opens after a short delay so it does not fire on cursor pass-through; opens on trigger focus, not just hover; flips to another position when clipped by the viewport.

### Maintenance: the governance checks

- **Documentation** (10 checks): getting-started guide, design and dev best practices, component anatomy (what's customizable vs fixed), properties documented in both design and code *and aligned across platforms*, composition examples for slotted components, a sandbox app simulating real product layouts, browser/OS support matrix, a predictable major-version release cycle.
- **Local libraries** (4): when product teams build their own vs request a system feature; horizontal (multi-product) vs vertical (single-team) libraries; minimum quality/documentation bar; local libraries must track the system's major releases.
- **Team processes** (6): a decision-making log for recurring decisions; roadmap that reserves capacity beyond bug fixes; stakeholder map including leadership; usage analytics (docs traffic, surveys, component usage); rotating support "shifts"; an SLA for requests and bugs.
- **Community & contribution** (8): platform-separated support channels; templates that demand reproduction links and design proposals; a regular update cadence; bookable open hours; house rules, contribution guidelines, a feature-proposal template guaranteeing changes apply across all platforms, and public credit for contributors.

## When to use / When NOT to use

Use when:
- Starting a design system or component library and scoping what to build first (work the checklist top-down: language → tokens → components → governance).
- Auditing an existing system, component library, or token file — generate the audit report as "no" answers grouped by category.
- Reviewing a single component PR — run just the 8 archetypes against it.
- Deciding whether a pattern belongs in the core system (is it one of the 29, or a composition of them?).

Not for:
- Deciding *visual style* — the checklist demands consistency mechanisms, not aesthetics; it cannot tell you what your brand should look like.
- One-off landing pages or prototypes — governance and documentation checks are dead weight below a certain scale; run only Foundations + the relevant components.
- Motion/interaction *quality* — it checks that easing/duration tokens and reduced-motion exist, not that an animation feels right (see `transitions`).

## How to apply (numbered audit)

1. **Draw the dependency map first.** List the 4 categories in order. You may not answer a Foundations question with a component hack (e.g. no per-component shadows — elevation is a token with 3–4 levels).
2. **Audit Design language (10 questions).** For each: vision, design principles, tone of voice, shared terminology, brand assets; then a11y approach, writing style, component microcopy rules, terminology, i18n/bi-di. Any "no" here corrupts everything below (microcopy inconsistency is a system bug, not a copy bug).
3. **Audit Foundations (26 questions).** Verify tokens exist for: unit scale (4/8/12/16), per-device grids, breakpoints, spacing; typography scale (adaptive, grid-matched, readable, fast-loading, with fallbacks); color (AA pairs, semantic set, dark palette, usage rules); elevation (3–4 shadow levels + linked backgrounds + z-index scale); motion (3 easings, N durations, reduced-motion); icons (one style, purpose names, keywords, grid-fit bounding boxes, aria strategy, reserved list).
4. **Audit components by archetype, not by memory.** For each of the 29 components (and any custom one), run the 8 archetypes as a fixed matrix; record every empty cell. Minimum bar per component: all relevant states, an accessible name, keyboard operability, and AA contrast.
5. **Score each form-field component against the full label set**: linked label, helper text, placeholder (never a label), error state (text + color, never color alone), disabled (also excluded from submit values), plus per-type extras (prefix/suffix, icon slot, sizes).
6. **Run the overlay checks**: Modal and Dropdown trap focus and return it on close; Esc closes; Tooltip opens on focus as well as hover and flips position at viewport edges; Toast stacks, pauses timeout on focus, offers undo-style actions.
7. **Audit Maintenance (28 questions).** If the system has no getting-started doc, no release cadence, no SLA, and no contribution template, mark the system "incomplete" even if every component passes — adoption will stall.
8. **Emit the gap report**: group "no" answers by category, order by blast radius (a missing token beats a missing component state beats a missing doc page), and state the fix as a task ("add `disabled` semantic color token", not "improve colors").
9. **Re-run on every major version** — the checklist is versioned content; maintenance questions (release cycle, migration support) only become answerable after the first breaking change.

### Output contract for the gap report

Every audit run should end with a report shaped like this — categories in source order, every entry an executable task:

```
DESIGN LANGUAGE — 4/10
  [ ] tone of voice: no doc — draft voice guidelines per product area
FOUNDATIONS — 14/26
  [ ] color: no semantic 'disabled' token — add to palette + link docs
  [ ] elevation: shadows hardcoded per component — extract 4-level token scale
COMPONENTS — 96/168
  [ ] Button: no loading state — add spinner that preserves dimensions
  [ ] Select: placeholder used as label — add linked label + helper text
MAINTENANCE — 3/28
  [ ] no getting-started guide — write setup doc before adding components
```

Two rules for the report: order fixes by blast radius (token > component state > doc page), and never mark a category complete while a category above it has open gaps — components built on missing foundations will be rebuilt.

### Answering the questions against a codebase

When auditing a real repo, translate archetypes into detection heuristics — a "no" is then a grep away, not a judgment call:

- **States**: search component source for `:hover`, `:active`, `:disabled`, `:focus-visible`, `data-loading`, `aria-invalid`. A component with only base styles fails archetype 3 outright.
- **Reduced motion**: `prefers-reduced-motion` must appear wherever `@keyframes` or `transition` appears — one without the other is a failed Motion (foundations) or Toast/Skeleton/Loading check.
- **Keyboard/focus**: look for `role=`, `aria-label`, `aria-labelledby`, `tabindex` handling, `keydown`/`ArrowUp` handlers in overlay components (Modal, Dropdown, Tabs, Calendar); focus trapping = focus management code on open/close.
- **Tokens**: if elevation, spacing, or duration values appear as literals (`box-shadow: 0 4px …`, `margin: 10px`, `300ms`) inside component files instead of variables, Foundations fails even when the visuals look consistent.
- **Contrast**: compute the ratio for every fg/bg pair the component can produce per variant/state; AA (4.5:1 text, 3:1 large text) is the pass line the source names.
- **Form fields**: placeholder present but no linked `<label for=…>` (or `aria-label`) is an automatic fail; disabled inputs must also be excluded from submitted values, not merely greyed out.

## AI-slop warning

AI agents fail this checklist in predictable ways:
- **Shipping components without state machines.** An AI-generated button with default styles only fails archetypes 3, 7, and 8 instantly — hover/active/loading/disabled and focus-visible are the audit, not decoration.
- **Inventing a fifth category.** The taxonomy is 4 categories; if you find yourself adding "Branding tokens" or "Utilities", you are renaming existing sections instead of answering their questions.
- **Contrast theater.** Generating a beautiful palette without AA pair checks, or checking brand colors but not the semantic set (disabled, backgrounds, actions) — the checklist explicitly separates these.
- **Documentation amnesia.** AI builds the library and skips Maintenance entirely; 28 of 232 questions (12%) are governance, and skipping them is the most common real-world system failure.
- **Placeholder-as-label.** The single most-violated form-field rule: placeholder text is never a label substitute, and disabled fields must be excluded from submitted values.
- **One-off values.** A shadow or duration hardcoded inside a component is a failed Foundations check even if it looks right — "changes on this level will resonate throughout the whole system" is the whole point of tokens.

## Relations

- `tokens-generator` — once this checklist exposes missing foundations, that skill generates the actual token files (spacing, color, typography scales).
- `web-interface-guidelines` — deeper per-element UI rules that expand several archetype checks (spacing, touch targets, states) beyond yes/no.
- `design-systems-surf` — live design systems to study for the reference link each checklist item demands; use it to benchmark answers.
- `oklch` — how to construct the color palette that passes this checklist's AA and dark-mode questions.
- `bankai` — the canon index that dispatches to this skill when a design-system audit is requested.
