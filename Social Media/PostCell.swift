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
    var likesReference: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        heartImageView.addGestureRecognizer(tap)
        heartImageView.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, image: UIImage? = nil){
        likesReference = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)

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
        
        likesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.heartImageView.image = UIImage(named: "empty-heart")
            }else{
               self.heartImageView.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.heartImageView.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesReference.setValue(true)
            }else{
                self.heartImageView.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesReference.removeValue()
            }
        })
    }
}
