//
//  RecentSearchesTableViewController.swift
//  SmashTweeter
//
//  Created by Xing Hui Lu on 11/2/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class RecentSearches {
    private struct Const {
        static let valuesKey = "RecentSearches.Values"
        static let numberOfSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    var values: [String] {
        get { return defaults.objectForKey(Const.valuesKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: Const.valuesKey) }
    }
    
    func add(search: String) {
        var currentSearches = values
        if let index = currentSearches.indexOf(search) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(search, atIndex: 0)
        if currentSearches.count > Const.numberOfSearches {
            currentSearches.removeLast()
        }
        values = currentSearches
    }
}

class RecentSearchesTableViewController: UITableViewController {
    var recentSearches = RecentSearches()
    
    private struct Storyboard {
        static let CellReuseIdentifier = "History Cell"
        static let SegueIdentifier = "From History"
    }
    
    // MARK: - Viewcontroller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.values.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = recentSearches.values[indexPath.row]
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SegueIdentifier {
            if let tvc = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    tvc.searchKeyword = cell.textLabel?.text
                }
            }
        }
    }
}
