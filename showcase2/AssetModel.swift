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
    
    var type: String!
    var owner: String!
    var make: String!
    var model: String!
    var estLifeLeft: Int!
    var purchaseDate: NSDate!
    var imageUrl: String!
    var assetCode: String!
    var assetKey: String!
    var assetRef: FIRDatabaseReference!
    
    init(assetKey: String, assetDict: Dictionary<String, AnyObject>) {
        
        self.assetKey = assetKey
        self.assetRef = DataService.ds.FB_ASSETS_REF.child(self.assetKey)
        
        if let type = assetDict["type"] as? String {
            self.type = type
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
        
        if let estLifeLeft = assetDict["estLifeLeft"] as? Int {
            self.estLifeLeft = estLifeLeft
        }
        
        if let purchaseDate = assetDict["purchaseDate"] as? NSDate {
            self.purchaseDate = purchaseDate
        }
        
        if let imageUrl = assetDict["imgageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let assetCode = assetDict["assetCode"] as? String {
            self.assetCode = assetCode
        }
        
    }
    
}

