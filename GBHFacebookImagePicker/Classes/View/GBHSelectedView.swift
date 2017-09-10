//
//  GBHSelectedView.swift
//  Pods
//
//  Created by Florian Gabach on 03/05/2017.
//
//

import UIKit

final class GBHSelectedView: UIView {

    // MARK: - Private var 

    private var didSetupConstraints = false

    private var checkMarkView: UIImageView?

    // MARK: - Lifecycle 

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Prepare 
        self.prepareView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Prepare
        self.prepareView()
    }

    // MARK: - Prepare 

    fileprivate func prepareView() {
        // Apply alpha 
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        // Add checkmark image 
        let checkMarkImage = GBHAssetManager.getImage(name: GBHAssetImage.checkMark)
        self.checkMarkView = UIImageView(image: checkMarkImage)
        self.checkMarkView?.translatesAutoresizingMaskIntoConstraints = false
        self.checkMarkView?.frame.size = CGSize(width: 20, height: 20)
        self.checkMarkView?.image = checkMarkImage
        if let view = self.checkMarkView {
            self.addSubview(view)
        }

        // Apply checkmark constraint 
        self.prepareConstraint()

    }

    /// Prepare view constraints
    fileprivate func prepareConstraint() {
        // Apply checkmark constraint 
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1,
                                              constant: -2.0))
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1,
                                              constant: -2.0))
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutAttribute.width,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutAttribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: 25))
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutAttribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: 25))
    }
}
