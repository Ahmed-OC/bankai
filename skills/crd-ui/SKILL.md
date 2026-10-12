---
name: crd-ui
description: Use when building payment forms or wallet UIs that need a live credit/debit card preview — brand detection, CVC flip, tilt, masked display, theming via CSS custom properties.
source: https://crd-ui.juanda.co/
category: library
---

# crd-ui — card design, elevated

Source: https://crd-ui.juanda.co/ — by Juan Garcia (@JuandaGarcia). A framework-agnostic **credit/debit card visualization** component ("crd" = credit card, not layout cards). Zero-dependency vanilla core; React 18+/Vue 3/Svelte 5 wrappers as subpath imports. MIT; 45 card backgrounds CC0. Docs also served as `llms.txt`/`llms-full.txt` for agents.

## What it is / Why it exists

A display-only card preview that mirrors your own payment inputs in real time: formatted/masked number, name, expiry MM/YY, CVC on the back, live brand detection, 3D flip on CVC focus, optional pointer tilt. It exists because the incumbent, `react-credit-cards`, has been unmaintained since June 2020 and fails to install on React 18/19 (`ERESOLVE` on its `react@^15 || ^16` peer dep). crd-ui's answer: one zero-runtime-dependency core that owns the DOM, with framework wrappers that are thin controlled components — not four reimplementations.

The design boundaries are the point: **the component only presents, it never stores or handles card data.** All state lives in your inputs; the card is a controlled view. This is what lets it compose with PCI iframe providers (Stripe Elements) where the number never touches your code.

## The core ideas

### 1. Controlled mirror, never a source of truth
Wire it as `<Card number={number} focused={focused} />` next to plain inputs; `onFocus`/`onBlur` set `focused` to the field name or null. Vanilla: `createCard(el, opts)` returns `{ update, brand, element, destroy }` — call `card.update({ number: value })` on input, `card.update({ focused: 'cvc' })` on focus to flip. The preview is derived state; nothing flows back except `onBrandChange`.

### 2. Fixed card anatomy at the real ratio
Root `perspective: 1000px`; an inner wrapper rotates; front/back faces use `backface-visibility: hidden`, back pre-rotated `rotateY(180deg)`. Card is 430×270 (~1.59:1, the ID-1 payment-card proportion) — backgrounds are shipped pre-sized to exactly this ratio so `--crd-bg` fills with `cover` and never crops. Slots: `root, inner, front, back, chip, logo, number, footer, name, expiry, expiryLabel, expiryValue, meta, metaExpiry, metaCvc, cvc` — 16 named parts, style any via a `classNames` map merged with built-ins.

### 3. The CVC flip is choreographed, not a bare rotateY
Default duration `0.75s` (`--crd-flip-duration`), inner transition `cubic-bezier(0.34, 1.3, 0.5, 1)` — the y > 1 overshoot reads as a spring settling past 180°. On every flip the core adds a transient `.crd--flipping` class running a `crd-lift` keyframe: `translateY(-7%) scale(1.06) rotate(-2.5deg)` at 50%, `translateY(-4%) scale(1.04) rotate(1.2deg)` at 75% — the card lifts off the surface with a wrist-flick tilt while a shadow animation grows underneath and a sheen sweeps each face via `::after` (parked fully transparent otherwise). All of it disabled under `prefers-reduced-motion: reduce`.

```css
.crd { perspective: 1000px; }
.crd__inner {
  position: relative; transform-style: preserve-3d;
  transition: transform var(--crd-flip-duration, .75s) cubic-bezier(0.34, 1.3, 0.5, 1);
}
.crd--flipped .crd__inner { transform: rotateY(180deg); }
.crd__face { position: absolute; inset: 0; backface-visibility: hidden; }
.crd__back { transform: rotateY(180deg); }
@keyframes crd-lift {
  50%  { transform: translateY(-7%) scale(1.06) rotate(-2.5deg); }
  75%  { transform: translateY(-4%) scale(1.04) rotate(1.2deg); }
}
@media (prefers-reduced-motion: reduce) {
  .crd__inner { transition: none; }
  .crd--flipping { animation: none; }
}
```

### 4. One traveling focus ring
A single `.crd__ring` element slides and morphs (position + size, spring settle) to frame whichever section `focused` names — number, name, expiry, or the CVC on the back. Not four per-field outlines: one element, retargeted. This keeps the input→preview correspondence legible without decorating every field.

### 5. Pointer tilt with cursor-tracked glare — hover-only, opt-in
`tilt` defaults to **false**. Core math: `TILT_MAX = 12deg`; on `pointermove`, normalized pointer `(px, py)` writes custom properties — `--crd-tilt-ry = (px - 0.5) * 12deg`, `--crd-tilt-rx = (0.5 - py) * 12deg`, glare center `--crd-tilt-gx = px * 100%`, `--crd-tilt-gy = py * 100%`. CSS does the rest: rotate while hovered with a fast 400ms `cubic-bezier(0.22, 1, 0.36, 1)` follow, ease back flat on leave with a slow 1000ms same-curve return. Glare = three layered radial circles (95px, 200px, 360px) blended like light (`screen`), opacity fade 300ms. On touch (`pointer: coarse`) the tilt is flattened, glare hidden, and `touch-action` restored — pointer-driven tilt fires erratically on tap. Same kill switch under reduced motion.

```css
.crd--tilt {
  transform: perspective(1000px)
    rotateX(var(--crd-tilt-rx, 0deg)) rotateY(var(--crd-tilt-ry, 0deg));
  transition: transform 1000ms cubic-bezier(0.22, 1, 0.36, 1);
  will-change: transform;
}
.crd--tilt.crd--tilt-hover { transition-duration: 400ms; } /* cursor-follow */
.crd__glare {
  background:
    radial-gradient(circle 95px  at var(--crd-tilt-gx, 50%) var(--crd-tilt-gy, 50%), …),
    radial-gradient(circle 360px at var(--crd-tilt-gx, 50%) var(--crd-tilt-gy, 50%), …);
  mix-blend-mode: screen; opacity: 0;
  transition: opacity 300ms cubic-bezier(0.22, 1, 0.36, 1);
}
.crd--tilt.crd--tilt-hover .crd__glare { opacity: 1; }
```

```js
const MAX = 12; // deg
el.addEventListener('pointermove', (e) => {
  const r = el.getBoundingClientRect();
  const px = (e.clientX - r.left) / r.width, py = (e.clientY - r.top) / r.height;
  el.style.setProperty('--crd-tilt-ry', `${(px - 0.5) * MAX}deg`);
  el.style.setProperty('--crd-tilt-rx', `${(0.5 - py) * MAX}deg`);
  el.style.setProperty('--crd-tilt-gx', `${px * 100}%`);
  el.style.setProperty('--crd-tilt-gy', `${py * 100}%`);
});
```

### 6. Live brand detection while typing
10 brands detected from the number as typed: visa, mastercard, amex, discover, dinersclub, jcb, unionpay, maestro, elo, hipercard — each with its own theme class (`.crd--brand-visa`, …) and formatting spec (Amex groups 4-6-5, 15 digits, 4-digit CVC). The rendered number is formatted per brand and masked while typing: untyped digits show as `•` padded to the brand's `maskLength`, so the card always looks complete and the user sees exactly how much is left. Exported `detectBrand` / `getBrandSpec` expose `lengths` and `maskLength` so you can validate length without another dependency. Built-in logo marks are deliberately generic wordmarks — the package ships no trademarked assets; pass licensed SVGs via `logos` (built-ins exported as `LOGOS` to extend rather than replace). The brand also feeds two visual channels: the logo swap and, in `sunset`/`gradient` variants, the finish tint.

### 7. Two layouts: form preview vs. owned card
`layout="form"` (default) is the checkout preview — CVC on the back, flip on CVC focus. `layout="display"` presents a card the user already owns (dashboards, saved-card lists, wallets): expiry and CVC move to a front meta row, empty values stay masked, empty name hides, no flip. The security pattern: start with `last4` + `brand` (renders `•••• 4242`), reveal by passing real values fetched on demand behind an explicit user action; `copyable` then makes revealed fields click-to-copy with a "Copied" bubble and an `onCopy(field, value)` hook.

### 8. Theming = `var()` fallbacks, not declarations
The stylesheet never *declares* `--crd-*` on `.crd`; it reads them with defaults as `var()` fallbacks. Consequence: an override set on the card **or any ancestor** always wins over brand and variant themes — that is the whole API: `--crd-width`, `--crd-radius`, `--crd-bg` (a full CSS `background` value — gradients or images), `--crd-font`, `--crd-color`, `--crd-shadow`. Six variants: `sunset` (default; tints its color bloom to the detected brand), `ember`, `holo`, `porcelain`, `graphite`, `gradient` (classic dark per-brand finish). Use `variant="gradient"` with `--crd-bg` artwork so the finish doesn't overpaint it. Framework wrappers land `className` on the root and are otherwise pass-through — creation-time options (`placeholders`, `locale`, `logos`) change only by remounting (e.g. a `key`).

### 9. Composing with PCI iframes (Stripe)
Because it is display-only it pairs with iframe fields: map the provider's brand to the `brand` override and iframe focus events to `focused`; digits stay masked. `brandFromStripe()` translates slugs (`'diners'` → `'dinersclub'`, `'unknown'` → `null`). Async iframe events create a focus race — clear focus only "if the focus is still ours," not unconditionally on blur. Post-tokenization, feed `PaymentMethod.card.last4` into `last4`.

### 8b. Tailwind without config (and the one case needing layers)
Because every knob is a custom property with a `var()` fallback, arbitrary-property utilities theme the card with zero config, on the card or any ancestor, and they beat the brand/variant themes: `className="[--crd-radius:1.25rem] [--crd-bg:var(--color-indigo-600)]"` (underscores become spaces: `[--crd-bg:url('/textures/holo.png')_center/cover]`). The one exception: utilities that override the card's *own* rules (e.g. `text-2xl` against the number's font-size) lose, because unlayered CSS always beats Tailwind's `@layer utilities`. Fix by declaring `@layer crd-ui, theme, base, components, utilities;` before importing Tailwind and using the layered build (`styles.layer.css`) — this is the general recipe for making any drop-in component CSS lose gracefully to a utility framework.

## Recreate the essence without the dependency

For one static preview or a learning context, the whole pattern is ~60 lines of plain code — the library is justified when you need brand specs, masking, and the choreographed motion maintained for you:

```html
<div class="crd"><div class="crd__inner">
  <div class="crd__face crd__front"><span class="number"></span></div>
  <div class="crd__face crd__back"><span class="cvc"></span></div>
</div></div>
<input id="number"><input id="cvc" inputmode="numeric">
```

```js
const inner = document.querySelector('.crd__inner');
const fmt = (digits, gaps, len) => {           // e.g. gaps [4,8,12], len 16
  const s = digits.padEnd(len, '•');           // mask while typing
  return gaps.concat(len).map((g, i, a) =>
    s.slice(i ? a[i - 1] : 0, g)).join(' ');
};
document.querySelector('#number').addEventListener('input', (e) => {
  const d = e.target.value.replace(/\D/g, '');
  const brand = detect(d);                     // BIN prefixes → brand
  document.querySelector('.number').textContent = fmt(d, brand.gaps, brand.len);
});
const cvc = document.querySelector('#cvc');
cvc.addEventListener('focus', () => inner.classList.add('crd--flipped'));
cvc.addEventListener('blur',  () => inner.classList.remove('crd--flipped'));
```

Match the defaults if you hand-roll: 0.75s flip, `cubic-bezier(0.34, 1.3, 0.5, 1)`, 12° tilt cap, 430×270 ratio, `perspective: 1000px`. When installing is actually justified: real checkout forms (maintained BIN tables drift — elo/hipercard/unionpay ranges change), multi-framework codebases sharing one core, and Stripe composition where the focus-race handling is already solved.

## When to use

- Checkout/payment forms where a live preview increases trust and catches keying errors (wrong brand, transposed expiry).
- Wallets, billing dashboards, saved-card lists: `layout="display"` + `last4` + reveal-on-demand + `copyable`.
- Any React 18/19 codebase stranded on `react-credit-cards` (props `number/name/expiry/cvc/focused` are near drop-in; map `locale: { valid }` → `{ validThru }`, `preview`+`issuer` → `layout="display"`+`brand`+`last4`, SCSS vars → `--crd-*`).
- When you need the payment-card visual without shipping a framework dependency (vanilla `createCard`).

## When NOT to use

- Static marketing mockups — one decorative card does not justify a component; a styled `div` with the 430×270 ratio and a CC0 background suffices.
- Inside PCI-scoped flows where even the preview could leak: present `last4` only; never route real PANs through a preview's props.
- As the brand detector's source of truth for accepting payments — gate on your processor's validation, not `detectBrand`.
- `tilt` on anything the user taps as a control (touch flattens it anyway); tilt is decoration for a hovered, non-interactive showpiece.
- Don't confuse this with layout-card patterns (content cards, media cards) — it models a physical payment card, nothing else.

## How to apply

1. Keep state in your own inputs; render the card as a controlled mirror (`focused` = field name or null). Never let the preview own data.
2. Flip only on CVC focus; keep the default 0.75s spring (`cubic-bezier(0.34, 1.3, 0.5, 1)`) and the lift keyframe — the arc + shadow is what sells it; a bare rotateY reads cheap.
3. If you add tilt: cap at 12°, two transition speeds (400ms follow / 1000ms return, `cubic-bezier(0.22, 1, 0.36, 1)`), glare via `screen` blend, and gate on hover + fine pointer + no reduced-motion.
4. Reserve `layout="display"` + `last4` for owned cards; reveal only on explicit user action with values fetched on demand; add `copyable` + `onCopy` there.
5. Theme exclusively with `--crd-*` custom properties set on `.crd` or an ancestor; images go in `--crd-bg` with `variant="gradient"`, pre-cropped to 430×270, hosted locally (never hot-linked).
6. Pass licensed brand SVGs via `logos`; do not ship trademarked marks you have no license for.
7. Localize every label: `placeholders`, `locale.validThru`, `locale.exp`, `locale.copied`.
8. With iframe fields, translate brands (`brandFromStripe`), mirror focus, and clear focus conditionally to dodge the async race.
9. Ship the reduced-motion path: flip degrades to an instant swap, tilt/glare fully disabled.

## AI-slop warning

Two distinct card-slop failure modes. (1) **Category confusion / lazy cardification**: agents asked for "cards" sprinkle payment-card chrome (chip, bank dots, embossed numbers) on content cards, or wrap everything in bordered rounded rectangles — the layout-card is the most-abused primitive in AI output, and this library models *payment* cards only. A payment-card preview is justified exactly where a card number is being entered or displayed; anywhere else it is costume. (2) **Theatrical overuse**: the tilt-glare-flip stack became a checkout cliché — tilt on by default, flip on hover, glare on mobile. The library itself defaults `tilt: false` and disables motion on touch and under `prefers-reduced-motion`; copy that restraint. Also: never generate a "card number input" that stores the PAN in component state for convenience — that is a PCI violation the display-only design exists to prevent.

## Relations

- `transitions` — the easing vocabulary (spring overshoot, ease-out-expo `cubic-bezier(0.22, 1, 0.36, 1)`) crd-ui's flip and tilt timings are instances of; use it to tune durations coherently.
- `magic-ui` — the effect-component library tradition crd-ui belongs to; compare weight budgets and the "mechanism over dependency" rule.
- `corner-radii` — how to pick `--crd-radius` from a radius scale instead of a hardcoded 18px per card.
- `web-interface-guidelines` — the baseline this skill assumes for `prefers-reduced-motion`, focus visibility, and touch-vs-pointer gating.
- `component-gallery` — broader component inventory; this skill is the deep-dive on the payment-card primitive specifically.
