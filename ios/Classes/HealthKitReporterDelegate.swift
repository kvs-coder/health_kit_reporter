//
//  HealthKitReporterDelegate.swift
//  health_kit_reporter
//
//  Created by Florian on 20.11.20.
//

import Foundation
import HealthKitReporter

protocol HealthKitReporterDelegate: class {
    func report(activitySummary: [ActivitySummary], error: Error?)
    func report(enumeratedStatistics: Statistics?, error: Error?)
    func report(anchoredSamples: [Sample], error: Error?)
    func report(observeredIdentifier: String?, error: Error?)
    func report(backgroundDeliveryEnabled: Bool, error: Error?)
    func report(allBackgroundDeliveriesDisabled: Bool, error: Error?)
    func report(backgroundDeliveryDisabled: Bool, error: Error?)
}
