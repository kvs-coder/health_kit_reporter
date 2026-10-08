import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';

import 'catalog.dart';
import 'demo_row.dart';
import 'seeding.dart';

/// Lists every public method of the plugin, grouped by area.
/// Tap a row to run it; its result, live updates or error appear in the row.
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _catalog = Catalog();
  final _results = <DemoRow, _Result>{};
  final _live = <DemoRow, StreamSubscription<dynamic>>{};
  String? _header;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void dispose() {
    _stopLiveQueries();
    super.dispose();
  }

  /// In the simulator, authorizes and seeds a week of data on the first launch of the day
  Future<void> _prepare() async {
    if (!await HealthKitReporter.isAvailable()) {
      setState(() => _header = 'Apple Health is not available on this device');
      return;
    }
    if (!_isSimulator) return;
    setState(() => _header = 'Simulator: authorizing and seeding demo data…');
    try {
      final authorization = _catalog.sections.first.rows
          .firstWhere((row) => row.title == 'requestAuthorization');
      await authorization.run!();
      final seeded = await Seeding.seed();
      setState(() => _header = seeded);
    } catch (error) {
      setState(() => _header = _message(error));
    }
  }

  /// Apps in the iOS simulator run from the CoreSimulator device folders
  static bool get _isSimulator =>
      Platform.environment.containsKey('SIMULATOR_UDID') ||
      Platform.resolvedExecutable.contains('/CoreSimulator/');

  Future<void> _tap(DemoRow row) async {
    if (row.isLive) {
      final active = _live.remove(row);
      if (active != null) {
        await active.cancel();
        setState(() => _results[row] = const _Result('stopped'));
        return;
      }
      setState(() => _results[row] = const _Result('listening…'));
      _live[row] = row.listen!((update) {
        if (mounted) setState(() => _results[row] = _Result(update));
      });
      return;
    }
    setState(() => _results[row] = const _Result('running…', running: true));
    try {
      final result = await row.run!();
      if (mounted) setState(() => _results[row] = _Result(result));
    } catch (error) {
      if (mounted) {
        setState(() => _results[row] = _Result(_message(error), error: true));
      }
    }
  }

  void _stopLiveQueries() {
    for (final subscription in _live.values) {
      subscription.cancel();
    }
    _live.clear();
  }

  static String _message(Object error) =>
      error is PlatformException ? '${error.code}: ${error.message}' : '$error';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthKitReporter'),
        actions: [
          TextButton(
            onPressed: _live.isEmpty
                ? null
                : () => setState(() {
                      _stopLiveQueries();
                      _results.removeWhere((row, _) => row.isLive);
                    }),
            child: const Text('Stop live queries'),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (_header != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_header!, style: theme.textTheme.bodySmall),
            ),
          for (final section in _catalog.sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
              child: Text(section.title.toUpperCase(),
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: theme.colorScheme.primary)),
            ),
            for (final row in section.rows) _tile(row, theme),
            if (section.footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Text(section.footer!, style: theme.textTheme.bodySmall),
              ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _tile(DemoRow row, ThemeData theme) {
    final result = _results[row];
    final isListening = _live.containsKey(row);
    return ListTile(
      title: Text(row.title),
      trailing: row.isLive
          ? Icon(isListening ? Icons.stop_circle_outlined : Icons.sensors)
          : result?.running == true
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.play_arrow),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.detail),
          if (result != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SelectableText(
                result.text,
                maxLines: 12,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'Menlo',
                  color: result.error ? theme.colorScheme.error : null,
                ),
              ),
            ),
        ],
      ),
      onTap: result?.running == true ? null : () => _tap(row),
    );
  }
}

class _Result {
  const _Result(this.text, {this.error = false, this.running = false});

  final String text;
  final bool error;
  final bool running;
}
