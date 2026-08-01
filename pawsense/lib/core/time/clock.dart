/// Injectable clock so time-dependent logic is testable.
///
/// Storage rule: every persisted timestamp is UTC. Repositories and services
/// must obtain "now" through a [Clock], never `DateTime.now()` directly.
abstract class Clock {
  const Clock();

  DateTime nowUtc();
}

class SystemClock extends Clock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

/// Manually advanced clock for tests and simulations.
class FakeClock extends Clock {
  FakeClock(this._now) : assert(_now.isUtc, 'FakeClock must start in UTC');

  DateTime _now;

  @override
  DateTime nowUtc() => _now;

  void advance(Duration d) => _now = _now.add(d);

  set now(DateTime value) {
    assert(value.isUtc);
    _now = value;
  }
}
