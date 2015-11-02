//
//  MentionsTableViewController.swift
//  SmashTweeter
//
//  Created by Xing Hui Lu on 10/29/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    // MARK: - Internal Data Structure
    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Mentions(
                        title: "Images",
                        data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }
                    ))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(
                        title: "URLs",
                        data: urls.map { MentionItem.Keyword($0.keyword) }
                    ))
                }
            }
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(
                        Mentions(
                            title: "Hashtags",
                            data: hashtags.map { MentionItem.Keyword($0.keyword) }
                        )
                    )
                }
            }
            if let users = tweet?.userMentions {
                if users.count > 0 {
                    mentions.append(
                        Mentions(
                            title: "Users",
                            data: users.map { MentionItem.Keyword($0.keyword) }
                        )
                    )
                }
            }
        }
    }
    
    private struct Storyboard {
        static let KeywordSegueIdentifier = "From Keyword"
        static let ImageSegueIdentifier = "From Image"
        static let MentionsCellIdentifier = "Keyword Cell"
        static let ImageMentionsCellIdentifier = "Image Cell"
    }
    
    
    private var mentions = [Mentions]()
    
    struct Mentions: CustomStringConvertible {
        var title: String
        var data: [MentionItem]
        
        var description: String {
            return ("\(title): \(data)")
        }
    }
    
    enum MentionItem: CustomStringConvertible {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    
    // MARK: - Viewcontroller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return mentions[section].data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionsCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageMentionsCellIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            cell.imageURL = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(mentions[section].title)"
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.KeywordSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let text = cell.textLabel?.text {
                    if text.hasPrefix("http") {
                        UIApplication.sharedApplication().openURL(NSURL(string: text)!)
                        
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.KeywordSegueIdentifier {
            if let tweetVC = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    tweetVC.searchKeyword = cell.textLabel?.text
                }
            }
        } else if segue.identifier == Storyboard.ImageSegueIdentifier {
            if let imageVC = segue.destinationViewController as? ImageViewController {
                if let cell = sender as? ImageTableViewCell {
                    imageVC.imageURL = cell.imageURL
                }
            }
        }
    }


}
