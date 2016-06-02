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
                self.loggedInLbl.text = "Welcome \(user.displayName)"
            
            } else {
                print("no user signed in yet!")
            }
        }
    }
}
