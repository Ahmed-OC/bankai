# Mobile — patterns, flows & galleries

Pattern-level canon for mobile screens: the documented galleries of real app UI, plus named exemplar apps per flow, each described precisely enough to rebuild. ~35 real apps and case studies are named across onboarding, paywall, empty states, search, profile, dashboard/data-viz, gestures, dark mode, and input craft.

---

## Section A — THE GALLERIES

1. **Mobbin — https://mobbin.com** (freemium; paid ~$10/mo)
   The reference library: 621,500+ searchable screenshots of real iOS, Android and web apps, sliced by flow (onboarding, paywall, empty states, checkout, settings) and by UI element (keypads, cards, FABs, bottom sheets). Best for: "show me 50 real versions of X screen." Flow galleries are directly linkable, e.g. https://mobbin.com/explore/mobile/flows/onboarding (1,600+ onboarding screens).

2. **Page Flows — https://pageflows.com** (paid, ~$99/yr; 3-day $2.95 trial)
   Video-first: 4,000+ complete screen-recorded user flows from Airbnb, Uber, Netflix, Robinhood, Amazon — not static shots but the whole journey with annotations, organized by task (onboarding, upgrade, search, checkout, settings). Absorbed Screenlane (July 2024), so it now covers pattern screenshots too. Best for: understanding what happens *between* screens.

3. **Refero — https://refero.design** (free tier; Pro ~$10/mo)
   76,000+ web and 68,000+ iOS screens from shipped products, grouped into user flows, filterable by pattern (paywalls, onboarding, empty states), with AI search and an MCP server so coding agents can pull real screens as references. Best for: massive breadth + "search by similar."

4. **Adapty Paywall Library — https://adapty.io/paywall-library** (free)
   10,000+ real paywalls from live apps — Duolingo, ChatGPT, Bumble, Hinge, CapCut, Disney+, Telegram — across 25 App Store categories, sortable by estimated revenue. The single best source for paywall craft: you can literally study what the top-grossing apps ship.

5. **Pttrns — https://pttrns.com** (freemium)
   The oldest mobile pattern gallery: iOS and Android screens categorized by pattern type — logins, onboarding, activity feeds, camera, maps, empties. Curated, not exhaustive; best for fast, quality-filtered browsing of a single pattern.

6. **Screensdesign — https://screensdesign.com** (free)
   Recorded mobile screens organized per flow with analytical articles attached: empty states (14 examples + a "seven states to design for" taxonomy), checkout (10 examples), paywall design (16 examples, 2026). Best for: pattern taxonomies with named exemplars, not just images.

7. **Asian app galleries (WWIT et al.) — https://medium.com/design-bootcamp/3-mobbin-like-websites-for-mobile-app-design-inspiration-from-korea-japan-and-china-dce957916554** (free)
   Three Mobbin-like galleries covering Korean, Japanese and Chinese apps (WWIT indexes Korean apps by screen category). Essential counterweight to Western-only pattern study: super-apps, QR-first flows, sticker/emoji-dense messaging, and denser information design done well.

---

## Section B — PATTERN EXEMPLARS

#### Onboarding

### Duolingo — 24-screen commitment funnel — https://botsi.com/resources/flows/apps/introduce-new-duolingo
Platform: Both · Flow: onboarding
- **Mechanism**: The whole annotated funnel is 24 screens: language choice → reason-for-learning → daily-goal commitment → streak setup → optional placement test — all *before* account creation, so the app feels personalized and invested-in by the time it asks for email. The paywall appears mid-onboarding, not after download (also documented at https://screensdesign.com and in UXCam's onboarding roundup: https://uxcam.com/blog/10-apps-with-great-user-onboarding).
- **Steal for**: front-load personalization and commitment; delay signup until the user has invested 2+ minutes.

### Robinhood — animated line-drawing slides + viral waitlist — https://www.prefinery.com/blog/referral-programs/prelaunch-campaign/robinhood
Platform: iOS · Flow: onboarding
- **Mechanism**: Onboarding slides use stylized animated line-drawing graphics (documented: https://takuma-kakehi.medium.com/design-of-robinhood-bringing-stock-trading-to-youth-2e0d4c4db480) — brand-feel without screenshots. Pre-launch, a referral waitlist (skip ~1,000 places per friend) acquired 1M users before shipping. Post-signup, confetti celebrated the first trade — until Robinhood removed it in 2021 amid gamification criticism (https://www.bizjournals.com/sanjose/news/2021/03/31/robinhood-ditches-controversial-practice-as-it-pre.html): the canonical case of celebration micro-interactions crossing into manipulation.
- **Steal for**: make waiting states beautiful; and note where celebration becomes a dark pattern.

### LinkedIn — 4-stage progressive onboarding — https://www.smashingmagazine.com/2024/05/best-practices-mobile-onboarding/
Platform: Both · Flow: onboarding
- **Mechanism**: Minimal signup → empty dashboard → checklist of small tasks → "Here's how to get started" carousel, each stage earning the next disclosure. Nothing is asked upfront that isn't needed for the current screen; education arrives as context tours *after* first use, not as a wall.
- **Steal for**: progressive onboarding — ask permission and information in-context at first use, never as an upfront wall.

### SoundCloud — aha-first, tour-later — https://www.smashingmagazine.com/2024/05/best-practices-mobile-onboarding/
Platform: Both · Flow: onboarding
- **Mechanism**: You can skip sign-up entirely and land straight in the product; the intro tour is dismissible ghost screens (faded UI screenshots) with no blocking modals. The "aha" (playing music) happens in the first 10 seconds.
- **Steal for**: let users feel the value before demanding identity; tours should be skippable overlays, not gates.

### Tinder — contextual permission pop-ups — https://www.smashingmagazine.com/2024/05/best-practices-mobile-onboarding/
Platform: Both · Flow: onboarding
- **Mechanism**: Instead of a permission wall at launch, contextual pop-ups with FOMO framing appear exactly when you first touch the feature that needs them ("enable notifications so you never miss a match"). Each ask is tied to visible value.
- **Steal for**: ask for notifications/location at the moment of first relevant use, framed by what the user loses by declining.

### Wise — show-don't-tell calculator — https://www.smashingmagazine.com/2024/05/best-practices-mobile-onboarding/
Platform: Both · Flow: onboarding
- **Mechanism**: The currency-conversion calculator sits on the home screen *before* any signup, and shows the real exchange rate and fees for your amount up front. The product's core value prop is demonstrated, not described, pre-account.
- **Steal for**: put a working demo of the core value before the signup gate (same family: Binance lets you explore the app freely and only demands KYC when you act).

#### Paywall / subscription

### Duolingo — context-personalized paywall — https://adapty.io/paywall-library/duolingo
Platform: Both · Flow: paywall
- **Mechanism**: The first feature bullet on the paywall changes dynamically based on where the user entered from (teardown: uxdesign.cc, "How Duolingo pushes users from freemium to premium," 2023); plan cards use pre-selected annual defaulting, and the flow includes multiple soft-dismissal steps before a real exit (further dark-pattern analysis with real screenshots: https://toomanypaywalls.com/app/duolingo).
- **Steal for**: one paywall, N entry points — mirror the feature the user was just touching in the first line of copy.

### Speak4Me — "Duolingo-style" paywall A/B test — https://superwall.com/case-studies/speak4me
Platform: iOS · Flow: paywall
- **Mechanism**: A documented experiment: an illustrated, benefit-led, Duolingo-style paywall vs. a minimal checkbox-style paywall. The illustrative one converted +27% higher. Rare paywall case study with real numbers and both variants shown.
- **Steal for**: invest in illustration and benefit hierarchy on paywalls — measured lift, not taste.

### Brilliant — quiz-to-paywall funnel — https://www.purchasely.com/blog/education-app-paywalls
Platform: Both · Flow: paywall
- **Mechanism**: An interactive placement/interest quiz (perceived as product, not marketing) ends in a paywall whose plans are framed by the quiz answers. Purchasely's teardown covers 12 education paywalls — Brilliant, Duolingo, Babbel, Busuu, Blinkist, Quizlet — with 5 recurring design patterns.
- **Steal for**: let users complete a personalized quiz first, then sell the plan that quiz implies.

### Bumble / Hinge / CapCut — what top-grossers actually ship — https://adapty.io/paywall-library
Platform: Both · Flow: paywall
- **Mechanism**: The library's revenue-sorted view shows the working endgame: Hinge gates "standout" likes; Bumble upsells per-moment (see who liked you); CapCut gates exports and templates — usage-based gating where the paywall appears at the moment of maximum intent, priced with weekly/annual anchors.
- **Steal for**: put the paywall at the point of accomplished intent (finished edit, received like), not at app open.

### Paywall taxonomy: timing, trials, dismissal offers — https://screensdesign.com/articles/mobile-app-paywall-design-examples-2026
Platform: Both · Flow: paywall
- **Mechanism**: 16 recorded paywalls organized by the levers that matter: when the paywall fires, plan-selection layout, free-trial framing, pricing clarity, social proof, and dismissal offers (downsell shown when the user tries to leave).
- **Steal for**: design the "no" path — a dismissal downsell, not a dead exit.

#### Empty states

### ClickUp — Inbox Zero as a reward — https://screensdesign.com/articles/mobile-app-empty-state-examples
Platform: Both · Flow: empty-state
- **Mechanism**: Empty inbox renders as a playful "Inbox Zero" celebration state — the emptiness is framed as an achievement with a distinct visual, not a blank list.
- **Steal for**: completion empties deserve their own design; "nothing here" can mean "you won."

### HEY — denied permission is not a dead end — https://screensdesign.com/articles/mobile-app-empty-state-examples
Platform: iOS · Flow: empty-state / permissions
- **Mechanism**: When the user refuses notifications, HEY shows a locally-triggered screen (vibration + screen wake simulation) explaining what they'll miss and how to enable it — replacing the OS dead-end with a persuasion moment. Same article: Tiimo's day view shows a sun-graphic empty schedule with one suggested next action; Opal's "no distractions found" screen confirms the feature *worked* ("silence is golden"); Bookmory, Tally, AnyList, Canva and Paperless Post each use a different empty-state species.
- **Steal for**: script the denied-permission branch as its own designed screen. (Taxonomy of 7 states to design: first use, no content, no results, completion, permissions, offline, errors.)

### Opal — empty as success signal — https://screensdesign.com/articles/mobile-app-empty-state-examples
Platform: iOS · Flow: empty-state
- **Mechanism**: A screen-time app whose ideal state is zero data: the empty analytics view is copy-written to confirm the product's promise rather than apologize for missing content.
- **Steal for**: when emptiness is the product goal, say so — don't render a generic "no data" illustration.

### First-use empties that teach — https://www.pencilandpaper.io/articles/empty-states
Platform: Both · Flow: empty-state
- **Mechanism**: Pencil & Paper's reference set covers the four moves: teach the screen's purpose, show dummy/sample data so users understand what will live here, offer one primary CTA, and design the no-search-results state with corrective actions ("Reset filters", "Try broader keywords").
- **Steal for**: empty state = teaching moment + exactly one CTA; never a bare illustration.

#### Search

### Spotify — recent searches with artwork + filter chips — https://theuxologist.com/case-studies/finding-music-fast-with-spotifys-smart-search
Platform: Both · Flow: search
- **Mechanism**: Recent searches are rendered as cards with artwork, a content-type label, and an individual removal control (dismiss one query, not "clear all"); below, horizontally scrollable filter chips (Songs, Albums, Artists, Podcasts) refine results without leaving the flow. Search doubles as discovery: the tab surfaces browse categories when empty.
- **Steal for**: make recent searches first-class objects — image + type + per-item delete.

### Airbnb — Categories: browse replaces query — https://news.airbnb.com/the-airbnb-2022-summer-release-introducing-a-new-airbnb-for-a-new-world-of-travel
Platform: Both · Flow: search / discovery
- **Mechanism**: The 2022 Summer Release (biggest redesign in a decade) made search inspiration-first: ~56 curated Categories (Cabins, Pools, Tiny Homes) as horizontal shelves above the destination box, and the old standalone "I'm Flexible" mode merged into default search — users can browse without typing a destination or date.
- **Steal for**: when users don't know the query, sell categories, not a text box.

### Baymard autocomplete — 9 research-backed patterns — https://baymard.com/research-articles/autocomplete-design
Platform: Both · Flow: search
- **Mechanism**: Baymard's large-scale research defines the autocomplete spec: match and bold on query substrings, support keyboard/inline completion, show group headers, distinguish query suggestions from actual results (predictive search), and handle zero-match states. Their keyboard study (https://baymard.com/research-articles/mobile-touch-keyboards) adds: match the on-screen keyboard to the field or don't ship it.
- **Steal for**: autocomplete is a spec, not a style — bold the match, group the results, plan the miss.

#### Profile

### Instagram — social-signup profile prefill — https://www.smashingmagazine.com/2024/05/best-practices-mobile-onboarding/
Platform: Both · Flow: profile / signup
- **Mechanism**: Signing up with a social account pre-fills the profile (name, photo, follower graph), then the app immediately surfaces "people you know" as follow suggestions — the profile starts populated and socially reinforced instead of empty, with FOMO framing pushing completion.
- **Steal for**: never show a newborn profile; prefill or seed it, then surface one social hook.

### Personalization questionnaire as profile builder — https://botsi.com/resources/flows/apps/introduce-new-duolingo
Platform: Both · Flow: profile
- **Mechanism**: Duolingo and MyFitnessPal (https://www.smashingmagazine.com/2024/05/best-practices-mobile-onboarding/) build the profile *through* a goal questionnaire — answers become both the personalized home screen and the retention hook (streaks, calorie targets). The profile is accumulated behavior, not a form.
- **Steal for**: replace "edit profile" forms with questions whose answers visibly reshape the product.

#### Dashboard / data-viz on mobile

### Spotify Wrapped — data storytelling engine — https://newsroom.spotify.com/2024-12-04/the-art-and-science-behind-spotify-wrapped
Platform: Both · Flow: dashboard / data-storytelling
- **Mechanism**: Your yearly listening stats become a vertical, tappable story: one stat per full-screen card, giant typographic numbers, persona labels ("you're in the top 3% of X listeners"), every card pre-formatted for Stories sharing. Spotify's own newsroom documents the creative process; case-study analyses (https://storysoft.io/data-storytelling-spotify-wrapped) frame it as data storytelling at scale.
- **Steal for**: render analytics as a narrative deck of one-metric cards built for screenshots, not a dashboard grid.

### Monzo — Trends spending dashboard — https://community.monzo.com/t/give-me-financial-insights-analytics-comparisons/65485
Platform: Both · Flow: dashboard / data-viz
- **Mechanism**: Spending is auto-categorized (transport, groceries…) into a Spending Overview and Trends view — stacked bars over time with per-category drills, plus "Pots" as visual goal containers. The community thread above documents the feature being shaped by explicit user demand.
- **Steal for**: category-colored stacked bars + tap-to-drill is the mobile-native finance chart; skip legends, color = category.

### Revolut — spending / income / cashflow analytics — https://help.revolut.com/en-US/help/accounts/budget-and-analytics
Platform: Both · Flow: dashboard / data-viz
- **Mechanism**: Officially documented structure: separate spending, income and cashflow analytics screens, each with time-range switching and merchant-level breakdowns under summary charts — an entire analytics suite compressed into three swipeable mobile views.
- **Steal for**: split one scary dashboard into three focused screens (out, in, net) with a shared time control.

### Fitness dashboards — rings and goal gauges — https://www.fusioncharts.com/blog/10-inspiring-fitness-app-dashboards
Platform: Both · Flow: dashboard / data-viz
- **Mechanism**: Ten real fitness app dashboards analyzed for chart choice: progress rings (Apple's Activity rings pattern) for daily goals, sparklines for trends, streak counters as ambient motivation — dense personal data made glanceable at wrist-distance.
- **Steal for**: rings for "today vs goal," sparkline for "trend," number+streak for "keep going."

#### Gesture navigation

### Tweetie — pull-to-refresh — https://en.wikipedia.org/wiki/Pull-to-refresh
Platform: iOS (pattern now universal) · Flow: gesture
- **Mechanic**: Invented by Loren Brichter for Tweetie (2009) to reclaim screen space from a refresh button; the stretchy arrow became the industry's most-copied gesture (Figma's history: https://www.figma.com/blog/software-is-culture/pull-to-refresh). Brichter later voiced regret that it feeds refresh-loop addiction — a documented reminder that delightful gestures have behavioral costs.
- **Steal for**: gestures born from a real constraint (no space) survive; and audit the habit loop you create.

### Tinder — swipe as the whole interface — https://www.inc.com/quora/3-design-secrets-that-made-tinder-a-huge-success.html
Platform: Both · Flow: gesture
- **Mechanism**: Card stack with physics: drag right/left replaces all buttons; partial drags spring back; superimposed Like/Nope stamps fade in as the card tilts, teaching meaning through motion alone. The design goal was the fastest path from seeing a profile to matching (psychology teardown: https://medium.com/design-bootcamp/unraveling-the-psychology-behind-tinders-ui-ux-design-a-deep-dive-into-5-key-principles-946518faf948).
- **Steal for**: make the primary action a physical, gesture-driven verb with visible feed-forward while dragging.

### iOS edge-swipe back (system gesture) — https://medium.com/@lyubovkurach/9-mobile-navigation-patterns-usage-pros-cons-45ba10d6f59c
Platform: iOS · Flow: gesture / navigation
- **Mechanism**: Edge-swipe-back as a system-wide gesture with an interactive transition: the previous screen peeks and follows the finger, releasing to commit or cancel — hierarchy you can feel. The same survey covers its Android counterpart and bottom-tab conventions. (Contrast case: the all-gesture Clear app, dissected in https://medium.com/@kollinz/misused-mobile-ux-patterns-84d2b6930570 — gestures with no visible affordance fail discoverability.)
- **Steal for**: pair every custom gesture with a visible-control fallback; steal the interactive peek transition for any back/dismiss.

#### Dark mode excellence

### Twitter/X — "Lights out" true black vs "Dim" — https://medium.com/design-bootcamp/the-enigmatic-beauty-of-dark-mode-a-hex-code-analysis-of-spotify-twitter-and-facebooks-dark-56d9cff242ca
Platform: Both · Flow: dark-mode
- **Mechanism**: Ships two dark themes: "Dim" (dark gray #15202B) and "Lights out" (true #000 for OLED battery savings) — the rare major app offering a genuine black option. The hex-code analysis in the link decomposes the exact palettes of Spotify, Twitter and Facebook dark modes.
- **Steal for**: offer gray-black and true-black variants; users on OLED hardware know the difference.

### Spotify — dark as brand default + semantic tokens — https://developer.apple.com/design/human-interface-guidelines/dark-mode
Platform: Both · Flow: dark-mode
- **Mechanism**: Spotify ships dark-only, on a near-black gray (#121212-ish, not pure black) so album art and cover art stay the brightest objects on screen. The system-side craft is Apple's HIG model: semantic dynamic colors (systemBackground, secondaryLabel) and elevation-based darkening instead of hardcoded hex — implemented for real in RaiseMe's documented iOS migration (https://medium.com/buildingraiseme/dark-mode-design-principles-raiseme-ios-dark-mode-theme-e065fb850bde). Reality check: an ACM study of 120 popular apps found only 55% implement dark mode properly (https://dl.acm.org/doi/10.1145/3643539).
- **Steal for**: theme by semantic token, keep imagery the light source, and let surfaces darken by elevation.

### Telegram — user-themeable dark mode — https://t.me/s/abtheme
Platform: Both · Flow: dark-mode
- **Mechanism**: A full theming platform (accent color + wallpaper + chat-bubble palette) with a large community ecosystem of AMOLED-true-black themes — dark mode as a user-authored surface rather than two locked variants.
- **Steal for**: if your app is text-dense, expose theme controls; your users will build the AMOLED mode for you.

#### Keyboard / input craft

### Cash App — keypad-first amount entry — https://mobbin.com/explore/screens/3f874a49-8397-4250-a91c-cb6cb51a7886
Platform: Both · Flow: input
- **Mechanism**: The amount screen *is* a custom keypad: giant numeric pad, huge amount readout, decimal handled by the app — bypassing the OS keyboard entirely (which lacks a decimal on `type=tel`; the classic problem is documented at https://ux.stackexchange.com questions on mobile money input). Venmo uses the same pattern: the keypad is the primary interface, not a text field's accessory.
- **Steal for**: for money/quantity input, replace the OS keyboard with a purpose-built pad — fewer keys, bigger targets, no wrong characters possible.

### Stripe — camera card scan + autofill alignment — https://stripe.com/resources/more/credit-card-checkout-ui-design
Platform: Both · Flow: input / checkout
- **Mechanism**: Stripe's own checkout guidance: on mobile, support camera-based card scanning and structure fields to cooperate with OS autofill — field order matching the physical card, live card-type detection, formatting as typed (4-4-4-4), validation on the fly. NN/g's mobile checkout research (https://www.nngroup.com/articles/mobile-checkout-ux) backs the pattern set.
- **Steal for**: every character the user doesn't type is conversion; scan, autofill, and format-while-typing.

### Baymard / NN/g — the input research base — https://baymard.com/research-articles/mobile-touch-keyboards
Platform: Both · Flow: input
- **Mechanism**: Baymard's touch-keyboard research (implementations have improved only ~9% — most fields still summon the wrong keyboard) gives the field→keyboard rules; their inline-validation study (https://baymard.com/research-articles/inline-form-validation) plus NN/g error guidelines (https://www.nngroup.com/articles/errors-forms-design-guidelines) set the timing spec: validate ~500ms after typing stops (Venture Harbour: https://ventureharbour.com/form-design-best-practices), animate feedback in 200–300ms (UX Matters: https://uxmatters.com/mt/archives/2012/09/mobile-inline-form-validation.php), and validate on blur, never mid-keystroke. Smashing's field-type reference: https://www.smashingmagazine.com/2018/08/best-practices-for-mobile-form-design.
- **Steal for**: treat keyboard selection and validation timing as a measurable spec, with these exact numbers.

---

## Study these first

1. **Mobbin onboarding flow gallery** — https://mobbin.com/explore/mobile/flows/onboarding — 1,600+ real onboarding screens in one place; calibrate before designing anything.
2. **Adapty Paywall Library** — https://adapty.io/paywall-library — what the highest-grossing apps actually put on their paywalls, sortable by revenue.
3. **NN/g, Mobile-App Onboarding: Component Analysis** — https://www.nngroup.com/articles/mobile-app-onboarding — the research backbone for every onboarding pattern above.
4. **Page Flows, Robinhood recordings** — https://pageflows.com/ios/products/robinhood — watch a full great onboarding end-to-end instead of guessing from stills.
5. **Screensdesign, 14 empty state examples** — https://screensdesign.com/articles/mobile-app-empty-state-examples — the seven-states taxonomy with a named app per state.
