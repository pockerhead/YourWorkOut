//
//  WorkoutTodayVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 11.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class WorkoutTodayVC: UIViewController {

    var TodayWorkout : Workout?
    var date : Date?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = FoodColors.primaryColor
        self.tableView.allowsMultipleSelectionDuringEditing = false;
        // Do any additional setup after loading the view.
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var formattedDate : String
        if let date = self.date {
            formattedDate = formatter.string(from: date)
        } else {
            formattedDate = formatter.string(from: Date())
        }
        WorkoutNetworkManager.shared.getWorkoutBy(date: formattedDate) { (workout, err ) in
            if let err = err{
                print(err)
            }
            if let TodayWorkout = workout{
                self.TodayWorkout = TodayWorkout
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension WorkoutTodayVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.TodayWorkout?.exercises.count ?? 0) + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row < self.TodayWorkout?.exercises.count ?? 0{
            cell.textLabel?.text = (self.TodayWorkout?.exercises[indexPath.row].title ?? "")
        } else {
            cell.textLabel?.text = "Add exersise"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.TodayWorkout?.exercises.count ?? 0{
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchExercisesVC") as! SearchExercisesVC
//            self.selectedMeal = self.todayMeal.foodMeals[indexPath.section]
//            self.selectedIndex = indexPath
//            vc.foodDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)        }
    }
}
