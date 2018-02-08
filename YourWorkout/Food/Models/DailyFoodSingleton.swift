//
//  DailyFoodSingleton.swift
//  YourWorkout
//
//  Created by Artem Balashow on 30.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DailyFood {
    
    static let shared = DailyFood()
    
    var calories : Float = 0.0
    var carbonhydrates : Float = 0.0
    var proteins : Float = 0.0
    var fats : Float = 0.0

    private init(){
    }
    
    func updateDailyFood(completion: @escaping () -> Void){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var formattedDate : String
        formattedDate = formatter.string(from: Date())
        
        let parameters: Parameters = [
            "username":User.shared.username,
            "date":formattedDate,
            "foods":[]
        ]
        Alamofire.request(URL.init(string: "\(API_URL)/food/getjournalbydate")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {
            responce in
//            switch (responce.result){
//            case .success:
//                break
//            case .failure(let error):
//                break
//            }
            if let json = responce.result.value as? [String:Any]{
                let json = JSON(json)
                if let responce = json["dailyFoods"].dictionary {
                    
                    if let calories = responce["calories"]?.float{
                        self.calories = calories
                    }
                    if let carbonhydrates = responce["carbonhydrate"]?.float{
                        self.carbonhydrates = carbonhydrates
                    }
                    if let proteins = responce["protein"]?.float{
                        self.proteins = proteins
                    }
                    if let fats = responce["fat"]?.float{
                        self.fats = fats
                    }
                    completion()
                }
            }
        })
        
        
    }
    
}
