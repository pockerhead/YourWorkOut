//
//  SearchExCell.swift
//  YourWorkout
//
//  Created by Артём Балашов on 25.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class SearchExCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addButton: MyMDCFloatingButton!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.addButton.setBackgroundColor(NewWaveColors.blueColor)
        // Configure the view for the selected state
    }
    func configureCell(with name:String?, detail:String?){
        if let name = name{
           self.nameLabel.text = name
        }
        self.nameLabel.sizeToFit()
        if let detail = detail{
            self.detailLabel.text = detail
        }
        self.detailLabel.sizeToFit()

    }
}
