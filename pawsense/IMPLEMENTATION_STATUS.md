# IMPLEMENTATION_STATUS.md

Single source of truth for resuming work. Updated after every phase.

Last updated: 2026-08-01 (Phase 3 complete)

## Environment (verified)

- Flutter 3.44.8 stable, Dart 3.12.2 (Homebrew cask, darwin-arm64)
- Android: OpenJDK 17 (Homebrew formula), SDK 36 + build-tools 36.0.0 at
  `~/Library/Android/sdk`, licences accepted; `flutter doctor` Android green
- iOS: **blocked on this machine** — full Xcode not installed (Command Line
  Tools only), no CocoaPods. iOS config is authored; compile check pending
- Repo: `feature/pawsense-v1` branched from up-to-date `main`

## Phase checklist

- [x] Phase 0: Toolchain setup (Flutter/JDK/Android SDK installed & verified)
- [x] Phase 1: Repository and product foundation
  - [x] Repo inspected, branch created (`feature/pawsense-v1`)
  - [x] `flutter create` scaffold (org com.apham2509, ios+android)
  - [x] Dependencies added and resolved (see DECISIONS.md D-002)
  - [x] analysis_options tightened; l10n pipeline (ARB) generating
  - [x] Original audio assets synthesised (tool/generate_placeholder_audio.dart)
  - [x] Docs: README, CLAUDE.md, DECISIONS, CHANGELOG, PRD, ARCHITECTURE, ROADMAP
  - [x] CI workflow (.github/workflows/pawsense-ci.yml)
  - [x] Committed
- [x] Phase 2: Database and profile system
  - [x] Drift schema v1 (8 tables, FK cascades, UTC ISO text datetimes)
  - [x] Migration strategy + settings-row seeding
  - [x] CatProfileRepository (create/update/archive/restore/reorder/delete
        cascade incl. media) + SettingsRepository (PIN hashing)
  - [x] App shell: router, theme, bootstrap, intro flow
  - [x] Profile picker (grid + mixed session), manage screen (drag reorder,
        archive/restore, delete with scope confirmation)
  - [x] 7-step questionnaire wizard (create + edit, photo picking)
  - [x] Cat home hub; functional settings screen (durations, sound, rewards,
        PIN, accessibility)
  - [x] docs/DATABASE_SCHEMA.md
  - [x] Tests: 17 (repositories incl. cascade + mixed-session survival,
        PIN hashing; app-level widget tests for first-launch/picker/manage/
        settings)
  - Note: widget-test learnings — drift awaits need tester.runAsync
    (harness dbCall), teardown unmount before db.close, dialog controllers
    owned by dialog state
- [x] Phase 3: Core game engine
  - [x] PlayTuning (all gameplay constants, device-independent)
  - [x] Movement strategies: smooth / stop-and-go / unpredictable (bounded,
        non-teleporting, seed-deterministic)
  - [x] Touch pipeline: clusterer (180 ms / 4% shortest-dim), classifier
        (hit > ownerGesture precedence, edge, postCapture, dedup), hold
        tracking
  - [x] OwnerExitTracker (two-corner 2 s simultaneous hold)
  - [x] FrustrationDetector (7 flags, severity 0-3) +
        DisengagementTracker (12/20/30 s ladder)
  - [x] GameSessionController: full state machine (countdown, cue, spawn,
        catch/timeout, inter-trial, typed ends), reward reminders, safety
        wiring, learning-valid trial semantics
  - [x] PawSenseGame + procedural mouse/moth/fish (Canvas vector, capture/
        spawn/expire animations, high-contrast palettes)
  - [x] Tests: +79 (58 unit + 21 controller/game); found and fixed a real
        zombie-session bug (phase clobber after frustrated end)
- [ ] Phase 4: Event pipeline and session analytics
  - Note: Phases 4 and 5 were committed in swapped order (dependencies
    first): the pipeline consumes the trial sources, which are built on the
    personalisation domain.
- [x] Phase 5: Calibration and personalisation
  - [x] PreferenceScorer (spec formulas exactly), TrialRewardCalculator,
        confidence tiers + favourite gap
  - [x] ConfigurationSelector (UCB bonus with per-factor totals, 80/20,
        top-band exploitation, repetition rules, difficulty bands x safety)
  - [x] DifficultyController (evidence gates, cooldown, immediate safety
        reductions, -2 on repeated high frustration)
  - [x] CalibrationScheduler (balanced 12 trials, seeded, safety waivers)
  - [x] Priors seeding + decayed stats update (D-005)
  - [x] docs/PERSONALISATION.md (complete formulas, pseudocode, limits)
  - [x] Tests: +50 (formula-exact unit tests; 2000-seed calibration
        property test; 5000-selection safety property; simulations:
        convergence, exploration persistence, struggling cat, gradual
        difficulty, lucky-trial gating, priors overpowered)
- [ ] Phase 6: Voice cues and Touch Training
- [ ] Phase 7: Insights and data management
- [ ] Phase 8: Safety, accessibility, release hardening
- [ ] Phase 9: Repository integration (root README, PR)

## Staged work not yet in the tree

Pure-Dart domain files drafted ahead of their phases are staged at
`<scratchpad>/staging/lib/` (session-local) and are moved into `lib/` during
their owning phase. If resuming in a fresh session and the scratchpad is
gone, the files are re-authored from docs/PERSONALISATION.md +
docs/ARCHITECTURE.md specs — no unique state lives there.

## Known blockers

- iOS compile check + physical-device QA require Xcode / hardware (owner
  action; steps in docs/RELEASE_GUIDE.md)
- `flutter test integration_test` requires a connected device/emulator; not
  runnable on this machine (no emulator images installed, no Xcode). Suite is
  authored and CI-documented.

## Quality gate log

| Phase | format | analyze | test | apk debug |
|-------|--------|---------|------|-----------|
| scaffold baseline | n/a | 3 issues (template lints + missing assets dir, all since fixed) | pass (1 test) | not yet run |
| Phase 1 | clean | clean | pass (1 test) | not yet run |
| Phase 2 | clean | clean | pass (17 tests) | not yet run |
| Phase 3 | clean | clean | pass (96 tests) | not yet run |
| Phase 5 | clean | clean | pass (146 tests) | not yet run |
