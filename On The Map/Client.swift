//
//  Networking.swift
//  On The Map
//
//  Created by Jason Southwell on 1/31/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import Foundation
import UIKit

class OTMNetworkingClient: NSObject {
    
    
//    var students = Students.sharedInstance().arrayOfStudents
    let studentSharedInstance = Students.shared

    func taskForLogin(_ userName: String, password: String, completionHandlerForLogin: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
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
        
    }
    
    func taskForLogout(_ completionHandlerForLogout: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
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
            
            let responseError = ["error": "Could not log you out. Please try again later."] as AnyObject
            
            if error != nil {
                
                print(error!)
                
                completionHandlerForLogout(responseError, error as NSError?)
                
            }
            
            guard data != nil else {
                
                print(error!)
                
                completionHandlerForLogout(responseError, nil)
                
                return
            }
            
            guard let newData = data!.subdata(in: Range(uncheckedBounds: (lower: data!.startIndex.advanced(by: 5), upper: data!.endIndex))) as Data? else {
                
                print("problem with subsetting data")
                
                completionHandlerForLogout(responseError, nil)
                
                return
            }
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
        })
        
        print("logging out")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.showSelectedStudentOnMap = false
        appDelegate.selectedStudentCoordinates = (nil,nil)
        
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            let error = ["error": "No internet connection detected. Please connect and try again."] as AnyObject
                        
            completionHandlerForLogout(error, nil)
            
        }
        
        
    }
    
    func taskForDetailsPost(_ parameters: [String : Any], completionHandlerForDetailsPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
            "Content-Type": "application/json"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")! as URL)
        
        request.allHTTPHeaderFields = headers
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpMethod = "POST"
        
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
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForDetailsPost)
            
        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            let errorResponse = ["error": "No internet connection detected. Please connect and try again."] as AnyObject
            
            completionHandlerForDetailsPost(errorResponse, nil)
        
            
        }

    
    }

        
    func getStudentLocationsFromUdacity(completionHandlerForGetLocations: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")! as URL)
        
        request.allHTTPHeaderFields = headers
        
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
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: {response, error in
            
                completionHandlerForGetLocations(response, error as NSError?)
            
            })

            
        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
        
            
        } else {
            
            let errorResponse = ["error": "No internet connection detected. Please connect and try again."]  as AnyObject?
            
            completionHandlerForGetLocations(errorResponse, nil)
            
            
        }
        
    }

    
    func taskForGetCurrentUserDataFromUdacity(completionHandlerForUserDataFromUdacity: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        
        let url = NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation/")
        
        let userKey = studentSharedInstance.currentUserStudentKey!
        
        let newURL = NSURL(string: "?where=%7B%22uniqueKey%22%3A%22\(userKey)%22%7D", relativeTo: url as URL?)!
        
        let request = NSMutableURLRequest(url: newURL as URL)
        
        request.allHTTPHeaderFields = headers
        
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
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: {response, error in
                
                completionHandlerForUserDataFromUdacity(response, error)
                
            })
            

        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
            
        } else {
            
            let errorResponse = ["error": "No internet connection detected. Please connect and try again."]  as AnyObject?
            
            print(errorResponse!)
            
            completionHandlerForUserDataFromUdacity(errorResponse, nil)

        }
        
    }
    
    func loadStudentDetails(completionHandlerForLoadStudentDetails: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        studentSharedInstance.arrayOfStudents.removeAll()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        LoadingOverlay.shared.showOverlay()
        
        self.getStudentLocationsFromUdacity(completionHandlerForGetLocations: { (response, error) -> Void in
            
            if response == nil {
                return
            }
            
            if error != nil {
                return
            }
            
            if let studentResults = response!["results"] as? [[String:AnyObject]] {
                
                for student in studentResults {
                    
                    if student["firstName"] != nil {
                        
                        _ = StudentDetails.init(dictionary: student, studentsArray: &self.studentSharedInstance.arrayOfStudents)
                        
                    }
                }
                
                performUIUpdatesOnMain {
                    
                    completionHandlerForLoadStudentDetails(nil, nil)
                    
                }
                
                
            } else if let errorResponse = response!["error"] as? String {
                
                
                completionHandlerForLoadStudentDetails(errorResponse, nil)
                
                
            }
            
            
            
        })
        
    }
    
    
    
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var sessionData: AnyObject! = nil
                
        do { let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
  
            sessionData = parsedResult
            
        } catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            
            return
            
        }
        
        completionHandlerForConvertData(sessionData, nil)
    }
    
    class var shared: OTMNetworkingClient {
        
        struct Static {
            
            static let instance: OTMNetworkingClient = OTMNetworkingClient()
            
        }
        
        return Static.instance
    }

    

    
}
