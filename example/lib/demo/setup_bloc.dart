import 'dart:io';

import 'package:health_kit_reporter/health_kit_reporter.dart';

import '../bloc/bloc.dart';
import 'catalog_bloc.dart';

/// Prepares the demo when it starts
sealed class SetupEvent {
  const SetupEvent();
}

/// Checks Apple Health; in the simulator also authorizes and seeds a week of data
final class SetupStarted extends SetupEvent {
  const SetupStarted();
}

enum SetupStatus { checking, unavailable, preparing, ready, failed }

class SetupState {
  const SetupState(this.status, this.message);

  final SetupStatus status;
  final String message;
}

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc({
    required this.authorize,
    required this.seed,
    Future<bool> Function()? isAvailable,
    bool? isSimulator,
  })  : _isAvailable = isAvailable ?? HealthKitReporter.isAvailable,
        _isSimulator = isSimulator ?? _runsInSimulator,
        super(const SetupState(SetupStatus.checking, 'Checking Apple Health…'));

  /// Requests the demo's authorization
  final Future<String> Function() authorize;

  /// Writes the simulator data
  final Future<String> Function() seed;
  final Future<bool> Function() _isAvailable;
  final bool _isSimulator;

  @override
  Future<void> onEvent(SetupEvent event) async {
    switch (event) {
      case SetupStarted():
        await _start();
    }
  }

  Future<void> _start() async {
    try {
      if (!await _isAvailable()) {
        emit(const SetupState(SetupStatus.unavailable,
            'Apple Health is not available on this device'));
        return;
      }
      if (!_isSimulator) {
        emit(const SetupState(SetupStatus.ready, 'Apple Health is available'));
        return;
      }
      emit(const SetupState(
          SetupStatus.preparing, 'Authorizing and seeding demo data…'));
      await authorize();
      emit(SetupState(SetupStatus.ready, await seed()));
    } catch (error) {
      emit(SetupState(SetupStatus.failed, CatalogBloc.describe(error)));
    }
  }

  /// Apps in the iOS simulator run from the CoreSimulator device folders
  static bool get _runsInSimulator =>
      Platform.environment.containsKey('SIMULATOR_UDID') ||
      Platform.resolvedExecutable.contains('/CoreSimulator/');
}
