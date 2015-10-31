//
//  TweetTableViewController.swift
//  SmashTweeter
//
//  Created by Xing Hui Lu on 10/26/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var tweets = [[Tweet]]()

    struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
        static let MentionsSegueIdentifier = "Show Mentions"
    
    }
    
    var lastRequestAttempted: TwitterRequest?
    var nextRequestAttempt: TwitterRequest? {
        if lastRequestAttempted == nil {
            if searchKeyword != nil {
                return TwitterRequest(search: searchKeyword!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastRequestAttempted!.requestForNewer
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchKeyword != nil {
            if let request = nextRequestAttempt {
                self.lastRequestAttempted = request
                request.fetchTweets { (tweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tweets.insert(tweets, atIndex: 0)
                        self.tableView.reloadData()
                        sender?.endRefreshing()
                    }
                }
            }
        }
        sender?.endRefreshing()
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchKeyword
        }
    }
    
    
    var searchKeyword: String? = "#standford" {
        didSet {
            lastRequestAttempted = nil
            searchTextField?.text = searchKeyword
            refresh()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchTextField.resignFirstResponder()
            if searchTextField.text != "" {
                searchKeyword = searchTextField.text
            } else {
                searchTextField.text = searchKeyword
            }
        }
        
        return true
    }
    
    func refresh() {
        if refreshControl != nil {
            refresh(refreshControl!)
        }
    }
    
    //MARK: View Controller Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 162
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
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

    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.MentionsSegueIdentifier {
            if let cell = sender as? TweetTableViewCell {
                if let tweet = cell.tweet {
                    if tweet.urls.count + tweet.media.count + tweet.userMentions.count + tweet.hashtags.count > 0 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.MentionsSegueIdentifier {
            if let mtvc = segue.destinationViewController as? MentionsTableViewController {
                if let cell = sender as? TweetTableViewCell {
                    if let tweet = cell.tweet {
                        mtvc.tweet = tweet
                    }
                }
            }
        }
    }
}


