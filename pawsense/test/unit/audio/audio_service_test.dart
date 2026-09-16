import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/audio/audio_service.dart';

class DelayedCuePlayer implements CuePlayer {
  final events = StreamController<void>.broadcast(sync: true);
  final calls = <String>[];
  Completer<void>? stopGate;
  Completer<void>? sourceGate;
  Completer<void>? resumeGate;
  bool failSource = false;
  bool playing = false;

  @override
  Stream<void> get onComplete => events.stream;

  @override
  Future<void> stop() async {
    calls.add('stop');
    final gate = stopGate;
    stopGate = null;
    await gate?.future;
    playing = false;
  }

  @override
  Future<void> setSourceFile(String path) async {
    calls.add('source:$path');
    final gate = sourceGate;
    sourceGate = null;
    await gate?.future;
    if (failSource) throw StateError('cannot decode cue');
  }

  @override
  Future<void> resume() async {
    calls.add('resume');
    final gate = resumeGate;
    resumeGate = null;
    await gate?.future;
    playing = true;
  }

  @override
  Future<void> dispose() async {
    calls.add('dispose');
    playing = false;
    await events.close();
  }
}

void main() {
  testWidgets('stop during native startup prevents delayed voice playback', (
    tester,
  ) async {
    final stopGate = Completer<void>();
    final player = DelayedCuePlayer()..stopGate = stopGate;
    final audio = AudioService(cuePlayerFactory: () => player);
    var completed = false;
    unawaited(audio.playCueFile('/touch.m4a').then((_) => completed = true));
    await tester.pump();
    expect(player.calls, ['stop']);

    final stopped = audio.stopCue();
    await tester.pump();
    expect(
      completed,
      isTrue,
      reason: 'stop settles the controller immediately',
    );
    stopGate.complete();
    await tester.pump();
    await stopped;
    expect(player.calls, ['stop', 'stop']);
    expect(player.playing, isFalse);
    await audio.dispose();
  });

  testWidgets(
    'stop during file preparation prevents resume and cancels its guard',
    (tester) async {
      final sourceGate = Completer<void>();
      final player = DelayedCuePlayer()..sourceGate = sourceGate;
      final audio = AudioService(cuePlayerFactory: () => player);
      final cue = audio.playCueFile('/touch.m4a');
      await tester.pump();
      expect(player.calls, ['stop', 'source:/touch.m4a']);
      final stopped = audio.stopCue();
      sourceGate.complete();
      await tester.pump();
      await stopped;
      await cue;
      expect(player.calls, isNot(contains('resume')));
      final stoppedCalls = List<String>.of(player.calls);
      await tester.pump(const Duration(seconds: 7));
      expect(
        player.calls,
        stoppedCalls,
        reason: 'cancelled timer must do nothing',
      );
      await audio.dispose();
    },
  );

  testWidgets('stop during native resume is applied after resume completes', (
    tester,
  ) async {
    final resumeGate = Completer<void>();
    final player = DelayedCuePlayer()..resumeGate = resumeGate;
    final audio = AudioService(cuePlayerFactory: () => player);
    final cue = audio.playCueFile('/touch.m4a');
    await tester.pump();
    expect(player.calls.last, 'resume');
    final stopped = audio.stopCue();
    resumeGate.complete();
    await tester.pump();
    await stopped;
    await cue;
    expect(player.calls.last, 'stop');
    expect(player.playing, isFalse);
    await audio.dispose();
  });

  testWidgets('dispose invalidates pending preparation and runs exactly once', (
    tester,
  ) async {
    final sourceGate = Completer<void>();
    final player = DelayedCuePlayer()..sourceGate = sourceGate;
    final audio = AudioService(cuePlayerFactory: () => player);
    var completed = false;
    unawaited(audio.playCueFile('/touch.m4a').then((_) => completed = true));
    await tester.pump();
    final disposing = audio.dispose();
    await tester.pump();
    expect(completed, isTrue);
    sourceGate.complete();
    await tester.pump();
    await disposing;
    await audio.dispose();
    await audio.playCueFile('/after-dispose.m4a');
    await audio.stopCue();
    expect(player.calls, ['stop', 'source:/touch.m4a', 'dispose']);
    expect(player.playing, isFalse);
  });

  testWidgets(
    'replacement cancels the old waiter and only starts the newest cue',
    (tester) async {
      final stopGate = Completer<void>();
      final player = DelayedCuePlayer()..stopGate = stopGate;
      final audio = AudioService(cuePlayerFactory: () => player);
      var oldCompleted = false;
      var newCompleted = false;
      unawaited(audio.playCueFile('/old.m4a').then((_) => oldCompleted = true));
      await tester.pump();
      unawaited(audio.playCueFile('/new.m4a').then((_) => newCompleted = true));
      await tester.pump();
      expect(oldCompleted, isTrue);
      expect(newCompleted, isFalse);
      stopGate.complete();
      await tester.pump();
      expect(player.calls, ['stop', 'stop', 'source:/new.m4a', 'resume']);
      player.events.add(null);
      await tester.pump();
      expect(newCompleted, isTrue);
      await tester.pump(const Duration(seconds: 7));
      expect(player.calls.last, 'resume', reason: 'completion cancels timeout');
      await audio.dispose();
    },
  );

  testWidgets('guard bounds a stalled source and prevents its late resume', (
    tester,
  ) async {
    final sourceGate = Completer<void>();
    final player = DelayedCuePlayer()..sourceGate = sourceGate;
    final audio = AudioService(cuePlayerFactory: () => player);
    var completed = false;
    unawaited(audio.playCueFile('/stalled.m4a').then((_) => completed = true));
    await tester.pump();
    await tester.pump(const Duration(seconds: 6));
    expect(completed, isTrue);
    sourceGate.complete();
    await tester.pump();
    expect(player.calls, ['stop', 'source:/stalled.m4a', 'stop']);
    expect(player.playing, isFalse);
    await audio.dispose();
  });

  testWidgets('failed cue settles and does not poison the next playback', (
    tester,
  ) async {
    final player = DelayedCuePlayer()..failSource = true;
    final audio = AudioService(cuePlayerFactory: () => player);
    final failed = audio.playCueFile('/broken.m4a');
    await tester.pump();
    await failed;
    expect(player.calls, isNot(contains('resume')));
    player.failSource = false;
    final good = audio.playCueFile('/good.m4a');
    await tester.pump();
    expect(player.calls.last, 'resume');
    player.events.add(null);
    await tester.pump();
    await good;
    await audio.dispose();
  });
}
