//
//  UIViewController+Childs.swift
//  Bolts
//
//  Created by Florian Gabach on 14/11/2018.
//

import Foundation

extension UIViewController {

    // MARK: - Child

    func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.view.pinEdges(to: self.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
