//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Wade Li on 3/10/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tArray = [NSDictionary]()
    var nOT: Int!
    let myRC = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRC.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRC
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweet()
    }

    @objc func loadTweet(){
        nOT = 20
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myP = ["count": nOT]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myP, success: { (tweets:[NSDictionary]) in
            self.tArray.removeAll()
            for tweet in tweets{
                self.tArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRC.endRefreshing()
        }, failure: { (Error) in
            print("Cound not retreive tweet")
        })
    }
    
    func loadMore(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        nOT = nOT + 20
        let myP = ["count": nOT]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myP, success: { (tweets:[NSDictionary]) in
            self.tArray.removeAll()
            for tweet in tweets{
                self.tArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Cound not retreive tweet")
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        let user = tArray[indexPath.row]["user"] as! NSDictionary
        cell.username.text = user["name"] as? String
        cell.context.text = tArray[indexPath.row]["text"] as? String
        let iURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: iURL!)
        if let iData = data {
            cell.poster.image = UIImage(data: iData)
        }
        cell.setFavorite(tArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tArray[indexPath.row]["id"] as! Int
        cell.setRetweet(tArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tArray.count {
            loadMore()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tArray.count
    }
}
