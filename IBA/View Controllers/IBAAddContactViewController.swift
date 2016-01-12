//
//  IBAAddContactViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/12/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAAddContactViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    
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

}