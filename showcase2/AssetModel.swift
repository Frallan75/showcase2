//
//  AssetCellModel.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Firebase

class Asset: NSObject {
    
    var typeUid: String!
    var ownerUid: String!
    var make: String!
    var model: String!
    var estLifeLeft: Int!
    var purchaseDate: String!
    var endDate: String!
    var assetImgUrl: String!
    var assetOwnerName: String!
    var assetTypeName: String!
//    var assetCode: String!
    var assetUid: String!
    
    init(assetUid: String, assetDict: Dictionary<String, AnyObject>) {
        
        self.assetUid = assetUid
        
        if let typeUid = assetDict[ASSET_TYPE_UID] as? String {
            self.typeUid = typeUid
        }
        
        if let ownerUid = assetDict[ASSET_OWNER_UID] as? String {
            self.ownerUid = ownerUid
        }

        if let make = assetDict[ASSET_MAKE] as? String {
            self.make = make
        }
        
        if let model = assetDict[ASSET_MODEL] as? String {
            self.model = model
        }
        
        if let estLifeLeft = assetDict[ASSET_EST_TIME_END] as? Int {
            self.estLifeLeft = estLifeLeft
        }
        
        if let purchaseDate = assetDict[ASSET_PUR_DATE] as? String {
            self.purchaseDate = purchaseDate
        }
        
        if let endDate = assetDict[ASSET_END_DATE] as? String {
            self.endDate = endDate
        }
        
        if let assetImgUrl = assetDict[ASSET_IMG_URL] as? String {
            self.assetImgUrl = assetImgUrl
        }
        
        if let assetOwnerName = assetDict["assetOwnerName"] as? String {
            self.assetOwnerName = assetOwnerName
        }
        
        if let assetTypeName = assetDict["assetTypeName"] as? String {
            self.assetTypeName = assetTypeName
        }
        
//        if let assetCode = assetDict["assetCode"] as? String {
//            self.assetCode = assetCode
//        }
    }
    
    override var hash: Int {
        return assetUid.hashValue
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? Asset else {
            return false
        }
        let lhs = self
        
        return lhs.assetUid == rhs.assetUid
    }

}

