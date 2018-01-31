//
//  FoodListModel.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class FoodListModel {

    static let sharedInstance = FoodListModel()
    
    var foodList : [FoodModel]
    
    private init(){
        self.foodList = []
    }
    
    func initFoodListWithResponce(responce:[[String:Any]]){
        self.foodList = []
        for item in responce {
            self.foodList.append(FoodModel.init(item: item))
        }
    }
    
}

class FoodListModelNonShared {
    
    
    var foodList : [FoodModel]
    
    init(){
        self.foodList = []
    }
    
    func initFoodListWithResponce(responce:[[String:Any]]){
        self.foodList = []
        for item in responce {
            self.foodList.append(FoodModel.init(item: item))
        }
    }
    
}
