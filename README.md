# bankai

**The final form of UI/UX skills for AI agents — 107 skills that make coding agents design interfaces which don't look generated.**

One master skill (`bankai`) routes to 106 children distilled from the work of the best design engineers — Rauno Freiberg, Emil Kowalski, Jakub Krehel, Paco Coursey, Brad Frost, Butterick, and ~60 more — plus rules hardened over 40+ A/B evals where independent agents built the same brief with and without the canon. When your agent releases its final form, slop dies.

```
same brief, independent agents      plain    with bankai
─────────────────────────────────  ───────  ───────────
artisan landing (worst offender)      76          85
keyboard configurator                 77          86
cycling platform (new domain)         67          85
3-run variance test          12/12 identical builds → 0/12 shared axes
```

## Install

The skills are plain markdown your agent reads — no runtime, no dependencies. One skill, `bankai`, appears in your agent; its 106 sub-skills travel inside it and load on demand.

**npx (any Node ≥ 14 — no Node 22 needed, works with ZCode, Claude Code, Codex, Cursor, opencode…):**
```bash
npx github:Ahmed-OC/bankai
```

**macOS / Linux one-liner (needs only curl):**
```bash
curl -fsSL https://raw.githubusercontent.com/Ahmed-OC/bankai/main/install.sh | bash
```

**Windows PowerShell:**
```powershell
powershell -Command "irm https://raw.githubusercontent.com/Ahmed-OC/bankai/main/install.ps1 | iex"
```

The installer auto-detects your skills directory (`.agents/skills`, `.claude/skills`, `.codex/skills`, `.cursor/skills` — project-level first, then home). To choose a destination explicitly:

```bash
npx github:Ahmed-OC/bankai path/to/skills-dir
# or:  curl -fsSL …/install.sh | bash -s -- path/to/skills-dir
# Windows: set $env:BANKAI_TARGET = "path" first, then run the one-liner above
```

<details>
<summary>Other methods</summary>

```bash
# npx skills CLI (requires Node 22+) — the ecosystem-standard installer:
npx skills@latest add Ahmed-OC/bankai        # only "bankai" is listed; the children travel inside

# git clone + script
git clone https://github.com/Ahmed-OC/bankai.git
cd bankai && ./install.sh                    # macOS/Linux
# or:  powershell -File install.ps1           # Windows
# or:  node bin/install.js                    # any Node ≥ 14

# or manually: copy the bankai/ folder next to your other skills
```
</details>

## How it works

You don't read 107 files. **Open `bankai` at the start of any UI work** — it carries the shared doctrine and routes you to the 3-5 children your brief actually needs:

- **The Differentiation Engine** — pick a product mode, then a THEME from the curated library (33 directions backed by 256 world-class references; the canon proposes, you choose), (Operate / Create / Consume / Entice / Play), set five dials explicitly (VARIANCE, MOTION, DENSITY, ORNAMENT, WARMTH), write a one-line design intent. Ban your first *two* concepts — the domain's obvious metaphor is the slop.
- **Exact numbers, not vibes** — motion bands in ms, state-layer lightness deltas, contrast ratios to annotate, touch targets, stagger caps, easing families.
- **Rulings for conflicts** — R1 "should this animate?" (default: no), R8 "briefs are floors" (unrequested depth is mandatory), R9 "interaction floor" (undo, keyboard, honest states everywhere).
- **The anti-slop ban list + mechanical pass** — 15 generated-work tells, closed by literal grep commands you run on your own output before shipping. A box checked without a command output is `UNVERIFIED`, never `PASS`.

Flagship children: `spectacle` (signature law, arrival choreography), `domain-fit` (14-domain matrix), `mobile` (the native bridge: Expo/RN/iOS/Android — HIG + Material 3 exact numbers, translated mechanisms), `micro-craft` (exact finishing formulas), `dynamism` (L0-L6 ladder, at-rest life that is TRUE or LABELED), `3d-craft` (3D interaction contract), `oklch`, `practical-typography`, `cmdk`, `sonner`, `rauno`… Full routing table lives in the master.

## What's inside

```
bankai/                    THE SKILL — the entry point (this is what gets installed)
  SKILL.md                the canon: modes, dials, theme selection, rulings, routing, delivery gate
  skills/<name>/          the 106 sub-skills (one per curated source) + the `mobile` native bridge
  skills/_CONVENTIONS.md  binding format for every sub-skill
  library/THEMES.md       33 curated directions — the theme picker (propose 3-5, caller chooses)
  library/parts/*.md      256 world-class references, mechanism-level, 7 zones (mobile-first)
```

Your agent sees ONE skill: `bankai`. It routes to the sub-skill it needs, when it needs it.

Every child carries a `source:` link in its frontmatter — this is a research distillation of publicly published material, crediting the original authors. All credit for the underlying ideas belongs to them; the canon's contribution is the routing, the rulings, and the eval-hardened rules. If you're an author and want something corrected or removed, please open an issue.

## License

[MIT](LICENSE)
