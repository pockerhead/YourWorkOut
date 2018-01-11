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

        self.caloriesLabel.text = "\(String(describing: calories)) Ккал."
        self.carbonhydratesLabel.text = "\(String(describing: carbonhydrate)) гр."
        self.fatsLabel.text = "\(String(describing: fat)) гр."
        self.proteinsLabel.text = "\(String(describing: protein)) гр."
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
