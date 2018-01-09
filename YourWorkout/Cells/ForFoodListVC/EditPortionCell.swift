//
//  EditPortionCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 09.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import ValueStepper

class EditPortionCell: UITableViewCell {

    @IBOutlet weak var portionStepper: ValueStepper!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
portionStepper.valueLabel.text = "100"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func portionValueCahnged(_ sender: ValueStepper) {
        print("value is \(portionStepper.value)")
    }
    
}
