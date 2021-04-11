//
//  ObserverQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 08.12.20.
//

import Foundation
import HealthKitReporter

public final class ObserverQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var query: Query?

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension ObserverQueryStreamHandler: StreamHandlerProtocol {
    public func setQuery(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            return
        }
        guard let type = identifier.objectType as? SampleType else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        query = try reporter.observer.observerQuery(
            type: type,
            predicate: predicate
        ) { (query, identifier, error) in
            guard
                error == nil,
                let identifier = identifier
            else {
                return
            }
            events(["identifier": identifier])
        }
    }

    public static func make(with reporter: HealthKitReporter) -> ObserverQueryStreamHandler {
        ObserverQueryStreamHandler(reporter: reporter)
    }
}
// MARK: - FlutterStreamHandler
extension ObserverQueryStreamHandler: FlutterStreamHandler {
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
