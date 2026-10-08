//
//  EventChannel.swift
//  health_kit_reporter
//
//  Created by Kachalov, Victor on 11.04.21.
//

import Foundation

enum EventChannel: String, CaseIterable {
    case observerQuery = "health_kit_reporter_event_channel_observer_query"
    case statisticsCollectionQuery = "health_kit_reporter_event_channel_statistics_collection_query"
    case activitySummaryQuery = "health_kit_reporter_event_channel_query_activity_summary"
    case anchoredObjectQuery = "health_kit_reporter_event_channel_anchored_object_query"

    func combinedWith(identifier: String) -> String {
        "\(self.rawValue)_\(identifier)"
    }
}
