//
//  FeedVC.swift
//  Social Media
//
//  Created by Mario Alberto Barragán Espinosa on 06/09/16.
//  Copyright © 2016 mario. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var addImage: CircleView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var captionTextField: FancyField!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? PostCell{
            
            if let image = FeedVC.imageCache.object(forKey: "") {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        }else{
            return PostCell()
        }
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let removeSuccessful: Bool = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_ID)
        print("MARIO: ID removed from keychain result: \(removeSuccessful)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.addImage.image = pickedImage
            imageSelected = true
        }else{
            print("MARIO: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: AnyObject) {
        
        guard let caption = captionTextField.text, caption != "" else {
            print("MARIO: Empty caption text")
            return
        }
        
        guard let image = addImage.image, imageSelected == true else {
            print("MARIO: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("MARIO: Unabled to upload image to firebase storage")
                } else {
                    print("MARIO: Succesfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                }
            })
        }
    }
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }

}
