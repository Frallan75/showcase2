//
//  MaterialButton.swift
//  showcase2
//
//  Created by Francisco Claret on 01/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import UIKit

class MaterialButton: UIButton {

        override func awakeFromNib() {
            
            layer.cornerRadius = 2.0
            layer.shadowColor = SHADOW_COLOR.CGColor
            layer.shadowOpacity = 0.9
            layer.shadowRadius = 4.0
            layer.shadowOffset = CGSizeMake(0.0, 2.0)
        }
}
