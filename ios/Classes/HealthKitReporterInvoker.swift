//
//  HealthKitReporterInvoker.swift
//  health_kit_reporter
//
//  Created by Florian on 20.11.20.
//

import Foundation
import HealthKitReporter

public class HealthKitReporterInvoker {
    public let reporter: HealthKitReporter
    weak var delegate: HealthKitReporterDelegate?

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }

    public func queryActivitySummary(predicate: NSPredicate) {
        reporter.reader.queryActivitySummary(
            predicate: predicate,
            monitorUpdates: true
        ) { [self] (activitySummaries, error) in
            delegate?.report(activitySummary: activitySummaries, error: error)
        }
    }
    public func statisticsCollectionQuery(
        type: QuantityType,
        unit: String,
        quantitySamplePredicate: NSPredicate?,
        anchorDate: Date,
        enumerateFrom: Date,
        enumerateTo: Date,
        intervalComponents: DateComponents,
        monitorUpdates: Bool = true
    ) {
        reporter.reader.statisticsCollectionQuery(
            type: type,
            unit: unit,
            quantitySamplePredicate: quantitySamplePredicate,
            anchorDate: anchorDate,
            enumerateFrom: enumerateFrom,
            enumerateTo: enumerateTo,
            intervalComponents: intervalComponents,
            monitorUpdates: monitorUpdates
        ) { [self] (statistics, error) in
            delegate?.report(enumeratedStatistics: statistics, error: error)
        }
    }
    public func anchoredObjectQuery(
        type: SampleType,
        predicate: NSPredicate,
        monitorUpdates: Bool = true
    ) {
        reporter.reader.anchoredObjectQuery(
            type: type,
            predicate: predicate,
            monitorUpdates: false
        ) { [self] (samples, error) in
            delegate?.report(anchoredSamples: samples, error: error)
        }
    }
    public func observerQuery(type: ObjectType, predicate: NSPredicate?) {
        reporter.observer.observerQuery(
            type: type,
            predicate: predicate
        ) { [self] (identifier, error) in
            delegate?.report(observeredIdentifier: identifier, error: error)
        }
    }
    public func enableBackgroundDelivery(
        type: ObjectType,
        frequency: UpdateFrequency
    ) {
        reporter.observer.enableBackgroundDelivery(
            type: type,
            frequency: frequency
        ) { [self] (success, error) in
            delegate?.report(backgroundDeliveryEnabled: success, error: error)
        }
    }
    public func disableAllBackgroundDelivery() {
        reporter.observer.disableAllBackgroundDelivery { [self] (success, error) in
            delegate?.report(allBackgroundDeliveriesDisabled: success, error: error)
        }
    }
    public func disableBackgroundDelivery(type: ObjectType) {
        reporter.observer.disableBackgroundDelivery(
            type: type
        ) { [self] (success, error) in
            delegate?.report(backgroundDeliveryDisabled: success, error: error)
        }
    }
}
