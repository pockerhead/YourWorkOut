//
//  ActivityIndicator.swift
//  YourWorkout
//
//  Created by Artem Balashow on 31.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var viewController = UIViewController()
    
    
    func initIndicator(_ title: String,from vc: UIViewController) {
        self.viewController = vc
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        effectView.frame = CGRect(x: vc.view.frame.midX - strLabel.frame.width/2, y: vc.view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
    }
    
    func toggleActivity() {
        if activityIndicator.isAnimating{
            UIView.transition(with: self.viewController.view, duration: 0.5, options: .curveEaseIn,
                              animations: {self.effectView.removeFromSuperview()}, completion: nil)
            activityIndicator.stopAnimating()
        } else {
            UIView.transition(with: self.viewController.view, duration: 0.5, options: .curveEaseIn,
                              animations: {self.viewController.view.addSubview(self.effectView)}, completion: nil)
            activityIndicator.startAnimating()
        }
    }
    
}
