//
//  GBHAlbumTableViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

class GBHAlbumTableViewCell: UITableViewCell {
    
    var photoImageView: GBHImageAsyncViewLoading!
    
    private let imageWidth = 70
    private let imageHeight = 70
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.accessoryType = .disclosureIndicator
        
        self.photoImageView = GBHImageAsyncViewLoading(frame: CGRect(x: 15, y: 10, width: imageWidth, height: imageHeight))
        self.photoImageView.contentMode = UIViewContentMode.scaleToFill
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

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellWidth: Int = Int(self.frame.size.width)
        self.textLabel?.frame = CGRect(x: imageWidth + 30, y: 30, width: cellWidth - (imageWidth * 2), height: 20)
        self.detailTextLabel?.frame = CGRect(x: imageWidth + 30, y: 50, width: cellWidth, height: 20)
    }
    
    func confirgure(album: GBHFacebookAlbumModel) {
        // Album title
        self.textLabel?.text = album.name ?? ""
        
        // Picture count
        if let count = album.count {
            self.detailTextLabel?.text = "\(count)"
        } else {
            self.detailTextLabel?.text = "0"
        }

        // Album cover
        if let url = album.coverUrl {
            self.photoImageView.imageUrl = url
        }
    }

}
