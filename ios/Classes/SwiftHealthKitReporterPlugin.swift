import Flutter
import UIKit
import HealthKitReporter

extension Data {
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
}

public class SwiftHealthKitReporterPlugin: NSObject, FlutterPlugin {
    private enum Method: String {
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
        case requestAuthorization
        case preferredUnits
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
            case .characteristicsQuery:
                characteristicsQuery(reporter: reporter, result: result)
            case .quantityQuery:
                guard let arguments = call.arguments as? [String: Any] else {
                    result(
                        FlutterError(
                            code: #function,
                            message: "Error call arguments",
                            details: "No arguments"
                        )
                    )
                    return
                }
                quantityQuery(
                    reporter: reporter,
                    arguments: arguments,
                    result: result
                )
            //            case .categoryQuery:
            //
            //            case .workoutQuery:
            //
            //            case .electrocardiogramQuery:
            //
            //            case .sampleQuery:
            //
            //            case .statisticsQuery:
            //
            //            case .statisticsCollectionQuery:
            //
            //            case .heartbeatSeriesQuery:
            //
            //            case .queryActivitySummary:
            //
            //            case .anchoredObjectQuery:
            //
            //            case .sourceQuery:
            //
            //            case .correlationQuery:
            //
            //            case .observerQuery:
            //
            //            case .enableBackgroundDelivery:
            //
            //            case .disableAllBackgroundDelivery:
            //
            //            case .disableBackgroundDelivery:
            //
            //            case .requestAuthorization:
            //
            //            case .preferredUnits:
            //
            //            case .startWatchApp:
            //
            //            case .isAuthorizedToWrite:
            //
            //            case .addCategory:
            //
            //            case .addQuantitiy:
            //
            //            case .delete:
            //
            //            case .save:
            //
            default: return
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
        arguments: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let unit = arguments["unit"] as? String,
            let startDate = (arguments["startDate"] as? String)?
                .asDate(format: Date.yyyyMMdd),
            let endDate = (arguments["endDate"] as? String)?
                .asDate(format: Date.yyyyMMdd)
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
}
