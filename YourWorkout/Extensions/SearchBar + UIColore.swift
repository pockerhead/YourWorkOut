//
//  SearchBar + UIColore.swift
//  YourWorkout
//
//  Created by Артём Балашов on 16.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import  UIKit

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
