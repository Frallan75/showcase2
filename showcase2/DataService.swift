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
let FB_STORAGE_REF = FIRStorage.storage().referenceForURL("gs://project-6105936688785280588.appspot.com/")
let imageCache = NSCache()

class DataService {
    
    static let ds = DataService()
    
    let FB_BASE_REF = FB_REF
    let FB_ASSETS_REF = FB_REF.child("assets")
    let FB_USERS_REF = FB_REF.child("users")
    let FB_TYPES_REF = FB_REF.child("types")
    let FB_IMAGES_REF = FB_STORAGE_REF.child("images")
    let imageCache2 = imageCache
    
    func createNewType(typeName: String) {
        let key = FB_TYPES_REF.childByAutoId().key
        let typeDict = ["name" : typeName.lowercaseString]
        FB_TYPES_REF.child(key).updateChildValues(typeDict)
    }
    
    func createNewAsset(assetDict: Dictionary<String, AnyObject>, oldAsset: Asset?, image: UIImage) {
        
        print("\(assetDict[ASSET_OWNER_NAME])")
        
        let newKey: String!
        var assetDictUpdatedWid: Dictionary<NSObject, AnyObject> = [:]
        var childUpdates: Dictionary<NSObject, AnyObject> = [:]
        
        if let oldKey = oldAsset?.assetUid {
            print("213123")
            print(oldKey)
            newKey = oldKey
            
            let childRemoves = ["/types/\(oldAsset!.typeUid)/assets/\(oldKey)",
                                "/users/\(oldAsset!.ownerUid)/assets/\(oldKey)"]
            
            for item in childRemoves {
                FB_REF.child(item).removeValue()
            }
            
        } else {
            
             newKey = FB_ASSETS_REF.childByAutoId().key
        }
        
        let nsdataImg =  UIImagePNGRepresentation(image)
        let imgSize = CGFloat(nsdataImg!.length)
        let imageResizeFactor = MAX_ASSET_IMG_SIZE/imgSize
        let imageToStore = UIImageJPEGRepresentation(image, imageResizeFactor)
    
        IMAGE_CACHE.setObject(image, forKey: newKey)
        
        FB_STORAGE_REF.child("/images/\(newKey)/assetImage.png").putData(imageToStore!, metadata: nil) { metadata, error in
            
            if (error != nil) {
                print("\(error?.localizedDescription)")
            } else {
                let imageUrl = (metadata!.downloadURL()?.path)!
                
                assetDictUpdatedWid = assetDict
                
                if let endDateStr = assetDict["endDate"] as? String {
                    assetDictUpdatedWid["estLifeLeft"] = self.endOfLifeCalculation(endDateStr)
                } else {
                    assetDictUpdatedWid["estLifeLeft"] = 0
                }
                
                assetDictUpdatedWid[ASSET_IMG_URL] = imageUrl
                
                childUpdates = ["/assets/\(newKey)" : assetDictUpdatedWid,
                                "/types/\(assetDictUpdatedWid[ASSET_TYPE_UID]!)/assets/\(newKey)": newKey,
                                "/users/\(assetDictUpdatedWid[ASSET_OWNER_UID]!)/assets/\(newKey)" : newKey]
                
                FB_REF.updateChildValues(childUpdates)
            }
        }
    }
    
//    func fetchImageFromUrl(url: String, completion: (image: UIImage) -> ()) {
//        
//        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//        let dataTask: NSURLSessionDataTask?
//        
//        if let nsUrl = NSURL(string: url) {
//            print(nsUrl)
//            
//            dataTask = defaultSession.dataTaskWithURL(nsUrl) { data, response, error in
//                print("in session")
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//                
//                print("in image")
//                let image = UIImage(data: data!)
//                completion(image: image!)
//            }
//        dataTask!.resume()
//        }
//        
//    }
    
    func fetchImageFromUrl(url: String, completion: (image: UIImage) -> ()) {
        
        let fetchImageTask = Alamofire.request(.GET, url).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error -> Void in
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
    
    func storeAssetImage(image: UIImage, assetUid: String) -> String {
        
    return "no valid url"
    }
}

