//
//  IBAContactsSetupViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/1/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class IBAContactsSetupViewController: UIViewController, CNContactPickerDelegate {
    
    var contactStore = CNContactStore()
    
    @IBOutlet weak var addContactsButton: IBARoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                } else if authorizationStatus == CNAuthorizationStatus.Denied {
                    NSLog("no access to contacts :(")
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
    // MARK: button behavior
    
    @IBAction func addContactsButtonTapped(sender: AnyObject) {
        self.requestAccess { (accessGranted) -> Void in
            if accessGranted {
                let contactPickerViewController = CNContactPickerViewController()
                
                contactPickerViewController.delegate = self
                
                self.presentViewController(contactPickerViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: CNContactPickerDelegate

    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        NSLog("selected contacts")
        for contact in contacts {
            if let storedContact = IBAContact(name: contact.givenName) {
                AppDelegate.getAppDelegate().appData.storedContacts.append(storedContact)
            }
        }
        
        self.performSegueWithIdentifier("moveToContactIntervalSetup", sender: self)
    }
}

