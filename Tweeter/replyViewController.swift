//
//  replyViewController.swift
//  Tweeter
//
//  Created by Chandler Griffin on 2/19/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class replyViewController: UIViewController {
    
    var user: User?
    var profileImageURL: URL?
    var currentUserName: String?
    var handle: String?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var replyButton: UIBarButtonItem!
    
    var retweeter: String?
    var tweeter: String?
    var tweetID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.textView.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 139/255, green: 197/255, blue: 236/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        profileImageURL = user?.profileURL
        currentUserName = user?.name
        handle = user?.screename
        
        if user != nil {
            if let url = profileImageURL{
                self.avatarImageView.setImageWith(url)
            }
            self.nameLabel.text = currentUserName
            self.handleLabel.text = "@\(handle!)"
        }
        var starterText = "@"
        if retweeter != nil {
            starterText = "\(starterText)\(tweeter!) @\(retweeter!) "
        }   else    {
            starterText = "\(tweeter!) "
        }
        self.textView.text = starterText
        self.textView.becomeFirstResponder()
        self.canTweet()
    }

    @IBAction func reply(_ sender: Any) {
        if let text = self.textView.text{
            let encoded = text.replacingOccurrences(of: " ", with: "%20")
            TwitterClient.sharedInstance?.reply(message: encoded, statusID: tweetID!, success: {
                print("yas reply")
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func canTweet(){
        if self.textView.text.isEmpty{
            self.replyButton.isEnabled = false
            self.replyButton.customView?.alpha = 0.4
        }else{
            self.replyButton.isEnabled = true
            self.replyButton.customView?.alpha = 1
        }
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

extension replyViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.canTweet()
    }
}
