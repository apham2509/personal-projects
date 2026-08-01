# PawSense Privacy

V1 is local-first. This document is the engineering source of truth; the
in-app privacy screen and docs/legal/privacy-policy.md say the same things
in owner language.

## Local data map

| Data | Where | Notes |
|------|-------|-------|
| Cat profiles + questionnaire answers | SQLite (`pawsense.sqlite`, app-private storage) | includes optional free-text notes |
| Sessions, trials, touch events | SQLite | touch positions stored as screen fractions; pointer-downs only |
| Learned preferences (PreferenceStats), cue progress | SQLite | decayed working counters + reaction EWMAs |
| Settings incl. optional owner PIN | SQLite | PIN stored as SHA-256(salt+pin), never plaintext |
| Profile photos | `<documents>/profiles/<catId>/photo_*.jpg` | copied from the system picker selection |
| Voice cue recordings | `<documents>/profiles/<catId>/cues/*.m4a` | recorded in-app |
| Transient exports | `<documents>/export/` | cleared after the share sheet completes |

No account exists. No cloud storage, no sync, no advertising, no
third-party analytics, no remote logging or crash reporting. Core
functionality performs no network calls; debug builds install an
HttpOverrides tripwire that throws on any HTTP client creation, and a unit
test (`no_network_dependencies_test`) fails the build if a networking or
analytics package is added to the pubspec.

## Permissions

- **Microphone** (`NSMicrophoneUsageDescription` / `RECORD_AUDIO`):
  requested only when the owner records a voice cue; used only during
  recording; files stay in app storage. Denial is handled gracefully with
  guidance to system settings; every play feature works without it.
- **Photos**: never a library permission — the modern system photo picker
  (PHPicker / Android photo picker) hands over only the selected image.
- Nothing else. No location, no contacts, no Bluetooth, no trackers.

## Export

Settings > Data management exports one cat or everything as JSON or
per-table CSVs through the native share sheet. The owner chooses the
destination; PawSense itself transmits nothing. V1 exports exclude photo
and audio files by documented decision (DECISIONS.md D-007) and say so in
the UI; cue metadata (type, duration, recorded-at) is included.

## Deletion

- One session; one cat's entire history; one profile with all dependent
  rows and media files (cascading foreign keys + directory removal); or all
  application data (returns to first-launch state).
- Every destructive action shows a confirmation stating exactly what is
  removed. Deletions are immediate and permanent; there is no server-side
  copy anywhere.
- Learned preference counters are a running summary and are not rolled back
  by deleting individual sessions; the confirmation copy says so.

## If cloud features are ever added (V2+)

Any such feature will be opt-in and off by default, encrypted in transit
and at rest, described in an updated privacy policy before release, and
reflected in updated App Store privacy and Play Data Safety disclosures.
The no-network build check will be adjusted to allow-list only the specific
endpoints involved.
