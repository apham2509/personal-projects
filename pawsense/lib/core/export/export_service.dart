import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';

import '../../app/app_config.dart';
import '../../features/personalisation/domain/algorithm_version.dart' as algo;
import '../../shared/models/enums.dart';
import '../database/app_database.dart';
import '../files/file_service.dart';
import '../time/clock.dart';

/// Builds owner-facing exports of all behavioural data.
///
/// V1 exports never include media (photos, voice recordings) — only cue
/// *metadata* — per DECISIONS.md D-007; the JSON/CSV therefore stays small,
/// deterministic, and shareable through any target. All files are written
/// to the transient export directory which callers clear after sharing.
class ExportService {
  ExportService(this._db, this._files, this._clock);

  final AppDatabase _db;
  final FileService _files;
  final Clock _clock;

  static const exportFormatVersion = 1;

  String _iso(DateTime? value) => value == null ? '' : value.toIso8601String();

  /// Full JSON export; [catId] limits to one cat (mixed sessions are
  /// included only in full exports since they belong to nobody).
  Future<Map<String, dynamic>> buildJson({String? catId}) async {
    final cats =
        await (_db.select(_db.catProfiles)..where(
              (c) => catId == null ? const Constant(true) : c.id.equals(catId),
            ))
            .get();

    final sessions =
        await (_db.select(_db.sessions)..where(
              (s) =>
                  catId == null ? const Constant(true) : s.catId.equals(catId),
            ))
            .get();
    final sessionIds = sessions.map((s) => s.id).toList();
    final trials = sessionIds.isEmpty
        ? <TargetTrial>[]
        : await (_db.select(
            _db.targetTrials,
          )..where((t) => t.sessionId.isIn(sessionIds))).get();
    final touches = sessionIds.isEmpty
        ? <TouchEvent>[]
        : await (_db.select(
            _db.touchEvents,
          )..where((t) => t.sessionId.isIn(sessionIds))).get();
    final stats =
        await (_db.select(_db.preferenceStats)..where(
              (s) =>
                  catId == null ? const Constant(true) : s.catId.equals(catId),
            ))
            .get();
    final cueProgress =
        await (_db.select(_db.cueProgress)..where(
              (c) =>
                  catId == null ? const Constant(true) : c.catId.equals(catId),
            ))
            .get();
    final voiceCues =
        await (_db.select(_db.voiceCues)..where(
              (c) =>
                  catId == null ? const Constant(true) : c.catId.equals(catId),
            ))
            .get();

    final trialsBySession = <String, List<TargetTrial>>{};
    for (final trial in trials) {
      trialsBySession.putIfAbsent(trial.sessionId, () => []).add(trial);
    }
    final touchesBySession = <String, List<TouchEvent>>{};
    for (final touch in touches) {
      touchesBySession.putIfAbsent(touch.sessionId, () => []).add(touch);
    }

    Map<String, dynamic> sessionJson(Session s) => {
      'id': s.id,
      'catId': s.catId,
      'mode': s.mode.name,
      'startedAtUtc': _iso(s.startedAtUtc),
      'endedAtUtc': _iso(s.endedAtUtc),
      'plannedDurationSeconds': s.plannedDurationSeconds,
      'actualDurationMs': s.actualDurationMs,
      'status': s.status.name,
      'calibrationSession': s.calibrationSession,
      'randomSeed': s.randomSeed,
      'algorithmVersion': s.algorithmVersion,
      'appVersion': s.appVersion,
      'platform': s.platform,
      'screenWidthLogical': s.screenWidthLogical,
      'screenHeightLogical': s.screenHeightLogical,
      'ownerSubjectiveFeedback': s.ownerSubjectiveFeedback?.name,
      'catches': s.catches,
      'misses': s.misses,
      'timeouts': s.timeouts,
      'medianReactionMs': s.medianReactionMs,
      'frustrationCount': s.frustrationCount,
      'trials': [
        for (final t in trialsBySession[s.id] ?? const <TargetTrial>[])
          {
            'id': t.id,
            'trialIndex': t.trialIndex,
            'targetType': t.targetType.name,
            'movementStyle': t.movementStyle.name,
            'speedLevel': t.speedLevel.name,
            'sizeLevel': t.sizeLevel.name,
            'soundMode': t.soundMode.name,
            'spawnZone': t.spawnZone.name,
            'spawnedAtUtc': _iso(t.spawnedAtUtc),
            'becameTouchableAtUtc': _iso(t.becameTouchableAtUtc),
            'endedAtUtc': _iso(t.endedAtUtc),
            'spawnXNormalised': t.spawnXNormalised,
            'spawnYNormalised': t.spawnYNormalised,
            'targetPathSeed': t.targetPathSeed,
            'success': t.success,
            'firstSuccessfulTouchAtUtc': _iso(t.firstSuccessfulTouchAtUtc),
            'reactionTimeMs': t.reactionTimeMs,
            'missCount': t.missCount,
            'timeout': t.timeout,
            'cueType': t.cueType?.name,
            'praiseCueType': t.praiseCueType?.name,
            'rewardReminderShown': t.rewardReminderShown,
            'frustrationSeverity': t.frustrationSeverity,
            'frustrationFlags': t.frustrationFlags.map((f) => f.name).toList(),
            'trialReward': t.trialReward,
            'difficultyAtTrial': t.difficultyAtTrial,
            'algorithmVersion': t.algorithmVersion,
          },
      ],
      'touchEvents': [
        for (final e in touchesBySession[s.id] ?? const <TouchEvent>[])
          {
            'id': e.id,
            'trialId': e.trialId,
            'pointerId': e.pointerId,
            'logicalInteractionId': e.logicalInteractionId,
            'occurredAtUtc': _iso(e.occurredAtUtc),
            'xNormalised': e.xNormalised,
            'yNormalised': e.yNormalised,
            'classification': e.classification.name,
            'deduplicated': e.deduplicated,
            'distanceFromTarget': e.distanceFromTarget,
          },
      ],
    };

    return {
      'export': {
        'formatVersion': exportFormatVersion,
        'appVersion': appVersion,
        'algorithmVersion': algo.algorithmVersion,
        'createdAtUtc': _iso(_clock.nowUtc()),
        'scope': catId ?? 'all',
        'includesMedia': false,
      },
      'cats': [
        for (final cat in cats)
          {
            'id': cat.id,
            'name': cat.name,
            'createdAtUtc': _iso(cat.createdAtUtc),
            'archivedAtUtc': _iso(cat.archivedAtUtc),
            'ageGroup': cat.ageGroup.name,
            'bodySize': cat.bodySize.name,
            'energyLevel': cat.energyLevel.name,
            'screenExperience': cat.screenExperience.name,
            'favouritePrey': cat.favouritePrey?.name,
            'soundSensitivity': cat.soundSensitivity.name,
            'treatMotivation': cat.treatMotivation.name,
            'mobilityConsideration': cat.mobilityConsideration.name,
            'visionConsideration': cat.visionConsideration.name,
            'hearingConsideration': cat.hearingConsideration.name,
            'primaryGoal': cat.primaryGoal.name,
            'notes': cat.notes,
            'onboardingVersion': cat.onboardingVersion,
            'calibrationState': cat.calibrationState.name,
            'currentDifficulty': cat.currentDifficulty,
            'algorithmVersion': cat.algorithmVersion,
          },
      ],
      'sessions': [for (final s in sessions) sessionJson(s)],
      'preferenceStats': [
        for (final s in stats)
          {
            'catId': s.catId,
            'factorType': s.factorType.name,
            'factorValue': s.factorValue,
            'impressions': s.impressions,
            'successes': s.successes,
            'timeouts': s.timeouts,
            'totalMisses': s.totalMisses,
            'frustrationCount': s.frustrationCount,
            'reactionTimeEwmaMs': s.reactionTimeEwmaMs,
            'cumulativeReward': s.cumulativeReward,
            'algorithmVersion': s.algorithmVersion,
          },
      ],
      'cueProgress': [
        for (final c in cueProgress)
          {
            'catId': c.catId,
            'cueType': c.cueType.name,
            'exposures': c.exposures,
            'successfulResponses': c.successfulResponses,
            'reactionTimeEwmaMs': c.reactionTimeEwmaMs,
          },
      ],
      'voiceCueMetadata': [
        for (final v in voiceCues)
          {
            'catId': v.catId,
            'cueType': v.cueType.name,
            'durationMs': v.durationMs,
            'recordedAtUtc': _iso(v.updatedAtUtc),
          },
      ],
    };
  }

  /// Writes the JSON export to the export directory. Caller shares then
  /// clears the directory.
  Future<File> writeJsonFile({String? catId}) async {
    final json = await buildJson(catId: catId);
    final dir = _files.exportDir()..createSync(recursive: true);
    final stamp = _clock.nowUtc().millisecondsSinceEpoch;
    final file = File('${dir.path}/pawsense_export_$stamp.json');
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));
    return file;
  }

  /// Writes one CSV file per table and returns them (for multi-file share).
  Future<List<File>> writeCsvFiles({String? catId}) async {
    final json = await buildJson(catId: catId);
    final dir = _files.exportDir()..createSync(recursive: true);
    final codec = Csv(lineDelimiter: '\n');
    final files = <File>[];

    File write(String name, List<List<dynamic>> rows) {
      final file = File('${dir.path}/$name.csv');
      file.writeAsStringSync(codec.encode(rows));
      files.add(file);
      return file;
    }

    final cats = (json['cats'] as List).cast<Map<String, dynamic>>();
    if (cats.isNotEmpty) {
      write('cat_profiles', [
        cats.first.keys.toList(),
        for (final cat in cats) cat.values.toList(),
      ]);
    }

    final sessions = (json['sessions'] as List).cast<Map<String, dynamic>>();
    final sessionColumns = [
      'id',
      'catId',
      'mode',
      'startedAtUtc',
      'endedAtUtc',
      'plannedDurationSeconds',
      'actualDurationMs',
      'status',
      'calibrationSession',
      'randomSeed',
      'algorithmVersion',
      'appVersion',
      'platform',
      'screenWidthLogical',
      'screenHeightLogical',
      'ownerSubjectiveFeedback',
      'catches',
      'misses',
      'timeouts',
      'medianReactionMs',
      'frustrationCount',
    ];
    write('sessions', [
      sessionColumns,
      for (final s in sessions) [for (final c in sessionColumns) s[c]],
    ]);

    final trialRows = <List<dynamic>>[];
    final touchRows = <List<dynamic>>[];
    List<String>? trialColumns;
    const touchColumns = [
      'sessionId',
      'id',
      'trialId',
      'pointerId',
      'logicalInteractionId',
      'occurredAtUtc',
      'xNormalised',
      'yNormalised',
      'classification',
      'deduplicated',
      'distanceFromTarget',
    ];
    for (final s in sessions) {
      for (final t in (s['trials'] as List).cast<Map<String, dynamic>>()) {
        trialColumns ??= ['sessionId', ...t.keys.map((k) => k.toString())];
        trialRows.add([
          s['id'],
          for (final c in trialColumns.skip(1))
            c == 'frustrationFlags' ? (t[c] as List).join('|') : t[c],
        ]);
      }
      for (final e in (s['touchEvents'] as List).cast<Map<String, dynamic>>()) {
        touchRows.add([s['id'], for (final c in touchColumns.skip(1)) e[c]]);
      }
    }
    write('target_trials', [
      trialColumns ?? ['sessionId'],
      ...trialRows,
    ]);
    write('touch_events', [touchColumns, ...touchRows]);

    final stats = (json['preferenceStats'] as List)
        .cast<Map<String, dynamic>>();
    if (stats.isNotEmpty) {
      write('preference_stats', [
        stats.first.keys.toList(),
        for (final s in stats) s.values.toList(),
      ]);
    }
    final cueProgress = (json['cueProgress'] as List)
        .cast<Map<String, dynamic>>();
    if (cueProgress.isNotEmpty) {
      write('cue_progress', [
        cueProgress.first.keys.toList(),
        for (final c in cueProgress) c.values.toList(),
      ]);
    }
    final voiceCues = (json['voiceCueMetadata'] as List)
        .cast<Map<String, dynamic>>();
    if (voiceCues.isNotEmpty) {
      write('voice_cue_metadata', [
        voiceCues.first.keys.toList(),
        for (final v in voiceCues) v.values.toList(),
      ]);
    }
    return files;
  }

  /// Removes everything: all profiles (cascades), mixed sessions, media,
  /// and resets settings to first-launch defaults.
  Future<void> deleteAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.catProfiles).go();
      await _db.delete(_db.sessions).go(); // mixed sessions have no cat
      final settings = _db.update(_db.appSettings)
        ..where((s) => s.id.equals(1));
      await settings.write(
        const AppSettingsCompanion(
          defaultSessionDurationSeconds: Value(180),
          soundEnabled: Value(true),
          rewardSchedule: Value(RewardSchedule.none),
          maxRewardReminders: Value(3),
          ownerPinHash: Value(null),
          ownerPinSalt: Value(null),
          onboardingComplete: Value(false),
          privacyVersionAccepted: Value(0),
          preferredLocale: Value(null),
          reduceMotion: Value(false),
          highContrastMode: Value(false),
        ),
      );
    });
    await _files.deleteAllProfileTrees();
    await _files.clearExportDir();
  }
}
