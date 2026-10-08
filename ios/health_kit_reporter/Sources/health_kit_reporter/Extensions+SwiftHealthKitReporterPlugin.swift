//
//  Extensions+SwiftHealthKitReporterPlugin.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 17.04.22.
//

import Flutter
import HealthKitReporter
// ObjectiveC declares a Category type too
import struct HealthKitReporter.Category

// MARK: - MethodCall
extension SwiftHealthKitReporterPlugin {
    enum Method: String {
        case isAvailable
        case supportsHealthRecords
        case requestAuthorization
        case requestPerObjectReadAuthorization
        case isWritable
        case preferredUnits
        case characteristicsQuery
        case quantityQuery
        case categoryQuery
        case workoutQuery
        case electrocardiogramQuery
        case sampleQuery
        case statisticsQuery
        case heartbeatSeriesQuery
        case workoutRouteQuery
        case queryActivitySummary
        case sourceQuery
        case correlationQuery
        case clinicalRecordQuery
        case visionPrescriptionQuery
        case workoutEffortRelationshipQuery
        case enableBackgroundDelivery
        case disableAllBackgroundDelivery
        case disableBackgroundDelivery
        case startWatchApp
        case isAuthorizedToWrite
        case addCategory
        case addQuantity
        case relateWorkoutEffort
        case unrelateWorkoutEffort
        case delete
        case deleteSamples
        case deleteObjects
        case save
        case saveSamples
    }

    public func handle(_ call: FlutterMethodCall, result flutterResult: @escaping FlutterResult) {
        // Flutter expects results on the platform thread; HealthKit calls back on its own queues
        let result: FlutterResult = { value in
            DispatchQueue.main.async { flutterResult(value) }
        }
        guard let method = Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        if method == .isAvailable {
            result(HealthKitReporter.isHealthDataAvailable)
            return
        }
        guard let reporter = self.reporter else {
            result(
                FlutterError(
                    code: call.method,
                    error: HealthKitError.notAvailable()
                )
            )
            return
        }
        let arguments = call.arguments as? [String: Any] ?? [:]
        do {
            try handle(method, reporter: reporter, arguments: arguments, result: result)
        } catch {
            result(FlutterError(code: call.method, error: error))
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func handle(
        _ method: Method,
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) throws {
        let code = method.rawValue
        switch method {
        case .isAvailable:
            result(HealthKitReporter.isHealthDataAvailable)
        case .supportsHealthRecords:
            result(reporter.manager.supportsHealthRecords())
        case .requestAuthorization:
            reporter.manager.requestAuthorization(
                toRead: try (arguments["toRead"] as? [String] ?? []).map { try $0.asObjectType() },
                toWrite: try (arguments["toWrite"] as? [String] ?? []).map { try $0.asSampleType() },
                completion: status(code, result)
            )
        case .requestPerObjectReadAuthorization:
            guard #available(iOS 16.0, *) else {
                throw HealthKitError.notAvailable("Per-object authorization is available from iOS 16")
            }
            reporter.manager.requestPerObjectReadAuthorization(
                for: try arguments.string("identifier").asObjectType(),
                predicate: try arguments.samplesPredicate(),
                completion: status(code, result)
            )
        case .isWritable:
            let type = try arguments.string("identifier").asObjectType()
            result((type as? SampleType)?.isWritable ?? false)
        case .preferredUnits:
            let types = try arguments.strings("identifiers").map { try QuantityType.make(from: $0) }
            reporter.manager.preferredUnits(for: types, completion: encoded(code, result))
        case .characteristicsQuery:
            result(try reporter.reader.characteristics().encoded())
        case .quantityQuery:
            let query = try reporter.reader.quantityQuery(
                type: try QuantityType.make(from: try arguments.string("identifier")),
                unit: try arguments.string("unit"),
                predicate: try arguments.requiredSamplesPredicate(),
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .categoryQuery:
            let query = try reporter.reader.categoryQuery(
                type: try CategoryType.make(from: try arguments.string("identifier")),
                predicate: try arguments.requiredSamplesPredicate(),
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .workoutQuery:
            let query = try reporter.reader.workoutQuery(
                predicate: try arguments.requiredSamplesPredicate(),
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .electrocardiogramQuery:
            let query = try reporter.reader.electrocardiogramQuery(
                predicate: try arguments.requiredSamplesPredicate(),
                withVoltageMeasurements: arguments["withVoltageMeasurements"] as? Bool ?? false,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .sampleQuery:
            let query = try reporter.reader.sampleQuery(
                type: try arguments.string("identifier").asSampleType(),
                predicate: try arguments.requiredSamplesPredicate()
            ) { (_, samples, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                result(samples.compactMap { try? $0.encoded() })
            }
            reporter.manager.executeQuery(query)
        case .statisticsQuery:
            let query = try reporter.reader.statisticsQuery(
                type: try QuantityType.make(from: try arguments.string("identifier")),
                unit: try arguments.string("unit"),
                predicate: try arguments.requiredSamplesPredicate(),
                separateBySource: arguments["separateBySource"] as? Bool ?? false
            ) { (statistics, error) in
                guard let statistics = statistics else {
                    result(
                        FlutterError(
                            code: code,
                            error: error ?? HealthKitError.invalidValue("No statistics for the predicate")
                        )
                    )
                    return
                }
                self.send(statistics, code: code, to: result)
            }
            reporter.manager.executeQuery(query)
        case .heartbeatSeriesQuery:
            let query = try reporter.reader.heartbeatSeriesQuery(
                predicate: try arguments.requiredSamplesPredicate(),
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .workoutRouteQuery:
            let query = try reporter.reader.workoutRouteQuery(
                predicate: try arguments.requiredSamplesPredicate(),
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .queryActivitySummary:
            let query = reporter.reader.queryActivitySummary(
                predicate: try arguments.activitySummaryPredicate(),
                monitorUpdates: false,
                completionHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .sourceQuery:
            let query = try reporter.reader.sourceQuery(
                type: try arguments.string("identifier").asSampleType(),
                predicate: try arguments.requiredSamplesPredicate(),
                completionHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .correlationQuery:
            let identifier = try arguments.string("identifier")
            guard let type = identifier.objectType as? CorrelationType else {
                throw HealthKitError.invalidType("Not a correlation type: \(identifier)")
            }
            var typePredicates: [String: NSPredicate] = [:]
            for (key, value) in arguments["typePredicates"] as? [String: [String: Any]] ?? [:] {
                typePredicates[key] = try value.requiredSamplesPredicate()
            }
            let query = try reporter.reader.correlationQuery(
                type: type,
                predicate: try arguments.requiredSamplesPredicate(),
                typePredicates: typePredicates,
                completionHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .clinicalRecordQuery:
            let identifier = try arguments.string("identifier")
            guard let type = identifier.objectType as? ClinicalType else {
                throw HealthKitError.invalidType("Not a clinical type: \(identifier)")
            }
            let query = try reporter.reader.clinicalRecordQuery(
                type: type,
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .visionPrescriptionQuery:
            guard #available(iOS 16.0, *) else {
                throw HealthKitError.notAvailable("Vision prescriptions are available from iOS 16")
            }
            let query = try reporter.reader.visionPrescriptionQuery(
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .workoutEffortRelationshipQuery:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Workout effort is available from iOS 18")
            }
            let query = try reporter.reader.workoutEffortRelationshipQuery(
                predicate: try arguments.samplesPredicate(),
                anchor: try arguments.anchor(),
                mostRelevant: arguments["mostRelevant"] as? Bool ?? false
            ) { (relationships, anchor, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                do {
                    result([
                        "relationships": try relationships.encoded(),
                        "anchor": anchor.asArgument as Any
                    ])
                } catch {
                    result(FlutterError(code: code, error: error))
                }
            }
            reporter.manager.executeQuery(query)
        case .enableBackgroundDelivery:
            guard let frequency = arguments["frequency"] as? Int else {
                throw HealthKitError.invalidValue("Missing or invalid argument frequency in \(arguments)")
            }
            reporter.observer.enableBackgroundDelivery(
                type: try arguments.string("identifier").asObjectType(),
                frequency: try UpdateFrequency.make(from: frequency),
                completionHandler: status(code, result)
            )
        case .disableAllBackgroundDelivery:
            reporter.observer.disableAllBackgroundDelivery(completionHandler: status(code, result))
        case .disableBackgroundDelivery:
            reporter.observer.disableBackgroundDelivery(
                type: try arguments.string("identifier").asObjectType(),
                completionHandler: status(code, result)
            )
        case .startWatchApp:
            reporter.manager.startWatchApp(
                with: try WorkoutConfiguration.make(from: arguments),
                completion: status(code, result)
            )
        case .isAuthorizedToWrite:
            result(try reporter.writer.isAuthorizedToWrite(type: try arguments.string("identifier").asObjectType()))
        case .addCategory:
            guard let categories = arguments["categories"] as? [[String: Any]] else {
                throw HealthKitError.invalidValue("Missing or invalid argument categories in \(arguments)")
            }
            reporter.writer.addCategory(
                try categories.map { try Category.make(from: $0).fromDart() },
                from: try (arguments["device"] as? [String: Any]).map { try Device.make(from: $0) },
                to: try Workout.make(from: try arguments.dictionary("workout")),
                completion: status(code, result)
            )
        case .addQuantity:
            guard let quantities = arguments["quantities"] as? [[String: Any]] else {
                throw HealthKitError.invalidValue("Missing or invalid argument quantities in \(arguments)")
            }
            reporter.writer.addQuantity(
                try quantities.map { try Quantity.make(from: $0).fromDart() },
                from: try (arguments["device"] as? [String: Any]).map { try Device.make(from: $0) },
                to: try Workout.make(from: try arguments.dictionary("workout")),
                completion: status(code, result)
            )
        case .relateWorkoutEffort:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Workout effort is available from iOS 18")
            }
            reporter.writer.relateWorkoutEffort(
                try Quantity.make(from: try arguments.dictionary("sample")).fromDart(),
                toWorkout: try arguments.string("workoutUUID"),
                activity: arguments["activityUUID"] as? String,
                completion: status(code, result)
            )
        case .unrelateWorkoutEffort:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Workout effort is available from iOS 18")
            }
            reporter.writer.unrelateWorkoutEffort(
                try Quantity.make(from: try arguments.dictionary("sample")).fromDart(),
                fromWorkout: try arguments.string("workoutUUID"),
                activity: arguments["activityUUID"] as? String,
                completion: status(code, result)
            )
        case .delete:
            reporter.writer.delete(sample: try parseSample(arguments), completion: status(code, result))
        case .deleteSamples:
            reporter.writer.delete(samples: try parseSamples(arguments), completion: status(code, result))
        case .deleteObjects:
            reporter.writer.deleteObjects(
                of: try arguments.string("identifier").asObjectType(),
                predicate: try arguments.requiredSamplesPredicate()
            ) { (success, count, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                result(["status": success, "count": count])
            }
        case .save:
            reporter.writer.save(sample: try parseSample(arguments)) { (success, uuid, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                result(["status": success, "uuid": uuid as Any])
            }
        case .saveSamples:
            reporter.writer.save(samples: try parseSamples(arguments)) { (success, uuids, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                result(["status": success, "uuids": uuids])
            }
        }
    }
}
// MARK: - Helper functions
extension SwiftHealthKitReporterPlugin {
    /// Encodes the payload as JSON and replies with it
    private func send<T: Encodable>(_ value: T, code: String, to result: FlutterResult) {
        do {
            result(try value.encoded())
        } catch {
            result(FlutterError(code: code, error: error))
        }
    }
    /// Results handler replying with the JSON encoded payloads, or the error
    private func encoded<T: Encodable>(_ code: String, _ result: @escaping FlutterResult) -> (T, Error?) -> Void {
        return { value, error in
            if let error = error {
                result(FlutterError(code: code, error: error))
                return
            }
            self.send(value, code: code, to: result)
        }
    }
    /// Completion replying with the status, or the error
    private func status(_ code: String, _ result: @escaping FlutterResult) -> StatusCompletionBlock {
        return { success, error in
            if let error = error {
                result(FlutterError(code: code, error: error))
                return
            }
            result(success)
        }
    }
    private func parseSamples(_ arguments: [String: Any]) throws -> [Sample] {
        guard let samples = arguments["samples"] as? [[String: Any]] else {
            throw HealthKitError.invalidValue("Missing or invalid argument samples in \(arguments)")
        }
        return try samples.map(parseSample)
    }
    /**
     The sample Dart sends, keyed by its kind, e.g. ["quantity": [...]].
     `make(from:)` keeps its "uuid", so delete and unrelate find the stored sample
     */
    private func parseSample(_ arguments: [String: Any]) throws -> Sample {
        if let quantity = arguments["quantity"] as? [String: Any] {
            return try Quantity.make(from: quantity).fromDart()
        }
        if let category = arguments["category"] as? [String: Any] {
            return try Category.make(from: category).fromDart()
        }
        if let workout = arguments["workout"] as? [String: Any] {
            return try Workout.make(from: workout).fromDart()
        }
        if let correlation = arguments["correlation"] as? [String: Any] {
            return try Correlation.make(from: correlation).fromDart()
        }
        if let prescription = arguments["visionPrescription"] as? [String: Any] {
            guard #available(iOS 16.0, *) else {
                throw HealthKitError.notAvailable("Vision prescriptions are available from iOS 16")
            }
            return try VisionPrescription.make(from: prescription).fromDart()
        }
        throw HealthKitError.invalidValue("Invalid arguments: \(arguments)")
    }
}
// MARK: - Dart timestamps
// Dart builds samples with DateTime.millisecondsSinceEpoch; the payloads hold seconds
extension Quantity {
    func fromDart() -> Quantity {
        return copyWith(
            startTimestamp: startTimestamp.secondsSince1970,
            endTimestamp: endTimestamp.secondsSince1970
        )
    }
}
extension Category {
    func fromDart() -> Category {
        return copyWith(
            startTimestamp: startTimestamp.secondsSince1970,
            endTimestamp: endTimestamp.secondsSince1970
        )
    }
}
extension Workout {
    func fromDart() -> Workout {
        return copyWith(
            startTimestamp: startTimestamp.secondsSince1970,
            endTimestamp: endTimestamp.secondsSince1970,
            workoutEvents: workoutEvents.map { event in
                event.copyWith(
                    startTimestamp: event.startTimestamp.secondsSince1970,
                    endTimestamp: event.endTimestamp.secondsSince1970
                )
            }
        )
    }
}
extension Correlation {
    func fromDart() -> Correlation {
        return copyWith(
            startTimestamp: startTimestamp.secondsSince1970,
            endTimestamp: endTimestamp.secondsSince1970,
            harmonized: harmonized.copyWith(
                quantitySamples: harmonized.quantitySamples.map { $0.fromDart() },
                categorySamples: harmonized.categorySamples.map { $0.fromDart() }
            )
        )
    }
}
@available(iOS 16.0, *)
extension VisionPrescription {
    func fromDart() -> VisionPrescription {
        return copyWith(
            startTimestamp: startTimestamp.secondsSince1970,
            endTimestamp: endTimestamp.secondsSince1970
        )
    }
}
