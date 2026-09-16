/// Actual Flutter/Flame artwork and owner screens, rendered for visual review.
///
/// Run from pawsense/:
/// flutter test tool/capture_visual_previews_test.dart \
///   --dart-define=PAWSENSE_PREVIEW_DIR=/tmp/pawsense-preview
/// Add --dart-define=PAWSENSE_GENERATE_ICONS=true to regenerate native icons.
/// This tool is opt-in: ordinary `flutter test` does not write artwork.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/random/seeded_random.dart';
import 'package:pawsense/core/utils/vec2.dart';
import 'package:pawsense/features/play/domain/movement/movement_strategy.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/game/components/fish_component.dart';
import 'package:pawsense/features/play/game/components/moth_component.dart';
import 'package:pawsense/features/play/game/components/mouse_component.dart';
import 'package:pawsense/features/play/game/components/prey_component.dart';
import 'package:pawsense/features/play/game/paw_sense_game.dart';
import 'package:pawsense/shared/models/enums.dart';

import '../test/widget/harness.dart';

const _output = String.fromEnvironment('PAWSENSE_PREVIEW_DIR');
const _generateIcons = bool.fromEnvironment('PAWSENSE_GENERATE_ICONS');

void main() {
  testWidgets('capture real prey, native icon and owner screens', (
    tester,
  ) async {
    if (_output.isEmpty) return;
    final output = Directory(_output)..createSync(recursive: true);
    await tester.runAsync(() async {
      await _loadFonts();
      await _preySheet(output, highContrast: false);
      await _preySheet(output, highContrast: true);
      await _tabletFrames(output);
      await _icon(File('${output.path}/pawsense-icon.png'), 1024);
      if (_generateIcons) await _nativeIcons();
    });

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final app = TestApp.create();
    addTearDown(app.dispose);
    // Prepare real SQLite data before widgets subscribe to its streams.
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Mochi');
    });
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: boundaryKey, child: app.build()),
    );
    await pumpUntilFound(tester, find.text('Mochi'));
    await goTo(tester, '/intro');
    await pumpUntilFound(tester, find.text('Continue'));
    await _capture(tester, boundaryKey, '${output.path}/owner-intro-phone.png');

    await goTo(tester, '/profiles');
    await pumpUntilFound(tester, find.text('Mochi'));
    await _capture(
      tester,
      boundaryKey,
      '${output.path}/owner-picker-phone.png',
    );
    await tester.tap(find.text('Mochi'));
    await pumpUntilFound(tester, find.text('Play'));
    await _capture(tester, boundaryKey, '${output.path}/owner-home-phone.png');

    tester.view.physicalSize = const Size(1024, 768);
    await tester.pumpAndSettle();
    await _capture(tester, boundaryKey, '${output.path}/owner-home-tablet.png');
    expect(tester.takeException(), isNull);
    await tearDownApp(tester);
  });
}

Future<void> _loadFonts() async {
  // flutter_tester is <sdk>/bin/cache/artifacts/engine/<platform>/flutter_tester.
  var sdk = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 5; i++) {
    sdk = sdk.parent;
  }
  final root = Platform.environment['FLUTTER_ROOT'] ?? sdk.path;
  for (final family in ['Roboto', 'MaterialIcons']) {
    final loader = FontLoader(family);
    final names = family == 'Roboto'
        ? ['Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf']
        : ['MaterialIcons-Regular.otf'];
    for (final name in names) {
      final bytes = await File(
        '$root/bin/cache/artifacts/material_fonts/$name',
      ).readAsBytes();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }
}

Future<void> _capture(WidgetTester tester, GlobalKey key, String path) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    await _save(image, File(path));
  });
}

PreyComponent _prey(
  PreyType kind, {
  required double diameter,
  bool highContrast = false,
}) {
  final movement = MovementStrategy.create(
    style: MovementStyle.unpredictable,
    rng: SeededRandom(812),
    speed: defaultPlayTuning.speedFractionMedium,
    bounds: const Bounds2(0.18, 0.18, 1.15, 0.82),
    start: const Vec2(0.65, 0.45),
  );
  final rng = SeededRandom(42);
  return switch (kind) {
    PreyType.mouse => MouseComponent(
      tuning: defaultPlayTuning,
      strategy: movement,
      unitPx: 768,
      diameterPx: diameter,
      animationRng: rng,
      palette: highContrast
          ? MouseComponent.highContrastPalette
          : MouseComponent.regularPalette,
    ),
    PreyType.moth => MothComponent(
      tuning: defaultPlayTuning,
      strategy: movement,
      unitPx: 768,
      diameterPx: diameter,
      animationRng: rng,
      palette: highContrast
          ? MothComponent.highContrastPalette
          : MothComponent.regularPalette,
    ),
    PreyType.fish => FishComponent(
      tuning: defaultPlayTuning,
      strategy: movement,
      unitPx: 768,
      diameterPx: diameter,
      animationRng: rng,
      palette: highContrast
          ? FishComponent.highContrastPalette
          : FishComponent.regularPalette,
    ),
  };
}

void _label(
  Canvas canvas,
  String text,
  Offset offset, {
  double size = 20,
  Color color = const Color(0xFFBFCFC1),
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontFamily: 'Roboto', fontSize: size, color: color),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

Future<void> _preySheet(Directory output, {required bool highContrast}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..drawColor(PawSenseGame.backgroundColour, BlendMode.src);
  _label(
    canvas,
    'PawSense · ${highContrast ? 'high contrast' : 'regular'} prey · actual Canvas render',
    const Offset(32, 28),
    size: 26,
  );
  _label(
    canvas,
    'Successive movement phases (top) and catch response (last two columns)',
    const Offset(32, 65),
    size: 16,
  );
  for (var row = 0; row < PreyType.values.length; row++) {
    final kind = PreyType.values[row];
    final prey = _prey(kind, diameter: 148, highContrast: highContrast);
    prey.update(prey.spawnInSeconds);
    _label(canvas, kind.name, Offset(32, 148 + row * 210));
    for (var col = 0; col < 6; col++) {
      if (col == 4) prey.capture();
      for (var frame = 0; frame < (col >= 4 ? 8 : 13); frame++) {
        prey.update(1 / 60);
      }
      canvas.save();
      canvas.translate(155 + col * 170, 120 + row * 210);
      prey.render(canvas);
      canvas.restore();
    }
  }
  final picture = recorder.endRecording();
  await _save(
    await picture.toImage(1210, 750),
    File(
      '${output.path}/prey-${highContrast ? 'high-contrast' : 'regular'}.png',
    ),
  );
  picture.dispose();
}

Future<void> _tabletFrames(Directory output) async {
  final directory = Directory('${output.path}/animation')..createSync();
  for (final kind in PreyType.values) {
    final prey = _prey(
      kind,
      diameter: 768 * defaultPlayTuning.sizeFractionMedium,
    );
    prey.update(prey.spawnInSeconds);
    for (var frame = 0; frame < 48; frame++) {
      for (var tick = 0; tick < 3; tick++) {
        prey.update(1 / 60);
      }
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder)
        ..drawColor(PawSenseGame.backgroundColour, BlendMode.src);
      canvas.translate(
        prey.position.x - prey.diameterPx / 2,
        prey.position.y - prey.diameterPx / 2,
      );
      prey.render(canvas);
      final picture = recorder.endRecording();
      final image = await picture.toImage(1024, 768);
      final file = File(
        '${directory.path}/${kind.name}-${frame.toString().padLeft(2, '0')}.png',
      );
      await _save(image, file);
      if (frame == 18) {
        await file.copy('${output.path}/tablet-hunt-${kind.name}.png');
      }
      picture.dispose();
    }
  }
  await File('${output.path}/animation.html').writeAsString(
    '''<!doctype html>
<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>PawSense — actual prey animation review</title>
<style>body{margin:24px;background:#faf8f2;color:#243b30;font:16px system-ui}button,select{font:inherit;padding:10px;margin:0 12px 16px 0}img{width:min(100%,1024px);display:block;aspect-ratio:4/3;background:#101512;border-radius:18px}p{max-width:65ch}</style>
<h1>PawSense · tablet hunt</h1><p>Actual Flutter Canvas frames, sampled at 20 fps. This review page has controls; the cat-facing game has no text or buttons.</p>
<select id="prey"><option>mouse</option><option>moth</option><option>fish</option></select><button id="toggle">Pause</button><img id="frame" alt="Actual tablet hunting surface">
<script>let n=0,playing=true;const cache={};for(const p of ['mouse','moth','fish']){cache[p]=[];for(let i=0;i<48;i++){const im=new Image();im.src='animation/'+p+'-'+String(i).padStart(2,'0')+'.png';cache[p].push(im)}}const image=document.getElementById('frame'),prey=document.getElementById('prey'),button=document.getElementById('toggle');function draw(){image.src=cache[prey.value][n].src}prey.onchange=()=>{n=0;draw()};button.onclick=()=>{playing=!playing;button.textContent=playing?'Pause':'Play'};draw();setInterval(()=>{if(playing){n=(n+1)%48;draw()}},50)</script>''',
  );
}

/// Original PawSense cat-face mark. All geometry is in a 100×100 design space.
/// Keep the face inside the central safe area for launcher masking.
void _drawIcon(Canvas canvas, double size, {bool launch = false}) {
  canvas.scale(size / 100);
  const ink = Color(0xFF2C4638);
  const fur = Color(0xFFE3B895);
  const cream = Color(0xFFF5DDC4);
  const patch = Color(0xFFBE8061);
  canvas.drawColor(
    launch ? const Color(0xFFFAF8F2) : const Color(0xFFE0EBDD),
    BlendMode.src,
  );
  canvas.drawCircle(
    const Offset(50, 51),
    39,
    Paint()..color = const Color(0xFFF1F2E9),
  );
  final head = Path()
    ..moveTo(24, 46)
    ..cubicTo(22, 38, 20, 22, 25, 22)
    ..cubicTo(29, 22, 35, 29, 39, 33)
    ..quadraticBezierTo(50, 30, 62, 33)
    ..cubicTo(66, 29, 73, 22, 76, 22)
    ..cubicTo(81, 22, 78, 39, 77, 46)
    ..cubicTo(90, 63, 74, 78, 51, 79)
    ..cubicTo(28, 81, 11, 63, 24, 46)
    ..close();
  canvas.drawPath(head, Paint()..color = fur);
  canvas.drawPath(
    Path()
      ..moveTo(27, 29)
      ..lineTo(28, 41)
      ..lineTo(36, 36)
      ..close()
      ..moveTo(73, 29)
      ..lineTo(65, 36)
      ..lineTo(73, 41)
      ..close(),
    Paint()..color = patch,
  );
  canvas.drawPath(
    Path()
      ..moveTo(50, 34)
      ..cubicTo(44, 44, 36, 50, 36, 60)
      ..cubicTo(36, 73, 64, 74, 65, 60)
      ..cubicTo(65, 50, 56, 44, 50, 34)
      ..close(),
    Paint()..color = cream,
  );
  for (final x in [36.0, 65.0]) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, 52), width: 3.5, height: 6),
      Paint()..color = ink,
    );
    canvas.drawCircle(Offset(x + 0.4, 50.5), 0.8, Paint()..color = cream);
  }
  canvas.drawPath(
    Path()
      ..moveTo(46, 59)
      ..quadraticBezierTo(50, 57, 54, 59)
      ..lineTo(50, 63)
      ..close(),
    Paint()..color = patch,
  );
  final line = Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 1.6;
  canvas.drawPath(
    Path()
      ..moveTo(50, 63)
      ..lineTo(50, 65)
      ..quadraticBezierTo(47, 68, 44, 65)
      ..moveTo(50, 65)
      ..quadraticBezierTo(53, 68, 56, 65),
    line,
  );
  line
    ..strokeWidth = 1.1
    ..color = ink.withValues(alpha: 0.65);
  canvas.drawPath(
    Path()
      ..moveTo(30, 59)
      ..lineTo(19, 57)
      ..moveTo(30, 64)
      ..lineTo(20, 67)
      ..moveTo(71, 59)
      ..lineTo(82, 57)
      ..moveTo(71, 64)
      ..lineTo(81, 67),
    line,
  );
}

Future<void> _icon(File file, int size, {bool launch = false}) async {
  final recorder = ui.PictureRecorder();
  _drawIcon(Canvas(recorder), size.toDouble(), launch: launch);
  final picture = recorder.endRecording();
  await _save(await picture.toImage(size, size), file, rgb: true);
  picture.dispose();
}

Future<void> _nativeIcons() async {
  final contents =
      jsonDecode(
            await File(
              'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
            ).readAsString(),
          )
          as Map<String, dynamic>;
  final written = <String>{};
  for (final value in contents['images'] as List<dynamic>) {
    final item = value as Map<String, dynamic>;
    final filename = item['filename'] as String;
    if (!written.add(filename)) continue;
    final logical = double.parse((item['size'] as String).split('x').first);
    final scale = double.parse((item['scale'] as String).replaceAll('x', ''));
    await _icon(
      File('ios/Runner/Assets.xcassets/AppIcon.appiconset/$filename'),
      (logical * scale).round(),
    );
  }
  for (final entry in {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  }.entries) {
    await _icon(
      File('android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png'),
      entry.value,
    );
    await _icon(
      File('android/app/src/main/res/drawable-${entry.key}/launch_image.png'),
      entry.value * 2,
      launch: true,
    );
  }
  for (final scale in [1, 2, 3]) {
    await _icon(
      File(
        'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage${scale == 1 ? '' : '@${scale}x'}.png',
      ),
      120 * scale,
      launch: true,
    );
  }
}

Future<void> _save(ui.Image image, File file, {bool rgb = false}) async {
  final data = await image.toByteData(
    format: rgb ? ui.ImageByteFormat.rawRgba : ui.ImageByteFormat.png,
  );
  final bytes = data!.buffer.asUint8List();
  await file.parent.create(recursive: true);
  await file.writeAsBytes(
    rgb ? _rgbPng(bytes, image.width, image.height) : bytes,
  );
  image.dispose();
}

/// Encode opaque native icons as true RGB PNGs: iOS icons may not have an
/// alpha channel, even when every source pixel is opaque. Uses SDK zlib only.
Uint8List _rgbPng(Uint8List rgba, int width, int height) {
  final scanlines = BytesBuilder();
  for (var y = 0; y < height; y++) {
    scanlines.addByte(0);
    for (var x = 0; x < width; x++) {
      final offset = (y * width + x) * 4;
      scanlines.add(rgba.sublist(offset, offset + 3));
    }
  }
  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8)
    ..setUint8(9, 2);
  final output = BytesBuilder()..add([137, 80, 78, 71, 13, 10, 26, 10]);
  void chunk(String type, List<int> content) {
    final payload = [...ascii.encode(type), ...content];
    var crc = 0xffffffff;
    for (final byte in payload) {
      crc ^= byte;
      for (var bit = 0; bit < 8; bit++) {
        crc = crc & 1 == 1 ? 0xedb88320 ^ (crc >>> 1) : crc >>> 1;
      }
    }
    output.add(
      (ByteData(4)..setUint32(0, content.length)).buffer.asUint8List(),
    );
    output.add(payload);
    output.add(
      (ByteData(4)..setUint32(0, crc ^ 0xffffffff)).buffer.asUint8List(),
    );
  }

  chunk('IHDR', header.buffer.asUint8List());
  chunk('IDAT', zlib.encode(scanlines.takeBytes()));
  chunk('IEND', const []);
  return output.takeBytes();
}
