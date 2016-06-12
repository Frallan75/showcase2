//
//  OwnerModel.swift
//  showcase2
//
//  Created by Francisco Claret on 04/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import UIKit

class Owner {
    
    var name: String!
    var ownerUid: String!
    var email: String!
    var provider: String!
    var ownerImgUrl: String!
    
    init(ownerUid: String, ownerDict: Dictionary<String, AnyObject>) {
        
        self.ownerUid = ownerUid
        
        if let name = ownerDict["name"] as? String {
            self.name = name
        }
        
        if let email = ownerDict["email"] as? String {
            self.email = email
        }
        
        if let provider = ownerDict["provider"] as? String {
            self.provider = provider
        }
        
        if let ownerImgUrl = ownerDict["ownerUrl"] as? String {
            self.ownerImgUrl = ownerImgUrl
        }
    }
}
