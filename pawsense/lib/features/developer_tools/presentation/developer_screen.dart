import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../../../shared/providers/core_providers.dart';
import '../../personalisation/domain/algorithm_version.dart' as algo;
import '../../personalisation/domain/preference_scoring.dart';
import '../../play/presentation/session_launch.dart';
import '../data/demo_data_service.dart';

final demoDataServiceProvider = Provider<DemoDataService>(
  (ref) => DemoDataService(
    ref.watch(catProfileRepositoryProvider),
    ref.watch(sessionRepositoryProvider),
  ),
);

/// Debug-only simulation and inspection tools. Never routed in release
/// builds (the route itself checks kDebugMode).
///
/// Intentionally not localised: developer-facing, never shipped.
class DeveloperScreen extends ConsumerStatefulWidget {
  const DeveloperScreen({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen> {
  String? _selectedCatId;
  String _log = '';
  int _seed = 20260801;

  void _append(String line) => setState(() => _log = '$line\n$_log');

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(body: Center(child: Text('Debug builds only')));
    }
    final cats = ref.watch(activeProfilesProvider).value ?? const [];
    final selected = _selectedCatId ?? (cats.isEmpty ? null : cats.first.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Developer tools')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Algorithm: ${algo.algorithmVersion}   Seed: $_seed',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () async {
                      final id = await ref
                          .read(demoDataServiceProvider)
                          .seedDemoCat(seed: _seed);
                      _append('Seeded demo cat $id (seed $_seed)');
                      setState(() => _seed++);
                    },
                    child: const Text('Seed demo cat (thriving)'),
                  ),
                  FilledButton.tonal(
                    onPressed: () async {
                      final id = await ref
                          .read(demoDataServiceProvider)
                          .seedDemoCat(seed: _seed, struggling: true);
                      _append('Seeded struggling demo cat $id');
                      setState(() => _seed++);
                    },
                    child: const Text('Seed demo cat (struggling)'),
                  ),
                ],
              ),
              const Divider(height: 32),
              DropdownButtonFormField<String>(
                initialValue: selected,
                decoration: const InputDecoration(
                  labelText: 'Cat',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final cat in cats)
                    DropdownMenuItem(value: cat.id, child: Text(cat.name)),
                ],
                onChanged: (value) => setState(() => _selectedCatId = value),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: selected == null
                        ? null
                        : () async {
                            await ref
                                .read(preferenceRepositoryProvider)
                                .resetModel(selected);
                            _append('Reset learned model for $selected');
                          },
                    child: const Text('Reset learned model'),
                  ),
                  OutlinedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                            context.push(
                              '/play',
                              extra: SessionLaunch(
                                mode: SessionMode.freePlay,
                                catId: selected,
                                durationSeconds: 60,
                                soundEnabled: false,
                                replayConfig: const TrialConfiguration(
                                  preyType: PreyType.moth,
                                  movementStyle: MovementStyle.unpredictable,
                                  speedLevel: SpeedLevel.medium,
                                  sizeLevel: SizeLevel.medium,
                                  soundMode: SoundMode.silent,
                                  spawnZone: SpawnZone.centre,
                                ),
                              ),
                            );
                          },
                    child: const Text('Replay fixed configuration'),
                  ),
                ],
              ),
              const Divider(height: 32),
              if (selected != null) _StatsTable(catId: selected),
              const Divider(height: 32),
              Text('Log', style: Theme.of(context).textTheme.titleSmall),
              Text(_log, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsTable extends ConsumerWidget {
  const _StatsTable({required this.catId});

  final String catId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(_statsProvider(catId)).value ?? const [];
    const scorer = PreferenceScorer();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preference stats (decayed working counters)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (stats.isEmpty) const Text('No stats yet.'),
            for (final row in stats)
              Text(
                '${row.factorType.name}.${row.factorValue}: '
                'n=${row.impressions.toStringAsFixed(1)} '
                's=${row.successes.toStringAsFixed(1)} '
                'u=${scorer.utility(FactorStats(impressions: row.impressions, successes: row.successes, timeouts: row.timeouts, totalMisses: row.totalMisses, frustrationCount: row.frustrationCount, reactionTimeEwmaMs: row.reactionTimeEwmaMs, cumulativeReward: row.cumulativeReward)).toStringAsFixed(3)}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

final _statsProvider = StreamProvider.family<List<PreferenceStat>, String>(
  (ref, catId) => ref.watch(preferenceRepositoryProvider).watchStats(catId),
);
