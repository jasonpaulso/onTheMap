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
        
        let httpBody = ["udacity" :
            [
                "username" : userName,
                "password" : password
            ]
        ]
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
       
            guard error == nil else {
                
                print("error POSTing to api/session")
                
                print(error!.localizedDescription)
                
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
   
            do {
                let range = Range(uncheckedBounds: (5, responseData.count - 5))
                
                let newData = responseData.subdata(in: range)
                
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
                
                guard let sessionData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject? else {
                    
                        print("1: error trying to convert data to JSON")
                    
                        return
                    
                }

                print(sessionData)
                
                return
                
            } catch  {
                
                print("2: error trying to convert data to JSON", error.localizedDescription)
                
                return
            }
        })
        
        task.resume()
    }
    

    

    

}

