//
//  DatePickerViewHolderView.swift
//  showcase2
//
//  Created by Francisco Claret on 05/06/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import Foundation

protocol DatePickerDelegate {
    func pickedDate(date: NSDate)
    func dismissDatePicker()
}


class DatePickerViewHolderView: UIView {
    
    var delegate: DatePickerDelegate?
    var pickedDate: NSDate!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {

        datePicker.datePickerMode = UIDatePickerMode.Date
        
        
        datePicker.addTarget(self, action: #selector(DatePickerViewHolderView.pickerDate(_:)), forControlEvents: .ValueChanged)
    }
    
    
    func pickerDate(sender: UIDatePicker) {

        delegate?.pickedDate(sender.date)

    }

    @IBAction func doneBtnPressed(sender: UIButton) {
       delegate?.dismissDatePicker()
    }
    
}
