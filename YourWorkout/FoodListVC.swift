//
//  FoodListVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 08.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import ExpandableCell


class FoodListVC: UIViewController {
    
    @IBOutlet weak var tableView: ExpandableTableView!
    var foodData = FoodListModel.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFood = [FoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.expandableDelegate = self
        tableView.animation = .automatic
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnSearchBar))
        searchController.searchBar.addGestureRecognizer(tap)
        //Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        let cellNib = UINib(nibName: "FoodItemCell", bundle: nil)
        let expandedCellNib = UINib(nibName: "ExpandedFoodCell", bundle: nil)
        let expandedDetailCellNib = UINib(nibName: "ExpandedDetailsCell", bundle: nil)
        let epandedEditPortionCellNib = UINib(nibName: "EditPortionCell", bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: "FoodItemCell")
        tableView.register(expandedCellNib, forCellReuseIdentifier: "ExpandedFoodCell")
        tableView.register(expandedDetailCellNib, forCellReuseIdentifier: "ExpandedDetailsCell")
        tableView.register(epandedEditPortionCellNib, forCellReuseIdentifier: "EditPortionCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    @objc func keyBoardWillShow(notification: NSNotification) {
        tableView.closeAll()
    }
    
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        //handle dismiss of keyboard here
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchController.searchBar.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //    // MARK: - Search
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
        tableView.reloadData()

    }
    @objc func tapOnSearchBar(){
        self.tableView.closeAll()
    }
    
    
}
extension FoodListVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension FoodListVC: ExpandableDelegate{
    
    // MARK: - ExpandableDelegate methods
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "ExpandedFoodCell") as! ExpandedFoodCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "ExpandedDetailsCell") as! ExpandedDetailsCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "EditPortionCell") as! EditPortionCell
        
        let foodItem : FoodModel
        
        foodItem = foodData.foodList[indexPath.row]
        
        
        cell1.proteinsLabel.text = String(describing: foodItem.protein!)
        cell1.fatsLabel.text = String(describing: foodItem.fat!)
        cell1.uglevodsLabel.text = String(describing: foodItem.carbonhydrate!)
        cell1.selectionStyle = .none
        
        cell2.caloriesLabel.text = String(describing: foodItem.calories!)
        cell2.selectionStyle = .none
        
        return [cell1,cell2,cell3]
        
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        
        return [44,44,44]
        
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredFood.count
        } else {
            return foodData.foodList.count
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
//        self.searchController.isActive = false
        //                tableView.closeAll()
        self.searchController.searchBar.endEditing(true)
        
        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
//        self.searchController.isActive = false

        self.searchController.searchBar.endEditing(true)
        
        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    //    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
    //        if let cell = expandedCell as? ExpandedCell {
    //            print("\(cell.titleLabel.text ?? "")")
    //        }
    //    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell") as! FoodItemCell
        let foodItem : FoodModel
        print("IndexPath =>\(indexPath.row) and FiltFoodCount => \(filteredFood.count)")
        if isFiltering() {
            if indexPath.row < filteredFood.count {
                foodItem = filteredFood[indexPath.row]
            } else {
                return UITableViewCell()
            }
           
        } else {
            foodItem = foodData.foodList[indexPath.row]
        }
        //            foodItem = foodData.foodList[indexPath.row]
        
        
        cell.foodName.text = "\(String(describing: foodItem.name!))"
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        cell?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        //        let cell = expandableTableView.cellForRow(at: indexPath)
        //        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //        cell?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    //        func expandableTableView(_ expandableTableView: ExpandableTableView, titleForHeaderInSection section: Int) -> String? {
    //            return "Section \(section)"
    //        }
    //
    //        func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
    //            return 33
    //        }
    
    
}

