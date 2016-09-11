//
//  PostCell.swift
//  Social Media
//
//  Created by Mario Alberto Barragán Espinosa on 07/09/16.
//  Copyright © 2016 mario. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet var profileImageView: CircleView!
    @IBOutlet var heartImageView: CircleView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post){
        self.post = post
        self.postTextView.text = post.caption
        self.likesLabel.text = String(post.likes)
    }

}
