//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 1/24/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
     // Mark: Develeopment Credentials
    
    
    
    
    override func viewDidLoad() {
        
        usernameField.delegate = self
        passwordField.delegate = self
        submitButton.isEnabled = true
        submitButton.layer.cornerRadius = 15
        submitButton.clipsToBounds = true

        super.viewDidLoad()
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        UIApplication.shared.open(NSURL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")! as URL, options: [:], completionHandler: nil)
    }
    
    
    // Mark: Credential Input
    
    @IBAction func submitUserCredentials(_ sender: Any) {
        
        let isUserEmailValid = isValidUserEmail(usernameString: usernameField.text!)
        let isUserPasswordValid = isValidString(string: passwordField.text!)
        
        if isUserEmailValid && isUserPasswordValid {
            
            print("valid email address")
            loginUser()
            
        } else if !isUserEmailValid {
            
            print("invalid email address")
            self.showAlert(title: "Alert", message: "Email address is not valid", buttonText: "OK")

        } else if !isUserPasswordValid {
            
            print("invalid password")
            self.showAlert(title: "Alert", message: "Please enter a password", buttonText: "OK")
            
        }
        
    }
    
    func loginUser() {
        
        LoadingOverlay.shared.showOverlay()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let _ = OTMNetworkingClient.sharedInstance().taskForLogin(usernameField.text!, password: passwordField.text!, completionHandlerForLogin: { (response, error) in
            
            if error == nil {
                
                performUIUpdatesOnMain {
                    
                    guard (response?["error"] as? String) == nil else {
                        
                        performUIUpdatesOnMain {
                            
                            self.showAlert(title: "Alert", message: (response?["error"] as! String), buttonText: "Dismiss")
                            
                        }
                        
                        return
                    }
                    
                    guard let accountData = response?["account"] as! [String:Any]? else {
                        
                        print("could not parse account details")
                        return
                    }
                    
                    guard let accountKey = accountData["key"] as! String? else {
                        
                        print("could not parse unique key from account details")
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
                    
                    Students.sharedInstance().currentUserStudentKey = accountKey
                    
                    self.getCurrentUserDetails(accountKey: Students.sharedInstance().currentUserStudentKey!)
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
            
                    LoadingOverlay.shared.hideOverlayView()
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    self.present(viewController, animated: true, completion: nil)
                    
                }
                
            } else {
                
                performUIUpdatesOnMain {
                    
                    self.showAlert(title: "Alert", message: "There was a problem logging you in. Please try again.", buttonText: "OK")
                    
                    print(error as Any)
                    
                }
                
            }
            
        })

    }
    
    func getCurrentUserDetails(accountKey: String) {
        
        OTMNetworkingClient.sharedInstance().taskForGetCurrentUserDataFromUdacity(completionHandlerForUserDataFromUdacity: {response, error in
            
            if error == nil {
                
                if let currentStudentResult = response?["results"] as? [[String: Any]] {
                    
                    let currentStudent = currentStudentResult[0]
                    
                    Students.sharedInstance().currentUserStudent = StudentDetails.init(dictionary: currentStudent as [String : AnyObject])
                    
                    return
                    
                } else if let error = response?["error"] as? String {
                    
                    self.showAlert(title: "Alert", message: error, buttonText: "OK")
                    
                    return
                }
                
            } else {
                
                print(error!)
                
                performUIUpdatesOnMain {
                    
                    self.showAlert(title: "Alert", message: "There was a problem retrieving your information. Please log out and bacdk in.", buttonText: "OK")
                    
                    print(error as Any)
                    
                    return
                    
                }
                
            }
            
        })
        
    }
    
    private func checkField(sender: AnyObject) {
        
        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            
            submitButton.isEnabled = false
            
        } else {
            
            submitButton.isEnabled = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
 
    
    


}



