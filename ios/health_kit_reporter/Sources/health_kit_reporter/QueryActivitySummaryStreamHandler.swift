//
//  QueryActivitySummaryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import HealthKitReporter

public final class QueryActivitySummaryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var activeQueries = [QueryHandle]()
    public var plannedQueries = [QueryHandle]()

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension QueryActivitySummaryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        let query = reporter.reader.queryActivitySummary(
            predicate: try arguments.activitySummaryPredicate(),
            monitorUpdates: true
        ) { (activitySummaries, error) in
            if let error = error {
                events(FlutterError(code: "QueryActivitySummary", error: error))
                return
            }
            do {
                events(try activitySummaries.encoded())
            } catch {
                events(FlutterError(code: "QueryActivitySummary", error: error))
            }
        }
        plannedQueries.append(query)
    }

    public static func make(with reporter: HealthKitReporter) -> QueryActivitySummaryStreamHandler {
        QueryActivitySummaryStreamHandler(reporter: reporter)
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
