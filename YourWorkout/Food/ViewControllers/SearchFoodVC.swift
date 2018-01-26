//
//  FoodListHeaderTVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 10.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import ExpandableCell

protocol SearchFoodVCDelegate {
    func getFood(food:FoodModel,fromController:SearchFoodVC, gramms:Float)
}

class SearchFoodVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var foodData = FoodListModel.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFood = FoodListModel.sharedInstance.foodList
    var heightAtIndexPath = NSMutableDictionary()
    var foodDelegate : SearchFoodVCDelegate?
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var expandedCells = [Int]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorInit("Загрузка")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите название продукта"
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        tableView.delegate = self
        tableView.dataSource = self
//        definesPresentationContext = true
        doFirstRequest()
        //        tableView.openAll()
        searchController.searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                let parameters: Parameters = ["search":query]
                let requestFood = FoodListModel.sharedInstance
                self.toggleActivity()
                Alamofire.request("\(API_URL)/food/find", parameters:parameters).responseJSON(completionHandler: { responce in
                    if let json = responce.result.value{
                        DispatchQueue.main.async {
                            print(json)
                            requestFood.initFoodListWithResponce(responce: json as! [[String : Any]])
                            self.filteredFood = requestFood.foodList
                            let indexSet = IndexSet.init(integer: 0)
                            self.tableView.reloadData()
                            self.toggleActivity()
                            
                        }
                        
                    }
                })
            })
            .disposed(by: disposeBag)
        
//        self.tableView.backgroundColor = FoodColors.primaryColor
//        self.view.backgroundColor = FoodColors.primaryColor
        
        let expandedCellNib = UINib(nibName: "ExpandedFoodCell", bundle: nil)
        
        let expandableCell = UINib(nibName: "ExpandableCellForFood", bundle: nil)
        self.tableView.register(expandedCellNib, forCellReuseIdentifier: "ExpandedFoodCell")
        self.tableView.register(expandableCell, forCellReuseIdentifier: "ExpandableCellForFood")
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.open(at:indexPath )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doFirstRequest(){
        let parameters: Parameters = ["search":""]
        let requestFood = FoodListModel.sharedInstance
        self.toggleActivity()
        Alamofire.request("\(API_URL)/food/find", parameters:parameters).responseJSON(completionHandler: { responce in
            if let json = responce.result.value{
                DispatchQueue.main.async {
                    print(json)
                    requestFood.initFoodListWithResponce(responce: json as! [[String : Any]])
                    self.filteredFood = requestFood.foodList
                    
                    self.tableView.reloadData()
                    self.toggleActivity()
                    
                }
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        self.tableView.reloadData()
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
}

extension SearchFoodVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFood.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "ExpandedFoodCell") as! ExpandedFoodCell
        //        let cell1 = UITableViewCell()
        let foodItem : FoodModel
        
        foodItem = filteredFood[indexPath.row]
        //        cell1.textLabel?.text = foodItem.name
        if self.expandedCells.contains(indexPath.row) {
            cell1.backGroundView.isHidden = false
        } else {
            cell1.backGroundView.isHidden = true
        }
        cell1.initWithFood(protein: foodItem.protein, fat: foodItem.fat, carbonhydrates: foodItem.carbonhydrate, calories: foodItem.calories,name:foodItem.name!)
        cell1.addButton.didTouchUpInside = {sender in
            let foodName = self.foodData.foodList[indexPath.row].name!
            let calories = cell1.caloriesOnChange
            let protein = cell1.proteinsOnChange
            let carbonhydrate = cell1.carbonhydratesOnChange
            let fat = cell1.fatsOnChange
            let gramms = Float(cell1.portionStepper.value)
            print(fat)
            let food = FoodModel(name: foodName, calories: calories, protein: protein, carbonhydrate: carbonhydrate, fat: fat)
            self.foodDelegate?.getFood(food: food, fromController: self, gramms: gramms)
            self.navigationController?.popViewController(animated: true)
            
            
            
            
            
        }
        cell1.nameButton.didTouchUpInside = {[unowned self] sender in
            cell1.backGroundView.isHidden = !cell1.backGroundView.isHidden
            if self.expandedCells.contains(indexPath.row) {
                self.expandedCells = self.expandedCells.filter({$0 != indexPath.row})
            } else {
                self.expandedCells.append(indexPath.row)
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.expandedCells.contains(indexPath.row){
            return 155

        } else {
            return 44

        }
        return 44
    }
    
}


