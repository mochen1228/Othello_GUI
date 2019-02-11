//
//  TweetsTableViewController.swift
//  
//
//  Created by ChenMo on 2/3/19.
//

import UIKit

class TweetsTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let tweetRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        tweetRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true) {
            print("Logged out")
        }
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as! String
        cell.tweetTextLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        cell.createdTimeLabel.text = "3h Ago"
        DispatchQueue.global(qos: .userInitiated).async {
            let imageURL = URL(string:user["profile_image_url_https"] as! String)
            if let imageData = try? Data(contentsOf: imageURL!) {
                DispatchQueue.main.async {
                    cell.profilePicImage?.image = UIImage(data: imageData);
                }
            }
        }
        return cell
    }

    @objc func loadTweet () {
        let loadTweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let param = ["count": 20]
        TwitterAPICaller.client!.getDictionariesRequest(url: loadTweetURL, parameters: param, success: {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }) { (Error) in
            print("Cannot get tweets")
        }
    }
}
