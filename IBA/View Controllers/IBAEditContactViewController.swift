//
//  IBAEditContactViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/11/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit
import ImageIO

class IBAEditContactViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var changeButton: IBARoundedButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastContactedTextField: UITextField!
    @IBOutlet weak var contactIntervalPickerView: UIPickerView!
    
    var optionalIndex: Int?
    var contactToEdit: IBAContact?
    
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
        profileImageView.layer.masksToBounds = true
        
        if let index = self.optionalIndex {
            contactToEdit = AppDelegate.getAppDelegate().appData.storedContacts[index]
        }
        
        //fill current data
        navItem.title = "Edit \(contactToEdit!.name)"
        
        if let profileImage = contactToEdit?.optionalProfileImage {
            profileImageView.image = profileImage
        }
        
        nameTextField.text = contactToEdit!.name
        if let dateLastContacted = contactToEdit!.dateLastContacted {
            lastContactedTextField.text = dateFormatter.stringFromDate(dateLastContacted)
            lastContactedDatePicker.date = dateLastContacted
        }
        
        if let timePeriodQuantityIndex = contactToEdit!.timePeriodQuantityIndex {
            contactIntervalPickerView.selectRow(timePeriodQuantityIndex, inComponent: 0, animated: false)
        }
        if let timePeriodTypeIndex = contactToEdit!.timePeriodTypeIndex {
            contactIntervalPickerView.selectRow(timePeriodTypeIndex, inComponent: 1, animated: false)
        }
        
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
        
        //disable buttons if need be
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            changeButton.enabled = false
        }
        
    }
    
    func dismissLastContactedDatePicker() {
        updateTextField()
        self.view.endEditing(true)
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
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        self.profileImageView.image = nil
        if let imageData = UIImagePNGRepresentation(image) {
            //create thumbnail
            if image.size.height > image.size.width {
                let thumbnail = UIImage(data: imageData, scale: 100/image.size.height)
                self.profileImageView.image = thumbnail
            } else {
                let thumbnail = UIImage(data: imageData, scale: 100/image.size.width)
                self.profileImageView.image = thumbnail
            }
        }
        self.spinner.stopAnimating()
    }
    
    
    @IBAction func changeProfileImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true) {
            self.spinner.startAnimating()
        }
    }
    
    @IBAction func removeProfileImage(sender: AnyObject) {
        profileImageView.image = nil
    }
    
    @IBAction func saveContact(sender: AnyObject) {
        contactToEdit?.optionalProfileImage = profileImageView.image
        
        if let newName = nameTextField.text {
            if !newName.isEmpty {
                contactToEdit?.name = newName
            }
        }
        if let newDateLastContacted = lastContactedTextField.text {
            if !newDateLastContacted.isEmpty {
                contactToEdit?.dateLastContacted = lastContactedDatePicker.date
            }
        }
        
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
        
        contactToEdit?.desiredContactInterval = timeInterval
        contactToEdit?.timePeriodQuantityIndex = self.contactIntervalPickerView.selectedRowInComponent(0)
        contactToEdit?.timePeriodTypeIndex = self.contactIntervalPickerView.selectedRowInComponent(1)
        
        self.performSegueWithIdentifier("returnToOverviewFromEdit", sender: self)
    }
    
    @IBAction func deleteContact(sender: AnyObject) {
        let alertController = UIAlertController(title: "Delete \(contactToEdit!.name)", message: "Are you sure you want to remove \(contactToEdit!.name) from your list?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let confirm = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            if let index = self.optionalIndex {
                AppDelegate.getAppDelegate().appData.storedContacts.removeAtIndex(index)
            }
            self.performSegueWithIdentifier("returnToOverviewFromEdit", sender: self)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
