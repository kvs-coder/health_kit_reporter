//
//  Extensions+NSObject.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Flutter
import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
}

extension FlutterError {
    /// Wraps an error, keeping its localized description (HealthKitError is a LocalizedError) as the message
    convenience init(code: String, error: Error?) {
        self.init(
            code: code,
            message: error?.localizedDescription ?? "Unknown error",
            details: error.map { String(describing: $0) }
        )
    }
}
