//
//  FoodListModel.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import Alamofire


class FoodModel {

    var name : String?
    var protein : Float?
    var water : Float?
    var calories : Float?
    var carbonhydrate : Float?
    var fat : Float?
    init(item:[String:Any]){
        self.name = (item["name"] as? String) ?? "No name"
        self.calories = (item["calories"] as? Float) ?? 0.0
        self.protein = (item["protein"] as? Float) ?? 0.0
        self.water = (item["water"] as? Float) ?? 0.0
        self.carbonhydrate = (item["carbohydrate"] as? Float) ?? 0.0
        self.fat = (item["fat"] as? Float) ?? 0.0
    }
    
    init(name:String,calories:Float,protein:Float,carbonhydrate:Float,fat:Float){
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbonhydrate = carbonhydrate
        self.fat = fat
    }
}
