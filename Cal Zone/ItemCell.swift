//
//  ItemCell.swift
//  Homeowner
//
//  Created by teacher on 10/27/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

//ItemCell is a custom cell
class ItemCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    //function to set fonts of labels
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        distanceLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        addressLabel.font = captionFont
    }

}
