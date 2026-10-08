//
//  StreamHandlerFactory.swift
//  health_kit_reporter
//
//  Created by Kachalov, Victor on 11.04.21.
//

import HealthKitReporter

final class StreamHandlerFactory: NSObject {
    static func make(with reporter: HealthKitReporter, for event: EventChannel) throws -> StreamHandlerProtocol {
        switch event {
        case .observerQuery:
            return ObserverQueryStreamHandler.make(with: reporter)
        case .statisticsCollectionQuery:
            return StatisticsCollectionQueryStreamHandler.make(with: reporter)
        case .activitySummaryQuery:
            if #available(iOS 9.3, *) {
                return QueryActivitySummaryStreamHandler.make(with: reporter)
            } else {
                throw HealthKitError.notAvailable("Not available for the current iOS version")
            }
        case .anchoredObjectQuery:
            return AnchoredObjectQueryStreamHandler.make(with: reporter)
        }
    }
}
