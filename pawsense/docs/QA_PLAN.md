# PawSense QA Plan

## Automated (run on every change; CI runs them all)

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test                       # 180+ tests, all suites below
flutter build apk --debug
```

- **Unit — touch processing**: clustering windows/radii, dedup, hitbox
  inflation + minimum, classification precedence, owner-corner exclusion,
  hold tracking.
- **Unit — movement**: bounds containment over long simulations, hard step
  cap (no teleporting), seed determinism, travel liveliness, irregular
  frame times, all styles x speeds.
- **Unit — personalisation**: exact formula tests (smoothed catch rate,
  reaction score, calm/timeout scores, utility weights, confidence,
  reward clamps), UCB bonus, 80/20 behaviour, repetition rules, difficulty
  gates/cooldowns/safety drops, frustration flags, disengagement ladder.
- **Property tests**: calibration balance + sequence constraints across
  2000 seeds; selector safety across 5000 selections.
- **Simulations**: convergence to a synthetic preference, exploration
  persistence, struggling-cat difficulty collapse, gradual difficulty rise,
  priors overpowered by evidence, lucky-trial gating.
- **Unit — data**: repositories (CRUD, cascades, mixed-session isolation,
  PIN hashing), session pipeline (batch anchoring, transactional
  finalisation, crash recovery idempotence), voice cues (save/replace/
  delete/missing-file), exports (JSON structure, scope, CSVs, delete-all),
  insights calculator honesty gates, no-network tripwire.
- **Widget**: first-launch flow, picker, wizard validation, manage
  (archive/restore/delete confirms), settings + PIN, session setup, mixed
  setup, results + owner note, voice recording + permission denial,
  insights empty/populated, history delete, export share seam.
- **Game**: controller state machine (catch/timeout/disengagement/
  frustration ends, no double catches, buffer bounds, reward reminders,
  cue sequencing, seed reproducibility, spawn zones), headless Flame game
  (reachability, immediate capture deactivation, component lifecycle,
  render smoke), 30-minute soak.

## Integration tests (`integration_test/`, need a device or emulator)

Authored flows: first launch -> create cat -> calibration setup; free play
-> stored session -> insights; export share; delete cascade; interrupted
session recovery. Run with:

```bash
flutter test integration_test -d <device-id>
```

Not runnable on the development machine used for V1 (no emulator/Xcode);
must be part of the physical-device pass below.

## Physical-device pass (required before any release)

Hardware: one iPad (Guided Access), one Android tablet (app pinning), plus
a phone form-factor sanity check of owner screens.

1. Play session at 60 fps: watch for jank during spawn/capture (DevTools
   performance overlay), on both tablets.
2. Real paw testing with a cat: cluster window sanity (no double catches
   from one pounce), hitbox feel for small targets, exit gesture cannot be
   triggered by play, screen-pinning workflows.
3. Audio: cue recording/playback latency, praise timing after catch, no
   clipping, silent mode honoured, volume comfortable at arm's length.
4. Lifecycle: background mid-session (status `backgrounded`), force-kill
   mid-session then relaunch (crash recovery to `interrupted`), rotation
   on owner screens, immersive-mode restore after exit.
5. Permissions: deny microphone, verify guidance; revoke mid-app.
6. Accessibility: VoiceOver/TalkBack across owner screens, 200% font
   scale, contrast in light/dark themes.
7. Battery/thermals: one full 5-minute session should not warm the device
   noticeably.
8. Export: share JSON to Files/Drive-like target and re-import into the
   validator (`dart run tool/validate_exports.dart`).

## Release regression checklist

- [ ] All automated gates green on CI
- [ ] Integration tests green on at least one physical device per platform
- [ ] Physical-device pass items above completed and noted
- [ ] `dart run tool/generate_demo_data.dart` output passes
      `tool/validate_exports.dart`
- [ ] Store metadata matches docs/STORE_LISTING.md; privacy disclosures
      match docs/PRIVACY.md
- [ ] Version bumped in pubspec.yaml AND lib/app/app_config.dart
- [ ] CHANGELOG.md updated
