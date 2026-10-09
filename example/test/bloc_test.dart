import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter_example/demo/catalog_bloc.dart';
import 'package:health_kit_reporter_example/demo/demo_row.dart';
import 'package:health_kit_reporter_example/demo/setup_bloc.dart';

void main() {
  final ok = DemoRow('ok', 'succeeds', run: () async => 'done');
  final failing = DemoRow('failing', 'fails',
      run: () async =>
          throw PlatformException(code: 'save', message: 'denied'));
  final updates = StreamController<String>.broadcast();
  final live = DemoRow('live', 'reports',
      listen: (report) => updates.stream.listen(report));
  final sections = [
    DemoSection('Reader', [ok, failing]),
    DemoSection('Live', [live]),
  ];

  late CatalogBloc sut;
  setUp(() => sut = CatalogBloc(sections));
  tearDown(() => sut.close());

  test('a_row_reports_running_then_its_result', () async {
    final states =
        sut.states.map((e) => e.results[ok]?.status).take(2).toList();
    sut.add(RowTapped(ok));
    expect(await states, [RowStatus.running, RowStatus.success]);
    expect(sut.state.results[ok]?.text, 'done');
  });

  test('a_failing_row_reports_the_platform_error', () async {
    sut.add(RowTapped(failing));
    await sut.states
        .firstWhere((e) => e.results[failing]?.status == RowStatus.failure);
    expect(sut.state.results[failing]?.text, 'save: denied');
  });

  test('a_live_row_reports_updates_until_tapped_again', () async {
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.contains(live));
    updates.add('1 update');
    await sut.states.firstWhere((e) => e.results[live]?.text == '1 update');
    expect(sut.state.results[live]?.status, RowStatus.listening);
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.isEmpty);
    updates.add('ignored');
    await pumpEventQueue();
    expect(sut.state.results[live]?.text, 'stopped');
    expect(updates.hasListener, isFalse);
  });

  test('stopping_all_live_queries_clears_their_results', () async {
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.contains(live));
    sut.add(const LiveQueriesStopped());
    await sut.states.firstWhere((e) => e.live.isEmpty);
    expect(sut.state.results.containsKey(live), isFalse);
  });

  test('search_and_section_filter_the_rows', () async {
    sut.add(const SearchChanged('FAIL'));
    await sut.states.first;
    expect(sut.state.visibleSections.single.rows, [failing]);
    sut
      ..add(const SearchChanged(''))
      ..add(const SectionSelected('Live'));
    await sut.states.firstWhere((e) => e.section == 'Live');
    expect(sut.state.visibleSections.single.title, 'Live');
    sut.add(const SectionSelected(null));
    await sut.states.first;
    expect(sut.state.visibleSections, hasLength(2));
  });

  group('setup', () {
    Future<List<SetupStatus>> statuses(SetupBloc bloc) =>
        bloc.states.map((e) => e.status).take(2).toList();

    test('simulator_authorizes_and_seeds', () async {
      final bloc = SetupBloc(
        authorize: () async => 'authorized',
        seed: () async => 'Seeded 7 samples',
        isAvailable: () async => true,
        isSimulator: true,
      );
      final result = statuses(bloc);
      bloc.add(const SetupStarted());
      expect(await result, [SetupStatus.preparing, SetupStatus.ready]);
      expect(bloc.state.message, 'Seeded 7 samples');
      await bloc.close();
    });

    test('device_without_health_is_unavailable', () async {
      final bloc = SetupBloc(
        authorize: () async => fail('no authorization'),
        seed: () async => fail('no seeding'),
        isAvailable: () async => false,
        isSimulator: false,
      );
      bloc.add(const SetupStarted());
      expect((await bloc.states.first).status, SetupStatus.unavailable);
      await bloc.close();
    });

    test('an_unanswered_authorization_times_out', () async {
      final bloc = SetupBloc(
        authorize: () => Completer<String>().future,
        seed: () async => fail('no seeding'),
        isAvailable: () async => true,
        isSimulator: true,
        authorizationTimeout: const Duration(milliseconds: 10),
      );
      bloc.add(const SetupStarted());
      final failed =
          await bloc.states.firstWhere((e) => e.status == SetupStatus.failed);
      expect(failed.message, contains("didn't answer"));
      await bloc.close();
    });

    test('a_failing_seed_is_reported', () async {
      final bloc = SetupBloc(
        authorize: () async => 'authorized',
        seed: () async => throw PlatformException(
            code: 'saveSamples', message: 'Not authorized'),
        isAvailable: () async => true,
        isSimulator: true,
      );
      bloc.add(const SetupStarted());
      final failed =
          await bloc.states.firstWhere((e) => e.status == SetupStatus.failed);
      expect(failed.message, 'saveSamples: Not authorized');
      await bloc.close();
    });
  });
}
