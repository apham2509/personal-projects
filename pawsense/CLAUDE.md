# CLAUDE.md — PawSense

Guidance for AI-assisted work on this project. Read this before changing code.

## What this is

Local-first Flutter app: personalised cat enrichment + positive-reinforcement
training. Flame game surface, Material 3 owner UI, Riverpod DI, Drift/SQLite
persistence, go_router navigation. iOS/iPadOS + Android only.

Current status: see [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md).
Decisions log: see [DECISIONS.md](DECISIONS.md).

## Hard rules

1. **No cloud, no accounts, no analytics.** Do not add networking packages
   (`http`, `dio`, `firebase_*`, any analytics SDK). A unit test
   (`test/unit/no_network_dependencies_test.dart`) fails the build if a
   networking dependency appears in the pubspec. Core functionality must work
   offline forever.
2. **No copyrighted assets.** All art is procedural (Canvas/Flame), all audio
   is synthesised by `tool/generate_placeholder_audio.dart` or recorded by the
   owner on device.
3. **User-visible strings live in ARB files** (`lib/l10n/app_en.arb`), never
   hard-coded in widgets or game logic. British English.
4. **Personalisation guardrails:**
   - The algorithm stays transparent and documented. Any formula/threshold
     change must bump `algorithmVersion`
     (`lib/features/personalisation/domain/personalisation_policy.dart`) and
     update [docs/PERSONALISATION.md](docs/PERSONALISATION.md).
   - Safety constraints (sound-sensitive, reduced vision, mobility) are hard
     constraints; selection may never violate them.
   - Never market the adaptation as deep RL or "the cat understands English".
     Insights must show sample size + confidence tier; below the minimum
     sample there is no conclusion.
   - Mixed sessions never update individual preference models.
5. **Cat-facing screen:** no buttons, text, menus, links, pop-ups, flashing
   or strobing effects, or sudden loud audio. Exit only via the two-corner
   owner gesture + owner gate.
6. **Determinism:** all gameplay/scheduling randomness flows through
   `SeededRandom` (SplitMix64). Sessions store their seed. Never use
   `dart:math` `Random` directly in domain logic.
7. **Frame loop hygiene:** no synchronous DB writes inside the game loop.
   Events buffer in memory and persist at trial boundaries / session end.
8. **Timestamps are UTC** in storage; UUIDs are primary keys; enums persist
   by name (never reorder or rename persisted enum values without a
   migration).
9. Domain services (`lib/features/*/domain`, `lib/core/random`,
   `lib/core/utils`) stay pure Dart — no Flutter imports — so they run under
   plain `dart` and stay trivially testable.

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # Drift codegen
flutter gen-l10n                                          # after ARB edits
dart format .
flutter analyze
flutter test                                              # fast suite
flutter test test/unit/personalisation                    # focused run
flutter test integration_test                             # needs a device
flutter build apk --debug
dart run tool/generate_placeholder_audio.dart             # regen audio assets
```

## Layout

Feature-first: `lib/features/<feature>/{data,domain,presentation}` plus
`lib/features/play/game` for Flame components. Shared enums/models in
`lib/shared/models`. Infrastructure in `lib/core`. Tests mirror this in
`test/unit`, `test/widget`, `test/game`, `test/fixtures`.

Generated code (Drift `*.g.dart`, `lib/l10n/generated/`) is committed; CI
regenerates and the analyzer excludes it.
