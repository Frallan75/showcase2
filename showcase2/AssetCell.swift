//
//  AssetCell.swift
//  showcase2
//
//  Created by Francisco Claret on 02/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class AssetCell: UITableViewCell {

    
    @IBOutlet weak var assetImgView: UIView!
    @IBOutlet weak var assetTypeLbl: UILabel!
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetLifeLeftLbl: UILabel!
    @IBOutlet weak var assetStatusView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        assetImgView.layer.cornerRadius = assetImgView.frame.width / 2
        assetImgView.clipsToBounds = true
        assetImgView.clipsToBounds = true
    }

    

}
