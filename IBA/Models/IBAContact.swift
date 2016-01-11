//
//  IBAContact.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import Contacts

class IBAContact {
    
    // MARK: properties
    
    var name: String
    var optionalImageData: NSData?
    var dateLastContacted: NSDate?
    var desiredContactInterval: NSDateComponents?
    
    // MARK: initialization
    
    init?(contact: CNContact) {
        if !contact.nickname.isEmpty {
            self.name = contact.nickname
        } else {
            self.name = "\(contact.givenName) \(contact.familyName)"
        }
        
        self.optionalImageData = contact.thumbnailImageData
        
        if name.isEmpty {
            return nil
        }
    }
}