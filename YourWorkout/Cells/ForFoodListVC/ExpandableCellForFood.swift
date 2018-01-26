//
//  EditPortionCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 09.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import ExpandableCell


class ExpandableCellForFood: ExpandableCell {

    @IBOutlet weak var foodNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        portionStepper.valueLabel.text = portionStepper.value > 100 ? String(describing: portionStepper.value) : "100"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
