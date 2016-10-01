//
//  GBHFacebookAlbumModel.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import Foundation

class GBHFacebookAlbumModel {
    
    var name: String?
    var count: Int?
    var coverUrl: URL?
    var id: String?
    var photos: [GBHFacebookImageModel] = []
    
    init(name:String, count:Int, coverUrl:URL, id: String){
        self.name = name
        self.id = id
        self.coverUrl = coverUrl
        self.count = count
    }
}
