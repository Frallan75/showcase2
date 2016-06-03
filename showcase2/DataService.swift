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

let FB_REF = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    let FB_BASE_REF = FB_REF
    let FB_ASSET_REF = FB_REF.child("assets")
    let FB_USER_REF = FB_REF.child("users")
    
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
    
    func createFIRUser(uid: String, user: Dictionary<String, AnyObject>) {
        FB_USER_REF.child(uid).updateChildValues(user)
    }
    

    
}

