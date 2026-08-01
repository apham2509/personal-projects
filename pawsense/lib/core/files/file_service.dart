import 'dart:io';

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
///
/// Internals are synchronous on purpose: every file here is small (photos
/// around 1 MB, cues a few hundred KB), sync IO is deterministic under
/// widget tests' fake-async zone, and `avoid_slow_async_io` prefers it.
/// Signatures stay Future-returning so a move to an isolate later would not
/// ripple through callers.
class FileService {
  FileService(this._documentsDir);

  final Directory _documentsDir;

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
    dir.createSync(recursive: true);
    for (final entity in dir.listSync()) {
      if (entity is File && _isPhotoFile(entity.path)) {
        entity.deleteSync();
      }
    }
    final target = File('${dir.path}/photo_$nowMillis.jpg');
    source.copySync(target.path);
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
    dir.createSync(recursive: true);
    final target = File('${dir.path}/$cueTypeName.m4a');
    if (target.existsSync()) target.deleteSync();
    source.copySync(target.path);
    return 'profiles/$catId/cues/$cueTypeName.m4a';
  }

  Future<void> deleteRelative(String relativePath) async {
    final file = resolve(relativePath);
    if (file.existsSync()) file.deleteSync();
  }

  /// Removes every file belonging to a cat (photos and cue recordings).
  Future<void> deleteProfileTree(String catId) async {
    final dir = profileDir(catId);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }

  /// Removes all profile media (used by "delete all application data").
  Future<void> deleteAllProfileTrees() async {
    final dir = Directory('${_documentsDir.path}/profiles');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }

  /// Clears transient export artefacts after sharing completes.
  Future<void> clearExportDir() async {
    final dir = exportDir();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }

  bool _isPhotoFile(String path) {
    final name = path.split(Platform.pathSeparator).last;
    return name.startsWith('photo_') && name.endsWith('.jpg');
  }
}
