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
                self.loggedInLbl.text = user.displayName
                self.user = FIRAuth.auth()?.currentUser
            } else {
                print("no user signed in yet!")
            }
        }
    }
}
