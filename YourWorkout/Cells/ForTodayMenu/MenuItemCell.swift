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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.gradientPressed(_:)))
        
//        self.gradientView.addGestureRecognizer(tap)
        
        self.gradientView.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func gradientPressed(_ sender : UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            let intPointX = self.gradientView.startPointX
            let intPointY = self.gradientView.startPointY
            self.gradientView.startPointX = self.gradientView.endPointX
            self.gradientView.startPointY = self.gradientView.endPointY
            self.gradientView.endPointX = intPointX
            self.gradientView.endPointY = intPointY
        }
            print("pressed")
    }

    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
}
