//
//  MyTableTableViewController.swift
//  TableViewDemo
//
//  Created by ChenMo on 6/27/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit
import Twitter

class MyTableTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tweetSearchTextField: UITextField! {
        didSet {
            tweetSearchTextField.delegate = self;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tweetSearchTextField {
            searchText = tweetSearchTextField?.text;
        }
        return true;
    }
    
    private var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            print(tweets);
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll();
            tweetSearchTextField.text = searchText;
            tweetSearchTextField.resignFirstResponder();
            tableView.reloadData();
            searchForTweets();
            title = searchText;
        }
    }
    
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count:100);
        }
        return nil;
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    func insertTweet(_ newTweets: [Twitter.Tweet]) {
        tweets.insert(newTweets, at: 0);
        tableView.insertSections([0], with: .fade);
    }
    
    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request;
            request.fetchTweets{ [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.insertTweet(newTweets);
                    } else {
                        self?.refreshControl?.endRefreshing();
                    }
                }
            }
        } else {
            self.refreshControl?.endRefreshing();
        }
        self.refreshControl?.endRefreshing();
    }
    
    @IBAction func refreshTweet(_ sender: UIRefreshControl) {
        searchForTweets();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.tableFooterView = UIView(frame: .zero);
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension;

    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row];
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet;
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
