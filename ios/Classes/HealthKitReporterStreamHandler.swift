//
//  HealthKitReporterStreamHandler.swift
//  health_kit_reporter
//
//  Created by Florian on 20.11.20.
//

import Foundation
import HealthKitReporter

public class HealthKitReporterStreamHandler: NSObject {
    public enum Method: String {
        case statisticsCollectionQuery
        case queryActivitySummary
        case anchoredObjectQuery
        case observerQuery
    }

    private let binaryMessenger: FlutterBinaryMessenger?

    public init(viewController: UIViewController) {
        let flutterViewController = viewController as? FlutterViewController
        self.binaryMessenger = flutterViewController?.binaryMessenger
    }

    public func setEventChannelStreamHandler() {
        if let binaryMessenger = self.binaryMessenger {
            let eventChannel = FlutterEventChannel(
                name: "health_kit_reporter_event_channel",
                binaryMessenger: binaryMessenger
            )
            eventChannel.setStreamHandler(self)
        }
    }
}
// MARK: - FlutterStreamHandler
extension HealthKitReporterStreamHandler: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        guard let arguments = arguments as? [String: Any] else {
            return FlutterError(
                code: #function,
                message: "\(#line). Error call arguments.",
                details: "No arguments"
            )
        }
        guard let eventMethod = arguments["eventMethod"] as? String else {
            return FlutterError(
                code: #function,
                message: "Invalid function name: \(arguments)",
                details: "Wrong arguments"
            )
        }
        guard let method = Method.init(rawValue: eventMethod) else {
            return FlutterError(
                code: #function,
                message: "Method enum can not be represented",
                details: "Raw value was: \(eventMethod)"
            )
        }
        do {
            let reporter = try HealthKitReporter()
            switch method {
            case .statisticsCollectionQuery:
                statisticsCollectionQuery(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            case .queryActivitySummary:
                queryActivitySummary(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            case .anchoredObjectQuery:
                anchoredObjectQuery(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            case .observerQuery:
                observerQuery(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            }
        } catch {
            events(nil)
        }
        return nil
    }
    public func onCancel(
        withArguments arguments: Any?
    ) -> FlutterError? {
        return nil
    }
}
// MARK: - EventChannel Methods
extension HealthKitReporterStreamHandler {
    private func statisticsCollectionQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        events: @escaping FlutterEventSink
    ) {
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
        let monitorUpdates = (
            arguments["monitorUpdates"] as? String
        )?.boolean ?? true
        reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: predicate,
            anchorDate: Date.make(from: anchorTimestamp),
            enumerateFrom: Date.make(from: enumerateFrom),
            enumerateTo: Date.make(from: enumerateTo),
            intervalComponents: DateComponents.make(
                from: intervalComponents
            ),
            monitorUpdates: monitorUpdates
        ) { (statistics, error) in
            guard error == nil else {
                return
            }
            do {
                guard let statistics = statistics else {
                    return
                }
                let dictionary: [String: Any] = [
                    "event": Method.statisticsCollectionQuery.rawValue,
                    "result": try statistics.encoded()
                ]
                events(dictionary)
            } catch {
                events(nil)
            }
        }
    }
    private func queryActivitySummary(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        events: @escaping FlutterEventSink
    ) {
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
        reporter.reader.queryActivitySummary(
            predicate: predicate,
            monitorUpdates: monitorUpdates
        ) { (activitySummaries, error) in
            guard error == nil else {
                return
            }
            do {
                let dictionary: [String: Any] = [
                    "event": Method.queryActivitySummary.rawValue,
                    "result": try activitySummaries.encoded()
                ]
                events(dictionary)
            } catch {
                events(nil)
            }
        }
    }
    private func anchoredObjectQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        events: @escaping FlutterEventSink
    ) {
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
        let monitorUpdates = (arguments["monitorUpdates"] as? String)?.boolean ?? true
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        reporter.reader.anchoredObjectQuery(
            type: type,
            predicate: predicate,
            monitorUpdates: monitorUpdates
        ) { (_, samples, error) in
            guard error == nil else {
                return
            }
            var jsonArray: [String] = []
            for sample in samples {
                do {
                    let encoded = try sample.encoded()
                    jsonArray.append(encoded)
                } catch {
                    continue
                }
            }
            let dictionary: [String: Any] = [
                "event": Method.anchoredObjectQuery.rawValue,
                "result": jsonArray
            ]
            events(dictionary)
        }
    }
    private func observerQuery(
        reporter: HealthKitReporter,
        arguments: [String: Any],
        events: @escaping FlutterEventSink
    ) {
        guard
            let identifier = arguments["identifier"] as? String,
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            return
        }
        guard let type = identifier.objectType else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        reporter.observer.observerQuery(
            type: type,
            predicate: predicate
        ) { (_, identifier, error) in
            guard error == nil else {
                return
            }
            guard let identifier = identifier else {
                return
            }
            let dictionary: [String: Any] = [
                "event": Method.observerQuery.rawValue,
                "result": [
                    "observingTypeIdentifier": identifier
                ]
            ]
            events(dictionary)
        }
    }
}
