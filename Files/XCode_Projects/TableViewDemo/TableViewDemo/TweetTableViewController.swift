//
//  TweetTableViewController.swift
//  TableViewDemo
//
//  Created by ChenMo on 7/20/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: MyTableTableViewController {
    
    override func insertTweet(_ newTweets: [Twitter.Tweet]) {
        super.insertTweet(newTweets);
        //updateDatabase(newTweets);
    }
    
    private func updateDatabase(with content: [Twitter.Tweet]) {

    }
    
}
