//
//  MyButton.swift
//  YourWorkout
//
//  Created by Артём Балашов on 15.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

class MyMDCFloatingButton: MDCFloatingButton {
    
    typealias DidTapButton = (MyMDCFloatingButton) -> ()
    
    init(){
        super.init(frame: .zero, shape: .default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    
    @objc func didTouchUpInside(sender: UIButton) {
        if let handler = didTouchUpInside {
            handler(self)
        }
    }
    
    var didTouchUpInside: DidTapButton? {
        didSet {
            if didTouchUpInside != nil {
                addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            }
        }
    }
    
    
}
