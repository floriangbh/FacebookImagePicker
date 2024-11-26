//
//  FacebookPickerConfig.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

/// Simple struct to hold settings 
public struct FacebookPickerConfig {

    // MARK: - Configurable

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
        public var backgroundColor: UIColor = Styles().backgroundColor

        /// Will be applied to the navigation bar 
        public var closeButtonColor: UIColor = Styles().label

        /// Will be applied to album's title color 
        public var albumsTitleColor: UIColor = Styles().label

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

    public struct TextConfig {
        /// Will be applied to the album's navigation bar title
        public var localizedTitle: String = NSLocalizedString("Album(s)", comment: "")
        
        /// Tagged album name
        public var localizedTaggedAlbumName: String = NSLocalizedString("Photos of You", comment: "")
        
        /// Name for Pictures
        public var localizedPictures: String = NSLocalizedString("Pictures", comment: "")
        
        /// Name for title in popup
        public var localizedOups: String = NSLocalizedString("Oups", comment: "")
        
        /// Name for need photo permission in popup
        public var localizedAllowPhotoPermission: String = NSLocalizedString("You need to allow photo's permission.", comment: "")
        
        /// Name for allow in popup
        public var localizedAllow: String =  NSLocalizedString("Allow", comment: "")
        
        /// Name for close in popup
        public var localizedClose: String =  NSLocalizedString("Close", comment: "")
        
        /// Naviagtion bar button name
        public var localizedSelect: String = NSLocalizedString("Select", comment: "")
        
        /// Name for Select all
        public var localizedSelectAll: String = NSLocalizedString("Select all", comment: "")
        
        /// Name for no pictures in the albue
        public var localizedNoPicturesInAlbum: String = NSLocalizedString("No picture in this album.", comment: "")
    }

    /// The picture corner radius. Used for display album cover and album's picture.
    public var pictureCornerRadius: CGFloat = 2.0

    /// Tap animation
    public var performTapAnimation: Bool = true
    
    /// Allow multiple pictures selection
    public var allowAllSelection: Bool = false

    /// Maximum selected pictures
    public var maximumSelectedPictures: Int = 1

    /// Number of picture per row
    public var picturePerRow: CGFloat = 4.0

    /// Space beetween cell 
    public var cellSpacing: CGFloat = 1.5

    /// Display tagged album 
    public var displayTaggedAlbum: Bool = false

    /// UI-specific configuration.
    public var uiConfig = UIConfig()

    /// Text-specific configuration.
    public var textConfig = TextConfig()

    // MARK: - Internal

    var shouldDisplayToolbar: Bool {
        return self.maximumSelectedPictures > 1
    }
}
