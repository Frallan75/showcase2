//
//  Constants.swift
//  showcase2
//
//  Created by Francisco Claret on 01/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import UIKit

//COLORS
let SHADOW_COLOR = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5)
let BORDER_COLOR = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.1)

//KEYS
let KEY_UID = "uid"

//DATES
public let DATE_FORMAT = "dd-MM-yyyy"

//SEGUES
let SEGUE_LOGGED_IN = "loggedIn"
let ASSET_DETAIL_VC = "assetDetialVC"
let ASSET_MANAGEMENT_VC = "assetManagementVC"
let OWNERS_VC_SEGUE = "ownersVCsegue"
let TYPES_VC_SEGUE = "typesVCsegue"
let MANAGE_TYPE_VC_SEGUE = "manageTypes"

//POSITIONS
let NAV_BAR_HEIGHT: CGFloat = 65

//ASSET COMPONENTS
let ASSET_TYPE_UID = "typeUid"
let ASSET_OWNER_UID = "ownerUid"
let ASSET_MAKE = "make"
let ASSET_MODEL = "model"
let ASSET_PUR_DATE = "purchaseDate"
let ASSET_END_DATE = "endDate"
let ASSET_IMG_URL = "assetImgUrl"
let ASSET_EST_TIME_END = "estLifeLeft"
let ASSET_IMG = "assetUIImage"

//TYPE COMPONENTS
let TYPE_NAME = "name"
let TYPE_ASSETS = "assetsInType"

//IMAGE SIZE
let MAX_ASSET_IMG_SIZE: CGFloat = 250000

//CACHE
public let IMAGE_CACHE = NSCache()
