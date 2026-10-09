import 'package:flutter/widgets.dart';

import 'bloc.dart';

/// Rebuilds with every state of [bloc], starting from its current one.
class BlocBuilder<B extends Bloc<dynamic, S>, S> extends StatelessWidget {
  const BlocBuilder({super.key, required this.bloc, required this.builder});

  final B bloc;
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) => StreamBuilder<S>(
        initialData: bloc.state,
        stream: bloc.states,
        builder: (context, snapshot) =>
            builder(context, snapshot.data ?? bloc.state),
      );
}
