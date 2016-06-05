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
            print("in listening")
            
            self.typenameArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                print("in snapshots")
                
                for snap in snapshots {
                    
                    if let typeDict = snap.value as? Dictionary<String, AnyObject> {

                        print("printing snap.key \(snap.key)")
                        
                        let typeToAdd = Type(typeUid: snap.key, typeDict: typeDict)

                        self.typenameArray.append(typeToAdd)
                    }
                }
            }
            self.tableView.reloadData()
            print("printing array")
            print(self.typenameArray)
        })
    }
    
    @IBAction func addTypeBtnPressed(sender: UIButton) {
        
        if let typeName = newAssetTypeTxtField.text where newAssetTypeTxtField.text != "" {
            print("1")
            print(self.typenameArray)
            DataService.ds.createNewType(typeName)
            
            print("Now we should be listnening and addig one to the array")
            
            self.tableView.reloadData()
            
        } else {
            
            print("please fill in data in field!")
            
        }
    }
}

extension ManageAssetTypeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in type array count tableview")
        return typenameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(" in cell for row....")
        
        let type = typenameArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("typeCell") as? TypeCell {
            
            cell.configureTypeCell(type)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
