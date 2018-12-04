//
//  Int.swift
//  Pods
//
//  Created by Patrick Kaalund on 04/07/2018.
//

import UIKit

extension Int {
    public func locallyFormattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: Locale.current.identifier)

        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
