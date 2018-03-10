//
//  ApproachCell.swift
//  YourWorkout
//
//  Created by Артём Балашов on 10.03.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class ApproachCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var repeatsTextfield: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    public var repeatsDidChanged : ((Approach) ->())?
    public var weightDidChanged : ((Approach) ->())?
    
    var approach: Approach?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.repeatsTextfield.addTarget(self, action: #selector(repeatsTextFieldChanged), for: .editingChanged)
        self.weightTextField.addTarget(self, action: #selector(weightTextFieldChanged), for: .editingChanged)
        self.repeatsTextfield.setDoneOnKeyboard()
        self.weightTextField.setDoneOnKeyboard()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func repeatsTextFieldChanged(){
        if let approach = self.approach{
            guard let repeatsText = self.repeatsTextfield.text, let repeats = Int(repeatsText) else { return }
            approach.repeats = repeats
            self.repeatsDidChanged?(approach)
        }
    }
    
    @objc func weightTextFieldChanged(){
        if let approach = self.approach{
            guard let weightText = self.weightTextField.text, let weight = Float(weightText) else { return }
            approach.weigth = weight
            self.weightDidChanged?(approach)
        }
    }
    
}
