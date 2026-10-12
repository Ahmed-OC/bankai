---
name: desengs-abtest-design
description: Use when deciding between two UI or flow variants (trial/paywall design, CTA style, icons, checkout steps, pricing display) and needing an evidence-backed default. Verdicts from 47 real app A/B tests.
source: https://abtest.design/
category: reference
---

# abtest.design (desengs) — A/B face-offs of interface details, with verdicts

Source: https://abtest.design/ — curated gallery of 47 real-world A/B test results from best-in-class apps (Duolingo, Headspace, GitHub, Uber, TikTok, Runtastic, Mobbin itself). Powered by Mobbin; test submissions go through Mobbin's Notion. No license stated. Entry format: company → pattern tag → what was tested (control vs variant) → Results (exact metric) → Source link → "Also seen on" (other apps already shipping the winning pattern).

## What it is / Why it exists

Not a "guess the better design" quiz — a corpus of shipped experiments with outcome numbers. It exists because micro-design arguments (badge vs no badge, heart vs thumbs-up, one screen vs three) are settled by data more reliably than by taste, and the same winning patterns recur across apps. The gallery is biased toward monetization surfaces: paywalls, trials, checkout, onboarding — where apps actually run tests. Use it as a priors table: when you must pick between two variants and cannot test, pick the side that won in a comparable context.

The site's own taxonomy (use these names): **Paywall & free trial** (17 tests), **Onboarding** (9), **Checkout & sales** (10), **User engagement & retention** (4), **Monetization awareness** (2), **Referral** (2), **Misc** (5).

## The core ideas

### 1. Verdicts — paywall, trial, and pricing display

| Choice you face | Winner | Why | Evidence |
|---|---|---|---|
| Hide paid features vs mark them with a "PRO" badge | Badge | Visible free/paid boundary avoids surprise-paywall rage; badge sells the upgrade before the wall | Mobbin +35% free→paid, no other change |
| Generic promo copy vs real user review + 5 stars on paywall | Review | Social proof at the decision point beats self-praise | Runtastic +44% paid subs |
| Benefits list vs emotional/identity appeal ("support our work") | Emotional | Belonging converts where feature parity doesn't | Neos Kosmos +16% |
| Neutral stock visual vs mission-relevant visual on paywall | Mission image | Congruence with why users are there | Neos Kosmos +13% |
| Hard paywall vs soft (10s free preview, then "Enjoying? Continue") | Soft | Sunk cost + demonstrated value before the ask | PepTalk: B overtook A significantly |
| Full paywall screen vs inline "payramp" (one-touch trial start) | Payramp | Fewer screens to trial; "Redeem your free 2 weeks" frames trial as gain, not commitment | Slopes +25% trial starts |
| "Sign up for free" vs "Trial for free" CTA | "Trial for free" | Names the actual offer; primes premium value | Going +104% trial starts MoM |
| Show full course/product price vs per-month price | Per-month | Smaller anchor, matches mental budgeting | Unacademy +13.5% CTR |
| Price range ($14–$20) vs single estimate | Single | Users anchor on the high end of ranges and hesitate | Uber: double-digit rides/user lift |
| Equal tiers vs high contrast between tiers (more features highlighted, valued features emphasized, dead tier removed) | Contrast | Comparison must be legible at a glance | GitHub +20% free AND paid signups |
| Trial on all plans vs trial only on annual | Annual-only trial | Trial makes the attached plan feel like the "safe" choice | Moonly +39% view→sub, +47% rev/100 installs |
| Same trial length everywhere vs 7-day monthly / 14-day annual | Split lengths | Longer trial is a discount that steers to annual | Headspace double-digit lift |
| Both plans upfront vs yearly-only (monthly behind "View All Plans") | Yearly-only | Default = the decision | Mojo +15–20% yearly share |
| No trial reminder vs email 3 days before charge | Reminder | Transparency about the coming charge increases, not decreases, sales | Shaw Academy +14% sales, no cancellation spike |
| Vague "7-day trial" vs step-by-step trial timeline (reminders day 5, charge day 7) | Timeline | Removing cancel-fear removes signup-fear | Blinkist +23% signups, complaints −55%, push opt-in 6%→74% |
| No card required vs credit-card-required trial | Card required (B2B/SaaS only) | Friction filters out uncommitted signups | Outseta 35% vs 7.25% (4–5x) |
| Monthly vs weekly vs weekly-with-trial | Trial+weekly | Trial de-risks; weekly lowers anchor | pdf scanner: 2.29% vs 1.63% vs 1.21% |

### 2. Verdicts — onboarding and checkout flow

| Choice you face | Winner | Why | Evidence |
|---|---|---|---|
| One form screen vs one field per screen (3 screens: name, email, phone) | One field per screen | Cognitive load per screen beats click count | Houzz +15% despite more clicks |
| Choose/transfer number upfront vs pre-assigned number with change option | Pre-assign | Sensible default; let users accept, not compose | Virgin Mobile UAE +9% progression, drop-off −18% |
| Mandatory account creation at checkout vs name+email only (password via reset link) | No account step | Account creation is a surcharge on checkout | HotelTonight +15% |
| Pop-ups + banners guiding first session vs single 5-step checklist | Checklist | One visible path replaces competing interruptions | Mural +10% 1-week retention |
| Pick one goal vs pick multiple goals in onboarding | Multi-select | Users have compound intent; multi-capture personalizes better | Headspace +10% trial conversion |
| KYC/bank details before value vs after (earn first, link later) | After | High-commitment steps must follow demonstrated value | TikTok +25% creator enrollment |
| Signup wall first vs 3 pages of content before signup prompt | Content first | Value preview lowers the wall | Pinterest +15–20% signups |
| Generic landing for paid traffic vs dedicated single-intent page (no header, no nav) | Dedicated | Match page to ad intent; remove exits | Houzz +5% trial starts |
| Questionnaire → generic plans vs recommended plan from answers | Personalized | Effort invested maps to a tailored answer | Grammarly +10–20% upgrades |
| Neutral tone vs conversational/brand voice in funnel steps | Conversational | Voice is a conversion surface, not decoration | Dollar Shave Club +5.24% |

### 3. Verdicts — engagement, referral, and micro-details

| Choice you face | Winner | Why | Evidence |
|---|---|---|---|
| Streak tied to daily goal vs streak preserved by any 1 lesson | Decoupled | Make preservation cheap; ambitious goals stop punishing casual days | Duolingo +40% learners on 7+ day streak |
| Black-box referral vs real-time view of friend's signup progress | Real-time | Visible progress = motivation; opaque = friction | SoFi 20x referrals (2%→40% of signups in 3 months) |
| Standard-length referral trial vs doubled (30-day guest pass) | Doubled | Referral + extended trial compound trust | Headspace +7% signups, +8% revenue |
| Total portfolio value vs per-investment amounts shown | Breakdown | Granular numbers make progress tangible | Stash +12% kept auto-saving 8 months later |
| Heart/X vs thumbs-up/thumbs-down for like buttons | Thumbs | Recognition beats emotional symbolism; team's heart hypothesis was wrong | Paktor: likes +6%, dislikes +4.3%, repeat usage +2.3% |
| CTA matching existing UI components vs thin-bordered distinct CTA | Distinct border | Contrast/isolation drives discovery; "consistency" variant came last | Unacademy: 13k vs 9k (control) vs 7k (matching) clicks |
| Hidden free-delivery policy vs badge on product page | Surface it | Invisible benefits convert nobody | Clarks +2.6% |
| Buried returns policy vs prominent easy-returns messaging | Surface it | Answer the buyer's silent objection at the decision point | T.M. Lewin +50% conversion, +7% monthly sales |
| No price reassurance vs best-price-guarantee widget with explanation | Guarantee | Kills the "search elsewhere" exit | Buyagift +9.6% |
| Plain product page vs concise benefit-focused copy at top | Benefit copy | Lead with value, not specs | Goldelucks orders +31.56%, order revenue +66.2% |
| Brand-story panel absent vs present (craft/sustainability) | Present | Story converts a subset deeply | Beckett Simonon +5% sales, 237% annualized ROI |
| Static reminder to abandoned carts vs 15% discount + countdown timer | Urgency | FOMO re-engages the already-interested | Kiss My Keto +15.05% |
| Trial message alone vs "Free during the month" + "Save 60%" badge | Both | Name the free term AND the discount anchor | TIPSTOP +190% |
| One-shot upsell screen vs projected lifetime cost of the problem ("years on your phone") | Lifetime projection | Big number creates a motivation spike (gym-membership effect) | Opal 7%→17% trial conversion over iterations |

### 4. The five mechanisms that explain nearly every verdict

Name the mechanism before shipping the pattern — it tells you when the pattern transfers:

1. **Pre-awareness beats surprise.** Every "surface it" win (pro badge, returns policy, free delivery, trial timeline, reminder email) works by telling the user the cost/limit before they commit. The unit of design is the expectation, not the element. If a badge/review/policy line doesn't change what the user expects before tapping, it won't move the metric.
2. **Demonstrated value before commitment.** Soft paywall (10s preview), payramp (one-touch start), Pinterest (3 pages free), TikTok (earn before KYC), HotelTonight (buy before account). Order the flow so the ask always follows a taste of payoff; never interleave a commitment step before the value step it protects.
3. **Reframing the number.** Per-month over total (Unacademy), single estimate over range (Uber), lifetime projection over session cost (Opal), "Save 60%" badge (TIPSTOP), "Redeem" over "Start" (Slopes). Same price, different anchor. When displaying any cost, ask which framing makes the affordable reading the default reading.
4. **Defaults and exclusivity steer.** Trial attached only to annual (Moonly), yearly-only screen (Mojo), pre-assigned number (Virgin Mobile). Users accept composed defaults far more often than they choose. Whatever option carries the trial, the pre-selection, or the sole visibility wins the mix shift.
5. **Social proof at the decision point.** Review on paywall (Runtastic), mission-congruent visual (Neos Kosmos), story panel (Beckett Simonon), friends' progress (SoFi). Placement is the pattern, not the asset: the same review in a footer does nothing; on the paywall it is +44%.

### 5. Where the data contradicts the obvious rule

- **"Simplify always" is false.** Instapage stripped "unnecessary" detail from pricing to reduce cognitive load and LOST: original 3.67% vs simplified 3.44%. Comparison information is fuel, not clutter. Strip decoration, keep decision data.
- **Designer intuition about iconography is unreliable.** Paktor's team shipped heart/X expecting it to win; thumbs won by 6%. Don't argue metaphors — when stakes are real, test.
- **Consistency with the design system can lose to contrast.** Unacademy's variant B (matched existing components) underperformed even the control (7k vs 9k); the off-system thin-bordered button nearly doubled it (13k).
- **Friction is context-dependent.** The same friction that kills B2C checkout (Houzz, HotelTonight) multiplied B2B conversion 4–5x at Outseta. Filter before the wall only when the product needs committed users.
- **Transparency about costs raises revenue.** Reminder-before-charge (+14%), full trial timeline (+23%), single honest price estimate — fear removal outperformed information hiding in every instance in this corpus.

## When to use / When NOT to use

Use when:
- Choosing between two concrete variants of a trial, paywall, pricing display, CTA, form split, badge, or icon and there is no time/traffic to test.
- Reviewing a monetization or onboarding flow and needing a checklist of known-good patterns ("Also seen on" validates cross-app).
- Deciding what to A/B test first — pick the choices below where evidence says the gap is large (trial exclusivity, paywall copy type, CTA wording).

Do NOT use when:
- The decision is perceptual craft with no behavioral measure (spacing rhythm, typography, easing) — no verdicts here for that; use taste/laws siblings.
- Your context inverts: urgency countdowns were tested on cart abandoners only; dark-pattern replication (countdowns everywhere, forced trials) is not endorsed by the corpus and erodes trust metrics the tests didn't measure.
- The metric in the table doesn't match yours: these optimize conversion/revenue/retention, not accessibility, performance, or brand health.

## How to apply (numbered checklist)

1. State the choice as two variants (A/B) with one metric. If you can't name the metric, this corpus can't help.
2. Find the closest row above; adopt the winner and its mechanism, not just its skin (a badge without an honest free/paid boundary is decoration).
3. Encode the mechanism minimally. Pro badge — a persistent, non-modal marker, not an interstitial:
   ```html
   <button class="feature">
     Export to PDF
     <span class="pro-badge" aria-label="Paid feature">PRO</span>
   </button>
   ```
   ```css
   .pro-badge { font-size: 10px; font-weight: 700; letter-spacing: .04em;
     color: #9a7200; background: #ffd60a; border-radius: 4px; padding: 1px 5px; }
   /* Persistent marker, never hidden until tap — the verdict is about pre-awareness, not the badge shape. */
   ```
4. For trial/paywall copy: name what is free, when it ends, and what it costs — in that order ("Free during the month", "reminders Day 5, charged Day 7", "Trial for free").
5. For flows: move commitment (accounts, KYC, choices with defaults) after demonstrated value; split forms by field, not by section. One field per screen with visible progress and a single primary action:
   ```html
   <form> <!-- step 2 of 3: email only -->
     <label for="email">Email</label>
     <input id="email" type="email" autocomplete="email" autofocus>
     <button type="submit">Continue</button>
   </form>
   <!-- Houzz verdict: 3 single-field screens beat 1 three-field screen by 15%.
        The mechanism is per-screen cognitive load — do NOT collapse to one screen to "save clicks". -->
   ```
6. For defaults: pre-select the plan/option you want chosen (yearly, pre-assigned number) and keep the alternative one link away.
7. For urgency: restrict countdowns/timers to re-engagement contexts (abandoned cart, expiring trial reminder at D-3); never on first exposure.
8. When you CAN test: split evenly, run to significance (Shaw Academy reported >99%; Unacademy reported raw click counts — prefer the former), and pre-register your hypothesis so a Paktor-style inversion is legible.
9. Record the losing variant and the metric in your own notes; a verdict without its number is an opinion.

## AI-slop warning

- **Winner bias.** The gallery publishes successes; nobody submits the badge that did nothing. Treat every number as an upper bound on effect, not an expectation.
- **Metric laundering.** "+143%"-style lifts (Opal) came from iteration sequences, not one diff. Never present a single change as the cause when the source describes iterations.
- **Context transplant.** Applying Outseta's card-required verdict to a consumer app, or Kiss My Keto's countdown to a non-abandoned visitor, is the standard AI misuse — the mechanism (filtering, urgency) only fires in its original condition.
- **Simplify-everything reflex.** AI defaults to removing elements; the Instapage loss shows removing decision-relevant information reduces conversion. Removing is a hypothesis, not a hygiene rule.
- **Pattern skinning.** Copying the badge/review/countdown visuals without the transparency mechanism underneath produces dark-pattern-flavored slop that the corpus explicitly argues against (Blinkist, Shaw Academy: honesty was the winning move).

## Relations

- `desengs-ui-ux-master` — umbrella canon; routes tie-break decisions between two variants here for the evidence-backed default.
- `desengs-laws-of-ux` — supplies the perceptual machinery behind these verdicts (loss aversion = reminders and payramp framing; Von Restorff = thin-bordered CTA beating system-consistent B; goal gradient = checklist and referral progress). This skill contributes the empirical outcomes; that one the explanations.
- `desengs-ui-playbook` — broader rule catalog without evidence weights; use it for rules this corpus never tested (spacing, hierarchy) and prefer this skill's numbers when both cover the same choice.
- `desengs-taste` — the fallback when no test data exists; keeps the instinct honest that Paktor's team (and any untested icon metaphor) demonstrably lacked.
- `desengs-principles` — principle-level framing of the same mechanisms; consult for the generalization, come back here for the exact deltas.
