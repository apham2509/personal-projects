/// Small robust-statistics helpers shared by aggregation and insights.
library;

/// Median of [values]; null when empty. Does not mutate the input.
int? medianInt(Iterable<int> values) {
  final sorted = values.toList()..sort();
  if (sorted.isEmpty) return null;
  final mid = sorted.length ~/ 2;
  if (sorted.length.isOdd) return sorted[mid];
  return (sorted[mid - 1] + sorted[mid]) ~/ 2;
}

double? medianDouble(Iterable<double> values) {
  final sorted = values.toList()..sort();
  if (sorted.isEmpty) return null;
  final mid = sorted.length ~/ 2;
  if (sorted.length.isOdd) return sorted[mid];
  return (sorted[mid - 1] + sorted[mid]) / 2;
}

/// Exponentially weighted moving average step.
double ewma({
  required double? previous,
  required double sample,
  required double alpha,
}) => previous == null ? sample : alpha * sample + (1 - alpha) * previous;
