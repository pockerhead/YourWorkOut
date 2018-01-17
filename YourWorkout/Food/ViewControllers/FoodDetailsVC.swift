//
//  FoodDetailsVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 11.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class FoodDetailsVC: UIViewController {
    var protein = Float()
    var carbonhydrate = Float()
    var calories = Float()
    var fat = Float()
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbonhydratesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelsArray = [self.caloriesLabel,self.carbonhydratesLabel,self.fatsLabel,self.proteinsLabel]
        self.caloriesLabel.text = "\(String(describing: calories)) Ккал."
        self.carbonhydratesLabel.text = "\(String(describing: carbonhydrate)) гр."
        self.fatsLabel.text = "\(String(describing: fat)) гр."
        self.proteinsLabel.text = "\(String(describing: protein)) гр."
        for label in labelsArray{
            label?.sizeToFit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initWithFoodData(data:FoodModel){
        self.navigationItem.title = data.name
        self.protein = data.protein!
        self.carbonhydrate = data.carbonhydrate!
        self.fat = data.fat!
        self.calories = data.calories!
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
