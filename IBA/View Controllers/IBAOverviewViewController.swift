//
//  IBAOverviewViewController.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit
import DynamicColor

class IBAOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let unknownDate = "???"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "OverviewTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! IBAOverviewTableViewCell
        
        let contact = AppDelegate.getAppDelegate().appData.storedContacts[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.lastSeenLabel.text = "last seen: \(contact.dateLastContacted ?? unknownDate)"
        
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
        let markAsSeen = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Seen") { (rowAction, indexPath) -> Void in
            self.showSetDateAlertForContactAtIndexPath(indexPath)
        }
        markAsSeen.backgroundColor = UIColor(hexString:"83D9EA")
        
        return [markAsSeen]
    }
    
    // MARK: actions
    
    func showSetDateAlertForContactAtIndexPath(indexPath: NSIndexPath) {
        //show alert
        NSLog("marked as seen")
    }
    
}
