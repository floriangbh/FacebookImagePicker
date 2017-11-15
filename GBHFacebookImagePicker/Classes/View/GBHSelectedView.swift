//
//  GBHSelectedView.swift
//  Pods
//
//  Created by Florian Gabach on 03/05/2017.
//
//

import UIKit

class GBHSelectedView: UIView {

    /// Check view
    private var checkView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Border width
        let borderWidth = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth
        self.layer.borderWidth = borderWidth ?? 3.0

        // Apply border color
        let defaultColor = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor?.cgColor
        self.layer.borderColor = defaultColor ?? UIColor.blue.cgColor

        // Check image view
        let checkImageView = UIImageView()

        checkImageView.image = GBHAssetManager.getImage(name: "GBHFacebookImagePickerDefaultSelectedCheckmark")
        checkImageView.backgroundColor = .clear

        self.checkView.addSubview(checkImageView)

        checkImageView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: self.checkView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: checkImageView,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self.checkView,
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
                                       constant: 12)
        let height = NSLayoutConstraint(item: checkImageView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 12)

        self.checkView.addConstraints([centerX, centerY, width, height])

        // Check view
        self.addSubview(self.checkView)

        self.checkView.backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor ?? .blue

        self.checkView.translatesAutoresizingMaskIntoConstraints = false

        let top = NSLayoutConstraint(item: self,
                                     attribute: .top, relatedBy: .equal,
                                     toItem: self.checkView,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: -6)
        let trailing = NSLayoutConstraint(item: self,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.checkView,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: 6)
        let widthCheckView = NSLayoutConstraint(item: self.checkView,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 18)
        let heightCheckView = NSLayoutConstraint(item: self.checkView,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 18)

        self.addConstraints([top, trailing, widthCheckView, heightCheckView])

        self.checkView.layer.cornerRadius = heightCheckView.constant / 2
        self.checkView.layer.borderWidth = 0.5
        self.checkView.layer.borderColor = UIColor.white.cgColor

        self.checkView.isHidden = !GBHFacebookImagePicker.pickerConfig.uiConfig.showCheckView
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
