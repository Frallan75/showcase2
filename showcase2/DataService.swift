//
//  DataService.swift
//  showcase2
//
//  Created by Francisco Claret on 01/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference()
    
    var REF_BASE: FIRDatabaseReference {
      return _REF_BASE
    }
    
    func fetchImageFromUrl(url: String, completion: (image: UIImage) -> ()) {
        print(url)
        Alamofire.request(.GET, url).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error -> Void in
            
            let fetchedImage: UIImage!
            
            if error == nil {
                
                fetchedImage = UIImage(data: data!)!
                
            } else {
                
                fetchedImage = UIImage(named: "add_user.png")
                
            }
            completion(image: fetchedImage)
        })
    }

    
}

