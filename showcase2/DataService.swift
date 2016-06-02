//
//  DataService.swift
//  showcase2
//
//  Created by Francisco Claret on 01/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference()
    
    var REF_BASE: FIRDatabaseReference {
      return _REF_BASE
    }
    
}

