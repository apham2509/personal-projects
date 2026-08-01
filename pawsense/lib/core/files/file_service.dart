import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Owns the app-managed file tree:
///
/// ```
/// <app documents>/
///   profiles/<catId>/photo_<millis>.jpg
///   profiles/<catId>/cues/<cueType>.m4a
///   export/                (transient)
/// ```
///
/// The database stores paths *relative* to the documents directory so
/// backups/restores and iOS container moves cannot break references.
class FileService {
  FileService(this._documentsDir);

  final Directory _documentsDir;

  static Future<FileService> create() async {
    final dir = await getApplicationDocumentsDirectory();
    return FileService(dir);
  }

  Directory get documentsDir => _documentsDir;

  /// Absolute [File] for a stored relative path.
  File resolve(String relativePath) =>
      File('${_documentsDir.path}/$relativePath');

  Directory profileDir(String catId) =>
      Directory('${_documentsDir.path}/profiles/$catId');

  Directory cueDir(String catId) => Directory('${profileDir(catId).path}/cues');

  Directory exportDir() => Directory('${_documentsDir.path}/export');

  /// Copies a picked photo into the profile directory and returns its
  /// relative path. A timestamped name defeats stale image caches after a
  /// photo change; any previous photo files for the cat are removed.
  Future<String> savePhoto(String catId, File source, int nowMillis) async {
    final dir = profileDir(catId);
    await dir.create(recursive: true);
    await for (final entity in dir.list()) {
      if (entity is File && _isPhotoFile(entity.path)) {
        await entity.delete();
      }
    }
    final target = File('${dir.path}/photo_$nowMillis.jpg');
    await source.copy(target.path);
    return 'profiles/$catId/photo_$nowMillis.jpg';
  }

  /// Copies a finished cue recording into the profile cue directory and
  /// returns its relative path (one file per cue type; replaces existing).
  Future<String> saveCueRecording(
    String catId,
    String cueTypeName,
    File source,
  ) async {
    final dir = cueDir(catId);
    await dir.create(recursive: true);
    final target = File('${dir.path}/$cueTypeName.m4a');
    if (target.existsSync()) await target.delete();
    await source.copy(target.path);
    return 'profiles/$catId/cues/$cueTypeName.m4a';
  }

  Future<void> deleteRelative(String relativePath) async {
    final file = resolve(relativePath);
    if (file.existsSync()) await file.delete();
  }

  /// Removes every file belonging to a cat (photos and cue recordings).
  Future<void> deleteProfileTree(String catId) async {
    final dir = profileDir(catId);
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  /// Removes all profile media (used by "delete all application data").
  Future<void> deleteAllProfileTrees() async {
    final dir = Directory('${_documentsDir.path}/profiles');
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  /// Clears transient export artefacts after sharing completes.
  Future<void> clearExportDir() async {
    final dir = exportDir();
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  bool _isPhotoFile(String path) {
    final name = path.split(Platform.pathSeparator).last;
    return name.startsWith('photo_') && name.endsWith('.jpg');
  }
}
