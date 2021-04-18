//
//  Extensions+Query.swift
//  health_kit_reporter
//
//  Created by Kachalov, Victor on 18.04.21.
//

import HealthKitReporter

extension Query {
    var identifier: String? {
        if #available(iOS 9.3, *) {
            return objectType?.identifier
        } else {
            return sampleType?.identifier
        }
    }
}
