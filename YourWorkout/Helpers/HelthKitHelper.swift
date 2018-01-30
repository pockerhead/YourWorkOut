//
//  HelthKitHelper.swift
//  YourWorkout
//
//  Created by Artem Balashow on 30.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import Foundation
import HealthKit

class HealthParser {
    
    let healthStore = HKHealthStore()
    
    func getTodaysDistance(completion: @escaping (Double) -> Void) {
        let distanceQuantity = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceQuantity, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to fetch distance = \(error?.localizedDescription ?? "N/A")")
                completion(0.0)
                return
            }
            
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit.meter()))
            }
        }
        
        healthStore.execute(query)
    }
}
