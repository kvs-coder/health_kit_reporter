//
//  AnchoredObjectQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import HealthKitReporter

public final class AnchoredObjectQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var activeQueries = [QueryHandle]()
    public var plannedQueries = [QueryHandle]()

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension AnchoredObjectQueryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        let predicate = try arguments.samplesPredicate()
        let descriptors = try arguments.strings("identifiers").map {
            QueryDescriptor(type: try $0.asSampleType(), predicate: predicate)
        }
        // One query for every type, so a single anchor covers all of them
        let query = try reporter.reader.anchoredObjectQuery(
            descriptors: descriptors,
            anchor: try arguments.anchor(),
            monitorUpdates: true
        ) { (_, samples, deletedObjects, anchor, error) in
            if let error = error {
                events(FlutterError(code: "AnchoredObjectQuery", error: error))
                return
            }
            events([
                "samples": samples.compactMap { try? $0.encoded() },
                "deletedObjects": deletedObjects.compactMap { try? $0.encoded() },
                "anchor": anchor.asArgument as Any
            ])
        }
        plannedQueries.append(query)
    }

    public static func make(with reporter: HealthKitReporter) -> AnchoredObjectQueryStreamHandler {
        AnchoredObjectQueryStreamHandler(reporter: reporter)
    }
}
// MARK: - FlutterStreamHandler
extension AnchoredObjectQueryStreamHandler: FlutterStreamHandler {
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
