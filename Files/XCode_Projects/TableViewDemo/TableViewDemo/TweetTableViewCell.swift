//
//  TweetTableViewCell.swift
//  TableViewDemo
//
//  Created by ChenMo on 7/12/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var tweeter: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var timeCreated: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI();
        }
    }
    
    private func updateUI() {
        tweeter?.text = tweet?.user.description;
        content?.text = tweet?.text;
        DispatchQueue.global(qos: .userInitiated).async {
            if let profilePhotoURL = self.tweet?.user.profileImageURL {
                if let imageData = try? Data(contentsOf: profilePhotoURL) {
                    self.profilePhotoImageView?.image = UIImage(data: imageData);
                }
            } else {
                self.profilePhotoImageView?.image = nil;
            }
        }
        
    }
}
