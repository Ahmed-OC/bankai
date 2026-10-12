---
name: limit-details
description: Use when a screen, component, or style sheet is accumulating controls, styles, or states and something must be cut. Turns "limit the number of details" into countable budgets and a repeatable detail audit.
source: https://design.lightspark.com/limit-the-number-of-details
category: essay
---

# Limit the Number of Details — the restraint budget

Source: https://design.lightspark.com/limit-the-number-of-details — Geoff Teehan, essay on Lightspark's "Design Field Notes" blog (free to read, no explicit license). A ~2,500-word argument for capping how many details a product carries, built on the Dorsey maxim "Make every single detail perfect, and limit the number of details."

## What it is / Why it exists

- Thesis, quoted from Jack Dorsey: "Make every single detail perfect, and limit the number of details." Teehan's gloss: "When you strip away what doesn't matter, the things that do matter get the attention they deserve." Perfection and restraint are one rule, not two — you cannot have the first without the second.
- "Details" is defined broadly: "every feature, setting, pixel, interaction, and state." Not just visual polish — every control, mode, preference, and behavior is a detail someone must design, build, and maintain.
- Why the essay exists: software has no natural brake. "Hardware has physics. Hardware has supply chains. Software has none of that. Adding another button is basically free." Free to add, expensive to live with. This skill converts that warning into budgets an AI can count and enforce before shipping.

## The core ideas

### 1. Details compete for a finite perceptual budget
- "Attention is the scarcest resource in design." Every element on screen bids for it; every element you add lowers the attention the remaining ones can receive.
- The cost formula, quoted: "Complexity is a tax on craft." and "Every detail you add makes it harder to perfect the details that remain."
- Consequence for UI building: detail is a budget to spend, not a quality to add. Spend it only where it earns meaning — the primary action, the number being watched, the state that prevents an error. Everything else stays plain so the spent detail reads.

### 2. Details multiply through relationships
- A single control needs placement, label, states. Add a second and you now also own the *relationship*: alignment, ordering, relative weight, which one is primary. n elements generate roughly n(n−1)/2 pairwise relationships — visual, spatial, hierarchical. Cost grows faster than count.
- This is why screens decay gradually: "Nothing about one button feels crowded. Ten might." No single addition trips the wire; the aggregate does.
- Focal hierarchy is the escape: one primary element per view, a clear second tier, and a quiet rest. If two elements tie for first, the user must resolve the tie on every visit — that resolution is the tax being paid.

### 3. Case studies: concentration beats elimination
- iPod: a thousand songs routed through one mechanical scroll wheel, obsessively refined. Teehan: "The click wheel wasn't simple. It was concentrated." Complexity wasn't removed; it was funneled into one detail worth perfecting.
- Braun RT 20 (Dieter Rams): three knobs — volume, tuning, tone — each inevitable. "It's hard to make thirty knobs feel considered. It's very possible to make three feel inevitable." Thirty knobs is enterprise software.
- Teenage Engineering OP-1: genuinely complex product, but four color-coded encoders whose color maps knob to screen element. Four knobs become a language; complexity feels contained rather than leaked.
- MUJI CD player: pull-cord interaction borrowed from ceiling fans — "almost nothing to explain because there's almost nothing to misunderstand." Familiarity is a detail you get for free; spend budget elsewhere.

### 4. The trap: reasonable decisions, aggregate disaster
- Porsche 918 Spyder center console: reportedly "over 800 individual controls and functions." The mechanism of failure, quoted: "Complexity didn't arrive all at once. It arrived one reasonable decision at a time. No single decision felt wrong." Reviewing individual changes cannot catch this; only counting the total can.
- Volkswagen walked back all-touchscreen interiors; design chief Andreas Mindt: "We have no more touch-only. Never." The applied lesson: the five most-used functions deserve the richest, most immediate controls — and the discipline is choosing the five.
- Software equivalent: "iTunes 1.0 was a music player. iTunes 12.8 is a mall." Feature accretion without a detail cap turns a tool into a building you get lost in.

### 5. Why complexity grows anyway (the org asymmetry)
- "Adding something usually has an advocate. Removing something has an enemy." Requests arrive individually sensible; nobody owns the total count. Therefore the count must be owned explicitly — by a budget, not by vigilance.
- "Just because you can add something doesn't mean you should." Every feature "adds weight" — "A feature isn't free."
- What removal returns: time to perfect what stays. "Being able to obsess over the click wheel came directly from not having to design fifty other controls." What that looks like in practice: reconsidering a type size, rewriting three words, moving something two pixels, fixing what annoys on the twentieth use. "Boring, meticulous work" — the value of craft is that "it doesn't have to shout."
- Users may never notice the restraint; they shouldn't have to. The essay's test of success is not admiration of the surface but absence of friction: at 70 mph, finding the fan control matters more than a console that photographs well.

### 6. The goal is not minimalism
- Quoted: "Minimalism is not the absence of detail. It's the presence of the right details." Sparse can still be bad. Earned complexity is fine — pro tools and cockpits get theirs by making every control earn its way in.
- Closing rule, quoted: "So make every detail you keep as considered as possible, and keep the number of details as low as you can get away with."

## The restraint budget (derived numbers)

The essay argues the principle; the counts below are this skill's operationalization of it. Tune per project, but write the numbers down — an uncapped budget is no budget.

Per view (what the eye can parse at a glance):
- Exactly 1 primary focal element (the hero action, the key number, the playing track). Everything else is subordinate.
- Max 3 simultaneous calls to action; exactly 1 styled as primary.
- Max 3 font sizes, 2 font weights (plus 1 accent weight used once), 3 text colors per theme (primary, secondary, disabled), 2 border styles, 2 shadow levels, 3 corner-radii steps.

Per surface (card, toolbar, list row, modal):
- Max 3 distinct interactive controls before the row needs hierarchy redesign, not another button.
- Max 1 accent color per surface; accents used on ≤ 10% of pixels.
- Max 1 motion signature per surface; enter effects stagger ≤ 5 items.
- Remember what a control really costs: the essay counts states as details too — every button carries hover, focus, active, disabled, and loading. Five controls ≈ twenty-five states to design, build, and keep consistent. This is the arithmetic behind "A feature isn't free."

Per product:
- Max 5 top-level destinations. The VW lesson generalized: pick the five most-used functions and give them the best real estate; everything else is a second click away.

```css
/* The budget as tokens — additions require editing this block, which is the point. */
:root {
  /* type: 3 sizes, 2 weights + 1 accent */
  --text-sm: 0.8125rem; --text-md: 0.9375rem; --text-lg: 1.25rem;
  --weight-regular: 400; --weight-medium: 500;
  --weight-accent: 650; /* used at most once per view */
  /* color: 3 text colors, 1 accent */
  --text-1: oklch(0.28 0.01 260); --text-2: oklch(0.50 0.01 260); --text-3: oklch(0.71 0.01 260);
  --accent: oklch(0.62 0.19 35);
  /* depth: 2 shadows, 2 borders, 3 radii */
  --shadow-1: 0 1px 2px oklch(0 0 0 / 0.06);
  --shadow-2: 0 8px 24px oklch(0 0 0 / 0.12);
  --border-1: 1px solid oklch(0 0 0 / 0.08);
  --border-2: 1px solid oklch(0 0 0 / 0.16);
  --radius-sm: 6px; --radius-md: 10px; --radius-lg: 16px;
}
```

Enforce mechanically — a budget nobody counts is decoration:

```bash
# Distinct font sizes actually used (should be ≤ 3–4):
grep -rhoE "font-size:\s*[^;]+" src/ | sort -u | wc -l
# Distinct text colors (should be ≤ 3–4 per theme):
grep -rhoE "color:\s*[^;]+" src/ | sort -u | wc -l
# Distinct box-shadows (should be ≤ 2–3):
grep -rhoE "box-shadow:\s*[^;]+" src/ | sort -u | wc -l
```

## When to use / When NOT to use

Use when:
- Building any new screen, modal, card, or settings page — set the budgets before writing markup.
- A screen "feels off" but nothing is individually wrong — that is the 800-controls condition; run the audit below.
- Reviewing a diff that adds a control, badge, toggle, mode, or preference.
- A product is mid-lifecycle and requests are piling on — count total controls, not request merit.

Do NOT use when:
- The complexity is content, not chrome: dense data tables, code editors, trading terminals. Rows and columns are data; cap the *surrounding* details, not the data.
- The tool is a pro tool that has earned it (the essay's own carve-out). Photoshop's density is a decision; your settings page's density is an accident. Audit accidental complexity first.
- Accessibility requires redundancy: visible label + icon + text is not "extra detail" to strip — removing affordances in minimalism's name fails the "right details" test.
- Early exploration, before it's known which details matter. Cut once the shape is stable.

## How to apply — the detail audit (numbered)

Run on any view that feels crowded, ships soon, or just grew:

1. **Blur test.** Screenshot the view and apply ~5px blur (or squint). If multiple elements still fight for the eye, there is no focal point — demote all but one. The survivor set is your real hierarchy; make it the intended one.
2. **Count the inventory.** List every control, font size, weight, text color, border style, shadow, radius, icon, and accent usage. Compare against the budgets above. Any over-budget axis is a finding.
3. **Removal test, per detail.** Ask: what concretely breaks if this is deleted? If nothing names a breakage — only "it's nice" or "we built it" — remove it. "Every feature adds weight"; the burden of proof sits on the detail.
4. **Relationship check.** For surviving controls, verify each pair reads as one system: consistent alignment, one primary per group, ordering that matches frequency of use. Pairs that need explanation are pairs that need merging or removal.
5. **Concentrate.** Route the just-reclaimed budget into the survivors: spacing, hover/focus/disabled/loading states, exact copy, focus ring contrast ≥ 3:1, keyboard order. This is the "make every detail perfect" half of the maxim.
6. **Cap the totals and write them down.** Update the token block and record control counts (e.g., "toolbar: 4 controls, modal: 2 CTAs") in the PR. The next addition must visibly break a stated number, not a vibe.
7. **Re-run on growth.** Every quarter or release, recount. Remember the mechanism: "one reasonable decision at a time" is exactly how 800 controls happen — only the running total catches it.

### Worked example

A "share" modal arrives with: title, subtitle, URL field, copy button, QR code, 6 platform icons, permission dropdown, expiry dropdown, password toggle, preview thumbnail, "learn more" link, cancel, share = 14 visible details.

- Blur test: URL field, icon row, and Share button all survive — three focal points. One must win: the Share button; the icon row loses.
- Counts: 4 font sizes (over 3), 4 text colors (over 3), 2 competing primary buttons.
- Removal test: subtitle rewrites the title — delete; "learn more" breaks nothing in-modal — moves to docs; QR code serves a minority path — moves behind an overflow icon (still reachable, no longer bidding for attention); password + expiry are advanced — collapse into one "options" disclosure, closed by default.
- Survivors: title, URL + copy, one "options" disclosure, cancel, share = 7 details, one focal point.
- Reinvest: copy button gets confirmed state + keyboard shortcut hint; URL field gets full-width auto-select on focus; focus ring contrast fixed to 3:1; esc closes the modal; enter shares. None of this was affordable at 14 details.

## AI-slop warning

How AI typically misapplies this principle:

- **Adding detail as effort.** Asked to "polish" a screen, AI adds — gradients, glow, noise textures, a sixth gray, badges, icons on every label — because additions read as work. Correct polish here is subtraction plus deeper states on what remains. If a polish pass increases the count of any budget axis, it failed.
- **Simultaneous techniques.** AI stacks shadow + gradient border + noise + glow + micro-animation on one component. Each is "a detail"; together they are noise. One signature technique per surface, budgeted.
- **Mistaking the goal for minimalism.** AI reads "limit details" as "make it empty" — stripping labels, affordances, and feedback until the UI is vague. The essay's own correction: "Minimalism is not the absence of detail. It's the presence of the right details." Never delete the label, the focus state, or the error message to hit a count.
- **Feature-slop in conversation.** When asked to improve a product, AI proposes new modes and settings rather than merging existing ones. Default move: consolidate before adding; make the addition justify itself against the written budget.
- **No fatigue sensor.** AI never gets tired looking at a crowded screen; users do. That is precisely why the counts must be mechanical (blur test, grep, written budgets) rather than felt.

## Relations

- **rams** — supplies the ten-principle frame this essay quotes ("thorough down to the last detail" + "as little design as possible") and a scored audit; use it for the full review, this skill for the counting discipline.
- **taste** — its ban list enforces the low end of these budgets (capped grays, weights, shadows); load it when writing the actual CSS so the token block stays honest.
- **lessons-design** — the taste-over-rules counterpart: what to cut and how to frame removal for stakeholders (the "removing has an enemy" problem).
- **devouring-details** — the opposite direction of the same coin: where to reinvest the reclaimed budget when detailing the survivors.
- **details-feel-better** — a concrete reinvestment menu (text-wrap, concentric radii, interruptible motion) for step 5 of the audit.
