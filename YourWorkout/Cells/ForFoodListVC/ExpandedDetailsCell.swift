//
//  ExpandedDetailsCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 09.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class ExpandedDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var grammsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbonhydratesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        super.awakeFromNib()
        
        self.backView.layer.shadowColor = UIColor.black.cgColor
        self.backView.layer.shadowOpacity = 1
        self.backView.layer.shadowOffset = CGSize(width: 1, height:  1)
        self.backView.layer.shadowRadius = 1
        self.backgroundColor = FoodColors.primaryColor
        self.contentView.sendSubview(toBack: self.backView)
    }
    
   
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""

        self.caloriesLabel.text = "1000"
        self.carbonhydratesLabel.text = "1000"
        self.fatsLabel.text = "1000"
        self.proteinsLabel.text = "1000"
        self.grammsLabel.text = "1000"

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
