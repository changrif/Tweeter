//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Chandler Griffin on 1/30/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "ElRrKD3eIZbXO9w7StkVD6LuZ", consumerSecret: "TlocczYMVPHI28G7ttnJ58Zc42ilavTn1yQGUcD8p6S86Ibnqb")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ())    {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweeterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let token: String = (requestToken?.token!)!
            let url=URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            UIApplication.shared.open(url)
        }, failure: { (error: Error?) in
            print("I got an error: \(error?.localizedDescription)")
            self.loginFailure!(error!)
        })
    }
    
    func logout()   {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.UserDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL)    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (requestToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure!(error)
            })
            
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            //print(dictionaries)
            
           success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func favoriteMe(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func retweetMe(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func sendTweet(message: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/update.json?status=\(message)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("posted tweet")
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func reply(message: String, statusID: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/update.json?status=\(message)", parameters: ["in_reply_to_status_id": statusID], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("replied to tweet")
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ())   {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}
