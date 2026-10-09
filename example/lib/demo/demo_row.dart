import 'dart:async';

import 'package:flutter/material.dart';

/// One public method of the plugin, run from a row of the demo list.
///
/// [run] completes with a one-shot result; [listen] starts a live query
/// that keeps reporting through `report` until it is cancelled.
class DemoRow {
  const DemoRow(this.title, this.detail, {this.run, this.listen})
      : assert((run == null) != (listen == null));

  final String title;
  final String detail;
  final Future<String> Function()? run;
  final StreamSubscription<dynamic> Function(void Function(String) report)?
      listen;

  bool get isLive => listen != null;
}

/// Rows grouped by area, like the sections of the reader, writer,
/// observer and manager of HealthKitReporter.
class DemoSection {
  const DemoSection(this.title, this.rows,
      {this.icon = Icons.apps_rounded, this.footer});

  final String title;

  /// Shown next to the title
  final IconData icon;
  final String? footer;
  final List<DemoRow> rows;
}
