/// App-level constants that are not gameplay tuning.
library;

/// Human-readable version stored on every session row. Keep in sync with
/// pubspec.yaml `version`.
const String appVersion = '0.1.0';

/// Version of the privacy explanation the owner accepted during intro.
/// Bump when docs/PRIVACY.md changes materially; the app then re-shows the
/// privacy page on next launch.
const int privacyPolicyVersion = 1;
