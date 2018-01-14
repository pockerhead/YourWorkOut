//
//  RegistrationVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 14.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    let keychain = Keychain()
    var reg = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: UIButton) {
        print("register")
        name.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
        email.resignFirstResponder()
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let usernameString = "username=" + self.username.text!
        let passwordString = "&password=" + self.password.text!
        let emailString = "&email=" + self.email.text!
        let nameString = "&name=" + self.name.text!
        let postData = NSMutableData(data: usernameString.data(using: String.Encoding.utf8)!)
        postData.append(passwordString.data(using: String.Encoding.utf8)!)
        postData.append(emailString.data(using: String.Encoding.utf8)!)
        postData.append(nameString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.1.41:3000/signup")! as URL,
                                   cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error  in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                
                if (httpResponse?.statusCode == 200){
                    DispatchQueue.main.async { // Correct
                        //segue to main view, etc.
                        if(self.reg == false){
                            self.keychain.setPasscode(identifier: "MPPassword", passcode: self.password.text!)
                            self.keychain.setPasscode(identifier: "MPUsername", passcode: self.username.text!)
                            self.performSegue(withIdentifier: "LogSeg", sender: self)
                            self.reg = true
                        }
                    }
                    
                        
                    
                }else{
                    print("error")
                }
                // use anyObj here
                print("json error: \(String(describing: error))")
            }
        })
        
        dataTask.resume()
        
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
