# IMPLEMENTATION_STATUS.md

Single source of truth for resuming work. Updated after every phase.

Last updated: 2026-08-01 (Phase 2 complete)

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
- [ ] Phase 3: Core game engine
- [ ] Phase 4: Event pipeline and session analytics
- [ ] Phase 5: Calibration and personalisation
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
