//
//  GBHFacebookPickerConfig.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

/// Simple struct to hold settings 
public struct GBHFacebookPickerConfig {

    /// Sub-stuct holding configuration relevant to UI presentation ! 
    public struct UIConfig {
        /// Statusbar style
        public var statusbarStyle: UIStatusBarStyle = .default

        /// Will be applied to the navigation bar 
        public var navBarTintColor: UIColor?

        /// Will be applied to navigation bar title color 
        public var navTitleColor: UIColor?

        /// Will be applied to navigation bar tintColor  
        public var navTintColor: UIColor?

        /// Will be applied to the navigation bar 
        public var backgroundColor: UIColor?

        /// Will be applied to the navigation bar 
        public var closeButtonColor: UIColor?

        /// Will be applied to album's title color 
        public var albumsTitleColor: UIColor?

        /// Will be applied to album's pictures number 
        public var albumsCountColor: UIColor?

        /// Show check view
        public var showCheckView: Bool = true

        /// Place checkView
        public var placeCheckView: CheckViewPosition = .bottomRight

        /// Selected border color
        public var selectedBorderColor: UIColor?

        /// Selected border width
        public var selectedBorderWidth: CGFloat = 0

        /// Check view background color
        public var checkViewBackgroundColor: UIColor?

        /// Preview photos size (normal by default)
        public var previewPhotoSize: ImageSize = .normal
    }

    /// Will be applied to the album's navigation bar title
    public var title: String = NSLocalizedString("Album(s)",
                                                 comment: "")

    /// The picture corner radius. Used for display album cover and album's picture.
    public var pictureCornerRadius: CGFloat = 2.0

    /// Tap animation
    public var performTapAnimation: Bool = true

    /// Allow multiple pictures selection
    public var allowMultipleSelection: Bool = false

    /// Allow multiple pictures selection
    public var allowAllSelection: Bool = false

    /// Maximum selected pictures
    public var maximumSelectedPictures: Int?

    /// Number of picture per row
    public var picturePerRow: CGFloat = 4.0

    /// Space beetween cell 
    public var cellSpacing: CGFloat = 1.5

    /// Display tagged album 
    public var displayTaggedAlbum: Bool = false

    // Tagged album name 
    public var taggedAlbumName: String = NSLocalizedString("Photos of You",
                                                            comment: "")

    /// UI-specific configuration.
    public var uiConfig = UIConfig()
}
