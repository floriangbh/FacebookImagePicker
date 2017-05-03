//
//  PhotoTableViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 03/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
    }
}
