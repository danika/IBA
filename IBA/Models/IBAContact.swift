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
    var dateLastContacted: NSDate?
    var desiredContactInterval: NSDateComponents?
    
    // MARK: initialization
    
    init?(name: String) {
        self.name = name
        
        if name.isEmpty {
            return nil
        }
    }
}