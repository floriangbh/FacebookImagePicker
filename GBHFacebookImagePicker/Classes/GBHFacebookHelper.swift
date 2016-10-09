//
//  GBHFacebookHelper.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 28/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class GBHFacebookHelper {
    
    /**
     * User's album list
     **/
    fileprivate var albumList: [GBHFacebookAlbumModel] = []
    
    /**
     * Singleton
     **/
    static let shared = GBHFacebookHelper()
    
    
    // MARK: - Retrieve Facebook's Albums
    
    /**
     * Make GRAPH API's request for user's album
     **/
    fileprivate func fbAlbumRequest(after: String?) {
        
        // Build path album request
        var  path = "me/albums?limit=100&fields=id,name,count,cover_photo"
        if let afterPath = after {
            path = path.appendingFormat("&after=%@", afterPath)
        }
        
        // Build Facebook's request
        let graphRequest = FBSDKGraphRequest(graphPath: path,
                                             parameters: nil)
        
        // Start Facebook Request
        _ = graphRequest?.start { connection, result, error in
            if error != nil {
                print(error.debugDescription)
                return
            }else{
                // Try to parse request's result
                if let fbResult = result as? Dictionary<String, AnyObject> {
                    
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
                        NotificationCenter.default.post(name: Notification.Name.GBHFacebookImagePickerDidRetrieveAlbum,
                                                        object: self.albumList)
                    }
                }
            }
        }
    }
    
    /**
     * Parsing GRAPH API result for user's album in GBHFacebookAlbumModel array
     **/
    fileprivate func parseFbAlbumResult(fbResult: Dictionary<String, AnyObject>) {
        if let albumArray = fbResult["data"] as? [AnyObject] {
            
            // Parsing user's album
            for album in albumArray {
                if let albumDic = album as? [String:AnyObject],
                    let albumName = albumDic["name"] as? String,
                    let albumId = albumDic["id"] as? String,
                    let albumCount = albumDic["count"] as? Int {
                    
                    // Album's cover url
                    let albumUrlPath = String(format : "https://graph.facebook.com/%@/picture?type=small&access_token=%@", albumId, FBSDKAccessToken.current().tokenString)
                    
                    // Build Album model
                    if let coverUrl = URL(string: albumUrlPath) {
                        let albm = GBHFacebookAlbumModel(name: albumName, count: albumCount, coverUrl: coverUrl, id: albumId)
                        self.albumList.append(albm)
                    }
                }
            }
        }
    }
    
    // MARK: - Retrieve Facebook's Picture
    
    /**
     * Make GRAPH API's request for album's pictures
     **/
    func fbAlbumsPictureRequest(after: String?,
                                album : GBHFacebookAlbumModel) {
        
        // Build path album request
        var  path = "/\(album.id!)/photos?fields=picture,source,id,images&limit=1000"
        if let afterPath = after {
            path = path.appendingFormat("&after=%@", afterPath)
        }
        
        // Build Facebook's request
        let graphRequest = FBSDKGraphRequest(graphPath: path,
                                             parameters: nil)
        
        // Start Facebook's request
        _ = graphRequest?.start { connection, result, error in
            if error != nil {
                print(error.debugDescription)
                return
            }else{
                // Try to parse request's result
                if let fbResult = result as? Dictionary<String, AnyObject> {
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
                        NotificationCenter.default.post(name: Notification.Name.GBHFacebookImagePickerDidRetriveAlbumPicture,
                                                        object: album)
                    }
                }
            }
        }
    }
    
    /**
     * Parsing GRAPH API result for album's picture in GBHFacebookAlbumModel
     **/
    fileprivate func parseFbPicture(fbResult: Dictionary<String, AnyObject>, album: GBHFacebookAlbumModel) {
        if let photosResult = fbResult["data"] as? [AnyObject] {
            
            // Parsing album's picture
            for photo in photosResult {
                if let photoDic = photo as? [String : AnyObject],
                    let id = photoDic["id"] as? String,
                    let link = photoDic["source"] as? String {
                    
                    // Build Picture model
                    let photoObject = GBHFacebookImageModel(link: link, id: id)
                    album.photos.append(photoObject)
                }
            }
        }
    }
    
    // MARK: - Logout
    
    /**
     * Logout with clear session, token & user's album
     **/
    fileprivate func logout() {
        FBSDKLoginManager().logOut()
    }
    
    // MARK: - Login
    
    /**
     * Start login with Facebook SDK
     * Parameters :
     * - vc : source controller
     * - completion(success , error if needed)
     **/
    func login(vc: UIViewController,
               completion: @escaping (Bool, LoginError?) -> Void) {
        
        self.albumList = [] // Clear Album
        
        if FBSDKAccessToken.current() == nil {
            // No token, we need to login

            // Start Facebook's login
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["user_photos"],
                               from: vc) { (response, error) in
                                if(error != nil) {
                                    // Failed
                                    print("Failed to login")
                                    print(error.debugDescription)
                                    completion(false, LoginError.LoginFailed)
                                } else {
                                    // Success
                                    if response?.isCancelled == true {
                                        // Login Cancelled
                                        completion(false, LoginError.LoginCancelled)
                                    } else {
                                        if response?.token != nil {
                                            // Check "user_photos" permission statut
                                            if (response?.declinedPermissions.contains("user_photos"))! {
                                                // "user_photos" is dennied
                                                self.logout() // Flush fb session
                                                completion(false, LoginError.PermissionDenied)
                                            } else {
                                                // "user_photos" is granted, let's get user's pictures
                                                self.fbAlbumRequest(after: nil)
                                                completion(true, nil)
                                            }
                                        } else {
                                            // Failed
                                            completion(false, LoginError.LoginFailed)
                                        }
                                    }
                                }
            }
        } else {
            // Already logged in, check User_photos permission
            if FBSDKAccessToken.current().permissions.contains("user_photos") {
                // User_photos's permission ok
                self.fbAlbumRequest(after: nil)
                completion(true, nil)
            } else {
                // User_photos's permission denied
                self.logout() // Flush fb session
                completion(false, LoginError.PermissionDenied)
            }
        }
    }
}
