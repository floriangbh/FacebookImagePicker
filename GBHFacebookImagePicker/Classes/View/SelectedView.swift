//
//  SelectedView.swift
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

final class SelectedView: UIView {

    // MARK: - Private var

    private var checkMarkView: UIView?

    private var checkMarkViewSize: CGSize = CGSize(width: 20.0, height: 20.0)

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Prepare
        if  FacebookImagePicker.pickerConfig.uiConfig.showCheckView {
            self.prepareView()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Prepare
        if FacebookImagePicker.pickerConfig.uiConfig.showCheckView {
            self.prepareView()
        }
    }

    // MARK: - Prepare
    private func prepareView() {
        // Apply alpha
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        // Add checkmark view
        self.checkMarkView = UIView()

        // Check mark view size
        self.checkMarkViewSize = CGSize(width: self.checkMarkViewSize.width,
                                        height: self.checkMarkViewSize.height)

        // Checkmark background color
        let customColor = FacebookImagePicker.pickerConfig.uiConfig.checkViewBackgroundColor
        let backgroundColor = customColor ?? Colors.facebookColor

        self.checkMarkView?.layer.borderWidth = 1.5
        self.checkMarkView?.layer.borderColor = UIColor.white.cgColor
        self.checkMarkView?.backgroundColor = backgroundColor
        self.checkMarkView?.translatesAutoresizingMaskIntoConstraints = false
        self.checkMarkView?.frame.size = CGSize(width: 20, height: 20)
        if let view = self.checkMarkView {
            self.addSubview(view)
        }

        // Add checkmark image view
        self.prepareCheckMarkView()

        // Apply checkmark constraint
        self.prepareConstraint()

        // Border
        self.layer.borderColor = FacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor?.cgColor
        self.layer.borderWidth = FacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth
    }

    private func prepareCheckMarkView() {
        guard let checkView = self.checkMarkView else { return }

        // Add checkmark image from assets
        let checkImageView = UIImageView()
        checkImageView.image = AssetsController.getImage(name: AssetImage.checkMark)
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
    private func prepareConstraint() {
        // Apply checkmark constraint
        guard let checkMarkView = self.checkMarkView else { return }

        // Define margin
        var margin: CGFloat = 2

        // Extend margin if borderWidth is chosen
        margin += FacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth

        // Place vertical constraint
        self.applyVerticalConstraints(margin: margin)

        // Place horizontal constraint
        self.applyHorizontalConstraints(margin: margin)

        // Apply width and height
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: self.checkMarkViewSize.width))
        self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: self.checkMarkViewSize.height))

        // Rounding
        checkMarkView.layer.cornerRadius = self.checkMarkViewSize.height / 2
        checkMarkView.clipsToBounds = true
    }

    private func applyVerticalConstraints(margin: CGFloat) {
        guard let checkMarkView = self.checkMarkView else { return }
        switch FacebookImagePicker.pickerConfig.uiConfig.placeCheckView {
        case .topLeft, .topRight:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutConstraint.Attribute.top,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.top,
                                                  multiplier: 1,
                                                  constant: margin))
        case .bottomLeft, .bottomRight:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  multiplier: 1,
                                                  constant: -margin))
        }
    }

    private func applyHorizontalConstraints(margin: CGFloat) {
        guard let checkMarkView = self.checkMarkView else { return }
        switch FacebookImagePicker.pickerConfig.uiConfig.placeCheckView {
        case .topLeft, .bottomLeft:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  multiplier: 1,
                                                  constant: margin))
        case .topRight, .bottomRight:
            self.addConstraint(NSLayoutConstraint(item: checkMarkView,
                                                  attribute: NSLayoutConstraint.Attribute.trailing,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.trailing,
                                                  multiplier: 1,
                                                  constant: -margin))
        }
    }
}
