//
//  AnchoredObjectQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Florian on 09.12.20.
//

import Foundation
import HealthKitReporter

public class AnchoredObjectQueryStreamHandler: NSObject {
    let reporter: HealthKitReporter
    var query: AnchoredObjectQuery?

    public init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension AnchoredObjectQueryStreamHandler: StreamHandlerProtocol {
    func setQuery(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
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
        query = try reporter.reader.anchoredObjectQuery(
            type: type,
            predicate: predicate,
            monitorUpdates: true
        ) { (query, samples, deletedObjects, anchor, error) in
            guard error == nil else {
                return
            }
            var jsonDictionary: [String: Any] = [:]
            var samplesArray: [String] = []
            for sample in samples {
                do {
                    let encoded = try sample.encoded()
                    samplesArray.append(encoded)
                } catch {
                    continue
                }
            }
            var deletedObjectsArray: [String] = []
            for deletedObject in deletedObjects {
                do {
                    let encoded = try deletedObject.encoded()
                    deletedObjectsArray.append(encoded)
                } catch {
                    continue
                }
            }
            jsonDictionary["samples"] = samplesArray
            jsonDictionary["deletedObjects"] = deletedObjectsArray
            events(jsonDictionary)
        }
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
