//
//  GBHAlbumTableViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

final class GBHAlbumTableViewCell: UITableViewCell {

    // MARK: - Var

    /// Album's cover image views
    fileprivate var photoImageView: GBHImageAsyncViewLoading?

    /// Width of the album's cover 
    fileprivate let imageWidth = 70

    /// Height of the album's cover 
    fileprivate let imageHeight = 70

    // MARK: - Lifecycle

    /// Initialize the cell
    ///
    /// - Parameters:
    ///   - style: the style of the cell (subtitle for this case)
    ///   - reuseIdentifier: the reuse identifier of the cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle,
                   reuseIdentifier: reuseIdentifier)

        // Common init
        self.backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.accessoryType = .disclosureIndicator

        // Album cover image
        self.photoImageView = GBHImageAsyncViewLoading(frame: CGRect(x: 15,
                                                                     y: 10,
                                                                     width: imageWidth,
                                                                     height: imageHeight))
        self.photoImageView?.contentMode = .scaleAspectFill
        self.photoImageView?.clipsToBounds = true
        self.photoImageView?.layer.cornerRadius = GBHFacebookImagePicker.pickerConfig.pictureCornerRadius
        if let imgView = self.photoImageView {
            self.contentView.addSubview(imgView)
        }

        // Album title label 
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.textLabel?.textColor = GBHFacebookImagePicker.pickerConfig.uiConfig.albumsTitleColor ?? .black

        // Photo count label 
        let defaultColor = UIColor.lightGray
        self.detailTextLabel?.textColor = GBHFacebookImagePicker.pickerConfig.uiConfig.albumsCountColor ?? defaultColor
    }

    /// Required for deserialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Overriding prepare for reuse 
    override func prepareForReuse() {
        super.prepareForReuse()

        // Set default image
        self.photoImageView?.image = GBHAssetManager.getImage(name: GBHAssetImage.loader)
    }

    /// Define the layout of the album name label and number of picture label
    override func layoutSubviews() {
        super.layoutSubviews()

        // The cell width 
        let cellWidth: Int = Int(self.frame.size.width)

        // Album's title
        self.textLabel?.frame = CGRect(x: imageWidth + 30,
                                       y: 30,
                                       width: cellWidth - (imageWidth * 2),
                                       height: 20)

        // Number of photos in the album
        self.detailTextLabel?.frame = CGRect(x: imageWidth + 30,
                                             y: 50,
                                             width: cellWidth - (imageWidth * 2),
                                             height: 20)
    }

    // MARK: - Configure 

    /// Configure the cell with Facebook's album 
    ///
    /// - Parameter album: Album model which contain album information
    func configure(album: GBHFacebookAlbum) {
        // Album title
        self.textLabel?.text = album.name ?? ""

        // Album's pictures count
        if let count = album.count {
            self.detailTextLabel?.text = "\(count)"
        } else {
            self.detailTextLabel?.text = ""
        }

        // Album cover image
        if album.albumId == GBHFacebookManager.idTaggedPhotosAlbum {
            // Special cover for tagged album : user facebook account picture 
            GBHFacebookManager.shared.getProfilePicture({ (_, url) in
                if let stringUrl = url, let url = URL(string: stringUrl) {
                    self.photoImageView?.imageUrl = url
                }
            })
        } else if let url = album.coverUrl {
            // Regular album, load the album cover from de Graph API url 
            self.photoImageView?.imageUrl = url
        }
    }
}
