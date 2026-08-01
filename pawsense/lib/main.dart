import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/errors/no_network_http_overrides.dart';
import 'core/files/file_service_locator.dart';
import 'shared/providers/core_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    // Local-first tripwire: any accidental HTTP use throws in development.
    HttpOverrides.global = NoNetworkHttpOverrides();
  }

  final fileService = await createFileService();

  runApp(
    ProviderScope(
      overrides: [fileServiceProvider.overrideWithValue(fileService)],
      child: const PawSenseApp(),
    ),
  );
}
