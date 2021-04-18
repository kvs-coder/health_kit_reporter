//
//  WorkoutRouteQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation
import HealthKitReporter

public final class WorkoutRouteQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var activeQueries = Set<Query>()
    public var plannedQueries = Set<Query>()

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
}
// MARK: - StreamHandlerProtocol
extension WorkoutRouteQueryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
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
        if #available(iOS 13.0, *) {
            let query = try reporter.reader.workoutRouteQuery(
                predicate: predicate
            ) { (workoutRoute, error) in
                guard
                    error == nil,
                    let workoutRoute = workoutRoute
                else {
                    return
                }
                do {
                    events(try workoutRoute.encoded())
                } catch {
                    events(nil)
                }
            }
            plannedQueries.insert(query)
        } else {
            events(nil)
        }
    }
    
    public static func make(with reporter: HealthKitReporter) -> WorkoutRouteQueryStreamHandler {
        WorkoutRouteQueryStreamHandler(reporter: reporter)
    }
}

// MARK: - FlutterStreamHandler
extension WorkoutRouteQueryStreamHandler: FlutterStreamHandler {
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
