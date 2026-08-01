import 'enums.dart';

/// One fully specified prey presentation.
///
/// Everything the game needs to spawn a target: what it looks like, how it
/// moves, how fast, how large, whether it makes sound, and roughly where it
/// first appears.
class TrialConfiguration {
  const TrialConfiguration({
    required this.preyType,
    required this.movementStyle,
    required this.speedLevel,
    required this.sizeLevel,
    required this.soundMode,
    required this.spawnZone,
  });

  final PreyType preyType;
  final MovementStyle movementStyle;
  final SpeedLevel speedLevel;
  final SizeLevel sizeLevel;
  final SoundMode soundMode;
  final SpawnZone spawnZone;

  /// The stored value of the given factor dimension, by enum name.
  String factorValue(FactorType factor) => switch (factor) {
    FactorType.targetType => preyType.name,
    FactorType.movementStyle => movementStyle.name,
    FactorType.speedLevel => speedLevel.name,
    FactorType.sizeLevel => sizeLevel.name,
    FactorType.soundMode => soundMode.name,
    FactorType.spawnZone => spawnZone.name,
  };

  TrialConfiguration copyWith({
    PreyType? preyType,
    MovementStyle? movementStyle,
    SpeedLevel? speedLevel,
    SizeLevel? sizeLevel,
    SoundMode? soundMode,
    SpawnZone? spawnZone,
  }) {
    return TrialConfiguration(
      preyType: preyType ?? this.preyType,
      movementStyle: movementStyle ?? this.movementStyle,
      speedLevel: speedLevel ?? this.speedLevel,
      sizeLevel: sizeLevel ?? this.sizeLevel,
      soundMode: soundMode ?? this.soundMode,
      spawnZone: spawnZone ?? this.spawnZone,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TrialConfiguration &&
        other.preyType == preyType &&
        other.movementStyle == movementStyle &&
        other.speedLevel == speedLevel &&
        other.sizeLevel == sizeLevel &&
        other.soundMode == soundMode &&
        other.spawnZone == spawnZone;
  }

  @override
  int get hashCode => Object.hash(
    preyType,
    movementStyle,
    speedLevel,
    sizeLevel,
    soundMode,
    spawnZone,
  );

  @override
  String toString() =>
      'TrialConfiguration(${preyType.name}, ${movementStyle.name}, '
      '${speedLevel.name}, ${sizeLevel.name}, ${soundMode.name}, '
      '${spawnZone.name})';
}
