//
//  ProfileVC.swift
//  YourWorkout
//
//  Created by Artem Balashow on 24.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!
    let keychain = Keychain()
    let userPath = [
        [
            "name":"Имя"
        ],
        [
            "name":"Описание"
        ],
        [
            "name":"Логин"
        ],
        [
            "name":"Пароль"
        ],
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProfileButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    image = UIImage().circleMasked!
                }
                result = image
//                self.profileImageButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
//                self.profileImageButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                self.profileImageButton.setBackgroundImage(result, for: .normal)
                self.profileImageButton.setTitle("", for: .normal)
            }
        }
        
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
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userPath.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userPath[section]["name"]
    }
}
