//
//  FoodListHeaderTVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 10.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController



class FoodListHeaderTVC: CollapsibleTableSectionViewController {
    
    var foodData = FoodListModel.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFood = [FoodModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        let cellNib = UINib(nibName: "FoodItemCell", bundle: nil)
        let expandedCellNib = UINib(nibName: "ExpandedFoodCell", bundle: nil)
        let expandedDetailCellNib = UINib(nibName: "ExpandedDetailsCell", bundle: nil)
        let epandedEditPortionCellNib = UINib(nibName: "EditPortionCell", bundle: nil)
        
        self._tableView.register(cellNib, forCellReuseIdentifier: "FoodItemCell")
        self._tableView.register(expandedCellNib, forCellReuseIdentifier: "ExpandedFoodCell")
        self._tableView.register(expandedDetailCellNib, forCellReuseIdentifier: "ExpandedDetailsCell")
        self._tableView.register(epandedEditPortionCellNib, forCellReuseIdentifier: "EditPortionCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FoodListHeaderTVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
// MARK: - Search

extension FoodListHeaderTVC {
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFood = foodData.foodList.filter({( item : FoodModel) -> Bool in
            return (item.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        self._tableView.reloadData()
    }
}


extension FoodListHeaderTVC: CollapsibleTableSectionDelegate {
    
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
        let cell2 = self._tableView.dequeueReusableCell(withIdentifier: "ExpandedDetailsCell") as! ExpandedDetailsCell
        let cell3 = self._tableView.dequeueReusableCell(withIdentifier: "EditPortionCell") as! EditPortionCell
        let foodItem : FoodModel
        if isFiltering(){
            foodItem = filteredFood[indexPath.section]
        } else {
            foodItem = foodData.foodList[indexPath.section]
        }
        
        cell1.initWithFood(protein: foodItem.protein, fat: foodItem.fat, carbonhydrates: foodItem.carbonhydrate, calories: foodItem.calories)
//        cell2.initWithFood(calories: foodItem.calories)
//        cell3.selectionStyle = .none
//
//        switch indexPath.row {
//        case 0:
//            return cell1
//        case 1:
//            return cell2
//        case 2:
//            return cell3
//        default:
//            break
//        }
        
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc : FoodDetailsVC = (self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailsViewController") as? FoodDetailsVC)!
        vc.navigationItem.title = foodData.foodList[indexPath.section].name
        vc.protein = foodData.foodList[indexPath.section].protein!
        vc.carbonhydrate = foodData.foodList[indexPath.section].carbonhydrate!
        vc.fat = foodData.foodList[indexPath.section].fat!
        vc.calories = foodData.foodList[indexPath.section].calories!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

