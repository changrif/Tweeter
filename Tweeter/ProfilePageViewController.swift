//
//  ProfilePageViewController.swift
//  Tweeter
//
//  Created by Chandler Griffin on 2/19/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    var currentUser: User?
    
    var user: NSDictionary?
    var headerImageUrl: URL?
    var avatarImageURL: URL?
    var name: String?
    var handle: String?
    var followers: Int?
    var following: Int?
    var tweets: Int?
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if let user = user  {
            let headerString = user["profile_background_image_url_https"] as! String?
            headerImageUrl = URL(string: headerString!)
            let avatarString = user["profile_image_url_https"] as! String?
            avatarImageURL = URL(string: avatarString!)
            name = user["name"] as! String?
            handle = user["screen_name"] as! String?
            followers = user["followers_count"] as? Int
            following = user["friends_count"] as? Int
            tweets = user["statuses_count"] as? Int
        }   else    {
            headerImageUrl = currentUser?.backgroundImageUrl
            avatarImageURL = currentUser?.profileURL
            name = currentUser?.name
            handle = currentUser?.screename
            followers = currentUser?.followerCount
            following = currentUser?.followingCount
            tweets = currentUser?.tweetCount
        }
        if let headerImageUrl = headerImageUrl  {
            headerImageView.setImageWith(headerImageUrl)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = headerImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            headerImageView.addSubview(blurEffectView)
        }
        avatarImageView.setImageWith(avatarImageURL!)
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
        
        nameLabel.text = name
        handleLabel.text = "@\(handle!)"
        tweetLabel.text = String(describing: tweets!)
        followingLabel.text = String(describing: following!)
        followersLabel.text = String(describing: followers!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
