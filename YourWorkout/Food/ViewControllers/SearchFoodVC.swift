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
    var isLoadingMore = false // flag
    var expandedCells = [Int]()
    var searchQuery = ""
    let activityIndicator = ActivityIndicator()
    var page = 2
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.initIndicator("Loading", from: self)
        
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Введите название продукта"
        self.searchController.searchBar.barStyle = .black
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.page = 1
                let parameters: Parameters = ["search":query,
                                              "page":self.page]
                self.searchQuery = query
                let requestFood = FoodListModel.sharedInstance
                self.activityIndicator.toggleActivity()
                Alamofire.request("\(API_URL)/food/find", parameters:parameters).responseJSON(completionHandler: { responce in
                    if let json = responce.result.value{
                        DispatchQueue.main.async {
                            print(json)
                            requestFood.initFoodListWithResponce(responce: json as! [[String : Any]])
                            self.filteredFood = requestFood.foodList
                            let indexSet = IndexSet.init(integer: 0)
                            self.tableView.performBatchUpdates({
                                self.tableView.reloadSections(indexSet, with: .automatic)
                                self.activityIndicator.toggleActivity()
                            }, completion: nil)
                            
                        }
                        
                    }
                })
            })
            .disposed(by: disposeBag)
        
        
        self.navigationItem.searchController = searchController
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.doFirstRequest()
        
        
        let expandedCellNib = UINib(nibName: "ExpandedFoodCell", bundle: nil)
        let expandableCell = UINib(nibName: "ExpandableCellForFood", bundle: nil)
        
        self.tableView.register(expandedCellNib, forCellReuseIdentifier: "ExpandedFoodCell")
        self.tableView.register(expandableCell, forCellReuseIdentifier: "ExpandableCellForFood")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = scrollView.contentSize.height * 0.2
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.isLoadingMore = true
            // Update UI
            let parameters: Parameters = [
                "search":self.searchQuery,
                "page":self.page
            ]
            let requestFood = FoodListModel.sharedInstance
//            self.activityIndicator.toggleActivity()
            Alamofire.request("\(API_URL)/food/find", parameters:parameters).responseJSON(completionHandler: { responce in
                if let json = responce.result.value{
                    self.page = self.page + 1
                    print(json)
                    requestFood.initFoodListWithResponce(responce: json as! [[String : Any]])
                    self.filteredFood = requestFood.foodList
                    let indexSet = IndexSet.init(integer: 0)
                    
//                    self.activityIndicator.toggleActivity()
                    
                    self.tableView.reloadData()
                    
                    self.isLoadingMore = false
                    
                    
                    
                }
            })
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doFirstRequest(){
        let parameters: Parameters = ["search":"","page":1]
        let requestFood = FoodListModel.sharedInstance
        self.activityIndicator.toggleActivity()
        
        Alamofire.request("\(API_URL)/food/find", parameters:parameters).responseJSON(completionHandler: { responce in
            if let json = responce.result.value{
                DispatchQueue.main.async {
                    print(json)
                    requestFood.initFoodListWithResponce(responce: json as! [[String : Any]])
                    self.filteredFood = requestFood.foodList
                    let indexSet = IndexSet.init(integer: 0)
                    self.tableView.performBatchUpdates({
                        self.tableView.reloadSections(indexSet, with: .automatic)
                        self.activityIndicator.toggleActivity()
                        
                    }, completion: nil)
                    
                }
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.reloadData()
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
        let foodItem : FoodModel
        foodItem = filteredFood[indexPath.row]
        if self.expandedCells.contains(indexPath.row) {
            cell1.backGroundView.isHidden = false
        } else {
            cell1.backGroundView.isHidden = true
        }
        cell1.initWithFood(protein: foodItem.protein, fat: foodItem.fat, carbonhydrates: foodItem.carbonhydrate, calories: foodItem.calories,name:foodItem.name!)
        cell1.addButton.didTouchUpInside = {sender in
            self.searchController.setEditing(false, animated: false)
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
            cell1.isOpened = !cell1.isOpened
            print(cell1.isOpened)
            if self.expandedCells.contains(indexPath.row) {
                self.expandedCells = self.expandedCells.filter({$0 != indexPath.row})
            } else {
                self.expandedCells.append(indexPath.row)
            }
            cell1.backGroundView.isHidden = !cell1.backGroundView.isHidden
            
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
        
    }
    
}


