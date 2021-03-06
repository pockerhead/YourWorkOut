//
//  FoodItemCell.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class FoodItemCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var deleteButton: MyMDCRaisedButton!
    @IBOutlet weak var button: MyMDCRaisedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        button.didTouchUpInside = nil
        deleteButton.didTouchUpInside = nil
        self.button.setBackgroundColor(NewWaveColors.violetColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
