//
//  AssetCell.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Alamofire
import AlamofireImage

class AssetCell: UITableViewCell {
    
    @IBOutlet weak var assetImgView: UIImageView!
    @IBOutlet weak var assetTypeNameLbl: UILabel!
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetLifeLeftLbl: UILabel!
    @IBOutlet weak var assetStatusView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    let imageCache = NSCache()
    var downloadImageTask: FIRStorageDownloadTask?
    func configureAsset(asset: Asset, img: UIImage?) {
        
        assetNameLbl.text = asset.model.capitalizedString
        
        DataService.ds.FB_TYPES_REF.child(asset.typeUid).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { snapshot in
            
            if let typeDict = snapshot.value as? Dictionary<String, AnyObject> {

                self.assetTypeNameLbl.text = "\(typeDict["name"]!)".capitalizedString
            }
        })
        
        DataService.ds.FB_USERS_REF.child(asset.ownerUid).observeSingleEventOfType(FIRDataEventType.Value, withBlock:  { snapshot in
            
            if let ownerDict = snapshot.value as? Dictionary<String, AnyObject> {
                
                self.ownerNameLbl.text = ("\(ownerDict["name"]!)").capitalizedString
            }
        })

        if asset.assetImgUrl != nil {
            if img != nil {
                self.assetImgView.image = img
            } else {
                
                downloadImageTask = FB_STORAGE_REF.child("images/\(asset.assetUid)/assetImage.png").dataWithMaxSize(1*1024*1024, completion: { data, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        
                    } else if let data = data {
                        if let image = UIImage(data: data) {
                            self.assetImgView.image = image
                            IMAGE_CACHE.setObject(image, forKey: asset.assetUid)
                        }
                    }
                })
            }
        } else {
            self.assetImgView.hidden = true
        }
        
        if let lifeLeftInt = asset.estLifeLeft {

            assetLifeLeftLbl.text = "\(asset.estLifeLeft)"
            
            switch lifeLeftInt {
            case 0...4:
                assetStatusView.backgroundColor = UIColor.redColor()
            case 4...10:
                assetStatusView.backgroundColor = UIColor.orangeColor()
            case 11...20:
                assetStatusView.backgroundColor = UIColor.yellowColor()
            case 21...1000:
                assetStatusView.backgroundColor = UIColor.greenColor()
            default:
                assetStatusView.backgroundColor = UIColor.blackColor()
            }
        } else {
            print("problem converting LifeLeft string to Int")
        }
    }
}
