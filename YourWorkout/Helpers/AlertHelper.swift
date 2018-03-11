//
//  AlertHelper.swift
//  YourWorkout
//
//  Created by Artem Balashow on 09.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper{
    static public func showAlertWith(title: String?,message:String?,from controller: UIViewController,withCancelButtonTitle cancelButtonTitle:String?, cancelButtonPressed:(()->Void)?, actionButtonTitle:String?, actionButtonPressed:(()->Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: cancelButtonTitle != nil ? cancelButtonTitle : "OK", style: UIAlertActionStyle.cancel, handler: { action in
            switch action.style{
            case .cancel:
                if let cancelButtonPressed = cancelButtonPressed{
                    cancelButtonPressed()
                }
                break
            default:
                break
            }}))
        
        if let actionButtonPressed = actionButtonPressed{
            alert.addAction(UIAlertAction(title: actionButtonTitle != nil ? actionButtonTitle : "OK", style: UIAlertActionStyle.default, handler: { action in
                switch action.style{
                case .default:
                    actionButtonPressed()
                    break
                default:
                    break
                }}))
        }
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static public func showAlertWith(message:String?,from controller: UIViewController, cancelButtonPressed:(()->Void)?){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if let cancelButtonPressed = cancelButtonPressed{
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                switch action.style{
                case .cancel:
                    cancelButtonPressed()
                    break
                default:
                    break
                }}))
        }
        controller.present(alert, animated: true, completion: nil)
    }
}
