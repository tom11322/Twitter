//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Wade Li on 3/10/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var context: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var retweet: UIButton!
    
    @IBAction func favorTweet(_ sender: Any) {
        let  toBeFavor = !favorited
        if(toBeFavor) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        }
        else{
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
    }
    
    @IBAction func reTweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweet(true)
        }, failure: { (error) in
            print("Error in retweeting: \(error)")
        })
    }
    
    var favorited: Bool = false
    var tweetId: Int = -1
    
    func setFavorite(_ isFavorited: Bool){
        favorited = isFavorited
        if(favorited) {
            like.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            like.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_ isRetweeted: Bool){
        if(isRetweeted){
            retweet.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweet.isEnabled = false
        }
        else{
            retweet.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweet.isEnabled = true
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
