//
//  GBHFacebookAlbumModel.swift
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
