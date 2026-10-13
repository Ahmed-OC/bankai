---
name: html-can-do-that
description: Use when a UI pattern seems to need JS or a component library — a pre-flight checklist of native HTML capabilities (popover, dialog, details accordions, invokers, lazy loading, datalist) that may already do the job.
source: https://chrisburnell.com/html-can-do-that/
category: reference
---

# HTML Can Do That? — native capabilities before JavaScript

Source: https://chrisburnell.com/html-can-do-that/ — Chris Burnell, single-page showcase written in one hour for HTML Day 2026 (online event run by Zachary Kai, 2026-08-08; a11y-focused update 2026-08-20). No license stated; the author explicitly invites corrections and self-describes as "not an expert."

## What it is / Why it exists

Thesis, in the author's words: "HTML has been gobbling up swathes of what used to be JavaScript's remit." The page lists dynamic UI functionality achievable with zero JavaScript, each item paired with a live demo, MDN link, and caniuse link.

Its job in this canon: a **pre-flight checklist**. Before any component gets hand-rolled or `npm install`ed, match the pattern against the native column below. If HTML does it, HTML does it — JS only layers the delta.

Critical framing from the 2026-08-20 update: the author revised the page specifically "to better express and highlight where the browser implementation of some of this stuff is severely lacking and/or completely fails to meet accessibility needs. So, by all means, try it out, but **make it as accessible as you can**!" Every item below therefore carries two verdicts: *native exists* and *safe to ship*. They are not the same column.

## The core ideas — the verified inventory

Scope note: the source covers exactly these 8 items. It does NOT cover CSS `field-sizing`, `:has()`, scroll-driven animations, view transitions, `accent-color`, `accesskey`, or `typeahead` beyond `<datalist>`. Do not cite this skill as backing for those.

### 1. `popover` + `popovertarget` — zero-JS popovers

Light dismiss, `Esc` to close, top-layer promotion (no `z-index` wrangling) — all from attributes.

```html
<button popovertarget="my-popover">Toggle popover</button>
<div id="my-popover" popover>
  <p>Top layer, Esc-to-close, light-dismiss — no JavaScript.</p>
  <button popovertarget="my-popover" popovertargetaction="hide">Close</button>
</div>
```

- Replaces: tooltip/menu/popover JS packages and their focus/focus-trap plumbing.
- Support era: Baseline since 2024 (Chrome 114, Safari 17, Firefox 125).
- Mechanism notes: default `popover` is light-dismiss (`popover="auto"`); `popover="manual"` disables it. The browser handles top layer, Esc, and closing on outside click.

### 2. `<dialog>` — native modals, two ways

```html
<!-- Way 1: HTML-only — dialog wearing the popover machinery -->
<button popovertarget="my-dialog">Toggle dialog popover</button>
<dialog id="my-dialog" popover>
  <form method="dialog"><button>Close</button></form>
</dialog>

<!-- Way 2: the JS API — the one case for modal semantics -->
<dialog id="modal">
  <form method="dialog"><button>Close</button></form>
</dialog>
<script>
  document.getElementById("open-btn").addEventListener("click", () =>
    document.getElementById("modal").showModal());
</script>
```

- Replaces: Radix/Headless-UI-style Dialog components whenever styling and focus needs are modest.
- Support era: element Baseline since 2022 (Firefox 98, Safari 15.4).
- Mechanism notes: `.showModal()` gives real modal semantics (backdrop, focus containment, `::backdrop` styling); `<form method="dialog">` closes any dialog with zero JS; `popovertarget` opens/closes a `popover`-attributed dialog without JS.

### 3. Grouped `<details name>` — exclusive accordions

```html
<details name="accordion-group">
  <summary>First</summary>
  <p>Open the second one and watch this close on its own.</p>
</details>
<details name="accordion-group">
  <summary>Second</summary>
  <p>First one's hidden now.</p>
</details>
```

- Replaces: every hand-rolled accordion with `useState`/`itemOpen` state and every accordion dependency.
- Support era: all engines by late 2024 (Chrome 120, Safari 17.2, Firefox 130).
- Mechanism note: a shared `name` value makes the group exclusive — open one, the rest close. Style the marker via `summary::-webkit-details-marker` / `list-style: none` and animate with the modern `details::details-content` + `interpolate-size: allow-keywords` (outside the source's scope; verify before relying on it).

### 4. `command` / `commandfor` — invoker commands

Separate buttons controlling one target popover. No scripting.

```html
<button command="show-popover" commandfor="target">Open</button>
<button command="hide-popover" commandfor="target">Close</button>
<dialog id="target" popover>…</dialog>
```

- Replaces: the open/close state wiring that normally accompanies #1 and #2.
- Support era: newest item here — per the author, `show-modal`, `close`, `request-close`, `toggle-popover`, `show-popover`, `hide-popover` are the invokers that have landed stable in browsers (Chromium and WebKit; Firefox pending). Treat as progressive enhancement with `popovertarget` as fallback.
- Future invokers named by the author: increment/decrement values, media-element control, copy text.

### 5. `loading="lazy"` — drop the lazy-load library

```html
<img src="/avatar@2x.jpeg" loading="lazy" width="200" height="200" alt="…">
```

- Replaces: `IntersectionObserver` scaffolding, lazysizes-style plugins, `react-lazyload`.
- Support era: universal since ~2022 (Chrome 76 in 2019, Firefox 75 in 2020, Safari 15.4).
- Mechanism note: defers loading until near the viewport — the demo text says "Not an `IntersectionObserver` in sight." Always ship explicit `width`/`height` (as shown) to reserve space and kill CLS.

### 6. `hidden="until-found"` — findable hidden content

```html
<a href="#spoiler">Jump to hidden content</a>
<div id="spoiler" hidden="until-found">
  <p>Revealed automatically when the fragment is navigated to.</p>
</div>
```

- Replaces: custom "expand on anchor click" JS; enables Ctrl+F to find content inside collapsed regions.
- Support era: Chromium since 102 (2022) and Safari 17.4 (2024); Firefox pending.
- Caveat (author's): "only really plays nicely with browser default search, and not so well with screen reader search implementations… one to keep in the back pocket." Not production-critical.

### 7. Native form controls: `type="color"`, `type="date"`, `type="range"`, `<progress>`, `<meter>`

```html
<label>Colour <input type="color" value="#663399"></label>
<label>Date   <input type="date"></label>
<label>Range  <input type="range" min="0" max="100" value="50"></label>
<progress value="42" max="100">42%</progress>
<meter min="0" value="50" max="100" low="20" high="80" optimum="90"></meter>
```

- Replaces: color/date/range picker libraries, progress-bar components, gauge SVGs.
- Support era: shipped since ~2011–2012; availability was never the problem.
- **Warning, verbatim weight**: "the implementations shipping in browsers are, unfortunately, lacking… You can expect things like the default browser styles of these elements to vary pretty wildly between browsers and for the accessibility experiences to be very poor. Be wary of the many pitfalls!" `<progress>`/`<meter>` for read-only display are the safest of the set; interactive pickers need careful cross-browser/a11y review first. `accent-color` styling is outside this source's claims.

### 8. `<datalist>` — native autocomplete suggestions

```html
<label>Favourite HTML element
  <input type="text" list="element-options">
</label>
<datalist id="element-options">
  <option value="a"><option value="abbr"><option value="address">
</datalist>
```

- Replaces: combobox/autocomplete dropdown libraries — in theory.
- Support era: shipped for years (Firefox 4 in 2011, Chrome 20 in 2012, Safari 12.1 in 2019) — but age ≠ quality.
- **Warning (author's)**: "Support for this across input types is still pretty spotty, and there are also a number of issues in its implementation in browsers." He points to Adrian Roselli's *Under-Engineered Comboboxen* and concludes "You might even want to skip using this for now." Default: do not ship `<datalist>` as an a11y-critical combobox.

## When to use / When NOT to use

Use when:
- About to hand-roll or install: a modal, popover/tooltip, accordion, combobox, lazy-image loader, progress indicator, or picker. Check the table above first — the default answer is the native mechanism, with JS only for the delta (custom events, persistence, validation UX).
- Working with a low-JS budget: content sites, marketing pages, docs, internal tools — the native set covers most interactive needs outright.
- The feature is newest-wave (invokers, `until-found`): ship it as progressive enhancement over an older native fallback, not as the only path.

Do NOT use when:
- Pixel-exact, brand-consistent styling of form controls is a hard requirement — the author's own warning says these "vary pretty wildly between browsers."
- The control is a11y-critical (combobox, date picker in a checkout): the source itself flags `<datalist>` and the native pickers as failing accessibility needs in places. Use a vetted accessible component and say why.
- Firefox is a supported browser and the feature is `command`/`commandfor` or `hidden="until-found"` — no fallback, no ship.

## How to apply — the pre-flight checklist

1. Name the pattern you're about to build or install (modal, popover, accordion, autocomplete, lazy media, progress, gauge, picker).
2. Look it up in the inventory above. If a native mechanism exists, it becomes the default implementation.
3. Write it with the source snippet as the skeleton: attributes (`popover`, `popovertarget`, `name`, `command`/`commandfor`, `loading`, `hidden`) — not state, not effects, not a dependency.
4. Add JS only for the named delta (analytics, persistence, multi-step flows) — never to re-implement open/close/Esc/top-layer.
5. For newest-era features, verify current engine support, then ship as enhancement over a `popovertarget`-era fallback.
6. Before shipping native form controls or `<datalist>`: keyboard-test, screen-reader-test, and cross-browser-style-test. If any fail, swap to a vetted accessible component — that is the author's stated bar, not a regression.
7. Always pair `loading="lazy"` images with explicit `width`/`height` attributes.
8. Keep the list re-checked quarterly — the author's stance is that invokers are "useful for lots of other non-JS functionality, one day."

## AI-slop warning

How AI misapplies this source:
- Defaulting to a component library or `useState`-driven modal/accordion when 3–6 lines of attribute-bearing HTML do the same job — the exact bloat this skill exists to intercept.
- The reverse sin: quoting "HTML can do that" to skip accessibility testing. The author's closing lines are the antidote: "Do not use this page to justify decisions to your boss. *Or yourself.* Don't forget that not everyone browses the web like you do." Native ≠ accessible-by-default; the page's own update exists to say so.
- Shipping `<datalist>` or native pickers into a11y-critical flows because "it's native" — the source explicitly warns against exactly this.
- Crediting this skill for features it doesn't cover (`:has()`, view transitions, `field-sizing`, `accent-color`) instead of verifying against the source.

## Relations

- **details-feel-better** — the craft companion for item #3: how to make `<details>`/`<summary>` feel designed rather than default, once you've chosen the native accordion.
- **fancy-components** — the escape hatch this skill gates: when the native mechanism fails the a11y/styling bar, this is the vetted route to a richer component.
- **web-interface-guidelines** — the quality/a11y bar that native elements must still meet; use it for step 6 of the checklist.
- **you-dont-need-animations** — the same anti-bloat doctrine applied to motion: native CSS over animation libraries; pairs with this skill's JS-over-HTML inversion.
