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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func submitUserCredentials(_ sender: Any) {

        logInUser(userName: usernameField.text!, password: passwordField.text!)

    }

    
    func logInUser(userName: String, password: String) {
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        let parameters = ["udacity": [
            "username": userName,
            "password": password
            ]]
        
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
            
            do {
                var sessionData:AnyObject?

                let range = Range(uncheckedBounds: (5, (data?.count)! - 5))

                let newData = data?.subdata(in: range)

                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)

                sessionData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject

                print(sessionData!)

                return

            } catch  {
                
                print("2: error trying to convert data to JSON", error.localizedDescription)
                
                return
            }
            
        })
        
        dataTask.resume()
    }

    

    

}

