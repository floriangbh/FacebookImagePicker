//
//  GBHAlbumTableViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class GBHAlbumTableViewCell: UITableViewCell {
    
    // MARK: - Var
    
    fileprivate var photoImageView: GBHImageAsyncViewLoading?
    fileprivate let imageWidth = 70
    fileprivate let imageHeight = 70
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        // Common init
        self.backgroundColor = GBHFacebookImagePicker.pickerConfig.ui.backgroundColor
        self.accessoryType = .disclosureIndicator
        
        // Album cover image
        self.photoImageView = GBHImageAsyncViewLoading(frame: CGRect(x: 15, y: 10, width: imageWidth, height: imageHeight))
        self.photoImageView?.contentMode = .scaleAspectFill
        self.photoImageView?.clipsToBounds = true
        self.photoImageView?.layer.cornerRadius = GBHAppearanceManager.pictureCornerRadius
        if let imgView = self.photoImageView {
            self.contentView.addSubview(imgView)
        }
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
            self.photoImageView?.imageUrl = url
        }
    }

}
