//
//  ExpandedFoodCell.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import ValueStepper
class ExpandedFoodCell: UITableViewCell {

    @IBOutlet weak var portionStepper: ValueStepper!
    @IBOutlet weak var carbonhydratesLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    var proteins : Float = 0.0
    var carbonhydrates : Float = 0.0
    var fats : Float = 0.0
    var calories : Float = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func onValueChanged(_ sender: ValueStepper) {
        let coef = Float(self.portionStepper.value / 100)
        self.proteinsLabel.text = String(describing: (self.proteins * coef))
        self.fatsLabel.text = String(describing: (self.fats * coef))
        self.carbonhydratesLabel.text = String(describing: (self.carbonhydrates * coef))
        self.caloriesLabel.text = String(describing: (self.calories * coef))
        
        
    }
    @IBAction func addFood(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initWithFood(protein:Float?,fat:Float?,carbonhydrates:Float?, calories:Float?){
        self.proteins = protein!
        self.carbonhydrates = carbonhydrates!
        self.fats = fat!
        self.calories = calories!
        self.proteinsLabel.text = String(describing: self.proteins)
        self.fatsLabel.text = String(describing: self.fats)
        self.carbonhydratesLabel.text = String(describing: self.carbonhydrates)
        self.caloriesLabel.text = String(describing: self.calories)
        self.portionStepper.valueLabel.text = "100"
        self.portionStepper.value = 100
        self.selectionStyle = .none
    }
}
