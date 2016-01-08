//
//  IBAContactIntervalSetupViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAContactIntervalSetupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var contactIntervalPickerView: UIPickerView!
    
    let pluralTimePeriods = ["days", "weeks", "months", "years"]
    let singularTimePeriods = ["day", "week", "month", "year"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set default to 2 weeks
        self.contactIntervalPickerView.selectRow(1, inComponent: 0, animated: false)
        self.contactIntervalPickerView.selectRow(1, inComponent: 1, animated: false)
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
    
    // MARK: button behavior
    
    @IBAction func setForEveryoneButtonTapped(sender: AnyObject) {
        let number = self.contactIntervalPickerView.selectedRowInComponent(0)+1
        let type = self.contactIntervalPickerView.selectedRowInComponent(1)
        let timeInterval = NSDateComponents()
        
        switch type {
        case 0: //days
            timeInterval.day = number
            
        case 1: //weeks
            timeInterval.day = number*7
            
        case 2: //months
            timeInterval.month = number
            
        case 3: //years
            timeInterval.year = number
            
        default:
            break
        }
        
        for storedContact in AppDelegate.getAppDelegate().appData.storedContacts {
            storedContact.desiredContactInterval = timeInterval
        }
        
        self.performSegueWithIdentifier("moveToOverview", sender: self)
    }
    
}
