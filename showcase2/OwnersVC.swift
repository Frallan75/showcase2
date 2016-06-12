//
//  OwnersVC.swift
//  showcase2
//
//  Created by Francisco Claret on 10/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import Foundation

protocol PickOwnerProtocol: class {
    func chosenOwmer(chosenOwner: Owner)
}

class OwnersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PickOwnerProtocol?
    var ownerArray: [Owner] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Im in the owners VC")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.FB_USERS_REF.observeEventType(.Value, withBlock: { snapshot in
            
            self.ownerArray = []
            print("1")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("2")
                    if let ownerDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        print("Hahahha \(ownerDict["name"])")
                        
                        let ownerToStore = Owner(ownerUid: snap.key, ownerDict: ownerDict)
                        self.ownerArray.append(ownerToStore)
                        print(self.ownerArray)
                    }
                }
            }
            self.tableView.reloadData()
             print(self.ownerArray)
        })
    }
    
    @IBAction func closeBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension OwnersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ownerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let owner = ownerArray[indexPath.row]
        print("in cell")
        if let cell = tableView.dequeueReusableCellWithIdentifier("ownerCell") as? OwnerCell {
            
            cell.configureOwnerCell(owner)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.delegate?.chosenOwmer(ownerArray[indexPath.row])
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}
