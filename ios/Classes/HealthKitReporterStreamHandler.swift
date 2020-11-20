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
        case enableBackgroundDelivery
        case disableAllBackgroundDelivery
        case disableBackgroundDelivery
    }

    private let binaryMessenger: FlutterBinaryMessenger?
    private var eventSink: FlutterEventSink?

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
            case .enableBackgroundDelivery:
                guard let arguments = arguments as? [String: String] else {
                    return nil
                }
                enableBackgroundDelivery(
                    reporter: reporter,
                    arguments: arguments,
                    events: events
                )
            case .disableAllBackgroundDelivery:
                disableAllBackgroundDelivery(
                    reporter: reporter,
                    events: events
                )
            case .disableBackgroundDelivery:
                guard let arguments = arguments as? [String: String] else {
                    return nil
                }
                disableBackgroundDelivery(
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
        self.eventSink = nil
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
                .asDate(format: Date.iso8601)
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
        let intervalComponents = DateComponents.make(from: arguments)
        let monitorUpdates = (arguments["monitorUpdates"] as? String)?.boolean ?? true
        reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: predicate,
            anchorDate: anchorDate,
            enumerateFrom: enumerateFrom,
            enumerateTo: enumerateTo,
            intervalComponents: intervalComponents,
            monitorUpdates: monitorUpdates
        ) { (statistics, error) in
            guard error == nil else {
                return
            }
            do {
                guard let statistics = statistics else {
                    return
                }
                events(try statistics.encoded())
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
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
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
                events(try activitySummaries.encoded())
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
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
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
            events(jsonArray)
        }
    }
    private func observerQuery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        events: @escaping FlutterEventSink
    ) {
        guard
            let identifier = arguments["identifier"],
            let startDate = arguments["startDate"]?.asDate(format: Date.iso8601),
            let endDate = arguments["endDate"]?.asDate(format: Date.iso8601)
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
            events(["observingTypeIdentifier": identifier])
        }
    }
    private func enableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        events: @escaping FlutterEventSink
    ) {
        guard
            let identifier = arguments["identifier"],
            let frequency = arguments["frequency"]?.integer
        else {
            return
        }
        guard let type = identifier.objectType else {
            return
        }
        do {
            let updateFrequency = try UpdateFrequency.make(from: frequency)
            reporter.observer.enableBackgroundDelivery(
                type: type,
                frequency: updateFrequency
            ) { (success, error) in
                guard error == nil else {
                    return
                }
                events(["enableBackgroundDelivery": success])
            }
        } catch {
            events(nil)
        }
    }
    private func disableAllBackgroundDelivery(
        reporter: HealthKitReporter,
        events: @escaping FlutterEventSink
    ) {
        reporter.observer.disableAllBackgroundDelivery { (success, error) in
            guard error == nil else {
                return
            }
            events(["disableAllBackgroundDelivery": success])
        }
    }
    private func disableBackgroundDelivery(
        reporter: HealthKitReporter,
        arguments: [String: String],
        events: @escaping FlutterEventSink
    ) {
        guard let identifier = arguments["identifier"] else {
            return
        }
        guard let type = identifier.objectType else {
            return
        }
        reporter.observer.disableBackgroundDelivery(
            type: type
        ) { (success, error) in
            guard error == nil else {
                return
            }
            events(["disableBackgroundDelivery": success])
        }
    }
}
