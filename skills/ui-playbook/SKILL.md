---
name: ui-playbook
description: Use when picking or building a common UI component (button, select, tooltip, popover, notification, input, checkbox, avatar, motion) and you need its documented behavior, exact timings, pitfalls, and a11y rules.
source: https://uiplaybook.dev/
category: reference
---

# UI Playbook — the documented reasons behind common UI patterns

Source: https://uiplaybook.dev/ — Rauno Freiberg (interface engineer, also of rauno fame). An open-source (MIT, github.com/raunofreiberg/ui-playbook) effort to document common UI components: their functionality, best practices, accessibility requirements, and examples. It exists because design systems keep re-implementing the same patterns differently, with no centralized spec for how each component should behave.

## What it is / Why it exists

Not a component library — a specification per pattern. Each "play" (Tooltip, Button, Select, Notification, TextField, Avatar, Checkbox, Motion, Popover) documents the same four things: **Functionality** (required behavior), **Best Practices** (when to use / not), **Accessibility** (WAI-ARIA Practices reference + code), and **Implementation** (the hard-won traps: `mousedown` vs `click`, disabled-button events, iOS 16px zoom). Use it *before* writing a component: it tells you what the component must do and which corners AI implementations typically cut.

## The core ideas

### Cross-cutting doctrine (applies to every pattern)

1. **Native element first.** `<button>`, `<select>`, `<input>`, `<input type="checkbox">` give keyboard behavior and ARIA semantics for free. Custom implementations must justify themselves — a fully accessible custom Select is "a substantial undertaking."
2. **Never remove `outline: 0` before adding custom focus styles.** Stated on Button, TextField, Checkbox pages.
3. **Minimum 44px target size** for pointer inputs (WCAG 2.1 Target Size) — buttons and checkboxes expand to it.
4. **Overlays render in a Portal** (outside the parent DOM hierarchy) to escape `overflow: hidden` clipping, and reposition dynamically based on collisions and available space.
5. **Disabled elements pair with a Tooltip** explaining why on hover (Button, TextField, Checkbox).
6. **Names communicate behavior, not looks.** Hence "Notification" over Toast/Snackbar/Alert: alerts belong in-context and shouldn't auto-disappear, so reusing the word for a transient message corrupts the ARIA contract.
7. **Placeholders are not labels.** They vanish once filled and aren't announced by screen readers.
8. **Respect `prefers-reduced-motion`; default to no animation** and opt in via the media query (below).

### Button

- Trigger for actions (submit form, open dialog). Use the native `<button>` element — first choice, no exceptions except nested buttons.
- Five states: hover, active, focus, disabled, loading. Loading shows a spinner and **must not change the button's width or height** (no layout shift while async work runs).
- Hierarchy via variants (primary/secondary), not via divs styled as buttons. Succinct labels; `aria-label` on icon-only buttons.
- Link-styled buttons swap the element, keep visuals (React `as` prop pattern).
- **Div-button anti-pattern:** `<div onClick>` loses all native behavior. Only legal exception: nested interactive elements are invalid HTML inside a `<button>` (e.g. a tag with select + remove). Then re-implement per WAI-ARIA Button:

```jsx
function DivButton({ 'aria-label': ariaLabel, disabled, onClick, children }) {
  function onKeyDown(e) {
    if (disabled) return;
    if (e.key === 'Enter' || e.key === ' ') onClick();
  }
  return (
    <div role="button" tabIndex={0} onKeyDown={onKeyDown}
      {...!disabled && { onClick }}
      aria-disabled={disabled ? 'true' : 'false'}
      {...ariaLabel && { 'aria-label': ariaLabel }}>
      {children}
    </div>
  );
}
```

### Select (dropdown)

- One selected value; overlay usable by mouse and keyboard; **scrolls to the selected item on open**; supports typeahead; repositions on collision; `disabled` on the trigger button.
- **Use only for 5+ options.** Fewer → radio buttons / checkboxes (all visible, no extra click). Don't use for familiar, typeable data: birth day/month/year belong in text inputs, not scrollable lists.
- Preselect a sensible default — saves clicks and nudges toward the best choice.
- Trigger is a `<button>` (semantics + SR feedback). **On mobile, fall back to native `<select>`** — you won't beat the platform widgets users already know.
- **Open on `mousedown`, not `click`:** click fires after mouseup, so the menu wouldn't open until release; mousedown enables the single press–drag–release gesture.
- On open, move focus into the listbox (trap it); close on outside click. ARIA: follow the WAI-ARIA **Listbox** practices, not Combobox.

### Tooltip

- "A non-interactive overlay that briefly explains the function of the trigger element." Shows on hover **or keyboard focus**; focus stays on the trigger; dismissed by Escape or navigating away.
- Timing: **~100ms delay before showing** (prevents accidental activation); once one tooltip is visible, hovering any other trigger shows it **immediately, no delay**.
- Never for task-critical info (the trigger's action must make sense alone), long content, or interactive content — that's a **Popover**.
- For simple cases, the native `title` attribute suffices; don't build an overlay for it.
- **Disabled-button trap:** browsers don't fire mouse events on `disabled` elements. Fix with Pointer Events (spec-compliant) or wrap the element in a `<span>` that receives the events.

### Popover

- "An interactive contextual overlay that provides additional content or actions." Opens on click / Enter / Space; traps focus inside; dismissed by Escape, outside click, or tabbing out; **focus returns to the trigger** on dismissal.
- Boundary: hover-content → Tooltip; full-screen overlay → Modal. Popover is the middle.
- Use for **secondary** actions and supplementary content (filters, descriptions) — never primary content, and never as a fix for a cramped layout.
- Don't surprise: the trigger must hint at more content ("Actions" label + chevron icon). Position beside the trigger; arrow optional but association must be obvious.
- Rich content only (images, links, lists) — it stays open after interaction, unlike a tooltip.
- Non-interactive triggers (`<img>`, bare strings) block keyboard access: warn and implicitly wrap in a `<button>`.
- ARIA on the trigger: `aria-expanded`, `aria-controls` (popover's id), `aria-haspopup` set to the popover's role.

### Notification

- Informational feedback on an action or app occurrence (also network errors). Bottom of screen, temporary, **does not interrupt or require action to disappear**. If it must interrupt and demand action → WAI-ARIA AlertDialog instead.
- Wording: graspable at a glance, **noun + verb** — "User deleted", not "The user has been deleted".
- Duration: **4s** default auto-dismiss; **up to 10s** when there's an action (e.g. Undo); make it configurable.
- **Pause the timer on hover; restart it on mouseleave** so users can finish reading.
- Position bottom-left ("least disruptive area, contains no interactive elements"); stack newest-on-top, expand on hover, **cap visible stack at 3**.
- Declarative JSX doesn't fit a global concern: mount one `<NotificationContainer />` at the app root and expose an imperative `notification.dispatch(message)` API.
- ARIA: `role="status"` (polite — waits for current SR announcement) vs `role="alert"` (assertive — interrupts). Status for "Changes saved"; alert for "Network error". **In most cases, use status.**

### TextField

- Native `<input>` underneath. States: hover, active, focus, disabled (+tooltip why), read-only (still focusable, selectable, copyable — e.g. post-submission review), error (color change **plus** an associated error message).
- Three labels: **field label** (above), **hint label** (below, extra context — use sparingly), **error label** (below, replaces the hint).
- Placeholder = a formatting *example* while empty: "joe.doe@gmail.com", not "Your e-mail address". Never a label substitute.
- Validation timing: **complex input (new password) → validate inline, immediately**; **simple input (email) → wait until the user is done** — never error mid-typing.
- Required fields: `required` + asterisk; if most fields are required, mark the minority "(Optional)" instead — less clutter.
- **Ban `<input type="number">`** (accessibility gaps, browsers mangle large numbers). Use:

```html
<input type="text" inputmode="numeric" pattern="[0-9]*">
```

- Associate labels explicitly (`for`/`id`), not by nesting (nested label/input causes stray-activation bugs); abstract id generation inside the component:

```html
<label for="email">Email</label>
<input type="email" name="email" id="email" aria-describedby="hint" />
<small id="hint">Your e-mail won't appear publicly.</small>
```

- Errors: `aria-invalid="true"` + error text wired via `aria-describedby`.
- **iOS zooms into inputs with font-size < 16px** — mobile input font must be ≥ 16px.

### Checkbox

- Native `<input type="checkbox">`. States: hover, active, focus, disabled, checked, **indeterminate** — a parent over a sub-set: unchecked if none checked, checked if all, mixed if some.
- Always provide a label (standalone checkboxes are meaningless). **Positive, active wording:** "Disable notifications", not "Don't send me notifications".
- **Checkboxes never trigger immediate actions** (no enabling/disabling features on click) — request confirmation, or use a Toggle for instant effects.
- Custom styling: `appearance: none` + absolutely-positioned SVG check over the input. **Never `display: none`** on the native input — kills focus and keyboard nav:

```css
.checkbox { appearance: none; width: 24px; height: 24px; border-radius: 4px; }
.checkbox:checked { background: #6469FF; }
.check { position: absolute; color: white; width: 16px; height: 16px; }
```

- Groups: wrap in `<fieldset>` + `<legend>` (SR announces instructions first); `disabled` on the fieldset disables all descendants.
- Mixed state: `aria-checked="mixed"` + `aria-controls="id1 id2"` on the parent listing its set.

### Avatar

- `<img>` with `alt` = the user's name; `object-fit: cover` to crop oversized photos. Real user photos, not generic silhouettes (users visually organize/recognize each other).
- **Unique fallback** when the image fails: initials on a color derived from hashing the *full name* — hue = `hash(name) % 360`, base HSL `s: 0.95, l: 0.5` + triad color as gradient partner.
- Expose at least two sizes (small for tables, large for profiles).
- SVG/color placeholders need `role="img"` + `aria-label={name}` to be announced.

### Motion

- Three principles: **predictable** (objects enter and exit the way they entered — nothing vanishes mid-air), **purposeful** (show connections, focal points, feedback), **playful** (empty states, loaders, success celebrations).
- Tiers: A = CSS-only (hover responses, pulse, shake on invalid input — echoes a head-shake); B = enter/exit animations (requires deferring unmount, e.g. spring-physics libs like react-spring / framer-motion); C = SVG brand animations, skeleton loaders (prevent layout jumps), celebrations.
- **Durations: 100–500ms total range.** ~100ms for small feedback (checkbox toggle, hover); **200–300ms** for entering/exiting (notifications, modals). Too fast distracts; too slow feels like delay.
- Springs beat fixed durations when motion can be interrupted (you can't "cancel" a 300ms curve mid-flight); CSS is fine for small interactions.
- Accessibility gate — **default to no animation**, enable only for users who haven't opted out:

```css
.button { transform: scale(1); }
.button:hover { transform: scale(1.2); }
@media (prefers-reduced-motion: no-preference) {
  .button { transition: transform 300ms; }
}
```

```js
const prefersReducedMotion =
  !window.matchMedia('(prefers-reduced-motion: no-preference)').matches;
// gate JS/canvas animation on !prefersReducedMotion
```

## When to use / When NOT to use

Use this skill when: choosing which component fits a need (select vs radios; tooltip vs popover vs title; notification vs alert dialog; checkbox vs toggle); implementing any of the nine documented patterns; wiring overlay behavior (delays, focus traps, dismissal, positioning); deciding animation duration or whether to animate at all.

Do NOT use it for: component *visual* design (colors, spacing — it specifies behavior, not looks); patterns it doesn't cover yet (modal, tabs, toggle, radio, dropdown-menu are undocumented or upcoming — fall back to WAI-ARIA APG directly); marketing-site hero effects (see siblings below).

## How to apply

1. Identify the need, then check the pattern boundaries: 2–4 choices → radios/checkboxes; 5+ → select; hover-help → tooltip (or `title` if trivial); click-menu → popover; full-screen → modal; transient feedback → notification; instant setting → toggle (never checkbox).
2. Start from the native element; list what it already gives you before writing custom code.
3. For overlays: Portal + collision-aware positioning; ~100ms tooltip delay (0ms after the first); focus trap in popover/select; focus return to trigger on dismiss; Escape + outside-click dismissal.
4. For forms: explicit `for`/`id` labels; placeholder as example; `aria-describedby` + `aria-invalid` on errors; validate complex fields inline and simple fields on blur; ≥ 16px input font on mobile; `inputmode="numeric"` not `type="number"`.
5. For feedback: 4s / 10s durations, hover-pause, stack ≤ 3 bottom-left, noun+verb copy, `role="status"` unless urgent.
6. Size interactive targets to ≥ 44px; ship hover/active/focus/disabled (+ loading for buttons, readonly/error for inputs) as separate states.
7. Scope every animation inside `prefers-reduced-motion: no-preference`; pick duration from the 100–500ms ladder.
8. Before shipping a custom Select on mobile, test the native `<select>` fallback path.

## AI-slop warning

AI's typical failures against this playbook: building a custom dropdown/select/popover from a bare `<div onClick>` (no focus trap, no keyboard, no `aria-expanded`); using placeholders as labels; `outline: 0` with no replacement focus style; error messages shown mid-keystroke; `type="number"` for numeric fields; tooltips that contain buttons (unclickable by definition); toasts that steal focus or vanish in 1.5s; animating everything at 500ms+ with no reduced-motion gate; checkbox that fires a side effect on click. The gravest slop is skipping step 1 — reaching for the *fashionable* component (popover menu, custom select) when radios, a `title`, or the native element was the documented answer. When uncertain, the native element + WAI-ARIA APG reference named in each play is the floor, not the ceiling.

## Relations

- **ui-ux-canon** — the canon index; route here first, then load this skill when a specific pattern is being picked or built.
- **web-interface-guidelines** — complementary HTML/CSS craft rules (this playbook supplies the per-component behavior contract; that skill supplies markup/styling hygiene).
- **laws-of-ux** — the perception psychology (Doherty threshold, goal gradient) that explains *why* these timings (100ms, 4s) work.
- **sonner** — a production toast library; it operationalizes this playbook's Notification rules (stacking, pause-on-hover) — check it against the numbers above.
- **rauno** — the author's own portfolio; his interface craft (focus on micro-interaction detail, reduced-motion respect) is these rules applied.
