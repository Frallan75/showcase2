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
    
    func createNewType(typeName: String) {
        let key = FB_TYPES_REF.childByAutoId().key
        let typeDict = ["name" : typeName]
        FB_TYPES_REF.child(key).updateChildValues(typeDict)
    }
    
    func createNewAsset(assetDict: Dictionary<String, AnyObject>, oldAsset: Asset?) {
        
        let newKey: String!
        var assetDictUpdatedWid: Dictionary<NSObject, AnyObject>
        let childUpdates: Dictionary<NSObject, AnyObject>
        
        if let oldKey = oldAsset?.assetUid {
            
            newKey = oldKey
            
            let childRemoves = ["/types/\(oldAsset!.typeUid)/assets/\(oldKey)",
                                "/users/\(oldAsset!.ownerUid)/assets/\(oldKey)"]
            
            for item in childRemoves {
                FB_REF.child(item).removeValue()
            }
        } else {
             newKey = FB_ASSETS_REF.childByAutoId().key
        }
        
        assetDictUpdatedWid = assetDict
        
        if let endDateStr = assetDict["endDate"] as? String {
            assetDictUpdatedWid["estLifeLeft"] = endOfLifeCalculation(endDateStr)
        } else {
            assetDictUpdatedWid["estLifeLeft"] = 0
        }
        
        
        childUpdates = ["/assets/\(newKey)" : assetDictUpdatedWid,
                        "/types/\(assetDictUpdatedWid[ASSET_TYPE_UID]!)/assets/\(newKey)": newKey,
                        "/users/\(assetDictUpdatedWid[ASSET_OWNER_UID]!)/assets/\(newKey)" : newKey]
        FB_REF.updateChildValues(childUpdates)
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
    
    func endOfLifeCalculation(assetEndOfLifeDate: String) -> Int {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        
        if let assetEndOfLifeNSDate = dateFormatter.dateFromString(assetEndOfLifeDate) {
            
            let timeToDeath = assetEndOfLifeNSDate.timeIntervalSinceDate(NSDate())
            let monthsToDeath = Int(Double(timeToDeath/3600/24/30))
            return monthsToDeath
            
        } else {
            print("problem with converting date to compare")
            return 0
        }
    }
    
    func createEmailFIRUser(user: FIRUser) {
        
        let userToCreate: Dictionary<String, AnyObject> = ["provider" : "email",
                                                           "email" : user.email!,
                                                           "name": user.email!]
        
        self.FB_USERS_REF.child(user.uid).updateChildValues(userToCreate)
    }
    
    func createFirUserFromOwnerManager(userDict: Dictionary<String, AnyObject>) {
        self.FB_USERS_REF.childByAutoId().setValue(userDict)
    }
}

