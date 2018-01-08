//
//  FoodListModel.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import Alamofire


class FoodListModel {

    static let sharedInstance = FoodListModel()
    private init(){
        
    }
    
    var foodList = [FoodListModel]()

    var name : String?
    var protein : Float?
    var water : Float?
    
    
    
    func initFoodListWithResponce(responce:[[String:Any]]){
        var tempFood = FoodListModel()
        print(responce)
        for item in responce {
            print("\(item)\n")
            tempFood.name = (item["name"] as? String)!
            tempFood.protein = (item["protein"] as? Float)!
            tempFood.water = (item["water"] as? Float)!
            print(tempFood.name ?? "nil")
            self.foodList.append(tempFood)
        }
    }
    
    
    
    
    
    
}
