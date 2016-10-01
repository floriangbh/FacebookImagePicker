//
//  GBHFacebookImageModel.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import Foundation

class GBHFacebookImageModel {
    
    var link: String?
    var id: String?
    
    init(link:String, id: String){
        self.id = id
        self.link = link
    }
}
