//
//  WorkoutModel.swift
//  YourWorkout
//
//  Created by Артём Балашов on 11.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import SwiftyJSON


class Workout{
    var name : String = ""
    var durability : Float = 0.0
    var calloriesBurned : Float = 0.0
    var exercises : [Exercise] = []
    
    init(json: JSON) {
        if let workout = json["workout"].dictionary{
            if let name = workout["name"]?.string{
                self.name = name
            }
            if let exercises = workout["exercises"]?.array{
                self.exercises = exercises.flatMap({Exercise(json:$0)})
            }
            if let durability = workout["durability"]?.float{
                self.durability = durability
            }
            if let calloriesBurned = workout["calloriesBurned"]?.float{
                self.calloriesBurned = calloriesBurned
            }
        }
        
    }
}

class Exercise{
    var title : String = ""
    var mainMuscleGroup : [String] = []
    var secondaryMuscleGroup : [String] = []
    var sportStuff = [String]()
    var approaches = [Approach]()
    
    init(json: JSON) {
        if let title = json["title"].string{
            self.title = title
        }
        if let mainMuscleGroup = json["mainMuscleGroup"].array{
            for json in mainMuscleGroup{
                if let json = json.string{
                    self.mainMuscleGroup.append(json)
                }
            }
        }
        if let secondaryMuscleGroup = json["secondaryMuscleGroup"].array{
            for json in secondaryMuscleGroup{
                if let json = json.string{
                    self.secondaryMuscleGroup.append(json)
                }
            }
        }
        if let sportStuff = json["sportStuff"].array{
            for json in sportStuff{
                if let json = json.string{
                    self.sportStuff.append(json)
                }
            }
        }
        if let approaches = json["approaches"].array{
            self.approaches = approaches.flatMap({Approach.init(json:$0)})
        }
    }
    
    init(name:String,main:[String],sec:[String],stuff:[String]) {
        self.title = name
        self.mainMuscleGroup = main
        self.secondaryMuscleGroup = sec
        self.sportStuff = stuff
        self.approaches = [Approach]()
    }
    
}

class Approach{
    var repeats : Int = 0
    var weigth : Float = 0.0
    
    init(json: JSON) {
        if let repeats = json["repeats"].int{
            self.repeats = repeats
        }
        if let weigth = json["weigth"].float{
            self.weigth = weigth
        }
    }
    init(repeats: Int, weigth: Float) {
        self.repeats = repeats
        self.weigth = weigth
    }

}

class SearchExercise{
    var title : String = ""
    var mainMuscleGroup : [String] = []
    var secondaryMuscleGroup : [String] = []
    var sportStuff = [String]()
    
    init(json: JSON) {
        if let title = json["title"].string{
            self.title = title
        }
        if let mainMuscleGroup = json["mainMuscleGroup"].array{
            for json in mainMuscleGroup{
                if let json = json.string{
                    self.mainMuscleGroup.append(json)
                }
            }
        }
        if let secondaryMuscleGroup = json["secondaryMuscleGroup"].array{
            for json in secondaryMuscleGroup{
                if let json = json.string{
                    self.secondaryMuscleGroup.append(json)
                }
            }
        }
        if let sportStuff = json["sportStuff"].array{
            for json in sportStuff{
                if let json = json.string{
                    self.sportStuff.append(json)
                }
            }
        }
    }
    
}
