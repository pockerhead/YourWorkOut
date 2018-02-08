//
//  TodayVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 30.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import Alamofire
import HealthKit

class TodayVC: UIViewController {
    var menuStruct = [
        ["name":"workout",
         "title":"Дневник \nтренировок",],
        ["name":"food",
         "title":"Дневник \nпитания",
         "segue":"toToday"],
        ["name":"activity",
         "title":"Активность \nи сон",
         ],
        ]
    var distance = 0.0
    var cellHeight : CGFloat = 100
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = FoodColors.primaryColor
        
        var colors = [UIColor]()
        colors.append(FoodColors.barTopColor)
        colors.append(FoodColors.barBottomColor)
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        let menuItemNib = UINib(nibName: "MenuItemCell", bundle: nil)
        self.tableView.register( menuItemNib, forCellReuseIdentifier: "MenuItemCell")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateMainValues()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    func updateMainValues(){
        
        DailyFood.shared.updateDailyFood(completion: {
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates({self.tableView.reloadData()}, completion: nil)
            }
        })
        HealthSingletone.shared.updateDistance()
        
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates({self.tableView.reloadData()}, completion: nil)
        }
        
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
extension TodayVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as? MenuItemCell{
            self.cellHeight = cell.frame.size.height
            cell.selectionStyle = .none
            switch self.menuStruct[indexPath.row]["name"] {
            case "activity"?:
                
                cell.gradientView.startColor = TodayMenuColors.ActivityTopColor
                cell.gradientView.endColor = TodayMenuColors.ActivityBottomColor
                cell.iconImage.image = #imageLiteral(resourceName: "activityIcon")
                cell.nameLabel.text = self.menuStruct[indexPath.row]["title"]
                cell.firstDetailLabel.text = String(format: "Пройдено: %.1f км", HealthSingletone.shared.distance)
                cell.secondDetailLabel.text = String(format: "Расход калорий: %.1f Ккал", HealthSingletone.shared.burnedCallories)
                return cell
            case "food"?:
                
                cell.gradientView.startColor = TodayMenuColors.FoodTopColor
                cell.gradientView.endColor = TodayMenuColors.FoodBottomColor
                cell.iconImage.image = #imageLiteral(resourceName: "foddIcon")
                cell.nameLabel.text = self.menuStruct[indexPath.row]["title"]
                cell.firstDetailLabel.text = "Б:\(DailyFood.shared.proteins) Ж:\(DailyFood.shared.fats) У:\(DailyFood.shared.carbonhydrates)"
                cell.secondDetailLabel.text = "Калорийность: \(DailyFood.shared.calories) Ккал"
                return cell
            case "workout"?:
                
                cell.gradientView.startColor = TodayMenuColors.WorkoutTopColor
                cell.gradientView.endColor = TodayMenuColors.WorkoutBottomColor
                cell.iconImage.image = #imageLiteral(resourceName: "workoutIcon")
                cell.nameLabel.text = self.menuStruct[indexPath.row]["title"]
                cell.firstDetailLabel.text = "Поднятый вес: 0 кг"
                cell.secondDetailLabel.text = "Расход калорий: 0 Ккал"
                return cell
            default:
                cell.nameLabel.text = self.menuStruct[indexPath.row]["title"]
            }
        }
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuStruct.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.cellHeight
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.menuStruct[indexPath.row]["name"] {
        case "activity"?:
            break
        case "food"?:
            self.performSegue(withIdentifier: self.menuStruct[indexPath.row]["segue"]!, sender: self)
            break
        case "workout"?:
            break
        default:
            break
        }
        
    }
    
}
