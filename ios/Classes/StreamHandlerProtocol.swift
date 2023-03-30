//
//  StreamHandlerProtocol.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import HealthKitReporter

public protocol StreamHandlerProtocol: FlutterStreamHandler & NSObjectProtocol {
    var reporter: HealthKitReporter { get }
    var activeQueries: Set<Query> { get set }
    var plannedQueries: Set<Query> { get set }

    func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws

    static func make(with reporter: HealthKitReporter) -> Self
}
