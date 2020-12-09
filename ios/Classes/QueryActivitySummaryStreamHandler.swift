//
//  QueryActivitySummaryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Florian on 09.12.20.
//

import Foundation
import HealthKitReporter

public class QueryActivitySummaryStreamHandler: NSObject {
    let reporter: HealthKitReporter
    var query: ActivitySummaryQuery?

    public init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension QueryActivitySummaryStreamHandler: StreamHandlerProtocol {
    func setQuery(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        guard
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        let monitorUpdates = (arguments["monitorUpdates"] as? String)?.boolean ?? true
        query = reporter.reader.queryActivitySummary(
            predicate: predicate,
            monitorUpdates: monitorUpdates
        ) { (activitySummaries, error) in
            guard error == nil else {
                return
            }
            do {
                events(try activitySummaries.encoded())
            } catch {
                events(nil)
            }
        }
    }
}
// MARK: - FlutterStreamHandler
extension QueryActivitySummaryStreamHandler: FlutterStreamHandler {
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
