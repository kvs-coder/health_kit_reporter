import Flutter
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
        case addQuantity
        case delete
        case deleteObjects
        case save
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "health_kit_reporter_method_channel",
            binaryMessenger: registrar.messenger()
        )

        let instance = SwiftHealthKitReporterPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
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
                guard let arguments = call.arguments as? [String: Any] else {
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
                guard let arguments = call.arguments as? [String: Any] else {
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
                guard let arguments = call.arguments as? [String: String] else {
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
        ) { (preferredUnits, error) in
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
            do {
                result(try preferredUnits.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of preffered units: \(preferredUnits)",
                        details: "\(error)"
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
            ) { (quantities, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in quantityQuery for identifier: \(identifier)",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
                        )
                    )
                    return
                }
                do {
                    result(try quantities.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of quantities: \(quantities)",
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
            ) { (categories, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in categoryQuery for identifier: \(identifier)",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
                        )
                    )
                    return
                }
                do {
                    result(try categories.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of categories: \(categories)",
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
        ) { (workouts, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in workoutQuery",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            do {
                result(try workouts.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of workouts: \(workouts)",
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
            ) { (electrocardiograms, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in electrocardiogramQuery",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
                        )
                    )
                    return
                }
                do {
                    result(try electrocardiograms.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of electrocardiograms: \(electrocardiograms)",
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
        guard let type = identifier.objectType else {
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
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
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
                            message: "Error in json encoding of sample: \(sample). Continue",
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
        guard let type = identifier.objectType as? QuantityType else {
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
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            do {
                guard let statistics = statistics else {
                    result(
                        FlutterError(
                            code: #function,
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
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let unit = arguments["unit"] as? String,
            let startDate = (arguments["startDate"] as? String)?
                .asDate(format: Date.iso8601),
            let endDate = (arguments["endDate"] as? String)?
                .asDate(format: Date.iso8601),
            let anchorDate = (arguments["anchorDate"] as? String)?
                .asDate(format: Date.iso8601),
            let enumerateFrom = (arguments["enumerateFrom"] as? String)?
                .asDate(format: Date.iso8601),
            let enumerateTo = (arguments["enumerateTo"] as? String)?
                .asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType as? QuantityType else {
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
        let intervalComponents = DateComponents.make(from: arguments)
        let monitorUpdates = (arguments["monitorUpdates"] as? String)?.boolean ?? false
        reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: predicate,
            anchorDate: anchorDate,
            enumerateFrom: enumerateFrom,
            enumerateTo: enumerateTo,
            intervalComponents: intervalComponents,
            monitorUpdates: monitorUpdates
        ) { (statistics, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in statisticsCollectionQuery",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            do {
                guard let statistics = statistics else {
                    result(
                        FlutterError(
                            code: #function,
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
        if #available(iOS 13.0, *) {
            reporter.reader.heartbeatSeriesQuery(
                predicate: predicate
            ) { (serie, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in heartbeatSeriesQuery",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
                        )
                    )
                    return
                }
                do {
                    guard let serie = serie else {
                        result(
                            FlutterError(
                                code: #function,
                                message: "Series samples was null",
                                details: nil
                            )
                        )
                        return
                    }
                    result(try serie.encoded())
                } catch {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in json encoding of serie: \(String(describing: serie))",
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
                    details: "HeartbeatSeries query is available for iOS 13."
                )
            )
        }
    }
    private func queryActivitySummary(
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
        let monitorUpdates = arguments["monitorUpdates"]?.boolean ?? false
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.reader.queryActivitySummary(
            predicate: predicate,
            monitorUpdates: monitorUpdates
        ) { (activitySummaries, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in queryActivitySummary",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            do {
                result(try activitySummaries.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of activitySummaries: \(activitySummaries)",
                        details: "\(error)"
                    )
                )
            }
        }
    }
    private func anchoredObjectQuery(
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
        guard let type = identifier.objectType else {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing ObjectType"
                )
            )
            return
        }
        let monitorUpdates = arguments["monitorUpdates"]?.boolean ?? false
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.reader.anchoredObjectQuery(
            type: type,
            predicate: predicate,
            monitorUpdates: monitorUpdates
        ) { (samples, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in queryActivitySummary",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
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
                            message: "Error in json encoding of sample: \(sample). Continue",
                            details: "\(error)"
                        )
                    )
                    continue
                }
            }
            result(jsonArray)
        }
    }
    private func sourceQuery(
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
        guard let type = identifier.objectType else {
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
        reporter.reader.sourceQuery(
            type: type,
            predicate: predicate
        ) { (sources, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in sourceQuery",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            do {
                result(try sources.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of sources: \(sources)",
                        details: "\(error)"
                    )
                )
            }
        }
    }
    private func correlationQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startDate = (arguments["startDate"] as? String)?.asDate(format: Date.iso8601),
            let endDate = (arguments["endDate"] as? String)?.asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType as? CorrelationType else {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing identifier: \(identifier)",
                    details: "Invalid identifier for any existing CorrelationType"
                )
            )
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        var typePredicates: [String: NSPredicate] = [:]
        if let typePredicatesArgument = arguments["typePredicates"] as? [String: [String: String]] {
            for (key, value) in typePredicatesArgument {
                guard
                    let startDate = value["startDate"]?.asDate(format: Date.iso8601),
                    let endDate = value["endDate"]?.asDate(format: Date.iso8601)
                else {
                    continue
                }
                let typePredicate = NSPredicate.samplesPredicate(
                    startDate: startDate,
                    endDate: endDate
                )
                typePredicates[key] = typePredicate
            }
        }
        reporter.reader.correlationQuery(
            type: type,
            predicate: predicate,
            typePredicates: typePredicates
        ) { (correlations, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in correlationQuery",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            do {
                result(try correlations.encoded())
            } catch {
                result(
                    FlutterError(
                        code: #function,
                        message: "Error in json encoding of correlations: \(correlations)",
                        details: "\(error)"
                    )
                )
            }
        }
    }
    private func observerQuery(
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
        guard let type = identifier.objectType else {
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
        reporter.observer.observerQuery(
            type: type,
            predicate: predicate
        ) { (identifier, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in observerQuery",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            guard let identifier = identifier else {
                result(
                    FlutterError(
                        code: #function,
                        message: "Identifier was null",
                        details: nil
                    )
                )
                return
            }
            result(identifier)
        }
    }
    private func enableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"],
            let frequency = arguments["frequency"]?.integer
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType else {
            result(
                FlutterError(
                    code: #function,
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
                            code: #function,
                            message: "\(#line). Error in enableBackgroundDelivery",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing frequency: \(frequency)",
                    details: "\(error)"
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
                        code: #function,
                        message: "\(#line). Error in disableAllBackgroundDelivery",
                        details: "\(error!)"
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
                    code: #function,
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
                        code: #function,
                        message: "\(#line). Error in disableBackgroundDelivery",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
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
        do {
            let workoutConfiguration = try WorkoutConfiguration.make(from: arguments)
            reporter.manager.startWatchApp(with: workoutConfiguration) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in startWatchApp",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
                        )
                    )
                    return
                }
                result(success)
            }
        } catch {
            result(
                FlutterError(
                    code: #function,
                    message: "\(#line). Error in creating WorkoutConfiguration",
                    details: "Arguments: \(String(describing: arguments)). \(error)"
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
                    code: #function,
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
                    code: #function,
                    message: message,
                    details: "\(error)"
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
            let device = arguments["device"] as? [String: Any],
            let workout = arguments["workout"] as? [String: Any]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        do {
            reporter.writer.addCategory(
                try category.map {
                    try Category.make(from: $0)
                },
                from: try Device.make(from: device),
                to: try Workout.make(from: workout)
            ) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in addCategory",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
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
            let device = arguments["device"] as? [String: Any],
            let workout = arguments["workout"] as? [String: Any]
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        do {
            reporter.writer.addQuantitiy(try quantity.map {
                try Quantity.make(from: $0)
            },
            from: try Device.make(from: device),
            to: try Workout.make(from: workout)) { (success, error) in
                guard error == nil else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "\(#line). Error in addQuantitiy",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
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
                            code: #function,
                            message: "\(#line). Error in delete",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
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
            let startDate = (arguments["startDate"] as? String)?
                .asDate(format: Date.iso8601),
            let endDate = (arguments["endDate"] as? String)?
                .asDate(format: Date.iso8601)
        else {
            throwParsingArgumentsError(result: result, arguments: arguments)
            return
        }
        guard let type = identifier.objectType else {
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
        reporter.writer.deleteObjects(
            of: type,
            predicate: predicate
        ) { (success, id, error) in
            guard error == nil else {
                result(
                    FlutterError(
                        code: #function,
                        message: "\(#line). Error in delete",
                        details: "Arguments: \(String(describing: arguments)). \(error!)"
                    )
                )
                return
            }
            let resultDictionary: [String: Any] = [
                "status": success,
                "id": id
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
                            code: #function,
                            message: "\(#line). Error in save",
                            details: "Arguments: \(String(describing: arguments)). \(error!)"
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
            return try Quantity.make(from: quantity)
        }
        if let category = arguments["category"] as? [String: Any] {
            return try Category.make(from: category)
        }
        if let workout = arguments["workout"] as? [String: Any] {
            return try Workout.make(from: workout)
        }
        throw HealthKitError.invalidValue("Invalid arguments: \(arguments)")
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
                details: "Arguments: \(String(describing: arguments))."
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
