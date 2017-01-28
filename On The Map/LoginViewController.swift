//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 1/24/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func getUserInfo(_ sender: Any) {
        getUserDataFromUdacity()
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
            
            displayAlertMessage(messageToDisplay: "Email address is not valid")
            
        } else if !isUserPasswordValid {
            
            print("invalid password")
            
            displayAlertMessage(messageToDisplay: "Please enter a password")
            
        }
        
    }
    
    func isValidUserPassword(userPassword: String) -> Bool {
        
        var returnValue = true
        
        let whitespace = NSCharacterSet.whitespaces
        
        if ((passwordField.text?.trimmingCharacters(in: whitespace)) == "") {
            
            returnValue = false
        
        }
        
        return returnValue
    }
    
    func isValidUserEmail(usernameString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = usernameString as NSString
            let results = regex.matches(in: usernameString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // OK button tapped

        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
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
                
            } else {
                
                let httpResponse = response as? HTTPURLResponse
                
                print(httpResponse!)
            }
            
            guard data != nil else {
                
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
            
            guard let sessionData = results?["session"] as? [String: AnyObject] else {
                
                print("Error: could not parse data")
                print(results!)
                
                return
            }
            
//            if let _ = sessionData["status"] as? Int == 403
            
            print("Results: \(results)")
            
            DispatchQueue.main.async {
                
                if sessionData["id"] as? String != nil {
                    
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                    
                    self.present(viewController, animated: false, completion: nil)
                    
                } else  {
                    
                    print("Error: could not parse session ID")
                    
                    return
                }
                
            }
            
            
        })
        
        dataTask.resume()
        
    }
    
    func getUserDataFromUdacity() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/3903878747")! as URL)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                let httpResponse = response as? HTTPURLResponse
                
                print(httpResponse!)
            }
            
            guard data != nil else {
                
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
            
            print(results!)
            
        })
        
        dataTask.resume()
    }
    
    
    
    
    
    
}

