//
//  TypeCell.swift
//  showcase2
//
//  Created by Francisco Claret on 03/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class TypeCell: UITableViewCell {

    @IBOutlet weak var typeNameLbl: UILabel!
    
//    var typeName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func configureTypeCell(type: Type) {
        
        print("in cell configure")
        print(type.name)
        typeNameLbl.text = type.name

    
    }
}
