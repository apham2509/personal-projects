# PawSense Release Guide

## Identifiers

- Android applicationId: `com.apham2509.pawsense`
- iOS bundle identifier: `com.apham2509.pawsense`
- Display name: PawSense
- Version: pubspec.yaml `version` (keep `lib/app/app_config.dart`
  `appVersion` in sync — it is stamped onto every session row)

## App icons and launch screens

V1 ships the Flutter template icons; before store submission generate a
proper icon set (e.g. with `flutter_launcher_icons`) from an original
design. No copyrighted or AI-ambiguous artwork; keep the procedural-art
spirit of the app.

## Android

1. Create an upload keystore (never commit it):
   ```bash
   keytool -genkey -v -keystore ~/keys/pawsense-upload.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias pawsense
   ```
2. Create `android/key.properties` (gitignored) with storeFile/storePassword/
   keyAlias/keyPassword, and wire the standard `signingConfigs.release`
   block in `android/app/build.gradle.kts` (currently release builds sign
   with debug keys so `flutter run --release` works).
3. Build: `flutter build appbundle --release`.
4. Play Console: internal testing track first. Data Safety answers: see
   below. Category: Entertainment (or Lifestyle). Content rating
   questionnaire: no user-generated content shared, no ads.

## iOS/iPadOS

1. Requires a Mac with full Xcode and CocoaPods
   (`brew install cocoapods`), plus an Apple Developer Programme
   membership.
2. `cd ios && pod install`, open `Runner.xcworkspace`, select your team;
   automatic signing is fine for TestFlight.
3. Compile check without signing: `flutter build ios --no-codesign`.
4. Archive via Xcode Organizer -> TestFlight internal testing.
5. Info.plist already contains the microphone usage description; verify
   orientations (owner screens all, play forces landscape at runtime).
6. Do not commit certificates, profiles, or ExportOptions with team IDs.

## Store privacy disclosures (accurate for V1)

**Apple App Privacy**: "Data Not Collected" across all categories — no data
leaves the device; there is no tracking, no third-party SDK with network
access. (Microphone/photo access is on-device functionality, not
collection.)

**Google Play Data Safety**:
- Data collected: none.
- Data shared: none.
- On-device data: profile info, photos, audio recordings, app activity —
  stored locally, deletable in-app (mention the in-app delete-all).
- Security practices: data not transmitted; users can request deletion via
  in-app deletion (immediate).

Reassess both the moment any SDK or network capability is added
(docs/PRIVACY.md "If cloud features are ever added").

## Release checklist

1. `git pull --ff-only` on main; branch `release/x.y.z`.
2. Bump versions (pubspec + app_config) and CHANGELOG.
3. Full QA gate (docs/QA_PLAN.md) including physical-device pass.
4. Android: `flutter build appbundle --release` -> Play internal testing.
5. iOS: Xcode archive -> TestFlight.
6. Beta with real cats (see README "Recommended beta"), fix, repeat.
7. Store listings from docs/STORE_LISTING.md; screenshots from a demo-data
   build (`/dev` screen seeds deterministic cats in debug builds).
