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
                guard let arguments = arguments as? [String: String] else {
                    return nil
                }
                queryActivitySummary(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            case .anchoredObjectQuery:
                guard let arguments = arguments as? [String: String] else {
                    return nil
                }
                anchoredObjectQuery(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            case .observerQuery:
                guard let arguments = arguments as? [String: String] else {
                    return nil
                }
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
            let startDate = (arguments["startDate"] as? String)?
                .asDate(format: Date.iso8601),
            let endDate = (arguments["endDate"] as? String)?
                .asDate(format: Date.iso8601),
            let anchorDate = (arguments["anchorDate"] as? String)?
                .asDate(format: Date.iso8601),
            let enumerateFrom = (arguments["enumerateFrom"] as? String)?
                .asDate(format: Date.iso8601),
            let enumerateTo = (arguments["enumerateTo"] as? String)?
                .asDate(format: Date.iso8601),
        let intervalComponents = arguments["intervalComponents"] as? [String: Any]
        else {
            return
        }
        guard let type = identifier.objectType as? QuantityType else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        let monitorUpdates = (
            arguments["monitorUpdates"] as? String
        )?.boolean ?? true
        reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: predicate,
            anchorDate: anchorDate,
            enumerateFrom: enumerateFrom,
            enumerateTo: enumerateTo,
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
        arguments: [String: String],
        events: @escaping FlutterEventSink
    ) {
        guard
            let startDate = arguments["startDate"]?
                .asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?
                .asDate(format: Date.iso8601)
        else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        let monitorUpdates = arguments["monitorUpdates"]?.boolean ?? true
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
        arguments: [String: String],
        events: @escaping FlutterEventSink
    ) {
        guard
            let identifier = arguments["identifier"],
            let startDate = arguments["startDate"]?
                .asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?
                .asDate(format: Date.iso8601)
        else {
            return
        }
        guard let type = identifier.objectType else {
            return
        }
        let monitorUpdates = arguments["monitorUpdates"]?.boolean ?? true
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.reader.anchoredObjectQuery(
            type: type,
            predicate: predicate,
            monitorUpdates: monitorUpdates
        ) { (samples, error) in
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
        arguments: [String: String],
        events: @escaping FlutterEventSink
    ) {
        guard
            let identifier = arguments["identifier"],
            let startDate = arguments["startDate"]?
                .asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?
                .asDate(format: Date.iso8601)
        else {
            return
        }
        guard let type = identifier.objectType else {
            return
        }
        let predicate = NSPredicate.samplesPredicate(
            startDate: startDate,
            endDate: endDate
        )
        reporter.observer.observerQuery(
            type: type,
            predicate: predicate
        ) { (identifier, error) in
            guard error == nil else {
                return
            }
            guard let identifier = identifier else {
                return
            }
            let dictionary: [String: Any] = [
                "event": Method.anchoredObjectQuery.rawValue,
                "result": [
                    "observingTypeIdentifier": identifier
                ]
            ]
            events(dictionary)
        }
    }
}
