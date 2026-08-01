import 'dart:io';

/// Debug-build tripwire for the local-first guarantee: any code path that
/// tries to open an HTTP client throws immediately, making an accidental
/// network dependency impossible to miss during development.
///
/// Installed from `main()` in debug builds only; release builds simply have
/// no networking code or packages (enforced by
/// test/unit/no_network_dependencies_test.dart).
class NoNetworkHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    throw StateError(
      'PawSense is local-first; unexpected network access was attempted. '
      'See CLAUDE.md hard rule 1.',
    );
  }
}
