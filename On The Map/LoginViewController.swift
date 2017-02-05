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
            
            let _ = OTMNetworkingClient.sharedInstance().taskForLogin(usernameField.text!, password: passwordField.text!, completionHandlerForLogin: { (response, error) in
                
                if error == nil {
                    
                    performUIUpdatesOnMain {
                        
                        guard (response?["error"] as? String) == nil else {
                            
                            performUIUpdatesOnMain {
                                
                                self.showAlert(title: "Alert", message: (response?["error"] as! String), buttonText: "Dismiss")
                                
                            }
                            
                            return
                        }
                        
                        
                        guard let sessionData = response?["session"] as? [String: AnyObject] else {
                            
                            print("Error: could not parse data")
                            
                            print(response!)
                            
                            return
                        }
                        
                        guard sessionData["id"] as? String != nil else {
                            
                            self.showAlert(title: "Alert", message: "There was a problem logging you in. Please try again.", buttonText: "OK")
                            
                            return
                        }
                        
                        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                        
                        self.present(viewController, animated: false, completion: nil)
                        
                    }
                    
                } else {
                    
                    performUIUpdatesOnMain {
                        
                        self.showAlert(title: "Alert", message: "There was a problem logging you in. Please try again.", buttonText: "OK")
                        
                        print(error as Any)
                        
                    }
                    
                }
                
                
            
            })
            
        } else if !isUserEmailValid {
            
            print("invalid email address")
            
            self.showAlert(title: "Alert", message: "Email address is not valid", buttonText: "OK")

        } else if !isUserPasswordValid {
            
            print("invalid password")
            self.showAlert(title: "Alert", message: "Please enter a password", buttonText: "OK")
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkField(sender: AnyObject.self as AnyObject)
        
    }
    
    private func checkField(sender: AnyObject) {
        
        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            
            submitButton.isEnabled = false
            
        } else {
            
            submitButton.isEnabled = true
        }
        
    }
    


}



