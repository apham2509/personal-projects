# PawSense Release Guide

## Identifiers

- Android applicationId: `com.apham2509.pawsense`
- iOS bundle identifier: `com.apham2509.pawsense`
- Display name: PawSense
- Version: pubspec.yaml `version` (keep `lib/app/app_config.dart`
  `appVersion` in sync — it is stamped onto every session row)

## App icons and launch screens

The app ships an original Canvas-drawn PawSense mark, matching platform
icons, and warm-paper launch screens. Their source and preview generation
live in `tool/capture_visual_previews_test.dart`; regenerate from that
original artwork when changing the identity.

## Android

### Install a beta from CI

1. Open the repository's **Actions → PawSense CI** and select a successful
   run for the commit being tested (or use **Run workflow**).
2. Download `pawsense-android-debug-<commit>` from the run's artifacts,
   extract `app-debug.apk`, and transfer it to the Android phone/tablet.
3. Open the APK and allow installation from that browser/file manager when
   Android prompts. Alternatively, use `adb install -r app-debug.apk` from
   a computer with an attached device.
4. Run the physical QA checklist, especially the hunt, owner exit, and real
   voice recording. The APK is a debug beta, not a Play Store release.

Artifacts expire after 14 days. CI-generated debug signing keys can change
between runs; Android may reject an update with a signature mismatch. Export
any play data you want to retain before uninstalling the earlier beta; an
uninstall removes local profiles and audio, and exports do not include audio
files. Use a stable private signing key when distributing ongoing betas.

### Prepare a store build

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

CI runs `flutter build ios --release --no-codesign` on macOS to check the
app and its native plugins compile. That produces no installable iPhone/iPad
beta and does not sign or publish anything. Installing on a physical Apple
device requires Xcode signing; distributing via TestFlight requires the
Apple Developer Programme setup below. CI uses no Apple account, certificate,
or provisioning-profile secrets.

### Test on your own iPhone or iPad

1. Use a Mac with full Xcode 15 or newer. Run `flutter pub get` and
   `flutter build ios --debug --no-codesign` once to prepare the project.
2. Flutter 3.44.8 uses Swift Package Manager by default. The Xcode project
   references `FlutterGeneratedPluginSwiftPackage`; Flutter generates this
   package and the current native plugins all support it. No manual
   `pod install` is needed for this dependency set.
3. Open `ios/Runner.xcworkspace`, add your Apple Account in Xcode settings,
   and choose your team under Runner → Signing & Capabilities. Automatic
   signing with a free Personal Team supports testing on your own device.
4. Connect the device, enable Developer Mode when prompted, select it in
   Xcode, and run. Personal Team provisioning is temporary; rebuild when it
   expires. Run the physical-device QA checklist on both phone and tablet.

### Distribute through TestFlight

1. Use a paid Apple Developer Programme membership and its signing team.
2. Archive a release build through Xcode Organizer and upload to TestFlight
   internal testing before broader distribution.
3. Info.plist contains microphone and selected-photo usage descriptions;
   verify permissions and orientations on a physical iPhone and iPad.
4. Do not commit certificates, profiles, or ExportOptions with team IDs.

See Apple's [membership comparison](https://developer.apple.com/support/compare-memberships/)
for Personal Team and distribution capabilities, and Flutter's
[Swift Package Manager guide](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers)
for native dependency setup.

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
