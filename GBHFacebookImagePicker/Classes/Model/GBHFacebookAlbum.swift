//
//  GBHFacebookAlbumModel.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

class GBHFacebookAlbum {

    // MARK: - Var

    /// Album's name
    var name: String?

    /// Album's pictures number
    var count: Int?

    /// Album's cover url
    var coverUrl: URL?

    // Album's id
    var albumId: String?

    // Contains album's picture
    var photos: [GBHFacebookImage] = []

    // MARK: - Init

    /// Initialize the album (from the retrieved information given by the Graph API)
    ///
    /// - Parameters:
    ///   - name: the album's name
    ///   - count: the number of picture in the album
    ///   - coverUrl: the string url of the cover picture 
    ///   - albmId: the album id 
    init(name: String, count: Int, coverUrl: URL, albmId: String) {
        self.name = name
        self.albumId = albmId
        self.coverUrl = coverUrl
        self.count = count
    }
}
