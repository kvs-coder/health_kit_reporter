import 'dart:async';

import 'package:flutter/services.dart';

import '../bloc/bloc.dart';
import 'demo_row.dart';

/// What the user does with the catalog
sealed class CatalogEvent {
  const CatalogEvent();
}

/// Runs a one-shot row, or starts / stops a live one
final class RowTapped extends CatalogEvent {
  const RowTapped(this.row);

  final DemoRow row;
}

/// Stops every live query
final class LiveQueriesStopped extends CatalogEvent {
  const LiveQueriesStopped();
}

/// Shows the rows whose title or detail contain [query]
final class SearchChanged extends CatalogEvent {
  const SearchChanged(this.query);

  final String query;
}

/// Shows only the section with [title]; all of them when null
final class SectionSelected extends CatalogEvent {
  const SectionSelected(this.title);

  final String? title;
}

final class _LiveUpdated extends CatalogEvent {
  const _LiveUpdated(this.row, this.result);

  final DemoRow row;
  final RowResult result;
}

enum RowStatus { running, success, failure, listening }

/// The latest outcome of a row
class RowResult {
  const RowResult(this.status, this.text);

  final RowStatus status;
  final String text;
}

class CatalogState {
  const CatalogState({
    required this.sections,
    this.results = const {},
    this.live = const {},
    this.query = '',
    this.section,
  });

  final List<DemoSection> sections;
  final Map<DemoRow, RowResult> results;

  /// Rows whose live query runs
  final Set<DemoRow> live;
  final String query;

  /// The selected section's title; null shows all
  final String? section;

  /// The sections and rows the search and the selected section leave
  List<DemoSection> get visibleSections {
    final needle = query.trim().toLowerCase();
    return [
      for (final section in sections)
        if (this.section == null || section.title == this.section)
          DemoSection(
            section.title,
            [
              for (final row in section.rows)
                if (needle.isEmpty ||
                    row.title.toLowerCase().contains(needle) ||
                    row.detail.toLowerCase().contains(needle))
                  row
            ],
            icon: section.icon,
            footer: section.footer,
          ),
    ].where((section) => section.rows.isNotEmpty).toList();
  }

  CatalogState copyWith({
    Map<DemoRow, RowResult>? results,
    Set<DemoRow>? live,
    String? query,
    String? Function()? section,
  }) =>
      CatalogState(
        sections: sections,
        results: results ?? this.results,
        live: live ?? this.live,
        query: query ?? this.query,
        section: section != null ? section() : this.section,
      );
}

/// Runs the rows of the catalog and keeps their results and live queries
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(List<DemoSection> sections)
      : super(CatalogState(sections: sections));

  final _subscriptions = <DemoRow, StreamSubscription<dynamic>>{};

  @override
  void onEvent(CatalogEvent event) {
    switch (event) {
      case RowTapped(:final row) when row.isLive:
        _toggle(row);
      case RowTapped(:final row):
        _run(row);
      case LiveQueriesStopped():
        _stopAll();
      case SearchChanged(:final query):
        emit(state.copyWith(query: query));
      case SectionSelected(:final title):
        emit(state.copyWith(section: () => title));
      case _LiveUpdated(:final row, :final result):
        if (_subscriptions.containsKey(row)) _result(row, result);
    }
  }

  Future<void> _run(DemoRow row) async {
    if (state.results[row]?.status == RowStatus.running) return;
    _result(row, const RowResult(RowStatus.running, 'running…'));
    try {
      _result(row, RowResult(RowStatus.success, await row.run!()));
    } catch (error) {
      _result(row, RowResult(RowStatus.failure, describe(error)));
    }
  }

  void _toggle(DemoRow row) {
    final subscription = _subscriptions.remove(row);
    if (subscription != null) {
      subscription.cancel();
      emit(state.copyWith(
        live: {...state.live}..remove(row),
        results: {
          ...state.results,
          row: const RowResult(RowStatus.success, 'stopped')
        },
      ));
      return;
    }
    _subscriptions[row] = row.listen!((update) =>
        add(_LiveUpdated(row, RowResult(RowStatus.listening, update))));
    emit(state.copyWith(
      live: {...state.live, row},
      results: {
        ...state.results,
        row: const RowResult(RowStatus.listening, 'listening…')
      },
    ));
  }

  void _stopAll() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    emit(state.copyWith(
      live: const {},
      results: {...state.results}..removeWhere((row, _) => row.isLive),
    ));
  }

  void _result(DemoRow row, RowResult result) =>
      emit(state.copyWith(results: {...state.results, row: result}));

  @override
  Future<void> close() async {
    _stopAll();
    await super.close();
  }

  /// A platform error as its method and message, anything else as is
  static String describe(Object error) =>
      error is PlatformException ? '${error.code}: ${error.message}' : '$error';
}
