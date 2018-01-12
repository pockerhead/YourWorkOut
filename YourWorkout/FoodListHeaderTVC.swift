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
    var heightAtIndexPath = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
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
        vc.navigationItem.title = foodData.foodList[indexPath.section].name
        vc.protein = foodData.foodList[indexPath.section].protein!
        vc.carbonhydrate = foodData.foodList[indexPath.section].carbonhydrate!
        vc.fat = foodData.foodList[indexPath.section].fat!
        vc.calories = foodData.foodList[indexPath.section].calories!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

