//
//  TodayHeaderCell.swift
//  YourWorkout
//
//  Created by Artem Balashow on 17.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class TodayHeaderCell: UITableViewHeaderFooterView {

    
    @IBOutlet weak var deleteButton: MyMDCRaisedButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var backgroundViewForHeader: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteButton.backgroundColor = NewWaveColors.orangeColor
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.sizeToFit()
        deleteButton.layer.cornerRadius = 8
        self.backgroundViewForHeader.backgroundColor = UIColor.clear
        self.backgroundViewForHeader.blurView.setup(style: .dark, alpha: 0.6).enable()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.didTouchUpInside = nil
    }

    
}
