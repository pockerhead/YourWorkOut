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
        
        getCurrentWorkout()
        let exNib = UINib(nibName: "ExerciseCell", bundle: nil)
        self.tableView.register(exNib, forCellReuseIdentifier: "ExerciseCell")
    }
    
    func getCurrentWorkout(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var formattedDate : String
        if let date = self.date {
            formattedDate = formatter.string(from: date)
        } else {
            self.date = Date()
            formattedDate = formatter.string(from: Date())
        }
        WorkoutNetworkManager.shared.getWorkoutBy(date: formattedDate) { (workout, err ) in
            if let err = err{
                print(err)
            }
            if let TodayWorkout = workout{
                self.TodayWorkout = TodayWorkout
                self.tableView.reloadData()
            }
        }
    }
    func updateWorkout(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var formattedDate : String
        if let date = self.date {
            formattedDate = formatter.string(from: date)
        } else {
            self.date = Date()
            formattedDate = formatter.string(from: Date())
        }
        WorkoutNetworkManager.shared.updateWorkoutBy(date: formattedDate, workout: self.TodayWorkout!) { (work, err ) in
            print(err)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.TodayWorkout?.exercises.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row < self.TodayWorkout?.exercises.count ?? 0{
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExerciseCell") as? ExerciseCell{
                let index = indexPath.row + 1
                let item = self.TodayWorkout?.exercises[indexPath.row]
                let title = item?.title
                let main = item?.mainMuscleGroup
                cell.indexLabel.text = "\(index) \(title!)"
                cell.detailLabel.text = main?[0] ?? ""
                return cell
            }
            
        } else {
            cell.textLabel?.text = "Add exersise"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.TodayWorkout?.exercises.count ?? 0{
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchExercisesVC") as! SearchExercisesVC
            
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension WorkoutTodayVC: SearchExDelegate{
    func getExercise(with name: String, mainMuscle: [String], secondaryMuscle: [String], sportStuff: [String]) {
        self.TodayWorkout?.exercises.append(Exercise.init(name: name, main: mainMuscle, sec: secondaryMuscle, stuff: sportStuff))
        self.tableView.reloadData()
        updateWorkout()
    }
}
