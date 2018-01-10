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

        
        let cellNib = UINib(nibName: "FoodItemCell", bundle: nil)
        let expandedCellNib = UINib(nibName: "ExpandedFoodCell", bundle: nil)
        let expandedDetailCellNib = UINib(nibName: "ExpandedDetailsCell", bundle: nil)
        let epandedEditPortionCellNib = UINib(nibName: "EditPortionCell", bundle: nil)
        
//        self._tableView.register(cellNib, forCellReuseIdentifier: "FoodItemCell")
//        self._tableView.register(expandedCellNib, forCellReuseIdentifier: "ExpandedFoodCell")
//        self._tableView.register(expandedDetailCellNib, forCellReuseIdentifier: "ExpandedDetailsCell")
//        self._tableView.register(epandedEditPortionCellNib, forCellReuseIdentifier: "EditPortionCell")
//        tableView.estimatedRowHeight = 44.0
//        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension FoodListHeaderTVC: CollapsibleTableSectionDelegate {
    
    func numberOfSections(_ tableView: UITableView) -> Int {
        return foodData.foodList.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell1 = self._tableView.dequeueReusableCell(withIdentifier: "ExpandedFoodCell") as! ExpandedFoodCell
        let cell2 = self._tableView.dequeueReusableCell(withIdentifier: "ExpandedDetailsCell") as! ExpandedDetailsCell
        let cell3 = self._tableView.dequeueReusableCell(withIdentifier: "EditPortionCell") as! EditPortionCell
        
        let foodItem = foodData.foodList[indexPath.row]
        
        cell1.initWithFood(protein: foodItem.protein, fat: foodItem.fat, carbonhydrates: foodItem.carbonhydrate)
        cell2.initWithFood(calories: foodItem.calories)
        cell3.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            return cell1
        case 1:
            return cell2
        case 2:
            return cell3
        default:
            break
        }
        
        return UITableViewCell()
 */
        
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomCell ??
            CustomCell(style: .default, reuseIdentifier: "Cell")
        
        let foodItem = foodData.foodList[indexPath.section]
        
        cell.nameLabel.text = String(describing: foodItem.protein!)
        cell.detailLabel.text = String(describing:foodItem.calories!)
        
        return cell
    }
    
    func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return foodData.foodList[section].name
    }
    
    func shouldCollapseByDefault(_ tableView: UITableView) -> Bool {
        return true
    }
    
}

