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
    
    init(uid: String, ownerDict: Dictionary<String, AnyObject>) {
        
        self.ownerUid = uid
        
        if let name = ownerDict["name"] as? String {
            self.name = name
        }
        
        if let email = ownerDict["email"] as? String {
            self.email = email
        }
        
        if let provider = ownerDict["provider"] as? String {
            self.provider = provider
        }  
    }
}
