//
//  IBAReplaceSegue.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAReplaceSegue: UIStoryboardSegue {
        
    override func perform() {
        sourceViewController.navigationController?.setViewControllers([destinationViewController], animated: true)
    }
}
