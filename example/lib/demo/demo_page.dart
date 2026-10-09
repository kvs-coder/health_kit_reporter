import 'package:flutter/material.dart';

import '../bloc/bloc_builder.dart';
import 'catalog.dart';
import 'catalog_bloc.dart';
import 'demo_widgets.dart';
import 'seeding.dart';
import 'setup_bloc.dart';

/// Lists every public method of the plugin, grouped by area.
/// Tap a row to run it; its result, live updates or error appear below it.
///
/// The page only renders: [SetupBloc] prepares the demo,
/// [CatalogBloc] runs the rows and keeps their results.
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _catalog = Catalog();
  late final _catalogBloc = CatalogBloc(_catalog.sections);
  late final _setupBloc = SetupBloc(
    authorize: _catalog.sections
        .expand((section) => section.rows)
        .firstWhere((row) => row.title == 'requestAuthorization')
        .run!,
    seed: Seeding.seed,
  )..add(const SetupStarted());

  @override
  void dispose() {
    _catalogBloc.close();
    _setupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      bloc: _catalogBloc,
      builder: (context, state) => Scaffold(
        floatingActionButton: state.live.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _catalogBloc.add(const LiveQueriesStopped()),
                icon: const Icon(Icons.stop_rounded),
                label: Text('Stop ${state.live.length} live '
                    '${state.live.length == 1 ? 'query' : 'queries'}'),
              ),
        body: CustomScrollView(
          slivers: [
            const HealthAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: BlocBuilder<SetupBloc, SetupState>(
                  bloc: _setupBloc,
                  builder: (context, setup) => SetupCard(
                    state: setup,
                    onRetry: () => _setupBloc.add(const SetupStarted()),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CatalogFilter(
                sections: state.sections,
                selected: state.section,
                onSearch: (query) => _catalogBloc.add(SearchChanged(query)),
                onSection: (title) => _catalogBloc.add(SectionSelected(title)),
              ),
            ),
            for (final section in state.visibleSections)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionCard(
                    section: section,
                    results: state.results,
                    live: state.live,
                    onTap: (row) => _catalogBloc.add(RowTapped(row)),
                  ),
                ),
              ),
            if (state.visibleSections.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No method matches the search')),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }
}
