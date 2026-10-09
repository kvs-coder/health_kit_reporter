//
//  ObserverQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 08.12.20.
//

import Flutter
import HealthKitReporter

public final class ObserverQueryStreamHandler: NSObject {
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
extension ObserverQueryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        let predicate = try arguments.samplesPredicate()
        for identifier in try arguments.strings("identifiers") {
            let query = try reporter.observer.observerQuery(
                type: try identifier.asSampleType(),
                predicate: predicate
            ) { (_, identifier, error, completion) in
                defer { completion() }
                if let error = error {
                    events(FlutterError(code: EventChannel.observerQuery.rawValue, error: error))
                    return
                }
                guard let identifier = identifier else {
                    return
                }
                events(["identifier": identifier])
            }
            plannedQueries.append(query)
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
        handleOnListen(eventSink: events)
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        handleOnCancel()
    }
}
