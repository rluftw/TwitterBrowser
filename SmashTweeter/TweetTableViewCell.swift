//
//  TweetTableViewCell.swift
//  SmashTweeter
//
//  Created by Xing Hui Lu on 10/26/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfilePicture: UIImageView!
    @IBOutlet weak var tweetScreenName: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    let hashtagColor = UIColor.greenColor()
    let urlColor = UIColor.blueColor()
    let screenNameColor = UIColor.purpleColor()
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenName?.text = nil
        tweetProfilePicture?.image = nil
        dateCreated?.text = nil
        
        if let tweet = self.tweet {
            if var text = tweet.text {
                for _ in tweet.media {
                    text += " 📷"
                }
                
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.changeKeywordsColor(tweet.userMentions, color: screenNameColor)
                attributedText.changeKeywordsColor(tweet.hashtags, color: hashtagColor)
                attributedText.changeKeywordsColor(tweet.urls, color: urlColor)
                tweetTextLabel.attributedText = attributedText
                
                tweetScreenName?.text = "\(tweet.user)"
                
                if let profileImageURL = tweet.user.profileImageURL {
                    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                    let queue = dispatch_get_global_queue(qos, 0)
                    
                    dispatch_async(queue) {
                        if let imageData = NSData(contentsOfURL: profileImageURL) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tweetProfilePicture?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
                
                let formatter = NSDateFormatter()
                if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                    formatter.dateStyle = .ShortStyle
                } else {
                    formatter.timeStyle = .ShortStyle
                }
                
                dateCreated?.text = formatter.stringFromDate(tweet.created)
            }
        }
    }
}

extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}
