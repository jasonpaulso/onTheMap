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



