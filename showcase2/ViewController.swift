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
        
        print(DataService.ds.FB_BASE_REF)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // **  COMMENT TO UNAPPLY QUICK "ALREADY LOGGED IN WITH NSUserDefaults"
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            
        }
        // **
        
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        var userToCreate = Dictionary<String, AnyObject>()
        
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { fbLoginResult, fbLoginError in
            
            if fbLoginError != nil {
                
                print("Facebook Error at login \(fbLoginError)")
                
            } else {
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    
                    if error != nil {
                        
                        print("WE have a sign in with credentials problem")
                        
                    } else {
                        
                        userToCreate["profileImgUrl"] = user!.photoURL!.absoluteString
                        userToCreate["provider"] = credential.provider
                        userToCreate["email"] = user!.email
                        userToCreate["name"] = user!.displayName
                        
                        DataService.ds.createFIRUser(user!.uid, user: userToCreate)
                        
                        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(sender: UIButton) {
        
        if let email = usernameTxtField.text where email != "", let pwd = passwordTxtField.text where pwd != "" {
            
            clearForm(nil)
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { user, error in
                
                if let error = error {
                    
                    print("Printing error: \(error.localizedDescription)")
                    
                    if let errorDesc = FIRAuthErrorCode(rawValue: error.code) {
                        
                        switch errorDesc {
                            
                        case.ErrorCodeInvalidEmail:
                            self.displayLoginAlert("Invalid email format", error: "")
                            
                        case .ErrorCodeWrongPassword:
                            self.displayLoginAlert("Wrong password", error: "")
                            
                        case .ErrorCodeUserNotFound:
                            self.displayCreateNewUserAlert("create user?", msg: "Are you sure you want to create a new user with email: \(email)?", user: email, pwd: pwd)
                            
                        default:
                            self.displayLoginAlert("Uknown error", error: "")
                        }
                    }
                    
                } else if let user = user {
                    
                    self.createUserDictionaryEmailLogin(user)
                    
                } else {
                    
                    print("Error in email user creation!")
                }
            })
            
        } else {
            displayLoginAlert("Please enter valid data in fields", error: "You must enter a valid email adress and password in order to login. Please try again!")
        }
    }
    
    func createNewUser(email: String, pwd: String) {
        
        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user: FIRUser?, error:NSError?) in
            
            if let error = error {
                
                if let errorDesc = FIRAuthErrorCode(rawValue: error.code) {
                    
                    switch errorDesc {
                        
                    case .ErrorCodeInvalidEmail:
                        self.displayLoginAlert("Login Error!", error: "Invalid Email format")
                    case .ErrorCodeWeakPassword:
                        self.displayLoginAlert("Login Error!", error: "Password to weak. Password must be at least 6 characters long")
                    default:
                        self.displayLoginAlert("Login Error!", error: "Unknown error at create")
                    }
                }
            } else if let user = user {
                
                self.createUserDictionaryEmailLogin(user)
                
            } else {
                
                print("Error in email user creation!")
            }
        })
    }
    
    func createUserDictionaryEmailLogin(user: FIRUser) {
        
        var userToCreate = Dictionary<String, AnyObject>()
        
        userToCreate["provider"] = "email"
        userToCreate["email"] = user.email
        
        DataService.ds.createFIRUser(user.uid, user: userToCreate)
        
        self.loginFinalStep(user)
        
    }
    
    func loginFinalStep(user: FIRUser) {
        
        NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: KEY_UID)
        
        print(FIRAuth.auth()?.currentUser?.email)
        
        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        
    }
    
    func displayLoginAlert(title: String, error: String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayCreateNewUserAlert(title: String, msg: String, user: String, pwd: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
            self.createNewUser(user, pwd: pwd)
        }
        
        let discardAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: clearForm)
        alert.addAction(action)
        alert.addAction(discardAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func clearForm(alert: UIAlertAction?) {
        
        usernameTxtField.text = ""
        passwordTxtField.text = ""
    }
}