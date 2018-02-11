//
//  TodayWorkoutManager.swift
//  YourWorkout
//
//  Created by Артём Балашов on 11.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WorkoutNetworkManager{
    static let shared = WorkoutNetworkManager()
    
    func getWorkoutBy(date:String,completion:@escaping (_ result:Workout?,_ error:Error?)->Void){
        let parameters : Parameters = [
        "date" : date,
        "username" : User.shared.username
        ]
        Alamofire.request(URL.init(string: "\(API_URL)/workout/getjournalbydate")!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (responce) in
            switch responce.result{
            case .success:
                if let resp = responce.result.value{
                    let json = JSON(resp)
                    let result = Workout(json: json)
                    completion(result, nil)
                }
                break
            case .failure(let error):
                print(error)
                completion(nil,error)
                break
            }
        }
    }
}
