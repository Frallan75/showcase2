//
//  AssetCellModel.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Firebase

class Asset {
    
    var typeUid: String!
    var owner: String!
    var make: String!
    var model: String!
    var estLifeLeft: String!
    var purchaseDate: NSDate!
    var assetImgUrl: String!
    var assetCode: String!
    var assetKey: String!
    var assetRef: FIRDatabaseReference!
    
    init(assetKey: String, assetDict: Dictionary<String, AnyObject>) {
        
        self.assetKey = assetKey
        self.assetRef = DataService.ds.FB_ASSETS_REF.child(self.assetKey)
        
        if let typeUid = assetDict["typeUid"] as? String {
            self.typeUid = typeUid
        }
        
        if let owner = assetDict["owner"] as? String {
            self.owner = owner
        }

        if let make = assetDict["make"] as? String {
            self.make = make
        }
        
        if let model = assetDict["model"] as? String {
            self.model = model
        }
        
        if let estLifeLeft = assetDict["estLifeLeft"] as? String {
            self.estLifeLeft = estLifeLeft
        }
        
        if let purchaseDate = assetDict["purchaseDate"] as? NSDate {
            self.purchaseDate = purchaseDate
        }
        
        if let assetImgUrl = assetDict["assetImgUrl"] as? String {
            self.assetImgUrl = assetImgUrl
        }
        
        if let assetCode = assetDict["assetCode"] as? String {
            self.assetCode = assetCode
        }
    }
}

