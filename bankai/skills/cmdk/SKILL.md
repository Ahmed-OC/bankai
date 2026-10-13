---
name: cmdk
description: Use when building or evaluating a ⌘K command palette, searchable command menu, or combobox in an app. Encodes cmdk's anatomy, fuzzy scoring, keyboard model, and a hand-built equivalent.
source: https://github.com/pacocoursey/cmdk; https://raw.githubusercontent.com/pacocoursey/cmdk/main/ARCHITECTURE.md
category: library
---

# cmdk — the command palette, done properly

Source: https://github.com/pacocoursey/cmdk — Paco Coursey's fast, unstyled, composable command-menu React component. MIT. Docs = README + ARCHITECTURE.md (the listed docs site cmdk.paco.io does not resolve; do not cite it). Written 2019 as a composable-combobox experiment, rewritten 2022; powered Vercel's command menu (Rauno Freiberg, 2020). Requires React 18 (`useId`, `useSyncExternalStore`).

## What it is / Why it exists

A command palette is one input that makes every action in an app reachable by typing. It serves two users at once: power users (⌘K, type, Enter — no pointer path) and discoverers (type a word, see grouped matches with their shortcuts). It collapses nested nav, buried settings, and rarely-used actions into a flat, searchable index.

cmdk exists because a palette is ~10 details and every hand-rolled one gets 6 right: ARIA combobox wiring, focus trap, filter-that-preserves-DOM-order, first-item auto-selection, empty/loading states, scroll-into-view. cmdk packages exactly those details, unstyled, behind data-attributes (`cmdk-root`, `cmdk-input`, `cmdk-item`…) so the mechanism is orthogonal to the skin. Its second job: it is equally a valid accessible combobox — you render items, it filters and sorts them automatically.

## The anatomy (component inventory)

- `Command` `[cmdk-root]` — inline menu. Props: `value`/`onValueChange` (controlled selection), `filter` (custom rank fn), `shouldFilter={false}`, `loop`, `label` (required for a11y), `defaultValue`.
- `Command.Dialog` `[cmdk-dialog]` + always-rendered `[cmdk-overlay]` — composes Radix Dialog: modality, focus trap, portal (`container` prop, defaults `body`). Props forward to `Command`.
- `Command.Input` `[cmdk-input]` — plain input, controlled via `value`/`onValueChange`. This is the only focusable thing; all keys route through it.
- `Command.List` `[cmdk-list]` — scroll container. Animates height via `--cmdk-list-height` CSS var; `scroll-padding-block: 8px` makes `scrollIntoView` trigger earlier near edges.
- `Command.Group` `[cmdk-group]` + `heading` → `[cmdk-group-heading]` — never unmounts; hidden via the `hidden` attribute (style `&[hidden]` explicitly, it's not `display:none` by default once you style it). Groups re-sort by their best item's score.
- `Command.Item` `[cmdk-item]` + `[data-selected]`/`[data-disabled]` — `value` (auto-inferred from `textContent` if omitted, must be unique), `onSelect(value)`, `keywords={['fruit']}` (filter aliases, trimmed), `forceMount`, `disabled`. Becomes active on pointer enter, before any click.
- `Command.Separator` `[cmdk-separator]` — visible only when search is empty (or `alwaysRender`). Rationale: separators group visually; under search, score-order grouping replaces them.
- `Command.Empty` `[cmdk-empty]` — auto-renders at zero matches. Read `state.search` via `useCommandState` to echo the query back ("No results for "proj"").
- `Command.Loading` `[cmdk-loading]` — you render it conditionally for async result sets.
- `useCommandState(s => s.search)` — `useSyncExternalStore` over the internal store; advanced use only.

## The core ideas

**1. The DOM is authoritative.** All items stay in the React tree; each item adds/removes itself from the DOM when the search changes. Selection order = DOM order = the order you composed. This is why the API is compound components, not `items={[...]}` or render props: consumers can interleave `<BlogItems/>`, static JSX, and conditional items freely, and filtering still works — impossible with `React.Children` iteration or data-array APIs. Cost: 2,000 items filtered to 2 still allocate 2,000 component instances; DOM stays at 2. Accepted trade.

**2. Selection is tracked by value, never by index.** The 2019 version tracked index 0..n; that breaks under Strict Mode (double effects) and concurrent mode. The 2022 rewrite keys selection on the item's stable `value` string. If you hand-roll a palette and store `activeIndex`, you are rebuilding the bug they already fixed.

**3. Filtering = scoring.** Default filter is fuzzy subsequence scoring (`command-score`): matches out-of-order characters but ranks them. Filter contract: `(value, search, keywords) => 0..1`; 1 = best, 0 = hidden. Exact constants from the source: continuous match 1.0; match after a space 0.9; after a gap char (`/ \ _ + . # " @ [ ( { &`) 0.8; any other character jump 0.17; transposed letters 0.1. Penalties: skipped char ×0.999, case mismatch ×0.9999, distance from start ×0.9, incomplete word ×0.99. Consequences you can state: "sett" beats "settings" over "reset tokens" because prefix-continuity dominates; word-start matches beat mid-word matches by ~5×. After each keystroke: filter → sort items by score → sort groups by their max item score → auto-select first item if none selected. Values and keywords are always `trim()`med.

**4. The keyboard contract.** ⌘K/Ctrl+K listener is deliberately NOT built in — you write `if (e.key === 'k' && (e.metaKey || e.ctrlKey)) { e.preventDefault(); toggle() }` yourself "to have full control over keybind context" (don't steal ⌘K from an editor page). Inside: type to filter; ↑/↓ move selection (wrap only with `loop`); Enter runs `onSelect`; Escape closes the Dialog — or pops one page in nested menus; Backspace pops a page only when search is empty. On search change the first item is auto-selected so Enter always does something.

**5. Nesting is just state, not a component.** Submenus ("Change theme…" → dark/light) are a `pages` array stack; render the top page's items or the last pushed page's items, pop on Escape/empty-Backspace. Sub-items that only appear while searching: read `state.search` and return `null` when empty. No tree abstraction needed.

**6. Scale limits are stated, not hidden.** Good to ~2,000–3,000 items. Beyond: `shouldFilter={false}`, filter yourself, bring your own virtualizer. Async sets: render items as they arrive; filtering re-runs automatically; show `Command.Loading` meanwhile.

**7. Skin via attributes, proven by four skins.** The repo ships vercel/linear/raycast/framer drop-in stylesheets over the identical DOM — proof the component is genuinely unstyled. Canonical numbers (vercel theme): root `max-width: 640px`, `border-radius: 12px`, `padding: 8px`; item `height: 48px`, `font-size: 14px`, `border-radius: 8px`, `gap: 8px`, icons 18px; input `font-size: 17px` with a 1px bottom border; group heading and `kbd` hints 12px; list `max-height: 400px`, `overscroll-behavior: contain`, height transition `100ms ease`; selected item = one background-tint step + one text-contrast step, never color-only.

## When to use / When NOT to use

Use a palette when: the app has >~20 reachable actions or destinations; users live in it all day with a hardware keyboard; navigation is deeper than 2 levels; global actions exist that have no home (theme switch, "go to project…", sign out); you need one entry point for search + actions + AI prompt. It is the cheapest way to give every feature a second, searchable path.

Do NOT use when: it's a marketing or content site — palettes serve known-item lookup ("I know it's called settings"), and visitors don't know your vocabulary; the site has <10 links (a visible nav is faster and shows options); the primary context is touch — an on-screen keyboard plus a floating dialog is misery (use a bottom sheet with visible chips instead); or you'd bolt it on for the "modern SaaS" aesthetic. If a visible menu can show all options within one glance, the palette adds a keystroke and hides affordances for nothing.

## Build the mechanism by hand (no dependency)

The whole contract in ~40 lines — ARIA combobox pattern, value-based selection, fuzzy score, keyboard loop:

```html
<div role="dialog" aria-modal="true" aria-label="Command menu" class="palette">
  <input role="combobox" aria-expanded="true" aria-autocomplete="list"
         aria-controls="cmd-list" aria-activedescendant="" placeholder="Type a command…">
  <div role="listbox" id="cmd-list"></div>
</div>
```

```js
const ITEMS = [
  { value: 'settings', hint: 'Settings', kw: ['preferences', 'config'] },
  { value: 'theme',    hint: 'Change theme…', kw: ['dark', 'light'] },
];
let active = null; // value string, never an index

const score = (v, s) => {           // fuzzy subsequence rank, 0..1
  s = s.trim().toLowerCase(); if (!s) return 1;
  v = v.toLowerCase(); let i = 0, streak = 0, best = 0;
  for (const ch of v) i = ch === s[i] ? (streak++, i + 1) : i;
  // rank: longer streak + earlier end of match wins; refine with word-start bonus
  return i === s.length ? (streak / s.length) * (s.length / v.length) : 0;
};

function render(search) {
  const list = document.getElementById('cmd-list');
  const hits = ITEMS.map(it => ({ ...it, r: Math.max(
    score(it.hint, search), ...it.kw.map(k => score(k, search))) }))
    .filter(it => it.r > 0).sort((a, b) => b.r - a.r);
  list.innerHTML = hits.length ? '' : '<div class="empty">No results.</div>';
  hits.forEach(it => {
    const o = document.createElement('div');
    o.role = 'option'; o.id = 'opt-' + it.value; o.dataset.value = it.value;
    o.textContent = it.hint;
    o.onpointerenter = () => setActive(it.value);   // hover = active, like cmdk
    o.onclick = () => select(it.value);
    list.append(o);
  });
  if (!active || !hits.some(h => h.value === active)) active = hits[0]?.value ?? null;
  setActive(active);                                  // auto-select first item
}
function setActive(v) {
  active = v;
  document.querySelectorAll('#cmd-list [role=option]').forEach(o => {
    o.setAttribute('aria-selected', String(o.dataset.value === v));
    o.classList.toggle('sel', o.dataset.value === v);
    if (o.dataset.value === v) o.scrollIntoView({ block: 'nearest' });
  });
  document.querySelector('[role=combobox]').setAttribute('aria-activedescendant', active ? 'opt-' + active : '');
}
const input = document.querySelector('[role=combobox]');
input.oninput = e => render(e.target.value);
input.onkeydown = e => {
  const opts = [...document.querySelectorAll('#cmd-list [role=option]')];
  const i = opts.findIndex(o => o.dataset.value === active);
  if (e.key === 'ArrowDown') { e.preventDefault(); setActive(opts[(i + 1) % opts.length]?.dataset.value); }
  if (e.key === 'ArrowUp')   { e.preventDefault(); setActive(opts[(i - 1 + opts.length) % opts.length]?.dataset.value); }
  if (e.key === 'Enter')     { e.preventDefault(); active && select(active); }
  if (e.key === 'Escape')    { close(); }
};
function select(v) { /* run the action; close dialog; restore prior focus */ }
document.addEventListener('keydown', e => {
  if (e.key === 'k' && (e.metaKey || e.ctrlKey)) { e.preventDefault(); open(); }
});
```

Skin with the canonical numbers, ported to plain CSS:

```css
.palette { width: min(640px, calc(100vw - 32px)); border-radius: 12px; padding: 8px;
  background: var(--bg); border: 1px solid var(--border); box-shadow: 0 16px 48px rgb(0 0 0 / .16); }
[role=combobox] { width: 100%; font-size: 17px; padding: 8px; border: 0; outline: 0;
  border-bottom: 1px solid var(--border); }
[role=listbox] { max-height: 400px; overflow-y: auto; overscroll-behavior: contain;
  scroll-padding-block: 8px; transition: height 100ms ease; }
[role=option] { height: 48px; display: flex; align-items: center; gap: 8px;
  padding: 0 16px; border-radius: 8px; font-size: 14px; cursor: pointer; }
[role=option].sel { background: color-mix(in oklab, var(--fg) 8%, transparent); }
[role=option] kbd { margin-left: auto; font-size: 12px; padding: 2px 6px; border-radius: 4px;
  background: color-mix(in oklab, var(--fg) 6%, transparent); }
[role=option][hidden] { display: none; }  /* groups/items hide, never unmount */
```

Install cmdk instead when: React 18 app, you want the combobox correctness (focus restoration, `aria-activedescendant` lifecycle, group registration, Strict-Mode-safe ordering) and the Radix Dialog composition for free, and you will not exceed ~3,000 items. Skip it when you're not on React, or when you need virtualized 10k+ lists — fighting the always-mounted design costs more than the dependency saves.

## How to apply

1. Trigger: visible button labeled "Search… ⌘K" + global keydown on k + meta/ctrl with `preventDefault()`. Never bind ⌘K on pages where an editor or browser owns it.
2. Open state: render `open={false}` on the server; focus the input on open; restore focus to the trigger on close.
3. Input: 17px, no chrome, one bottom border; placeholder states the verb ("Type a command or search…").
4. List: grouped by task domain, not alphabetically; 12px headings; 48px items; icon 18px + label + optional right-aligned `kbd` shortcut.
5. Filtering: keep fuzzy scoring; add `keywords` aliases for synonyms users actually type; trim everything; never match on the icon name.
6. Always auto-select the first result after each keystroke; keep selection by value across filter passes.
7. Style `[hidden]` explicitly — groups hide via attribute, and your CSS must honor it.
8. Ship `Empty` (echo the query) and `Loading` states; async results render incrementally.
9. Nested flows: a page stack; Escape pops, Backspace pops only when input is empty, breadcrumb the path above the input.
10. Scroll: `overscroll-behavior: contain` on the list, `scroll-padding-block: 8px`, `scrollIntoView({block:'nearest'})`.
11. Test with keyboard only, then with a screen reader (combobox + listbox + activedescendant). If Enter can ever do nothing, it's broken.
12. Audit reachability: every palette item should also exist in visible UI. The palette is a second path, never the only one.

## AI-slop warning

The ⌘K palette is the single most over-applied pattern in AI-generated UI: every scaffolded SaaS starter ships one, including five-page marketing sites and admin dashboards with 8 links — there, it hides options behind a blank input and signals borrowed taste, not power. Tells: a search box with nothing to find, items that duplicate the nav verbatim, no ⌘K binding at all, fuzzy highlighting as decoration on 3 items. Second failure mode: rebuilding it badly instead of using it — index-based selection (breaks on re-filter), `onChange` filtering that loses focus, missing `aria-activedescendant`, a click-only palette that ignores ↑/↓/Enter, or a "Loading…" that never resolves. If the app doesn't pass the >20-actions bar, delete the palette and spend the effort on the visible nav.

## Relations

- rauno — the interaction designer behind the palette that made cmdk famous; adds taste-level context for hover-to-active, restraint, and why palettes read as "fast".
- web-interface-guidelines — the keyboard and focus rules (event-key handling, `:focus-visible`, scroll containment) this component implements; consult before hand-rolling.
- interfaces-dev — broader component-anatomy canon; the palette is one entry there, this skill is the deep cut.
- loading-dev — the async/loading half of the palette contract (skeletons vs spinners while `Command.Loading` shows).
- transitions — supplies the timing judgment for the `100ms` height animation and overlay fade; contradicts any impulse to animate the item list itself.
