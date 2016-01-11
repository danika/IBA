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
    
    static let lateColor = UIColor(hexString: "CC2456")
    static let dueColor = UIColor(hexString: "F68100")
    static let goodColor = UIColor(hexString: "7ABF2E")
    
    var thumbnail: UIImage?
    var idealContactDate: NSDate?
    var color = UIColor.clearColor()
    
    // MARK: initialization
    
    init(contact: IBAContact) {
        if let imageData = contact.optionalImageData {
            thumbnail = UIImage(data: imageData)
        }
        
        if let dateLastContacted = contact.dateLastContacted {
            let calendar = NSCalendar.currentCalendar()
            let today = NSDate()

            idealContactDate = calendar.dateByAddingComponents(contact.desiredContactInterval!, toDate: dateLastContacted, options: NSCalendarOptions.WrapComponents)
            
            //visit due when there is 1/3 of the desired contact interval remaining until the ideal contact date
            let dueTime = (dateLastContacted.timeIntervalSinceDate(idealContactDate!))*0.3
            
            if today.timeIntervalSinceDate(idealContactDate!) <= 0 {
                //today is earlier than the ideal contact date
                color = IBAContactViewModel.dueColor
                
                if today.timeIntervalSinceDate(idealContactDate!) < dueTime {
                    //over 2/3 time remaining
                    color = IBAContactViewModel.goodColor
                }
            } else {
                //today is later than the ideal contact date
                color = IBAContactViewModel.lateColor
            }
        }
    }
}
