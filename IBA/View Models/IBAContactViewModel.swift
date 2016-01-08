//
//  IBAContactViewModel.swift
//  IBA
//
//  Created by Danika Suggs on 1/8/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAContactViewModel {
    
    // MARK: properties
    
    var color: UIColor
    
    // MARK: initialization
    
    init(contact: IBAContact) {
        color = UIColor(hexString: "c0392b")
        
        if let dateLastContacted = contact.dateLastContacted {
            let calendar = NSCalendar.currentCalendar()
            let today = NSDate()
            
            //while ideal contact date is before today, darken color
            var idealContactDate = calendar.dateByAddingComponents(contact.desiredContactInterval!, toDate: dateLastContacted, options: NSCalendarOptions.WrapComponents)
            
            while idealContactDate?.earlierDate(today) == today {
                color = color.darkerColor()
                
                idealContactDate = calendar.dateByAddingComponents(contact.desiredContactInterval!, toDate: idealContactDate!, options: NSCalendarOptions.WrapComponents)
            }
        }
        
        
    }
}
