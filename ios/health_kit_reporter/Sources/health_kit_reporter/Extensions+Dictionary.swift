//
//  Extensions+Dictionary.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 08.10.26.
//

import Foundation
import HealthKitReporter

/// Reading the arguments Dart sends over the channels
extension Dictionary where Key == String, Value == Any {
    func string(_ key: String) throws -> String {
        guard let value = self[key] as? String else {
            throw HealthKitError.invalidValue("Missing or invalid argument \(key) in \(self)")
        }
        return value
    }
    func double(_ key: String) throws -> Double {
        guard let value = self[key] as? NSNumber else {
            throw HealthKitError.invalidValue("Missing or invalid argument \(key) in \(self)")
        }
        return value.doubleValue
    }
    func dictionary(_ key: String) throws -> [String: Any] {
        guard let value = self[key] as? [String: Any] else {
            throw HealthKitError.invalidValue("Missing or invalid argument \(key) in \(self)")
        }
        return value
    }
    func strings(_ key: String) throws -> [String] {
        guard let value = self[key] as? [String] else {
            throw HealthKitError.invalidValue("Missing or invalid argument \(key) in \(self)")
        }
        return value
    }
    /// Date from milliseconds since 1970, as Dart's DateTime.millisecondsSinceEpoch sends it
    func date(_ key: String) throws -> Date {
        return Date.make(from: try double(key))
    }
    /**
     Samples predicate from **startTimestamp** / **endTimestamp** (milliseconds),
     nil when the arguments have none.
     **predicateOptions** narrows it: "strictStartDate", "strictEndDate" or "notStrict"; both strict by default
     */
    func samplesPredicate() throws -> NSPredicate? {
        guard self["startTimestamp"] != nil || self["endTimestamp"] != nil else {
            return nil
        }
        return NSPredicate.samplesPredicate(
            startDate: try date("startTimestamp"),
            endDate: try date("endTimestamp"),
            options: try predicateOptions()
        )
    }
    func requiredSamplesPredicate() throws -> NSPredicate {
        guard let predicate = try samplesPredicate() else {
            throw HealthKitError.invalidValue("Missing startTimestamp / endTimestamp in \(self)")
        }
        return predicate
    }
    private func predicateOptions() throws -> SamplePredicateOptions {
        switch self["predicateOptions"] as? String {
        case nil:
            return [.strictStartDate, .strictEndDate]
        case "strictStartDate":
            return [.strictStartDate]
        case "strictEndDate":
            return [.strictEndDate]
        case "notStrict":
            return []
        case let option?:
            throw HealthKitError.invalidValue("Unknown predicate option \(option)")
        }
    }
    /// Activity summary predicate for the days between **startTimestamp** and **endTimestamp**
    func activitySummaryPredicate() throws -> NSPredicate {
        let units: Set<Calendar.Component> = [.day, .month, .year, .era]
        let calendar = Calendar.current
        var start = calendar.dateComponents(units, from: try date("startTimestamp"))
        start.calendar = calendar
        var end = calendar.dateComponents(units, from: try date("endTimestamp"))
        end.calendar = calendar
        return NSPredicate.activitySummaryPredicateBetween(start: start, end: end)
    }
    /// The anchor Dart persisted, as the base64 string an earlier event carried; nil starts from the beginning
    func anchor() throws -> Anchor? {
        guard let string = self["anchor"] as? String else {
            return nil
        }
        guard let data = Data(base64Encoded: string) else {
            throw HealthKitError.invalidValue("Anchor is not a base64 string: \(string)")
        }
        return Anchor(data: data)
    }
}

extension String {
    func asObjectType() throws -> ObjectType {
        guard let type = objectType else {
            throw HealthKitError.invalidType("Unknown identifier: \(self)")
        }
        return type
    }
    func asSampleType() throws -> SampleType {
        guard let type = objectType as? SampleType else {
            throw HealthKitError.invalidType("Not a sample type: \(self)")
        }
        return type
    }
}

extension Optional where Wrapped == Anchor {
    /// The anchor as Dart persists it: the base64 string its JSON encoding holds
    var asArgument: String? {
        return self?.data.base64EncodedString()
    }
}
