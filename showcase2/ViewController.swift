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
    
    override func viewDidAppear(animated: Bool) {
        
        // **  COMMENT 3 LINES BELOW TO UNAPPLY QUICK "ALREADY LOGGED IN WITH NSUserDefaults"
        
                if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
        // **
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { fbLoginResult, fbLoginError in
            if fbLoginError != nil {
                self.displayLoginAlert("\(fbLoginError.userInfo)", error: "Please try again, if error persists, contact the app developer!")
                
            } else {
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    
                    if error != nil {
                        self.displayLoginAlert("Alert!", error: "WE have a sign in with credentials problem")
                        
                    } else if let user = user {
                        
                        let userToCreate: Dictionary<String, AnyObject> = ["profileImgUrl" : user.photoURL!.absoluteString,
                                                                           "provider" : credential.provider,
                                                                           "email" : user.email!,
                                                                           "name" : user.displayName!]
                        
                        DataService.ds.FB_USERS_REF.child(user.uid).updateChildValues(userToCreate)
                        self.loginFinalStep(user)
                        
                    } else {
                        self.displayLoginAlert("Alert", error: "There was a problem at login, please contact app developer and procide CODE: 434")
                    }
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(sender: UIButton) {
        
        if let email = usernameTxtField.text where email != "", let pwd = passwordTxtField.text where pwd != "" {
            
            clearForm(nil)
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd) { user, error in
                
                if let error = error {
                    
                    if let errorDesc = FIRAuthErrorCode(rawValue: error.code) {
                        
                        switch errorDesc {
                            
                        case .ErrorCodeNetworkError:
                            self.displayLoginAlert("Network Alert", error: "No connection to the Internet available, please try again when connectivity is established")
                        case.ErrorCodeEmailAlreadyInUse:
                            self.displayLoginAlert("Email already in use!", error: "")
                        case.ErrorCodeInvalidEmail:
                            self.displayLoginAlert("Invalid email format", error: "")
                        case .ErrorCodeWrongPassword:
                            self.displayLoginAlert("Wrong password", error: "The supplied password was incorrect, pleae try again")
                        case .ErrorCodeUserNotFound:
                            self.displayCreateNewUserAlert("create user?", msg: "Are you sure you want to create a new user with email: \(email)?", email: email, pwd: pwd)
                        default:
                            self.displayLoginAlert("Uknown error", error: "An unknown error has occurred, please try again!")
                        }
                    }
                    
                } else if let user = user {
                    
                    self.loginFinalStep(user)
                    
                } else {
                    self.displayLoginAlert("Alert", error: "There was a problem at login, please contact app developer and procide CODE: 434")
                }
            }
        } else {
            self.displayLoginAlert("Please enter valid data in fields", error: "You must enter a valid email adress and password in order to login. Please try again!")
        }
    }

    func displayLoginAlert(title: String, error: String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayCreateNewUserAlert(title: String, msg: String, email: String, pwd: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {alert in self.createNewUser(email, pwd: pwd)})
        let discardAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: clearForm)
        
        alert.addAction(action)
        alert.addAction(discardAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createNewUser(email: String, pwd: String) {
    
        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
            if let error = error {
                self.displayLoginAlert("Alert", error: "\(error.localizedDescription)")

            } else if let user = user {
                self.displayLoginAlert("congrats", error: "user created")
                self.loginFinalStep(user)
            }
        })
    }
    
    func loginFinalStep(user: FIRUser) {
        
        NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: KEY_UID)
        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        
    }
    
    func clearForm(alert: UIAlertAction?) {
        usernameTxtField.text = ""
        passwordTxtField.text = ""
    }
}