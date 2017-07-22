//
//  GBHSelectedView.swift
//  Pods
//
//  Created by Florian Gabach on 03/05/2017.
//
//

import UIKit

final class GBHSelectedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Border width
        let borderWidth = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth
        self.layer.borderWidth = borderWidth ?? 3.0

        // Apply border color 
        let defaultColor = GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor?.cgColor
        self.layer.borderColor = defaultColor ?? UIColor.blue.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
