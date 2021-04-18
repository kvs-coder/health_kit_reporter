//
//  StatisticsCollectionQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation
import HealthKitReporter

public final class StatisticsCollectionQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var activeQueries = Set<Query>()
    public var plannedQueries = Set<Query>()

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension StatisticsCollectionQueryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String : Any], events: @escaping FlutterEventSink) throws {
        guard
            let identifier = arguments["identifier"] as? String,
            let unit = arguments["unit"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double,
            let anchorTimestamp = arguments["anchorTimestamp"] as? Double,
            let enumerateFrom = arguments["enumerateFrom"] as? Double,
            let enumerateTo = arguments["enumerateTo"] as? Double,
            let intervalComponents = arguments["intervalComponents"] as? [String: Any]
        else {
            return
        }
        guard let type = identifier.objectType as? QuantityType else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        let query = try reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: predicate,
            anchorDate: Date.make(from: anchorTimestamp),
            enumerateFrom: Date.make(from: enumerateFrom),
            enumerateTo: Date.make(from: enumerateTo),
            intervalComponents: DateComponents.make(
                from: intervalComponents
            ),
            monitorUpdates: true
        ) { (statistics, error) in
            guard
                error == nil,
                let statistics = statistics
            else {
                return
            }
            do {
                events(try statistics.encoded())
            } catch {
                events(nil)
            }
        }
        plannedQueries.insert(query)
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
        handleOnListen(withArguments: arguments, eventSink: events)
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        handleOnCancel(withArguments: arguments)
    }
}
