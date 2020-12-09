//
//  StreamHandlerProtocol.swift
//  health_kit_reporter
//
//  Created by Florian on 09.12.20.
//

import Foundation
import HealthKitReporter

protocol StreamHandlerProtocol {
    associatedtype QueryType where QueryType: Query

    var reporter: HealthKitReporter { get }
    var query: QueryType? { get set }

    func setQuery(arguments: [String: Any], events: @escaping FlutterEventSink) throws
}
