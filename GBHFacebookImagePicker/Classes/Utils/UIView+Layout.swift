//
//  UIView+Extensions.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 30/01/2018.
//

import UIKit

extension UIView {
    public func pinEdges(to other: UIView, withBorderSize size: CGFloat = 0.0) {
        other.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: size).isActive = true
        self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: size).isActive = true
        self.topAnchor.constraint(equalTo: other.topAnchor, constant: size).isActive = true
        self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -size).isActive = true
    }
}
