//
//  GBHFacebookPickerConfig.swift
//  Pods
//
//  Created by Florian Gabach on 31/10/2016.
//
//

import UIKit

public struct GBHFacebookPickerConfig {
    
    /// Sub-stuct holding configuration relevant to UI presentation.
    public struct UI {
        
        /// Style of the navigation bar, can be .facebook , .light or .dark
        public var style: PickerStyle = .facebook
        
        /// Border color of the selected image
        var backgroundColor: UIColor = GBHAppearanceManager.whiteCustom
    }
    
    /// UI-specific configuration.
    public var ui = UI()
}
