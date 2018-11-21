//
//  Reusable.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 21/11/2018.
//

import UIKit

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
