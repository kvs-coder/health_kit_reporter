//
//  Extensions+FlutterStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation

extension FlutterStreamHandler where Self: NSObject & StreamHandlerProtocol {
    private func hasAlreadyActiveQuery(with identifier: String) -> Bool {
        for activeQuery in activeQueries {
            if activeQuery.identifier == identifier {
                return true
            }
        }
        return false
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
        do {
            try setQueries(
                arguments: arguments,
                events: events
            )
            guard let identifier = arguments["identifier"] as? String else {
                return FlutterError(
                    code: className,
                    message: "Error call arguments.",
                    details: "No identifier."
                )
            }
            let isActive = hasAlreadyActiveQuery(with: identifier)
            if isActive {
                return FlutterError(
                    code: className,
                    message: "Error setting query.",
                    details: "Query is already running."
                )
            } else {
                for plannedQuery in plannedQueries {
                    reporter.manager.executeQuery(plannedQuery)
                    activeQueries.insert(plannedQuery)
                }
                plannedQueries.removeAll()
            }
        } catch {
            return FlutterError(
                code: className,
                message: "Error setting query.",
                details: error
            )
        }
        return nil
    }
    func handleOnCancel(withArguments arguments: Any?) -> FlutterError? {
        activeQueries.forEach { reporter.manager.stopQuery($0) }
        return nil
    }
}
