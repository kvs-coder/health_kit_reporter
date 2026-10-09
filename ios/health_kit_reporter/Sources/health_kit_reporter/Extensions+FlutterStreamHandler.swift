//
//  Extensions+FlutterStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import Foundation

extension StreamHandlerProtocol {
    /// Plans the queries before Dart listens, so invalid arguments fail the method call
    func plan(arguments: [String: Any]) throws {
        do {
            // Flutter expects events on the platform thread; HealthKit calls back on its own queues
            try setQueries(arguments: arguments) { [weak self] event in
                DispatchQueue.main.async { self?.eventSink?(event) }
            }
        } catch {
            plannedQueries.removeAll()
            throw error
        }
    }

    func handleOnListen(eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        for plannedQuery in plannedQueries {
            reporter.manager.executeQuery(plannedQuery)
            activeQueries.append(plannedQuery)
        }
        plannedQueries.removeAll()
        return nil
    }

    func handleOnCancel() -> FlutterError? {
        activeQueries.forEach { reporter.manager.stopQuery($0) }
        activeQueries.removeAll()
        plannedQueries.removeAll()
        eventSink = nil
        onClose?()
        onClose = nil
        return nil
    }
}
