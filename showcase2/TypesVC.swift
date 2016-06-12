//
//  TypesVC.swift
//  showcase2
//
//  Created by Francisco Claret on 10/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


protocol PickedTypeProtocol {
    func chosenType(type: Type)
}

class TypesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var typesArray: [Type] = []
    var delegate: PickedTypeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.FB_TYPES_REF.observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
            
                for snap in snapshots {
                
                    if let typeDict = snap.value as? Dictionary<String, AnyObject> {
                        let typeToAdd = Type(typeUid: snap.key, typeDict: typeDict)
                        self.typesArray.append(typeToAdd)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    @IBAction func closeBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension TypesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = typesArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("typeCell") as? TypeCell {
            
            cell.configureTypeCell(type)
            return cell
        
        }
        return TypeCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        delegate?.chosenType(typesArray[indexPath.row])
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}