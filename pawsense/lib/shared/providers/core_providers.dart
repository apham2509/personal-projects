import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/files/file_service.dart';
import '../../core/time/clock.dart';
import '../../features/cat_profiles/data/cat_profile_repository.dart';
import '../../features/settings/data/settings_repository.dart';

/// Core infrastructure wiring. `fileServiceProvider` is overridden in
/// `main()` after async initialisation; tests override `databaseProvider`
/// with an in-memory database and `clockProvider` with a [FakeClock].
final clockProvider = Provider<Clock>((ref) => const SystemClock());

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
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
