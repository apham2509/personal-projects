import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/audio/audio_service.dart';
import '../../core/database/app_database.dart';
import '../../core/database/open.dart';
import '../../core/files/file_service.dart';
import '../../core/time/clock.dart';
import '../../features/cat_profiles/data/cat_profile_repository.dart';
import '../../features/personalisation/data/preference_repository.dart';
import '../../features/play/data/session_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../features/training/data/cue_progress_repository.dart';
import '../../features/voice_cues/data/voice_cue_repository.dart';

/// Core infrastructure wiring. `fileServiceProvider` is overridden in
/// `main()` after async initialisation; tests override `databaseProvider`
/// with an in-memory database and `clockProvider` with a [FakeClock].
final clockProvider = Provider<Clock>((ref) => const SystemClock());

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = openAppDatabase();
  ref.onDispose(db.close);
  return db;
});

final fileServiceProvider = Provider<FileService>(
  (ref) => throw UnimplementedError(
    'fileServiceProvider must be overridden at bootstrap',
  ),
);

final catProfileRepositoryProvider = Provider<CatProfileRepository>(
  (ref) => CatProfileRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
    ref.watch(uuidProvider),
    ref.watch(fileServiceProvider),
  ),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final settingsProvider = StreamProvider<AppSetting>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final activeProfilesProvider = StreamProvider<List<CatProfile>>(
  (ref) => ref.watch(catProfileRepositoryProvider).watchActive(),
);

final archivedProfilesProvider = StreamProvider<List<CatProfile>>(
  (ref) => ref.watch(catProfileRepositoryProvider).watchArchived(),
);

final catProfileProvider = StreamProvider.family<CatProfile?, String>(
  (ref, id) => ref.watch(catProfileRepositoryProvider).watchById(id),
);

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final preferenceRepositoryProvider = Provider<PreferenceRepository>(
  (ref) => PreferenceRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
    ref.watch(uuidProvider),
  ),
);

final cueProgressRepositoryProvider = Provider<CueProgressRepository>(
  (ref) => CueProgressRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
    ref.watch(uuidProvider),
  ),
);

final voiceCueRepositoryProvider = Provider<VoiceCueRepository>(
  (ref) => VoiceCueRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
    ref.watch(uuidProvider),
    ref.watch(fileServiceProvider),
  ),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
    ref.watch(uuidProvider),
    ref.watch(preferenceRepositoryProvider),
    ref.watch(cueProgressRepositoryProvider),
  ),
);

final sessionsForCatProvider = StreamProvider.family<List<Session>, String>(
  (ref, catId) =>
      ref.watch(sessionRepositoryProvider).watchSessionsForCat(catId),
);
