//
//  HeartbeatSeriesQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Florian on 09.12.20.
//

import Foundation
import HealthKitReporter

public class HeartbeatSeriesQueryStreamHandler: NSObject {
    let reporter: HealthKitReporter
    var query: SampleQuery?

    public init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension HeartbeatSeriesQueryStreamHandler: StreamHandlerProtocol {
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
