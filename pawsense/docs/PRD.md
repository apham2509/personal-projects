# PawSense — Product Requirements Document (V1)

- Product: PawSense — personalised digital enrichment and
  positive-reinforcement training for cats
- Tagline: Play smarter. Learn your cat.
- Platforms: iOS/iPadOS and Android (tablet-first, phone-compatible owner UI)
- Status: V1 in build on `feature/pawsense-v1`

## 1. Product statement

PawSense gives each cat an individual profile, observes screen interactions,
learns the target types and play patterns that work best for that cat, adapts
future sessions, and helps owners associate spoken cues ("Touch", "Good",
"All done") with successful play. V1 is entirely local and private: no
account, no backend, no analytics.

Terminology guardrails: the cat learns through positive reinforcement; the
app personalises with an adaptive, interpretable algorithm. V1 is never
marketed as deep reinforcement learning, never claims scientifically proven
learning, and never claims a cat "understands English". Copy uses careful
phrasing such as "Tiger responded faster after the Touch cue across recent
trials."

## 2. Users and value

Primary users: cat owners, multi-cat households, owners wanting safe indoor
enrichment, owners interested in positive-reinforcement cue training, owners
who enjoy behavioural insights.

Primary value: individualised play rather than one generic game; short,
healthy sessions; transparent behavioural adaptation; owner-recorded voice
reinforcement; useful per-cat insights; complete privacy.

## 3. Functional requirements

### FR-1 Local cat profiles

- Netflix-style "Who's playing?" picker with circular profile cards
- Create, edit, archive, restore, reorder, permanently delete profiles
- Per-profile photo, questionnaire, history, voice recordings, preferences,
  sessions, insights
- No human account, no login, no backend, no cloud sync
- "Mixed session" mode for multi-cat play that never updates individual
  preference models and stores its data separately

Acceptance criteria:

- [ ] Two profiles can play alternately and their preference models never
      cross-contaminate (verified by unit + integration test)
- [ ] Archived profiles disappear from the picker but retain data; restore
      brings them back; permanent delete removes all dependent rows and files
- [ ] Mixed sessions write sessions/trials/events with `catId = null` and
      leave every `PreferenceStats` row untouched

### FR-2 Onboarding questionnaire

Fields (all influencing initial play only): name; optional photo; age group
(kitten / young adult / adult / senior / unknown); body size (small / medium
/ large); energy (low / medium / high); screen-play experience (none / some /
frequent); favourite real-world prey (mouse / moth-bug / fish / feather /
ball / other / unknown); sound sensitivity (enjoys sound / neutral / easily
startled / unknown); treat motivation (low / medium / high / unknown);
mobility consideration (none / limited movement / senior-friendly); vision
(none known / reduced / unknown); hearing (none known / reduced / unknown);
main owner goal (play / mental enrichment / verbal cue training / gentle
activity); optional notes.

The questionnaire creates weak initial priors only; observed behaviour must
outweigh owner guesses after enough data (see docs/PERSONALISATION.md).

Acceptance criteria:

- [ ] Wizard completes with only a name (everything else has defaults or
      "unknown")
- [ ] Priors are seeded per docs/PERSONALISATION.md and demonstrably
      overpowered by ~20 contradicting observed trials (simulation test)

### FR-3 First-session calibration

- 12 trials testing mouse/moth/fish x smooth/stop-go/unpredictable x
  slow/medium x large/medium x sound/silent (where safe)
- Deterministic seeded schedule, balanced factor exposure; no target type
  more than twice consecutively; no exact configuration repeated
  consecutively
- Safety overrides: sound-sensitive cats start silent; reduced-vision cats
  start large/high-contrast; mobility-limited cats start slow
- Calibration may be skipped, restarted, or continued later; result and
  confidence stored

### FR-4 Play modes

1. Free Play: adaptive prey; successful touch triggers capture animation and
   sound/voice reward
2. Touch Training: owner-recorded "Touch" cue -> jittered 300-700 ms delay ->
   target -> catch plays "Good"/"Good job" -> session ends with "All done"
3. Calibration (FR-3)
4. Mixed Session (FR-1)

### FR-5 Prey and movement

- Prey: mouse, moth, fish — original procedural vector art (Flame/Canvas),
  each with idle, movement, and capture animation, optional subtle
  synthesised sound, enlarged invisible hitbox, stable visual identity
- Movement styles: smooth (curved continuous), stop-and-go (scurry, pause,
  direction change), unpredictable (bounded non-teleporting changes)
- Device-independent tuning (fractions of shortest screen dimension):
  safe margin ~8% per edge; sizes ~15/11/8%; speeds ~0.12/0.22/0.35 per
  second — all configurable constants in `play_tuning.dart`
- Targets never hide under system UI, become unreachable, visibly teleport,
  trap in corners, leave safe bounds, or oscillate unnaturally

### FR-6 Session controls

- Durations 1/2/3/5 min (default 3, hard max 5)
- Early stop by owner; automatic end on completion, prolonged inactivity,
  repeated frustration, owner exit, app backgrounding, or interruption/crash
- "All done" cue at end when available; owner-facing result screen after

### FR-7 Owner-recorded voice cues

Per cat: cat name, Touch, Good, Good job, All done. Record, preview,
re-record, delete; stored locally only in an app-managed profile directory;
cleaned up with profile/cue deletion; graceful microphone-denial UX; silent
fallback plus subtle synthesised success sound when no praise recording
exists; never uploaded.

### FR-8 Real-world reward schedule (optional)

None / manual only / every 3 catches / variable 2-5 catches; max reminders
per session (default 3). Copy always states treats are optional, should fit
the cat's normal diet, and that PawSense is not veterinary advice.

### FR-9 Owner dashboard

Per cat: recent sessions, catches, catch rate, median reaction time,
engagement duration, miss rate, frustration indicators, favourite prey,
preferred movement style, speed range, target size, best time-of-day (only
with sufficient data), cue response trend, paw-touch heatmap (normalised),
difficulty trend, completion reasons, calibration status.

Confidence labels: Early observation (8-19 comparable impressions),
Developing pattern (20-49), Strong pattern (50+); below 8, no conclusion.
Every insight shows sample size, confidence label, and a plain-language
explanation, e.g. "Tiger has caught stop-and-go mice in 17 of 21 recent
trials. This is a developing pattern."

### FR-10 Data management

Export one cat or all data as JSON and as CSV (separate files per table) via
the native share sheet. Delete one session / one cat's history / one profile
with all associated data / all app data — each with confirmation explaining
exactly what is removed. V1 exports exclude media (photos, audio); this is a
documented decision (DECISIONS.md D-007).

### FR-11 Localisation

Flutter ARB localisation from the beginning; complete English copy; Finnish
and Vietnamese must be addable by dropping in new ARB files; no hard-coded
user-visible strings in widgets or game logic.

### FR-12 Developer simulation mode (debug builds only)

Simulate catches/misses/inactivity/frustration; generate deterministic test
sessions; inspect personalisation scores; reset a profile's learned model;
replay a trial configuration; seed demo data; display algorithm version and
seed. Not reachable in release builds.

## 4. User stories (selection)

- As an owner of two very different cats, I pick Tiger's profile and get
  slow, large, ground-style prey, then pick Shark's and get fast moths —
  without configuring anything manually.
- As the owner of a sound-startled cat, I mark her "easily startled" and no
  session ever starts with sound until I explicitly enable it.
- As a data-minded owner, I open Insights and see exactly how many trials
  back every claim, with an honest "early observation" tag on new patterns.
- As a privacy-conscious owner, I export everything to JSON, verify nothing
  ever left the device, and delete a retired cat's profile completely.
- As an owner training a "Touch" cue, I record my own voice once and the app
  uses it consistently, praising in my voice on success.

## 5. UX requirements

Owner-facing: friendly, polished, calm, playful; Material 3; large tap
targets; accessibility semantics; tablet-first responsive; portrait and
landscape for owner screens; clear empty/loading/error/permission-denied
states; no manipulative engagement patterns, streak guilt, or screen-time
optimisation.

Primary flow: first launch (intro, local-first privacy, safety, create first
cat, permissions only when needed) -> profile picker -> cat home (Play /
Train / Insights / History / Profile & voice) -> session setup (mode,
duration, adaptive or manual, sound, reward reminders) -> 3-second calm
countdown -> cat play screen -> result screen -> optional owner note
(engaged / neutral / frustrated, stored separately from observed data) ->
updated insights.

Cat-facing screen: no visible buttons, ads, text, menus, purchase controls,
destructive actions, links, navigation bars, sudden pop-ups, or flashing;
dark/calm configurable background; high-contrast prey.

Owner-only exit: simultaneous ~2 s long-press in upper-left + upper-right
corners, then an owner gate (press-and-hold confirmation or optional 4-digit
PIN); system UI and orientation restored on exit. The app explains iPad
Guided Access and Android screen pinning and never claims to fully lock the
OS itself.

## 6. Non-goals (V1)

User accounts; authentication; cloud database/sync; Firebase; third-party
analytics; advertising; IAP/subscriptions; camera-based cat recognition; cat
facial recognition; automatic multi-cat identification; Bluetooth treat
dispensers; social feeds; leaderboards; veterinary diagnosis; deep
reinforcement learning; generative AI; remote owner control; public profile
sharing. Documented as V2/V3 candidates only (docs/ROADMAP.md).

## 7. Release criteria

The V1 definition of done is tracked in IMPLEMENTATION_STATUS.md and mirrors
the execution contract: all functional requirements implemented and tested,
`flutter analyze` clean, tests green, Android debug build succeeding, CI
passing, privacy/safety/store documentation complete, physical-device checks
documented.
