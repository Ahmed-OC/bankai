---
name: practical-typography
description: Use when rendering any body text, headings, or UI copy — sizes, line spacing, line length, fonts, quotes, dashes, emphasis. Butterick's Practical Typography condensed to exact decision points.
source: https://practicaltypography.com/
category: reference
---

# Practical Typography — Butterick's rules, condensed to decision points

Source: https://practicaltypography.com/ — Matthew Butterick, "Butterick's Practical Typography" (online book). The canonical rulebook for setting English text. Free to read; all quoted rules below are Butterick's verbatim.

## What it is / Why it exists

A typography book written for people who make documents and web pages with default settings. Its thesis: "most documents can be significantly improved with less effort than you'd spend on a cup of coffee," because typography errors are habits inherited from typewriters, not taste problems. The book's own summary lists 26 key rules; the four body-text variables — point size, line spacing, line length, font — "determine how the body text looks." Everything else is emphasis, punctuation, and layout discipline. The companion essay "Typography in ten minutes" compresses it to five moves: set the body text first, tune line spacing/length/font second, then headings, then punctuation, then stop — restraint is the method. For an agent, this is the pre-flight checklist applied to every text node it renders: HTML, markdown, email, PDF, or app UI.

## The core ideas

Butterick's own frame: the four body-text variables (point size, line spacing, line length, font) plus a set of bans inherited from the typewriter. The whole book in one table:

| Decision | Exact value |
| --- | --- |
| Body size (print / web) | 10–12 pt / 15–25 px |
| Line spacing | 120–145% of size (unitless 1.2–1.45) |
| Line length | 45–90 chars incl. spaces (2–3 alphabets) |
| Paragraph gap (if not indenting) | 50–100% of body size (4–10 pt) |
| First-line indent (if not spacing) | 1–4× point size |
| Heading size step | smallest visible increment (~1.05–1.2×) |
| Heading levels | max 3, two is better |
| Letterspacing on caps/small caps | +5–12% (0.05–0.12em) |
| Letterspacing on lowercase | none, ever |
| Fonts per document | 2 usual, 3 rare, 4 never |
| Spaces between sentences | exactly one |

Verification mechanism — the alphabet test: paste `abcdefghijklmnopqrstuvwxyz` onto a rendered line; 2–3 full copies should fit. Works anywhere, no character counter needed.

### 1. The four body-text numbers

- **Point size**: print body text 10–12 pt ("If you're not required to use 12 point, don't" — try 10, 10.5, 11.5). Web body text **15–25 px**. Footnote/caption territory (6–8 pt on business cards) is legible, so small UI labels are fine — just not as body text.
- **Line spacing**: **120–145% of the point size**. 110% is too tight, 170% too loose. In CSS: unitless `line-height: 1.2`–`1.45`. Fonts that render small at a nominal size need less spacing; the tighter the line spacing, the shorter the line length must be.
- **Line length**: **45–90 characters per line including spaces**; "you should be able to fit between two and three alphabets" on a line. Measure in characters, never px/rem. Butterick on responsive layout: "The major flaw in many responsive web layouts? Insufficient attention to line length."
- **Font**: "The easiest and most visible improvement you can make to your typography is to use a professional font." Avoid goofy fonts, monospaced fonts (for proportional text), most free fonts, and system fonts — "especially Times New Roman and Arial."
- **The variables are coupled**: as point size shrinks, reduce line spacing and line length too (that is why newspaper type stays legible). When fitting text into a fixed space, adjust line spacing before point size — it moves more ink per unit of change.

Baseline CSS for any reading surface:

```css
.prose {
  font-size: clamp(1rem, 0.9rem + 0.5vw, 1.3125rem); /* stays inside 15–25px */
  line-height: 1.4;             /* unitless → 120–145% at any size */
  max-width: 72ch;              /* ch = width of "0"; keeps 45–90 chars */
  text-align: left;
  hyphens: auto;                /* only needed if you ever justify */
  font-kerning: normal;         /* "Kerning should always be turned on" */
}
```

### 2. Emphasis: bold, italic, and the bans

- **Bold or italic — never both**: "think of them as mutually exclusive," and "use bold and italic as little as possible. They are tools for emphasis." If everything is emphasized, nothing is. Short spans only — never a whole paragraph in bold.
- **Serif body text**: italic for gentle emphasis, bold for heavier. **Sans-serif body text**: skip italic ("most sans serif italic fonts just have a gentle slant" that doesn't stand out) — use bold.
- **Semibold is a legitimate middle weight** for large text, but for body emphasis Butterick usually prefers full bold for contrast. Black/ultra weights suit headlines only. Foreign words: italicize the unassimilated (*bête noire*, *Weltanschauung*), never the absorbed (croissant, résumé). Punctuation adjacent to an emphasized span stays roman unless a collision demands otherwise.
- **Underlining: "Absolutely not."** "In a printed document, don't underline. Ever. It's ugly and it makes text harder to read." It's a typewriter workaround (typewriters had no bold/italic). In UI: underline only links, and even there color + weight suffices — "Are underlined links dead? Maybe not quite. Dying? For sure." Never underline non-link text.
- **All caps: "Fine for less than one line"** — headings, labels, headers/footers. "DON'T CAPITALIZE WHOLE PARAGRAPHS"; caps at body sizes read as a uniform rectangle (no word shapes) and cause skimming. To warn or alert, use a rule/border, a label heading, or a larger size — not caps.
- **Small caps: "Use real small caps; avoid fakes."** Fakes (scaled-down capitals) are too tall and too light. If the font has no true small caps, don't use them at all. Same sparing-use and letterspacing rules as all caps.
- **Letterspacing**: add **5–12% (CSS 0.05em–0.12em) to all-caps and small-caps text only**, especially at small sizes. "Lowercase letters don't ordinarily need letterspacing" (Goudy: "Anyone who would letterspace lowercase would steal sheep"). Overshoot test: if the gaps between letters could fit more letters, you've gone overboard.
- **Emphasis escalation is an arms race** — solve it with structure (headings, lists), not ever-heavier formatting.

```css
.label {                 /* the correct caps pattern */
  text-transform: uppercase;   /* apply to typed-lowercase source text, keep it toggleable */
  letter-spacing: 0.08em;      /* 5–12% */
  font-feature-settings: "smcp" on;  /* real small caps, if the font has them */
}
a { text-decoration: underline; }      /* links only */
a:hover { text-decoration: none; }
strong, b { font-weight: 700; }
em, i { font-style: italic; }          /* never combined: no bold-italic spans */
```

### 3. Punctuation: where AI slop lives

- **Curly quotes always**: " and ' never " and '. "Straight quotes should never, ever appear in your documents." Exception: code and backticks (syntax must stay literal) and foot/inch marks (those stay straight: 5' 11"). Straight quotes are acceptable in email; everywhere else they signal machine output untouched by care.
- **Apostrophes point downward** — same character as the closing single quote (’), never the opening one (‘). So *isn’t*, the ’80s (typed directly, or smart-quotes will flip it wrong), Patent ’211. The Hawaiian okina is the one upward apostrophe-like mark (Hawai‘i) — or just use anglicized spellings.
- **Three dash characters, never stacked hyphens**: hyphen `-` for compounds (topsy-turvy) and phrasal adjectives (five-dollar bills); en dash `–` for ranges (1880–1912, pp. 330–39) and pairs (Sarbanes–Oxley Act) — but "from 1880 to 1912", never "from 1880–1912"; em dash `—` for sentence breaks — "when a comma is too weak, but a colon, semicolon, or pair of parentheses is too strong." En/em dashes sit flush against the text (word spaces around an em dash only if it looks crushed on screen); never substitute a slash for an en dash.
- **Ellipsis**: the character `…`, not three periods; nonbreaking space on whichever side has text.
- **Exactly one space between sentences**; never multiple word spaces in a row — doubled spaces "disrupt the balance of white space" and can cut rivers across a page.
- **Real symbols**: ™ © ®, not (TM) (C) (R). Ampersands sparingly. In documents over three pages, "one exclamation point is plenty."

Mechanism for web text: emit correct Unicode characters in content (" " ' ' – — …) with UTF-8 encoding, rather than converting at runtime. If conversion is needed, use an existing smart-quotes library with `lang` awareness — don't hand-roll the regex (decades of edge cases: ’80s, code spans, HTML attributes). Keep `code`, `pre`, and `kbd` content exempt.

### 4. Paragraph architecture

- **Separate paragraphs with EITHER a first-line indent of 1–4× the point size (12 pt text → 12–48 pt; CSS `text-indent: 1.5em`) OR 4–10 pt of space between paragraphs (50–100% of body size; CSS `margin-block: 0.75em 0`)** — "Using both is a mistake. Belts and suspenders." Never insert blank paragraphs/`<br>` runs.
- **First paragraph after a heading: no indent** — it's obvious where it starts.
- **Prefer space-after over space-before** (word processors and collapsing margins take the larger of the two, so before+after values don't sum). Block quotes get a side indent, not quotation-mark decoration. Hanging (negative) indents only with bullets — "text should only be indented inward."
- **Justified text**: left-align on the web — "the justification engine of a word processor or web browser is rudimentary," producing "gruesomely large spaces between words." If you must justify, hyphenation is mandatory: `text-align: justify; hyphens: auto;` plus `text-justify: inter-word` as the lesser evil. Justification "is not a signifier of professional typography."
- **Centered text: short phrases or titles only** — never whole blocks (both edges ragged = hard to read, hard to align). "Asymmetry is nothing to fear."

### 5. Headings

- **Limit yourself to three levels of headings. Two is better.** Beyond that, simplify the outline, don't add depth.
- **Bold, not italic; never underline; never all caps; sentence case** — "Always Avoid Title Case, Because Your Headings Aren't Titles."
- **Size: "just a little"** — for 12 pt body try 12.5–13 pt, not 14–15. "There is no typographic universe in which you need to double the point size" (the browser-default `<h1>` at ~200% is a starting point to shrink, not a target). Reject invented modular scales: "When your headings look right, they are right. The ratio is irrelevant."
- **The best emphasis is space above and below** the heading, not size. If a heavy bold face makes headings feel darker than needed, drop the size a half point rather than dropping the weight.
- No hyphenation in headings; keep headings with the following paragraph (`break-after: avoid`); don't center them. Only two levels of indentation, even with three heading levels — deeper indents "look random and messy."

```css
h1, h2, h3 { font-weight: 700; text-wrap: balance; hyphens: none; }
h2 { font-size: 1.17em; margin: 1.5em 0 0.5em; break-after: avoid; }
h3 { font-size: 1.06em; margin: 1.25em 0 0.5em; break-after: avoid; }
```

### 6. Font choice and pairing

- **Budget: most documents tolerate a second font, few a third, almost none four or more.** One font per paragraph; switch only at paragraph/role boundaries. In a multi-page UI, the whole product counts as one document — and "for presentations, treat all slides as a single document" when counting fonts.
- **The serif+sans pairing rule is a myth**: "You can mix any two fonts that are identifiably different." Lower contrast between fonts often works better than higher. Give each font a consistent role (body vs. headings vs. peripheral labels/footers).
- **Rote method that works**: combine fonts by the same designer (families meant to sit together).
- **System fonts — "Avoid if you can, choose wisely if you can't."** Tolerable: Charter, Gill Sans, Helvetica Neue, Avenir, Franklin Gothic, Iowan Old Style, Century Schoolbook, Palatino/Garamond variants, Optima, Hoefler Text, Segoe UI, Calibri (limited doses). Fatal to credibility ("F list"): Arial, Verdana, Tahoma, Trebuchet MS, Comic Sans, Papyrus, script/stencil/novelty fonts — Arial ranks below Comic Sans for Butterick. Screen-only use buys leniency; anything that might be printed does not.
- **Free fonts**: "most free fonts are garbage," but these pass: Source Serif, Source Code, IBM Plex (sans/serif/mono), Cooper Hewitt, Charter (OFL-licensed, "holds up beautifully on today's screens"). Free ≠ system: system fonts carry restrictive licenses; OFL fonts can ship with software.
- For websites, he adds: drop the mid-'90s habits — tiny body text, huge headings — and "steal from better sources" than web templates.

## When to use / When NOT to use

**Use when**: rendering prose of any length (articles, docs, emails, chat messages over one paragraph), choosing type scale or measure for a layout, formatting emphasis in generated copy, emitting punctuation from templates, or deciding fonts for a product. The punctuation rules apply to every text output, including short UI strings.
**Do not use for**: non-Latin scripts (the book covers English), display/brand lettering (different discipline), or as an excuse to skip font-loading/performance decisions — this skill sets targets, it doesn't load fonts. Interaction-specific text rules (truncation, tap targets, contrast ratios) live elsewhere; this skill governs how text is *set*, not whether it's *reachable*. Monospace is exempt where it is the convention — code editors, terminals, ASCII-aligned tables — the ban targets proportional prose set in mono.

## How to apply

1. Set body text: 15–25 px (web) or 10–12 pt (print), `line-height` 1.2–1.45 unitless, container capped 45–90 `ch` — verify with the alphabet test (2–3 alphabets per line).
2. Pick one professional font for body; add at most one more for a distinct role; each is identifiably different and consistently used. Default stack candidates: Charter, Source Serif, IBM Plex; never Arial/Verdana/Tahoma as a design choice.
3. Separate paragraphs with exactly one mechanism: `text-indent` 1–4em (skip on first paragraph) **or** `margin-block` ~0.5–1em — never both, never empty paragraphs.
4. Left-align by default. If justifying, add `hyphens: auto` or don't justify.
5. Headings: ≤3 levels, bold, sentence case, smallest visible size step, emphasized mainly by margin; `break-after: avoid`.
6. Emphasis in running text: choose bold *or* italic for short spans (bold-only next to sans body); never bold-italic, never underline, never all-caps paragraphs.
7. Caps/small-caps labels: `text-transform: uppercase` on lowercase source + `letter-spacing: 0.05em–0.12em` + real small caps (`"smcp"`) or none.
8. Scan emitted copy for typewriter marks and fix: " → “ ”, ' → ’ (downward), -- → – / — (range vs. break), ... → …, (C) → ©, double spaces → single.
9. Links: underline or color, never both mandatory; no other underlined text anywhere.
10. Never fake structure with characters: no tab runs, no tables of spaces, no ASCII rules (`---` as a visual divider in rendered output), no carriage returns for vertical space.
11. Re-check line length last, at the narrowest and widest supported viewports — responsive layouts fail here first.
12. For PDF or print export, hold the 10–12 pt equivalent and embed the font — "any PDF may get printed," so screen-optimized fonts (Georgia, Verdana, Calibri) lose their one advantage.

## AI-slop warning

Generated UIs commit these constantly: straight quotes and dumb apostrophes pasted into otherwise polished copy (Butterick: "one of the most grievous and inept typographic errors"); `--` or ` - ` where an em dash belongs; title-case headings; ALL-CAPS PARAGRAPHS; underlined "decorative" text; bold-italic combo emphasis; tracking-widest lowercase (the fake-luxury look — lowercase must not be letterspaced); fake small caps via `font-size: 0.8em; text-transform: uppercase`; huge modular heading scales (h1 3rem+ for a 1rem body) with airy 1.8 line-height "for elegance"; `line-height` in px (breaks on user zoom); four-font stacks; centered paragraphs; justified text without hyphenation creating rivers; `1.5rem`+ gaps between paragraphs *plus* indents. The deeper failure: AI treats typography as styling applied after content, so it ships defaults plus decoration. Butterick's position is the inverse — four numeric decisions (size, spacing, measure, font) plus removing typewriter habits *is* the styling.

## Relations

- **calvez-typography** — another typography essay; adds a designer's expressive intent where Butterick is strictly rule-based — read it after this, not instead.
- **web-interface-guidelines** — covers the interaction half of text (touch targets, truncation, i18n, contrast numbers) that this skill deliberately does not.
- **oklch** — the color-side counterpart: this skill fixes measure and rhythm, OKLCH fixes the text/contrast values.
- **ui-ux-canon** — the canon root that dispatches to this skill whenever rendered text needs setting.
