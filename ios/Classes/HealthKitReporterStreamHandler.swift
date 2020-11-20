//
//  HealthKitReporterStreamHandler.swift
//  health_kit_reporter
//
//  Created by Florian on 20.11.20.
//

import Foundation
import HealthKitReporter

public class HealthKitReporterStreamHandler: NSObject {
    public enum EventMethod: String {
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

    public func setEventChannelStreamHandler(
        invokeEventCallback: (HealthKitReporterInvoker?, Error?) -> Void
    ) {
        if let binaryMessenger = self.binaryMessenger {
            let eventChannel = FlutterEventChannel(
                name: "health_kit_reporter_event_channel",
                binaryMessenger: binaryMessenger
            )
            eventChannel.setStreamHandler(self)
            do {
                let reporter = try HealthKitReporter()
                let wrapper = HealthKitReporterInvoker(reporter: reporter)
                wrapper.delegate = self
                invokeEventCallback(wrapper, nil)
            }
            catch {
                invokeEventCallback(nil, error)
            }
        }
    }
}
// MARK: - FlutterStreamHandler
extension HealthKitReporterStreamHandler: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    public func onCancel(
        withArguments arguments: Any?
    ) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
// MARK: - HealthKitReporterDelegate
extension HealthKitReporterStreamHandler: HealthKitReporterDelegate {
    func report(activitySummary: [ActivitySummary], error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(activitySummary)
    }
    func report(enumeratedStatistics: Statistics?, error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(enumeratedStatistics)
    }
    func report(anchoredSamples: [Sample], error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(anchoredSamples)
    }
    func report(observeredIdentifier: String?, error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(observeredIdentifier)
    }
    func report(backgroundDeliveryEnabled: Bool, error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(backgroundDeliveryEnabled)
    }
    func report(allBackgroundDeliveriesDisabled: Bool, error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(allBackgroundDeliveriesDisabled)
    }
    func report(backgroundDeliveryDisabled: Bool, error: Error?) {
        guard error == nil else {
            eventSink?(error)
            return
        }
        eventSink?(backgroundDeliveryDisabled)
    }
}
