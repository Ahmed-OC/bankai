---
name: shoogle
description: Use when a React UI build needs an existing shadcn-registry component, block, or hook instead of hand-rolling one. Covers Shoogle's web search, 434-registry directory, MCP tools, and CLI.
source: https://shoogle.dev
category: tool
---

# Shoogle — one search box over the entire shadcn/ui registry ecosystem

Source: https://shoogle.dev — maintained by @alibey_10 (X). A search engine + directory for shadcn-registry items (components, blocks, templates, hooks) aggregated from 434 community registries, with a hosted MCP server (`https://mcp.shoogle.dev/mcp`) and CLI route. No license stated for the index; every indexed item belongs to its own registry's license — check before vendoring.

## What it is / Why it exists

The shadcn/ui distribution model is deliberately decentralized: components are not npm packages but registry items you add via `npx shadcn@latest add <item>`, which copies source files into your project. The ecosystem grew to hundreds of independent registries (cult-ui, magicui, shadcncraft, agent-ui-kit, …), each on its own site with its own discovery. The gap: no item-level search across all of them, and no way for an AI coding agent to find them without web browsing.

Shoogle fills both:

1. **Index**: crawls the community registries listed in the shadcn/ui directory, flattens every item into `{name, type, description, registry, homepage, addCommandArgument}`, and full-text-indexes item **names** (backend: Convex search).
2. **Surfaces**: web UI (`/search`, `/directory`, `/shadcn-components`), a stateless streamable-HTTP MCP server for agents, and the standard shadcn CLI (`search @shoogle`).

Stated purpose of the MCP: stop agents "burning tokens on sloppy user interfaces" — search a vetted index instead of inventing components from scratch.

## The core ideas

### 1. The item, not the registry, is the search unit
You never search "which registry is good"; you search `"carousel"` and get back items from every registry that has one. A result row (verified live, 2026-10):

```json
{
  "name": "feature-carousel",
  "registry": "@cult-ui",
  "type": "registry:ui",
  "description": "Feature carousel component with smooth transitions and customizable layouts",
  "homepage": "https://www.cult-ui.com/?utm_source=shoogle.dev&utm_medium=mcp&utm_campaign=registry_search",
  "addCommandArgument": "@cult-ui/feature-carousel"
}
```

Every field exists to end in one terminal action: `npx shadcn@latest add @cult-ui/feature-carousel`.

### 2. Names are the only full-text surface
The index is built on item names, not descriptions. `"carousel"` returns ~100 items; a concept query like `"ecommerce product grid"` matches nothing unless a name literally contains those words. For concept-level browsing use the taxonomy instead of the search box (see idea 5).

Consequence for queries: use the generic widget noun (`carousel`, `datatable`, `calendar`, `hero`, `otp`), not the use case. `"date picker"` matches; `"booking form"` does not.

### 3. Two search tools, scoped and unscoped
The MCP server (`shoogle-mcp-server` v1.0.0, protocol 2024-11-05, no auth, stateless — each POST is standalone) exposes exactly two tools:

- `search_registry_items` — `query` (required), `offset` (default 0), `limit` (default 100, **max 100**).
- `search_registry_items_scoped` — adds `registries: string[]` (min 1, e.g. `["shadcn","magicui"]`); the response includes `unknownRegistries` so you learn which namespaces failed to resolve.

Responses: `{query, pagination:{total, offset, limit, hasMore}, items[], timestamp}`. Paginate with `offset` when `hasMore` is true; you cannot raise the ceiling above 100.

The server also prescribes how to present results: a markdown table with columns **name, registry, homepage, add command, type, description** — and, for scoped search, mention any `unknownRegistries` so the caller knows which namespaces failed. Follow that contract; it is what consuming agents expect.

Because the server is stateless streamable HTTP with no auth, any client can call it raw (verified working):

```bash
curl -s -X POST https://mcp.shoogle.dev/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call",
       "params":{"name":"search_registry_items",
                 "arguments":{"query":"carousel","limit":5}}}'
```

No `initialize` handshake or session header required — usable from scripts and CI the same way as the CLI.

### 4. The type vocabulary is the shadcn registry schema
Filter and reason with these types: `registry:ui`, `registry:block`, `registry:hook`, `registry:lib`, `registry:page`, `registry:file`, `registry:template`. When you need a composed section (hero, pricing, dashboard shell) filter `registry:block`; for behavior alone (`use-carousel`) take `registry:hook` — it vendors less code than a wrapped component.

### 5. A two-level taxonomy for concept browsing
- `/directory` — all 434 registries, sortable Latest/Oldest, 10 per page, 24 category chips: Design System, General, Marketing UI, Dashboard UI, AI Blocks, Ecommerce UI, Icons, Loaders, Charts, Maps, Forms, Text Editor, Video, Audio, Auth, Payments, Gamification, Web3, Utilities, Docs UI, Terminal UI, React Native, Other, WIP.
- `/shadcn-components` (Explore tab) — item-level groupings with counts: Application UI (38), AI Agents (16), Marketing Blocks (15), Ecommerce Blocks (10), Scroll UI (8), plus Charts, Templates, AI elements, Commerce.

Rule of thumb: known noun → search; fuzzy concept → taxonomy chip.

Read the directory as a freshness feed, not a ranking: sorted Latest/Oldest, the front page is the ecosystem's leading edge (Oct 2026 entries: `@agent-ui-kit` — agent-run tool-call timelines and human-in-the-loop approvals; `@keyframery` — a `<Cuts />` motion layer for dialogs/sheets/tabs/toasts; `@shaderscn` — copy-paste WebGL shader sections; `@agentfaces` — animated agent faces with lip sync). When a task needs something the base shadcn registry lacks (agent UI, shaders, 3D viewer), the directory's newest page is where that capability first appears — search names will lag it.

### 6. Install = vendoring, not dependency
`add` copies the item's files and its `dependencies` (Radix/Base UI/Aria primitives, utils) into your repo. After install you own the code: no upstream updates, no security patches unless you re-run add. This ownership is the whole shadcn bargain — Shoogle only changes how you *find* the code, not what happens after.

The web UI supports the decision before the install: results render in a master-detail layout where selecting an item loads a **live iframe preview** of its demo page (with a fullscreen toggle) — you judge motion and density in-browser, not from a thumbnail. Sorts are "Featured" (sponsored/curation mix) vs "Recently added" (pure recency); "Bookmarks" is a third tab stored locally per browser.

### 7. Replicating the tool by hand (no Shoogle, no MCP)
The mechanism is fully open — every registry serves a JSON manifest per the shadcn registry-item schema:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry-item.json",
  "name": "feature-carousel",
  "type": "registry:ui",
  "description": "Feature carousel component",
  "files": [{ "path": "registry/ui/feature-carousel.tsx", "type": "registry:ui" }],
  "dependencies": ["embla-carousel-react"],
  "registryDependencies": ["button", "card"]
}
```

1. Collect registry URLs (shadcn's public directory lists community registries).
2. Fetch each registry's manifest (convention: `/api/registry` or a `registry.json`).
3. Flatten to rows `{name, type, description, registry, addCommandArgument: "@" + registry + "/" + name}` and build a name-level full-text index over them (a SQL FTS5 table or Convex search is enough at 434-registry scale).
4. Install remains the standard CLI: `npx shadcn@latest add @namespace/item` — it resolves the namespace, fetches the manifest, and copies `files` into your project.

That is the entire methodology Shoogle encodes: **centralize manifests, index names, return the add-command argument.** Nothing in it is proprietary; the value is the operational cost someone else pays (crawling, deduping, hosting) plus the two clean agent interfaces on top.

## When to use / When NOT to use

Use when:
- React + Tailwind project, need a non-trivial component (carousel, datatable, chart, command palette, agent chat UI) — search before writing.
- You want to compare 3–5 implementations of the same widget before committing (scoped search makes A/B cheap).
- An AI agent is building UI: register the MCP once, search per task, install via `add` — cheaper and more consistent than generating bespoke component code.
- Discovering what exists in a domain you don't know (e.g. "scroll-driven UI" → Scroll UI category lists 8 named patterns: Scroll Fade, Scroll Velocity, Scroll Animation, Scroll Area, Scroll Button, Scroll Progress, Scroll Reveal, Scroll Spy — a free pattern vocabulary even if you hand-roll).
- Scoping a known-good registry across a whole feature: `search_registry_items_scoped(query="dialog", registries=["magicui","cult-ui"])` keeps one visual language per feature instead of one per component.

Do NOT use when:
- The stack is not React + Tailwind. Registries are overwhelmingly React/TS + Tailwind + Radix/Base UI/Aria (one SwiftUI registry exists — `@swiftui-flx` — treat as a curiosity). For plain HTML/CSS, port the *pattern*, not the code.
- The platform already does it: native `<dialog>`, `details/summary`, scroll-driven CSS animations, popover API — a registry item for these is net-negative weight.
- You already have a design system with fixed tokens: mixing items from 3+ registries imports 3+ sets of radius/motion/spacing assumptions and visible drift.
- The component is security- or money-critical (Auth, Payments registries exist): vendored code = your audit surface.
- You need semantic quality ranking: Shoogle sorts by name relevance, "Featured" (sponsor-influenced) or "Recently added". It has no quality score — curation is your job.
- The item is smaller than its dependency: many `registry:ui` results pull runtime deps (embla, framer-motion) plus 2–3 `registryDependencies`. If your need is one visual trick, porting 30 lines of CSS from the live preview beats vendoring 300 lines of React.

## How to apply (numbered checklist)

1. Register once (agents): `claude mcp add shoogle --transport http --scope user https://mcp.shoogle.dev/mcp`, verify with `claude mcp list`. Cursor: `{"mcpServers":{"shoogle":{"url":"https://mcp.shoogle.dev/mcp"}}}` in `.cursor/mcp.json`. No auth, no session state.
2. Before writing any component >50 lines, search its noun: `search_registry_items(query="carousel", limit=5)`.
3. Read `pagination.total`; if >100, tighten the query or page with `offset` — do not loop blindly.
4. Shortlist 2–3 items across different `registry` values; compare `type`, `description`, and the registry's homepage.
5. Prefer the smallest type that solves it: `registry:hook` < `registry:ui` < `registry:block` (less vendored code).
6. Check the source registry's freshness on its homepage/GitHub before adding (a WIP/abandoned registry stays indexed forever).
7. Install: `npx shadcn@latest add @namespace/item`. Immediately re-read the vendored files: rename tokens, align radius/motion with your system, strip demo copy.
8. Prefer one registry namespace per feature area (dashboard from registry A, marketing from registry B) — never per component. This is the single strongest defense against style drift.
9. CLI-only alternative (no MCP): `pnpm dlx shadcn@latest search @shoogle -q carousel` — flags `-q` (required), `--limit` (default 100), `--offset` (default 0); multiple registries can be searched at once (`search @shoogle @magicui`).
10. Strip UTM parameters (`utm_source=shoogle.dev...`) from any homepage link you persist — they exist for Shoogle's attribution, not yours.

## AI-slop warning

- **Slop-by-catalog**: an agent that grabs the first carousel result ships `@cult-ui/feature-carousel`, then `@shadcncraft/use-carousel`, then `@000h-cojeev/carousel` — three motion languages in one app. One component per concept per app; enforce it in review.
- **The default look is the cliché**: the indexed ecosystem converges on neutral palette + `rounded-md` + `shadow-sm` + soft springs. Searching 434 registries for "beautiful" returns 434 shades of the same thing. Use Shoogle for *mechanism* (working carousel logic, datatable state), then re-skin deliberately.
- **Ranking is not merit**: "Featured" ordering and the Enterprise Partners strip (ReUI, Arc, hosting affiliates) are paid placements; homepage links are UTM-tagged. Never cite result position as a quality argument.
- **Vendored ≠ maintained**: after `add`, upstream fixes do not reach you. Registries vary in a11y rigor (Radix-based ones inherit Radix quality; one-off ones may lack focus management entirely). Agent must audit keyboard/focus/ARIA in every vendored file, not assume the index filtered for it.
- **Index is name-literal**: searching descriptions or vibes silently returns zero and the agent concludes "nothing exists" and hand-rolls slop. If a search misses, switch to the taxonomy chips before writing code from scratch.

## Relations

- **magic-ui** — a specific high-craft registry that Shoogle indexes; the quality bar to hold any search result against before installing.
- **component-gallery** — curated human galleries vs Shoogle's exhaustive machine index: use galleries for taste, Shoogle for coverage; they contradict on ranking philosophy (curation vs sponsor-influenced relevance).
- **loading-dev** — the niche single-concept registry pattern; exactly when `search_registry_items_scoped(query=..., registries=["loading-dev"])` beats open search.
- **cmdk** — a single-component registry item (command palette); illustrates that one result row is worth a whole skill — depth after discovery.
- **ui-ux-canon** — the canon that decides whether to search-and-vendor at all or hand-craft per its principles; consult it before any `add`.
