//
//  GBHSelectedView.swift
//  Pods
//
//  Created by Florian Gabach on 03/05/2017.
//
//

import UIKit

public enum CheckViewPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

final class GBHSelectedView: UIView {

    // MARK: - Private var
    private var didSetupConstraints = false

    private var checkMarkView: UIImageView?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Prepare
        if  GBHFacebookImagePicker.pickerConfig.uiConfig.showCheckView {
            self.prepareView()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Prepare
        if GBHFacebookImagePicker.pickerConfig.uiConfig.showCheckView {
            self.prepareView()
        }
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

        // Border
        self.layer.borderColor = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor?.cgColor
        self.layer.borderWidth = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth
    }

    /// Prepare view constraints
    fileprivate func prepareConstraint() {
        // Apply checkmark constraint
        guard let checkMarkView = self.checkMarkView else { return }

        // define margin
        let margin: CGFloat = 2

        // Place vertical constraint
        self.applyVerticalConstraints(margin: margin)

        // Place horisontal constraint
        self.applyHorisontalConstraints(margin: margin)

        // Apply width and height
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

    fileprivate func applyVerticalConstraints(margin: CGFloat) {
        switch GBHFacebookImagePicker.pickerConfig.uiConfig.placeCheckView {
        case .topLeft, .topRight:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutAttribute.top,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutAttribute.top,
                                                  multiplier: 1,
                                                  constant: margin))
        case .bottomLeft, .bottomRight:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  multiplier: 1,
                                                  constant: -margin))
        }
    }

    fileprivate func applyHorisontalConstraints(margin: CGFloat) {
        switch GBHFacebookImagePicker.pickerConfig.uiConfig.placeCheckView {
        case .topLeft, .bottomLeft:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutAttribute.leading,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutAttribute.leading,
                                                  multiplier: 1,
                                                  constant: margin))
        case .topRight, .bottomRight:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutAttribute.trailing,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutAttribute.trailing,
                                                  multiplier: 1,
                                                  constant: -margin))
        }
    }
}
