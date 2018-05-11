//
//  UICollectionView+Extensions.swift
//  Bolts
//
//  Created by Florian Gabach on 11/05/2018.
//

import UIKit

extension UICollectionView {
    public func selectAllCell(toPosition position: UICollectionViewScrollPosition = []) {
        for section in 0..<self.numberOfSections {
            for item in 0..<self.numberOfItems(inSection: section) {
                let index = IndexPath(row: item, section: section)
                self.selectItem(at: index, animated: false, scrollPosition: position)
            }
        }
    }
}
