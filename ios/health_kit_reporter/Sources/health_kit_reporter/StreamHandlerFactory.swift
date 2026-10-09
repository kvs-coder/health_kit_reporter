//
//  StreamHandlerFactory.swift
//  health_kit_reporter
//
//  Created by Kachalov, Victor on 11.04.21.
//

import Foundation
import HealthKitReporter

final class StreamHandlerFactory: NSObject {
    static func make(with reporter: HealthKitReporter, for event: EventChannel) -> StreamHandlerProtocol {
        switch event {
        case .observerQuery:
            return ObserverQueryStreamHandler.make(with: reporter)
        case .statisticsCollectionQuery:
            return StatisticsCollectionQueryStreamHandler.make(with: reporter)
        case .queryActivitySummaryUpdates:
            return QueryActivitySummaryStreamHandler.make(with: reporter)
        case .anchoredObjectQuery:
            return AnchoredObjectQueryStreamHandler.make(with: reporter)
        }
    }
}
