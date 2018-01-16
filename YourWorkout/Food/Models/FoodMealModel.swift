//
//  FoodMealModel.swift
//  YourWorkout
//
//  Created by Артём Балашов on 15.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation

class TodayEating {
    var foodMeals : [FoodMeal]
    init(){
        self.foodMeals = []
    }
    func addMeal(meal:FoodMeal){
        self.foodMeals.append(meal)
    }
    func initWithServerResponse(response:[[String:Any]]){
        for item in response {
            let name = item["name"]
            let meal = FoodMeal.init(name: "empty")
            self.foodMeals.append(meal.initWithNameAndMeal(name: name as! String, meal: item["products"] as! [[String:Any]]))
        }
    }
    func toDict()-> [[String:Any]]{
        var arr = [[String:Any]]()
        for foodMeal in self.foodMeals {
            var foodMealDict = [String:Any]()
            foodMealDict["name"] = foodMeal.name
            var arrofDict = [[String:Any]]()
            for meal in foodMeal.mealList{
                let dict = [
                    "name":meal.name,
                    "calories":meal.calories,
                    "protein":meal.protein,
                    "carbonhydrate":meal.carbonhydrate,
                    "fat":meal.fat,
                    "gramms":meal.gramms
                    ] as [String : Any]
                arrofDict.append(dict)
            }
            foodMealDict["products"] = arrofDict
            arr.append(foodMealDict)
        }
        return arr
    }
    
    func returnAllMacros()->[String:Float]{
        var dict = [
            "proteins":Float(0.0),
            "carbonhydrates":Float(0.0),
            "fats":Float(0.0),
            "calories":Float(0.0)

            ]
        var arr = [[String:Float]]()
        for foodMeal in self.foodMeals {
            dict["proteins"] = foodMeal.mealList.map({$0.protein}).reduce(0,+)
            dict["fats"] = foodMeal.mealList.map({$0.fat}).reduce(0,+)
            dict["carbonhydrates"] = foodMeal.mealList.map({$0.carbonhydrate}).reduce(0,+)
            dict["calories"] = foodMeal.mealList.map({$0.calories}).reduce(0,+)
            arr.append(dict)
        }
        
        dict["proteins"] = arr.map({Float($0["proteins"]!)}).reduce(0,+)
        dict["fats"] = arr.map({Float($0["fats"]!)}).reduce(0,+)
        dict["carbonhydrates"] = arr.map({Float($0["carbonhydrates"]!)}).reduce(0,+)
        dict["calories"] = arr.map({Float($0["calories"]!)}).reduce(0,+)

        return dict
    }
}

class FoodMeal{
    var mealList : [OneFood]
    var name:String

    init(name:String){
        self.name = name

        self.mealList = []
    }
    func initWithNameAndMeal(name:String,meal:[[String:Any]])->FoodMeal{
        self.name = name
        for item in meal {
            self.mealList.append(OneFood.init(name: item["name"] as! String, calories: item["calories"] as! Float, protein: item["protein"] as! Float, fat: item["fat"] as! Float, carbonhydrate: item["carbonhydrate"] as! Float, gramms: item["gramms"] as! Float))
        }
        return self
    }
    func addMeal(meal:OneFood){
        self.mealList.append(meal)
    }
}

class OneFood {
    var name:String
    var calories:Float
    var protein:Float
    var fat:Float
    var carbonhydrate:Float
    var gramms:Float
    
    init(name:String,calories:Float,protein:Float,fat:Float,carbonhydrate:Float,gramms:Float) {
        self.name = name
        self.protein = protein
        self.carbonhydrate = carbonhydrate
        self.fat = fat
        self.gramms = gramms
        self.calories = calories
    }
    
    
}
