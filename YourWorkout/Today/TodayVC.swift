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
        ["title":""],
        ["title":""],
        ["title":"Питание","segue":"toToday"],
        ["title":"Тренировки"],
        ]
    var distance = 0.0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateMainValues()
    }
    func updateMainValues(){
        DailyFood.shared.updateDailyFood(completion: {
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates({self.tableView.reloadData()}, completion: nil)
            }
        })
        
        self.distance = HealthSingletone.shared.distance
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
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = String(format:"Съедено сегодня: %.1f Ккал.",DailyFood.shared.calories)
        case 1:
            cell.textLabel?.text = String(format:"Пройдено за сегодня :%.3f км.",self.distance)
        default:
            cell.textLabel?.text = self.menuStruct[indexPath.row]["title"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuStruct.count

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 2:
            self.performSegue(withIdentifier: self.menuStruct[indexPath.row]["segue"]!, sender: self)
            break
        default:
            break
        }
    }
    
}
