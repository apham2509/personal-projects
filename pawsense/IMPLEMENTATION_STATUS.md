# PawSense implementation status

Updated 2026-09-16. App version **0.2.0+2**; learning evidence version
**pawsense-personalisation-v1.1**. Branch: `feature/pawsense-polished-beta`.

## Product and beta scope

Real cats hunt moving prey on a tablet. Owners set up individual profiles,
record short cues, supervise play and optionally provide a physical reward.
Touch Training sequences greeting → Touch → short pause → prey → paw catch
→ recorded praise. Free Play and a non-learning Mixed Session remain
available. iOS/iPadOS and Android are the supported platforms; phone owner
screens are supported, but the main play surface is a tablet.

Local SQLite, recordings and photos stay on device. No account, backend,
analytics or network dependency is required. Adaptation uses documented
factor scores and exploration; it is not a language-understanding claim.

## This beta's changes

- Original procedural prey anatomy and deterministic movement animation;
  regular/high-contrast palettes and catch-area containment tests.
- Swept paw catches and later-pad cluster promotion; no false pre-target
  misses, repeated move misses or held-paw catches on later targets.
- Recorded greetings/praise finish before the next cue; session sound and
  profile safety settings govern voice playback. Recordings auto-stop at
  five seconds and cancel safely on background/navigation.
- Scoped screen wake lock, owner-gate pause, guarded system Back, saved
  interruptions on background, unexpected navigation and board resize.
- Optional physical reward reminders pause before the next hunt.
- Warm, accessible owner theme and original Canvas illustrations; reduced
  motion, scrollable profile picker and responsive phone controls.
- At least eight concluded calibration trials before completion. Fresh
  v1.1 priors, idempotent finalisation and version-specific preference
  evidence; older descriptive history remains available.
- Android tablet integration drives native audio, actual gameplay touch,
  owner exit and SQLite reopening. CI also compiles unsigned native iOS
  and produces an installable Android debug APK.

## Verification

Local quality gates pass: **262 tests**, clean `flutter analyze`, clean
format check, regenerated Drift/localisations and clean workflow validation.
Native Android APK and unsigned iOS builds passed in
[CI run 35148702543](https://github.com/apham2509/personal-projects/actions/runs/35148702543).
The Android integration app compiled and installed, then exposed a temporary
directory error in the test harness before any app flow ran. That harness
setup is corrected; the device-flow rerun is pending.
Visual previews render the actual Canvas prey and owner widgets using
`tool/capture_visual_previews_test.dart`; these are renderer captures, not
physical-device screenshots.

The historical 0.1.0 baseline (2026-08-01) passed 181 tests and an Android
debug build. That does not verify the current beta or current local tools.

## Current environment

- Flutter 3.44.8 / Dart 3.12.2 installed at
  `~/.local/share/pawsense-tools/flutter` for local analysis and host tests.
- This Mac currently has neither a configured Android SDK nor full Xcode.
  Native builds run in GitHub Actions. No local native-build claim is made.
- iOS CI uses macOS/Xcode and compiles without signing. A successful compile
  is not an installable iPhone/iPad beta.

## Remaining physical-device checks

Use [QA_PLAN.md](docs/QA_PLAN.md) for the supervised device pass and
[RELEASE_GUIDE.md](docs/RELEASE_GUIDE.md) for installation/signing.

- Real microphone permission, recorded voice quality and cue loudness.
- Real cat paw recognition, prey response and optional physical rewards.
- iPad/iPhone signing and installation; Android installation.
- Guided Access/app pinning, interruptions, orientation/window modes,
  performance, heat and screen sleep on physical hardware.

These checks cannot be inferred from simulation, emulator input or native
compilation. Store publication is outside this beta pass.
