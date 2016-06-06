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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loggedInLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var numAssetCurrUserLbl: UILabel!
    
    var user: FIRUser!
    
    var asset: Asset!
    var assetArray: [Asset] = []
    var assetKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //LOOK FOR ASSETS TO FILL INTO ASSET ARRAY
        
        DataService.ds.FB_ASSETS_REF.observeEventType(.Value, withBlock:  { snapshot in
            
            self.assetArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let assetDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let asset = Asset(assetKey: key, assetDict: assetDict)
                        self.assetArray.append(asset)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        //USER INFO
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if let user = user {
                
                self.user = FIRAuth.auth()?.currentUser
                
                if user.displayName == nil {
                    
                    let changeRequest = user.profileChangeRequest()
                    
                    changeRequest.displayName = user.email
                    
                    changeRequest.commitChangesWithCompletion({ error in
                        
                        if error != nil {
                            //** Implement alert here ** //
                            print("Couldn't change user name")
                        } else {
                            print("name change success, name is now \(user.displayName)")
                        }
                    })
                }
                self.loggedInLbl.text = "\(user.displayName!)"
                
                let refCurrUserAssets = DataService.ds.FB_USERS_REF.child(user.uid).child("assets")
                
                refCurrUserAssets.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                    
                    if snapshot.childrenCount == 0 {
                        self.numAssetCurrUserLbl.text = "0"
                    } else {
                        self.numAssetCurrUserLbl.text = "\(snapshot.childrenCount)"
                    }
                })
                
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

extension LoggedInVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let asset = assetArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("assetCell") as? AssetCell {
            
            cell.configureAsset(asset)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    
    
}
