//
//  IBAOverviewTableViewCell.swift
//  IBA
//
//  Created by Danika Suggs on 1/4/16.
//  Copyright © 2016 Danika Suggs. All rights reserved.
//

import UIKit

class IBAOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var visitByLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsZero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbnailView.layer.cornerRadius = thumbnailView.frame.height/2
        thumbnailView.layer.masksToBounds = true
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        let thumbnailColor = thumbnailView.backgroundColor
        
        super.setSelected(selected, animated: animated)
    
        colorView.backgroundColor = color
        thumbnailView.backgroundColor = thumbnailColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        let thumbnailColor = thumbnailView.backgroundColor
        
        super.setHighlighted(highlighted, animated: animated)
        
        colorView.backgroundColor = color
        thumbnailView.backgroundColor = thumbnailColor
    }

}
