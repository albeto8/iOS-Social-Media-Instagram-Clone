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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
