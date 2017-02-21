//
//  User.swift
//  Tweeter
//
//  Created by Chandler Griffin on 1/29/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screename: String?
    var profileURL: URL?
    var tagline: String?
    var backgroundImageUrl: URL?
    var tweetCount: Int?
    var followerCount: Int?
    var followingCount: Int?
    var profileID: String?
    
    var dictionary: NSDictionary?
    static let UserDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary)  {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString  {
            profileURL = URL(string: profileURLString)
        }
        
        if let backgroundImageUrlString = dictionary["profile_background_image_url_https"] as? String {
            backgroundImageUrl = URL(string: backgroundImageUrlString)!
        }
        
        tweetCount = dictionary["statuses_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        
        tagline = dictionary["description"] as? String
        profileID = dictionary["id_str"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User?    {
        get {
            if _currentUser == nil   {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData  {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }   set(user)   {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user  {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary! as Any, options: [])
                defaults.set(data, forKey: "currentUserData")
            }   else    {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }

}
