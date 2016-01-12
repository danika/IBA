//
//  IBAContact.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import Contacts
import UIKit

class IBAContact {
    
    // MARK: properties
    
    var name: String
    var optionalProfileImage: UIImage?
    var dateLastContacted: NSDate?
    var desiredContactInterval: NSDateComponents?
    
    var timePeriodQuantityIndex: Int?
    var timePeriodTypeIndex: Int?
    
    // MARK: initialization
    
    init?(contact: CNContact) {
        if !contact.nickname.isEmpty {
            self.name = contact.nickname
        } else {
            self.name = "\(contact.givenName) \(contact.familyName)"
        }
        
        if let imageData = contact.thumbnailImageData {
            self.optionalProfileImage = UIImage(data: imageData)
        }
        
        if name.isEmpty {
            return nil
        }
    }
}