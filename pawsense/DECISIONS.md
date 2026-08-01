# DECISIONS.md — PawSense

Significant architecture and product decisions, newest last. Each entry:
context, decision, consequences.

## D-001: Monorepo placement and isolation

The app lives in `personal-projects/pawsense/` beside existing projects.
Nothing outside `pawsense/`, `.github/workflows/pawsense-ci.yml`, and the
root README project table is touched. CI is path-filtered so wildfire
workflows are unaffected.

## D-002: Package set (checked against Flutter 3.44.8 / Dart 3.12.2, 2026-08-01)

Chosen (resolved versions in `pubspec.lock`):

- `flame` 1.38 — cat-facing game surface.
- `flutter_riverpod` 3.4 — DI + state. Classic providers with
  `Notifier`/`AsyncNotifier`; no riverpod codegen, keeping build_runner
  surface to Drift only.
- `drift` + `drift_flutter` 2.34 — typed SQLite with migrations; NativeDatabase
  in-memory for tests.
- `go_router` 17 — Flutter-team-maintained routing.
- `record` 7 — voice-cue capture (AAC/m4a).
- `audioplayers` 6 — **single audio engine** for both owner cue playback and
  short game effects (`AudioPool` for low latency). The spec suggested
  `just_audio` + `flame_audio`; using one engine avoids two audio sessions
  fighting on iOS, halves the dependency surface, and `flame_audio` is a thin
  wrapper over audioplayers anyway. Documented equivalent, maintained.
- `image_picker` 1.2 — uses PHPicker (iOS) and the Android system photo
  picker; no broad storage permissions needed.
- ~~`permission_handler`~~ — initially included for `openAppSettings()`,
  removed in Phase 8: `permission_handler_android` 13.x requires
  compileSdk 37 while AGP 9.0.1 caps at 36, and `record` already owns the
  microphone permission request. The mic-denied state now shows textual
  guidance to system settings instead of a deep link.
- `share_plus`, `csv`, `uuid`, `crypto` (PIN hashing), `fl_chart` (trend
  charts; heatmap is a CustomPainter), `path_provider`, `intl` +
  `flutter_localizations` (ARB), `collection`.

Rejected: `firebase_*`/analytics (hard product rule), `just_audio` +
`flame_audio` (see above), `isar`/`hive` (Drift chosen for typed relational
queries, transactions, and migration story), riverpod codegen (extra
generator for little gain at this size).

## D-003: Deterministic randomness via own SplitMix64

Dart's `Random` algorithm is implementation-defined, so stored seeds would
not be guaranteed to replay identically across Dart versions/platforms.
`SeededRandom` implements SplitMix64 (tiny, well-specified). All gameplay,
scheduling, and selection randomness flows through it; sessions persist their
seed and `algorithmVersion`, making every schedule and movement path
reproducible.

## D-004: Generated code is committed

Drift `*.g.dart` and `lib/l10n/generated/` are committed. Reviewers can see
schema changes in diffs, tooling (IDE/analyzer) works after a bare checkout,
and CI still regenerates before testing, so drift between source and
generated code cannot survive CI. Analyzer excludes generated files.

## D-005: Preference recency — decayed counts, raw history immutable

Spec formulas (Beta(2,2)-smoothed catch rate etc.) are kept exactly, but the
per-factor counters they read are gently decayed (multiplied by 0.995) on
each update before increment, giving an effective memory of roughly the last
few hundred trials. Raw trials/events are never modified; owner-facing
insight sample sizes are computed from raw trial queries, not decayed
counters, so displayed evidence is always honest counts.

## D-006: Touch clustering operates in logical pixels

Cluster radius is specified as 0.04 x shortest screen dimension. Normalised
x/y are per-axis (0-1 of width/height), so distances computed on normalised
coordinates would be aspect-distorted. The clusterer therefore works in
logical pixels with a pixel radius; storage keeps normalised coordinates for
device independence.

## D-007: V1 export excludes media

JSON/CSV exports cover all behavioural data, profiles, preference statistics,
and cue metadata, but not photos or voice recordings. Bundling media means
zipping large binary payloads through the share sheet with poor failure
modes; V1 keeps exports small, deterministic, and testable. The "include
media" toggle is deferred to V2 and stated in PRIVACY.md and the UI copy.

## D-008: sortOrder column added to CatProfiles

The spec's profile table had no ordering field but requires reorderable
profiles. `sortOrder` (integer) added; reordering persists explicit values.

## D-009: Single Listener overlay feeds a pure touch pipeline

Raw pointer events are captured by one Flutter `Listener` above the
`GameWidget`, not by Flame gesture callbacks. The pipeline
(clusterer -> classifier -> session controller) is pure Dart and unit
testable without a game instance; Flame components never receive input
directly, which also guarantees a captured target cannot double-fire.

## D-010: Owner PIN is optional and hashed

Owner gate defaults to press-and-hold. An optional 4-digit PIN is stored as
SHA-256(salt + pin) with a random 16-byte salt — not plaintext. This is a
child/paw gate, not a security boundary, and is documented as such.

## D-011: JDK/Android toolchain on dev machine

Homebrew `temurin@17` cask needs sudo (pkg installer), unavailable in this
environment; used the `openjdk@17` formula plus `android-commandlinetools`
cask with SDK root at `~/Library/Android/sdk` instead. Functionally
identical for Gradle builds. Xcode is not installed on this machine, so iOS
compile checks are documented as pending (IMPLEMENTATION_STATUS.md).

## D-012: Prey sound plays on capture, not continuously

Continuous per-prey sound loops risk startling sound-sensitive cats and
complicate the audio budget. V1 plays the short synthesised prey voice at
spawn (sound mode permitting) and the capture pop + praise on catch. All
sounds are quiet, soft-attack, synthesised originals
(`tool/generate_placeholder_audio.dart`).
