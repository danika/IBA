//
//  IBAOverviewViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit
import DynamicColor
import QuartzCore

class IBAOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = NSDateFormatter()
    var lastContactedTextField: UITextField?
    let lastContactedDatePicker = UIDatePicker()
    
    var contactViewModels: [IBAContactViewModel]
    
    required init?(coder aDecoder: NSCoder) {
        contactViewModels = [IBAContactViewModel]()
        
        super.init(coder: aDecoder)

        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        lastContactedDatePicker.backgroundColor = UIColor.whiteColor()
        lastContactedDatePicker.datePickerMode = UIDatePickerMode.Date
        lastContactedDatePicker.addTarget(self, action: "updateTextField", forControlEvents: UIControlEvents.ValueChanged)
        lastContactedDatePicker.maximumDate = NSDate()
        
        for storedContact in AppDelegate.getAppDelegate().appData.storedContacts {
            contactViewModels.append(IBAContactViewModel(contact: storedContact))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //refresh view models
        contactViewModels = [IBAContactViewModel]()
        for storedContact in AppDelegate.getAppDelegate().appData.storedContacts {
            contactViewModels.append(IBAContactViewModel(contact: storedContact))
        }
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "OverviewTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! IBAOverviewTableViewCell
        
        //to do: consolidate these
        let contact = AppDelegate.getAppDelegate().appData.storedContacts[indexPath.row]
        let viewModel = self.contactViewModels[indexPath.row]
        
        cell.thumbnailView.image = contact.optionalProfileImage
        cell.nameLabel.text = contact.name
        cell.colorView.backgroundColor = viewModel.color
        
        if let dateLastContacted = contact.dateLastContacted {
            cell.lastSeenLabel.text = "last seen: \(self.dateFormatter.stringFromDate(dateLastContacted))"
            cell.visitByLabel.text = "visit by: \(self.dateFormatter.stringFromDate(viewModel.idealContactDate!))"
            
        } else {
            cell.lastSeenLabel.text = "last seen: ???"
            cell.visitByLabel.text = ""
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.getAppDelegate().appData.storedContacts.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let markAsSeen = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Seen") { (rowAction, indexPath) -> Void in self.showSetDateAlertForContactAtIndexPath(indexPath) }
        markAsSeen.backgroundColor = UIColor(hexString:"83D9EA")
        
        return [markAsSeen]
    }
    
    // MARK: actions
    
    func showSetDateAlertForContactAtIndexPath(indexPath: NSIndexPath) {
        let tappedContact = AppDelegate.getAppDelegate().appData.storedContacts[indexPath.row]
        
        //show alert
        let alertController = UIAlertController(title: "Last Seen", message: "When was your last visit with \(tappedContact.name)?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            tappedContact.dateLastContacted = self.lastContactedDatePicker.date
            
            AppDelegate.getAppDelegate().appData.storedContacts.removeAtIndex(indexPath.row)
            AppDelegate.getAppDelegate().appData.storedContacts.append(tappedContact)
            
            self.contactViewModels.removeAtIndex(indexPath.row)
            self.contactViewModels.append(IBAContactViewModel(contact: tappedContact))
            
            //find the correct index path for the chosen date
            let lastIndexPath = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.tableView.insertRowsAtIndexPaths([lastIndexPath], withRowAnimation: UITableViewRowAnimation.Right)
            self.tableView.endUpdates()
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.lastContactedTextField = textField
            self.lastContactedTextField?.text = self.dateFormatter.stringFromDate(NSDate())
            self.lastContactedDatePicker.date = NSDate()
            self.lastContactedTextField?.inputView = self.lastContactedDatePicker
            
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateTextField() {
        self.lastContactedTextField?.text = self.dateFormatter.stringFromDate(self.lastContactedDatePicker.date)
    }
    
    // MARK: segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editContact" {
            if let cell = sender as? UITableViewCell {
                let destinationViewController = segue.destinationViewController as! IBAEditContactViewController
                destinationViewController.optionalIndex = tableView.indexPathForCell(cell)?.row
            }
        }
    }
    
    
    @IBAction func returnToOverviewFromEdit(segue:UIStoryboardSegue) {
    }
}
