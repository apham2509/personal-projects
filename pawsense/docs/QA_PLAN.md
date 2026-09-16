# PawSense QA Plan

## Automated checks

`PawSense CI` runs for PawSense changes on pull requests, `main`, and
`feature/**`, and can be started manually with **Run workflow**. It has three
independent jobs: host analysis/tests plus a downloadable Android debug APK;
Android tablet emulator integration; and an unsigned iOS device build that
compiles the native plugins. An iOS compile pass does not prove behaviour on
an iPhone or iPad.

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test                       # all fast suites below
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

The Android CI job runs these on an API 35 Pixel C tablet emulator. Each
test uses its own real SQLite file and private temporary media directory,
initialises before app mount, and unmounts the app before awaiting database
closure. Tests never delete a tester's own profiles.

- First launch, profile wizard, and calibration setup.
- Stored sessions, insights, and history.
- Export files and deletion of dependent records/media.
- App-bootstrap recovery of an interrupted stored session, plus idempotence.
- Voice recording screen Record/Stop and preview; actual native AAC decode
  and playback; a live Flame hunt with the real session runner and pointer
  input; one successful Touch trial and recorded praise; system Back
  protection; the two-corner gesture and owner hold; saved session, touch,
  and cue-response progress; and reopening SQLite to verify durability.

The voice test replaces only microphone capture with an original synthetic
AAC fixture embedded in the integration bundle. It makes no runtime network
request and still exercises production file saving, audio playback, and
training. It does **not** validate actual human voice capture, OS microphone
permission dialogs, audible quality, or what a cat learns. The audio engine
also has a direct decode/completion assertion so a playback fail-open guard
cannot conceal a broken fixture. Those remaining checks belong below.

Run on a connected device or emulator with:

```bash
flutter test integration_test/app_flows_test.dart -d <device-id>
```

The development machine has no Android SDK or full Xcode. Local Dart
analysis/bundle compilation cannot replace the CI emulator run or the
physical-device pass.

## Physical-device pass (required before any release)

Hardware: one iPad (Guided Access), one Android tablet (app pinning), plus
a phone form-factor sanity check of owner screens.

1. Play session at 60 fps: watch for jank during spawn/capture (DevTools
   performance overlay), on both tablets.
2. Real paw testing with a cat: cluster window sanity (no double catches
   from one pounce), hitbox feel for small targets, exit gesture cannot be
   triggered by play, screen-pinning workflows.
3. Audio: record the owner's real voice for all five slots; stop, preview,
   re-record, delete, and relaunch. Confirm Touch finishes before prey appears,
   recorded praise follows a catch, and All done plays on owner exit.
   Check playback latency, no clipping, app sound settings honoured, and
   comfortable volume at arm's length. Confirm easily startled profiles
   remain silent even when sound is enabled in session setup.
4. Lifecycle: background mid-session (status `backgrounded`), force-kill
   mid-session then relaunch (crash recovery to `interrupted`), rotation
   on owner screens, immersive-mode restore after exit.
5. Permissions: deny microphone, verify guidance; revoke mid-app. Background
   or navigate away while recording; confirm capture stops and no abandoned
   temporary recording remains.
6. Accessibility: VoiceOver/TalkBack across owner screens, 200% font
   scale, contrast in light/dark themes.
7. Battery/thermals: one full 5-minute session should not warm the device
   noticeably. The screen stays awake throughout the hunt, then returns to
   normal sleep behaviour on results, owner exit, and backgrounding.
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
