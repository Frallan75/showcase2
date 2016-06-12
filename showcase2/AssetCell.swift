//
//  AssetCell.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Alamofire

class AssetCell: UITableViewCell {
    
    @IBOutlet weak var assetImgView: UIView!
    @IBOutlet weak var assetTypeNameLbl: UILabel!
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetLifeLeftLbl: UILabel!
    @IBOutlet weak var assetStatusView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    func configureAsset(asset: Asset) {
        
        DataService.ds.FB_TYPES_REF.child(asset.typeUid).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { snapshot in
            
            if let typeDict = snapshot.value as? Dictionary<String, AnyObject> {

                self.assetTypeNameLbl.text = "\(typeDict["name"]!)"            }
        })
        
        print(asset.ownerUid)
        
        DataService.ds.FB_USERS_REF.child(asset.ownerUid).observeSingleEventOfType(FIRDataEventType.Value, withBlock:  { snapshot in
            
            if let ownerDict = snapshot.value as? Dictionary<String, AnyObject> {
                
                self.ownerNameLbl.text = ("\(ownerDict["name"]!)")
            }
        })
        
        assetNameLbl.text = asset.model
        
        if let lifeLeftInt = asset.estLifeLeft {

            assetLifeLeftLbl.text = "\(asset.estLifeLeft)"
            
            switch lifeLeftInt {
            case 0...4:
                assetStatusView.backgroundColor = UIColor.redColor()
            case 4...10:
                assetStatusView.backgroundColor = UIColor.orangeColor()
            case 11...20:
                assetStatusView.backgroundColor = UIColor.yellowColor()
            case 21...1000:
                assetStatusView.backgroundColor = UIColor.greenColor()
            default:
                assetStatusView.backgroundColor = UIColor.blackColor()
            }
        } else {
            print("problem converting LifeLeft string to Int")
        }
    }
}
