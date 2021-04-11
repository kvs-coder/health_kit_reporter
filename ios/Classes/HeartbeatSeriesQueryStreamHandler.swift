//
//  HeartbeatSeriesQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation
import HealthKitReporter

public final class HeartbeatSeriesQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var query: Query?

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension HeartbeatSeriesQueryStreamHandler: StreamHandlerProtocol {
    public func setQuery(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
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
        if #available(iOS 13.0, *) {
            query = try reporter.reader.heartbeatSeriesQuery(
                predicate: predicate
            ) { (heartbeatSerie, error) in
                guard
                    error == nil,
                    let heartbeatSerie = heartbeatSerie
                else {
                    return
                }
                do {
                    events(try heartbeatSerie.encoded())
                } catch {
                    events(nil)
                }
            }
        } else {
            events(nil)
        }
    }

    public static func make(with reporter: HealthKitReporter) -> HeartbeatSeriesQueryStreamHandler {
        HeartbeatSeriesQueryStreamHandler(reporter: reporter)
    }
}
// MARK: - FlutterStreamHandler
extension HeartbeatSeriesQueryStreamHandler: FlutterStreamHandler {
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
