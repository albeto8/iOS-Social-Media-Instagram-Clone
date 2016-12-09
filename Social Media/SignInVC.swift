//
//  ViewController.swift
//  Social Media
//
//  Created by Mario Alberto Barragán Espinosa on 05/09/16.
//  Copyright © 2016 mario. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet var emailField: FancyField!
    @IBOutlet var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_ID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MARIO: Unable to authenticate with facebook: - \(error)")
            }else if result?.isCancelled == true {
                print("MARIO: User cancelled facebook authenticaton")
            }else{
                print("MARIO: Succesfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("MARIO: Email user authenticated with firebase")
                    if let user = user{
                       self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("MARIO: Unable to authenticate with firebase using email")
                        }else {
                            print("MARIO: Succesfully authenticated with firebase using email")
                            if let user = user{
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func firebaseAuthenticate (_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("MARIO: Unable to authenticate with firebase: - \(error)")
            }else{
                print("MARIO: Succesfully authenticated with firebase")
                if let user = user{
                   self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    func completeSignIn(id: String){
         let saveSuccessful: Bool = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_ID)
        print("MARIO: KeyChain save reuslt: \(saveSuccessful)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}

