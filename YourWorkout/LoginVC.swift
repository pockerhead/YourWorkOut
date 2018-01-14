//
//  LoginVC.swift
//  YourWorkout
//
//  Created by Артём Балашов on 14.01.2018.
//  Copyright © 2018 Артём Балашов. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation

class LoginVC: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    var loggedIn = false;
    let keychain = Keychain()
    var userData = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.addSocketHandlers()
        self.loggedIn = false;
        self.hideKeyboardWhenTappedAround()
        //comment below to force login
        guard let username = self.keychain.getPasscode(identifier: "MPPassword") else {
            return
        }
        guard let password = self.keychain.getPasscode(identifier: "MPUsername") else {
            return
        }
//        if(username != "" && password != ""){
//            self.loginRequestWithParams(usernameString: self.keychain.getPasscode(identifier: "MPUsername")! as String, passwordString: self.keychain.getPasscode(identifier: "MPPassword")! as String)
//        }
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    func addSocketHandlers(){
        // Our socket handlers go here
        
    }
    func loginRequestWithParams(usernameString : String, passwordString : String){
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let usernameStr = "username=" + usernameString
        let passwordStr = "&password=" + passwordString
        let postData = NSMutableData(data: usernameStr.data(using: String.Encoding.utf8)!)
        
        postData.append(passwordStr.data(using: String.Encoding.utf8)!)
        
        var request = URLRequest(url: NSURL(string: "http://192.168.1.41:3000/login")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            data,response,error in
            if (error != nil) {
                print(error ?? "err")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                
                if (httpResponse?.statusCode == 200){
                    
                        //segue to main view.
                    if(self.keychain.getPasscode(identifier: "MPPassword") == "" || self.keychain.getPasscode(identifier: "MPUsername") == ""){
                        self.keychain.setPasscode(identifier: "MPPassword", passcode: passwordString)
                        self.keychain.setPasscode(identifier: "MPUsername", passcode: usernameString)
                        }
                        if (self.loggedIn == false){
                            self.performSegue(withIdentifier: "LoginSegue", sender: self)
                            // use anyObj here
                            self.loggedIn = true;
                        }else{
                            
                        }
                    
                }else{
                    print("error")
                }
                if let undata = data{
                    let json = try? JSONSerialization.jsonObject(with: undata, options: []) as! [String:Any]
                    let alertView = UIAlertController(title: "Ошибка", message: json!["SERVER_MESSAGE"]! as? String, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertView.addAction(OK)
                    self.present(alertView, animated: true, completion: nil);
                }
                
                
            }
        })
        
        dataTask.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        if (self.username.text == "" || self.password.text == ""){
            let alertView = UIAlertController(title: "UWOTM8", message: "Fam, what you tryna pull?", preferredStyle: .alert)
            let OK = UIAlertAction(title: "Is it 2 l8 2 say sorry", style: .default, handler: nil)
            alertView.addAction(OK)
            self.present(alertView, animated: true, completion: nil);
            return;
        }
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        self.loginRequestWithParams(usernameString: self.username.text!, passwordString: self.password.text!)
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
