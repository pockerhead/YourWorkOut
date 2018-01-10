//
//  ExpandedDetailsCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 09.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class ExpandedDetailsCell: UITableViewCell {

    @IBOutlet weak var caloriesLabel: UILabel!
    @IBAction func foodInfoButtonPressed(_ sender: UIButton) {
    }
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
    
    func initWithFood(calories:Float?){
        self.caloriesLabel.text = String(describing: calories!)
       
        self.selectionStyle = .none
    }
    
}
