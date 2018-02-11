//
//  SearchExercisesVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 11.02.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import SwiftyJSON

class SearchExercisesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredExercises = [SearchExercise]()
    var searchQuery = ""
    let activityIndicator = ActivityIndicator()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.initIndicator("Loading", from: self)
        
        
        self.searchController.searchBar.backgroundColor = FoodColors.barBottomColor
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
                
                let parameters: Parameters = ["searchTitle":query]
                self.searchQuery = query
                
                self.activityIndicator.toggleActivity()
                Alamofire.request("\(API_URL)/exercise/find", parameters:parameters).responseJSON(completionHandler: { responce in
                    if let json = responce.result.value{
                        DispatchQueue.main.async {
                            if let resp = JSON(json).array{
                                self.filteredExercises = resp.flatMap({SearchExercise(json:$0)})
                            }
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension SearchExercisesVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredExercises.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredExercises[indexPath.row].title
        return cell
    }
}
