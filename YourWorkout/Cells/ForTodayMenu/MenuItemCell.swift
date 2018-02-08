//
//  MenuItemCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 07.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstDetailLabel: UILabel!
    @IBOutlet weak var secondDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
