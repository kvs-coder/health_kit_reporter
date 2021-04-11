//
//  Extensions+FlutterStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation

extension FlutterStreamHandler where Self: NSObject & StreamHandlerProtocol {
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
            try setQuery(
                arguments: arguments,
                events: events
            )
            if let query = self.query {
                reporter.manager.executeQuery(query)
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
        guard let query = self.query else {
            return FlutterError(
                code: className,
                message: "Error setting query.",
                details: "Query was null"
            )
        }
        reporter.manager.stopQuery(query)
        return nil
    }
}
