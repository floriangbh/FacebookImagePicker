//
//  GBHAlbumTableViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

class GBHAlbumTableViewCell: UITableViewCell {
    
    // MARK: - Var
    
    fileprivate var photoImageView: GBHImageAsyncViewLoading!
    fileprivate let imageWidth = 70
    fileprivate let imageHeight = 70
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        // Common init
        self.backgroundColor = GBHAppearanceManager.whiteCustom
        self.accessoryType = .disclosureIndicator
        
        // Album cover image
        self.photoImageView = GBHImageAsyncViewLoading(frame: CGRect(x: 15, y: 10, width: imageWidth, height: imageHeight))
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.clipsToBounds = true
        self.contentView.addSubview(self.photoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Text layout
        let cellWidth: Int = Int(self.frame.size.width)
        self.textLabel?.frame = CGRect(x: imageWidth + 30, y: 30, width: cellWidth - (imageWidth * 2), height: 20)
        self.detailTextLabel?.frame = CGRect(x: imageWidth + 30, y: 50, width: cellWidth, height: 20)
    }
    
    // MARK: - Configure 
    
    func configure(album: GBHFacebookAlbumModel) {
        // Album title
        self.textLabel?.text = album.name ?? ""
        
        // Album's pictures count
        if let count = album.count {
            self.detailTextLabel?.text = "\(count)"
        } else {
            self.detailTextLabel?.text = "0"
        }

        // Album cover image
        if let url = album.coverUrl {
            self.photoImageView.imageUrl = url
        }
    }

}
