//
//  FoodMenuTVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 15.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class FoodMenuTVC: UITableViewController {
   
    @IBOutlet weak var profileButton: UIButton!
    var keychain = Keychain()
    var menu = [
        ["title":"Сегодня",
         "segue":"toToday"
        ],
        ["title":"Журнал",
         "segue":"toJournal"
        ],
        ["title":"Замеры и статистика",
         "segue":"toStatistics"
        ],
        ["title":"Выйти",
         "segue":"toLogin"
        ],
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = FoodColors.barColor
        
        initProfileButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    func initProfileButton(){
        let username : String = self.keychain.getPasscode(identifier: "MPUsername")! as String
        let imageUrl = URL(string: "\(API_URL)/public/\(username)/profile-image.jpeg")
        var result = UIImage()
        DispatchQueue.global(qos: .background).async{
            // do some task
            let imageData = NSData(contentsOf: imageUrl!)
            
            DispatchQueue.main.async {
                // update some UI
                let image : UIImage
                if let data = imageData {
                    image = (UIImage(data: data as Data)?.circleMasked!)!
                } else {
                    image = UIImage()//.circleMasked!
                }
                result = image
                self.profileButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
                self.profileButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                self.profileButton.setBackgroundImage(result, for: .normal)
                self.profileButton.setTitle("", for: .normal)
            }
        }
        
    }
    
    @IBAction func profileButtonWasPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toProfileVC", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = menu[indexPath.row]["title"]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: menu[indexPath.row]["segue"]!, sender: self)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLogin"{
            self.keychain.setPasscode(identifier: "MPPassword", passcode: "")
            self.keychain.setPasscode(identifier: "MPUsername", passcode: "")
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
