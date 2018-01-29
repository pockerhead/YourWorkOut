//
//  StatisticsVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 29.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import HealthKit
class StatisticsVC: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var calloriesBurnedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1. Use HealthKit to create the Height Sample Type
        getTodaysDistance(completion: { (distance) in
            let kilometersDistance = distance/1000
            self.distanceLabel.text = String(format:"%.3f",kilometersDistance ) + " км."
            self.distanceLabel.sizeToFit()
            
            let calloriesBurned = 0.5 * 80 * kilometersDistance
            self.calloriesBurnedLabel.text = String(format:"%.1f", calloriesBurned) + " Ккал."
             self.calloriesBurnedLabel.sizeToFit()
            })
        
        }
        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        //1. Use HKQuery to load the most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
                                            //2. Always dispatch to the main thread when complete.
                                            DispatchQueue.main.async {
                                                
                                                guard let samples = samples,
                                                    let mostRecentSample = samples.first as? HKQuantitySample else {
                                                        
                                                        completion(nil, error)
                                                        return
                                                }
                                                
                                                completion(mostRecentSample, nil)
                                            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
