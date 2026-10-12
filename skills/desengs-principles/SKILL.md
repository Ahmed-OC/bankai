---
name: desengs-principles
description: Use when writing, auditing, or citing a project's design principles to break design ties. Encodes principles.design's framework: decisive beats slogan, 3-5 per set, values/rules/principles split, vetted real-world sets.
source: https://principles.design/; https://principles.design/audit/
category: principle
---

# Design Principles (desengs) — writing and applying principles that actually decide

Source: https://principles.design/ — Ben Brignell (Brignell Ltd, UK), curator. A free, editorially curated library running since 2017: 236 example sets, 1,661 principles, 200 creators, tagged Universal/Specific, People/Organisations, and by domain (Software, Hardware, Infrastructure, Language, Design System). Framework from Brignell's 2026 article series and free audit tool; quoted principle sets remain the property of their authors (Rams/vitsoe, Government Digital Service, NHS, Ant Design, Microsoft, Amber Case, Clearleft, Fisher-Price founders).

## What it is / Why it exists

The site's definition, verbatim: design principles are "clear statements that help teams make consistent decisions and trade-offs when designing products, services, or systems." They are "not rules or slogans" — "at their best, they act as decision-making tools, helping people choose what to do when the right answer isn't obvious."

Why it exists: most published principle sets are never used. Meetings re-litigate the same debates and "outcomes often hinge on opinion or whoever speaks the loudest." The cure is not more principles — it is principles that pick a side.

The operating vocabulary is a four-way split you must be able to apply on sight:

| Kind | Does what | Example | Test |
|---|---|---|---|
| Slogan | Describes intent | "Be user-centric" | Two good options on the table — it resolves nothing |
| Value | States a belief | "We value transparency" | Shapes culture, not a specific choice |
| Rule | Prescribes one outcome | "Logo must always sit on white" | Breakable only at a cost; bends never |
| Principle | Creates a bias between options | "The logo should be clearly legible" | Guides judgement, allows exploration |

Two adjacent distinctions from the site:
- "Values shape culture. Principles shape decisions." Repair move: "We value transparency" → "Help the user understand what is happening and why."
- "Rules remove choice. Principles guide choice." Repair move: "logo on white only" → "logo clearly legible" (any background works if legibility holds).

Separately, "principles of design" (contrast, balance, hierarchy, alignment, proportion, repetition, unity, rhythm, white space) are craft-level, universal, and stable. "Design principles" are strategic and unique to an organisation. "The overlap happens in application. The distinction exists in intent." A team principle like "Prioritise clarity" gets *executed* through hierarchy, contrast, spacing — craft principles in service of authored ones. Never present the craft list as your project's principles.

## The core ideas

### 1. The site's own three writing criteria (Ben Brignell, "Writing Design Principles")

- **Concise** — readable at a glance, cut to a single line. Removing explanations and caveats "exposes whether the idea actually holds."
- **Memorable** — easy to repeat, a natural shape that sticks in conversation. If it needs lookup to influence a decision, it won't.
- **Decisive** — must "help you choose between options by creating a bias," guiding judgement rather than replacing it with rules. (Renamed from "Definitive" deliberately: guidance, not inflexibility.)

### 2. The five audit checks (the free audit tool's rubric)

Run every candidate principle through these:

1. **Decision vs intent** — "Does it guide a decision, or just describe an intent?"
2. **Trade-off** — "Does it reveal a trade-off? A principle that nobody would ever argue against isn't doing any work."
3. **Rule in disguise** — "Principles should bend to context." If it reads like a policy that must never be broken, it has drifted into a rule.
4. **Value in disguise** — beliefs don't guide a specific choice.
5. **Set size** — "Long lists are hard to recall and tend to become documentation instead of tools."

### 3. Failure modes and their fixes ("Why Most Design Principles Fail")

- **Slogans.** "Keep things simple" fails three ways: "simple" is subjective (remove options? reduce visual clutter? hide features behind a menu? — all defensible); simplicity isn't always right (the aircraft cockpit: a wheel and a start button would be simpler and lethal — the instruments exist because the pilot needs them); and it never says "what should happen when things become complicated." Fix: name the sacrifice — "Prefer what matters" turns the debate into prioritisation.
- **No trade-offs exposed.** The set "Be consistent / Be flexible / Be simple / Be powerful" never conflicts, so it never decides. "If everything is equally important, nothing actually guides the decision." Name the live tensions: clarity vs completeness, consistency vs flexibility, simplicity vs capability.
- **Too many.** "The most effective examples use 3-5 principles." GOV.UK's Digital Service Standard ran 18 and only survived because it was embedded, communicated, and publicly visible across all of government — an outlier, not a template.
- **Never used.** Test: "Does anyone actually refer to it?" Working principles become "part of everyday language" ("does this follow our clarity principle?"); unused ones "remain decorative."
- **Confused with values.** See the table above.

Worked repairs, straight from the site's own examples — apply this exact transform:

| Fails as | Rewrite | Why it now decides |
|---|---|---|
| "Be user-centric" (slogan) | "Help the user understand what is happening and why" | Names what the UI must contain (status, cause) when options compete |
| "Keep things simple" (slogan) | "Prefer what matters" | Turns the debate into prioritisation, not taste |
| "We value transparency" (value) | "Help the user understand what is happening and why" | Same belief, now checks a specific choice |
| "Our logo must always appear on a white background" (rule) | "The logo should be clearly legible" | Same goal (protect the mark), backgrounds/color/imagery freed |

Note the pattern: every successful rewrite names the *sacrifice* or the *test*. A line with neither is still a slogan.

### 4. Set size and gaps

3–5 principles. "Three, four or five principles are much easier to remember and use than eight, nine or ten." As lists grow they "drift closer towards being rules" and become "documentation rather than tools." Gaps are fine: "Design principles are not intended to describe everything a team values... The goal is not completeness. The goal is clarity." A small set forces priority — "when too many principles exist, it becomes unclear which ones should take priority."

### 5. Curated reference sets (strongest in the library, with attribution)

- **Dieter Rams, Ten Principles for Good Design** (source vitsoe.com): innovative / makes a product useful / aesthetic / makes a product understandable / unobtrusive / honest / long-lasting / thorough down to the last detail / environmentally friendly / **"Good design is as little design as possible — less, but better."** The canonical Universal set: each line disqualifies real work (fashionable → violates long-lasting; ornament → violates unobtrusive).
- **GOV.UK / Government Digital Service, 10 principles**: Start with user needs / Do less / Design with data / **Do the hard work to make it simple** / Iterate. Then iterate again / This is for everyone / Understand context / Build digital services, not websites / **Be consistent, not uniform** / Make things open: it makes things better. The gold standard for Specific sets: "This is for everyone" spends elegance to buy inclusion — a real, arguable trade-off.
- **NHS, 9 principles** (service-manual.nhs.uk): put people at the heart / design for the outcome / be inclusive / design for context / design for trust / test your assumptions / make, learn, iterate / do the hard work to make it simple / make things open. Domain-specific trade-offs (trust, clinical context) — proof of "Be yourself."
- **Microsoft, 5** (Metro era): Pride in craftsmanship / Do more with less / Fast and fluid / Authentically digital / Win as one. Five words-sets, memorable enough to survive recitation; "Authentically digital" is a decision (no skeuomorphic leather) disguised as two words.
- **Ant Design** (ant.design), a deliberate two-tier system: foundational craft — Proximity, Alignment, Contrast, Repetition; then actionable interaction — **Make it Direct** (edit in place, not on a separate page) / **Stay on the Page** (page changes cause change blindness) / **Keep it Lightweight** (Fitts's Law: big, in-context targets) / **Provide an Invitation** (discoverability cues) / **Use Transition** / **React Immediately** (a button should depress; typed characters appear). Copy this layering: craft tier stable, action tier decides.
- **Amber Case, Principles of Calm Technology, 8**: smallest possible amount of attention / inform and create calm / make use of the periphery / amplify the best of technology and the best of humanity / can communicate but doesn't need to speak / **should work even when it fails** / the right amount is the minimum needed to solve the problem / respect social norms.
- **Clearleft, "Principles for Design Principles"** (Katie Wishlade, 2021) — the meta-set for the writing process itself: **Be purposeful** (define which decisions the principles must influence before writing them) / **Be yourself** (ground in your own users and business; don't review competitors' principles first) / **Be actionable** (collect examples that do and don't demonstrate each principle) / **Be considered** (iterate on the wording; language is the product) / **Be maintained** (an owner, decisions, and a living reference — or rot).
- **Fisher-Price Toy Making Principles** (Irving Price, Helen Schelle), 5: intrinsic play value / ingenuity / strong construction / good value for the money / action. Evidence that the form predates software entirely; evaluation lenses, not instructions.
- **Ben Brignell, 7 "knowing when to stop" principles** — directly usable by an agent iterating on UI: stop when the next change is for you, not the user ("it's art, not design"); when the problem isn't proven ("design without evidence is speculation"); when the question shifts from "why?" to "how?"; when you're redesigning, not refining ("refinement reduces uncertainty. Redesign introduces it"); when the design can't be tested in its current form; when you're designing for edge cases ("solve the common case well first"); stop to allow time to learn.

Cautionary exhibit: the library's **IBM Design Principles** entry reads as guidance/rules ("provide the ability to undo and redo," "avoid modes," "use industry standard conventions") — competent content, rule-drifted form. Length plus prescription is how a principle set quietly becomes a guideline document.

## When to use / When NOT to use

Use when:
- Starting a project or feature where real trade-offs exist and debates recur (the same argument had twice is a missing principle).
- A tie must be broken between two defensible UI options and no hard constraint decides it.
- An existing set is decorative — nobody cites it — and must be rewritten or retired.
- A design system needs its front matter: the 3–5 statements that decide pattern conflicts.

Do NOT use when:
- Compliance is non-negotiable — accessibility thresholds (4.5:1 contrast, focus visible, WCAG success criteria) are *rules*; writing them as "principles" weakens them.
- The problem is craft execution (composition, rhythm) — that is the principles-of-design layer, applied, not authored.
- You are tempted to completeness — "gaps are healthy"; a set that covers everything guides nothing.
- The audience is marketing — that is values/slogan territory, and mixing it in is failure mode 5.

## How to apply (numbered checklist)

1. **Harvest arguments.** List the 3 recurring decision debates this project actually has (e.g., density vs air, onboarding friction vs data quality, motion vs calm). Principles exist to decide *these*. No recurring debate → write no principles.
2. **Draft 3–5 one-liners**, each naming a bias and its sacrifice. Prefer the forms "Do the hard work to make it simple" and "Stay on the Page" (verb + what gets sacrificed) over nouns ("Simplicity", "Focus").
3. **Audit each line with the five checks** (decision vs intent / trade-off / rule in disguise / value in disguise / set size). Any failure → rewrite, don't append. A sixth principle to cover a gap is usually the wrong fix.
4. **De-slogan mechanically.** For each "Be X" or "Keep it Y": name two options the line must separate. If it can't, replace it with what happens "when things become complicated."
5. **Store principles as a citable artifact with ids**, next to the code, not in a slide deck:

   ```yaml
   # design-principles.yml — max 5, one line each, owned, dated
   owner: <who may change this file>
   - id: P1
     text: "Do the hard work to make it simple"
     decides: ["form structure", "progressive disclosure", "defaults"]
     sacrifices: ["shipping the first working layout"]
   - id: P2
     text: "Stay on the page"
     decides: ["edit in place vs navigate to edit screen"]
     sacrifices: ["full-page focus modes"]
   ```

6. **Break ties by citation, not volume.** Protocol: state the options (A/B), state the principles each serves, pick the option serving the higher-priority principle, record `P#` in the decision log / PR description. If no principle applies, decide, then ask whether the missing principle is worth adding — usually it isn't (gaps are healthy).
Worked tie-break (the citation format that makes the file load-bearing):

```markdown
<!-- PR/decision log entry -->
Decision: profile editing opens inline on the settings page, not a dedicated /settings/profile screen.
Options: A) navigate to edit screen  B) edit in place.
Principles: A serves none; B serves P2 "Stay on the page".
Trade-off paid: B forgoes the focus of a full-page mode (P2.sacrifices).
Audit note: no principle covers autosave timing — decided by rule (save on blur), not added as P6.
```

8. **Attach examples both ways** (Clearleft: "Be actionable") — one interface moment that demonstrates each principle and one that violates it. This is what makes a principle teachable to other agents and contributors.
9. **Review quarterly against citation count.** A principle never cited in decisions is either unused (retire it) or unmemorable (rewrite it, one line, natural shape). Assign the owner from `design-principles.yml` (Clearleft: "Be maintained").
10. **Borrow forms, never content.** GOV.UK's "This is for everyone" works because they serve an entire country; yours must come from your users and constraints (Clearleft: "Be yourself").

## AI-slop warning

How AI typically misapplies this skill — check your output for each:

- **Generates 8–12 virtue nouns** ("Clean, Modern, Intuitive, User-friendly, Accessible, Delightful...") — slogans with zero trade-offs; the set size itself fails check 5. Hard cap: 5.
- **Writes values and calls them principles** ("We believe great design matters") — belief statements resolve no option pair.
- **Copies a famous set wholesale** into a project that lacks its constraints — Rams' "as little design as possible" on a data-dense enterprise tool produces starved dashboards (the cockpit problem). Attribution is for learning forms, not pasting content.
- **Cites principles nowhere.** Writing `design-principles.yml` and never referencing `P#` in a decision re-creates the "decorative" failure at machine speed. The citation, not the file, is the skill.
- **Invents attributions.** Only these sets are verified here: Rams (10), GOV.UK (10), NHS (9), Microsoft (5), Ant Design (2 tiers), Calm Technology (8), Clearleft meta (5), Fisher-Price (5), Brignell stop-principles (7). Anything else — check principles.design or omit the attribution.
- **Promotes craft principles to project principles** ("our principles: hierarchy, contrast, repetition") — that is the Ant Design foundational tier, universal and free, not a decision you made.
- **Never stops iterating** — violates Brignell's stop-principles; refinement that introduces new questions is redesign.

## Relations

- **desengs-rams** — full treatment of the Ten Principles for Good Design; this skill cites set #10 as a form, that one applies the whole set to product UI.
- **desengs-laws-of-ux** — cognitive laws (Fitts, Hick, Miller) are discovered constraints, not authored statements; use laws to *predict* and principles to *decide*. Complementary tie-break layers, different epistemic status.
- **desengs-web-interface-guidelines** — the rules/guideline layer *below* principles (exact spacing, type, contrast numbers); principles justify exceptions to it, guidelines instantiate it.
- **desengs-ui-ux-master** — the canon index; loads this skill when a project's principles are missing, decorative, or exceed 5 entries.
- **desengs-taste** — judgement for the cases no principle covers; principles are codified taste, taste is the uncoded remainder. Contradiction to hold: a good set leaves gaps *because* taste handles them.
