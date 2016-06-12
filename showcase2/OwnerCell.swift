//
//  OwnerCell.swift
//  showcase2
//
//  Created by Francisco Claret on 06/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class OwnerCell: UITableViewCell {
    
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var ownerEmailLbl: UILabel!
    
    var ownerName: String!
    var ownerEmail: String!
    
    func configureOwnerCell(owner: Owner) {
        ownerNameLbl.text = owner.name
        ownerEmailLbl.text = owner.email
    }
}
