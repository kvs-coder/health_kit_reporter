//
//  Extensions+FlutterStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import Foundation

extension FlutterStreamHandler where Self: NSObject & StreamHandlerProtocol {
    private func executePlannedQueries() {
        for plannedQuery in plannedQueries {
            reporter.manager.executeQuery(plannedQuery)
            activeQueries.append(plannedQuery)
        }
        plannedQueries.removeAll()
    }

    func handleOnListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        guard let arguments = arguments as? [String: Any] else {
            return FlutterError(
                code: self.className,
                message: "Error call arguments.",
                details: "No arguments"
            )
        }
        // Flutter expects events on the platform thread; HealthKit calls back on its own queues
        let mainThreadEvents: FlutterEventSink = { event in
            DispatchQueue.main.async { events(event) }
        }
        do {
            try setQueries(
                arguments: arguments,
                events: mainThreadEvents
            )
            executePlannedQueries()
        } catch {
            plannedQueries.removeAll()
            return FlutterError(
                code: className,
                message: error.localizedDescription,
                details: String(describing: error)
            )
        }
        return nil
    }
    func handleOnCancel(withArguments arguments: Any?) -> FlutterError? {
        activeQueries.forEach { reporter.manager.stopQuery($0) }
        activeQueries.removeAll()
        return nil
    }
}
