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
        case authorizationRequestStatus
        case earliestPermittedSampleDate
        case recalibrateEstimates
        case attachments
        case attachmentData
        case addAttachment
        case removeAttachment
        case sampleQueryWithDescriptors
        case quantitySeriesQuery
        case verifiableClinicalRecordQuery
        case cdaDocumentQuery
        case audiogramQuery
        case stateOfMindQuery
        case scoredAssessmentQuery
        case medicationDoseEventQuery
        case userAnnotatedMedicationQuery
        case saveWorkout
        case saveQuantitySeries
        case saveHeartbeatSeries
        case observerQuery
        case anchoredObjectQuery
        case queryActivitySummaryUpdates
        case statisticsCollectionQuery
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
                self.send(samples, error: error, code: code, to: result)
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
                try categories.map { try Category.make(from: $0) },
                from: try (arguments["device"] as? [String: Any]).map { try Device.make(from: $0) },
                to: try Workout.make(from: try arguments.dictionary("workout")),
                completion: status(code, result)
            )
        case .addQuantity:
            guard let quantities = arguments["quantities"] as? [[String: Any]] else {
                throw HealthKitError.invalidValue("Missing or invalid argument quantities in \(arguments)")
            }
            reporter.writer.addQuantity(
                try quantities.map { try Quantity.make(from: $0) },
                from: try (arguments["device"] as? [String: Any]).map { try Device.make(from: $0) },
                to: try Workout.make(from: try arguments.dictionary("workout")),
                completion: status(code, result)
            )
        case .relateWorkoutEffort:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Workout effort is available from iOS 18")
            }
            reporter.writer.relateWorkoutEffort(
                try Quantity.make(from: try arguments.dictionary("sample")),
                toWorkout: try arguments.string("workoutUUID"),
                activity: arguments["activityUUID"] as? String,
                completion: status(code, result)
            )
        case .unrelateWorkoutEffort:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Workout effort is available from iOS 18")
            }
            reporter.writer.unrelateWorkoutEffort(
                try Quantity.make(from: try arguments.dictionary("sample")),
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
        case .authorizationRequestStatus:
            reporter.manager.authorizationRequestStatus(
                toRead: try (arguments["toRead"] as? [String] ?? []).map { try $0.asObjectType() },
                toWrite: try (arguments["toWrite"] as? [String] ?? []).map { try $0.asSampleType() }
            ) { (status, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                result(status.rawValue)
            }
        case .earliestPermittedSampleDate:
            result(reporter.manager.earliestPermittedSampleDate().timeIntervalSince1970)
        case .recalibrateEstimates:
            reporter.manager.recalibrateEstimates(
                for: try arguments.string("identifier").asSampleType(),
                at: try arguments.date("timestamp"),
                completion: status(code, result)
            )
        case .attachments, .attachmentData, .addAttachment, .removeAttachment:
            guard #available(iOS 16.0, *) else {
                throw HealthKitError.notAvailable("Attachments are available from iOS 16")
            }
            try handleAttachments(method, reporter: reporter, arguments: arguments, result: result)
        case .sampleQueryWithDescriptors:
            guard let descriptors = arguments["descriptors"] as? [[String: Any]] else {
                throw HealthKitError.invalidValue("Missing or invalid argument descriptors in \(arguments)")
            }
            let query = try reporter.reader.sampleQuery(
                descriptors: try descriptors.map {
                    QueryDescriptor(
                        type: try $0.string("identifier").asSampleType(),
                        predicate: try $0.samplesPredicate()
                    )
                }
            ) { (_, samples, error) in
                self.send(samples, error: error, code: code, to: result)
            }
            reporter.manager.executeQuery(query)
        case .quantitySeriesQuery:
            let query = try reporter.reader.quantitySeriesQuery(
                type: try QuantityType.make(from: try arguments.string("identifier")),
                unit: try arguments.string("unit"),
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .verifiableClinicalRecordQuery:
            let query = reporter.reader.verifiableClinicalRecordQuery(
                recordTypes: try arguments.strings("recordTypes"),
                sourceTypes: arguments["sourceTypes"] as? [String] ?? [],
                predicate: try arguments.samplesPredicate(),
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .cdaDocumentQuery:
            var documents = [CDADocument]()
            let query = try reporter.reader.cdaDocumentQuery(
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                includeDocumentData: arguments["includeDocumentData"] as? Bool ?? true
            ) { (batch, done, error) in
                if let error = error {
                    result(FlutterError(code: code, error: error))
                    return
                }
                documents += batch
                if done {
                    self.send(documents, code: code, to: result)
                }
            }
            reporter.manager.executeQuery(query)
        case .audiogramQuery:
            let query = try reporter.reader.audiogramQuery(
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .stateOfMindQuery:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("State of mind is available from iOS 18")
            }
            let query = try reporter.reader.stateOfMindQuery(
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .scoredAssessmentQuery:
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Scored assessments are available from iOS 18")
            }
            let identifier = try arguments.string("identifier")
            guard let type = identifier.objectType as? ScoredAssessmentType else {
                throw HealthKitError.invalidType("Not a scored assessment type: \(identifier)")
            }
            let query = try reporter.reader.scoredAssessmentQuery(
                type: type,
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .medicationDoseEventQuery:
            guard #available(iOS 26.0, *) else {
                throw HealthKitError.notAvailable("Medications are available from iOS 26")
            }
            let query = try reporter.reader.medicationDoseEventQuery(
                medicationConceptIdentifier: arguments["medicationConceptIdentifier"] as? String,
                predicate: try arguments.samplesPredicate() ?? .allSamples,
                resultsHandler: encoded(code, result)
            )
            reporter.manager.executeQuery(query)
        case .userAnnotatedMedicationQuery:
            guard #available(iOS 26.0, *) else {
                throw HealthKitError.notAvailable("Medications are available from iOS 26")
            }
            let query = reporter.reader.userAnnotatedMedicationQuery(resultsHandler: encoded(code, result))
            reporter.manager.executeQuery(query)
        case .saveWorkout:
            reporter.writer.saveWorkout(
                try Workout.make(from: try arguments.dictionary("workout")),
                samples: try (arguments["samples"] as? [[String: Any]] ?? []).map { try Quantity.make(from: $0) },
                route: try (arguments["route"] as? [[String: Any]] ?? []).map {
                    try WorkoutRoute.Location.make(from: $0)
                }
            ) { (workout, error) in
                self.sendSavedWorkout(workout, error: error, code: code, to: result)
            }
        case .saveQuantitySeries:
            guard let values = arguments["values"] as? [[String: Any]] else {
                throw HealthKitError.invalidValue("Missing or invalid argument values in \(arguments)")
            }
            reporter.writer.saveQuantitySeries(
                type: try QuantityType.make(from: try arguments.string("identifier")),
                values: try values.map { try QuantitySeriesValue.make(from: $0) },
                device: try (arguments["device"] as? [String: Any]).map { try Device.make(from: $0) },
                metadata: try (arguments["metadata"] as? [String: Any]).map { try Metadata.make(from: $0) },
                completion: status(code, result)
            )
        case .saveHeartbeatSeries:
            reporter.writer.saveHeartbeatSeries(
                try HeartbeatSeries.make(from: try arguments.dictionary("series")),
                completion: status(code, result)
            )
        case .observerQuery:
            result(try openEventChannel(.observerQuery, reporter: reporter, arguments: arguments))
        case .anchoredObjectQuery:
            result(try openEventChannel(.anchoredObjectQuery, reporter: reporter, arguments: arguments))
        case .queryActivitySummaryUpdates:
            result(try openEventChannel(.queryActivitySummaryUpdates, reporter: reporter, arguments: arguments))
        case .statisticsCollectionQuery:
            result(try openEventChannel(.statisticsCollectionQuery, reporter: reporter, arguments: arguments))
        }
    }

    @available(iOS 16.0, *)
    private func handleAttachments(
        _ method: Method,
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) throws {
        let code = method.rawValue
        let type = try arguments.string("identifier").asSampleType()
        let uuid = try arguments.string("uuid")
        switch method {
        case .attachments:
            reporter.manager.attachments(forSampleOf: type, uuid: uuid, completion: encoded(code, result))
        case .attachmentData:
            reporter.manager.attachmentData(
                forSampleOf: type,
                uuid: uuid,
                attachmentIdentifier: try arguments.string("attachmentIdentifier")
            ) { (data, error) in
                guard let data = data else {
                    result(
                        FlutterError(
                            code: code,
                            error: error ?? HealthKitError.invalidValue("No attachment data")
                        )
                    )
                    return
                }
                result(FlutterStandardTypedData(bytes: data))
            }
        case .addAttachment:
            reporter.manager.addAttachment(
                toSampleOf: type,
                uuid: uuid,
                name: try arguments.string("name"),
                contentType: try arguments.string("contentType"),
                url: URL(fileURLWithPath: try arguments.string("filePath")),
                metadata: try (arguments["metadata"] as? [String: Any]).map { try Metadata.make(from: $0) }
            ) { (attachment, error) in
                guard let attachment = attachment else {
                    result(
                        FlutterError(
                            code: code,
                            error: error ?? HealthKitError.invalidValue("No attachment added")
                        )
                    )
                    return
                }
                self.send(attachment, code: code, to: result)
            }
        case .removeAttachment:
            reporter.manager.removeAttachment(
                fromSampleOf: type,
                uuid: uuid,
                attachmentIdentifier: try arguments.string("attachmentIdentifier"),
                completion: status(code, result)
            )
        default:
            throw HealthKitError.invalidValue("Not an attachment method: \(code)")
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
    /// Replies with every sample as JSON, or the error; a sample that can't be encoded fails the reply
    private func send(_ samples: [Sample], error: Error?, code: String, to result: FlutterResult) {
        if let error = error {
            result(FlutterError(code: code, error: error))
            return
        }
        do {
            result(try samples.map { try $0.encoded() })
        } catch {
            result(FlutterError(code: code, error: error))
        }
    }
    /// Replies with the saved workout as JSON. The workout is saved even when its route fails;
    /// then the error's details hold the stored workout's JSON
    private func sendSavedWorkout(_ workout: Workout?, error: Error?, code: String, to result: FlutterResult) {
        guard let workout = workout else {
            result(FlutterError(code: code, error: error ?? HealthKitError.unknown("No workout saved")))
            return
        }
        do {
            let json = try workout.encoded()
            guard let error = error else {
                result(json)
                return
            }
            result(FlutterError(code: code, message: error.localizedDescription, details: json))
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
     The sample Dart sends, keyed by its kind, e.g. ["quantity": [...]], with timestamps in seconds.
     `make(from:)` keeps its "uuid", so delete and unrelate find the stored sample
     */
    private func parseSample(_ arguments: [String: Any]) throws -> Sample {
        if let quantity = arguments["quantity"] as? [String: Any] {
            return try Quantity.make(from: quantity)
        }
        if let category = arguments["category"] as? [String: Any] {
            return try Category.make(from: category)
        }
        if let workout = arguments["workout"] as? [String: Any] {
            return try Workout.make(from: workout)
        }
        if let correlation = arguments["correlation"] as? [String: Any] {
            return try Correlation.make(from: correlation)
        }
        if let audiogram = arguments["audiogram"] as? [String: Any] {
            return try Audiogram.make(from: audiogram)
        }
        if let document = arguments["cdaDocument"] as? [String: Any] {
            return try CDADocument.make(from: document)
        }
        if let prescription = arguments["visionPrescription"] as? [String: Any] {
            guard #available(iOS 16.0, *) else {
                throw HealthKitError.notAvailable("Vision prescriptions are available from iOS 16")
            }
            return try VisionPrescription.make(from: prescription)
        }
        if let stateOfMind = arguments["stateOfMind"] as? [String: Any] {
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("State of mind is available from iOS 18")
            }
            return try StateOfMind.make(from: stateOfMind)
        }
        if let assessment = arguments["scoredAssessment"] as? [String: Any] {
            guard #available(iOS 18.0, *) else {
                throw HealthKitError.notAvailable("Scored assessments are available from iOS 18")
            }
            return try ScoredAssessment.make(from: assessment)
        }
        throw HealthKitError.invalidValue("Invalid arguments: \(arguments)")
    }
}
