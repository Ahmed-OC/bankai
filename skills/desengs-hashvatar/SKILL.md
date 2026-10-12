---
name: desengs-hashvatar
description: Use when UI must show avatars for identities that have no photo (wallets, API keys, anon users, tenants) and the image must be deterministic, client-side, and derived from a hash.
source: https://www.hashvatar.com/; https://github.com/medhychabour/hashvatar
category: library
---

# Hashvatar (desengs) — deterministic generated avatars

Source: https://www.hashvatar.com/ — Médhy Chabour (medhy.fr). A zero-dependency JS/React library (MIT) that renders deterministic avatars onto `<canvas>` from any string. The site is a playground + docs; the mechanics below are read from the MIT source (`src/hash.ts`, `color.ts`, `gradient.ts`, `dither.ts`).

## What it is / Why it exists

The identicon problem: in any multi-tenant product, most entities have no photo — anonymous commenters, API keys, wallets, bots, workspaces created 10 seconds ago, rows in an audit log. The options are a gray placeholder (dead UI), initials (fail for opaque IDs like `0x742…44e` or UUIDs), or an upload flow (friction, cold-start). A generated avatar removes all three: derive the image from a stable identity string through a hash, so the same input always produces the same image on every client, forever. **The string is the storage** — no server, no upload, no CDN, no migration.

Hashvatar's specific take vs classic identicons: not a mirrored pixel grid, but soft color compositions in two modes — `gradient` (6 blurred irregular polygons composited over a base fill) and `dither` (an 8×8 Bayer halftone across a rotated two-tone gradient). All colors are generated in OKLCH and are **monotone by default**: one hue per identity, only lightness/chroma vary.

API inventory: `createHashvatar(options) → { canvas, colors, destroy }`, `renderHashvatar(canvas, options)` (draw into an existing canvas), `hashToColors(hash, tones?, count?)` (colors only), `hashToSeeds(hash, count)` (raw [0,1) seeds for custom rendering), plus a React `<Hashvatar>` wrapper. Options: `hash`, `size` (default 64), `mode` (default `'gradient'`), `animated` (default false), `dotScale` (dither cell size, default `round(size/35)`), `tones` (palette constraint: hex / oklch / CSS names).

## The core ideas

1. **Determinism is the contract.** Never `Math.random()` for identity. Pipeline: normalize input → hash → seeded PRNG → every visual decision. Input is `trim().toLowerCase()`-ed before hashing, so `"Alice "` and `"alice"` yield the same avatar.
2. **FNV-1a 32-bit + Mulberry32.** A 6-line hash and a 6-line PRNG, identical on every JS engine, are enough. No crypto needed — this is identification, not authentication.
3. **Monotone color system in OKLCH.** One base hue (`seeds[0] × 360`); primary color L 0.55–0.77, C 0.18–0.36 with a hard clamp `C ≤ 0.37`; secondary (dark anchor) L 0.18–0.38, C 0.08–0.20. Result: each avatar is a coherent single-hue family instead of rainbow noise, and the chroma clamp prevents neon clipping when converting to sRGB.
4. **Tones constrain, never dictate.** Passing `tones: ["#ff6b6b"]` doesn't force that exact color: hue = tone.h ± 30°, primary L 0.52–0.74 with C ≥ 0.14. So a whole user base stays on-brand while remaining individually distinct.
5. **Gradient mode = blurred shape stack.** Base rect of color[0]; 6 seeded irregular hexagonal polygons (translate ±0.175×size, rotate ±0.6π rad, scale 0.85–1.35), each blurred `blur = max(2, round(size × 0.21))` on a padded offscreen canvas so blur doesn't clip, composited with cycling modes: source-over 0.9, overlay 0.48, soft-light 0.7, source-over 0.78, overlay 0.4, soft-light 0.6. Gradient mode uses 4 colors (1 base + 3 layers); dither uses 2.
6. **Dither mode = ordered halftone of a gradient.** Pick a rotation angle (`seeds[0] × 2π`) and transition width (`falloff = 0.55 + seed × 0.25`); per cell compute smoothstep of the projection onto the gradient axis; draw the light color where `t ≤ Bayer8[y%8][x%8]` (64 threshold levels). `dotScale` defaults to `round(size/35)` so pattern density stays constant at any size.
7. **Render sharp, crop with CSS.** Canvas is `size × min(devicePixelRatio, 3)` with CSS width/height pinned to `size`. Shape (circle, squircle, square, hexagon) is `border-radius` / `clip-path` on the outside — the renderer always draws a square.
8. **Animation is opt-in and deterministic.** `animated: false` by default. When on, every motion parameter (rotation speeds, per-cell drift phase/amplitude) comes from the same seeds, so the same hash plays the same animation. Respect `prefers-reduced-motion`; call `destroy()` on unmount (the React wrapper does).

## When to use / When NOT to use

Use generated avatars when:
- The identity is a long/opaque string (wallet, UUID, API key, anon handle) where initials are meaningless.
- You need thousands of distinct identities with zero upload friction (comment threads, member lists, tenant switchers, log viewers).
- Scanning benefit matters: humans re-recognize a color/pattern faster than a 0x address.

Prefer alternatives when:
- A real photo exists — always render it; generated is only the fallback tier (`photo → org logo → generated`).
- Enterprise/B2B dashboards, billing, audit, security UI — playful gradient blobs read unserious; use initials with a neutral background, or a strictly 2-tone monochrome identicon.
- Names are short and known (2-letter initials at ≥4.5:1 contrast are more sober and screen-reader-friendly).
- Consumer social products wanting character — full illustration sets (creature/build-a-face generators) fit better than abstract blobs.

Hard bans:
- Never rely on avatar color as the only differentiator (colorblind users; monotone hue is invisible to them) — always pair with the name/label text.
- Never hash a mutable display name; hash the stable ID, or the avatar silently changes when the user renames.
- Never animate avatars inside dense lists/tables — motion noise + battery cost. Animate only profile/hero moments.

## How to apply

1. Define the fallback chain once: uploaded photo → workspace logo → generated avatar from stable user/org ID.
2. Normalize the ID (`trim().toLowerCase()`) and hash the same field everywhere — frontend, email headers, exports.
3. Choose mode: `gradient` for soft/consumer surfaces, `dither` for technical/devtool surfaces (the halftone reads "engineered").
4. Constrain tones to 1–3 brand colors (hex or oklch strings); omit only if you deliberately want full-hue diversity across users.
5. Size: 64px default; 24–32px in comment threads, 32–40px in nav, 96–128px on profile. Render at `min(dpr, 3)`; for dither keep cells `≈ size/35`.
6. Shape via CSS (`border-radius: 50%`, `clip-path`), never inside the renderer.
7. Verify distinctiveness: render 10 consecutive real IDs at the smallest size you ship — if two are hard to tell apart at 24px, widen the L range (0.18–0.77) before touching C.
8. Cache: render once per ID to a canvas/data URL and reuse; re-rendering per frame wastes the determinism you paid for.
9. Ship `animated: false`; gate any animation on `prefers-reduced-motion: no-preference` and call `destroy()` on unmount.

## From scratch (no dependency)

The full pipeline in ~15 lines — this is the entire "hash → seed" layer:

```js
// FNV-1a 32-bit hash
function fnv1a(str) {
  let h = 0x811c9dc5;
  for (let i = 0; i < str.length; i++) { h ^= str.charCodeAt(i); h = Math.imul(h, 0x01000193); }
  return h >>> 0;
}
// Mulberry32 seeded PRNG — one hash → stream of [0,1)
function mulberry32(seed) {
  let s = seed;
  return () => {
    s |= 0; s = (s + 0x6d2b79f5) | 0;
    let t = Math.imul(s ^ (s >>> 15), 1 | s);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
// identity → seeds; normalize FIRST or "Alice" ≠ "alice "
const seeds = (id, n) => {
  const rng = mulberry32(fnv1a(String(id).trim().toLowerCase()));
  return Array.from({ length: n }, rng);
};
```

Classic mirrored-grid identicon as pure SVG (hash → hue → 5×5 grid, left 3 columns mirrored):

```js
function identiconSVG(id, size = 64) {
  const s = seeds(id, 16);                       // s[0] = hue, s[1..15] = cells
  const hue = Math.round(s[0] * 360);
  let cells = '';
  for (let y = 0; y < 5; y++) for (let x = 0; x < 3; x++)
    if (s[1 + y * 3 + x] > 0.5)
      cells += `<rect x="${x}" y="${y}" width="1" height="1"/><rect x="${4 - x}" y="${y}" width="1" height="1"/>`;
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5 5" width="${size}" height="${size}"
    shape-rendering="crispEdges" fill="oklch(0.6 0.18 ${hue})">
    <rect width="5" height="5" fill="oklch(0.95 0.01 ${hue})"/>${cells}</svg>`;
}
```

Hashvatar-style dither (two monotone OKLCH tones + rotated smoothstep gradient + Bayer threshold) on canvas:

```js
const BAYER4 = [[0,8,2,10],[12,4,14,6],[3,11,1,9],[15,7,13,5]].map(r => r.map(v => v / 16));
function ditherAvatar(id, size = 64) {
  const [hSeed, aSeed, fSeed] = seeds(id, 3);
  const hue = hSeed * 360, angle = aSeed * Math.PI * 2, falloff = 0.55 + fSeed * 0.25;
  const c = document.createElement('canvas'); c.width = c.height = size;
  const ctx = c.getContext('2d');
  const dot = Math.max(1, Math.round(size / 16)), n = Math.ceil(size / dot);
  const cos = Math.cos(angle), sin = Math.sin(angle);
  ctx.fillStyle = `oklch(0.25 0.10 ${hue})`; ctx.fillRect(0, 0, size, size);   // secondary
  ctx.fillStyle = `oklch(${(0.55 + fSeed * 0.2).toFixed(2)} 0.18 ${hue})`;    // primary
  for (let gy = 0; gy < n; gy++) for (let gx = 0; gx < n; gx++) {
    const proj = ((gx + 0.5) / n - 0.5) * cos + ((gy + 0.5) / n - 0.5) * sin;
    let t = Math.max(0, Math.min(1, (proj + falloff) / (falloff * 2)));
    t = t * t * (3 - 2 * t);                                                   // smoothstep
    if (t <= BAYER4[gy % 4][gx % 4]) ctx.fillRect(gx * dot, gy * dot, dot, dot);
  }
  return c;
}
```

Gradient-mode essence in SVG: base rect + 3–6 blurred polygons, `stdDeviation ≈ 0.21 × size`, shapes at ±0.35×size from center with `mix-blend-mode: overlay / soft-light` and opacities 0.4–0.9:

```html
<svg viewBox="0 0 64 64" width="64" height="64">
  <defs><filter id="b" x="-40%" y="-40%" width="180%" height="180%">
    <feGaussianBlur stdDeviation="13"/></filter></defs>
  <rect width="64" height="64" fill="oklch(0.25 0.1 250)"/>
  <g filter="url(#b)">
    <polygon points="54,32 48,12 24,14 12,33 24,50 46,50" fill="oklch(0.7 0.2 250)" opacity="0.9"/>
    <polygon points="14,20 50,18 52,40 32,56 12,44" fill="oklch(0.6 0.25 250)"
             opacity="0.48" style="mix-blend-mode:overlay"/>
    <polygon points="32,8 56,29 46,56 18,52 8,27 22,12" fill="oklch(0.8 0.15 250)"
             opacity="0.7" style="mix-blend-mode:soft-light"/>
  </g>
</svg>
```

**When installing is actually justified:** you want the polished animated gradient mode with its Safari/iOS fallback (Safari < 18 lacks `ctx.filter`; the library ships a 3-pass sliding-window box blur on `ImageData`, at half resolution when animated, to hold 60fps) and a maintained React wrapper with proper re-render/destroy handling. That is ~500 lines of edge-case code. If you need a static identicon or a simple dither, the ~40 lines above are enough — write them inline and skip the dependency.

## AI-slop warning

Gradient-blob avatars are the house style of Web3/crypto UIs since 2021 and now a default tell of AI-generated demos. Slop signatures: cute animated gradient blobs dropped onto enterprise dashboards, billing tables, and audit logs where they poison trust (use initials or 1-color identicons there); rainbow-unconstrained tones turning a member list into confetti (defeats the monotone-hue coherence that makes generated avatars legible); `animated: true` on every avatar in a dense list; and — worst — non-deterministic output because `Math.random()` crept in or the display name is hashed instead of the stable ID, so the avatar changes between visits and breaks the entire premise.

## Relations

- **desengs-oklch** — the color space behind the monotone system: hue-per-identity, L 0.18–0.77 ranges, the C ≤ 0.37 clamp, and why OKLCH keeps generated palettes perceptually even.
- **desengs-dither-kit** — dither mode is exactly an 8×8 Bayer ordered halftone; deeper pattern matrices and halftone aesthetics live there.
- **desengs-svg-guide** — the from-scratch identicon/gradient paths above as first-class SVG technique: crispEdges grids, filter regions, blend modes.
- **desengs-ui-playbook** — where avatars sit in real UI (list rows, nav, mention chips) and the sizing/label pairing rules that keep them legible.
- **desengs-dot-matrix** — the dot-grid aesthetic cousin of dither mode: cell sizing and rhythm at small sizes.
