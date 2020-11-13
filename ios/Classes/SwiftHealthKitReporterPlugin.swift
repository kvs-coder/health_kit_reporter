import Flutter
import UIKit
import HealthKitReporter

public class SwiftHealthKitReporterPlugin: NSObject, FlutterPlugin {
    private enum Method: String {
        case requestAuthorization
        case preferredUnits
        case characteristicsQuery
        case quantityQuery
        case categoryQuery
        case workoutQuery
        case electrocardiogramQuery
        case sampleQuery
        case statisticsQuery
        case statisticsCollectionQuery
        case heartbeatSeriesQuery
        case queryActivitySummary
        case anchoredObjectQuery
        case sourceQuery
        case correlationQuery
        case observerQuery
        case enableBackgroundDelivery
        case disableAllBackgroundDelivery
        case disableBackgroundDelivery
        case startWatchApp
        case isAuthorizedToWrite
        case addCategory
        case addQuantitiy
        case delete
        case save
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "health_kit_reporter", binaryMessenger: registrar.messenger())
        let instance = SwiftHealthKitReporterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        try! HealthKitReporter().manager.requestAuthorization(toRead: [QuantityType.stepCount
        ], toWrite: [], completion: { (success, error) in

        })
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method.init(rawValue: call.method) else {
            result(
                FlutterError(
                    code: #function,
                    message: "Please check the method",
                    details: "Provied method: \(call.method)"
                )
            )
            return
        }
        do {
            let reporter = try HealthKitReporter()
            switch method {
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
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                quantityQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .categoryQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                categoryQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .workoutQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                workoutQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .electrocardiogramQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                electrocardiogramQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .sampleQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                sampleQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .statisticsQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                statisticsQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .statisticsCollectionQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                statisticsCollectionQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .heartbeatSeriesQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                heartbeatSeriesQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .queryActivitySummary:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                queryActivitySummary(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .anchoredObjectQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                anchoredObjectQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .sourceQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                sourceQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .correlationQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                correlationQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .observerQuery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                observerQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .enableBackgroundDelivery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                enableBackgroundDelivery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .disableAllBackgroundDelivery:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                disableAllBackgroundDelivery(
                    reporter: reporter,
                    arguments: arguments,
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
                guard let arguments = call.arguments as? [String: String] else {
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
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                addCategory(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .addQuantitiy:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                addQuantitiy(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .delete:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                delete(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            case .save:
                guard let arguments = call.arguments as? [String: String] else {
                    throwNoArgumentsError(result: result)
                    return
                }
                save(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            }
        } catch {
            result(
                FlutterError(
                    code: #function,
                    message: "Error initializing HealthKitReporter",
                    details: "\(error)"
                )
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
        guard let toReadArguments = arguments["toRead"] else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let toWriteArguments = arguments["toWrite"] else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        reporter.manager.requestAuthorization(
            toRead: parse(arguments: toReadArguments),
            toWrite: parse(arguments: toWriteArguments)
        ) { (success, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in displaying Apple Health permission screen",
                        details: "\(error!)"
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
                        code: #function,
                        message: "Error in parsing quantitiy type",
                        details: "Identifier unknown: \(argument)"
                    )
                )
                return
            }
            quantityTypes.append(quantityType)
        }
        reporter.manager.preferredUnits(
            for: quantityTypes
        ) { (dictionary, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in getting preffered units",
                        details: "\(error!)"
                    )
                )
                return
            }
            result(dictionary)
        }
    }
    private func characteristicsQuery(
        reporter: HealthKitReporter,
        result: FlutterResult
    ) {
        do {
            let characteristics = try reporter.reader.characteristicsQuery()
            result(try characteristics.encoded())
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func quantityQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"],
            let unit = arguments["unit"],
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        do {
            let type = try QuantityType.make(from: identifier)
            let predicate = NSPredicate.samplesPredicate(
                startDate: startDate,
                endDate: endDate
            )
            reporter.reader.quantityQuery(
                type: type,
                unit: unit,
                predicate: predicate
            ) { (samples, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in quantityQuery for identifier: \(identifier)",
                            details: "Arguments: \(String(describing: arguments))"
                        )
                    )
                    return
                }
                do {
                    result(try samples.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of samples: \(samples)",
                            details: "\(error)"
                        )
                    )
                }
            }
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func categoryQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"],
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        do {
            let type = try CategoryType.make(from: identifier)
            let predicate = NSPredicate.samplesPredicate(
                startDate: startDate,
                endDate: endDate
            )
            reporter.reader.categoryQuery(
                type: type,
                predicate: predicate
            ) { (samples, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in categoryQuery for identifier: \(identifier)",
                            details: "Arguments: \(String(describing: arguments))"
                        )
                    )
                    return
                }
                do {
                    result(try samples.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of samples: \(samples)",
                            details: "\(error)"
                        )
                    )
                }
            }
        } catch {
            throwPlatformError(result: result, error: error)
        }
    }
    private func workoutQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.reader.workoutQuery(
            predicate: predicate
        ) { (samples, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in workoutQuery",
                        details: "Arguments: \(String(describing: arguments))"
                    )
                )
                return
            }
            do {
                result(try samples.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of samples: \(samples)",
                        details: "\(error)"
                    )
                )
            }
        }
    }
    private func electrocardiogramQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        if #available(iOS 14.0, *) {
            reporter.reader.electrocardiogramQuery(
                predicate: predicate
            ) { (samples, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in electrocardiogramQuery",
                            details: "Arguments: \(String(describing: arguments))"
                        )
                    )
                    return
                }
                do {
                    result(try samples.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of samples: \(samples)",
                            details: "\(error)"
                        )
                    )
                }
            }
        } else {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in platform version.",
                    details: "Electrocardiogram query is available for iOS 14."
                )
            )
        }
    }
    private func sampleQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"],
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = parse(argument: identifier) else {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.reader.sampleQuery(
            type: type,
            predicate: predicate
        ) { (samples, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in sampleQuery",
                        details: "Arguments: \(String(describing: arguments))"
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
                            code: #function,
                            message: "Error in json encoding of samples: \(samples)",
                            details: "\(error)"
                        )
                    )
                    continue
                }
            }
            result(jsonArray)
        }
    }
    private func statisticsQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"],
            let unit = arguments["unit"],
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = parse(argument: identifier) as? QuantityType else {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing QuantityType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.reader.statisticsQuery(
            type: type,
            unit: unit,
            predicate: predicate
        ) { (statistics, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in statisticsQuery",
                        details: "Arguments: \(String(describing: arguments))"
                    )
                )
                return
            }
            do {
                result(try statistics?.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of statistics: \(String(describing: statistics))",
                        details: "\(error)"
                    )
                )
            }
        }
    }
    private func statisticsCollectionQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"],
            let unit = arguments["unit"],
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601),
            let anchorDate = arguments["anchorDate"]?.asDate(format: Date.iso8601),
            let enumerateFrom = arguments["enumerateFrom"]?.asDate(format: Date.iso8601),
            let enumerateTo = arguments["enumerateTo"]?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = parse(argument: identifier) as? QuantityType else {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        let dateComponents = DateComponents(
            calendar: Calendar.current,
            timeZone: TimeZone.current,
            era: arguments["era"]?.integer,
            year: arguments["year"]?.integer,
            month: arguments["month"]?.integer,
            day: arguments["day"]?.integer,
            hour: arguments["hour"]?.integer,
            minute: arguments["minute"]?.integer,
            second: arguments["second"]?.integer,
            nanosecond: arguments["nanosecond"]?.integer,
            weekday: arguments["weekday"]?.integer,
            weekdayOrdinal: arguments["weekdayOrdinal"]?.integer,
            quarter: arguments["quarter"]?.integer,
            weekOfMonth: arguments["weekOfMonth"]?.integer,
            weekOfYear: arguments["weekOfYear"]?.integer,
            yearForWeekOfYear: arguments["yearForWeekOfYear"]?.integer
        )
        reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: predicate,
            anchorDate: anchorDate,
            enumerateFrom: enumerateFrom,
            enumerateTo: enumerateTo,
            intervalComponents: dateComponents,
            monitorUpdates: arguments["monitorUpdates"]?.boolean ?? false
        ) { (statistics, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in statisticsCollectionQuery",
                        details: "Arguments: \(String(describing: arguments))"
                    )
                )
                return
            }
            do {
                result(try statistics?.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of statistics: \(String(describing: statistics))",
                        details: "\(error)"
                    )
                )
            }
        }
    }
    private func heartbeatSeriesQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func queryActivitySummary(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func anchoredObjectQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func sourceQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func correlationQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func observerQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func enableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func disableAllBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func disableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func startWatchApp(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func isAuthorizedToWrite(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func addCategory(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func addQuantitiy(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func delete(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
    private func save(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {}
}
// MARK: - Helper functions
extension SwiftHealthKitReporterPlugin {
    private func parse(argument: String) -> ObjectType? {
        if let type = try? QuantityType.make(from: argument) {
            return type
        }
        if let type = try? CategoryType.make(from: argument) {
            return type
        }
        if let type = try? CharacteristicType.make(from: argument) {
            return type
        }
        if let type = try? SeriesType.make(from: argument) {
            return type
        }
        if let type = try? CorrelationType.make(from: argument) {
            return type
        }
        if let type = try? DocumentType.make(from: argument) {
            return type
        }
        if let type = try? ActivitySummaryType.make(from: argument) {
            return type
        }
        if let type = try? WorkoutType.make(from: argument) {
            return type
        }
        if #available(iOS 14.0, *) {
            if let type = try? ElectrocardiogramType.make(from: argument) {
                return type
            }
        }
        return nil
    }
    private func parse(arguments: [String]) -> [ObjectType] {
        var types: [ObjectType] = []
        for argument in arguments {
            if let type = parse(argument: argument) {
                types.append(type)
            }
        }
        return types
    }
    private func throwParsingArgumentsError(
        line: Int = #line,
        function: String = #function,
        result: FlutterResult,
        arguments: Any
    ) {
        result(
            FlutterError(
                code: #function,
                message: "\(line):\(function). Error in parsing arguments.",
                details: "Arguments: \(String(describing: arguments))"
            )
        )
    }
    private func throwNoArgumentsError(
        line: Int = #line,
        function: String = #function,
        result: FlutterResult
    ) {
        result(
            FlutterError(
                code: #function,
                message: "\(line):\(function). Error call arguments.",
                details: "No arguments"
            )
        )
    }
    private func throwPlatformError(
        line: Int = #line,
        function: String = #function,
        result: FlutterResult,
        error: Error
    ) {
        result(
            FlutterError(
                code: #function,
                message: "\(line):\(function). Error in platform method.",
                details: "\(error)"
            )
        )
    }
}
