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

    private var checkMarkView: UIView?

    private var checkMarkViewSize: CGSize = CGSize(width: 20.0, height: 20.0)

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

        // Add checkmark view
        self.checkMarkView = UIView()

        // Check mark view size
        self.checkMarkViewSize = CGSize(width: self.checkMarkViewSize.width,
                                        height: self.checkMarkViewSize.height)

        // Checkmark background color
        let backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.checkViewBackgroundColor ?? GBHAppearanceManager.facebookColor

        self.checkMarkView?.layer.borderWidth = 1.5
        self.checkMarkView?.layer.borderColor = UIColor.white.cgColor
        self.checkMarkView?.backgroundColor = backgroundColor
        self.checkMarkView?.translatesAutoresizingMaskIntoConstraints = false
        self.checkMarkView?.frame.size = CGSize(width: 20, height: 20)
        if let view = self.checkMarkView {
            self.addSubview(view)
        }

        // Add checkmark image view
        if let checkView = self.checkMarkView {
            self.prepareCheckMarkView()
        }

        // Apply checkmark constraint
        self.prepareConstraint()

        // Border
        self.layer.borderColor = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor?.cgColor
        self.layer.borderWidth = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth
    }

    fileprivate func prepareCheckMarkView() {
        guard let checkView = self.checkMarkView else { return }

        // Add checkmark image from assets
        let checkImageView = UIImageView()
        checkImageView.image = GBHAssetManager.getImage(name: GBHAssetImage.checkMark)
        checkImageView.backgroundColor = .clear
        checkView.addSubview(checkImageView)

        // Apply constraints
        checkImageView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: checkView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: checkImageView,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: checkView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: checkImageView,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        let width = NSLayoutConstraint(item: checkImageView,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1,
                                       constant: self.checkMarkViewSize.width / 2)
        let height = NSLayoutConstraint(item: checkImageView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: self.checkMarkViewSize.height / 2)

        checkView.addConstraints([centerX, centerY, width, height])
    }

    /// Prepare view constraints
    fileprivate func prepareConstraint() {
        // Apply checkmark constraint
        guard let checkMarkView = self.checkMarkView else { return }

        // Define margin
        var margin: CGFloat = 2

        // Extend margin if borderWidth is chosen
        margin += GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth

        // Place vertical constraint
        self.applyVerticalConstraints(margin: margin)

        // Place horizontal constraint
        self.applyHorizontalConstraints(margin: margin)

        // Apply width and height
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutAttribute.width,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutAttribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: self.checkMarkViewSize.width))
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutAttribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: self.checkMarkViewSize.height))

        // Rounding
        checkMarkView.layer.cornerRadius = self.checkMarkViewSize.height / 2
        checkMarkView.clipsToBounds = true
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

    fileprivate func applyHorizontalConstraints(margin: CGFloat) {
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
