//
//  LoggedInVC.swift
//  showcase2
//
//  Created by Francisco Claret on 01/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase

class LoggedInVC: UIViewController {
    
    @IBOutlet weak var loggedInLbl: UILabel!
    
    @IBOutlet weak var userImgView: UIImageView!
    
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                print("in logged in user = user")
                
                self.user = FIRAuth.auth()?.currentUser
                
                if user.displayName == nil {
                    
                    print("in displayName ==")
                    
                    let changeRequest = user.profileChangeRequest()
                    
                    changeRequest.displayName = user.email
                    
                    changeRequest.commitChangesWithCompletion({ error in
                        
                        if error != nil {
                            print("no luck")
                        } else {
                            print("name change success, name is now \(user.displayName)")
                        }
                    })
                }
                self.loggedInLbl.text = "Welcome \(user.displayName!)"
                
                if self.user.photoURL != nil {
                    
                    let usrImgUrl = String(self.user.photoURL!)
                    
                    DataService.ds.fetchImageFromUrl(usrImgUrl, completion: { image in
                        self.userImgView.image = image
                    })
                } else {
                    self.userImgView.image = UIImage(named: "add_user.png")
                }
                
            } else {
                print("no user signed in yet!")
            }
        }
    }
    
    @IBAction func logOutBtnPressed(sender: UIButton!) {
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        
        try! FIRAuth.auth()!.signOut()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}
