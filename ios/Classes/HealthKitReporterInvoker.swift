//
//  HealthKitReporterInvoker.swift
//  health_kit_reporter
//
//  Created by Florian on 20.11.20.
//

import Foundation
import HealthKitReporter

public class HealthKitReporterInvoker {
    private let reporter: HealthKitReporter
    weak var delegate: HealthKitReporterDelegate?

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }

    public func queryActivitySummary(predicate: NSPredicate) {
        reporter.reader.queryActivitySummary(
            predicate: predicate,
            monitorUpdates: true
        ) { [weak self] (activitySummaries, error) in
            self?.delegate?.report(activitySummary: activitySummaries, error: error)
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
        ) { [weak self] (statistics, error) in
            self?.delegate?.report(enumeratedStatistics: statistics, error: error)
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
        ) { [weak self] (samples, error) in
            self?.delegate?.report(anchoredSamples: samples, error: error)
        }
    }
    public func observerQuery(type: ObjectType, predicate: NSPredicate?) {
        reporter.observer.observerQuery(
            type: type,
            predicate: predicate
        ) { [weak self] (identifier, error) in
            self?.delegate?.report(observeredIdentifier: identifier, error: error)
        }
    }
    public func enableBackgroundDelivery(
        type: ObjectType,
        frequency: UpdateFrequency
    ) {
        reporter.observer.enableBackgroundDelivery(
            type: type,
            frequency: frequency
        ) { [weak self] (success, error) in
            self?.delegate?.report(backgroundDeliveryEnabled: success, error: error)
        }
    }
    public func disableAllBackgroundDelivery() {
        reporter.observer.disableAllBackgroundDelivery { [weak self] (success, error) in
            self?.delegate?.report(allBackgroundDeliveriesDisabled: success, error: error)
        }
    }
    public func disableBackgroundDelivery(type: ObjectType) {
        reporter.observer.disableBackgroundDelivery(
            type: type
        ) { [weak self] (success, error) in
            self?.delegate?.report(backgroundDeliveryDisabled: success, error: error)
        }
    }
}
