//
//  IBAEditContactViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/11/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAEditContactViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastContactedTextField: UITextField!
    @IBOutlet weak var contactIntervalPickerView: UIPickerView!
    
    var optionalIndex: Int?
    var contactToEdit: IBAContact?
    
    let pluralTimePeriods = ["days", "weeks", "months", "years"]
    let singularTimePeriods = ["day", "week", "month", "year"]
    
    let dateFormatter = NSDateFormatter()
    let lastContactedDatePicker = UIDatePicker()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        lastContactedDatePicker.backgroundColor = UIColor.whiteColor()
        lastContactedDatePicker.datePickerMode = UIDatePickerMode.Date
        lastContactedDatePicker.addTarget(self, action: "updateTextField", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = self.optionalIndex {
            contactToEdit = AppDelegate.getAppDelegate().appData.storedContacts[index]
        }
        
        navItem.title = "Edit \(contactToEdit!.name)"
        
        if let imageData = contactToEdit!.optionalImageData {
            profileImageView.image = UIImage(data: imageData)
        }
        
        nameTextField.text = contactToEdit!.name
        if let dateLastContacted = contactToEdit!.dateLastContacted {
            lastContactedTextField.text = dateFormatter.stringFromDate(dateLastContacted)
            lastContactedDatePicker.date = dateLastContacted
        }
        
        lastContactedTextField.inputView = lastContactedDatePicker
    }
    
    func updateTextField() {
        self.lastContactedTextField?.text = self.dateFormatter.stringFromDate(self.lastContactedDatePicker.date)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
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
    
    // MARK: segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveContact" {
            if let newName = nameTextField.text {
                contactToEdit?.name = newName
            }
            
            if let newDateLastContacted = lastContactedTextField.text {
                if !newDateLastContacted.isEmpty {
                    contactToEdit?.dateLastContacted = lastContactedDatePicker.date
                }
            }
        } else if segue.identifier == "deleteContact" {
            
            //trigger some sort of confirmation alert
            
            if let index = self.optionalIndex {
                AppDelegate.getAppDelegate().appData.storedContacts.removeAtIndex(index)
            }
        }
    }

}
