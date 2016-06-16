//
//  AssetAddVC.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class AssetAddVC: UIViewController {
    
    @IBOutlet weak var saveBtn:             UIButton!
    @IBOutlet weak var makeTF:              UITextField!
    @IBOutlet weak var modelTF:             UITextField!
    @IBOutlet weak var purchaseDateLbl:     UILabel!
    @IBOutlet weak var endDateLbl:          UILabel!
    @IBOutlet weak var typeLbl:             UILabel!
    @IBOutlet weak var ownerLabel:          UILabel!
    @IBOutlet weak var makeTFDoneBtn:       MaterialButton!
    @IBOutlet weak var modelTFDoneBtn:      MaterialButton!
    @IBOutlet var displayDatePickerView:    DatePickerViewHolderView!
    @IBOutlet weak var imagePickerView:     UIImageView!
    
    var assetTypeName:  String!
    var assetOwnerName: String!
    var chosenTypeUid:  String!
    var chosenOwnerUid: String!
    var purDate:        String!
    var endLifeDate:    String!
    var asset:          Asset!
    var datePickerTag:  Int!
    var dateFormatter = NSDateFormatter()
    var imagePicker =   UIImagePickerController()
    var imageSelected:  Bool!
    var image:          UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(displayDatePickerView)
        displayDatePickerView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, self.view.frame.height)
        displayDatePickerView.delegate = self
        
        dateFormatter.dateFormat = DATE_FORMAT
        
        imagePicker.delegate = self
        makeTFDoneBtn.hidden = true
        modelTFDoneBtn.hidden = true
        
        makeTF.addTarget(self, action: #selector(AssetAddVC.editing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        modelTF.addTarget(self, action: #selector(AssetAddVC.editing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        
        if asset != nil {
            
            self.saveBtn.setTitle("Update asset!", forState: .Normal)
            self.makeTF.text = asset.make
            self.modelTF.text = asset.model
            self.endDateLbl.text = asset.endDate
            self.purchaseDateLbl.text = asset.purchaseDate
            
            DataService.ds.FB_USERS_REF.child(asset.ownerUid).child("name").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                print(snapshot)
                if let ownerName = snapshot.value as? String {
                    self.ownerLabel.text = ownerName
                    self.assetOwnerName = ownerName
                }
            })
            
            DataService.ds.FB_TYPES_REF.child(asset.typeUid).child("name").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                if let typeName = snapshot.value as? String {
                    self.typeLbl.text = typeName
                    self.assetTypeName = typeName
                }
            })
            
            if let assetImage = IMAGE_CACHE.objectForKey(asset.assetUid) as? UIImage {
                self.image = assetImage
                self.imagePickerView.image = assetImage
            }
            
            chosenTypeUid = asset.typeUid
            chosenOwnerUid = asset.ownerUid
            purDate = asset.purchaseDate
            endLifeDate = asset.endDate
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        makeTFDoneBtn.hidden = true
        modelTFDoneBtn.hidden = true
    }
    
    @IBAction func pickTypeOwnerBtnPressed(sender: UIButton) {
        performSegueWithIdentifier(OWNERS_VC_SEGUE, sender: nil)
    }
    
    @IBAction func pickTypeBtnPressed(senden: UIButton) {
        performSegueWithIdentifier(TYPES_VC_SEGUE, sender: nil)
    }
    
    @IBAction func selectDateBtnPressed(sender: UIButton) {
        
        if sender.tag == 0 {
            datePickerTag = 0
        } else if sender.tag == 1 {
            datePickerTag = 1
        }
        
        displayBottomView(displayDatePickerView)
    }
    
    @IBAction func tfDoneBtnPressed(sender: UIButton) {
        
        if sender.tag == 0 {
            makeTF.endEditing(true)
            endEditing(makeTF)
        } else if sender.tag == 1 {
            modelTF.endEditing(true)
            endEditing(modelTF)
        }
    }
    
    @IBAction func selectImage(sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        let imageAlert = UIAlertController(title: "Pick image", message: nil, preferredStyle: .ActionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                self.imagePicker.sourceType = .Camera
                self .presentViewController(self.imagePicker, animated: true, completion: nil)
            } else {
                self.displayAlert("Warning!", body: "You don't have a camera!")
            }
        })
        
        let photoAlbumAction = UIAlertAction(title: "Album", style: .Default, handler: { (action) in
            self.imagePicker.sourceType = .PhotoLibrary
            self .presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelImageAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        imageAlert.addAction(cameraOption)
        imageAlert.addAction(photoAlbumAction)
        imageAlert.addAction(cancelImageAlertAction)
        
        presentViewController(imageAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton!) {
        
        if let make = makeTF.text where make != "",
            let model = modelTF.text where model != "",
            let endLifeDate = endLifeDate where endLifeDate != "",
            let purDate = purDate where purDate != "",
            let image = self.image,
            let chosenOwnerUid = chosenOwnerUid where chosenOwnerUid != "",
            let chosenTypeUid = chosenTypeUid where chosenTypeUid != "",
            let assetOwnerName = self.ownerLabel.text where assetOwnerName != "",
            let assetTypeName = self.typeLbl.text where assetTypeName != "" {
            
            let assetDict = [ASSET_TYPE_UID : chosenTypeUid,
                             ASSET_OWNER_UID : chosenOwnerUid,
                             ASSET_MAKE : make.lowercaseString,
                             ASSET_MODEL : model.lowercaseString,
                             ASSET_END_DATE : endLifeDate,
                             ASSET_PUR_DATE : purDate,
                             ASSET_OWNER_NAME: assetOwnerName.lowercaseString,
                             ASSET_TYPE_NAME: assetTypeName.lowercaseString]
            
            if self.asset != nil {
                print("with old asset")
                DataService.ds.createNewAsset(assetDict, oldAsset: self.asset, image: image)
                
                let alert = UIAlertController(title: "Success!", message: "Your asset was updated successfully!", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alert.addAction(okAction)
                presentViewController(alert, animated: true, completion: nil)
                
            } else {
                DataService.ds.createNewAsset(assetDict, oldAsset: nil, image: image)
                self.clearForms()
            }
        } else {
            self.displayAlert("Alert!", body: "Please make sure all fields are correctly filled, please try again!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == OWNERS_VC_SEGUE {
            let destVC = segue.destinationViewController as! OwnersVC
            destVC.delegate = self
        } else if segue.identifier == TYPES_VC_SEGUE {
            let destVC = segue.destinationViewController as! TypesVC
            destVC.delegate = self
        }
    }
    
    func editing(textField: UITextField) {
        
        UIView.animateWithDuration(NSTimeInterval.abs(0.5)) {
            
            if textField == self.makeTF {
                self.makeTFDoneBtn.hidden = false
                self.makeTFDoneBtn.userInteractionEnabled = true
            } else if textField == self.modelTF {
                self.modelTFDoneBtn.hidden = false
                self.modelTFDoneBtn.userInteractionEnabled = true
            }
        }
    }
    
    func endEditing(textField: UITextField) {
        UIView.animateWithDuration(NSTimeInterval.abs(0.5)) {
            
            if textField == self.makeTF {
                
                self.makeTFDoneBtn.hidden = true
                self.makeTFDoneBtn.userInteractionEnabled = false
            } else if textField == self.modelTF {
                self.modelTFDoneBtn.hidden = true
                self.modelTFDoneBtn.userInteractionEnabled = false
            }
        }
    }
    
    func displayBottomView(viewToDisplay: UIView) {
        viewToDisplay.hidden = false
        UIView.animateWithDuration(NSTimeInterval.abs(0.7)) {
            super.navigationController?.navigationBar.layer.zPosition =  -1
            viewToDisplay.frame = CGRectMake(0, self.view.frame.height - viewToDisplay.frame.height, self.view.frame.width, viewToDisplay.frame.height)
        }
    }
    
    func dismissBottomView(viewToDismiss: UIView) {
        super.navigationController?.navigationBar.layer.zPosition = 65
        UIView.animateWithDuration(NSTimeInterval.abs(0.6), animations: {
            viewToDismiss.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, viewToDismiss.frame.height)
        }) { (true) in
            viewToDismiss.hidden = true
        }
    }
    
    func clearForms() {
        
        makeTF.text = ""
        modelTF.text = ""
        purchaseDateLbl.text = ""
        endDateLbl.text = ""
    }
    
    func displayAlert(title: String, body: String) {
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension AssetAddVC: DatePickerDelegate {
    
    func pickedDate(date: NSDate) {
        
        if datePickerTag == 0 {
            self.purDate = self.dateFormatter.stringFromDate(date)
            purchaseDateLbl.text = self.purDate
            
        } else if datePickerTag == 1 {
            endLifeDate = self.dateFormatter.stringFromDate(date)
            endDateLbl.text = self.endLifeDate
        }
    }
    
    func dismissDatePicker() {
        dismissBottomView(displayDatePickerView)
    }
}

extension AssetAddVC: PickOwnerProtocol, PickedTypeProtocol {
    
    func chosenOwmer(chosenOwner: Owner) {
        
        if let chosenOwnerName = chosenOwner.name {
            self.ownerLabel.text = chosenOwnerName
        }
        if let chosenOwnerUid = chosenOwner.ownerUid {
            self.chosenOwnerUid = chosenOwnerUid
        }
    }
    
    func chosenType(type: Type) {
        
        if let chosenTypeName = type.name {
            self.typeLbl.text = chosenTypeName
        }
        if let chosenTypeUid = type.typeUid {
            self.chosenTypeUid = chosenTypeUid
        }
    }
}

extension AssetAddVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.image = image
        self.imagePickerView.image = image
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
}
