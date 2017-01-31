//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 1/24/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate, ShowsAlert {

    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func getUserInfo(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        usernameField.delegate = self
        passwordField.delegate = self
        submitButton.isEnabled = false
        super.viewDidLoad()
        
        
    }
    
    // Mark: Credential Input
    
    @IBAction func submitUserCredentials(_ sender: Any) {
        
        let isUserEmailValid = isValidUserEmail(usernameString: usernameField.text!)
        
        let isUserPasswordValid = isValidUserPassword(userPassword: passwordField.text!)
        
        if isUserEmailValid && isUserPasswordValid {
            
            print("valid email address")
            
            logInUser(userName: usernameField.text!, password: passwordField.text!)
            
        } else if !isUserEmailValid {
            
            print("invalid email address")
            
            self.showAlertAsync(title: "Alert", message: "Email address is not valid", buttonText: "OK")

            
            
        } else if !isUserPasswordValid {
            
            print("invalid password")
            self.showAlertAsync(title: "Alert", message: "Please enter a password", buttonText: "OK")
            
        }
        
    }

    
    func checkField(sender: AnyObject) {
        
        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            
            submitButton.isEnabled = false
            
        } else {
            
            submitButton.isEnabled = true
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkField(sender: AnyObject.self as AnyObject)
        
    }
    
    
    // Mark: Login Networking
    
    func logInUser(userName: String, password: String) {
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        let parameters = ["udacity": [
            "username": userName,
            "password": password
            ]
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                
                print(error!)
                
            }
            
            guard data != nil else {
                
                self.showAlertAsync(title: "Alert", message: "An error occured. Please confirm your details and try again.", buttonText: "OK")
                
                print("Error: did not receive data")
                
                return
            }
            
            guard let newData = data!.subdata(in: Range(uncheckedBounds: (lower: data!.startIndex.advanced(by: 5), upper: data!.endIndex))) as Data? else {
                
                print("Error: invalid range in data")
                
                return
            }
            
            guard let results = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject? else {
                
                print("Error: could not serialize data")
                
                return
            }
            
            
            guard (results!["error"] as? String) == nil else {
                
                self.showAlertAsync(title: "Alert", message: (results?["error"] as! String), buttonText: "Dismiss")
                
                return
            }
            
            
            guard let sessionData = results?["session"] as? [String: AnyObject] else {
                
                print("Error: could not parse data")
                
                print(results!)
                
                return
            }
            
            DispatchQueue.main.async {
                
                if sessionData["id"] as? String != nil {
                    
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                    
                    self.present(viewController, animated: false, completion: nil)
                    
                } else  {
                    
                    print("Error: could not parse session ID")
                    
                    self.showAlertAsync(title: "Alert", message: "There was a problem logging you in. Please try again.", buttonText: "OK")

                    
                    return
                }
            }
            
            
        })

        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            showAlertAsync(title: "Alert", message: "No internet connection detected. Please connect and try again.", buttonText: "OK")
            
        }
        
        
    }

    
}



