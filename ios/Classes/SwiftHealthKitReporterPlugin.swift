import Flutter
import UIKit
import HealthKitReporter

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
//        let reporter = try HealthKitReporter()
//        switch method {
//        case .characteristicsQuery:
//            let characteristics = try reporter.reader.characteristicsQuery()
//            let data = try JSONEncoder().encode(characteristics)
//            let jsonString = String(data: data, encoding: .utf8)
//            result(jsonString)
//        case .quantityQuery:
//            try reporter.reader
//        case .categoryQuery:
//            <#code#>
//        case .workoutQuery:
//            <#code#>
//        case .electrocardiogramQuery:
//            <#code#>
//        case .sampleQuery:
//            <#code#>
//        case .statisticsQuery:
//            <#code#>
//        case .statisticsCollectionQuery:
//            <#code#>
//        case .heartbeatSeriesQuery:
//            <#code#>
//        case .queryActivitySummary:
//            <#code#>
//        case .anchoredObjectQuery:
//            <#code#>
//        case .sourceQuery:
//            <#code#>
//        case .correlationQuery:
//            <#code#>
//        case .observerQuery:
//            <#code#>
//        case .enableBackgroundDelivery:
//            <#code#>
//        case .disableAllBackgroundDelivery:
//            <#code#>
//        case .disableBackgroundDelivery:
//            <#code#>
//        case .requestAuthorization:
//            <#code#>
//        case .preferredUnits:
//            <#code#>
//        case .startWatchApp:
//            <#code#>
//        case .isAuthorizedToWrite:
//            <#code#>
//        case .addCategory:
//            <#code#>
//        case .addQuantitiy:
//            <#code#>
//        case .delete:
//            <#code#>
//        case .save:
//            <#code#>
//        }
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
