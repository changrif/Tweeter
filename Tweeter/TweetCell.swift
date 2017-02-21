//
//  TweetCell.swift
//  Tweeter
//
//  Created by Chandler Griffin on 2/12/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func profileTap(cell: TweetCell, tweet: Tweet)
}

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dotImageView: UIImageView!
    
    var tweet: Tweet?   {
        didSet  {
            let avatarURL = URL(string: (tweet?.profileImageURLString)!)
            avatarImageView.setImageWith(avatarURL!)
            self.avatarImageView.isUserInteractionEnabled = true
            let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(profTapped(gesture:)))
            self.avatarImageView.addGestureRecognizer(userProfileTap)
            nameLabel.text = tweet?.username
            handleLabel.text = "@\((tweet?.handle)!)"
            tweetLabel.text = tweet?.text
            timeStampLabel.text = tweet?.timestamp
            dotImageView.image = #imageLiteral(resourceName: "dot")
            self.updateRetweetIcon()
            self.updateFavoriteIcon()
        }
    }
    
    weak var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame
        .width
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if(!(tweet?.isRetweeted)!) {
            TwitterClient.sharedInstance?.retweetMe(id: (tweet?.tweetID)!, success: {
                self.tweet?.isRetweeted = !(self.tweet?.isRetweeted)!
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
                self.updateFavoriteIcon()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }   else    {
            print("You already favorited this tweet!")
        }
    }
    
    func profTapped(gesture: UITapGestureRecognizer){
        delegate?.profileTap!(cell: self, tweet: self.tweet!)
    }
    
    func updateRetweetIcon()  {
        if(tweet?.isRetweeted)!   {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_green"), for: .normal)
        }   else    {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_grey"), for: .normal)
        }
    }
    
    func updateFavoriteIcon() {
        if(tweet?.isFavorited)!   {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_red"), for: .normal)
        }   else    {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_grey"), for: .normal)
        }
    }
}
