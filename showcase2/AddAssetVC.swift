//
//  AddAssetVC.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class AddAssetVC: UIViewController {
    
    @IBOutlet weak var ownerPickerView: UIPickerView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var makeTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var estLifeLeftTF: UITextField!
    
    @IBOutlet weak var BottomStackConstraint: NSLayoutConstraint!
    
    var typePickerArray: [Type] = []
    var ownerPickerArray: [Owner] = []
    
    var asset: Asset!
    
    var typeChosen: String!
    var ownerChosen: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePickerView.delegate = self
        typePickerView.dataSource = self
        ownerPickerView.delegate = self
        ownerPickerView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Load types into pickerArray
        
        DataService.ds.FB_TYPES_REF.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            
            self.typePickerArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let typeDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let typeToStoreToPickerArray = Type(typeUid: snap.key, typeDict: typeDict)
                        self.typePickerArray.append(typeToStoreToPickerArray)
                    }
                }
            }
            self.typePickerView.reloadAllComponents()
        })
        
        // Load users into ownersArray
        
        DataService.ds.FB_USERS_REF.observeEventType(FIRDataEventType.Value, withBlock:  { snapshot in
            
            self.ownerPickerArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    if var ownerDict = snap.value as? Dictionary<String, AnyObject> {
                        ownerDict["ownerUid"] = snap.key
                        let ownerToStorPickerArray = Owner(uid: snap.key, ownerDict: ownerDict)
                        self.ownerPickerArray.append(ownerToStorPickerArray)
                    }
                }
                
            }
            self.ownerPickerView.reloadAllComponents()
        })
    }
    
    @IBAction func pickOwnerBtnPressed(sender: UIButton) {
    }
    
    @IBAction func addImgBtnPressed(sender: UIButton) {
    }
    
    @IBAction func saveButtonPressed(sender: UIButton!) {
        
        if let make = makeTF.text where make != "", let model = modelTF.text where model != "", let estLifeLeft = estLifeLeftTF.text where estLifeLeftTF != "" {
            
            var assetDict = Dictionary<String, AnyObject>()
            
            assetDict["typeUid"] = self.typeChosen
            assetDict["owner"] = self.ownerChosen
            
            assetDict["make"] = make
            assetDict["model"] = model
            assetDict["estLifeLeft"] = estLifeLeft
            
            assetDict["purchaseDate"] = nil
            assetDict["imageUrl"] = "http://www.dn.se"
            
            DataService.ds.createNewAsset(assetDict)
            
        } else {
            
            //XXXXXX Implement Alerts here XXXXX//
            print("Alert, all fields are not filled!")
        }
    }
}

extension AddAssetVC: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if typePickerView == pickerView {
            return self.typePickerArray.count
        } else if ownerPickerView == pickerView {
            return self.ownerPickerArray.count
        } else {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if typePickerView == pickerView {
            return self.typePickerArray[row].name
        } else if ownerPickerView == pickerView {
            
            if self.ownerPickerArray[row].name != nil {
                return self.ownerPickerArray[row].name
            } else {
                return self.ownerPickerArray[row].email
            }
        } else {
            return "N/A"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if typePickerView == pickerView {
            self.typeChosen = self.typePickerArray[row].typeUid
        } else if ownerPickerView == pickerView {
            self.ownerChosen = self.ownerPickerArray[row].ownerUid
        }
    }
}
