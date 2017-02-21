//
//  Tweet.swift
//  Tweeter
//
//  Created by Chandler Griffin on 1/29/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var username: String?
    var handle: String?
    var profileImageURLString: String?
    var user: NSDictionary?
    var tweetID: String?
    var userID: String?
    var isRetweeted: Bool?
    var isFavorited: Bool?
    var retweeter: String?
    
    init(dictionary: NSDictionary)  {
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        tweetID = dictionary["id_str"] as? String
        userID = user?["id_str"] as? String
        let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        let retweetedUser = retweetedStatus?["user"] as? NSDictionary
        isFavorited = dictionary["favorited"] as? Bool
        isRetweeted = dictionary["retweeted"] as? Bool
        
        user = dictionary["user"] as? NSDictionary
        handle = user?["screen_name"] as? String
        
        if let retweetedUser = retweetedUser    {
            retweeter = handle
            user = retweetedUser
            username = user?["name"] as? String
            handle = user?["screen_name"] as? String
            tweetID = retweetedStatus?["id_str"] as! String?
            favoriteCount = retweetedStatus?["favorite_count"] as? Int
            retweetCount = retweetedStatus?["retweet_count"] as? Int
            profileImageURLString = retweetedUser["profile_image_url_https"] as? String
            text = retweetedStatus?["text"] as? String
        } else  {
            username = user?["name"] as? String
            profileImageURLString = user?["profile_image_url_https"] as? String
            text = dictionary["text"] as? String
        }
        let timeStampString = dictionary["created_at"] as? String
        

        if let timeStampString = timeStampString    {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let time = formatter.date(from: timeStampString)
            
            let difference = Int(Date().timeIntervalSince(time!))
            
            if(difference/86400 < 7)    {
                if(difference/3600 < 24)   {
                    if(difference/60 < 60) {
                        if(difference < 60) {
                            timestamp = "\(difference)s"
                        }   else    {
                            timestamp = "\(difference/60)m"
                        }
                    }   else    {
                        timestamp = "\(difference/3600)h"
                    }
                }   else    {
                    timestamp = "\(difference/86400)d"
                }
            }   else    {
                formatter.dateStyle = .short
                timestamp = "\(formatter.string(from: time!))"
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
