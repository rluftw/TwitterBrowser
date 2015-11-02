//
//  ImageTableViewCell.swift
//  SmashTweeter
//
//  Created by Xing Hui Lu on 10/30/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageURL: NSURL? { didSet { updateUI() } }

    func updateUI() {
        tweetImage?.image = nil
        if let url = imageURL {
            self.activityIndicator.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            let queue = dispatch_get_global_queue(qos, 0)
            
            dispatch_async(queue) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    // used if the cell moves
                    if url == self.imageURL {
                        if imageData != nil {
                            self.tweetImage.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImage.image = nil
                        }
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
