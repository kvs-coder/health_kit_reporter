import 'dart:async';

/// A business logic component built on plain streams:
/// events go in through [add], states come out of [states].
///
/// Every event is handed to [onEvent] as it arrives, so a slow event
/// (e.g. a HealthKit query) doesn't hold back the next ones.
/// [onEvent] reports new states with [emit].
abstract class Bloc<Event, State> {
  Bloc(this._state) {
    _subscription = _events.stream.listen(onEvent);
  }

  final _events = StreamController<Event>();
  final _states = StreamController<State>.broadcast();
  late final StreamSubscription<Event> _subscription;
  State _state;

  /// The latest state
  State get state => _state;

  /// Every new state, after [state]
  Stream<State> get states => _states.stream;

  bool get isClosed => _states.isClosed;

  /// Sends [event] to the bloc
  void add(Event event) {
    if (!_events.isClosed) _events.add(event);
  }

  /// Handles one event; call [emit] for every new state
  void onEvent(Event event);

  /// Publishes [state], unless it equals the current one or the bloc is closed
  void emit(State state) {
    if (isClosed || state == _state) return;
    _state = state;
    _states.add(state);
  }

  /// Stops taking events and closes [states]
  Future<void> close() async {
    await _subscription.cancel();
    await _events.close();
    await _states.close();
  }
}
