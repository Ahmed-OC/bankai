---
name: desengs-devl
description: Use when building full app screens (shells, auth, dashboards, tables, settings, empty states) and needing a production-fidelity structural reference or proven interaction pattern before designing from scratch.
source: https://devl.dev/
category: library
---

# devl.dev (desengs) — 158+ full-screen app-UI experiments catalogued as a file tree

Source: https://devl.dev/ — Sean Brydon (@seanbrydon13, Cal.com), self-described "scratch pad": two years of UI experiments, every entry a live, themeable, interactive `.tsx` screen built on coss-ui (Tailwind v4 + Base UI, shadcn-registry format, `cosscom/coss`). Free to browse; press `c` on any design to copy its source. No separate license stated on-site — code access is via the in-site copy key; primitives live in the open-source coss repo.

## What it is / Why it exists

Most component galleries show isolated primitives inside a docs frame. devl.dev fills the gap one level up: **complete app screens at production fidelity** — the whole two-pane settings page, the whole invoice table with filters, the whole auth flow — with realistic data ("Acme inc. · Pro · 24 members", "Net revenue $100.4k, +18.4% vs prev. 12mo") instead of "Lorem ipsum". It answers the question a primitive library cannot: *how do the parts compose into a screen, and what does real content do to the layout?*

Second contribution: the gallery itself is a UX artifact. The index is styled as a code-editor file tree (18 folders, filenames, `wip` badges), fully keyboard-driven — `←→` browse within a folder, `↑↓` jump between folders, `r` random design, `t` toggle light/dark, `c` copy source, `⌘K` fuzzy jump-to-search. Grid/stack view toggle in the header. Even the 404 is a designed empty state ("Folder not found. No folder named X. ← Back to folders") — the author dogfoods every pattern the gallery teaches.

Third: charts are hand-rolled "pure SVG" — no charting library — proving axis-light business charts are ~40 lines of markup.

## Inventory (18 folders, ~158 entries)

- **Layouts (12)**: workspace-rail, mini-rail, docs-tree, inbox-rail, app-shell, two-pane, three-pane, split-resizable, focus-mode, floating-toolbar, canvas-tools, bottom-nav
- **Forms (4)**: workspace-settings, invite-teammates, notifications, api-key
- **Auth & onboarding (14)**: login, onboarding, waitlist, check-email, inset-login, centered-signin/signup, left/right-signin, glass-signup (wip), otp-verify, reset-password, two-factor, magic-link-sent
- **Dashboards (9)**: metrics-overview, usage, analytics, home, revenue, services, engineering, support, market (several wip)
- **Tables (9)**: invoices, members, orders, logs, api-keys, inventory, issues, transactions, audit-log
- **Filters (4)**: toolbar, faceted, chips, sidebar
- **Empty states (10)**: inbox-zero, no-results, first-project, end-of-feed, no-team, trash, 404, maintenance, no-files, offline
- **Settings (12)**: profile, appearance, billing, integrations, security, permissions, branding, localization, webhooks, privacy, developer, sso
- **Cards (10)**: stat-tile, profile, pricing, product, invoice, task, event, integration, media, payment-method
- **Modals (10)**: confirm-delete, share-link, upload-files, command-palette, feedback, shortcuts, upgrade, export, create-workspace, two-factor-setup
- **Charts (9, pure SVG)**: revenue-area, cohort-heatmap, funnel, gauges, bar-grouped, line-multi, donut, scatter, waterfall
- **Timelines (12)**: audit, notifications, changelog, commits, approvals, pull-request, deploys, inbox-thread, activity-feed, releases, status-page, pr-ops-console
- **Calendars (9)**: month, week, agenda, date-range, timezone, mini, year-heatmap, recurring, holidays
- **Profile (10)**: hero, hover-card, team-grid, directory, compact-card, org-chart, skills, presence-rail, introductions, credentials
- **Toasts & banners (6)**: success, error-retry, info-banner, progress, undo, rich
- **Pricing (6)**: three-tier, comparison-table, slider-seats, simple-card, contact-sales, monthly-yearly
- **Tours & coachmarks (6)**: welcome-carousel, spotlight, arrow-tooltip, beacon, inline-hint, checklist
- **Threads & comments (6)**: inline-thread, side-panel, comment-row, mention-popover, resolved, compose-rich

## The core ideas

1. **Screens, not components, are the unit of reuse.** When starting a page, pick a structural sibling from this inventory (e.g. `three-pane` for a mail-like app, `split-resizable` for a code editor, `sidebar` filter pattern for tables) and adapt — do not assemble from primitives and hope.
2. **Realistic data is a design tool.** Every demo uses believable quantities: badge counts (Inbox 4, engineering 24), money ($100.4k), deltas (+18.4% vs prev. 12mo), precise timestamps ("Nothing new since 8:42 this morning"). Design with data that has the length and variance of production, or the layout lies about density.
3. **Act, then offer time-boxed undo — never pre-confirm.** The undo toast runs a live countdown the user can see: "Project archived. 'Q3 planning' moved to archive. [Undo] 8.0s left to undo." The visible timer converts an ambiguous toast into an explicit grace window.
4. **Empty states are achievements, not apologetics.** inbox-zero: progress framing ("This week: 47 cleared"), a calm illustration ("A quiet horizon"), a reassuring headline ("You're all caught up."), FOMO removal ("we'll let you know when something arrives"), and two secondary onward actions (View archive / Snooze new mail). Tone: reward, not error.
5. **Charts without a chart library.** The pattern is always: one hero KPI (value + delta vs previous period) + one SVG drawing + a legend naming exactly the series drawn. No axes, no gridlines beyond 25%-step baselines — the KPI card carries the numbers the user actually reads.
6. **The rail is a standard organ.** workspace-rail's order is stable: workspace switcher (name + plan + member count) → Quick find with ⌘K hint → primary nav with right-aligned badge counts → scrollable projects/teams lists with counts → pinned user footer with presence dot. mini-rail (icons only) is the collapsed variant.
7. **Command palette = three groups, typed jump targets.** Suggestions (create/invite/switch, each showing its eventual shortcut), Jump to (documents, projects, channels, branches — each tagged with its resource type), Settings (with key sequences like `G P`). Footer states the contract: `↑↓ navigate · ↵ select · ESC dismiss`.

## Signature techniques in plain code

**Undo toast with visible countdown** (replaces confirm dialogs for reversible actions):

```js
function undoToast(label, detail, { seconds = 8, commit, revert } = {}) {
  const el = document.createElement("output");
  el.role = "status"; // announced politely, not assertively
  el.innerHTML = `<strong>${label}</strong> ${detail}
    <button>Undo</button> <span>${seconds.toFixed(1)}s left to undo</span>`;
  document.body.append(el);
  let remaining = seconds;
  const id = setInterval(() => {
    remaining -= 0.1;
    if (remaining <= 0) { clearInterval(id); el.remove(); commit(); }
    else el.querySelector("span").textContent = `${remaining.toFixed(1)}s left to undo`;
  }, 100);
  el.querySelector("button").onclick = () => { clearInterval(id); el.remove(); revert(); };
}
// fire-and-forget the action; revert must restore prior state exactly
```

**Pure-SVG KPI area chart** (the whole revenue-area mechanism):

```html
<!-- KPI card carries the numbers; SVG carries only the shape -->
<div class="kpi">Net revenue <b>$100.4k</b> <em>+18.4% vs prev. 12mo</em></div>
<svg viewBox="0 0 600 160" preserveAspectRatio="none" role="img"
     aria-label="Revenue by stream, last 12 months">
  <defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
    <stop offset="0%"  stop-color="currentColor" stop-opacity=".3"/>
    <stop offset="100%" stop-color="currentColor" stop-opacity="0"/>
  </linearGradient></defs>
  <path d="M0,120 L55,112 L109,124 L164,96 L218,102 L273,80 L327,88 L382,64 L436,70 L491,48 L545,54 L600,36 L600,160 L0,160 Z"
        fill="url(#g)"/>
  <path d="M0,120 L55,112 L109,124 L164,96 L218,102 L273,80 L327,88 L382,64 L436,70 L491,48 L545,54 L600,36"
        fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
</svg>
<ul class="legend"><!-- one swatch per series actually drawn -->
  <li><i style="background:#4f7cff"></i>Subscriptions</li>
  <li><i style="background:#9d5cff"></i>Add-ons</li>
  <li><i style="background:#22c08b"></i>Services</li>
</ul>
```

Stacked areas: draw series back-to-front, each path closed to the *previous* series' top edge, not to the baseline.

**Workspace rail skeleton:**

```css
.app { display: grid; grid-template-columns: 260px 1fr; height: 100dvh; }
.rail { display: flex; flex-direction: column; border-right: 1px solid
        color-mix(in oklab, canvasText 12%, canvas); padding: 12px; gap: 2px; }
.rail nav, .rail .lists { overflow-y: auto; }        /* middle scrolls… */
.rail .me { position: sticky; bottom: 0; }           /* …footer stays pinned */
.rail .count { margin-left: auto; font-size: 11px;
               font-variant-numeric: tabular-nums; opacity: .6; }
```

Rail order (top→bottom): workspace switcher → Quick find (⌘K) → primary nav (badges right) → projects → teams → user + presence dot. `mini-rail`: same DOM, 56px column, labels → `title` tooltips.

## Data-realism conventions worth copying

The gallery's demo data follows rules that keep screens honest — apply them to any mock or prototype:

- Counts are small, specific, and uneven (Inbox 4, design 6, engineering 24) — never "99+" or round dozens everywhere.
- Money uses realistic magnitudes and delta formatting: "$100.4k", "+18.4% vs prev. 12mo" (sign explicit, comparison window named).
- Timestamps are precise, not rounded: "Nothing new since 8:42 this morning" — precision signals the system actually checked.
- Names skew workplace-real: workspaces "Acme inc.", projects "Q3 planning" / "Onboarding redesign", branches "feat/audit-log", channels "#design-crit".
- Shortcuts shown next to the actions they will replace: ⌘⇧W on "Switch workspace", "G P" for settings sequences — the palette teaches the faster path and then gets out of the way.

## When to use / When NOT to use

Use when:
- Starting any full app screen — check the inventory first; a structural sibling usually exists (auth flow, settings page, table with filters, empty state, pricing, command palette).
- Deciding whether a chart needs a library: if it is ≤3 series, no zoom/pan, no crosshair tooltips — hand-roll SVG per the pattern above.
- Replacing a confirm dialog with undo (any action reversible within ~8s: archive, move, label, mute).
- Writing empty-state copy — apply the inbox-zero formula (achievement → precise timestamp → FOMO removal → ≤2 secondary actions).
- Designing a gallery/docs index of your own: steal the keyboard model (`←→↑↓ r t c`, ⌘K) and wip badges.

Do NOT:
- Treat it as a dependency. Nothing installs from devl.dev itself; primitives come from coss-ui, full screens only via the in-site `c` copy key.
- Use for marketing/landing pages — it catalogs app interiors, not hero sections (pricing cards are the boundary).
- Use devl charts as a charting engine — no interactive axes, crosshairs, or data updates; that is a library's job.
- Copy `wip`-flagged entries as reference-grade.
- Rebuild what the platform gives you: native `<dialog>`, `<datalist>`, CSS `field-sizing: content` replace several modal/combo experiments — read a devl demo for its *layout*, not its plumbing.

## How to apply

1. Name the screen you are building; find its folder above and pick the closest 1–2 entries (e.g. settings → `permissions` or `webhooks`; list page → Tables + Filters/sidebar).
2. Open the entry; before styling anything, extract its information architecture: pane count and widths, what sits in the header vs body vs footer, where counts and shortcuts are displayed.
3. Rebuild the skeleton in your stack with your real domain objects — keep the structure, replace every label and datum with believable production-length data.
4. For reversible actions, replace confirm dialogs with the countdown undo toast (8s default; commit on timeout, exact-state revert on click).
5. For each chart, decide: ≤3 series and static → hand-rolled SVG + KPI + legend; otherwise use a chart library.
6. Write every empty state with the four-part formula; check the 404 gets the same treatment.
7. If you build a component gallery or docs index, adopt the keyboard model and file-tree framing wholesale.
8. Verify keyboard paths end-to-end: ⌘K opens, arrows move, ↵ selects, ESC always exits focus.

## AI-slop warning

This catalog documents the current default of AI-generated SaaS UIs: dark theme (#0a0a0a), muted grays, a 260px workspace rail, ⌘K palette, right-aligned badge counts, three-tier pricing. Reproduce that chrome wholesale and every product reads as a Linear/Slack clone with the user's logo swapped in. The transferable value is the *interaction* patterns (visible-countdown undo, achievement empty states, faceted filters, typed jump targets) and the *data realism* — not the gray-on-dark app shell. Never ship a devl screen verbatim: the demo data ("Acme inc.", "$100.4k") must become the user's domain, and at least one structural decision (rail vs top-nav, pane count) should diverge from the reference for a reason you can state.

## Relations

- `desengs-interfaces-dev` — same gallery genre (interactive reference sites); devl adds app-screen depth where interfaces.dev stays closer to component-level patterns.
- `desengs-component-gallery` — the generic gallery-building skill; devl's keyboard model and file-tree index are the concrete instance of it.
- `desengs-cmdk` — the command-palette skill; devl's palette demo contributes the three-group taxonomy (Suggestions / typed Jump-to / Settings) and per-item shortcut display.
- `desengs-sonner` — toast-library skill; pairs with devl's undo variant, which adds the visible countdown timer most toast libraries omit.
- `desengs-ui-playbook` — higher-level screen-recipe canon; consult it for which screen to build, devl for how a proven instance of that screen is structured.
