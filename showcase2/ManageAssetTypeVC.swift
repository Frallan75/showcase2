//
//  ManageAssetTypeVC.swift
//  showcase2
//
//  Created by Francisco Claret on 03/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase
import Foundation

protocol PickTypeProtocol {
    func chosenType(type: Type)
}

class ManageAssetTypeVC: UIViewController {
    
    @IBOutlet weak var newAssetTypeTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var typeArray: [Type] = []
    var delegate: PickTypeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.FB_TYPES_REF.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            
            self.typeArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if let typeDict = snap.value as? Dictionary<String, AnyObject> {
                        let typeToAdd = Type(typeUid: snap.key, typeDict: typeDict)
                        self.typeArray.append(typeToAdd)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addTypeBtnPressed(sender: UIButton) {
        
        if let typeName = newAssetTypeTxtField.text where typeName != "" {
            
            DataService.ds.createNewType(typeName)
            
            self.tableView.reloadData()
            self.newAssetTypeTxtField.endEditing(true)
            self.newAssetTypeTxtField.text = ""
            
        } else {
            self.displayAlert("Alert!", error: "Please fill in data in field!")
        }
    }
    
    func displayAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension ManageAssetTypeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = typeArray[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("typeCell") as? TypeCell {
            cell.configureTypeCell(type)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.delegate?.chosenType(typeArray[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
