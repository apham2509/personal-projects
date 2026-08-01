import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The local-first tripwire (CLAUDE.md hard rule 1): PawSense must not
/// depend on networking or analytics packages. If one appears in the
/// pubspec, this fails the build with the reason spelled out.
void main() {
  test('pubspec contains no networking or analytics dependencies', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    const banned = [
      'http:',
      'dio:',
      'chopper:',
      'retrofit:',
      'graphql',
      'web_socket_channel:',
      'grpc:',
      'firebase_',
      'cloud_firestore',
      'supabase',
      'amplify_',
      'sentry',
      'mixpanel',
      'amplitude',
      'posthog',
      'segment',
      'appsflyer',
      'adjust_sdk',
      'google_mobile_ads',
    ];

    final directSection = pubspec.split('dev_dependencies:').first;
    for (final name in banned) {
      expect(
        directSection.contains('\n  $name'),
        isFalse,
        reason:
            '"$name" looks like a networking/analytics dependency. PawSense '
            'is local-first: no cloud, no analytics, no ads (docs/PRIVACY.md, '
            'CLAUDE.md hard rule 1). If this is intentional, the privacy '
            'documentation and store disclosures must change first.',
      );
    }
  });
}
