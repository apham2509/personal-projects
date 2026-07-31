# PawSense

Play smarter. Learn your cat.

PawSense is a personalised digital enrichment and positive-reinforcement training app for cats, built with Flutter and Flame. Each cat gets its own profile. The app observes how that cat plays on screen, learns which prey types, movement styles, speeds, and sizes work best for that individual, adapts future sessions, and helps owners pair spoken cues such as "Touch", "Good", and "All done" with successful play.

Everything is local. There is no account, no cloud, no advertising, and no analytics. Behavioural data, photos, and voice recordings never leave the device.

## Screenshots

*Screenshots pending a physical-device capture pass.*

| Profile picker | Play session | Insights |
|----------------|--------------|----------|
| *placeholder* | *placeholder* | *placeholder* |

## Why this exists

Most cat games show every cat the same laser dot. Cats are individuals: one stalks slow, ground-hugging prey; another only bothers with erratic flutterers. PawSense treats each cat as its own small behavioural study — it starts from a short owner questionnaire, runs a balanced calibration, then keeps adapting from observed evidence, always explaining what it learned and how confident it is.

## Features

- Netflix-style "Who's playing?" profile picker with per-cat photos
- Cat onboarding questionnaire that seeds gentle initial priors
- Balanced, seeded 12-trial calibration session
- Free Play with three procedural prey types (mouse, moth, fish), three movement styles, adaptive speed/size/sound
- Touch Training mode using owner-recorded voice cues with praise on success
- Mixed Session mode for multi-cat households (never updates individual models)
- Transparent, interpretable personalisation (documented formulas, no black box)
- Difficulty controller (0-10) with cooldowns and immediate safety reductions
- Frustration and disengagement detection that makes sessions easier, then ends them gently
- Owner dashboard: catch rates, median reaction times, preference insights with confidence labels and sample sizes, paw-touch heatmap
- Local JSON and CSV export via the system share sheet
- Fine-grained deletion: one session, one cat's history, one profile, or everything
- Owner-only exit gesture so a paw tap cannot leave the play screen
- Full ARB localisation architecture (English shipped; Finnish and Vietnamese straightforward to add)
- Hidden developer simulation screen in debug builds

## Architecture summary

- **Flutter + Flame** for the cat-facing play surface; **Material 3** for owner screens
- **Riverpod** for dependency injection and state management
- **Drift (SQLite)** for typed local persistence with explicit migrations
- **go_router** for navigation
- Feature-first source layout with pure-Dart domain services (`lib/features/*/domain`) that have no Flutter dependency and are exhaustively unit tested
- Seeded deterministic randomness (SplitMix64) — every session stores its seed and algorithm version and can be replayed
- Raw interaction events buffered in memory, persisted in batches at trial boundaries, aggregated transactionally at session end
- Crash recovery: stale in-progress sessions are finalised as `interrupted` on next launch, preserving persisted trials

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for layers, data flow, and session lifecycle diagrams.

## Data and personalisation summary

The personalisation model is a transparent factor-level scoring system, not a neural network. Per cat, PawSense tracks smoothed catch rate, reaction score, calm-interaction score, and timeout score for each factor value (prey type, movement style, speed, size, sound mode, spawn zone), combines them into a utility with documented weights, adds a UCB-style exploration bonus, and selects 80% exploit / 20% explore under hard safety constraints. Difficulty moves on a 0-10 scale with evidence requirements and cooldowns. Every formula, threshold, and version is documented in [docs/PERSONALISATION.md](docs/PERSONALISATION.md).

Insights never overclaim: every behavioural statement shows its sample size and a confidence tier (early observation / developing pattern / strong pattern), and small samples show no conclusion at all.

## Privacy

- Local-first: no network calls are required for any core functionality
- No account, no cloud sync, no third-party analytics, no ads, no remote logging
- Microphone access is requested only when recording a voice cue; photos only via the modern system photo picker
- All data can be exported (JSON/CSV) and deleted, per cat or entirely
- Details: [docs/PRIVACY.md](docs/PRIVACY.md)

## Safety

- Sessions are short by design (hard cap 5 minutes) and end early on disengagement or repeated frustration
- No flashing, strobing, or sudden loud audio; calm dark backgrounds with high-contrast prey
- The app optimises for successful, calm, short engagement — not screen time
- Supervise play, use a stable tablet stand, consider a screen protector, and finish with a physical toy
- PawSense is enrichment, not veterinary advice
- Details: [docs/SAFETY.md](docs/SAFETY.md)

## Getting started

Prerequisites: Flutter 3.44+ (stable) with Dart 3.12+.

```bash
cd pawsense
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift codegen
flutter gen-l10n                                           # localisation
```

### Run on Android

```bash
flutter devices                 # find your device/emulator id
flutter run -d <device-id>
```

### Run on iOS/iPadOS

Requires a Mac with full Xcode and CocoaPods.

```bash
cd ios && pod install && cd ..
flutter run -d <device-id>
```

Signing: open `ios/Runner.xcworkspace` once in Xcode and select your development team. No provisioning material is committed to this repository.

### Tests

```bash
flutter test                          # unit + widget + simulation tests
flutter test integration_test        # requires a connected device/emulator
```

### Builds

```bash
flutter build apk --debug            # Android debug
flutter build apk --release          # unsigned release (documented in RELEASE_GUIDE)
flutter build ios --no-codesign      # iOS compile check (requires Xcode)
```

## Known limitations

- V1 exports exclude photos and voice recordings (documented decision; keeps exports small and reliable)
- Cue-response insights are informal single-household observations, not controlled experiments (an optional balanced cued/silent comparison mode is included, still informal)
- No automatic multi-cat identification: Mixed Session exists precisely because the app cannot know which cat touched the screen
- Time-of-day patterns require enough sessions before they appear
- iOS build verification and physical-device performance checks are documented but require hardware/Xcode (see IMPLEMENTATION_STATUS.md)

## Roadmap

See [docs/ROADMAP.md](docs/ROADMAP.md). Headlines: V2 explores optional encrypted cloud backup and richer target packs; V3 explores on-device cat presence detection and smart treat dispensers. No dates are promised.

## Contributing

This is a personal portfolio project inside a monorepo. Issues and suggestions are welcome. Keep pull requests scoped to `pawsense/`, run the quality gates (`dart format`, `flutter analyze`, `flutter test`) before pushing, and read [CLAUDE.md](CLAUDE.md) for architecture constraints (notably: no networking dependencies, no analytics, and personalisation changes must bump the algorithm version and update docs/PERSONALISATION.md).
