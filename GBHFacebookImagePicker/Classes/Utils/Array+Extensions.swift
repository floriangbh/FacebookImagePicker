//
//  Array+Extensions.swift
//  Bolts
//
//  Created by Florian Gabach on 21/11/2018.
//

import Foundation

extension Array {
    /// Get an index safely
    ///
    /// - Parameter index: desired index
    /// - Returns: Element from the index
    public func get(at index: Int) -> Element? {
        guard index >= 0
            && index < count else {
                return nil
        }
        
        return self[index]
    }
}
