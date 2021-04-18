//
//  Extensions+NSObject.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: self)
    }
}
