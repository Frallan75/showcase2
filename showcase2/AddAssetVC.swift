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

    @IBOutlet weak var makeTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var estLifeLeftTF: UITextField!
    
    var asset: Asset!
    var assetDict = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pickTypeBtnPressed(sender: UIButton) {
    }
    
    @IBAction func pickOwnerBtnPressed(sender: UIButton) {
    }
    
    @IBAction func addImgBtnPressed(sender: UIButton) {
    }
    
    @IBAction func saveButtonPressed(sender: UIButton!) {
    
        if let make = makeTF.text where make != "", let model = modelTF.text where model != "", let estLifeLeft = estLifeLeftTF.text where estLifeLeftTF != "" {
            
        
            assetDict["type"] = "IPhone"
            assetDict["owner"] = FIRAuth.auth()?.currentUser?.email!
            print(assetDict["owner"])
            
            assetDict["make"] = make
            assetDict["model"] = model
            assetDict["estLifeLeft"] = estLifeLeft
            
            assetDict["purchaseDate"] = nil
            assetDict["imageUrl"] = "http://www.dn.se"
            
            
            
        
            
        } else {
            print("Alert, all fields are not filled!")
        }
    
    
    
    }
    
    
}
