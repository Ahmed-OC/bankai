---
name: mobile
description: Use FIRST for any mobile app work (Expo, React Native, iOS, Android, app/APK builds) BEFORE applying the rest of the bankai canon. Translates every canon mechanism to its native equivalent (hover→press, focus-visible→a11y focus, IO→viewability, rAF→UI-thread worklets, prefers-reduced-motion→AccessibilityInfo, OKLCH→derived theme ramp), carries the platform laws (HIG + Material 3 exact numbers, edge-to-edge, predictive back, gestures, haptics taxonomy, 16.67ms frame budget, virtualized lists, OTA honesty) and the mechanical pass adapted to .tsx projects. On mobile targets, this skill's platform laws OVERRIDE web-specific wording elsewhere in the canon.
source: bankai research — Apple HIG, Material 3 (m3.material.io), developer.android.com, reactnative.dev/docs/performance, docs.expo.dev, github.com/expo/skills, github.com/software-mansion-labs/skills, github.com/callstackincubator/agent-skills, github.com/android/skills
category: bridge
---

# mobile — the bankai bridge for native apps (Expo / React Native / iOS / Android)

The canon's DOCTRINE applies unchanged: product modes (§1), dials, variance with intent, anti-convergence, domain-fit derivation, honesty (TRUE or LABELED), R8 unrequested depth, R9 interaction floor, the refonte hard rules, the signature law, the dynamism ladder, typography character, contrast floors, ship-the-annotation. What changes is the MECHANISM layer. **On a mobile target, this skill's translations and platform laws take precedence over web-specific wording anywhere else in the canon.**

## 1. Translation table — canon concept → native equivalent

| Canon (web wording) | Native equivalent |
|---|---|
| Touch targets ≥44px | **44×44pt hit region iOS / 48×48dp Android** (visual size may be smaller); `hitSlop` expands visual-only controls; ~12pt/4dp minimum spacing between adjacent targets |
| Hover states | Press/selected states — feedback is IMMEDIATE on Android (ripple) and in the **100-150ms** zone on iOS; never web-era 300ms delays |
| `:focus-visible` + keyboard walk | `accessibilityRole/label/state`, layout-order focus, and a real **screen-reader walkthrough** (VoiceOver/TalkBack) on one full flow |
| Escape closes overlays | Back gesture/button MUST dismiss — on Android via **predictive back** (`OnBackPressedCallback`, `android:enableOnBackInvokedCallback`; `onBackPressed()` overrides are deprecated). Blocking back = store-quality bug. iOS back-swipe fires from the leading edge (~20-44pt) — keep it draggable |
| `prefers-reduced-motion` | `AccessibilityInfo.isReduceMotionEnabled()` + `reduceMotionChanged` listener — collapse motion LIVE; iOS Reduce Motion → crossfade instead of translate/zoom |
| IntersectionObserver pause | `useIsFocused()`, `AppState`, `onViewableItemsChanged` — ambient loops pause off-screen AND in background |
| rAF bus | **Reanimated worklets on the UI thread**; the frame budget is **16.67ms**; zero JS-thread work per frame during gestures/scroll — `setState` in a gesture/scroll handler is the #1 jank cause in RN apps (use shared values + `useAnimatedStyle`) |
| CSS easings | iOS is **spring-first** (system default: response 0.55s, damping 1.0; interaction motion 100-500ms); Android is **token-first** (M3 emphasized `cubic-bezier(0.2,0,0,1)` family; durations 50-600ms tokens). The canon's house-curve ban applies wherever you declare beziers |
| OKLCH ramps | Unsupported in RN color strings — build the perceptual ramp offline, ship hex/rgba in the theme, **annotate smallest-text contrast ratios in the theme at authoring time**; use type-safe `Color` / semantic tokens that carry light+dark |
| Measure 45-75ch | Cap line length (~672pt readable guide on iPad); `allowFontScaling` NEVER disabled; layout survives **iOS Dynamic Type AX sizes (body → 53pt)** and **Android fontScale 200% (non-linear since 14)** — test both |
| Smart punctuation | Identical — same greps on .tsx |
| JS-gated visibility ban | n/a (native render) → replaced by **skeleton/placeholder honesty** (never blank frames that flash) |

## 2. iOS laws (HIG, exact)

- **Type ramp = system text styles, never arbitrary sizes** (default Large; body reaches 53pt at AX5 — layout must survive):

| Style | pt | Weight | Use |
|---|---|---|---|
| largeTitle | 34 | 400 | screen title, top of stack |
| title1 / title2 / title3 | 28 / 22 / 20 | 400 | page sections |
| headline | 17 | 600 semibold | row titles, emphasized body |
| body | 17 | 400 | DEFAULT body |
| callout | 16 | 400 | secondary emphasis |
| subheadline | 15 | 400 | row subtitles |
| footnote | 13 | 400 | captions, metadata |
| caption1 / caption2 | 12 / 11 | 400 | smallest labels |

Custom fonts must ride Dynamic Type (`UIFontMetrics`/relative) — a font that can't scale is the wrong font; with static bundled fonts set weight via fontFamily names and omit fontWeight.
- **Semantic colors** (`systemBackground`, `secondarySystemBackground`, `label`, `secondaryLabel`, `separator`) auto-adapt to dark mode and vibrancy; custom brand colors ship BOTH light+dark ≥4.5:1 (lightness-inversion derivation applies to customs only).
- **SF Symbols** (9 weights × 3 scales, optically aligned) — never hand-rolled icon SVGs; every iOS symbol needs a Material counterpart on Android (`expo-symbols`).
- **Tabs**: 2-5, icon + ALWAYS-visible label, bottom of screen; actions belong in a toolbar, never a tab bar. **Sheets** for short focused tasks; full-screen modal only for immersive work (video/photo/document); every modal has an obvious exit. **Alert** = unexpected critical info; **action sheet** = choices following an intentional action.
- **Haptics taxonomy — one semantic per event**: impact (light/medium/heavy/rigid/soft) for taps, `selectionAsync` for pickers/segments, notification (success/warning/error) for outcomes; **exactly one haptic per user action, in the same frame as the visual** — never on scroll, never on un-caused entrances.
- **Layout**: 16pt/side margins at compact width (20 regular); readable-content guide ~672pt; never occupy the system edges (top-left Notification Center, top-right Control Center, bottom home indicator — deferring them is a rare explicit opt-in). **Launch screen = static mirror of the first screen** — no logo, no branding, no progress; skeletons render once loaded. Pull-to-refresh only from the top of scrollable content.
- **Shadows**: `shadowColor/Offset/Opacity/Radius` (iOS) — or the CSS `boxShadow` prop on new RN; pair `borderCurve: 'continuous'` with every non-capsule radius; `contentInsetAdjustmentBehavior="automatic"` over manual SafeAreaView.
- Review rejects on: crashes at Dynamic Type AX sizes, broken iPad orientations, web-wrapper apps without native nav/gestures/share.

## 3. Android / Material 3 laws (exact)

- **Adaptive, not fixed**: window WIDTH buckets compact <600dp / medium 600-839 / expanded ≥840; recompute at runtime (rotation/fold); navigation follows the bucket: bottom bar (compact, 3-5 destinations, 80dp, always-visible labels, active pill 64×32dp) → rail (medium) → drawer (expanded). Never `isTablet`.
- **Edge-to-edge is enforced on Android 15 (SDK 35)**: draw behind status+nav bars, handle insets (`systemBars`, `displayCutout`, `systemGestures`); content obscured or fake letterbox bars = automatic fail.
- **M3 type scale** (sp only, never dp for text; never sp for padding; lineHeight in sp so it scales; fontScale 200% non-linear since Android 14):

| Style | sp / lh | Tracking | Weight |
|---|---|---|---|
| display L/M/S | 57/64 · 45/52 · 36/44 | −0.25 / 0 / 0 | 400 |
| headline L/M/S | 32/40 · 28/36 · 24/32 | 0 | 400 |
| title L/M/S | 22/28 · 16/24 · 14/20 | 0 / 0.15 / 0.1 | 400 / 500 / 500 |
| body L/M/S | 16/24 · 14/20 · 12/16 | 0.5 / 0.25 / 0.4 | 400 |
| label L/M/S | 14/20 · 12/16 · 11/16 | 0.1 / 0.5 / 0.5 | 500 |

**body large 16sp is the default.**
- **Dark theme elevation is COLOR, not shadow**: surface tint + container roles lift surfaces (legacy ladder: white 0/5/7/8/9/11% for elevation 0/1/3/6/8/12dp); nav bars carry no drop shadow.
- **Ripple is the pressed state**: bounded ripples for containers, unbounded for bare icons; a custom press flash reads instantly as non-native. Snackbar (NOT toast — custom toast views deprecated): max ONE action, text-label only, no auto-dismiss when an action exists, 4-10s without, swipe-dismissable.
- **Buttons by emphasis ladder** (filled > tonal > elevated > outlined > text); common buttons 40dp tall in 48dp targets; top app bar 64dp/Title Large; **FAB only for the single primary action** — a FAB competing with a filled button is a conflict.
- **Dynamic color (Material You) is the default on 12+** with a brand-seed scheme as fallback; error role colors (#B3261E/#F2B8B5), never hardcoded red.
- **Motion tokens**: durations short1-4 = 50/100/150/200ms (small components — enter ~50, exit ~200) · medium1-4 = 250/300/350/400ms (panel-size) · long1-4 = 450/500/550/600ms (full-screen — enter ~500, exit ~600) — **nothing interactive over 600ms**. Easing: emphasized `cubic-bezier(0.2,0,0,1)` default · emphasized-decelerate `(0.05,0.7,0.1,1)` enters · emphasized-accelerate `(0.3,0,0.8,0.15)` exits; standard set only for small utility transitions; linear only for continuous scrub. **Named patterns** (container transform, shared axis X/Y/Z, fade through, fade) instead of invented transitions. Overscroll = stretch on 12+ (glow is ≤11); gesture-exclusion rects capped at 200dp/edge.

## 4. React Native / Expo engineering laws

- **Release builds only for perf truth** (dev-mode JS perf is meaningless). Measure: Flashlight (JS-thread CPU/FPS/TTI, scripted via Maestro) + @shopify/react-native-performance marks; eslint `react-native/no-inline-styles` in CI.
- **Native stack always** (`@react-navigation/native-stack` / expo-router): screens are real native views, transitions run on the native thread for free; the JS stack only for custom card interpolators.
- **Animation**: Reanimated worklets are the default; legacy `Animated` needs `useNativeDriver: true` (transform/opacity ONLY — never layout); **`InteractionManager` is dead API** — defer with `requestIdleCallback`/`requestAnimationFrame`. In worklets-land `runOnUI` is renamed `scheduleOnUI`, `runOnJS` → `scheduleOnRN` (call only in `onEnd`/thresholds, never `onUpdate`).
- **Gestures**: `GestureDetector` (RNGH v2+) — **PanResponder is banned** (JS thread); `GestureHandlerRootView` is mandatory (topmost only); ScrollView/FlatList imported from RNGH; v2 gesture objects memoized.
- **Animate ONLY transform and opacity** (sole exception: absolutely-positioned childless elements like tab pills / progress fills); never animate images' width/height (animate scale), BlurView intensity, or elevation — crossfade instead; no zero-scale entrances (start 0.9-0.97 + opacity 0).
- **Frequency-gate motion**: interactions used 100+/day (tab switches, keyboard, scroll) get NO animation — tabs NEVER slide; reserve custom motion for low-frequency finger-driven moments. Springs parameterized by `{duration, dampingRatio}` (settle: 400/1.0; sheets: 300/0.8 + velocity; `overshootClamping` at hard edges); timed curves otherwise; **one haptic per action** (§2).
- **Lists**: unbounded → FlashList v2 / Legend List (recycling; v2 ignores `estimatedItemSize`) — `.map()` over data you don't control = automatic fail; FlatList tuning: `initialNumToRender` ≈ viewport (default 10), `windowSize` 21 default, `getItemLayout` for fixed rows; memoized rows + hoisted callbacks; bounded ≤10 items can use plain stacks.
- **No speculative optimization**: no memoization/atomic-state/compiler changes without a MEASURED problem; every perf change ships before/after numbers (FPS, TTI, bundle) or reverts.
- **Theme & structure**: ONE token system (`src/theme/`: colors/spacing/typography/radius/shadows/motion) — **adopt-before-build** (audit package.json for an existing system; it IS the source of truth); 4pt grid (4/8/16/24/32/48); three motion durations exactly (150/250/400ms); a literal appearing twice belongs in the theme. Platform differences via `.ios/.android/.native` files (extension-free import, props identical, default file ALWAYS present); only routes in `src/app`.
- **Images**: expo-image — BlurHash/ThumbHash `placeholder`, `transition` (skipOnCacheHit), `recyclingKey` in lists, `cachePolicy` for hot thumbnails.
- **Keyboard**: iOS `KeyboardAvoidingView behavior="padding"`; Android `softwareKeyboardLayoutMode: "resize"` in app config and NO double-avoidance (`behavior={Platform.OS==='ios'?'padding':undefined}`).
- **Release honesty**: EAS Update ships JS+assets ONLY (native change = store build); Apple 2.5.2 bans OTA that alters purpose/features — disclose OTA; develop on **expo-dev-client** once any native module/config plugin exists (Expo Go is prototype-only); strip `console.log` in production (a real JS-thread bottleneck); never disable Hermes.

## 5. Mechanism snippets (copy-paste, decision-bearing)

```js
// The threading law: shared values, never setState per frame
const x = useSharedValue(0);
const style = useAnimatedStyle(() => ({ transform: [{ translateX: x.value }] })); // UI thread
// hop back to React ONLY at gesture end / threshold:
useAnimatedReaction(() => x.value > SNAP, (over) => { if (over) scheduleOnRN(commit)(x.value); });

// Springs by duration+dampingRatio (never mass/stiffness/damping)
withSpring(x.value, { duration: 400, dampingRatio: 1 })            // settle
withSpring(x.value, { duration: 300, dampingRatio: 0.8, velocity })// sheet with carry
overshootClamping: true                                             // at hard edges

// Keyboard, the non-double-avoiding way
<KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
// + app.json (Android): "android": { "softwareKeyboardLayoutMode": "resize" }

// Android predictive back (replace every onBackPressed override)
const canGoBack = useCallback(() => stack.canPop(), [stack]);
<BackHandler>AddCallback enabled={canGoBack} onClicked={stack.pop} />; // or OnBackPressedCallback.kt

// Shadow split, encoded once in the theme
shadow: Platform.select({ ios: { shadowColor:'#000', shadowOpacity:.12, shadowRadius:10, shadowOffset:{width:0,height:4} }, android: { elevation: 6 } })
```

## 6. The mobile slop list — tells that mark an app as generated or non-native

1. Hamburger menu + custom web-style navbar fighting the platform's back gesture; tab slides.
2. No ripple / no press feedback on Android; 300ms web-era delays on iOS; hover-style ghost states.
3. Hardcoded white background ignoring OS dark mode; custom red instead of the error role.
4. Blank-then-flash screens (no skeletons); branded "splash" with a fake progress bar.
5. `.map()` over unbounded data; janky gestures (PanResponder / setState in handlers).
6. Gesture-only actions with no visible button path; blocked back on modals.
7. Haptic garnish on everything; more than one motion identity per screen.
8. Two competing token systems pasted together; literals duplicated across files.
9. Adaptive-blindness: fixed iPhone layout stretched on iPad/fold; content under system bars on Android 15.
10. Store/OTA claims the build doesn't honor.

## 7. The mechanical pass, mobile edition (no narrated PASS — command/line-cited)

- [ ] `grep -rnE "[A-Za-z]'[A-Za-z]" src/` → 0 in user-facing strings
- [ ] Hardcoded colors outside the theme → 0; every token used is defined; light+dark both ≥4.5:1 on smallest text (annotated in theme)
- [ ] Interactives ≥44pt/48dp hit region (hitSlop where visual is smaller); ~12pt/4dp inter-target spacing
- [ ] Reduce-motion handled AND live-updated (list screens); Dynamic Type AX + fontScale 200% + dark mode walkthroughs pass (or gaps listed)
- [ ] No JS-thread per-frame work: no setState in gesture/scroll handlers, no PanResponder, drivers are worklets/`useNativeDriver`; 16.67ms discipline cited
- [ ] Unbounded lists virtualized (name components); rows memoized, callbacks hoisted; `no-inline-styles` lint clean
- [ ] Back gesture tested on every overlay (predictive back on Android); screen-reader pass done on one full flow (name it)
- [ ] One haptic per action max; no fabricated liveness; OTA/store claims match behavior; launch screen static (no branding/progress)

## 8. Children routing for mobile

Web-specific children translate, not transfer: `cmdk` → native search/action-sheet patterns; `sonner` → **snackbar on Android** / native toasts never custom; `html-can-do-that`'s native-first check → **platform-API-first** (share, haptics, camera, filesystem via expo-modules — before JS reimplementations; `@expo/ui` for sheets/pickers/menus). Still read as-is: `domain-fit`, `spectacle` (Entice contexts), `micro-craft` (state layers = ripple/state-layer opacity math; elevation per §2-3), `dynamism` (ladder holds; mechanisms per §1 table), `web-haptics` (the synthesis basics), `loading-dev` (wait-length honesty), `oklch` (offline ramp math). For platform-native depth, the maintainers' skill repos (expo/skills, software-mansion-labs, android/skills) are the reference layer.

## 9. Refonte on mobile

The refonte hard rules apply verbatim — behavior diff is platform-agnostic. Identity anchors: the app's existing token system, type ramp, and motion language default KEEP (adopt-before-build — never introduce a second design system beside an existing one); a wholesale token swap is a rebrand decision, stated out loud.
