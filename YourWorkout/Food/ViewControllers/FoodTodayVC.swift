//
//  FoodTodayVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 15.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import Alamofire

class FoodTodayVC: UIViewController  {
    
    @IBOutlet weak var caloriesMainLabel: UILabel!
    @IBOutlet weak var carbonhydratesMainLabel: UILabel!
    @IBOutlet weak var fatsMainLabel: UILabel!
    @IBOutlet weak var proteinsMainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var todayMeal = TodayEating()
    var selectedMeal : FoodMeal?
    var selectedIndex : IndexPath?
    let keychain = Keychain()
    var date : Date?
    var navItemTitle : String?
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.allowsMultipleSelectionDuringEditing = false;
        let addItemCellNib = UINib(nibName: "FoodItemCell", bundle: nil)
        let foodCellNib = UINib(nibName: "ExpandedDetailsCell", bundle: nil)
        self.activityIndicatorInit("Загрузка")
        self.tableView.register( addItemCellNib, forCellReuseIdentifier: "AddItemCell")
        self.tableView.register( foodCellNib, forCellReuseIdentifier: "FoodCell")
        
        if let nav = self.navItemTitle{
            self.navigationItem.title = nav
        } else {
            self.navigationItem.title = "Сегодня"
        }
        
        
        self.getCurrentJournal()
        
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentJournal(){
        guard let username = self.keychain.getPasscode(identifier: "MPPassword") else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var formattedDate : String
        if let date = self.date {
            formattedDate = formatter.string(from: date)
        } else {
            formattedDate = formatter.string(from: Date())
        }
        let parameters: Parameters = [
            "username":username,
            "date":formattedDate,
            "foods":[]
        ]
        self.toggleActivity()
        Alamofire.request(URL.init(string: "\(API_URL)/food/getjournalbydate")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            responce in
            
            if let json = responce.result.value as? [String:Any]{
                self.todayMeal.initWithServerResponse(response: json["foods"] as! [[String:Any]] )
                self.tableView.reloadData()
                self.updateMainValues()
                self.toggleActivity()
            }
        })
    }
    
    func updateMainValues(){
        let dict = self.todayMeal.returnAllMacros()
        let proteins = dict["proteins"]
        let carbonhydrates = dict["carbonhydrates"]
        let fats = dict["fats"]
        let calories = dict["calories"]
        
        self.caloriesMainLabel.text = String(format:"%.1f",calories!)
        self.proteinsMainLabel.text = String(format:"%.1f",proteins!)
        self.carbonhydratesMainLabel.text = String(format:"%.1f",carbonhydrates!)
        self.fatsMainLabel.text = String(format:"%.1f",fats!)

    }
    
    func updateCurrentJournal(){
        guard let username = self.keychain.getPasscode(identifier: "MPPassword") else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        var formattedDate : String
        if let date = self.date {
            formattedDate = formatter.string(from: date)
        } else {
            formattedDate = formatter.string(from: Date())
        }
        let foods = todayMeal.toDict()
        let parameters: Parameters = [
            "username":username,
            "date":formattedDate,
            "foods":foods
        ]
        self.toggleActivity()
        Alamofire.request(URL.init(string: "\(API_URL)/food/update")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            responce in
            self.toggleActivity()
            
        })
        self.updateMainValues()

    }
    
    func activityIndicatorInit(_ title: String) {
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
       


    }
    func toggleActivity() {
        if activityIndicator.isAnimating{
            UIView.transition(with: self.view, duration: 0.5, options: .curveEaseIn,
                              animations: {self.effectView.removeFromSuperview()}, completion: nil)
            activityIndicator.stopAnimating()
        } else {
            UIView.transition(with: self.view, duration: 0.5, options: .curveEaseIn,
                              animations: {self.view.addSubview(self.effectView)}, completion: nil)
            activityIndicator.startAnimating()
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
extension FoodTodayVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.todayMeal.foodMeals.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section >= self.todayMeal.foodMeals.count{
            return 1
        } else {
            return self.todayMeal.foodMeals[section].mealList.count + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= self.todayMeal.foodMeals.count{
            return "Добавить"
        } else {
            return self.todayMeal.foodMeals[section].name
        }
  
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section >= self.todayMeal.foodMeals.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! FoodItemCell
            cell.button.setTitle("Добавить прием пищи", for: .normal)
//            cell.deleteButton.setTitle("", for: .normal)
            cell.deleteButton.isHidden = true
            cell.button.didTouchUpInside = { MyButton in
                let alertController = UIAlertController(title: "Новый прием пищи", message: "", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Добавить", style: .default, handler: {
                    alert -> Void in
                    
                    let firstTextField = alertController.textFields![0] as UITextField
                    
                    let foodMeal = FoodMeal(name: firstTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                    self.todayMeal.addMeal(meal: foodMeal)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertSections(IndexSet.init(integer: self.todayMeal.foodMeals.count-1), with: .fade)
                    self.tableView.endUpdates()
                    self.updateCurrentJournal()

                })
                saveAction.isEnabled = false
                let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                })
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Название"
                    NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                        {_ in
                            
                            let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                            let textIsNotEmpty = textCount > 0
                            
                            saveAction.isEnabled = textIsNotEmpty
                            
                    })
                }
                
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            return cell
        } else {
            if indexPath.row >= self.todayMeal.foodMeals[indexPath.section].mealList.count{
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! FoodItemCell
                
                cell1.deleteButton.isHidden = false
                cell1.deleteButton.setTitle("Удалить прием", for: .normal)

                cell1.deleteButton.didTouchUpInside = { sender in
                    
                    let alertController = UIAlertController(title: "Удалить \(self.todayMeal.foodMeals[indexPath.section].name)?", message: "", preferredStyle: .alert)
                    
                    let saveAction = UIAlertAction(title: "Удалить", style: .default, handler: {
                        alert -> Void in
                        

                        self.todayMeal.foodMeals.remove(at: indexPath.section)
                        
                        self.tableView.beginUpdates()
                        self.tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .fade)
                        self.tableView.endUpdates()
                        self.updateCurrentJournal()
                    })
                    saveAction.isEnabled = true
                    let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                    })
                    
                    alertController.addAction(saveAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
                cell1.button.setTitle("Добавить продукт", for: .normal)

                cell1.button.didTouchUpInside = { sender in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchFoodVC") as! SearchFoodVC
                    self.selectedMeal = self.todayMeal.foodMeals[indexPath.section]
                    self.selectedIndex = indexPath
                    vc.foodDelegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                return cell1
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! ExpandedDetailsCell
                let oneMeal = self.todayMeal.foodMeals[indexPath.section].mealList[indexPath.row]
                cell.nameLabel.text = oneMeal.name
                cell.proteinsLabel.text = String(format:"%.1f",oneMeal.protein)
                cell.fatsLabel.text = String(format:"%.1f",oneMeal.fat)
                cell.carbonhydratesLabel.text = String(format:"%.1f",oneMeal.carbonhydrate)
                cell.caloriesLabel.text = String(format:"%.1f",oneMeal.calories)
                cell.grammsLabel.text = "\(String(format:"%.1f",oneMeal.gramms)) гр."

                return cell
            }
            
        }
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section >= self.todayMeal.foodMeals.count{
            return 50.0
        } else {
            if indexPath.row >= self.todayMeal.foodMeals[indexPath.section].mealList.count{
                return 50.0
            } else {
                return 150.0
            }
            
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section >= self.todayMeal.foodMeals.count{
            return UITableViewCellEditingStyle.delete
        } else {
            if indexPath.row >= self.todayMeal.foodMeals[indexPath.section].mealList.count{
                return UITableViewCellEditingStyle.delete
            } else {
                return UITableViewCellEditingStyle.delete
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section >= self.todayMeal.foodMeals.count{
            return false
        } else {
            if indexPath.row >= self.todayMeal.foodMeals[indexPath.section].mealList.count{
                return false
            } else {
                return true
            }
            
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DispatchQueue.main.async {
                self.todayMeal.foodMeals[indexPath.section].mealList.remove(at: indexPath.row)
                
                self.tableView.beginUpdates()
                //                self.tableView.reloadData()
                
                self.tableView.deleteRows(at: [indexPath], with: .right)
                self.tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .left)
                self.tableView.endUpdates()
                self.updateCurrentJournal()

            }
        }
    }
    
    
}

extension FoodTodayVC:SearchFoodVCDelegate{
    func getFood(food: FoodModel, fromController: SearchFoodVC,gramms:Float) {
        let meal = OneFood(name: food.name!, calories: food.calories!, protein: food.protein!, fat: food.fat!, carbonhydrate: food.carbonhydrate!, gramms: gramms)
        
        self.selectedMeal?.addMeal(meal: meal)
        if let index = selectedIndex{
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                //                self.tableView.reloadData()
                
                self.tableView.insertRows(at:[index], with: .right)
                self.tableView.reloadRows(at:[index], with: .none)
                print(index)
                
                self.tableView.endUpdates()
            }
            
            
        }
        self.updateCurrentJournal()
        
    }
}

