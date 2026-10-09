import 'predicate.dart';

/// Equivalent of [QueryDescriptor]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// One sample type and predicate of a query that reads several types at once,
/// see [HealthKitReporter.sampleQueryWithDescriptors].
///
/// For native calls the instance will be mapped to [map].
///
class QueryDescriptor {
  const QueryDescriptor(
    this.identifier, [
    this.predicate,
  ]);

  final String identifier;

  /// Narrows the samples of this type; all of them when null
  final Predicate? predicate;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'identifier': identifier,
        ...?predicate?.map,
      };
}
