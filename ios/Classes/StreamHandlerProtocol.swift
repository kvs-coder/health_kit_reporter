//
//  StreamHandlerProtocol.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import HealthKitReporter

public protocol StreamHandlerProtocol: FlutterStreamHandler & NSObjectProtocol {
    var reporter: HealthKitReporter { get }
    var query: Query? { get set }

    func setQuery(arguments: [String: Any], events: @escaping FlutterEventSink) throws
    
    static func make(with reporter: HealthKitReporter) -> Self
}

extension StreamHandlerProtocol {
    var identifier: String? {
        var identifier: String?
        if #available(iOS 9.3, *) {
            identifier = query?.objectType?.identifier
        } else {
            identifier = query?.sampleType?.identifier
        }
        return identifier
    }
}
