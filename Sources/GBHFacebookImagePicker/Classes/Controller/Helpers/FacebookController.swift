//
//  GBHFacebookHelper.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 28/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

final class FacebookController {
    
    // MARK: - Singleton 
    
    static let shared = FacebookController()
    
    // MARK: - Var
    
    private var albumList: [FacebookAlbum] = []
    
    private var pictureUrl = "https://graph.facebook.com/%@/picture?type=small&access_token=%@"
    
    static let idTaggedPhotosAlbum = "idPhotosOfYouTagged"
    
    private var profilePictureUrl: String?
    
    /// Boolean to check if we have already added the tagged album, prevent multiple addition when fetching next cursor 
    private var alreadyAddTagged: Bool = false
    
    // MARK: - Retrieve Facebook's Albums
    
    /// Make GRAPH API's request for user's album
    ///
    /// - Parameter after: after page identifier (optional)
    func fetchFacebookAlbums(after: String? = nil,
                             completion: ((Result<[FacebookAlbum], Error>) -> Void)? = nil) {
        
        // Build path album request
        var  path = "me/albums?fields=id,name,count,cover_photo"
        if let afterPath = after {
            path = path.appendingFormat("&after=%@", afterPath)
        }
        
        // Build Facebook's request
        let graphRequest = GraphRequest(graphPath: path, parameters: [:])
        
        // Start Facebook Request
        graphRequest.start { [weak self] _, result, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion?(.failure(error))
                return
            } else {
                // Try to parse request's result
                if let fbResult = result as? [String: AnyObject] {
                    
                    // Parse Album
                    strongSelf.parseFbAlbumResult(fbResult: fbResult)
                    
                    // Add tagged album if needed 
                    if FacebookImagePicker.pickerConfig.displayTaggedAlbum
                        && strongSelf.alreadyAddTagged == false {
                        
                        // Create tagged album 
                        let taggedPhotosAlbum = FacebookAlbum(
                            name: FacebookImagePicker.pickerConfig.textConfig.localizedTaggedAlbumName,
                            albmId: FacebookController.idTaggedPhotosAlbum
                        )
                        
                        // Add to albums 
                        strongSelf.albumList.insert(taggedPhotosAlbum, at: 0)
                        
                        // Update flag 
                        strongSelf.alreadyAddTagged = true
                    }
                    
                    // Try to find next page
                    if let paging = fbResult["paging"] as? [String: AnyObject],
                        paging["next"] != nil,
                        let cursors = paging["cursors"] as? [String: AnyObject],
                        let after = cursors["after"] as? String {
                        
                        // Restart album request for next page
                        strongSelf.fetchFacebookAlbums(after: after, completion: completion)
                    } else {
                        
                        print("Found \(strongSelf.albumList.count) album(s) with this Facebook account.")
                        completion?(.success(strongSelf.albumList))
                    }
                }
            }
        }
    }
    
    /// Parsing GRAPH API result for user's album in FacebookAlbumModel array
    ///
    /// - Parameter fbResult: result of the Facebook's graph api
    private func parseFbAlbumResult(fbResult: [String: AnyObject]) {
        if let albumArray = fbResult["data"] as? [AnyObject] {
            
            // Parsing user's album
            for album in albumArray {
                if let albumDic = album as? [String: AnyObject],
                    let albumName = albumDic["name"] as? String,
                    let albumId = albumDic["id"] as? String,
                    let albumCount = albumDic["count"] as? Int {
                    
                    // Album's cover url
                    let token = AccessToken.current?.tokenString ?? ""
                    let albumUrlPath = String(format: self.pictureUrl, albumId, token)
                    
                    // Build Album model
                    if let coverUrl = URL(string: albumUrlPath) {
                        let albm = FacebookAlbum(name: albumName,
                                                 count: albumCount,
                                                 coverUrl: coverUrl,
                                                 albmId: albumId)
                        self.albumList.append(albm)
                    }
                }
            }
        }
    }
    
    // MARK: - Retrieve Facebook's Picture
    
    /// Make GRAPH API's request for album's pictures
    ///
    /// - Parameters:
    ///   - after: after page identifier (optional)
    ///   - album: album model
    func fbAlbumsPictureRequest(after: String? = nil,
                                album: FacebookAlbum,
                                completion: ((Result<FacebookAlbum, Error>) -> Void)? = nil) {
        
        // Build path album request
        guard let identifier = album.albumId else {
            return
        }
        var path = identifier == FacebookController.idTaggedPhotosAlbum
            ? "/me/photos?fields=picture,source,id"
            : "/\(identifier)/photos?fields=picture,source,id"
        if let afterPath = after {
            path = path.appendingFormat("&after=%@", afterPath)
        }
        
        // Build Facebook's request
        let graphRequest = GraphRequest(graphPath: path, parameters: [:])
        
        // Start Facebook's request
        _ = graphRequest.start { [weak self] _, result, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
                return
            } else {
                // Try to parse request's result
                if let fbResult = result as? [String: AnyObject] {
                    // Parse Album
                    // print(fbResult)
                    strongSelf.parseFbPicture(fbResult: fbResult,
                                              album: album)
                    
                    // Try to find next page
                    if let paging = fbResult["paging"] as? [String: AnyObject],
                        paging["next"] != nil,
                        let cursors = paging["cursors"] as? [String: AnyObject],
                        let after = cursors["after"] as? String {
                        
                        // Restart album request for next page
                        strongSelf.fbAlbumsPictureRequest(after: after, album: album, completion: completion)
                    } else {
                        print("Found \(album.photos.count) photos for the \"\(album.name!)\" album.")
                        // Notifie controller with albums & photos
                        completion?(.success(album))
                    }
                }
            }
        }
    }
    
    /// Parsing GRAPH API result for album's picture in FacebookAlbumModel
    ///
    /// - Parameters:
    ///   - fbResult: album's result
    ///   - album: concerned album model
    private func parseFbPicture(fbResult: [String: AnyObject],
                                album: FacebookAlbum) {
        if let photosResult = fbResult["data"] as? [AnyObject] {
            
            // Parsing album's picture
            for photo in photosResult {
                if let photoDic = photo as? [String: AnyObject],
                    let identifier = photoDic["id"] as? String,
                    let picture = photoDic["picture"] as? String,
                    let source = photoDic["source"] as? String {
                    
                    // Build Picture model
                    let photoObject = FacebookImage(picture: picture,
                                                    imgId: identifier,
                                                    source: source)
                    album.photos.append(photoObject)
                }
            }
        }
    }
    
    // MARK: - Logout
    
    /// Logout with clear session, token & user's album
    private func logout() {
        LoginManager().logOut()
    }
    
    // MARK: - Login
    
    /// Start login with the Facebook SDK
    ///
    /// - parameters vc: source controller
    /// - parameters completion: (success , error if needed)
    func login(controller: UIViewController,
               completion: @escaping (Result<Void, LoginError>) -> Void) {
        
        self.albumList = [] // Clear Album
        
        if AccessToken.current == nil {
            // No token, we need to log in
            
            // Start Facebook's login
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["user_photos"], from: controller) { [weak self] (response, error) in
                
                guard let strongSelf = self else { return }
                
                if error != nil {
                    // Failed
                    print("Failed to login")
                    print(error.debugDescription)
                    completion(.failure(.loginFailed))
                } else {
                    // Success
                    if response?.isCancelled == true {
                        // Login Cancelled
                        completion(.failure(.loginCancelled))
                    } else {
                        if response?.token != nil {
                            // Check "user_photos" permission statut
                            if let permission = response?.declinedPermissions {
                                if permission.contains("user_photos") {
                                    // "user_photos" is dennied
                                    strongSelf.logout() // Flush fb session
                                    completion(.failure(.permissionDenied))
                                } else {
                                    // "user_photos" is granted
                                    completion(.success(()))
                                }
                            } else {
                                // Failed to get permission
                                print("Failed to get permission...")
                                completion(.failure(.loginFailed))
                            }
                        } else {
                            // Failed
                            print("Failed to get token")
                            completion(.failure(.loginFailed))
                        }
                    }
                }
            }
        } else {
            // Already logged in, check User_photos permission
            if AccessToken.current?.hasGranted(permission: "user_photos") ?? false {
                // User_photos's permission ok
                completion(.success(()))
            } else {
                // User_photos's permission denied
                self.logout() // Flush fb session
                print("Permission for user's photos are denied")
                completion(.failure(.permissionDenied))
            }
        }
    }
    
    func getProfilePicture(completion: @escaping ((Result<String, Error>) -> Void)) {
        if let profilUrl = self.profilePictureUrl {
            // Return saved url 
            completion(.success(profilUrl))
        } else {
            // Retrieve profile url form Graph API
            if AccessToken.current != nil {
                let param = ["fields": "picture.width(600).height(600)"]
                let graphRequest = GraphRequest(graphPath: "me",
                                                parameters: param)
                _ = graphRequest.start(completion: { (_, result, error) -> Void in
                    if let error = error {
                        // KO
                        completion(.failure(error))
                    } else {
                        // OK
                        if let result = result as? [String: AnyObject] {
                            // Facebook profil pic URL
                            if result["picture"] != nil {
                                if let FBpictureData = result["picture"] as? [String: AnyObject],
                                    let FBpicData = FBpictureData["data"] as? [String: AnyObject],
                                    let FBPicUrl = FBpicData["url"] as? String {
                                    
                                    // Save url 
                                    self.profilePictureUrl = FBPicUrl
                                    
                                    // Start completion 
                                    completion(.success(FBPicUrl))
                                }
                            }
                        }
                        
                        completion(.failure(DownloadError.downloadError))
                    }
                })
            } else {
                // KO
                completion(.failure(DownloadError.tokenError))
                print("Token error")
            }
        }
    }
    
    /// Reset manager 
    func reset() {
        // Reset tagged flag 
        self.alreadyAddTagged = false
        
        // Reset profil picture url 
        self.profilePictureUrl = nil
    }
}
