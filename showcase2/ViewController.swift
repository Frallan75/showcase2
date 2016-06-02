//
//  ViewController.swift
//  showcase2
//
//  Created by Francisco Claret on 01/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTxtField: MaterialTxtField!
    @IBOutlet weak var passwordTxtField: MaterialTxtField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //
    //        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
    //            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    //        }
    //    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { fbLoginResult, fbLoginError in
            
            if fbLoginError != nil {
                print("Facebook Error at login \(fbLoginError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Succefully loged in with FB! \(accessToken)")
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    
                    if error != nil {
                        print("We have a problem")
                    } else {
                        let userId = user!.displayName!
                        NSUserDefaults.standardUserDefaults().setValue(userId, forKey: KEY_UID)
                        
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(sender: UIButton) {
        
        if let email = usernameTxtField.text where email != "", let pwd = passwordTxtField.text where pwd != "" {
        
        }
    }
    
    func clearForm() {
        
        usernameTxtField.text = ""
        passwordTxtField.text = ""
    }
    
    
    
}

