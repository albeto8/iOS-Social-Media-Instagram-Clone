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

class SignInVC: UIViewController {

    @IBOutlet var emailField: FancyField!
    
    @IBOutlet var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("MARIO: Unable to authenticate with firebase using email")
                        }else {
                            print("MARIO: Succesfully authenticated with firebase using email")
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
            }
        })
    }

}

