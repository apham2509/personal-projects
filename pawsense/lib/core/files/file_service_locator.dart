import 'package:path_provider/path_provider.dart';

import 'file_service.dart';

/// Resolves the platform documents directory. Kept out of file_service.dart
/// so the service itself stays pure dart:io and usable from headless
/// tooling.
Future<FileService> createFileService() async {
  final dir = await getApplicationDocumentsDirectory();
  return FileService(dir);
}
