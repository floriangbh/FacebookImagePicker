//
//  GBHFacebookHelper.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 28/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class GBHFacebookHelper {

    // MARK: - Singleton 

    static let shared = GBHFacebookHelper()

    // MARK: - Var

    /// User's album list
    fileprivate var albumList: [GBHFacebookAlbum] = []

    /// Picture url path for the API
    fileprivate let pictureUrl = "https://graph.facebook.com/%@/picture?type=small&access_token=%@"

    // MARK: - Retrieve Facebook's Albums

    /// Make GRAPH API's request for user's album
    ///
    /// - Parameter after: after page identifier (optional)
    fileprivate func fbAlbumRequest(after: String? = nil) {

        // Build path album request
        var  path = "me/albums?fields=id,name,count,cover_photo"
        if let afterPath = after {
            path = path.appendingFormat("&after=%@", afterPath)
        }

        // Build Facebook's request
        let graphRequest = FBSDKGraphRequest(graphPath: path,
                                             parameters: nil)

        // Start Facebook Request
        _ = graphRequest?.start { _, result, error in
            if error != nil {
                print(error.debugDescription)
                return
            } else {
                // Try to parse request's result
                if let fbResult = result as? [String: AnyObject] {

                    // Parse Album
                    self.parseFbAlbumResult(fbResult: fbResult)

                    // Try to find next page
                    if let paging = fbResult["paging"] as? [String: AnyObject],
                        let _ = paging["next"] as? String,
                        let cursors = paging["cursors"] as? [String: AnyObject],
                        let after = cursors["after"] as? String {

                        // Restart album request for next page
                        self.fbAlbumRequest(after: after)
                    } else {

                        print("Found \(self.albumList.count) album(s) with this Facebook account.")
                        // Notifie controller with albums
                        NotificationCenter.default.post(name: Notification.Name.ImagePickerDidRetrieveAlbum,
                                                        object: self.albumList)
                    }
                }
            }
        }
    }

    /// Parsing GRAPH API result for user's album in GBHFacebookAlbumModel array
    ///
    /// - Parameter fbResult: result of the Facebook's graph api
    fileprivate func parseFbAlbumResult(fbResult: [String: AnyObject]) {
        if let albumArray = fbResult["data"] as? [AnyObject] {

            // Parsing user's album
            for album in albumArray {
                if let albumDic = album as? [String:AnyObject],
                    let albumName = albumDic["name"] as? String,
                    let albumId = albumDic["id"] as? String,
                    let albumCount = albumDic["count"] as? Int {

                    // Album's cover url
                    let albumUrlPath = String(format : self.pictureUrl,
                                              albumId,
                                              FBSDKAccessToken.current().tokenString)

                    // Build Album model
                    if let coverUrl = URL(string: albumUrlPath) {
                        let albm = GBHFacebookAlbum(name: albumName,
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
    func fbAlbumsPictureRequest(after: String?,
                                album: GBHFacebookAlbum) {

        // Build path album request
        guard let id = album.albumId else {
            return
        }
        var  path = "/\(id)/photos?fields=picture,source,id"
        if let afterPath = after {
            path = path.appendingFormat("&after=%@", afterPath)
        }

        // Build Facebook's request
        let graphRequest = FBSDKGraphRequest(graphPath: path,
                                             parameters: nil)

        // Start Facebook's request
        _ = graphRequest?.start { _, result, error in
            if error != nil {
                print(error.debugDescription)
                return
            } else {
                // Try to parse request's result
                if let fbResult = result as? [String: AnyObject] {
                    // Parse Album
                    self.parseFbPicture(fbResult: fbResult,
                                        album: album)

                    // Try to find next page
                    if let paging = fbResult["paging"] as? [String: AnyObject],
                        let _ = paging["next"] as? String,
                        let cursors = paging["cursors"] as? [String: AnyObject],
                        let after = cursors["after"] as? String {

                        // Restart album request for next page
                        self.fbAlbumsPictureRequest(after: after,
                                                    album: album)
                    } else {
                        print("Found \(album.photos.count) photos for the \"\(album.name!)\" album.")
                        // Notifie controller with albums & photos
                        NotificationCenter.default.post(name: Notification.Name.ImagePickerDidRetriveAlbumPicture,
                                                        object: album)
                    }
                }
            }
        }
    }

    /// Parsing GRAPH API result for album's picture in GBHFacebookAlbumModel
    ///
    /// - Parameters:
    ///   - fbResult: album's result
    ///   - album: concerned album model
    fileprivate func parseFbPicture(fbResult: [String: AnyObject],
                                    album: GBHFacebookAlbum) {
        if let photosResult = fbResult["data"] as? [AnyObject] {

            // Parsing album's picture
            for photo in photosResult {
                if let photoDic = photo as? [String : AnyObject],
                    let id = photoDic["id"] as? String,
                    let picture = photoDic["picture"] as? String,
                    let source = photoDic["source"] as? String {

                    // Build Picture model
                    let photoObject = GBHFacebookImage(picture: picture,
                                                       imgId: id,
                                                       source: source)
                    album.photos.append(photoObject)
                }
            }
        }
    }

    // MARK: - Logout

    /// Logout with clear session, token & user's album
    fileprivate func logout() {
        FBSDKLoginManager().logOut()
    }

    // MARK: - Login

    /// Start login with Facebook SDK
    ///
    /// - parameters vc: source controller
    /// - parameters completion: (success , error if needed)
    func login(controller: UIViewController,
               completion: @escaping (Bool, LoginError?) -> Void) {

        self.albumList = [] // Clear Album

        if FBSDKAccessToken.current() == nil {
            // No token, we need to login

            // Start Facebook's login
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["user_photos"],
                               from: controller) { (response, error) in
                                if error != nil {
                                    // Failed
                                    print("Failed to login")
                                    print(error.debugDescription)
                                    completion(false, .loginFailed)
                                } else {
                                    // Success
                                    if response?.isCancelled == true {
                                        // Login Cancelled
                                        completion(false, .loginCancelled)
                                    } else {
                                        if response?.token != nil {
                                            // Check "user_photos" permission statut
                                            if let permission = response?.declinedPermissions {
                                                if permission.contains("user_photos") {
                                                    // "user_photos" is dennied
                                                    self.logout() // Flush fb session
                                                    completion(false, .permissionDenied)
                                                } else {
                                                    // "user_photos" is granted, let's get user's pictures
                                                    self.fbAlbumRequest()
                                                    completion(true, nil)
                                                }
                                            } else {
                                                // Failed to get permission 
                                                print("Failed to get permission...")
                                                completion(false, .loginFailed)
                                            }
                                        } else {
                                            // Failed
                                            print("Failed to get token")
                                            completion(false, .loginFailed)
                                        }
                                    }
                                }
            }
        } else {
            // Already logged in, check User_photos permission
            if FBSDKAccessToken.current().permissions.contains("user_photos") {
                // User_photos's permission ok
                self.fbAlbumRequest()
                completion(true, nil)
            } else {
                // User_photos's permission denied
                self.logout() // Flush fb session
                print("Permission for user's photos are denied")
                completion(false,
                           .permissionDenied)
            }
        }
    }
}
