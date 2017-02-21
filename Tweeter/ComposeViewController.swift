//
//  ComposeViewController.swift
//  Tweeter
//
//  Created by Chandler Griffin on 2/18/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

fileprivate let tweetMax = 140

class ComposeViewController: UIViewController {

    var user: User?
    var profileImageURL: URL?
    var currentUserName: String?
    var handle: String?
    var remainingCount: Int?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
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
        
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
        
        self.updateCharactersLeft()
        self.textView.becomeFirstResponder()
        self.canTweet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tweet(_ sender: Any) {
        if let text = self.textView.text{
            let encoded = text.replacingOccurrences(of: " ", with: "%20")

            TwitterClient.sharedInstance?.sendTweet(message: encoded, success: {
                print("yas tweet")
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func canTweet(){
        if self.textView.text.isEmpty{
            self.tweetButton.isEnabled = false
            self.tweetButton.customView?.alpha = 0.4
        }else{
            self.tweetButton.isEnabled = true
            self.tweetButton.customView?.alpha = 1
        }
    }
    
    func updateCharactersLeft(){
        self.remainingCount = tweetMax - self.textView.text.characters.count
        self.characterLimitLabel.text = String(describing: remainingCount!)
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

extension ComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.canTweet()
        self.updateCharactersLeft()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.characters.count == tweetMax && !text.isEmpty{
            return false
        }
        return true
    }
}
