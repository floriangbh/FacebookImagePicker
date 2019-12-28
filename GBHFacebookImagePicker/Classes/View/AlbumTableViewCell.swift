//
//  AlbumTableViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

final class AlbumTableViewCell: UITableViewCell, Reusable {

    // MARK: - Var

    /// Album's cover image views
    private var photoImageView: AsyncImageView?

    /// Width of the album's cover 
    private let imageWidth = 70

    /// Height of the album's cover 
    private let imageHeight = 70

    // MARK: - Lifecycle

    /// Initialize the cell
    ///
    /// - Parameters:
    ///   - style: the style of the cell (subtitle for this case)
    ///   - reuseIdentifier: the reuse identifier of the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle,
                   reuseIdentifier: reuseIdentifier)

        // Common init
        self.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.accessoryType = .disclosureIndicator

        // Album cover image
        self.photoImageView = AsyncImageView(frame: CGRect(x: 15,
                                                                     y: 10,
                                                                     width: imageWidth,
                                                                     height: imageHeight))
        self.photoImageView?.contentMode = .scaleAspectFill
        self.photoImageView?.clipsToBounds = true
        self.photoImageView?.layer.cornerRadius = FacebookImagePicker.pickerConfig.pictureCornerRadius
        if let imgView = self.photoImageView {
            self.contentView.addSubview(imgView)
        }

        // Album title label 
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.textLabel?.textColor = FacebookImagePicker.pickerConfig.uiConfig.albumsTitleColor 

        // Photo count label
        self.detailTextLabel?.textColor = FacebookImagePicker.pickerConfig.uiConfig.albumsCountColor ?? UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView?.image = AssetsController.getImage(name: AssetImage.loader)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let cellWidth: Int = Int(self.frame.size.width)
        self.textLabel?.frame = CGRect(x: imageWidth + 30, y: 30, width: cellWidth - (imageWidth * 2), height: 20)
        self.detailTextLabel?.frame = CGRect(x: imageWidth + 30, y: 50, width: cellWidth - (imageWidth * 2), height: 20)
    }

    // MARK: - Configure 

    /// Configure the cell with Facebook's album 
    ///
    /// - Parameter album: Album model which contain album information
    func configure(album: FacebookAlbum) {
        self.textLabel?.text = album.name ?? ""

        if let count = album.count {
            self.detailTextLabel?.text = "\(count.locallyFormattedString())"
        } else {
            self.detailTextLabel?.text = ""
        }

        // Album cover image
        if album.albumId == FacebookController.idTaggedPhotosAlbum {
            // Special cover for tagged album : user facebook account picture 
            FacebookController.shared.getProfilePicture(completion: { (result) in
                switch result {
                case .success(let url):
                    if let url = URL(string: url) {
                        self.photoImageView?.imageUrl = url
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        } else if let url = album.coverUrl {
            // Regular album, load the album cover from de Graph API url 
            self.photoImageView?.imageUrl = url
        }
    }
}
