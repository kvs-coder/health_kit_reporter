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
                <#code#>
            case .workoutQuery:
                <#code#>
            case .electrocardiogramQuery:
                <#code#>
            case .sampleQuery:
                <#code#>
            case .statisticsQuery:
                <#code#>
            case .statisticsCollectionQuery:
                <#code#>
            case .heartbeatSeriesQuery:
                <#code#>
            case .queryActivitySummary:
                <#code#>
            case .anchoredObjectQuery:
                <#code#>
            case .sourceQuery:
                <#code#>
            case .correlationQuery:
                <#code#>
            case .observerQuery:
                <#code#>
            case .enableBackgroundDelivery:
                <#code#>
            case .disableAllBackgroundDelivery:
                <#code#>
            case .disableBackgroundDelivery:
                <#code#>
            case .startWatchApp:
                <#code#>
            case .isAuthorizedToWrite:
                <#code#>
            case .addCategory:
                <#code#>
            case .addQuantitiy:
                <#code#>
            case .delete:
                <#code#>
            case .save:
                <#code#>
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
    private func characteristicsQuery(
        reporter: HealthKitReporter,
        result: FlutterResult
    ) {
        do {
            let characteristics = try reporter.reader.characteristicsQuery()
            result(try characteristics.encoded())
        } catch  {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in platform method",
                    details: "\(error)"
                )
            )
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
            result(
                FlutterError(
                    code: #function,
                    message: "Error in parsing arguments",
                    details: "Arguments: \(arguments)"
                )
            )
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
                if error != nil {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error in quantityQuery for identifier: \(identifier)",
                            details: "Arguments: \(arguments)"
                        )
                    )
                } else {
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
        } catch {
            result(
                FlutterError(
                    code: #function,
                    message: "Error in platform method",
                    details: "\(error)"
                )
            )
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
}
// MARK: - Helper functions
extension SwiftHealthKitReporterPlugin {
    private func parse(arguments: [String]) -> [ObjectType] {
        var types: [ObjectType] = []
        for argument in arguments {
            if let type = try? QuantityType.make(from: argument) {
                types.append(type)
            }
            if let type = try? CategoryType.make(from: argument) {
                types.append(type)
            }
            if let type = try? CharacteristicType.make(from: argument) {
                types.append(type)
            }
            if let type = try? SeriesType.make(from: argument) {
                types.append(type)
            }
            if let type = try? CorrelationType.make(from: argument) {
                types.append(type)
            }
            if let type = try? DocumentType.make(from: argument) {
                types.append(type)
            }
            if let type = try? ActivitySummaryType.make(from: argument) {
                types.append(type)
            }
            if let type = try? WorkoutType.make(from: argument) {
                types.append(type)
            }
            if #available(iOS 14.0, *) {
                if let type = try? ElectrocardiogramType.make(from: argument) {
                    types.append(type)
                }
            }
        }
        return types
    }
    private func throwParsingArgumentsError(
        result: FlutterResult,
        arguments: Any
    ) {
        result(
            FlutterError(
                code: #function,
                message: "Error in parsing arguments",
                details: "Arguments: \(String(describing: arguments))"
            )
        )
    }
    private func throwNoArgumentsError(result: FlutterResult) {
        result(
            FlutterError(
                code: #function,
                message: "Error call arguments",
                details: "No arguments"
            )
        )
    }
}
