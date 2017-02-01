//
//  Networking.swift
//  On The Map
//
//  Created by Jason Southwell on 1/31/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import Foundation
import UIKit


extension LoginViewController {
    
    
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
    
    
    //    func logOutUser() {
    //
    //
    //        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
    //
    //        request.httpMethod = "DELETE"
    //
    //        var xsrfCookie: HTTPCookie? = nil
    //
    //        let sharedCookieStorage = HTTPCookieStorage.shared
    //
    //        for cookie in sharedCookieStorage.cookies! {
    //            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    //        }
    //
    //        if let xsrfCookie = xsrfCookie {
    //            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    //        }
    //
    //        let session = URLSession.shared
    //
    //        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    //            if error != nil {
    //
    //                print(error!)
    //
    //            }
    //
    //            guard data != nil else {
    //
    //                self.showAlertAsync(title: "Alert", message: "An error occured. Please confirm your details and try again.", buttonText: "OK")
    //
    //                print("Error: did not receive data")
    //
    //                return
    //            }
    //
    //            guard let newData = data!.subdata(in: Range(uncheckedBounds: (lower: data!.startIndex.advanced(by: 5), upper: data!.endIndex))) as Data? else {
    //
    //                print("Error: invalid range in data")
    //
    //                return
    //            }
    //            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
    //            
    //        })
    //        
    //        dataTask.resume()
    //        
    //    }
    
}
