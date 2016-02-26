//
//  IBAAddContactViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/12/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAAddContactViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var lastContactedTextField: UITextField!
    @IBOutlet weak var contactIntervalPickerView: UIPickerView!
    
    let pluralTimePeriods = ["days", "weeks", "months", "years"]
    let singularTimePeriods = ["day", "week", "month", "year"]
    
    let dateFormatter = NSDateFormatter()
    let lastContactedDatePicker = UIDatePicker()
    let lastContactedToolbar = UIToolbar()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set default to 2 weeks
        self.contactIntervalPickerView.selectRow(1, inComponent: 0, animated: false)
        self.contactIntervalPickerView.selectRow(1, inComponent: 1, animated: false)
        
        //set up date picker
        lastContactedDatePicker.backgroundColor = UIColor.whiteColor()
        lastContactedDatePicker.datePickerMode = UIDatePickerMode.Date
        lastContactedDatePicker.addTarget(self, action: Selector("updateTextField"), forControlEvents: UIControlEvents.ValueChanged)
        lastContactedTextField.inputView = lastContactedDatePicker
        
        //set up toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("dismissLastContactedDatePicker"))
        doneButton.tintColor = UIColor(hexString: "83D9EA")
        lastContactedToolbar.sizeToFit()
        lastContactedToolbar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), doneButton], animated: false)
        lastContactedTextField.inputAccessoryView = lastContactedToolbar
    }
    
    func dismissLastContactedDatePicker() {
        updateTextField()
        self.view.endEditing(true)
    }
    
    func updateTextField() {
        self.lastContactedTextField?.text = self.dateFormatter.stringFromDate(self.lastContactedDatePicker.date)
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 30
        case 1:
            return pluralTimePeriods.count
        default:
            return 0
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let font = UIFont(name: "SFUIText-Light", size: 20) {
            switch component {
            case 0:
                return NSAttributedString(string: String(row+1), attributes:[NSFontAttributeName:font])
            case 1:
                if contactIntervalPickerView.selectedRowInComponent(0) == 0 {
                    return NSAttributedString(string: singularTimePeriods[row], attributes:[NSFontAttributeName:font])
                } else {
                    return NSAttributedString(string: pluralTimePeriods[row], attributes:[NSFontAttributeName:font])
                }
            default:
                return NSAttributedString()
            }
        } else {
            switch component {
            case 0:
                return NSAttributedString(string: String(row+1))
            case 1:
                if contactIntervalPickerView.selectedRowInComponent(0) == 0 {
                    return NSAttributedString(string: singularTimePeriods[row])
                } else {
                    return NSAttributedString(string: pluralTimePeriods[row])
                }
            default:
                return NSAttributedString()
            }
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1) //make sure we're using the correct strings
        }
    }

}
