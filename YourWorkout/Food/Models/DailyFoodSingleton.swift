//
//  DailyFoodSingleton.swift
//  YourWorkout
//
//  Created by Artem Balashow on 30.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation

class DailyFood {
    
    static let shared = DailyFood()
    
    var calories : Float = 0.0
    var carbonhydrates : Float = 0.0
    var proteins : Float = 0.0
    var fats : Float = 0.0

    private init(){
    }
    
    func updateDailyFoodWith(responce:[String:Any]){
        
        if let calories = responce["calories"] as? Float{
            self.calories = calories
        }
        if let carbonhydrates = responce["carbonhydrates"] as? Float{
            self.carbonhydrates = carbonhydrates
        }
        if let proteins = responce["proteins"] as? Float{
            self.proteins = proteins
        }
        if let fats = responce["fats"] as? Float{
            self.fats = fats
        }
    }
    
}
