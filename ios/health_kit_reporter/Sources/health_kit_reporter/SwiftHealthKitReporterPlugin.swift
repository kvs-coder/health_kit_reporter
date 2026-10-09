//
//  SwiftHealthKitReporterPlugin.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 11.11.20.
//

import Flutter
import HealthKitReporter

public class SwiftHealthKitReporterPlugin: NSObject, FlutterPlugin {
    let binaryMessenger: FlutterBinaryMessenger
    let reporter: HealthKitReporter?
    /// The event channel of every live subscription, until Dart cancels it
    var eventChannels = [String: FlutterEventChannel]()

    init(binaryMessenger: FlutterBinaryMessenger, reporter: HealthKitReporter?) {
        self.binaryMessenger = binaryMessenger
        self.reporter = reporter
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // Without Health data every call but isAvailable replies HealthKitError.notAvailable
        let instance = SwiftHealthKitReporterPlugin(
            binaryMessenger: registrar.messenger(),
            reporter: HealthKitReporter.isHealthDataAvailable ? HealthKitReporter() : nil
        )
        for method in MethodChannel.allCases {
            let methodChannel = FlutterMethodChannel(
                name: method.rawValue,
                binaryMessenger: instance.binaryMessenger
            )
            registrar.addMethodCallDelegate(instance, channel: methodChannel)
        }
    }
    /**
     Plans the live queries of a subscription on an event channel of its own
     and returns the channel's name; Dart listens to it to run the queries
     and cancels it to stop them, without touching other subscriptions
     */
    func openEventChannel(
        _ event: EventChannel,
        reporter: HealthKitReporter,
        arguments: [String: Any]
    ) throws -> String {
        let handler = StreamHandlerFactory.make(with: reporter, for: event)
        try handler.plan(arguments: arguments)
        let name = event.combinedWith(identifier: UUID().uuidString)
        let eventChannel = FlutterEventChannel(name: name, binaryMessenger: binaryMessenger)
        handler.onClose = { [weak self] in
            // Not while the channel still handles the cancel message
            DispatchQueue.main.async {
                self?.eventChannels.removeValue(forKey: name)?.setStreamHandler(nil)
            }
        }
        eventChannel.setStreamHandler(handler)
        eventChannels[name] = eventChannel
        return name
    }
}
