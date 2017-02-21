//
//  TweetDetailsViewController.swift
//  Tweeter
//
//  Created by Chandler Griffin on 2/15/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    var retweeter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let url = URL(string: tweet.profileImageURLString!)
        avatarImageView.setImageWith(url!)
        nameLabel.text = tweet.username
        handleLabel.text = "@\((tweet.handle)!)"
        textLabel.text = tweet.text
        timeStampLabel.text = tweet.timestamp
        numRetweetsLabel.text = "\(tweet.retweetCount!) retweets"
        numFavoritesLabel.text = "\(tweet.favoriteCount!) favorites"
        
        navigationController?.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
        
        replyButton.setImage(#imageLiteral(resourceName: "reply"), for: .normal)
        updateRetweetIcon()
        updateFavoriteIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if(!(tweet?.isRetweeted)!) {
            TwitterClient.sharedInstance?.retweetMe(id: (tweet?.tweetID)!, success: {
                self.tweet?.isRetweeted = !(self.tweet?.isRetweeted)!
                self.tweet.retweetCount! += 1
                self.updateRetweetIcon()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }   else    {
            print("You already retweeted this tweet!")
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if(!(tweet?.isFavorited)!) {
            TwitterClient.sharedInstance?.favoriteMe(id: (tweet?.tweetID)!, success: {
                self.tweet?.isFavorited = !(self.tweet?.isFavorited)!
                self.tweet.favoriteCount! += 1
                self.updateFavoriteIcon()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }   else    {
            print("You already favorited this tweet!")
        }
    }
    
    func updateRetweetIcon()  {
        if(tweet?.isRetweeted)!   {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_green"), for: .normal)
            numRetweetsLabel.text = "\(tweet.retweetCount!) retweets"
        }   else    {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_grey"), for: .normal)
        }
    }
    
    func updateFavoriteIcon() {
        if(tweet?.isFavorited)!   {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_red"), for: .normal)
            numFavoritesLabel.text = "\(tweet.favoriteCount!) favorites"
        }   else    {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_grey"), for: .normal)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let replyViewController = navigationController.topViewController as! replyViewController
        
        replyViewController.user = User.currentUser
        
        if tweet.retweeter != nil {
            replyViewController.retweeter = tweet.retweeter
        }
        replyViewController.tweeter = (tweet.handle)!
        replyViewController.tweetID = tweet.tweetID
    }

}
