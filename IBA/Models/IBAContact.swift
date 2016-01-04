//
//  IBAContact.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import Foundation

class IBAContact {
    // MARK: properties
    
    var name: String
    var desiredContactFrequency: NSTimeInterval?
    var dateLastContacted: NSDate?
    
    // MARK: initialization
    
    init?(name: String) {
        self.name = name
        
        if name.isEmpty {
            return nil
        }
    }
    
//    init?(name: String, desiredContactFrequency: NSTimeInterval) {
//        self.name = name
//        self.desiredContactFrequency = desiredContactFrequency
//        
//        let today = NSDate()
//        
//        self.dateLastContacted = NSDate(timeInterval: -self.desiredContactFrequency, sinceDate: today)
//        
//        if name.isEmpty || desiredContactFrequency <= 0 {
//            return nil
//        }
//    }
    
}