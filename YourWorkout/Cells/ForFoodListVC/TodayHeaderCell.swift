//
//  TodayHeaderCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 17.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class TodayHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var headerTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = FoodColors.barColor

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = FoodColors.barColor
        
    }

    
}
