import 'package:flutter/material.dart';

import 'demo/demo_page.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthKitReporter',
      theme: ThemeData(colorSchemeSeed: Colors.pink, useMaterial3: true),
      darkTheme: ThemeData(
          colorSchemeSeed: Colors.pink,
          brightness: Brightness.dark,
          useMaterial3: true),
      home: const DemoPage(),
    );
  }
}
