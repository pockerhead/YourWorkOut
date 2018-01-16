//
//  FoodListHeaderTVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 10.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController
import Alamofire

protocol SearchFoodVCDelegate {
    func getFood(food:FoodModel,fromController:SearchFoodVC, gramms:Float)
}

class SearchFoodVC: CollapsibleTableSectionViewController {
    
    var foodData = FoodListModel.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFood = [FoodModel]()
    var heightAtIndexPath = NSMutableDictionary()
    var foodDelegate : SearchFoodVCDelegate?
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.activityIndicatorInit("Загрузка")
//        self.navigationController?.navigationBar.prefersLargeTitles=false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
        searchController.searchBar.barStyle = .black

        navigationItem.searchController = searchController
        definesPresentationContext = true
        self._tableView.rowHeight = UITableViewAutomaticDimension

        
        let expandedCellNib = UINib(nibName: "ExpandedFoodCell", bundle: nil)
       
        
 
        self._tableView.register(expandedCellNib, forCellReuseIdentifier: "ExpandedFoodCell")
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SearchFoodVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
// MARK: - Search

extension SearchFoodVC {
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let parameters: Parameters = ["search":searchText]
        let requestFood = FoodListModel.sharedInstance
        self.toggleActivity()
        Alamofire.request("\(API_URL)/food/find", parameters:parameters).responseJSON(completionHandler: { responce in
            if let json = responce.result.value{
                DispatchQueue.main.async {
                    print(json)
                    requestFood.initFoodListWithResponce(responce: json as! [[String : Any]])
                    self.filteredFood = requestFood.foodList
                    
                    self._tableView.reloadData()
                    self.toggleActivity()

                }
                
            }
        })
        
        
    }
}


extension SearchFoodVC: CollapsibleTableSectionDelegate {
    
    func numberOfSections(_ tableView: UITableView) -> Int {
        if isFiltering() {
            return filteredFood.count
        } else {
            return foodData.foodList.count
        }
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = self._tableView.dequeueReusableCell(withIdentifier: "ExpandedFoodCell") as! ExpandedFoodCell
       
        let foodItem : FoodModel
        if isFiltering(){
            foodItem = filteredFood[indexPath.section]
        } else {
            foodItem = foodData.foodList[indexPath.section]
        }
        
        cell1.initWithFood(protein: foodItem.protein, fat: foodItem.fat, carbonhydrates: foodItem.carbonhydrate, calories: foodItem.calories)
        cell1.addButton.didTouchUpInside = {sender in
            let foodName = self.foodData.foodList[indexPath.section].name!
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
        
        return cell1
        
        
    }
    
    func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering(){
            return filteredFood[section].name

        } else {
            return foodData.foodList[section].name
        }
    }
    
    func shouldCollapseByDefault(_ tableView: UITableView) -> Bool {
        return true
    }
    
    func shouldCollapseOthers(_ tableView: UITableView) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc : FoodDetailsVC = (self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailsViewController") as? FoodDetailsVC)!
        var foodItem: FoodModel
        if isFiltering(){
            foodItem = filteredFood[indexPath.section]
        } else {
            foodItem = foodData.foodList[indexPath.section]
        }
        vc.initWithFoodData(data: foodItem)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

