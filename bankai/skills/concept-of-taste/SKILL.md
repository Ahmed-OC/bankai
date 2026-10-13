---
name: concept-of-taste
description: Use when deciding whether a UI choice is taste or trend, or when generated output looks correct but feels generic. Salaja's thesis: taste is trainable pattern discrimination built on fundamentals, not inherited instinct.
source: https://www.raphaelsalaja.com/library/the-concept-of-taste
category: essay
---

# The Concept of Taste — taste as trainable discrimination

Source: https://www.raphaelsalaja.com/library/the-concept-of-taste — Raphael Salaja, "The Concept of Taste", published 11 March 2025 on his personal site's library. A short philosophy-of-design essay; no license stated. Author is the same design engineer behind userinterface.wiki and calligraph (see Relations). It is the theoretical counterpart to his rule canon: the wiki says *what* to do, this essay says *what the faculty is that decides*.

## What it is

Salaja's answer to "isn't taste just subjective?" — no. The essay's opening move: "Taste in art and design is commonly called subjective, but history tells a different story. The frameworks that shape what we call 'good' are built by centuries of debate, critique, and cultural evolution. What feels intuitive is often the product of deliberate choices, repeated until they become invisible."

That last clause is the thesis: **taste is accumulated, now-invisible deliberate choice — a trainable discrimination ability, not an inborn or arbitrary preference.** Everything else in the essay (the philosophers, the trend critique, the cultivation method) derives from it. For anyone generating UI it reframes the job: taste is not picking a vibe, it is running pattern-matching against a large corpus of analyzed work and choosing on fundamentals.

## The core ideas

### 1. Three lenses: Hume, Kant, Bourdieu — taste is personal AND collective

Salaja compresses the philosophy of taste into three positions:

- **Hume**: taste is "a skill, honed by exposure and education." (The essay's own model.)
- **Kant**: taste, "though personal, could be guided by principles like harmony and balance." (Subjectivity channeled through structure.)
- **Bourdieu**: taste as "a tool of social distinction, more about cultural capital than innate perception." (The cynical check — much "taste" is signaling.)

His synthesis: "These perspectives reveal a tension: taste is both personal and collective, shaped by individual experience and the gravitational pull of community." Decision consequence: when your preference and the field's consensus disagree, neither automatically wins — but a preference you cannot connect to a fundamental (see #3) is probably Bourdieu-signaling, and should be dropped.

### 2. What taste actually detects: patterns, not vibes

"Behind every 'just right' composition or color choice, there are patterns: balance, proportion, the play between minimalism and maximalism. Color isn't just a visual tool, but a carrier of mood and memory. Typography sets the tone before a word is read. Even when taste feels like instinct, it's often the result of these structures at work."

The claim: every "it just feels right" verdict decomposes into nameable structures — balance, proportion, density play (minimalism vs maximalism), color's mood/memory load, typography's pre-semantic tone. An instinct you cannot decompose is untested; decompose it before trusting it.

### 3. Taste vs trend: fundamentals endure

"Trends flare and fade. What lasts is work grounded in fundamentals — composition, hierarchy, clarity — yet open to reinvention."

Two-tier model: **fundamentals** (composition, hierarchy, clarity) age well; **trends** are time-stamped. Trendy-but-broken fails fast; fundamental-but-dead is forgettable. The target is fundamentals "yet open to reinvention" — sound structure, current execution.

### 4. Taste moves, and digital moves it faster

"Taste adapts. Baroque drama gave way to modernist restraint, then to postmodern irony. Each movement was as much about its moment as its style. Today, digital culture accelerates this cycle: platforms amplify certain aesthetics, algorithms remix them, and what's new becomes old in weeks."

The product-design consequence he draws: "balancing usability with character, resisting the urge to chase novelty for its own sake." Corollary for generated UI: the aesthetic most visible right now (most amplified, most remixed by the models themselves) is by definition the closest to "old in weeks." The algorithmic default is the fastest-aging choice available.

### 5. Taste is built, not inherited — the cultivation loop

"Taste isn't inherited. It's built, by studying, experimenting, analyzing." And the essay's most quotable, hardest claim:

> "Anyone who says taste can't be taught is lying."

The method he prescribes:

1. **Look beyond your own era** — "The most resonant work often comes from those who look beyond their own era, borrowing, remixing, questioning what's considered 'good.'"
2. **Train discrimination explicitly** — "Training the eye means noticing why some designs sing and others falter. It means caring about hierarchy, readability, and emotional resonance — not as rules, but as tools." (Noticing *why*, not just *which* — diagnosis, not preference.)
3. **Feed widely** — "Browse Cosmos, Pinterest, Twitter, Instagram, digest critically acclaimed media, engage with diverse perspectives and always be curious." "There's a multitude of resources available now, everything is so accessible." Access is no longer the bottleneck; analysis is.
4. **Go cross-disciplinary** — da Vinci's "notebooks brimmed with observations spanning art, anatomy, engineering, and nature. Your mind should be a repository of the world, able to connect ideas and concepts across disciplines."

That is a loop: expose → analyze why → borrow/remix → expose again. Skill accrues per-iteration, which is why taste *cannot* be transmitted as a rule list — only as a trained discriminator plus the fundamentals it learned to lean on.

### 6. Where taste lives: between feeling and form

"Taste lives in the space between feeling and form. The best work balances personal intuition with structures that guide attention and evoke response. It's not about erasing subjectivity, but about channeling it through principles that endure."

And the closing definition: "Taste is never just about what you like. It's the intersection of memory, culture, critique, and craft." The job is "to move between tradition and invention, to create work that feels both timely and timeless." The test of success: "The result isn't just work that catches the eye. It's work that stays with you."

## Taste, style, trend — three different things (derived)

The essay never tabulates this, but its trend/fundamental split implies it:

| | What it is | Lifespan | Failure mode |
|---|---|---|---|
| **Taste** | Discrimination: knowing *why* something works, per fundamentals | Compounds | Never formed — no exposure, no analysis |
| **Style** | The surface a trained taste chooses this project | Years | Copied wholesale without the taste behind it |
| **Trend** | The current amplified aesthetic | Weeks | Chased for its own sake |

Sequence matters: taste → style → (optionally) trend accents. Trend → style (skipping taste) produces work that dates itself on ship.

## When to use

- Choosing between two defensible options ("both correct, one better") — run the fundamentals test, not a vibe vote.
- Deciding whether to adopt a current aesthetic (glass, claymorphism, whatever is being remixed now) — check it against "old in weeks."
- Reviewing generated UI that passes every check but feels generic — that is a missing-discrimination symptom, this skill's diagnosis applies.
- Building or evaluating a design-education/review loop for an AI or human — use Salaja's expose → analyze-why → remix cycle as the spec.
- Writing design principles: keep them in "structures that guide attention" territory (hierarchy, clarity, proportion), not trend territory.

## When NOT to use

- As a substitute for falsifiable rules — this essay supplies the philosophy, not values; get timings, contrast ratios, and easing curves from ui-wiki and siblings.
- To settle accessibility, usability, or performance questions — those are not taste questions; WCAG and interaction-latency rules win over any aesthetic argument.
- To justify exotic choices on "timeless" grounds — if it is not grounded in composition/hierarchy/clarity, it is trend or signaling (Bourdieu), and the essay argues against it too.

## How to apply (numbered checklist for an AI building UI)

1. **Decompose every "feels right."** For each styling decision, name the structure doing the work: balance, proportion, density play, color mood, typographic tone, hierarchy, clarity. If nothing names, the choice is arbitrary — redo it.
2. **Adopt a written reference corpus before generating.** Maintain 10–20 named references (products, eras, media) each with a one-line *why-it-works* note, spanning more than the current era (e.g., at least 3 pre-digital sources). Generate against the corpus, not against the training-distribution default. Minimum viable format — the `why` field is mandatory, it is the analysis step:

   ```js
   // taste-corpus.js — exposure without analysis does not train taste
   export const corpus = [
     { ref: "Braun TP1",            era: 1958, why: "one accent control max; hierarchy via size+position, never color count" },
     { ref: "Swair indentation grid", era: 1972, why: "proportion rhythm: constant gutter, variable column" },
     { ref: "Linear pricing page",  era: 2024, why: "density play — maximal info, minimal ink" },
     // ≥3 pre-digital entries; retire entries whose 'why' you can no longer defend
   ];
   ```

3. **Tiebreak defensible options by fundamentals, then corpus, never by vibes.** When two options both pass correctness: (a) pick the one whose support is a fundamental (hierarchy/clarity/composition); (b) if both are fundamental, pick the one matching a corpus `why`; (c) only then flip a coin. This ordering is the whole skill in one rule.
4. **Run the trend tax.** Before adopting any currently-amplified aesthetic, ask: is this doing structural work (hierarchy, clarity, character) or is it the remix-of-the-month? Cap trend elements at accents; never let one carry hierarchy or legibility.
5. **Balance usability with character.** Every screen: usability non-negotiable, then add at most 1–2 character moves (distinct type pairing, one bold proportion choice, one mood-carrying color decision). Zero character = invisible; all character = unusable.
6. **Encode deliberate choices so they become invisible.** "Repeated until they become invisible" = tokens. Choices proven by analysis go into tokens (color, radius, spacing, type scale, motion) and are never re-litigated per-component:

   ```css
   :root {
     /* decisions made once, by taste; applied everywhere, invisibly */
     --font-display: "Satoshi";      /* tone set before words are read */
     --accent: oklch(0.68 0.14 155); /* ONE mood-carrier, not decoration */
     --radius: 12px;                 /* one proportion voice */
     --space-unit: 8px;              /* rhythm = proportion made visible */
   }
   ```

7. **Run a why-critique pass.** After generating, per section ask "does this sing or falter, and why?" — output a one-line verdict naming the structure that succeeds or fails. Falter verdicts get fixed by changing structure, not by adding decoration.
8. **Feed cross-domain on purpose.** When stuck, pull a mechanism from outside software UI (print, film titles, cartography, industrial design) rather than another SaaS landing page.
9. **Ship "timely and timeless":** fundamentals carry the load (composition, hierarchy, clarity); at most ~20% of visible surface is era-stamped.

## Implications for AI-generated UI

Salaja does not discuss AI in the essay; these follow from applying his framework (canon inference, not quotation):

- **Can AI have taste?** On Hume's model — taste as skill from exposure and education — yes, in the only sense that matters operationally: an AI with a large, *analyzed* reference corpus and a decomposition habit behaves like trained taste; one without behaves like an untrained picker with strong priors.
- **Where to encode it:** not in the model, in the loop — (a) the reference corpus (#2), (b) the named-structure requirement (#1), (c) tokenized deliberate choices (#5), (d) the why-critique pass (#6). Taste externalized as process survives model and tool churn.
- **The default is the failure mode.** A generative model's statistical center is the "platforms amplify, algorithms remix" aesthetic at maximum concentration — precisely what the essay says turns old in weeks. Distance from the default is not contrarianism; it is the trend tax (#3).
- **Trend-laundering check:** AI output "looks like good design" when it matches the amplified present. Ask instead: stripped of era markers, is the composition/hierarchy/clarity still strong? If not, it was trend, not taste.

## AI-slop warning

How AI typically misapplies this principle (principles-category warning):

- **Treating taste as a style skin**: applying "brutalist" or "Swiss" as a filter (font + color swap) while the underlying hierarchy stays generic. The essay's whole point is that taste is the *judgment layer* (pattern decomposition), not the surface layer.
- **Subjectivity cop-out in both directions**: either "taste is subjective, anything I output is valid" (refuses the fundamentals tier) or "taste is Bourdieu signaling, ignore aesthetics" (refuses the craft tier). The essay requires both: personal intuition channeled through enduring principles.
- **Skipping the analysis step**: hoarding references (moodboards, "inspiration") without ever writing *why* each one works. Salaja's loop is expose → **analyze why** → remix; the middle step is the entire training signal, and it is the one AI pipelines most often omit.
- **Confusing recency with taste**: defaulting to the currently-most-remixed aesthetic because it is most represented in training data. That is the accelerated cycle working against you — "what's new becomes old in weeks."
- **One-era diet**: drawing only from contemporary SaaS/dribbble-style work. He explicitly prescribes looking "beyond your own era" and cross-disciplinary repossession; a single-era corpus cannot produce "timeless."

## Relations

- **ui-wiki** — same author (Raphael Salaja); his 152-rule falsifiable canon is the "structures that guide attention" made explicit: exact timings, curves, shadows, numerals. This essay is the why behind that wiki's discipline; use the wiki for values, this skill for judgment between values.
- **taste** — the operational anti-slop doctrine (Taste Skill, different source/author): concrete ban lists and pre-flight checks. This essay supplies its theoretical grounding — why the defaults are banned (they are the over-remixed present) and why the "design read" exists (decompose before generating). Where taste says *what*, Salaja says *what the faculty is*.
- **shedsgns-taste** — a second taste essay in the canon; compare theses: where Salaja frames taste as trainable personal discrimination, the shedsgns piece frames it as convergent preference refined under critique. Use Salaja for the training method, the other for the social/convergence angle.
- **calligraph** — same author's typography practice; direct evidence of his own rule that "typography sets the tone before a word is read" — letterform craft as the pre-semantic layer of taste.
