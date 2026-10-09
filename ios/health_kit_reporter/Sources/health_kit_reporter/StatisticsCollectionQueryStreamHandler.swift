//
//  StatisticsCollectionQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import HealthKitReporter

public final class StatisticsCollectionQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var activeQueries = [QueryHandle]()
    public var plannedQueries = [QueryHandle]()
    public var eventSink: FlutterEventSink?
    public var onClose: (() -> Void)?

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension StatisticsCollectionQueryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        guard let preferredUnits = arguments["preferredUnits"] as? [[String: Any]] else {
            throw HealthKitError.invalidValue("Missing preferredUnits in \(arguments)")
        }
        let predicate = try arguments.samplesPredicate()
        let anchorDate = try arguments.date("anchorTimestamp")
        let enumerateFrom = try arguments.date("enumerateFrom")
        let enumerateTo = try arguments.date("enumerateTo")
        let intervalComponents = DateComponents.make(from: try arguments.dictionary("intervalComponents"))
        let separateBySource = arguments["separateBySource"] as? Bool ?? false
        for preferredUnit in preferredUnits {
            let preferredUnit = try PreferredUnit.make(from: preferredUnit)
            guard let type = preferredUnit.identifier.objectType as? QuantityType else {
                throw HealthKitError.invalidType("Not a quantity type: \(preferredUnit.identifier)")
            }
            let query = try reporter.reader.statisticsCollectionQuery(
                type: type,
                unit: preferredUnit.unit,
                quantitySamplePredicate: predicate,
                anchorDate: anchorDate,
                enumerateFrom: enumerateFrom,
                enumerateTo: enumerateTo,
                intervalComponents: intervalComponents,
                monitorUpdates: true,
                separateBySource: separateBySource
            ) { (statistics, error) in
                if let error = error {
                    events(FlutterError(code: EventChannel.statisticsCollectionQuery.rawValue, error: error))
                    return
                }
                guard let statistics = statistics else {
                    return
                }
                do {
                    events(try statistics.encoded())
                } catch {
                    events(FlutterError(code: EventChannel.statisticsCollectionQuery.rawValue, error: error))
                }
            }
            plannedQueries.append(query)
        }
    }

    public static func make(with reporter: HealthKitReporter) -> StatisticsCollectionQueryStreamHandler {
        StatisticsCollectionQueryStreamHandler(reporter: reporter)
    }
}
// MARK: - FlutterStreamHandler
extension StatisticsCollectionQueryStreamHandler: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        handleOnListen(eventSink: events)
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        handleOnCancel()
    }
}
