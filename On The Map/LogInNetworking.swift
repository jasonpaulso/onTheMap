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
    
    
//    func logInUser(userName: String, password: String) {
//        
//        let headers = [
//            "accept": "application/json",
//            "content-type": "application/json"
//        ]
//        
//        let parameters = ["udacity": [
//            "username": userName,
//            "password": password
//            ]
//        ]
//        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
//        
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        
//        
//        let session = URLSession.shared
//        
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            
//            if error != nil {
//                
//                print(error!)
//                
//            }
//            
//            guard data != nil else {
//                
//                performUIUpdatesOnMain {
//                    
//                    self.showAlert(title: "Alert", message: "An error occured. Please confirm your details and try again.", buttonText: "OK")
//                    
//                    print("Error: did not receive data")
//                }
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
//            
//            guard let results = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject? else {
//                
//                print("Error: could not serialize data")
//                
//                return
//            }
//            
//            
//            guard (results!["error"] as? String) == nil else {
//                
//                performUIUpdatesOnMain {
//                    
//                    self.showAlert(title: "Alert", message: (results?["error"] as! String), buttonText: "Dismiss")
//                    
//                }
//                
//                return
//            }
//            
//            
//            guard let sessionData = results?["session"] as? [String: AnyObject] else {
//                
//                print("Error: could not parse data")
//                
//                print(results!)
//                
//                return
//            }
//            
//            
//            performUIUpdatesOnMain {
//                
//                if sessionData["id"] as? String != nil {
//                    
//                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
//                    
//                    self.present(viewController, animated: false, completion: nil)
//                    
//                } else  {
//                    
//                    print("Error: could not parse session ID")
//                    
//                    self.showAlert(title: "Alert", message: "There was a problem logging you in. Please try again.", buttonText: "OK")
//                    
//                    return
//                }
//            }
//            
//            
//        })
//        
//        if isInternetAvailable() {
//            
//            dataTask.resume()
//            
//        } else {
//            
//            performUIUpdatesOnMain {
//                
//                self.showAlert(title: "Alert", message: "No internet connection detected. Please connect and try again.", buttonText: "OK")
//                
//            }
//            
//            
//        }
//        
//        
//    }
    
    func parseData(newData: Data) -> AnyObject? {
        
        guard let results = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject? else {
            
            print("Error: could not serialize data")
            
            return ("Error: could not serialize data" as AnyObject?)
        }
        return results
        
    }
    
}



extension TabBarViewController: ShowsAlert {
    
        func logOutUser() {
    
            let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
    
            request.httpMethod = "DELETE"
    
            var xsrfCookie: HTTPCookie? = nil
    
            let sharedCookieStorage = HTTPCookieStorage.shared
    
            for cookie in sharedCookieStorage.cookies! {
                
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
                
            }
    
            if let xsrfCookie = xsrfCookie {
                
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
                
            }
    
            let session = URLSession.shared
    
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
    
                    print(error!)
    
                }
    
                guard data != nil else {
    
                    performUIUpdatesOnMain {
                        
                        self.showAlert(title: "Alert", message: "An error occured. Please confirm your details and try again.", buttonText: "OK")
                        
                        print("Error: did not receive data")
                    }
                    
                    return
                }
    
                guard let newData = data!.subdata(in: Range(uncheckedBounds: (lower: data!.startIndex.advanced(by: 5), upper: data!.endIndex))) as Data? else {
    
                    print("Error: invalid range in data")
    
                    return
                }
                
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
    
            })
            
            print("logging out")
            
            dataTask.resume()
            
        }

}

class OTMNetworkingClient: NSObject, ShowsAlert {
    
    func taskForLogin(_ userName: String, password: String, completionHandlerForLogin: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        func sendError(_ error: String) {
            
            print(error)
            
            let userInfo = [NSLocalizedDescriptionKey : error]
            
            completionHandlerForLogin(nil, NSError(domain: "taskForLogin", code: 1, userInfo: userInfo))
        }
        
        
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
            
            let errorResponse = ["error" : "An error occured. Please confirm your details and try again."] as AnyObject
            
            guard error == nil else {
                
                print(error!)
                
                completionHandlerForLogin(errorResponse, error as NSError?)
                
                return
                
            }
            
            guard data != nil else {
                
                completionHandlerForLogin(errorResponse, nil)
                
                return
            }
            
            guard let newData = data!.subdata(in: Range(uncheckedBounds: (lower: data!.startIndex.advanced(by: 5), upper: data!.endIndex))) as Data? else {
                
                print("Error: invalid range in data")
                
                completionHandlerForLogin(errorResponse, nil)
                
                return
            }
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForLogin)
    
            
        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            let error = ["error": "No internet connection detected. Please connect and try again."] as AnyObject
            
            print(error )
            
            completionHandlerForLogin(error, nil)
            
        }
        
        return dataTask
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var sessionData: AnyObject! = nil
        
        do {
            
            let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
  
            sessionData = parsedResult
            
        } catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            
            return
            
        }
        
        completionHandlerForConvertData(sessionData, nil)
    }
    
    
    class func sharedInstance() -> OTMNetworkingClient {
        
        struct Singleton {
            
            static var sharedInstance = OTMNetworkingClient()
            
        }
        
        return Singleton.sharedInstance
    }
    
}
