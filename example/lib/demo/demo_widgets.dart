import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'catalog_bloc.dart';
import 'demo_row.dart';
import 'setup_bloc.dart';

/// The large title over a pink heart gradient
class HealthAppBar extends StatelessWidget {
  const HealthAppBar({super.key});

  static const _heart = Color(0xFFFF2D55);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surfaceContainerLowest;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        expandedTitleScale: 1.5,
        titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
        title: Text('HealthKitReporter',
            style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface)),
        background: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _heart.withValues(alpha: 0.24),
                const Color(0xFFFF9500).withValues(alpha: 0.12),
                surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 24, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Every plugin method, live against Apple Health',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Icon(Icons.favorite_rounded,
                      size: 72, color: _heart.withValues(alpha: 0.9)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Whether Apple Health is available and the simulator data is ready
class SetupCard extends StatelessWidget {
  const SetupCard({super.key, required this.state, required this.onRetry});

  final SetupState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, color) = switch (state.status) {
      SetupStatus.checking || SetupStatus.preparing => (
          Icons.hourglass_top_rounded,
          colors.primary
        ),
      SetupStatus.ready => (Icons.check_circle_rounded, Colors.green),
      SetupStatus.unavailable => (Icons.heart_broken_rounded, colors.error),
      SetupStatus.failed => (Icons.error_rounded, colors.error),
    };
    final busy = state.status == SetupStatus.checking ||
        state.status == SetupStatus.preparing;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: busy
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: color))
                  : Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(state.message,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            if (state.status == SetupStatus.failed)
              IconButton(
                tooltip: 'Retry',
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
              ),
          ],
        ),
      ),
    );
  }
}

/// Search field and section chips
class CatalogFilter extends StatelessWidget {
  const CatalogFilter({
    super.key,
    required this.sections,
    required this.selected,
    required this.onSearch,
    required this.onSection,
  });

  final List<DemoSection> sections;
  final String? selected;
  final ValueChanged<String> onSearch;
  final ValueChanged<String?> onSection;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: onSearch,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search methods',
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _chip('All', Icons.apps_rounded, selected == null,
                  () => onSection(null)),
              for (final section in sections)
                _chip(section.title, section.icon, selected == section.title,
                    () => onSection(section.title)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(
          String label, IconData icon, bool selected, VoidCallback onTap) =>
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          avatar: selected ? null : Icon(icon, size: 18),
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
        ),
      );
}

/// One area of the plugin with its rows
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.section,
    required this.results,
    required this.live,
    required this.onTap,
  });

  final DemoSection section;
  final Map<DemoRow, RowResult> results;
  final Set<DemoRow> live;
  final ValueChanged<DemoRow> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
          child: Row(
            children: [
              Icon(section.icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(section.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${section.rows.length}',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: theme.colorScheme.outline)),
            ],
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (index, row) in section.rows.indexed) ...[
                if (index > 0) const Divider(height: 1, indent: 72),
                RowTile(
                  row: row,
                  result: results[row],
                  isLive: live.contains(row),
                  onTap: () => onTap(row),
                ),
              ],
            ],
          ),
        ),
        if (section.footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(section.footer!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline)),
          ),
      ],
    );
  }
}

/// A method: tap to run it, or to start and stop its live query
class RowTile extends StatelessWidget {
  const RowTile({
    super.key,
    required this.row,
    required this.result,
    required this.isLive,
    required this.onTap,
  });

  final DemoRow row;
  final RowResult? result;
  final bool isLive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final running = result?.status == RowStatus.running;
    final accent = row.isLive ? Colors.teal : colors.primary;
    return InkWell(
      onTap: running ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: accent.withValues(alpha: 0.12),
              child: running
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: accent))
                  : Icon(
                      row.isLive
                          ? (isLive
                              ? Icons.stop_rounded
                              : Icons.sensors_rounded)
                          : Icons.play_arrow_rounded,
                      color: accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(row.title,
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ),
                      if (isLive) ...[
                        const SizedBox(width: 8),
                        const LiveBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(row.detail,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant)),
                  if (result != null && !running) ResultPanel(result: result!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A pulsing "LIVE" label for running live queries
class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key});

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween(begin: 0.4, end: 1.0).animate(_pulse),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text('LIVE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
        ),
      );
}

/// The result of a row, tinted by its outcome; long-press copies it
class ResultPanel extends StatelessWidget {
  const ResultPanel({super.key, required this.result});

  final RowResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (result.status) {
      RowStatus.failure => theme.colorScheme.error,
      RowStatus.listening => Colors.teal,
      _ => Colors.green,
    };
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: result.text));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Result copied')));
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: color, width: 3)),
          ),
          child: Text(
            result.text,
            maxLines: 14,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'Menlo',
              height: 1.4,
              color: result.status == RowStatus.failure ? color : null,
            ),
          ),
        ),
      ),
    );
  }
}
