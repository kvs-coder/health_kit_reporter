//
//  EventChannel.swift
//  health_kit_reporter
//
//  Created by Kachalov, Victor on 11.04.21.
//

import Foundation

/// Live queries, named like their Dart methods. Every subscription gets an event channel of its own
enum EventChannel: String, CaseIterable {
    case observerQuery
    case statisticsCollectionQuery
    case queryActivitySummaryUpdates
    case anchoredObjectQuery

    func combinedWith(identifier: String) -> String {
        "health_kit_reporter_event_channel_\(self.rawValue)_\(identifier)"
    }
}
