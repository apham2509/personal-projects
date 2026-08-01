import 'package:drift/drift.dart';

import '../../shared/models/enums.dart';

/// Persists a set of [FrustrationFlag]s as a stable, comma-separated list of
/// enum names (sorted by declaration order so equal sets encode identically).
class FrustrationFlagSetConverter
    extends TypeConverter<Set<FrustrationFlag>, String> {
  const FrustrationFlagSetConverter();

  @override
  Set<FrustrationFlag> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const {};
    return fromDb
        .split(',')
        .map((name) => FrustrationFlag.values.byName(name))
        .toSet();
  }

  @override
  String toSql(Set<FrustrationFlag> value) {
    final ordered = value.toList()..sort((a, b) => a.index.compareTo(b.index));
    return ordered.map((flag) => flag.name).join(',');
  }
}
