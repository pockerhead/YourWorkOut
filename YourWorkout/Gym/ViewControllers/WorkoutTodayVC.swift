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
    var openedCells = [Int]()
    
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
    
}

extension WorkoutTodayVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let workout = self.TodayWorkout{
            let count = workout.exercises.count
            if count > indexPath.row{
                if self.openedCells.contains(indexPath.row){
                    let ex = workout.exercises[indexPath.row]
                    return 70 + 65 * CGFloat(ex.approaches.count)
                } else {
                    return 70
                }
                
            }
        }
        
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.TodayWorkout?.exercises.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row < self.TodayWorkout?.exercises.count ?? 0{
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExerciseCell") as? ExerciseCell{
                let index = indexPath.row + 1
                cell.index = index
                
                if let item = self.TodayWorkout?.exercises[indexPath.row] {
                    cell.detailLabel.text = item.mainMuscleGroup[0]
                    cell.indexLabel.text = "\(index) \(item.title)"
                    cell.exercise = item
                }
                
                cell.initUI()
                cell.didEditExercise = { ex in
                    self.TodayWorkout?.exercises[indexPath.row] = ex
                    self.updateWorkout()
                    if !self.openedCells.contains(indexPath.row) {
                        self.openedCells.append(indexPath.row)
                    }
                    if ex.approaches.isEmpty{
                        self.openedCells = self.openedCells.filter({$0 != indexPath.row})
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)

                }
                cell.didEditApproach = { ex in
                    self.TodayWorkout?.exercises[indexPath.row] = ex
                    self.updateWorkout()
                }
                
                cell.openButton.didTouchUpInside = {button in
                    if self.openedCells.contains(indexPath.row) {
                        self.openedCells = self.openedCells.filter({$0 != indexPath.row})
                    } else {
                        self.openedCells.append(indexPath.row)
                    }
                    cell.viewBackground.backgroundColor = FoodColors.barBottomColor
                    cell.indexLabel.textColor = UIColor.white
                    cell.detailLabel.textColor = UIColor.white
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                if self.openedCells.contains(indexPath.row){
                    cell.viewBackground.backgroundColor = FoodColors.barBottomColor
                    cell.indexLabel.textColor = UIColor.white
                    cell.detailLabel.textColor = UIColor.white
                } else {
                    cell.viewBackground.backgroundColor = UIColor.clear
                    cell.indexLabel.textColor = UIColor.black
                    cell.detailLabel.textColor = UIColor.black
                }
                
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
