//
//  ExpandedFoodCell.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class ExpandedFoodCell: UITableViewCell {

    @IBOutlet weak var carbonhydratesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initWithFood(protein:Float?,fat:Float?,carbonhydrates:Float?){
        self.proteinsLabel.text = String(describing: protein!)
        self.fatsLabel.text = String(describing: fat!)
        self.carbonhydratesLabel.text = String(describing: carbonhydrates!)
        self.selectionStyle = .none
    }
}
