# IMPLEMENTATION_STATUS.md

Single source of truth for resuming work. Updated after every phase.

Last updated: 2026-08-01 (Phase 8 complete)

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
- [x] Phase 4: Event pipeline and session analytics
  - Note: Phases 4 and 5 were committed in swapped order (dependencies
    first): the pipeline consumes the trial sources, which are built on the
    personalisation domain.
  - [x] SessionRepository: inProgress insert, trial+touch batches anchored
        to session start UTC, transactional finalisation (aggregates +
        preference stats + cue progress + profile difficulty)
  - [x] Crash recovery on launch (stale inProgress -> interrupted,
        aggregates from persisted trials, model untouched, idempotent)
  - [x] PreferenceRepository (snapshot load, prior seeding, decayed
        upserts), CueProgressRepository, VoiceCueRepository (data layer)
  - [x] Trial sources: calibration / adaptive / mixed / manual / replay
  - [x] SessionRunnerFactory + AudioService (audioplayers pools + cue
        player) + play screen (Listener pipeline, owner gate, countdown,
        reward hint, system UI restore), setup screen, results screen with
        owner subjective note
  - [x] Router wired end-to-end; docs/EVENT_SCHEMA.md
  - [x] Tests: +11 (repo pipeline incl. recovery + mixed isolation; widget
        setup/mixed/results; 30-minute soak) — 157 total
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
- [x] Phase 6: Voice cues and Touch Training
  - [x] CueRecorder seam over package:record (AAC m4a mono) with fake for
        tests; recordings via temp file -> profile tree move
  - [x] Voice cues screen: record/stop/preview/re-record/delete for all 5
        cue slots, mic-denied guidance with open-settings
  - [x] Touch Training sequencing already live in the controller (cue ->
        jittered delay -> spawn -> praise -> All done, Phase 3/4); cue
        progress persistence via finalisation (Phase 4)
  - [x] Platform mic config: NSMicrophoneUsageDescription + RECORD_AUDIO
  - [x] FileService switched to sync IO internals (deterministic under
        widget tests; lint-preferred; small local files)
  - [x] Tests: +6 (repo save/replace/delete/missing-file/cascade; widget
        record flow + permission denial) — 163 total
- [x] Phase 7: Insights and data management
  - [x] Pure InsightsCalculator (favourite gating: <8 no conclusion, 0.08
        utility gap; medians; 12x8 heatmap; day-part needs >= 10 sessions;
        trends over last 20 sessions; personality key gating)
  - [x] Insights screen: stat tiles, confidence-chipped favourites with
        evidence sentences, fl_chart trends, CustomPainter heatmap with
        hit/other legend, cue stats with honest caveat, completion reasons,
        playful personality card (with disclaimer)
  - [x] History screen (open/delete sessions with scope-explaining confirm)
  - [x] ExportService: versioned JSON, per-table CSVs, media excluded
        (D-007); share seam; delete-all-data reset to first launch
  - [x] Developer screen (kDebugMode route only): demo seeding, model
        reset, stats inspection, config replay + DemoDataService
  - [x] tool/generate_demo_data.dart + tool/validate_exports.dart run
        headless (AppDatabase and FileService made dart:ui-free; platform
        openers split out)
  - [x] no_network_dependencies tripwire test
  - [x] Tests: +18 - 181 total
- [x] Phase 8: Safety, accessibility, release hardening
  - [x] Real Safety screen (incl. Guided Access + app pinning guidance,
        honest "cannot lock the OS" framing) and Privacy screen; last
        placeholder screens removed
  - [x] Docs: SAFETY, PRIVACY, QA_PLAN, RELEASE_GUIDE, STORE_LISTING,
        legal/ (privacy policy, terms, support)
  - [x] Skip-calibration affordance (CalibrationState.skipped now settable)
  - [x] Reduce-motion honoured in wizard transitions
  - [x] Integration tests authored (5 device flows: first launch, insights,
        export, delete cascade, crash recovery) - need hardware to run
  - [x] permission_handler removed (required compileSdk 37 vs AGP 9.0.1
        cap of 36; record owns the mic permission) - D-002 updated
  - [x] ANDROID DEBUG BUILD SUCCEEDS (app-debug.apk, 51.8 s incremental)
  - [x] CHANGELOG for 0.1.0; l10n.yaml deprecation cleaned
  - Note: iOS compile check remains blocked (no Xcode on this machine);
        config authored (bundle id, mic usage string, orientations)
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
| Phase 4 | clean | clean | pass (157 tests) | not yet run |
| Phase 6 | clean | clean | pass (163 tests) | not yet run |
| Phase 7 | clean | clean | pass (181 tests) | not yet run |
| Phase 8 | clean | clean | pass (181 tests) | SUCCESS (app-debug.apk) |
