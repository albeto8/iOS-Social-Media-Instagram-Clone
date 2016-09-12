//
//  PostCell.swift
//  Social Media
//
//  Created by Mario Alberto Barragán Espinosa on 07/09/16.
//  Copyright © 2016 mario. All rights reserved.
//

import UIKit
import Firebase

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
    
    func configureCell(post: Post, image: UIImage? = nil){
        self.post = post
        self.postTextView.text = post.caption
        self.likesLabel.text = String(post.likes)
        
        if image != nil {
            self.postImageView.image = image
        } else {
            let reference = FIRStorage.storage().reference(forURL: post.imageUrl)
            reference.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("MARIO: Unable to download image from Firebase storage error: \(error)")
                } else {
                    print("MARIO: Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let downloadedImage = UIImage( data: imageData){
                            self.postImageView.image = downloadedImage
                            FeedVC.imageCache.setObject(downloadedImage, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }

}
