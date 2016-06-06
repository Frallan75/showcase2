//
//  ManageAssetTypeVC.swift
//  showcase2
//
//  Created by Francisco Claret on 03/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase

class ManageAssetTypeVC: UIViewController {
    
    @IBOutlet weak var newAssetTypeTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var typenameArray: [Type] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //LOAD EXISTING TYPES INTO typeArray
        DataService.ds.FB_TYPES_REF.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            
            self.typenameArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                for snap in snapshots {
                    
                    if let typeDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let typeToAdd = Type(typeUid: snap.key, typeDict: typeDict)
                        
                        self.typenameArray.append(typeToAdd)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addTypeBtnPressed(sender: UIButton) {
        
        if let typeName = newAssetTypeTxtField.text where newAssetTypeTxtField.text != "" {
            
            DataService.ds.createNewType(typeName)

            self.tableView.reloadData()
            
        } else {
            //*** Implement aler here!***///
            print("please fill in data in field!")
        }
    }
}

extension ManageAssetTypeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typenameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = typenameArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("typeCell") as? TypeCell {
            
            cell.configureTypeCell(type)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
