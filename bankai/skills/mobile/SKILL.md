---
name: mobile
description: Use FIRST for any mobile app work (Expo, React Native, iOS, Android, app/APK builds) BEFORE applying the rest of the bankai canon. Translates every canon mechanism to its native equivalent (hover→press, focus-visible→a11y focus, IO→viewability, rAF→UI-thread animation, prefers-reduced-motion→AccessibilityInfo, OKLCH→derived theme ramp), carries the platform laws (44pt/48dp targets, native navigation, gestures+haptics, safe areas, dynamic type, 60fps UI-thread, FlatList virtualization, OTA/app-store honesty), and adapts the mechanical pass greps to .tsx/.ts projects. On mobile targets, this skill's platform laws OVERRIDE web-specific wording elsewhere in the canon.
source: bankai research (platform conventions: Apple HIG, Material 3, Expo/React Native docs)
category: bridge
---

# mobile — the bankai bridge for native apps (Expo / React Native / iOS / Android)

The canon's DOCTRINE applies unchanged: product modes (§1), dials, variance with intent, anti-convergence, domain-fit derivation, honesty (TRUE or LABELED), R8 unrequested depth, R9 interaction floor (undo, honest states), the refonte hard rules (behavior diff, record truth, identity anchors, undo invariants), the signature law, dynamism ladder, typography character, contrast floors. What changes is the MECHANISM layer: everything the canon words in web terms (hover, focus-visible, IntersectionObserver, rAF, CSS easing, `prefers-reduced-motion`, OKLCH strings, greps on .html) has a native equivalent below. **On a mobile target, this skill's translations and platform laws take precedence over web-specific wording anywhere else in the canon.**

## 1. The translation table — canon concept → native equivalent

| Canon (web wording) | iOS | Android / React Native / Expo |
|---|---|---|
| Touch targets ≥44px | **44pt minimum** (HIG) | **48dp minimum** (Material); use `hitSlop` to expand visual-only controls |
| Hover states | none (pointer only on iPad) | `Pressable` pressed/selected states — press feedback is the hover equivalent, ≤100ms, never web-era 300ms delays |
| `:focus-visible` | keyboard/appearance focus, `accessibilityElements` order | `accessibilityRole/label/state`, focus order = layout order; screen-reader walkthrough replaces the keyboard walk |
| Escape closes overlays | back swipe / modal dismiss swipe | hardware/gesture back MUST dismiss; test it — blocking back is an app-store-quality bug |
| `prefers-reduced-motion` | Settings → Motion off | `AccessibilityInfo.isReduceMotionEnabled()` + `addEventListener('reduceMotionChanged')` — collapse motion live, not just at boot |
| IntersectionObserver pause | viewability / screen focus | `useIsFocused()`, `AppState` background/active, `FlatList onViewableItemsChanged` — ambient loops pause off-screen AND in background |
| rAF bus | UI-thread animation | `Reanimated`/`Animated` on the **UI thread**; JS-thread animation of transforms is a perf bug; `InteractionManager` for post-interaction work |
| CSS transitions/easings | `Animated.timing` + `Easing` | same easing FAMILIES as the canon (the house-curve ban applies to bezier values wherever you declare them) |
| OKLCH ramps | unsupported in RN color strings | build the perceptual ramp offline (OKLCH math in the theme file comments), ship hex/rgba, **annotate the smallest-text contrast ratios in the theme file at authoring time** (the same ship-the-annotation law) |
| Measure 45-75ch | line-length caps in px/% | `allowFontScaling` NEVER disabled; layout must survive Dynamic Type + largest sizes (test XXL) |
| Smart punctuation, quotes, em-dashes | identical (strings are strings) | identical — run the same greps on .tsx |
| JS-gated visibility ban | n/a (native render) | replaced by: **skeleton/placeholder honesty** — never render empty frames then flash content |
| Mechanical pass (§8 greps) | see §4 below | same discipline, adapted targets |

## 2. Platform laws (mobile floors and bans — these override web habits)

- **Respect the OS chrome**: native navigation (stack tabs, sheet presentations), native back behavior, native share/sheets. A web-style fixed navbar, hamburger menu fighting the back gesture, or custom modal that blocks back-swipe is the mobile equivalent of ban #1.
- **Gestures are the interface — with a fallback**: swipe actions, pull-to-refresh, bottom sheets with snap points, keyboard dismiss on scroll. But EVERY gesture has a visible non-gesture path (button, menu item, a11y action) — gesture-only is hover-only's mobile twin.
- **Haptics are feedback, not decoration** (`expo-haptics`): accompany state changes and confirmations, subtle by default, respect system settings — the R2 signature budget applies (one signature moment; haptic garnish on everything is slop).
- **Safe areas, keyboard avoidance, dark mode**: `useSafeAreaInsets`, `KeyboardAvoidingView`/root behavior; dark mode follows the OS by default, derived by the canon's lightness-inversion rule (§2), checked at the gate.
- **Performance floors (app-killers)**: 60fps interactions via UI-thread animation; `FlatList`/`FlashList` virtualization for any unbounded list (`.map()` over data you don't control = automatic fail); `expo-image` with caching; stable refs/memoization so state changes don't re-render screens; startup budget honest (splash reflects real loading, no fake progress).
- **Offline and release honesty**: network states surface honestly (retry, cache indicator); OTA updates (`eas update`) disclosed; store copy and screenshots make no claims the app doesn't do (fabricated-liveness law, app-store edition).
- **Testing reality**: test on BOTH platforms and at Dynamic Type XXL, in dark mode, with a screen reader (VoiceOver/TalkBack) — the mobile equivalent of the keyboard-only walk.

## 3. Mode mapping on mobile

The §1 mode table holds, with app context: **Operate** (tools, dashboards) — gesture-first, density high, zero theatrics. **Consume** — typographic, OS-typography-friendly. **Entice exists only in onboarding/paywall/store presence** — signature allowed but native-calm; an app that behaves like a landing page fails. **Play** — effects justified by the product. **Create** — canvas-first, generous space around it.

## 4. The mechanical pass, mobile edition (run on the project source — same no-narrated-PASS law)

- [ ] Punctuation: `grep -rnE "[A-Za-z]'[A-Za-z]" src/` → 0 in user-facing strings; smart quotes/dashes in copy.
- [ ] Theme discipline: hardcoded colors outside the theme file → 0 (`grep -rn "#[0-9a-fA-F]\{3,8\}" src/ | grep -v theme`); every token used is defined.
- [ ] Targets: interactive elements ≥44pt/48dp or hitSlop-expanded (inspect the Pressables/Touchables).
- [ ] Reduce-motion: handled via `AccessibilityInfo` AND live-updated; list the screens checked.
- [ ] No JS-thread animation of transforms (Animated/Reanimated drivers listed); unbounded lists virtualized (name the components).
- [ ] A11y: `accessibilityRole`+`label` on every interactive element; back gesture tested on overlays; screen-reader pass done on one full flow (name it).
- [ ] Honesty: no fake progress, no fabricated counters, OTA/store claims match behavior.
- [ ] Dark mode + Dynamic Type XXL walkthroughs pass (or the gaps are listed as known).

## 5. Children routing for mobile

The canon's web-specific children translate, not transfer: `cmdk` → native search/ActionSheet patterns; `sonner` → native toast library or OS-appropriate feedback; `html-can-do-that`'s native-first check becomes "platform-API-first" (share, haptics, camera, filesystem via expo-modules — before any JS reimplementation). Still read: `domain-fit`, `spectacle` (Entice contexts), `micro-craft` (state layers become opacity/elevation/scale press math — iOS elevation via shadow, Material via `elevation`), `dynamism` (the ladder holds; mechanisms per §1 table), `web-haptics`, `loading-dev` (wait-length honesty holds), `oklch` (for building the ramp offline).

## 6. Refonte on mobile

The refonte hard rules apply verbatim — behavior diff is platform-agnostic (state machines, caches, navigation flows). Identity anchors: the app's existing design tokens, type ramp, and motion language default KEEP. A redesign that swaps the app's token system wholesale is a rebrand decision, stated.
