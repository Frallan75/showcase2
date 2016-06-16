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
    
    @IBOutlet weak var tableView:           UITableView!
    @IBOutlet weak var loggedInLbl:         UILabel!
    @IBOutlet weak var userImgView:         UIImageView!
    @IBOutlet weak var numAssetCurrUserLbl: UILabel!
    @IBOutlet weak var segmentController:   UISegmentedControl!
    @IBOutlet weak var searchTypeBar:       UISearchBar!
    
    var user:          FIRUser!
    var asset:         Asset?
    var assetArray:    [Asset] = []
    var myAssetArray:  [Asset] = []
    var allAssetsArray:[Asset] = []
    
    var assetKey:      String!
    var selector:      Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate      = self
        tableView.dataSource    = self
        searchTypeBar.delegate  = self
        
        userImgView.layer.cornerRadius = userImgView.frame.height / 2
        userImgView.layer.shadowColor = (UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5)).CGColor
        userImgView.layer.shadowOpacity = 0.9
        userImgView.layer.shadowRadius = 4.0
    }
    
    override func viewDidAppear(animated: Bool) {
        
        segmentController.selectedSegmentIndex = selector
        
        asset = nil
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if let user = user {
                self.user = user
                if user.displayName == nil {
                    
                    let changeRequest = user.profileChangeRequest()
                    changeRequest.displayName = user.email?.lowercaseString
                    changeRequest.commitChangesWithCompletion { error in
                        
                        if error != nil {
                            self.displayAlert("Error!", body: "Couldn't change user name")
                        } else {
                            self.displayAlert("Username success", body: "Username is now \(user.displayName)")
                        }
                    }
                    
                } else if user.displayName != nil {
                    self.loggedInLbl.text? = user.displayName!
                }
                
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

        DataService.ds.FB_ASSETS_REF.observeEventType(.Value, withBlock:  { snapshot in
            
            self.allAssetsArray = []
            self.myAssetArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let assetDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key

                        let asset = Asset(assetUid: key, assetDict: assetDict)
                        
                        self.allAssetsArray.append(asset)
                        if self.user.uid == asset.ownerUid {
                            self.myAssetArray.append(asset)
                        }
                    }
                }
            }
            if self.selector == 0 {
                self.assetArray = self.myAssetArray
            } else if self.selector == 1 {
                self.assetArray = self.allAssetsArray
            }
            self.numAssetCurrUserLbl.text = "\(self.assetArray.count)"
            self.tableView.reloadData()
        })
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
    
    @IBAction func segmentController(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            selector = 0
            assetArray = myAssetArray
            numAssetCurrUserLbl.text = "\(myAssetArray.count)"
            tableView.reloadData()
        case 1:
            selector = 1
            assetArray = allAssetsArray
            numAssetCurrUserLbl.text = "\(allAssetsArray.count)"
            tableView.reloadData()
        default:
            tableView.reloadData()
        }
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
        
        var image: UIImage?
        let asset = assetArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("assetCell") as? AssetCell {
            
            cell.downloadImageTask?.cancel()
            
            if let url = asset.assetUid {
                image = IMAGE_CACHE.objectForKey(url) as? UIImage
            }
            
            cell.configureAsset(asset, img: image)
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.asset = assetArray[indexPath.row]
        performSegueWithIdentifier(ASSET_MANAGEMENT_VC, sender: nil)
    }
}

extension LoggedInVC: UISearchBarDelegate{
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            if selector == 0 {
                assetArray = myAssetArray
            } else if selector == 1 {
                assetArray = allAssetsArray
            }
            tableView.reloadData()
            
        } else {
            
            let lower = searchBar.text!.lowercaseString
            
            var searchTypeNameArray, searchModelArray, searchOwnerNameArray, doSearchOnArray: [Asset]!

            if selector == 0 {
                doSearchOnArray = myAssetArray
            } else if selector == 1 {
                doSearchOnArray = allAssetsArray
            }
            
            searchTypeNameArray = doSearchOnArray.filter({$0.assetTypeName.rangeOfString(lower) != nil})
            searchModelArray = doSearchOnArray.filter({$0.model.rangeOfString(lower) != nil})
            searchOwnerNameArray = doSearchOnArray.filter({$0.assetOwnerName.rangeOfString(lower) != nil})
            
            assetArray = Array(Set(searchTypeNameArray + searchModelArray + searchOwnerNameArray))
        }
        
        tableView.reloadData()
    }
}

