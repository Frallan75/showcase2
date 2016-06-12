//
//  TypeModel.swift
//  showcase2
//
//  Created by Francisco Claret on 03/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class Type {
    
    var typeUid: String!
    var name: String!
    var assetsInType: String!
    
    init(typeUid: String, typeDict: Dictionary<String, AnyObject>) {
        
        if let assetsInType = typeDict[TYPE_ASSETS] as? String {
            self.assetsInType = assetsInType
        }
        
        if let name = typeDict[TYPE_NAME] as? String {
            self.name = name
        }
        
        self.typeUid = typeUid
    }
}
