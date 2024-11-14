//
//  Extensions+SwiftHealthKitReporterPlugin.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 17.04.22.
//

import Flutter
import HealthKitReporter
import HealthKit

// MARK: - MethodCall
extension SwiftHealthKitReporterPlugin {
    private enum Method: String {
        case isAvailable
        case requestAuthorization
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
        case workoutRouteForUUIDQuery
        case queryActivitySummary
        case sourceQuery
        case correlationQuery
        case enableBackgroundDelivery
        case disableAllBackgroundDelivery
        case disableBackgroundDelivery
        case startWatchApp
        case isAuthorizedToWrite
        case addCategory
        case addQuantity
        case delete
        case deleteObjects
        case save
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            result(
                FlutterError(
                    code: className,
                    message: "Please check the method",
                    details: "Provided method: \(call.method)"
                )
            )
            return
        }

        if method == .isAvailable {
            result(HealthKitReporter.isHealthDataAvailable)
            return
        }

        guard let reporter = self.reporter else {
            result(
                FlutterError(
                    code: className,
                    message: "HealthKit is not available",
                    details: nil
                )
            )
            return
        }

        switch method {
        case .isAvailable:
            result(HealthKitReporter.isHealthDataAvailable)
        case .requestAuthorization:
            guard let arguments = call.arguments as? [String: [String]] else {
                throwNoArgumentsError(result: result)
                return
            }
            requestAuthorization(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .preferredUnits:
            guard let arguments = call.arguments as? [String] else {
                throwNoArgumentsError(result: result)
                return
            }
            preferredUnits(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .characteristicsQuery:
            characteristicsQuery(reporter: reporter, result: result)
        case .quantityQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            quantityQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .categoryQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            categoryQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .workoutQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            workoutQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .electrocardiogramQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            electrocardiogramQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .sampleQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            sampleQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .statisticsQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            statisticsQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .heartbeatSeriesQuery:
            guard let arguments = call.arguments as? [String: Double] else {
                throwNoArgumentsError(result: result)
                return
            }
            heartbeatSeriesQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .workoutRouteQuery:
            guard let arguments = call.arguments as? [String: Double] else {
                throwNoArgumentsError(result: result)
                return
            }
            workoutRouteQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .workoutRouteForUUIDQuery:
            guard let arguments = call.arguments as? [String: String] else {
                throwNoArgumentsError(result: result)
                return
            }
            workoutRouteForUUIDQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .queryActivitySummary:
            guard let arguments = call.arguments as? [String: Double] else {
                throwNoArgumentsError(result: result)
                return
            }
            queryActivitySummary(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .sourceQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            sourceQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .correlationQuery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            correlationQuery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .enableBackgroundDelivery:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            enableBackgroundDelivery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .disableAllBackgroundDelivery:
            disableAllBackgroundDelivery(
                reporter: reporter,
                result: result
            )
        case .disableBackgroundDelivery:
            guard let arguments = call.arguments as? [String: String] else {
                throwNoArgumentsError(result: result)
                return
            }
            disableBackgroundDelivery(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .startWatchApp:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            startWatchApp(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .isAuthorizedToWrite:
            guard let arguments = call.arguments as? [String: String] else {
                throwNoArgumentsError(result: result)
                return
            }
            isAuthorizedToWrite(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .addCategory:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            addCategory(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .addQuantity:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            addQuantity(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .delete:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            delete(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .deleteObjects:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            deleteObjects(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        case .save:
            guard let arguments = call.arguments as? [String: Any] else {
                throwNoArgumentsError(result: result)
                return
            }
            save(
                reporter: reporter,
                arguments: arguments,
                result: result
            )
        }
    }
}
// MARK: - Method Call methods
extension SwiftHealthKitReporterPlugin {
    private func requestAuthorization(
        reporter: HealthKitReporter,
        arguments: [String: [String]],
        result: @escaping FlutterResult
    ) {
        let toReadArguments = arguments["toRead"]
        let toWriteArguments = arguments["toWrite"]
        reporter.manager.requestAuthorization(
            toRead: toReadArguments != nil
                ? parse(arguments: toReadArguments!)
                : [],
            toWrite: toWriteArguments != nil
                ? parse(arguments: toWriteArguments!)
                : []
        ) { (success, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: "RequestAuthorization",
                        message: "Error in displaying Apple Health permission screen",
                        details: error.debugDescription
                    )
                )
                return
            }
            result(success)
        }
    }
    
    private func preferredUnits(
        reporter: HealthKitReporter,
        arguments: [String],
        result: @escaping FlutterResult
    ) {
        var quantityTypes: [QuantityType] = []
        for argument in arguments {
            guard let quantityType = try? QuantityType.make(from: argument) else {
                result(
                    FlutterError(
                        code: className,
                        message: "Error in parsing quantity type",
                        details: "Identifier unknown: \(argument)"
                    )
                )
                return
            }
            quantityTypes.append(quantityType)
        }
        reporter.manager.preferredUnits(
            for: quantityTypes
        ) { (preferredUnits, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: "PreferredUnits",
                        message: "Error in getting preferred units",
                        details: error.debugDescription
                    )
                )
                return
            }
            do {
                result(try preferredUnits.encoded())
            } catch {
                result(
                    FlutterError(
                        code: "PreferredUnits",
                        message: "Error in json encoding of preferred units: \(preferredUnits)",
                        details: error
                    )
                )
            }
        }
    }
    private func characteristicsQuery(
        reporter: HealthKitReporter,
        result: FlutterResult
    ) {
        do {
            let characteristics = reporter.reader.characteristics()
            result(try characteristics.encoded())
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func quantityQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let unit = arguments["unit"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        do {
            let type = try QuantityType.make(from: identifier)
            let predicate = NSPredicate.samplesPredicate(
                startDate: Date.make(from: startTimestamp),
                endDate: Date.make(from: endTimestamp)
            )
            let query = try reporter.reader.quantityQuery(
                type: type,
                unit: unit,
                predicate: predicate
            ) { (quantities, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "QuantityQuery",
                            message: "Error in quantityQuery for identifier: \(identifier)",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    result(try quantities.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "QuantityQuery",
                            message: "Error in json encoding of quantities: \(quantities)",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func categoryQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        do {
            let type = try CategoryType.make(from: identifier)
            let predicate = NSPredicate.samplesPredicate(
                startDate: Date.make(from: startTimestamp),
                endDate: Date.make(from: endTimestamp)
            )
            let query = try reporter.reader.categoryQuery(
                type: type,
                predicate: predicate
            ) { (categories, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "CategoryQuery",
                            message: "Error in categoryQuery for identifier: \(identifier)",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    result(try categories.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "CategoryQuery",
                            message: "Error in json encoding of categories: \(categories)",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func workoutQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double,
            let option = arguments["singleQueryOption"] as? String?
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        lazy var hkOptions:HKQueryOptions = {
            if (option != nil) {
                if (option == "strictStartDate") {
                    return [.strictStartDate]
                } else if (option == "strictEndDate") {
                    return [.strictEndDate]
                } else if (option == "notStrict") {
                    return []
                }
            }
            // Default to both being strict
            return [.strictStartDate, .strictEndDate]
        }()
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp),
            options: hkOptions
        )
        do {
            let query = try reporter.reader.workoutQuery(
                predicate: predicate
            ) { (workouts, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "WorkoutQuery",
                            message: "Error in workoutQuery",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    result(try workouts.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "WorkoutQuery",
                            message: "Error in json encoding of workouts: \(workouts)",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } catch {
            result(
                FlutterError(
                    code: className,
                    message: "Error in workoutQuery initialization",
                    details: error
                )
            )
        }
    }
    private func electrocardiogramQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double,
            let withVoltageMeasurements = arguments["withVoltageMeasurements"] as? Bool
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        if #available(iOS 14.0, *) {
            do {
                let query = try reporter.reader.electrocardiogramQuery(
                    predicate: predicate,
                    withVoltageMeasurements: withVoltageMeasurements
                ) { (electrocardiograms, error) in
                    guard error == nil else {
                        result(
                            FlutterError(
                                code: "ElectrocardiogramQuery",
                                message: "Error in electrocardiogramQuery",
                                details: error.debugDescription
                            )
                        )
                        return
                    }
                    do {
                        result(try electrocardiograms.encoded())
                    } catch {
                        result(
                            FlutterError(
                                code: "ElectrocardiogramQuery",
                                message: "Error in json encoding of electrocardiograms: \(electrocardiograms)",
                                details: error
                            )
                        )
                    }
                }
                reporter.manager.executeQuery(query)
            } catch {
                result(
                    FlutterError(
                        code: className,
                        message: "Error electrocardiograms query initialization",
                        details: error
                    )
                )
            }
        } else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in platform version.",
                    details: "Electrocardiogram query is available for iOS 14."
                )
            )
        }
    }
    private func sampleQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType as? SampleType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        do {
            let query = try reporter.reader.sampleQuery(
                type: type,
                predicate: predicate
            ) { (_, samples, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "SampleQuery",
                            message: "Error in sampleQuery",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                var jsonArray: [String] = []
                for sample in samples {
                    do {
                        let encoded = try sample.encoded()
                        jsonArray.append(encoded)
                    } catch {
                        result(
                            FlutterError(
                                code: "SampleQuery",
                                message: "Error in json encoding of sample: \(sample). Continue",
                                details: error
                            )
                        )
                        continue
                    }
                }
                result(jsonArray)
            }
            reporter.manager.executeQuery(query)
        } catch {
            result(
                FlutterError(
                    code: className,
                    message: "Error in sampleQuery initialization",
                    details: error
                )
            )
        }
    }
    private func statisticsQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let unit = arguments["unit"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType as? QuantityType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing QuantityType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        do {
            let query = try reporter.reader.statisticsQuery(
                type: type,
                unit: unit,
                predicate: predicate
            ) { (statistics, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "StatisticsQuery",
                            message: "Error in statisticsQuery",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    guard let statistics = statistics else {
                        result(
                            FlutterError(
                                code: "StatisticsQuery",
                                message: "Statistics samples was null",
                                details: nil
                            )
                        )
                        return
                    }
                    result(try statistics.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "StatisticsQuery",
                            message: "Error in json encoding of statistics: \(String(describing: statistics))",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } catch {
            result(
                FlutterError(
                    code: className,
                    message: "Error in statisticsQuery initialization",
                    details: error
                )
            )
        }
    }
    private func heartbeatSeriesQuery(
        reporter: HealthKitReporter,
        arguments: [String: Double],
        result: @escaping FlutterResult
    ) {
        guard
            let startTimestamp = arguments["startTimestamp"],
            let endTimestamp = arguments["endTimestamp"]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        if #available(iOS 13.0, *) {
            let predicate = NSPredicate.samplesPredicate(
                startDate: Date.make(from: startTimestamp),
                endDate: Date.make(from: endTimestamp)
            )
            do {
                let query = try reporter.reader.heartbeatSeriesQuery(
                    predicate: predicate
                ) { (series, error) in
                    guard error == nil else {
                        result(
                            FlutterError(
                                code: "HeartbeatSeriesQuery",
                                message: "Error in heartbeatSeriesQuery",
                                details: error.debugDescription
                            )
                        )
                        return
                    }
                    do {
                        result(try series.encoded())
                    } catch {
                        result(
                            FlutterError(
                                code: "HeartbeatSeriesQuery",
                                message: "Error in json encoding of beat by beat series: \(series)",
                                details: error
                            )
                        )
                    }
                }
                reporter.manager.executeQuery(query)
            } catch let error {
                result(
                    FlutterError(
                        code: className,
                        message: "Error in heartbeatSeriesQuery initialization",
                        details: error
                    )
                )
            }
        } else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in platform version.",
                    details: "HeartbeatSeries query is available for iOS 13."
                )
            )
        }
    }
    private func workoutRouteQuery(
        reporter: HealthKitReporter,
        arguments: [String: Double],
        result: @escaping FlutterResult
    ) {
        guard
            let startTimestamp = arguments["startTimestamp"],
            let endTimestamp = arguments["endTimestamp"]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        if #available(iOS 11.0, *) {
            let predicate = NSPredicate.samplesPredicate(
                startDate: Date.make(from: startTimestamp),
                endDate: Date.make(from: endTimestamp)
            )
            do {
                let query = try reporter.reader.workoutRouteQuery(
                    predicate: predicate
                ) { (routes, error) in
                    guard error == nil else {
                        result(
                            FlutterError(
                                code: "WorkoutRouteQuery",
                                message: "Error in workoutRouteQuery",
                                details: error.debugDescription
                            )
                        )
                        return
                    }
                    do {
                        result(try routes.encoded())
                    } catch {
                        result(
                            FlutterError(
                                code: "WorkoutRouteQuery",
                                message: "Error in json encoding of workout routes: \(routes)",
                                details: error
                            )
                        )
                    }
                }
                reporter.manager.executeQuery(query)
            } catch let error {
                result(
                    FlutterError(
                        code: className,
                        message: "Error in workoutRouteQuery initialization",
                        details: error
                    )
                )
            }
        } else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in platform version.",
                    details: "WorkoutRoute query is available for iOS 11."
                )
            )
        }
    }
    private func getWorkoutByID(
        reporter: HealthKitReporter,
        workoutUUID: UUID
    ) async -> HKWorkout? {
        let workoutPredicate = HKQuery.predicateForObject(with: workoutUUID)

        let samples = try! await withCheckedThrowingContinuation {
          (continuation: CheckedContinuation<[HKSample], Error>) in
          let query = HKSampleQuery(
            sampleType: HKObjectType.workoutType(),
            predicate: workoutPredicate,
            limit: 1,
            sortDescriptors: nil
          ) { (_, results, error) in

            if let hasError = error {
              continuation.resume(throwing: hasError)
              return
            }

            guard let samples = results else {
              fatalError("workout samples unexpectedly nil")
            }

            continuation.resume(returning: samples)
          }
          reporter.manager.executeQuery(query)
        }

        guard let workouts = samples as? [HKWorkout] else {
          return nil
        }

        return workouts.first ?? nil
    }
    @available(iOS 13.0.0, *)
    private func workoutRouteForUUIDQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    )  {
        guard
            let uuidString = arguments["uuid"],
            let uuid = UUID(uuidString: uuidString)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        Task {
            guard let workout = await getWorkoutByID(reporter: reporter, workoutUUID: uuid) else {
                result(
                       FlutterError(
                         code: "workoutRouteForUUIDQuery",
                         message: "Error getting workout with provided UUID",
                         details: uuid
                       )
                )
                return
            }

            let predicate = HKQuery.predicateForObjects(from: workout)
            do {
                let query = try reporter.reader.workoutRouteQuery(
                    predicate: predicate
                ) { (routes, error) in
                    guard error == nil else {
                        result(
                            FlutterError(
                                code: "workoutRouteForUUIDQuery",
                                message: "Error in workoutRouteQuery",
                                details: error.debugDescription
                            )
                        )
                        return
                    }
                    do {
                        result(try routes.encoded())
                    } catch {
                        result(
                            FlutterError(
                                code: "workoutRouteForUUIDQuery",
                                message: "Error in json encoding of workout routes: \(routes)",
                                details: error
                            )
                        )
                    }
                }
                reporter.manager.executeQuery(query)
            } catch let error {
                result(
                    FlutterError(
                        code: className,
                        message: "Error in workoutRouteQuery initialization",
                        details: error
                    )
                )
            }
        }
    }
    private func queryActivitySummary(
        reporter: HealthKitReporter,
        arguments: [String: Double],
        result: @escaping FlutterResult
    ) {
        guard
            let startTimestamp = arguments["startTimestamp"],
            let endTimestamp = arguments["endTimestamp"]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        if #available(iOS 9.3, *) {
            let startDate = Date.make(from: startTimestamp)
            let endDate = Date.make(from: endTimestamp)
            let units: Set<Calendar.Component> = [
                .day,
                .month,
                .year,
                .era
            ]
            let calendar = Calendar.current
            var startDateComponents = calendar.dateComponents(units, from: startDate)
            startDateComponents.calendar = calendar
            var endDateComponents = calendar.dateComponents(units, from: endDate)
            endDateComponents.calendar = calendar
            let predicate = NSPredicate.activitySummaryPredicateBetween(
                start: startDateComponents,
                end: endDateComponents
            )
            let query = reporter.reader.queryActivitySummary(
                predicate: predicate,
                monitorUpdates: false
            ) { (activitySummaries, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "QueryActivitySummary",
                            message: "Error in queryActivitySummary",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    result(try activitySummaries.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "QueryActivitySummary",
                            message: "Error in json encoding of activitySummaries: \(activitySummaries)",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in platform version.",
                    details: "ActivitySummary query is available for iOS 9.3."
                )
            )
        }
    }
    private func sourceQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType as? SampleType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        do {
            let query = try reporter.reader.sourceQuery(
                type: type,
                predicate: predicate
            ) { (sources, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "SourceQuery",
                            message: "Error in sourceQuery",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    result(try sources.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "SourceQuery",
                            message: "Error in json encoding of sources: \(sources)",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } catch {
            result(
                FlutterError(
                    code: className,
                    message: "Error in sourceQuery initialization",
                    details: error
                )
            )
        }
    }
    private func correlationQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType as? CorrelationType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing CorrelationType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        var typePredicates: [String: NSPredicate] = [:]
        if let typePredicatesArgument = arguments["typePredicates"] as? [String: [String: Double]] {
            for (key, value) in typePredicatesArgument {
                guard
                    let startTimestamp = value["startTimestamp"],
                    let endTimestamp = value["endTimestamp"]
                else {
                    continue
                }
                let typePredicate = NSPredicate.samplesPredicate(
                    startDate: Date.make(from: startTimestamp),
                    endDate: Date.make(from: endTimestamp)
                )
                typePredicates[key] = typePredicate
            }
        }
        do {
            let query = try reporter.reader.correlationQuery(
                type: type,
                predicate: predicate,
                typePredicates: typePredicates
            ) { (correlations, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "CorrelationQuery",
                            message: "Error in correlationQuery",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                do {
                    result(try correlations.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: "CorrelationQuery",
                            message: "Error in json encoding of correlations: \(correlations)",
                            details: error
                        )
                    )
                }
            }
            reporter.manager.executeQuery(query)
        } catch {
            result(
                FlutterError(
                    code: className,
                    message: "Error in correlationQuery initialization",
                    details: error
                )
            )
        }
    }
    private func enableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let frequency = arguments["frequency"] as? Int
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        do {
            let updateFrequency = try UpdateFrequency.make(from: frequency)
            reporter.observer.enableBackgroundDelivery(
                type: type,
                frequency: updateFrequency
            ) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "EnableBackgroundDelivery",
                            message: "Error in enableBackgroundDelivery",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing frequency: \(frequency)",
                    details: error
                )
            )
        }
    }
    private func disableAllBackgroundDelivery(
        reporter: HealthKitReporter,
        result: @escaping FlutterResult
    ) {
        reporter.observer.disableAllBackgroundDelivery { (success, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: "DisableAllBackgroundDelivery",
                        message: "Error in disableAllBackgroundDelivery",
                        details: error.debugDescription
                    )
                )
                return
            }
            result(success)
        }
    }
    private func disableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard let identifier = arguments["identifier"] else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        reporter.observer.disableBackgroundDelivery(type: type) { (success, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: "DisableBackgroundDelivery",
                        message: "Error in disableBackgroundDelivery",
                        details: error.debugDescription
                    )
                )
                return
            }
            result(success)
        }
    }
    private func startWatchApp(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        if #available(iOS 10.0, *) {
            do {
                let workoutConfiguration = try WorkoutConfiguration.make(from: arguments)
                reporter.manager.startWatchApp(with: workoutConfiguration) { (success, error) in
                    guard error == nil else {
                        result(
                            FlutterError(
                                code: "StartWatchApp",
                                message: "Error in startWatchApp",
                                details: error.debugDescription
                            )
                        )
                        return
                    }
                    result(success)
                }
            } catch {
                result(
                    FlutterError(
                        code: className,
                        message: "Error in creating WorkoutConfiguration",
                        details: error
                    )
                )
            }
        } else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in platform version.",
                    details: "StartWatchApp is available for iOS 9.3."
                )
            )
        }
    }
    private func isAuthorizedToWrite(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard let identifier = arguments["identifier"] else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        do {
            let isAuthorizedToWrite = try reporter.writer.isAuthorizedToWrite(type: type)
            result(isAuthorizedToWrite)
        } catch {
            let message = "Error in writing authorization status for identifier: \(identifier)"
            result(
                FlutterError(
                    code: className,
                    message: message,
                    details: error
                )
            )
        }
    }
    private func addCategory(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let category = arguments["categories"] as? [[String: Any]],
            let workout = arguments["workout"] as? [String: Any]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        let device = arguments["device"] as? [String: Any]
        do {
            reporter.writer.addCategory(
                try category.map {
                    try Category.make(from: $0)
                },
                from: device != nil
                    ? try Device.make(from: device!)
                    : nil,
                to: try Workout.make(from: workout)
            ) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "AddCategory",
                            message: "\(#line). Error in addCategory",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func addQuantity(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let quantity = arguments["quantities"] as? [[String: Any]],
            let workout = arguments["workout"] as? [String: Any]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        let device = arguments["device"] as? [String: Any]
        do {
            reporter.writer.addQuantitiy(try quantity.map {
                try Quantity.make(from: $0)
            },
            from: device != nil
                ? try Device.make(from: device!)
                : nil,
            to: try Workout.make(from: workout)) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "AddQuantity",
                            message: "Error in addQuantity",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func delete(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        do {
            let sample = try parse(arguments: arguments)
            reporter.writer.delete(sample: sample) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "Delete",
                            message: "Error in delete",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func deleteObjects(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType else {
            result(
                FlutterError(
                    code: className,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        reporter.writer.deleteObjects(
            of: type,
            predicate: predicate
        ) { (success, count, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: "DeleteObjects",
                        message: "Error in delete",
                        details: error.debugDescription
                    )
                )
                return
            }
            let resultDictionary: [String: Any] = [
                "status": success,
                "count": count
            ]
            result(resultDictionary)
        }
    }
    private func save(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        do {
            let sample = try parse(arguments: arguments)
            reporter.writer.save(sample: sample) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: "Save",
                            message: "Error in save",
                            details: error.debugDescription
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
}
// MARK: - Helper functions
extension SwiftHealthKitReporterPlugin {
    private func parse(arguments: [String]) -> [ObjectType] {
        var types: [ObjectType] = []
        for argument in arguments {
            if let type = argument.objectType {
                types.append(type)
            }
        }
        return types
    }
    private func parse(arguments: [String]) -> [SampleType] {
        var types: [SampleType] = []
        for argument in arguments {
            if let type = argument.objectType as? SampleType {
                types.append(type)
            }
        }
        return types
    }
    private func parse(arguments: [String: Any]) throws -> Sample {
        if let quantity = arguments["quantity"] as? [String: Any] {
            let sample = try Quantity.make(from: quantity)
            return sample.copyWith(
                startTimestamp: sample.startTimestamp.secondsSince1970,
                endTimestamp: sample.endTimestamp.secondsSince1970
            )
        }
        if let category = arguments["category"] as? [String: Any] {
            let sample = try Category.make(from: category)
            return sample.copyWith(
                startTimestamp: sample.startTimestamp.secondsSince1970,
                endTimestamp: sample.endTimestamp.secondsSince1970
            )
        }
        if let workout = arguments["workout"] as? [String: Any] {
            let sample = try Workout.make(from: workout)
            return sample.copyWith(
                startTimestamp: sample.startTimestamp.secondsSince1970,
                endTimestamp: sample.endTimestamp.secondsSince1970,
                workoutEvents: sample.workoutEvents.map { event in
                    event.copyWith(
                        startTimestamp: event.startTimestamp.secondsSince1970,
                        endTimestamp: event.endTimestamp.secondsSince1970
                    )
                }
            )
        }
        if let correlation = arguments["correlation"] as? [String: Any] {
            let sample = try Correlation.make(from: correlation)
            return sample.copyWith(
                startTimestamp: sample.startTimestamp.secondsSince1970,
                endTimestamp: sample.endTimestamp.secondsSince1970,
                harmonized: sample.harmonized.copyWith(
                    quantitySamples: sample.harmonized.quantitySamples.map { $0.copyWith(
                        startTimestamp: $0.startTimestamp.secondsSince1970,
                        endTimestamp: $0.endTimestamp.secondsSince1970
                    )},
                    categorySamples: sample.harmonized.categorySamples.map { $0.copyWith(
                        startTimestamp: $0.startTimestamp.secondsSince1970,
                        endTimestamp: $0.endTimestamp.secondsSince1970
                    )}
                )
            )
        }
        throw HealthKitError.invalidValue("Invalid arguments: \(arguments)")
    }
    private func throwParsingArgumentsError(
        result: FlutterResult,
        arguments: Any
    ) {
        result(
            FlutterError(
                code: className,
                message: "Error in parsing arguments.",
                details: "Arguments: \(String(describing: arguments))."
            )
        )
    }
    private func throwNoArgumentsError(result: FlutterResult) {
        result(
            FlutterError(
                code: className,
                message: "Error call arguments.",
                details: "No arguments"
            )
        )
    }
    private func throwPlatformError(
        result: FlutterResult,
        error: Error
    ) {
        result(
            FlutterError(
                code: className,
                message: "Error in platform method.",
                details: error
            )
        )
    }
    private func throwSystemVersionError(result: FlutterResult) {
        result(
            FlutterError(
                code: className,
                message: "The current system version does not support method",
                details: nil
            )
        )
    }
}
