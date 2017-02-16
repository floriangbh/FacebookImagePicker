//
//  GBHFacebookPickerConfig.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public struct GBHFacebookPickerConfig {

    /// Sub-stuct holding configuration relevant to UI presentation.
    // swiftlint:disable:next type_name
    public struct UI {

        /// Style of the navigation bar, can be .facebook , .light or .dark
        public var style: PickerStyle = .facebook

        /// Border color of the selected image
        var backgroundColor: UIColor = GBHAppearanceManager.whiteCustom
    }

    /// UI-specific configuration.
    // swiftlint:disable:next variable_name
    public var ui = UI()
}
