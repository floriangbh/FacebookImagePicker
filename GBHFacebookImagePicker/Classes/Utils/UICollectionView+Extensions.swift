//
//  UICollectionView+Extensions.swift
//  Bolts
//
//  Created by Florian Gabach on 11/05/2018.
//

import UIKit

extension UICollectionView {
    func selectAllCell(toPosition position: UICollectionView.ScrollPosition = []) {
        for section in 0..<self.numberOfSections {
            for item in 0..<self.numberOfItems(inSection: section) {
                let index = IndexPath(row: item, section: section)
                self.selectItem(at: index, animated: false, scrollPosition: position)
            }
        }
    }

    func register<T: UICollectionViewCell>(cellType: T.Type)
        where T: Reusable {
            self.register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
        where T: Reusable {
            let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
            guard let cell = bareCell as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the cell beforehand"
                )
            }
            return cell
    }

}
