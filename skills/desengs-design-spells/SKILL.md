---
name: desengs-design-spells
description: Use when an interface needs a signature moment, delightful micro-interaction, or memorable detail. A catalog taxonomy of interface "spells" with the effect, the principle behind why each delights, and its plain CSS/JS implementation cost.
source: https://designspells.com
category: reference
---

# Design Spells (desengs) — a catalog of interface "spells" and how to cast them

Source: https://designspells.com — a public, free catalog by Chester How and Duncan Leo (newsletter also written with Rick Lee). What it is: a growing, numbered archive of "design details that feel like magic" — micro-interactions, easter eggs, and other "seemingly extra" details that "infuse life, personality, and fun back into the web," harvested from real shipped products (iOS, Vercel, ChatGPT, Threads, Twitter/X, GitHub, Instagram, Notion, Arc, and many indie apps). Began as the Twitter account @designspells_; expanded into the site plus a biweekly "Spells Digest" newsletter. No license stated; content is editorial inspiration, not code.

## What it is / Why it exists

A "spell" is one observed, named moment in a shipped product, recorded as: `Spell 077 · <App> · <plain-language title> · video · tags · related spells`. Titles are written as observable behavior, not features ("The airplane flies away when turning off Airplane Mode on iOS"). Numbering passed 330. The catalog is evidence, not theory — every entry cites a product you can check.

The site's taxonomy (its tag set, use these exact words when naming options):
- Device: `Mobile`, `Desktop`, `Tablet`
- Type: `Interaction`, `Animation`, `Transition`, `3D`, `Button`, `404`, `Easter egg`, `Confetti`, `Dynamic island`
- Quality: `Beautiful`, `Unique`, `Fun`, `Skeuomorphic`
- Context: `Occasion`, `Apple`, `Motion`

Why it exists: the web converged on sterile, "professional" UI. Design Spells argues the fix is small, craft-heavy moments that cost little but signal a human made this. The skill's job: when a UI needs a signature moment, pick a named spell family below, know why it delights, and cast it with the cheapest mechanism that survives performance and accessibility budgets.

## The core ideas — the spell families, why they work, how to cast them

Seven families cover the catalog. For each: effect, principle (why it delights), mechanism (plain CSS/JS), and cost.

### 1. Celebration feedback (`Confetti`, `Fun`)
Observed: custom confetti joining Family's waitlist; confetti when a post finishes editing on Bear Blog; confetti when the most important task completes on Todoist; interactive balloons on your Twitter profile birthday; hearts floating up when liking on Instagram; "crack open" gems on Opal.
- Principle: reward completion. Positive affect anchored to the exact frame an accomplishment lands; the celebration marks the moment as real. Works because it fires once, at success, not on every interaction.
- Mechanism: canvas particle burst, 60–150 particles, 900–1500ms, then remove the canvas. Gravity 900px/s², zero `pointer-events`, `aria-hidden="true"`.
```js
function burst(x, y, colors, n = 100) {
  const c = Object.assign(document.createElement('canvas'), { ariaHidden: true });
  c.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:9999';
  const dpr = Math.min(devicePixelRatio, 2); // cap DPR: 150 particles at 2x is plenty
  c.width = innerWidth * dpr; c.height = innerHeight * dpr;
  document.body.append(c);
  const ctx = c.getContext('2d'); ctx.scale(dpr, dpr);
  const ps = Array.from({ length: n }, () => ({
    x, y, vy: -(300 + Math.random() * 400), vx: (Math.random() - 0.5) * 500,
    r: 3 + Math.random() * 5, rot: Math.random() * Math.PI, vr: (Math.random() - .5) * 10,
    col: colors[(Math.random() * colors.length) | 0], born: performance.now()
  }));
  (function tick(t) {
    const dt = Math.min((t - (tick.prev || t)) / 1000, .033); tick.prev = t;
    ctx.clearRect(0, 0, c.width, c.height);
    const age = t - ps[0].born;
    for (const p of ps) { p.vy += 900 * dt; p.x += p.vx * dt; p.y += p.vy * dt; p.rot += p.vr * dt;
      ctx.save(); ctx.translate(p.x, p.y); ctx.rotate(p.rot); ctx.fillStyle = p.col;
      ctx.globalAlpha = Math.max(0, 1 - age / 1500); ctx.fillRect(-p.r, -p.r / 2, p.r * 2, p.r); ctx.restore(); }
    if (age < 1600) requestAnimationFrame(tick); else c.remove();
  })(performance.now());
}
```
- Cost: ~40 lines, zero dependencies. Gate on `matchMedia('(prefers-reduced-motion: reduce)')` — render a static checkmark instead. Brand the particles (shape, color palette) or it reads as generic.

### 2. Skeuomorphic micro-moments (`Skeuomorphic`, `Fun`)
Observed: the airplane flies away when toggling Airplane Mode off on iOS; flame hover effect on OpenAI's documentation; Mac OS-style window on mobile (Linvill); draggable 60s timer inside a radiant arc ((Not Boring) Timer).
- Principle: the metaphor is made literal. Icons usually *name* a metaphor; the spell *performs* it once. Delight comes from the pun — the interface understood its own iconography. Also teaches state change through physical intuition (an airplane leaving = disconnected).
- Mechanism: a one-shot CSS keyframe on the toggle's icon, translate + slight rotate + fade, 400–600ms, `cubic-bezier(0.22, 1, 0.36, 1)`:
```css
@keyframes fly-away { to { transform: translate(120%, -80%) rotate(-12deg); opacity: 0; } }
.toggle[aria-checked="false"] .icon-airplane { animation: fly-away 500ms cubic-bezier(0.22,1,0.36,1) forwards; }
```
- Cost: trivial. The expensive part is art: the metaphor must be *the app's own* (a flame on a docs site about "hot" content), or it becomes clip-art theater.

### 3. Living state (`Animation`, `Motion`, `Dynamic island`)
Observed: ChatGPT's voice orb; personalized skeleton loaders on Vercel; authentic loading progress in YouTube (bar reflects real buffering, not a fake loop); Dynamic Island translation animations; Siri's screen ripple; hourly weather scrubbed via a time slider ((Not Boring) Weather).
- Principle: the system appears alive and attentive. A loader that mirrors the real content shape says "I know what you're about to see"; an orb that breathes says "I am listening." Delight = perceived agency and honesty about state.
- Mechanism A — organic orb: 8-point blob keyframes (never a border-radius circle; the wobbling blob is what reads as "alive"), 4–8s loop:
```css
.orb { width: 120px; height: 120px; background: radial-gradient(circle at 30% 30%, #8ab4f8, #1a73e8);
  animation: blob 6s ease-in-out infinite; filter: blur(0.5px); }
@keyframes blob {
  0%,100% { border-radius: 42% 58% 61% 39% / 45% 42% 58% 55%; }
  33%     { border-radius: 58% 42% 39% 61% / 55% 61% 39% 45%; }
  66%     { border-radius: 45% 55% 58% 42% / 42% 55% 45% 58%; }
}
```
- Mechanism B — audio-reactive scale (Web Audio analyser feeding `transform: scale()`, never re-rendering the element):
```js
const an = audioCtx.createAnalyser(); an.fftSize = 256; mic.connect(an);
const data = new Uint8Array(an.frequencyBinCount);
(function loop() { an.getByteFrequencyData(data);
  const level = data.reduce((a, b) => a + b, 0) / data.length / 255;   // 0..1
  orb.style.transform = `scale(${1 + level * 0.35})`;                  // composited, cheap
  requestAnimationFrame(loop); })();
```
- Mechanism C — honest progress: drive the bar's width from `fetch` reader `loaded/content-length` (or socket bytes), not a timer. Fake progress that reaches 90% and stalls is the anti-spell.
- Cost: orb is pure CSS (~10 lines). Audio reactivity needs mic permission — only inside an active voice session. All loops: pause when `document.hidden`.

### 4. Continuity and memory
Observed: Hacker News stores where your cursor was positioned on last visit (item highlights persist); Apple's iPad "Look Back & Smile" recaps Live Photos around an event.
- Principle: the app remembers you. Orientation cost drops and the product feels personal — small persistence beats clever animation for perceived intelligence. The spell is "you were here; I kept your place."
- Mechanism: persist UI state, restore silently before paint:
```js
// save (debounced)
addEventListener('pointerdown', e => localStorage.setItem('ui:lastActive',
  JSON.stringify({ id: e.target.closest('[data-item]')?.dataset.item, t: Date.now() })), { passive: true });
// restore (before first paint)
const last = JSON.parse(localStorage.getItem('ui:lastActive') || 'null');
if (last && Date.now() - last.t < 7 * 864e5)     // expire after 7 days
  document.querySelector(`[data-item="${last.id}"]`)?.classList.add('was-last-active');
```
- Cost: ~15 lines. Rules: restore only within a freshness window (7 days above), never persist sensitive input, cap storage writes (debounce 500ms).

### 5. Easter eggs (`Easter egg`, `404`)
Observed: Among Us crewmate walking through the terminal on Vercel; Konami code on Vercel; the Rust site's 404 hosting Ferris the crab.
- Principle: reward for curiosity. Easter eggs create insiders and humanize the makers; 404s with character convert a dead-end (peak attention) into a brand moment. Crucially they are opt-in discoveries, never load-bearing UI.
- Mechanism: sequence detector for key combos; hidden guest in terminal output:
```js
const KONAMI = ['ArrowUp','ArrowUp','ArrowDown','ArrowDown','ArrowLeft','ArrowRight','ArrowLeft','ArrowRight','b','a'];
let i = 0;
addEventListener('keydown', e => {
  i = e.key === KONAMI[i] ? i + 1 : (e.key === KONAMI[0] ? 1 : 0);
  if (i === KONAMI.length) { castEgg(); i = 0; }
});
```
- Cost: ~10 lines plus the egg's art. Keep the real navigation/recovery action visually primary on 404s; the egg is garnish. Zero-productivity surfaces only (footers, empty states, consoles).

### 6. Occasion awareness (`Occasion`)
Observed: birthday balloons on Twitter profiles (also family 1); season- and event-tinted details across the catalog (the `Occasion` tag).
- Principle: software that knows what day it is feels present in the world, not abstracted from it. Once-a-year moments stay novel because exposure is self-limiting.
- Mechanism: date gate + opt-out:
```js
const m = new Date().getMonth(), d = new Date().getDate();
if (m === 9 && d === 31) document.documentElement.dataset.occasion = 'halloween';
if (user?.birthday === todayISO() && !prefs.noCelebrations) burst(x, y, palette, 80);
```
- Cost: trivial code, real editorial cost (art per occasion). Ship max 2–3 occasions/year; respect a "disable celebrations" preference and `prefers-reduced-motion`.

### 7. Playful input and branded controls (`Interaction`, `Button`)
Observed: GitHub's branded search-bar hover (monogram morphs into the command palette hint); Threads' pull-to-refresh animation; drag-to-dismiss minimized Notion Calendar; customizable wallet QR on Family.
- Principle: the interaction itself is the brand. High-frequency gestures (pull-to-refresh, hover, dismiss) carry identity better than any hero section because users touch them hundreds of times. Constraint: the playful skin must not change the gesture's physics or success rate.
- Mechanism: pointer-follow brand response, transform-only, 120–180ms, `ease-out`:
```js
el.addEventListener('pointermove', e => {
  const r = el.getBoundingClientRect();
  const dx = (e.clientX - r.left - r.width / 2) / r.width;   // -0.5..0.5
  el.style.setProperty('--tx', `${dx * 6}px`);               // max 6px shift: perceptible, not wobbly
});
```
```css
.brand-mark { transform: translate(var(--tx, 0), var(--ty, 0)); transition: transform 150ms cubic-bezier(0.22,1,0.36,1); }
```
- Cost: low. Guard: disable during keyboard navigation; keep hit areas unchanged (≥44px).

## When to use / When NOT to use

Use when:
- The core flow is done, tested, fast (LCP competitive, zero console errors) — spells are finish, never foundation.
- A moment deserves marking: success, first-run, milestone, birthday, 404.
- The product has a metaphor worth performing literally (family 2) or a high-frequency gesture worth branding (family 7).
- You can name the spell in one observable sentence, Design Spells-style. If you can't describe the behavior in plain language, it's decoration, not a spell.

Do NOT use when:
- The interface lies: fake progress bars, fake "typing" delays on instant results, skeletons that never match real layout. The catalog's lesson is the opposite — honesty is the delight.
- The moment sits between the user and their task on every visit (celebration on every save, orb on every hover). Spells fire at moments, not constantly.
- Accessibility would be traded: no motion honoring `prefers-reduced-motion`, focus order broken by canvas layers, or egg-only navigation.
- The budget is real: audio-reactive orbs need mic + rAF loops; 3D tags need GPU. A hover transform (family 7) delivers 80% of the delight at 1% of the cost.

## How to apply

1. Audit the flow for spell slots: success moments, loading waits, errors/404s, first-run, returns (family 4), high-frequency gestures. List them.
2. Pick ONE signature moment per surface. Design Spells entries are singular; a page with three spells has none.
3. Choose the family by slot: success→1, metaphor→2, waiting/voice→3, return visit→4, dead-end→5, calendar event→6, gesture→7.
4. Write the spell's plain-language title first ("The airplane flies away when…"). If the title is boring, the spell is.
5. Implement with the cheapest mechanism above; zero new dependencies unless a canvas confetti lib is genuinely justified (a hand-rolled burst is ~40 lines).
6. Enforce numbers: micro-interactions 120–180ms; entrances/exits 300–500ms; celebrations ≤1500ms; easing `cubic-bezier(0.22,1,0.36,1)` for exits, `ease-out` for entrances.
7. Gate every spell on `prefers-reduced-motion: reduce` with a static fallback (checkmark, plain skeleton, no balloons).
8. Keep spells off the critical path: `aria-hidden`, `pointer-events: none`, no layout shifts (animate `transform`/`opacity` only), cleanup after finish (remove canvases, cancel rAF on `visibilitychange`).
9. Ship behind a flag for one release; watch rage-clicks and task completion, not engagement. A spell that hurts task completion is removed, not iterated.

## AI-slop warning

The AI failure mode is confetti-everything: pasting celebration particles, gradient orbs, and blob loaders onto every surface until the product reads as a template. Design Spells entries delight because they are (a) rare — one per surface, (b) specific to the product's own metaphor and palette, and (c) mechanically honest. AI output violates all three: birthday balloons on a B2B audit dashboard, a breathing orb for a form, confetti on every save. Second failure: fake liveness — timed "loading" theater and skeleton shapes unrelated to the content that replaces them; users detect this within two visits and it converts delight into distrust. Third: ignoring the motion/a11y gate and shipping canvas overlays that trap screen-reader focus and burn mobile batteries. If you cannot say why THIS product earns THIS spell, cut it.

## Relations

- `desengs-devouring-details` — the craft philosophy behind spending disproportionate effort on tiny moments; pairs with this catalog's "seemingly extra" framing.
- `desengs-invisible-details` — the counterweight: details that work because nobody notices them; read before adding any visible spell, to keep the visible/invisible split deliberate.
- `desengs-thinking-orbs` — deep-dive on the thinking/voice orb pattern (family 3's star spell) with production-grade variants.
- `desengs-magic-ui` — installable implementations of several families (confetti, orbs); consult before hand-rolling when a library's bundle cost is acceptable.
- `desengs-transitions` — the easing/duration mechanics that families 2, 3, and 7 depend on; exact curves for entrance vs. exit vs. celebration.
