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
    let FB_ASSETS_REF = FB_REF.child("assets")
    let FB_USERS_REF = FB_REF.child("users")
    let FB_TYPES_REF = FB_REF.child("types")
    
    func createFIRUser(uid: String, user: Dictionary<String, AnyObject>) {
        FB_USERS_REF.child(uid).updateChildValues(user)
    }
    
    func createNewType(typeName: String) {
        
        let key = FB_TYPES_REF.childByAutoId().key
        var typeDict = Dictionary<String, AnyObject>()
        
        typeDict["uid"] = key
        typeDict["name"] = typeName
        
        FB_TYPES_REF.child(key).updateChildValues(typeDict)
    }
    
    func createNewAsset(assetDict: Dictionary<String, AnyObject>) {
        
        let newKey = FB_ASSETS_REF.childByAutoId().key
        var assetDictUpdatedWid = assetDict
        assetDictUpdatedWid["uid"] = newKey
        FB_ASSETS_REF.child(newKey).updateChildValues(assetDictUpdatedWid)
        print("just before asset")
        if let owner = assetDict["owner"] as? String {
                print("in asset create")
            var assetDictToAdd = Dictionary<String, AnyObject>()
            assetDictToAdd[newKey] = newKey
            let newRef = FB_USERS_REF.child(owner)
            newRef.child("assets").updateChildValues(assetDictToAdd)
        }
    }
    
        func fetchImageFromUrl(url: String, completion: (image: UIImage) -> ()) {
            
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

