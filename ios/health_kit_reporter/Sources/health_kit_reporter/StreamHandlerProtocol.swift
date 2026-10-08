//
//  StreamHandlerProtocol.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import HealthKitReporter

public protocol StreamHandlerProtocol: FlutterStreamHandler & NSObjectProtocol {
    var reporter: HealthKitReporter { get }
    var activeQueries: [QueryHandle] { get set }
    var plannedQueries: [QueryHandle] { get set }

    func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws

    static func make(with reporter: HealthKitReporter) -> Self
}
