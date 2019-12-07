//
//  GBHFacebookImageModel.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

public enum ImageSize {
    case normal
    case full
}

public class FacebookImage {
    
    // MARK: - Var
    
    /// The image, not nil only if image is selected
    public var image: UIImage?
    
    /// Normal size picture url
    public var normalSizeUrl: String?
    
    /// Full size source picture url
    public var fullSizeUrl: String?
    
    /// Picture id
    public var imageId: String?
    
    // MARK: - Init
    
    /// Initialize Image model from informations retrieve from the graph API
    ///
    /// - Parameters:
    ///   - picture: the image string url for the default size 
    ///   - imgId: the image id 
    ///   - source: the image string url for the full size 
    init(picture: String, imgId: String, source: String) {
        self.imageId = imgId
        self.normalSizeUrl = picture
        self.fullSizeUrl = source
    }
    
    // MARK: - Download
    
    /// Download the image
    ///
    /// - Parameter completion: completion handler with optional error 
    internal func download(completion: @escaping (Result<Void, DownloadError>) -> Void) {
        guard let stringUrl = self.fullSizeUrl,
            let url = URL(string: stringUrl) else {
                completion(.failure(.invalidUrl))
                return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    completion(.failure(.downloadError))
                    return
            }
            
            // Set the image
            self.image = UIImage(data: data)
            completion(.success(()))
        }
        .resume()
    }
}
