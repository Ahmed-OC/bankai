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

Works with any agent that supports the Agent Skills convention (ZCode, Claude Code, Codex, Cursor, opencode, Amp…):

```bash
npx skills@latest add Ahmed-OC/bankai
```

Pick **`bankai`** (the entry point — it discovers and routes to the children), or take everything.

<details>
<summary>Other methods</summary>

```bash
# git clone + script (copies skills/ into your agent's skills directory)
git clone https://github.com/Ahmed-OC/bankai.git
cd bankai && ./install.sh            # macOS/Linux
# or:  powershell -File install.ps1   # Windows
# or manually: copy skills/* next to your other skills
```

The script auto-detects `.agents/skills`, `.claude/skills`, `.codex/skills`, `.cursor/skills` (project-level first, then home) or takes a target directory as an argument.
</details>

## How it works

You don't read 107 files. **Open `bankai` at the start of any UI work** — it carries the shared doctrine and routes you to the 3-5 children your brief actually needs:

- **The Differentiation Engine** — pick a product mode (Operate / Create / Consume / Entice / Play), set five dials explicitly (VARIANCE, MOTION, DENSITY, ORNAMENT, WARMTH), write a one-line design intent. Ban your first *two* concepts — the domain's obvious metaphor is the slop.
- **Exact numbers, not vibes** — motion bands in ms, state-layer lightness deltas, contrast ratios to annotate, touch targets, stagger caps, easing families.
- **Rulings for conflicts** — R1 "should this animate?" (default: no), R8 "briefs are floors" (unrequested depth is mandatory), R9 "interaction floor" (undo, keyboard, honest states everywhere).
- **The anti-slop ban list + mechanical pass** — 15 generated-work tells, closed by literal grep commands you run on your own output before shipping. A box checked without a command output is `UNVERIFIED`, never `PASS`.

Flagship children: `spectacle` (signature law, arrival choreography), `domain-fit` (14-domain matrix), `micro-craft` (exact finishing formulas), `dynamism` (L0-L6 ladder, at-rest life that is TRUE or LABELED), `3d-craft` (3D interaction contract), `oklch`, `practical-typography`, `cmdk`, `sonner`, `rauno`… Full routing table lives in the master.

## What's inside

```
skills/
  bankai/                the canon — start here
  <name>/                106 children (one per curated source)
  _CONVENTIONS.md        binding format for every skill
```

Every child carries a `source:` link in its frontmatter — this is a research distillation of publicly published material, crediting the original authors. All credit for the underlying ideas belongs to them; the canon's contribution is the routing, the rulings, and the eval-hardened rules. If you're an author and want something corrected or removed, please open an issue.

## License

[MIT](LICENSE)
