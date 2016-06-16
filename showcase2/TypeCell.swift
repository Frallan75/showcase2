//
//  TypeCell.swift
//  showcase2
//
//  Created by Francisco Claret on 03/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Foundation

class TypeCell: UITableViewCell {

    @IBOutlet weak var typeNameLbl: UILabel!
    
    func configureTypeCell(type: Type) {
        
        typeNameLbl.text = type.name.capitalizedString
    }
}
