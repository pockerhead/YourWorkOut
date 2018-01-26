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

    @IBOutlet weak var nameButton: MyMDCRaisedButton!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var addButton: MyMDCFloatingButton!
    @IBOutlet weak var portionStepper: ValueStepper!
    @IBOutlet weak var carbonhydratesLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    var proteins : Float = 0.0
    var carbonhydrates : Float = 0.0
    var fats : Float = 0.0
    var calories : Float = 0.0

    var proteinsOnChange : Float = 0.0
    var carbonhydratesOnChange : Float = 0.0
    var fatsOnChange : Float = 0.0
    var caloriesOnChange : Float = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.backgroundColor = FoodColors.primaryColor
        self.contentView.backgroundColor = FoodColors.primaryColor
        self.portionStepper.backgroundColor = FoodColors.secondaryColor
        self.portionStepper.tintColor = UIColor.white
        self.backGroundView.isHidden = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func onValueChanged(_ sender: ValueStepper) {
        let coef = Float(self.portionStepper.value / 100)
        self.proteinsOnChange = self.proteins * coef
        self.fatsOnChange = self.fats * coef
        self.carbonhydratesOnChange = self.carbonhydrates * coef
        self.caloriesOnChange = self.calories * coef
        self.proteinsLabel.text = String(format:"%.1f", self.proteinsOnChange)
        self.fatsLabel.text = String(format:"%.1f", self.fatsOnChange)
        self.carbonhydratesLabel.text = String(format:"%.1f", self.carbonhydratesOnChange)
        self.caloriesLabel.text = String(format:"%.1f", self.caloriesOnChange)
        
        
    }
    @IBAction func addFood(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func nameButtonPressed(_ sender: Any) {
//        self.backGroundView.isHidden = !self.backGroundView.isHidden
//
//    }
    func initWithFood(protein:Float?,fat:Float?,carbonhydrates:Float?, calories:Float?,name:String){
        
        self.nameButton.setTitle(name, for: .normal)
        self.nameButton.sizeToFit()
        
        self.proteins = protein!
        self.proteinsOnChange = protein!
        self.carbonhydrates = carbonhydrates!
        self.carbonhydratesOnChange = carbonhydrates!
        
        self.fats = fat!
        self.fatsOnChange = fat!

        self.calories = calories!
        self.caloriesOnChange = calories!

        self.proteinsLabel.text = String(format:"%.1f", self.proteins)
        self.fatsLabel.text = String(format:"%.1f", self.fats)
        self.carbonhydratesLabel.text = String(format:"%.1f", self.carbonhydrates)
        self.caloriesLabel.text = String(format:"%.1f", self.calories)
        self.portionStepper.valueLabel.text = "100"
        self.portionStepper.value = 100
        self.selectionStyle = .none
    }
}
