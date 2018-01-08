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
//    var protein : Float?
//    var water : Float?
    var calories : Float?
    init(item:[String:Any]){
        self.name = (item["name"] as? String)!
        self.calories = (item["calories"] as? Float)!
//        self.protein = (item["protein"] as? Float)!
//        self.water = (item["water"] as? Float)!
    }
    

    
}
