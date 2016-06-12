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
    var asset: Asset?
    var assetArray: [Asset] = []
    var assetKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        asset = nil
        
        DataService.ds.FB_ASSETS_REF.observeEventType(.Value, withBlock:  { snapshot in
            
            self.assetArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let assetDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let asset = Asset(assetUid: key, assetDict: assetDict)
                        self.assetArray.append(asset)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if let user = user {
                
                self.user = user //FIRAuth.auth()?.currentUser
                
                if user.displayName == nil {
                    let changeRequest = user.profileChangeRequest()
                    changeRequest.displayName = user.email
                    changeRequest.commitChangesWithCompletion { error in
                        
                        if error != nil {
                            self.displayAlert("Error!", body: "Couldn't change user name")
                        } else {
                            self.displayAlert("Username success", body: "Username is now \(user.displayName)")
                        }
                    }
                    
                } else if user.displayName != nil {
                    self.loggedInLbl.text = user.displayName
                }
                
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
                    DataService.ds.fetchImageFromUrl(usrImgUrl) { image in
                        self.userImgView.image = image
                    }
                    
                } else {
                    self.userImgView.image = UIImage(named: "add_user.png")
                }
            } else {
                self.displayAlert("Login error!", body: "No user signed in!")
            }
        }
    }
    
    func displayAlert (title: String, body: String) {
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOutBtnPressed(sender: UIButton!) {
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        try! FIRAuth.auth()!.signOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ASSET_MANAGEMENT_VC {
            let destVC = segue.destinationViewController as! AssetAddVC
            destVC.asset = self.asset
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.asset = assetArray[indexPath.row]
        performSegueWithIdentifier(ASSET_MANAGEMENT_VC, sender: nil)
    }
    
    
}
