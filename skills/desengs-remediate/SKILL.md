---
name: desengs-remediate
description: Use when a React app needs user-initiated bug feedback with visuals — screenshots, screen recordings, voice notes, element pins — POSTed as FormData to your own endpoint, no SaaS in the middle.
source: https://www.remediate.ski
category: library
---

# Remediate (desengs) — one client component + one server helper for in-app screenshot/video/voice feedback, no SaaS

Source: https://www.remediate.ski (docs: /docs/install, /docs/payload, /docs/privacy, /docs/reference, /docs/faq) — by Parth Patel (withparth.com). Open-source React feedback widget, npm `remediate`, v0.1.9, MIT. Repo: github.com/fvckprth/remediate. Stated contract: "no accounts, no saas, no storage" — the deployer owns the endpoint, the storage, and the compliance duty.

## What it is / Why it exists

The gap: in-app feedback tools (screenshot widgets, session replay, bug report suites) are SaaS. Accounts, per-seat pricing, user data flowing to a third party, a dashboard you don't control. For a solo dev or small team the actual need is tiny: a floating button; the user captures what they see; the app POSTs it somewhere you own.

Remediate compresses that to "one component on the client, one helper on the server":

- Client: `<Remediate />` mounts a floating button; styles self-inject under a `[data-remediate-widget]` namespace. ~14kb gzipped core; video capture +8kb and voice +2kb, both lazy-loaded on first open; `"sideEffects": false`, tree-shakes. React 18+ (19 works), TypeScript types ship in the package.
- Server: `parseFeedback(req)` from `"remediate/server"` — accepts any web `Request` (Next.js App Router, Remix, Hono, Bun, Deno, Cloudflare Workers, edge); Express/pages-router via `parseFeedbackExpress`/`parseFeedbackPages` adapters.
- Transport: one multipart FormData POST to your `endpoint`. Nothing else phones home — no telemetry.

The only runtime dependency is `html-to-image` (screenshot rasterization). Everything else — `getDisplayMedia`, `getUserMedia`, `MediaRecorder`, `canvas.captureStream` — is platform API.

## The core ideas

### 1. Five capture modes, one submission envelope
Every submission has the same shape whether it lands in `onSubmit` or at your endpoint:

```ts
interface FeedbackSubmission {
  id: string;            // "fb_a1b2c3d4e5f6"
  url: string;           // page the user was on
  timestamp: string;     // ISO-8601
  environment: Environment; // userAgent, browser, os, viewport, screen, devicePixelRatio, language, timezone, colorScheme
  items: FeedbackItem[]; // mixed array, ordered as the user added them
  metadata: Record<string, unknown>; // the metadata prop, verbatim — "nothing's added or removed"
}
```

Item types (narrow on `item.type`; shared base carries `id`, 1-based `index`, `timestamp`, `additionalText`, `priority: "none"|"low"|"medium"|"high"|"urgent"`):

- `photo` — DOM-rasterized PNG of a selected region; `area: SelectionArea` in CSS pixels, viewport-relative. **No permission prompt.** Cross-origin images and iframes render blank.
- `video` — real screen recording via `getDisplayMedia`. Desktop only ("mobile safari has no api for this"), HTTPS required. Blob is WebM (Chrome/Firefox) or MP4 (Safari).
- `annotation` — pin on a DOM element. Captures `note`, `clickOffset`, and an `ElementCapture`: CSS `selector`, `elementPath`, `boundingRect`, `cssClasses`, `attributes`, a subset of `computedStyles`, and `nearbyText` (visible text within ~200px).
- `textNote` — `text`. "whatever the user types. nothing else."
- `voiceNote` — mic recording via `getUserMedia`; WebM audio; native permission prompt on first use; HTTPS required.

`environment` is sent on every submission — browser, OS, viewport, screen, DPR, language, timezone, colorScheme. This is the diagnostic core: a bug report that arrives with the exact viewport and color scheme needs no follow-up question.

### 2. The wire format: one JSON field + named blob parts
Blobs never ride inside the JSON. With `endpoint`, blobs are stripped from the envelope and uploaded as separate FormData parts with deterministic names:

- `metadata` — stringified JSON envelope (internal field name; `parseFeedback` hides it)
- `screenshot-{itemId}` / `recording-{itemId}` / `voice-{itemId}` — the binary parts

Server side:

```js
import { parseFeedback } from "remediate/server";

const { submission, files } = await parseFeedback(req);
// files is a Map<string, ParsedFile> — NOT an array. Keyed by FormData field name.
// ParsedFile: { blob: Blob, filename, type: "image/png"|"video/webm"|"audio/webm"..., itemId, category: "screenshot"|"recording"|"voice" }

for (const [name, file] of files) {
  urls[name] = await uploadSomewhere(file.filename, file.blob, file.type);
}
const photo = files.get(`screenshot-${itemId}`); // fetch the file for a specific item
```

`parseFeedback` throws on malformed multipart — wrap in try/catch. Item text lives per type: `textNote → item.text`, `annotation → item.note`, everything else → `item.additionalText`.

### 3. Signature technique — the freeze-scroll DOM screenshot
The hard problem: rasterizing a region of a scrolling, nested-scrollable DOM. `scrollTop` does not survive DOM cloning, so a naive clone renders scrolled containers at offset 0. Remediate's fix (verified in `src/utils/capture-screenshot.ts`):

1. Find the element under the capture area via `document.elementsFromPoint`, skipping widget nodes (the selector overlay covers the viewport — `elementFromPoint` would hit it).
2. **Freeze every scrolled ancestor**: set `el.scrollTop = 0` and apply `transform: translate(-scrollLeft, -scrollTop)` to its first child. The transform is baked into inline style, which cloning preserves; visually nothing moves. Wait one `requestAnimationFrame`.
3. Rasterize `document.documentElement` with `html-to-image` (`toBlob`), passing `width/height/canvasWidth/canvasHeight` = the selected area and a style `transform: translate(-(area.x + scrollX)px, -(area.y + scrollY)px)` on the clone — the crop happens by translating the cloned page, not by post-cropping.
4. `pixelRatio: window.devicePixelRatio` for retina fidelity. `filter` excludes nodes with `[data-remediate-widget]` so the widget never appears in its own screenshot.
5. Unfreeze (restore scroll positions and transforms) in `finally`.

The mechanism, no library (minimal SVG-foreignObject serializer — this is what html-to-image automates, and why cross-origin images taint/blank):

```js
function freezeScrolls(container) {
  const frozen = [];
  for (const el of container.querySelectorAll("*")) {
    if (el.scrollTop || el.scrollLeft) {
      const child = el.firstElementChild;
      if (child) child.style.transform =
        `translate(${-el.scrollLeft}px, ${-el.scrollTop}px) ` + child.style.transform;
      frozen.push({ el, top: el.scrollTop, left: el.scrollLeft, child });
      el.scrollTop = el.scrollLeft = 0;
    }
  }
  return frozen;
}

async function captureArea(area) {
  const frozen = freezeScrolls(document.documentElement);
  await new Promise(r => requestAnimationFrame(r));
  try {
    const clone = document.documentElement.cloneNode(true);
    clone.setAttribute("xmlns", "http://www.w3.org/1999/xhtml");
    const svg = `<foreignObject width="100%" height="100%">
      <div xmlns="http://www.w3.org/1999/xhtml" style="
        transform: translate(${-(area.x + scrollX)}px, ${-(area.y + scrollY)}px);
        transform-origin: top left;">${clone.outerHTML}</div></foreignObject>`;
    const img = new Image();
    img.src = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(
      `<svg xmlns="http://www.w3.org/2000/svg" width="${area.width}" height="${area.height}">${svg}</svg>`);
    await img.decode();
    const canvas = document.createElement("canvas");
    canvas.width = area.width * devicePixelRatio;
    canvas.height = area.height * devicePixelRatio;
    canvas.getContext("2d").drawImage(img, 0, 0, canvas.width, canvas.height);
    return await new Promise(res => canvas.toBlob(res, "image/png"));
  } finally {
    for (const f of frozen) { // restore
      f.el.scrollTop = f.top; f.el.scrollLeft = f.left;
      if (f.child) f.child.style.transform = f.child.style.transform.replace(/^translate\([^)]*\)\s?/, "");
    }
  }
}
```

This is why cross-origin images and iframes render blank: the clone inlines resources as data URLs, and un-CORS'd resources can't be fetched/inlined without tainting the canvas. Not a bug — the boundary of the technique.

### 4. Signature technique — canvas-cropped screen recording
Not `MediaRecorder` on the raw `getDisplayMedia` stream. A live crop pipeline (verified in `src/utils/capture-video.ts`):

```js
const displayStream = await navigator.mediaDevices.getDisplayMedia({
  video: { displaySurface: "browser" }, audio: true, preferCurrentTab: true, // Chrome 109+
});
const video = document.createElement("video");
video.srcObject = displayStream; video.muted = true; video.playsInline = true;
await video.play();
await new Promise(r => requestAnimationFrame(r)); // let videoWidth/Height populate

const scaleX = video.videoWidth / innerWidth, scaleY = video.videoHeight / innerHeight;
const canvas = document.createElement("canvas");
canvas.width = area.width * scaleX; canvas.height = area.height * scaleY;
const ctx = canvas.getContext("2d");
(function draw() { // rAF loop crops each frame to the user's selected rectangle
  ctx.drawImage(video, area.x * scaleX, area.y * scaleY, area.width * scaleX, area.height * scaleY,
                0, 0, canvas.width, canvas.height);
  if (!stopped) requestAnimationFrame(draw);
})();

const combined = new MediaStream([
  ...canvas.captureStream(30).getVideoTracks(),   // 30fps cropped canvas, not the tab
  ...displayStream.getAudioTracks(),              // tab audio preserved
]);
const recorder = new MediaRecorder(combined, { mimeType: getSupportedMimeType() });
recorder.start(100); // 100ms timeslice → incremental chunks
```

Three details worth stealing: (a) the user selects an area *before* recording, so the output is pre-cropped — no trimming UI needed; (b) the browser's "Stop sharing" badge fires the track's `ended` event — treat it as stop, or the widget hangs open; (c) strip codec parameters from the blob type: `mimeType.split(";")[0]` — `"video/webm;codecs=vp9,opus"` embeds a comma, and some storage backends (Convex) reject `Content-Type` values containing commas with a 400. Key file extensions off the MIME type: MP4 on Safari, WebM elsewhere.

### 5. Voice notes double as a waveform source
`getUserMedia({audio: true})` + `MediaRecorder`, plus an `AnalyserNode` (`fftSize: 64`) fed by the same stream: `getByteFrequencyData()` per frame drives a live waveform while recording. The analyser is non-critical — wrapped in try/catch with a simulated fallback. Pattern: one media stream, two consumers (recorder + visualizer), zero extra permission prompts.

### 6. Masking: one attribute, honored at three layers — and its hard limit
`data-remediate-mask` on any element:

1. Blacked out in screenshots **before** the bitmap is rendered.
2. Excluded from `nearbyText` walks during annotation capture.
3. Attributes redacted in `ElementCapture`.

The hard limit: **masking does not affect screen recordings.** A live video stream cannot be reliably masked per-element, so the docs' only safe answer is "don't enable video on screens with sensitive data." This is the single most important deployment decision: mask aggressively (account numbers, payment info, SSNs, government IDs, emails/phones in headers, chat/email content, internal IDs mapping to users — "anything you would not email to support"), and gate `captureTypes` per screen.

Deliberate stance: it is **not private-by-default** — the user clicked "report a bug," so they are consciously sending what they see. "you are the data controller for everything remediate produces."

What is never captured: network requests, console logs, cookies/localStorage/sessionStorage, canvas pixel data, cross-origin iframe/image contents, anything not on screen at capture time. Metadata is only what you pass — nothing implicit.

### 7. Egress-agnostic: recipes are the real API
`toMarkdown(submission, { fileUrls, environment = true, metadata = false })` formats a submission as structured markdown — items grouped by type (annotations → text notes → captures), numbered to match the widget, priority badges, environment line; `fileUrls` renders screenshots inline and recordings/voice as links. Nine documented backends: Discord webhook (10 files/message, 8MB each free-tier), Resend email, Slack (incoming webhooks cannot upload files — link blob URLs instead), GitHub Issues (upload to blob storage first, screenshots render inline), Linear (GraphQL `issueCreate`), Convex (three-step: generateUploadUrl → POST blob → insert mutation), Vercel Blob + DB, Postgres/Drizzle writing to disk, and a local-dev route that drops `.feedback/{id}/submission.json` + files.

Serverless limits that shape the design: Vercel function bodies cap at 4.5MB (a 30-second recording exceeds it) and timeouts at 10s Hobby / 60s Pro. Escapes: edge runtime, client-side blob upload (POST only the JSON envelope), or compressed recordings.

### 8. Component surface and embedding constraints
`<Remediate>` props (all optional; omit both `endpoint` and `onSubmit` and submissions go nowhere — a valid dry-run): `endpoint`, `onSubmit` (receives blobs inline; if both set, POST runs first and `onSubmit` fires only on success), `onError`, `metadata`, `headers` (object or function — function for refreshable auth tokens), `captureTypes` (limit modes per screen), `open`/`onOpenChange` (controlled), `debug`, `messages` (override every user-visible string — all i18n keys). `<RemediateTrigger asChild>` swaps the floating button for your own. Imperative: `remediate.open() / close() / submit()`.

Constraints that bite: single instance per app — mount once at the root ("don't" run two). Iframe embedding needs `allow="display-capture; microphone"` or video/voice silently fail. CSP requires `media-src 'self' blob:`, `img-src 'self' data: blob:`, `connect-src 'self' <endpoint-origin>`, and `worker-src 'self' blob:` when video is enabled. Style overrides via CSS custom properties on the namespace: `[data-remediate-widget] { --rmd-accent: #ff5722; }`. Keyboard accessible; focus traps inside the open widget.

## When to use / When NOT to use

Use when:
- React 18/19 app, you control a backend route (any web-`Request` runtime), and you want bug reports with visuals — screenshots, pins, recordings, voice — without a feedback SaaS.
- Beta/staging programs: gate the mount (`{user.isBetaTester && <Remediate endpoint="/api/feedback" metadata={{ userId, email }} />}`; staging-only via `NEXT_PUBLIC_ENV === "staging" && ...`).
- Internal QA → GitHub Issues recipe; indie projects → Discord/Slack/email recipes.
- Agents: the package ships an installable agent skill (`npx skills add fvckprth/remediate`, then `/remediate`) that detects framework/backend, scaffolds the route, wires auth (Clerk/NextAuth/Supabase), and can add integrations, gating, dashboards, and clean removal.

Do NOT use when:
- Not React. The capture mechanisms above are portable plain JS; the component is not — port the utils, skip the package.
- Screens where users handle PII you cannot mask — and specifically never enable `video` there; `nearbyText` also grabs "logged in as x@y.com" lines near a pinned element.
- Mobile-only audiences: no screen recording on mobile Safari (the video button hides itself); screenshot fidelity collapses on cross-origin-media-heavy layouts.
- You want passive analytics or session replay: this is user-initiated, one-shot, consent-shaped by design — a real video, not a DOM-mutation log, and there is no per-element masking inside it.
- Body-limited serverless without a plan: 4.5MB caps will 413 on any real recording unless you upload blobs client-side or run on edge.

Installing is justified when you want the whole widget (area selection, capture panel, focus trap, i18n, server parser) maintained upstream. Hand-roll when you need exactly one mode — the text note plus a screenshot is ~150 lines using the mechanisms above.

## How to apply (numbered checklist)

1. `npm install remediate`; mount `<Remediate />` once at the app root inside a client boundary (the package emits `'use client'` on entry points, so importing from a server component works in Next.js App Router).
2. Define `POST /api/feedback`; call `parseFeedback(req)` inside try/catch — it throws on malformed multipart.
3. Gate the mount by environment, role, or beta flag; pass `metadata={{ userId, email }}` so deletion requests are a query, not a forensic hunt.
4. Add `data-remediate-mask` to every PII surface (payments, IDs, chat content, profile emails); test masking in staging before production.
5. Restrict `captureTypes` per screen — at minimum, disable video wherever sensitive data renders.
6. Wire egress: upload each `files` entry to blob storage, build a `urls` map, format with `toMarkdown(submission, { fileUrls: urls })`, forward to your tracker. Mind Discord's 10-file/8MB caps and Slack's no-upload webhooks.
7. Serverless: budget 4.5MB bodies and 10s/60s timeouts — prefer edge runtime or client-side blob upload for recordings.
8. Cross-origin widget: return `Access-Control-Allow-Origin: <app-origin>`, `Access-Control-Allow-Methods: "POST, OPTIONS"`, `Access-Control-Allow-Headers: "Content-Type, Authorization"`, and handle OPTIONS.
9. Add a CSRF token via the `headers` prop and validate it server-side; rate-limit the endpoint — nothing in the widget prevents a malicious client from posting forever.
10. Set CSP (`media-src 'self' blob:`, `img-src 'self' data: blob:`, `connect-src`, `worker-src 'self' blob:` for video) and `allow="display-capture; microphone"` on any embedding iframe.
11. Key stored file extensions off the blob MIME type (MP4 on Safari, WebM elsewhere), and store `type` without codec parameters.
12. Show a consent notice on first widget open — the library renders none. Encrypt submissions at rest, set a 30/60/90-day retention window, scope access, log reads, and never forward raw payloads to third-party LLMs without explicit consent.

## AI-slop warning

- **Mount spam**: pasting `<Remediate />` into every page/route instead of once at the root breaks the single-instance assumption and double-mounts the floating button and listeners.
- **Ungated production drops**: shipping it app-wide with all capture types on day one — billing screens recorded, `nearbyText` harvesting profile emails — is the canonical misdeployment. Gate the mount, mask, restrict `captureTypes`; test masking in staging.
- **LLM forwarding**: piping `submission` straight into a triage prompt contradicts the privacy page ("summarize server-side first, or get explicit consent"). Sanitize server-side before any model sees a payload.
- **Reinventing half of it**: hand-rolling a textarea-plus-mailto "feedback" widget when the user's actual report needs a screenshot; conversely, pulling the whole package for a contact form that never needed visuals. Match mechanism to traffic: visuals earn their bytes the first time a bug report arrives with viewport, colorScheme, and a cropped recording attached.
- **Silent-failure blindness**: HTTPS, iframe `allow`, and CSP failures are all *silent* — the agent must verify video/voice in a real browser (or via `debug` prop logs), not assume green CI means working capture.
- **i18n overrides**: `messages` replaces strings the a11y layer also uses — replacing labels with emoji or marketing copy degrades screen-reader output; keep overrides functional.

## Relations

- **desengs-agentation** — same distribution bet pushed further: remediate ships as an agent-installable skill (`npx skills add`, `/remediate` lifecycle commands) rather than docs a human reads; compare how each source treats agents as the primary installer.
- **desengs-devouring-details** — the invisible craft this library embodies: scroll-freezing transforms that survive cloning, the comma-in-`Content-Type` header bug, `ended`-event handling for the browser's stop badge — details users never see and only notice when absent.
- **desengs-web-interface-guidelines** — the baseline (keyboard paths, focus management, consent affordances) any customized trigger or `messages` override must still meet; the widget ships a focus trap, so don't break it restyling the trigger.
- **desengs-shoogle** — inverted acquisition model: shoogle centralizes discovery of vendored components; remediate skips discovery entirely (one npm package, one purpose, self-hosted data) — use shoogle's answer when a generic component suffices, this when the requirement is a data-flow, not a component.
