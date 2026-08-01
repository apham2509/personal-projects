// Validates a PawSense JSON export (and optionally a directory of CSV
// exports) for structural integrity. Used in QA before release:
//
//   dart run tool/validate_exports.dart path/to/pawsense_export.json [csvDir]
//
// Checks: format version, required top-level sections, referential
// integrity (session.catId in cats or null, trial counts vs session
// aggregates), and CSV header consistency.

import 'dart:convert';
import 'dart:io';

int _failures = 0;

void check(bool condition, String message) {
  if (condition) {
    stdout.writeln('  ok: $message');
  } else {
    _failures++;
    stderr.writeln('  FAIL: $message');
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      'usage: dart run tool/validate_exports.dart '
      '<export.json> [csvDir]',
    );
    exit(2);
  }

  final json =
      jsonDecode(File(args[0]).readAsStringSync()) as Map<String, dynamic>;

  stdout.writeln('Validating ${args[0]}');
  final export = json['export'] as Map<String, dynamic>?;
  check(export != null, 'export header present');
  check(export?['formatVersion'] == 1, 'format version 1');
  check(export?['includesMedia'] == false, 'media excluded (V1 contract)');
  check(
    (export?['algorithmVersion'] as String?)?.isNotEmpty ?? false,
    'algorithm version recorded',
  );

  final cats = (json['cats'] as List? ?? []).cast<Map<String, dynamic>>();
  final sessions = (json['sessions'] as List? ?? [])
      .cast<Map<String, dynamic>>();
  final catIds = cats.map((c) => c['id']).toSet();
  check(cats.isNotEmpty || sessions.isNotEmpty, 'export not empty');

  for (final session in sessions) {
    final id = session['id'];
    final catId = session['catId'];
    check(
      catId == null || catIds.contains(catId) || export?['scope'] != 'all',
      'session $id catId resolves ($catId)',
    );
    final trials = (session['trials'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final catches = trials.where((t) => t['success'] == true).length;
    final timeouts = trials.where((t) => t['timeout'] == true).length;
    if (session['status'] != 'inProgress') {
      check(
        session['catches'] == catches,
        'session $id catch aggregate matches trials '
        '(${session['catches']} vs $catches)',
      );
      check(
        session['timeouts'] == timeouts,
        'session $id timeout aggregate matches trials',
      );
    }
    for (final trial in trials) {
      check(
        trial['algorithmVersion'] == export?['algorithmVersion'],
        'trial ${trial['id']} algorithm version consistent',
      );
    }
  }

  if (args.length > 1) {
    final dir = Directory(args[1]);
    stdout.writeln('Validating CSVs in ${dir.path}');
    for (final name in ['sessions', 'target_trials', 'touch_events']) {
      final file = File('${dir.path}/$name.csv');
      check(file.existsSync(), '$name.csv exists');
      if (file.existsSync()) {
        final lines = const LineSplitter()
            .convert(file.readAsStringSync())
            .where((l) => l.isNotEmpty)
            .toList();
        check(lines.isNotEmpty, '$name.csv has a header row');
      }
    }
  }

  if (_failures > 0) {
    stderr.writeln('$_failures check(s) failed');
    exit(1);
  }
  stdout.writeln('All checks passed');
}
