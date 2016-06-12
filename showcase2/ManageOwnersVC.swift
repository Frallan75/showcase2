//
//  ManageOwnersVC.swift
//  showcase2
//
//  Created by Francisco Claret on 07/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ManageOwnersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var ownersArray: [Owner] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //**LOAD OWNER INTO ARRAY**//
        DataService.ds.FB_USERS_REF.observeEventType(FIRDataEventType.Value, withBlock:  { snapshot in
            self.ownersArray = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    let ownerUid = snap.key
                    
                    if let ownerDict = snap.value as? Dictionary<String, AnyObject> {
                        let ownerToAdd = Owner(ownerUid: ownerUid, ownerDict: ownerDict)
                        self.ownersArray.append(ownerToAdd)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
}

extension ManageOwnersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ownersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let owner = ownersArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ownerCell") as? OwnerCell {
            cell.configureOwnerCell(owner)
            return cell
        }
        return OwnerCell()
    }
}
