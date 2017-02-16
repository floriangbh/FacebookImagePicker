//
//  GBHFacebookAlbumModel.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import Foundation

class GBHFacebookAlbumModel {
    
    // MARK: - Var
    
    var name: String? // Album's name
    var count: Int? // Album's pictures number
    var coverUrl: URL? // Album's cover url
    var albumId: String? // Album's id
    var photos: [GBHFacebookImageModel] = [] // Contains album's picture
    
    // MARK: - Init
    
    init(name: String, count: Int, coverUrl: URL, albmId: String) {
        self.name = name
        self.albumId = albmId
        self.coverUrl = coverUrl
        self.count = count
    }
}
